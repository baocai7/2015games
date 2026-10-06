local UIScrollView = import(".UIScrollView")
local UIListView = class("UIListView", UIScrollView)
local UIListViewItem = import(".UIListViewItem")
UIListView.DELEGATE = "ListView_delegate"
UIListView.TOUCH_DELEGATE = "ListView_Touch_delegate"
UIListView.CELL_TAG = "Cell"
UIListView.CELL_SIZE_TAG = "CellSize"
UIListView.COUNT_TAG = "Count"
UIListView.CLICKED_TAG = "Clicked"
UIListView.UNLOAD_CELL_TAG = "UnloadCell"
UIListView.BG_ZORDER = -1
UIListView.CONTENT_ZORDER = 10
UIListView.ALIGNMENT_LEFT = 0
UIListView.ALIGNMENT_RIGHT = 1
UIListView.ALIGNMENT_VCENTER = 2
UIListView.ALIGNMENT_TOP = 3
UIListView.ALIGNMENT_BOTTOM = 4
UIListView.ALIGNMENT_HCENTER = 5

function UIListView:ctor(params)
  UIListView.super.ctor(self, params)
  self.items_ = {}
  self.direction = params.direction or UIScrollView.DIRECTION_VERTICAL
  self.alignment = params.alignment or UIListView.ALIGNMENT_VCENTER
  self.bAsyncLoad = params.async or false
  self.container = cc.Node:create()
  self:setDirection(params.direction)
  self:setViewRect(params.viewRect)
  self:addScrollNode(self.container)
  self:onScroll(handler(self, self.scrollListener))
  self.size = {}
  self.itemsFree_ = {}
  self.delegate_ = {}
  self.redundancyViewVal = 0
end

function UIListView:onCleanup()
  self:releaseAllFreeItems_()
end

function UIListView:onTouch(listener)
  self.touchListener_ = listener
  return self
end

function UIListView:setAlignment(align)
  self.alignment = align
end

function UIListView:newItem(item)
  item = UIListViewItem.new(item)
  item:setDirction(self.direction)
  item:onSizeChange(handler(self, self.itemSizeChangeListener))
  return item
end

function UIListView:setViewRect(viewRect)
  if UIScrollView.DIRECTION_VERTICAL == self.direction then
    self.redundancyViewVal = viewRect.height
  else
    self.redundancyViewVal = viewRect.width
  end
  UIListView.super.setViewRect(self, viewRect)
end

function UIListView:itemSizeChangeListener(listItem, newSize, oldSize)
  local pos = self:getItemPos(listItem)
  if not pos then
    return
  end
  local itemW, itemH = newSize.width - oldSize.width, newSize.height - oldSize.height
  if UIScrollView.DIRECTION_VERTICAL == self.direction then
    itemW = 0
  else
    itemH = 0
  end
  local content = listItem:getContent()
  transition.moveBy(content, {
    x = itemW / 2,
    y = itemH / 2,
    time = 0.2
  })
  self.size.width = self.size.width + itemW
  self.size.height = self.size.height + itemH
  if UIScrollView.DIRECTION_VERTICAL == self.direction then
    transition.moveBy(self.container, {
      x = -itemW,
      y = -itemH,
      time = 0.2
    })
    self:moveItems(1, pos - 1, itemW, itemH, true)
  else
    self:moveItems(pos + 1, table.nums(self.items_), itemW, itemH, true)
  end
end

