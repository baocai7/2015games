local M = {}
M = class("LayerChangeUserIcon", function()
  return display.newLayer()
end)

function M:ctor(handler_)
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  self.mNode = display.newNode():pos(display.cx, display.cy):addTo(self, 1)
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  if handler_ then
    self.mHandler = handler_
  end
  self:initData()
  self:changeUserIcon()
end

function M:initData()
  table.sort(CloudData.ICON_LIST.level, function(v1, v2)
    return v1.id < v2.id
  end)
  table.sort(CloudData.ICON_LIST.vip, function(v1, v2)
    return v1.id < v2.id
  end)
  table.sort(CloudData.ICON_LIST.pvp, function(v1, v2)
    return v1.id < v2.id
  end)
end

function M:changeUserIcon()
  local levelIcon = CloudData.ICON_LIST.level
  local vipIcon = CloudData.ICON_LIST.vip
  local pvpIcon = CloudData.ICON_LIST.pvp
  local bg = display.newScale9Sprite("common_ui/common_dialog.png", 0, 0, cc.size(598, 708), cc.rect(200, 200, 2, 2)):addTo(self.mNode)
  display.newSprite("user_center/icon_title.png"):pos(bg:getContentSize().width * 0.5, bg:getContentSize().height * 0.93):addTo(bg)
  self.mIconTable = {
    levelIcon,
    pvpIcon,
    vipIcon
  }
  self.mSelectedIconTable = {}
  for i = 1, 3 do
    local title = display.newSprite("user_center/icon_title" .. i .. ".png"):align(display.CENTER_LEFT, bg:getContentSize().width * 0.1, bg:getContentSize().height * (1.1 - 0.24 * i)):addTo(bg)
    local frame = display.newScale9Sprite("common_ui/common_frame11.png", 0, 0, cc.size(524, 124), cc.rect(40, 40, 2, 2)):pos(bg:getContentSize().width * 0.5, title:getPositionY() - 85):addTo(bg)
    local lv = cc.ui.UIListView.new({
      viewRect = cc.rect(12, 12, 500, 100),
      direction = cc.ui.UIScrollView.DIRECTION_HORIZONTAL
    }):onTouch(handler(self, self.touchListener)):addTo(frame)
    lv:setTag(i)
    local tb = {}
    local currIconData = self.mIconTable[i]
    for j = 1, #currIconData do
      local iconId = tonumber(currIconData[j].icon)
      local status = currIconData[j].status
      local item = lv:newItem()
      local iconFrame = display.newSprite("common_ui/frame1.png"):scale(0.8181818181818182)
      local icon
      if 0 == status then
        icon = display.newGraySprite(string.format("buddha_icon/buddha%d.png", iconId), {
          0.2,
          0.3,
          0.5,
          0.1
        })
      else
        icon = display.newSprite(string.format("buddha_icon/buddha%d.png", iconId))
      end
      icon:setPosition(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.5)
      iconFrame:addChild(icon)
      local selectedIcon = display.newSprite("common_ui/frame_selected.png"):pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.5):hide():addTo(iconFrame)
      local content = iconFrame
      item:addContent(content)
      item:setItemSize(102, 90)
      lv:addItem(item)
      table.insert(tb, selectedIcon)
    end
    lv:reload()
    table.insert(self.mSelectedIconTable, tb)
  end
  cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png"
  }):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S38", ""),
    size = 30,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(25, 30, 3)
  })):onButtonClicked(function()
    self:ensureCallback()
  end):align(display.CENTER, bg:getContentSize().width * 0.5, bg:getContentSize().height * 0.1):addTo(bg)
  cc.ui.UIPushButton.new({
    normal = "common_ui/close_normal.png",
    pressed = "common_ui/close_pressed.png"
  }):onButtonClicked(function()
    self:closeCallBack()
  end):align(display.CENTER, bg:getContentSize().width * 0.96, bg:getContentSize().height * 0.95):addTo(bg)
end

function M:ensureCallback()
  if not self.mSelectdIcon then
    self:closeCallBack()
    return
  end
  if 0 == self.mSelectdIcon.status then
    WSToast.new(DYLang.getString("S562", "")):addTo(self, 20)
    return
  end
  
  local function tFuncListener(jsonTable)
    if jsonTable.errorCode > 0 then
      local errMsg = jsonTable.errorMsg or "UNKNOWN"
      WSToast.new(errMsg):addTo(self, 20)
      return
    end
    self.mHandler(self.mSelectdIcon.icon)
    self:closeCallBack()
  end
  
  local params = {
    icon = tostring(self.mSelectdIcon.icon)
  }
  DYHttpMgr.changeUserIcon(tFuncListener, params)
end

function M:touchListener(event)
  local listView = event.listView
  if "clicked" == event.name then
    local tag = listView:getTag()
    self.mSelectdIcon = self.mIconTable[tag][event.itemPos]
    for m = 1, #self.mSelectedIconTable do
      for n = 1, #self.mSelectedIconTable[m] do
        local selectedIcon = self.mSelectedIconTable[m][n]
        if tag == m and event.itemPos == n then
          selectedIcon:show()
        else
          selectedIcon:hide()
        end
      end
    end
  elseif "moved" == event.name then
  else
    if "ended" == event.name then
    else
    end
  end
end

function M:closeCallBack()
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  self:removeSelf()
end

return M