function UIListView:scrollListener(event)
  if "began" == event.name then
    local nodePoint = self.container:convertToNodeSpace(cc.p(event.x, event.y))
    local pos, idx
    if self.bAsyncLoad then
      local itemRect
      for i, v in ipairs(self.items_) do
        local posX, posY = v:getPosition()
        local itemW, itemH = v:getItemSize()
        itemRect = cc.rect(posX, posY, itemW, itemH)
        if cc.rectContainsPoint(itemRect, nodePoint) then
          idx = v.idx_
          pos = i
          break
        end
      end
    else
      nodePoint.x = nodePoint.x - self.viewRect_.x
      nodePoint.y = nodePoint.y - self.viewRect_.y
      local width, height = 0, self.size.height
      local itemW, itemH = 0, 0
      if UIScrollView.DIRECTION_VERTICAL == self.direction then
        for i, v in ipairs(self.items_) do
          itemW, itemH = v:getItemSize()
          if height > nodePoint.y and nodePoint.y > height - itemH then
            pos = i
            idx = pos
            nodePoint.y = nodePoint.y - (height - itemH)
            break
          end
          height = height - itemH
        end
      else
        for i, v in ipairs(self.items_) do
          itemW, itemH = v:getItemSize()
          if width < nodePoint.x and nodePoint.x < width + itemW then
            pos = i
            idx = pos
            break
          end
          width = width + itemW
        end
      end
    end
    event.scrollView = nil
    event.listView = self
    event.itemPos = idx
    event.item = self.items_[pos]
    event.point = nodePoint
    self:notifyListener_(event)
  elseif "clicked" == event.name then
    local nodePoint = self.container:convertToNodeSpace(cc.p(event.x, event.y))
    local pos, idx
    if self.bAsyncLoad then
      local itemRect
      for i, v in ipairs(self.items_) do
        local posX, posY = v:getPosition()
        local itemW, itemH = v:getItemSize()
        itemRect = cc.rect(posX, posY, itemW, itemH)
        if cc.rectContainsPoint(itemRect, nodePoint) then
          idx = v.idx_
          pos = i
          break
        end
      end
    else
      nodePoint.x = nodePoint.x - self.viewRect_.x
      nodePoint.y = nodePoint.y - self.viewRect_.y
      local width, height = 0, self.size.height
      local itemW, itemH = 0, 0
      if UIScrollView.DIRECTION_VERTICAL == self.direction then
        for i, v in ipairs(self.items_) do
          itemW, itemH = v:getItemSize()
          if height > nodePoint.y and nodePoint.y > height - itemH then
            pos = i
            idx = pos
            nodePoint.y = nodePoint.y - (height - itemH)
            break
          end
          height = height - itemH
        end
      else
        for i, v in ipairs(self.items_) do
          itemW, itemH = v:getItemSize()
          if width < nodePoint.x and nodePoint.x < width + itemW then
            pos = i
            idx = pos
            break
          end
          width = width + itemW
        end
      end
    end
    self:notifyListener_({
      name = "clicked",
      listView = self,
      itemPos = idx,
      item = self.items_[pos],
      point = nodePoint
    })
  else
    event.scrollView = nil
    event.listView = self
    self:notifyListener_(event)
  end
end

function UIListView:addItem(listItem, pos)
  self:modifyItemSizeIf_(listItem)
  if pos then
    table.insert(self.items_, pos, listItem)
  else
    table.insert(self.items_, listItem)
  end
  self.container:addChild(listItem)
  return self
end

function UIListView:removeItem(listItem, bAni)
  assert(not self.bAsyncLoad, "UIListView:removeItem() - syncload not support remove")
  local itemW, itemH = listItem:getItemSize()
  self.container:removeChild(listItem)
  local pos = self:getItemPos(listItem)
  if pos then
    table.remove(self.items_, pos)
  end
  if UIScrollView.DIRECTION_VERTICAL == self.direction then
    itemW = 0
  else
    itemH = 0
  end
  self.size.width = self.size.width - itemW
  self.size.height = self.size.height - itemH
  if 0 == table.nums(self.items_) then
    return
  end
  if UIScrollView.DIRECTION_VERTICAL == self.direction then
    self:moveItems(1, pos - 1, -itemW, -itemH, bAni)
  else
    self:moveItems(pos, table.nums(self.items_), -itemW, -itemH, bAni)
  end
  return self
end

function UIListView:removeAllItems()
  self.container:removeAllChildren()
  self.items_ = {}
  return self
end

function UIListView:getItemPos(listItem)
  for i, v in ipairs(self.items_) do
    if v == listItem then
      return i
    end
  end
end

function UIListView:isItemInViewRect(pos)
  local item
  if "number" == type(pos) then
    item = self.items_[pos]
  elseif "userdata" == type(pos) then
    item = pos
  end
  if not item then
    return
  end
  local bound = item:getBoundingBox()
  local nodePoint = self.container:convertToWorldSpace(cc.p(bound.x, bound.y))
  bound.x = nodePoint.x
  bound.y = nodePoint.y
  return cc.rectIntersectsRect(self.viewRect_, bound)
end

function UIListView:reload()
  if self.bAsyncLoad then
    self:asyncLoad_()
  else
    self:layout_()
  end
  return self
end

function UIListView:dequeueItem()
  if #self.itemsFree_ < 1 then
    return
  end
  local item
  item = table.remove(self.itemsFree_, 1)
  item.bFromFreeQueue_ = true
  return item
end

function UIListView:layout_()
  local width, height = 0, 0
  local itemW, itemH = 0, 0
  local margin
  if UIScrollView.DIRECTION_VERTICAL == self.direction then
    width = self.viewRect_.width
    for i, v in ipairs(self.items_) do
      itemW, itemH = v:getItemSize()
      itemW = itemW or 0
      itemH = itemH or 0
      height = height + itemH
    end
  else
    height = self.viewRect_.height
    for i, v in ipairs(self.items_) do
      itemW, itemH = v:getItemSize()
      itemW = itemW or 0
      itemH = itemH or 0
      width = width + itemW
    end
  end
  self:setActualRect({
    x = self.viewRect_.x,
    y = self.viewRect_.y,
    width = width,
    height = height
  })
  self.size.width = width
  self.size.height = height
  local tempWidth, tempHeight = width, height
  if UIScrollView.DIRECTION_VERTICAL == self.direction then
    itemW, itemH = 0, 0
    local content
    for i, v in ipairs(self.items_) do
      itemW, itemH = v:getItemSize()
      itemW = itemW or 0
      itemH = itemH or 0
      tempHeight = tempHeight - itemH
      content = v:getContent()
      content:setAnchorPoint(0.5, 0.5)
      self:setPositionByAlignment_(content, itemW, itemH, v:getMargin())
      v:setPosition(self.viewRect_.x, self.viewRect_.y + tempHeight)
    end
  else
    itemW, itemH = 0, 0
    tempWidth = 0
    for i, v in ipairs(self.items_) do
      itemW, itemH = v:getItemSize()
      itemW = itemW or 0
      itemH = itemH or 0
      content = v:getContent()
      content:setAnchorPoint(0.5, 0.5)
      self:setPositionByAlignment_(content, itemW, itemH, v:getMargin())
      v:setPosition(self.viewRect_.x + tempWidth, self.viewRect_.y)
      tempWidth = tempWidth + itemW
    end
  end
  self.container:setPosition(0, self.viewRect_.height - self.size.height)
end

function UIListView:notifyItem(point)
  local count = self.listener[UIListView.DELEGATE](self, UIListView.COUNT_TAG)
  local temp = self.direction == UIListView.DIRECTION_VERTICAL and self.container:getContentSize().height or 0
  local w, h = 0, 0
  local tag = 0
  for i = 1, count do
    w, h = self.listener[UIListView.DELEGATE](self, UIListView.CELL_SIZE_TAG, i)
    if self.direction == UIListView.DIRECTION_VERTICAL then
      temp = temp - h
      if temp < point.y then
        point.y = point.y - temp
        tag = i
        break
      end
    else
      temp = temp + w
      if temp > point.x then
        point.x = point.x + w - temp
        tag = i
        break
      end
    end
  end
  if 0 == tag then
    printInfo("UIListView - didn't found item")
    return
  end
  local item = self.container:getChildByTag(tag)
  self.listener[UIListView.DELEGATE](self, UIListView.CLICKED_TAG, tag, point)
end

function UIListView:moveItems(beginIdx, endIdx, x, y, bAni)
  if 0 == endIdx then
    self:elasticScroll()
  end
  local posX, posY = 0, 0
  local moveByParams = {
    x = x,
    y = y,
    time = 0.2
  }
  for i = beginIdx, endIdx do
    if bAni then
      if i == beginIdx then
        function moveByParams.onComplete()
          self:elasticScroll()
        end
      else
        moveByParams.onComplete = nil
      end
      transition.moveBy(self.items_[i], moveByParams)
    else
      posX, posY = self.items_[i]:getPosition()
      self.items_[i]:setPosition(posX + x, posY + y)
      if i == beginIdx then
        self:elasticScroll()
      end
    end
  end
end

function UIListView:notifyListener_(event)
  if not self.touchListener_ then
    return
  end
  self.touchListener_(event)
end

function UIListView:modifyItemSizeIf_(item)
  local w, h = item:getItemSize()
  if UIScrollView.DIRECTION_VERTICAL == self.direction then
    if w ~= self.viewRect_.width then
      item:setItemSize(self.viewRect_.width, h, true)
    end
  elseif h ~= self.viewRect_.height then
    item:setItemSize(w, self.viewRect_.height, true)
  end
end

function UIListView:update_(dt)
  UIListView.super.update_(self, dt)
  self:checkItemsInStatus_()
  if self.bAsyncLoad then
    self:increaseOrReduceItem_()
  end
end

function UIListView:checkItemsInStatus_()
  if not self.itemInStatus_ then
    self.itemInStatus_ = {}
  end
  
  local function rectIntersectsRect(rectParent, rect)
    local nIntersects
    local bIn = rectParent.x <= rect.x and rectParent.x + rectParent.width >= rect.x + rect.width and rectParent.y <= rect.y and rectParent.y + rectParent.height >= rect.y + rect.height
    if bIn then
      nIntersects = 2
    else
      local bNotIn = rectParent.x > rect.x + rect.width or rectParent.x + rectParent.width < rect.x or rectParent.y > rect.y + rect.height or rectParent.y + rectParent.height < rect.y
      if bNotIn then
        nIntersects = 0
      else
        nIntersects = 1
      end
    end
    return nIntersects
  end
  
  local newStatus = {}
  local bound, nodePoint
  for i, v in ipairs(self.items_) do
    bound = v:getBoundingBox()
    nodePoint = self.container:convertToWorldSpace(cc.p(bound.x, bound.y))
    bound.x = nodePoint.x
    bound.y = nodePoint.y
    newStatus[i] = rectIntersectsRect(self.viewRect_, bound)
  end
  for i, v in ipairs(newStatus) do
    if self.itemInStatus_[i] and self.itemInStatus_[i] ~= v then
      local params = {
        listView = self,
        itemPos = i,
        item = self.items_[i]
      }
      if 0 == v then
        params.name = "itemDisappear"
      elseif 1 == v then
        params.name = "itemAppearChange"
      elseif 2 == v then
        params.name = "itemAppear"
      end
      self:notifyListener_(params)
    else
    end
  end
  self.itemInStatus_ = newStatus
end

function UIListView:increaseOrReduceItem_()
  if 0 == #self.items_ then
    print("ERROR items count is 0")
    return
  end
  
  local function getContainerCascadeBoundingBox()
    local boundingBox
    for i, item in ipairs(self.items_) do
      local w, h = item:getItemSize()
      local x, y = item:getPosition()
      local anchor = item:getAnchorPoint()
      x = x - anchor.x * w
      y = y - anchor.y * h
      if boundingBox then
        boundingBox = cc.rectUnion(boundingBox, cc.rect(x, y, w, h))
      else
        boundingBox = cc.rect(x, y, w, h)
      end
    end
    local point = self.container:convertToWorldSpace(cc.p(boundingBox.x, boundingBox.y))
    boundingBox.x = point.x
    boundingBox.y = point.y
    return boundingBox
  end
  
  local count = self.delegate_[UIListView.DELEGATE](self, UIListView.COUNT_TAG)
  local nNeedAdjust = 2
  local cascadeBound = getContainerCascadeBoundingBox()
  local item, itemW, itemH
  if UIScrollView.DIRECTION_VERTICAL == self.direction then
    local disH = cascadeBound.y + cascadeBound.height - self.viewRect_.y - self.viewRect_.height
    local tempIdx
    item = self.items_[1]
    if not item then
      print("increaseOrReduceItem_ item is nil, all item count:" .. #self.items_)
      return
    end
    tempIdx = item.idx_
    if disH > self.redundancyViewVal then
      itemW, itemH = item:getItemSize()
      if cascadeBound.height - itemH > self.viewRect_.height and disH - itemH > self.redundancyViewVal then
        self:unloadOneItem_(tempIdx)
      else
        nNeedAdjust = nNeedAdjust - 1
      end
    else
      item = nil
      tempIdx = tempIdx - 1
      if 0 < tempIdx then
        local localPoint = self.container:convertToNodeSpace(cc.p(cascadeBound.x, cascadeBound.y + cascadeBound.height))
        item = self:loadOneItem_(localPoint, tempIdx, true)
      end
      if nil == item then
        nNeedAdjust = nNeedAdjust - 1
      end
    end
    disH = self.viewRect_.y - cascadeBound.y
    item = self.items_[#self.items_]
    if not item then
      return
    end
    tempIdx = item.idx_
    if disH > self.redundancyViewVal then
      itemW, itemH = item:getItemSize()
      if cascadeBound.height - itemH > self.viewRect_.height and disH - itemH > self.redundancyViewVal then
        self:unloadOneItem_(tempIdx)
      else
        nNeedAdjust = nNeedAdjust - 1
      end
    else
      item = nil
      tempIdx = tempIdx + 1
      if count >= tempIdx then
        local localPoint = self.container:convertToNodeSpace(cc.p(cascadeBound.x, cascadeBound.y))
        item = self:loadOneItem_(localPoint, tempIdx)
      end
      if nil == item then
        nNeedAdjust = nNeedAdjust - 1
      end
    end
  else
    local disW = self.viewRect_.x - cascadeBound.x
    item = self.items_[1]
    local tempIdx = item.idx_
    if disW > self.redundancyViewVal then
      itemW, itemH = item:getItemSize()
      if cascadeBound.width - itemW > self.viewRect_.width and disW - itemW > self.redundancyViewVal then
        self:unloadOneItem_(tempIdx)
      else
        nNeedAdjust = nNeedAdjust - 1
      end
    else
      item = nil
      tempIdx = tempIdx - 1
      if 0 < tempIdx then
        local localPoint = self.container:convertToNodeSpace(cc.p(cascadeBound.x, cascadeBound.y))
        item = self:loadOneItem_(localPoint, tempIdx, true)
      end
      if nil == item then
        nNeedAdjust = nNeedAdjust - 1
      end
    end
    disW = cascadeBound.x + cascadeBound.width - self.viewRect_.x - self.viewRect_.width
    item = self.items_[#self.items_]
    tempIdx = item.idx_
    if disW > self.redundancyViewVal then
      itemW, itemH = item:getItemSize()
      if cascadeBound.width - itemW > self.viewRect_.width and disW - itemW > self.redundancyViewVal then
        self:unloadOneItem_(tempIdx)
      else
        nNeedAdjust = nNeedAdjust - 1
      end
    else
      item = nil
      tempIdx = tempIdx + 1
      if count >= tempIdx then
        local localPoint = self.container:convertToNodeSpace(cc.p(cascadeBound.x + cascadeBound.width, cascadeBound.y))
        item = self:loadOneItem_(localPoint, tempIdx)
      end
      if nil == item then
        nNeedAdjust = nNeedAdjust - 1
      end
    end
  end
  if 0 < nNeedAdjust then
    return self:increaseOrReduceItem_()
  end
end

function UIListView:asyncLoad_()
  self:removeAllItems()
  self.container:setPosition(0, 0)
  self.container:setContentSize(cc.size(0, 0))
  local count = self.delegate_[UIListView.DELEGATE](self, UIListView.COUNT_TAG)
  self.items_ = {}
  local itemW, itemH = 0, 0
  local item
  local containerW, containerH = 0, 0
  local posX, posY = 0, 0
  for i = 1, count do
    item, itemW, itemH = self:loadOneItem_(cc.p(posX, posY), i)
    if UIScrollView.DIRECTION_VERTICAL == self.direction then
      posY = posY - itemH
      containerH = containerH + itemH
    else
      posX = posX + itemW
      containerW = containerW + itemW
    end
    if containerW > self.viewRect_.width + self.redundancyViewVal or containerH > self.viewRect_.height + self.redundancyViewVal then
      break
    end
  end
  if UIScrollView.DIRECTION_VERTICAL == self.direction then
    self.container:setPosition(self.viewRect_.x, self.viewRect_.y + self.viewRect_.height)
  else
    self.container:setPosition(self.viewRect_.x, self.viewRect_.y)
  end
  return self
end

function UIListView:setDelegate(delegate)
  self.delegate_[UIListView.DELEGATE] = delegate
end

function UIListView:setPositionByAlignment_(content, w, h, margin)
  local size = content:getContentSize()
  if 0 == margin.left and 0 == margin.right and 0 == margin.top and 0 == margin.bottom then
    if UIScrollView.DIRECTION_VERTICAL == self.direction then
      if UIListView.ALIGNMENT_LEFT == self.alignment then
        content:setPosition(size.width / 2, h / 2)
      elseif UIListView.ALIGNMENT_RIGHT == self.alignment then
        content:setPosition(w - size.width / 2, h / 2)
      else
        content:setPosition(w / 2, h / 2)
      end
    elseif UIListView.ALIGNMENT_TOP == self.alignment then
      content:setPosition(w / 2, h - size.height / 2)
    elseif UIListView.ALIGNMENT_RIGHT == self.alignment then
      content:setPosition(w / 2, size.height / 2)
    else
      content:setPosition(w / 2, h / 2)
    end
  else
    local posX, posY
    if 0 ~= margin.right then
      posX = w - margin.right - size.width / 2
    else
      posX = size.width / 2 + margin.left
    end
    if 0 ~= margin.top then
      posY = h - margin.top - size.height / 2
    else
      posY = size.height / 2 + margin.bottom
    end
    content:setPosition(posX, posY)
  end
end

function UIListView:loadOneItem_(originPoint, idx, bBefore)
  local itemW, itemH = 0, 0
  local item
  local containerW, containerH = 0, 0
  local posX, posY = originPoint.x, originPoint.y
  local content
  item = self.delegate_[UIListView.DELEGATE](self, UIListView.CELL_TAG, idx)
  if nil == item then
    print("ERROR! UIListView load nil item")
    return
  end
  item.idx_ = idx
  itemW, itemH = item:getItemSize()
  if UIScrollView.DIRECTION_VERTICAL == self.direction then
    itemW = itemW or 0
    itemH = itemH or 0
    if bBefore then
    else
      posY = posY - itemH
    end
    content = item:getContent()
    content:setAnchorPoint(0.5, 0.5)
    self:setPositionByAlignment_(content, itemW, itemH, item:getMargin())
    item:setPosition(0, posY)
    containerH = containerH + itemH
  else
    itemW = itemW or 0
    itemH = itemH or 0
    if bBefore then
      posX = posX - itemW
    end
    content = item:getContent()
    content:setAnchorPoint(0.5, 0.5)
    self:setPositionByAlignment_(content, itemW, itemH, item:getMargin())
    item:setPosition(posX, 0)
    containerW = containerW + itemW
  end
  if bBefore then
    table.insert(self.items_, 1, item)
  else
    table.insert(self.items_, item)
  end
  self.container:addChild(item)
  if item.bFromFreeQueue_ then
    item.bFromFreeQueue_ = nil
    item:release()
  end
  return item, itemW, itemH
end

function UIListView:unloadOneItem_(idx)
  local item = self.items_[1]
  if nil == item then
    return
  end
  if idx < item.idx_ then
    return
  end
  local unloadIdx = idx - item.idx_ + 1
  item = self.items_[unloadIdx]
  if nil == item then
    return
  end
  table.remove(self.items_, unloadIdx)
  self:addFreeItem_(item)
  self.container:removeChild(item, false)
  self.delegate_[UIListView.DELEGATE](self, UIListView.UNLOAD_CELL_TAG, idx)
end

function UIListView:addFreeItem_(item)
  item:retain()
  table.insert(self.itemsFree_, item)
end

function UIListView:releaseAllFreeItems_()
  for i, v in ipairs(self.itemsFree_) do
    v:release()
  end
  self.itemsFree_ = {}
end

return UIListView
