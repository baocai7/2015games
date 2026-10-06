local CLASS_NAME = "LayerUnionList"
local M = {}
M = class(CLASS_NAME, function()
  return display.newLayer()
end)

function M:ctor(cb)
  DDLOG(CLASS_NAME .. ": onCreate")
  display.addSpriteFrames("union/ui_union_apply.plist", "union/ui_union_apply.png")
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  self.mEmptyNode = display.newNode()
  self.mEmptyNode:setPosition(display.cx, display.cy)
  self:addChild(self.mEmptyNode)
  self:initUI()
  self:initData()
  self.mKeypadListener = handler(self, self.onKeypad)
  self:setNodeEventEnabled(true)
end

function M:initUI()
  local bg = display.newSprite("pvp_ol/bg_rankInfo.png", 0, -20):addTo(self.mEmptyNode)
  self.mBg = bg
  local titleFrame = display.newSprite("common_ui/title_frame.png"):pos(bg:getContentSize().width * 0.5, bg:getContentSize().height - 30):addTo(bg)
  display.newSprite("union/title.png"):pos(titleFrame:getContentSize().width * 0.5, titleFrame:getContentSize().height * 0.55):addTo(titleFrame)
  display.newSprite("union/pic_tang.png"):pos(bg:getContentSize().width * 0.84, bg:getContentSize().height * 0.24):addTo(bg, 1)
  cc.ui.UIPushButton.new({
    normal = "common_ui/close_normal.png",
    pressed = "common_ui/close_pressed.png"
  }):scale(0.9):onButtonClicked(function()
    self:closeCallBack()
  end):align(display.CENTER, bg:getContentSize().width * 0.95, bg:getContentSize().height * 0.94):addTo(bg, 2)
end

function M:initData()
  local function tFuncEvent(param)
    local unionList = param.clan_list
    
    table.sort(unionList, function(v1, v2)
      if v1.level == v2.level then
        return v1.cur_count > v2.cur_count
      else
        return v1.level > v2.level
      end
    end)
    self.mUnoinList = unionList
    self.mCurUnionList = {}
    self.mContents = {}
    self.mCurrContents = {}
    self.mCurrPage = 1
    self.mMaxPage = math.ceil(#unionList / 6)
    self:loadUnionList()
    self:loadUnionNotice()
    self:loadPageBtn()
    self:loadSearchFunc()
  end
  
  self:safeSocketRequest("CMD_UNION_LIST", nil, tFuncEvent)
end

function M:loadUnionList()
  local posArr = {
    42,
    165,
    270,
    360,
    506
  }
  self.mListFrame = display.newScale9Sprite("union/common_frame.png", 442, 380, cc.size(708, 315), cc.rect(40, 40, 1, 1)):addTo(self.mBg)
  self.mMark = display.newSprite("#mark.png", 0, 294):addTo(self.mListFrame, 5)
  for i = 1, #self.mUnoinList do
    local info = self.mUnoinList[i]
    local content = self:getUnionInfo(info)
    content:hide()
    content:addTo(self.mListFrame)
    table.insert(self.mContents, content)
  end
  self.mCurrContents = clone(self.mContents)
  for i = 1, #posArr do
    local posX = posArr[i]
    display.newSprite("#title" .. i .. ".png", posX, 335):addTo(self.mListFrame)
  end
  for i = 1, 5 do
    local line = display.newSprite("#line.png", 354, 324 - 54 * i):addTo(self.mListFrame)
    line:setScaleX(2.5)
  end
  for i = 1, 6 do
    local content = self.mContents[i]
    if content then
      content:show()
      content:setPosition(0, 318 - 54 * i)
      table.insert(self.mCurUnionList, content)
    end
  end
  self.mListFrame:setTouchEnabled(true)
  self.mListFrame:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    return self:onTouch(event.name, event.x, event.y, 0)
  end)
end

function M:loadUnionNotice()
  local frame = display.newScale9Sprite("union/common_frame.png", 905, 402, cc.size(200, 270), cc.rect(40, 40, 1, 1)):addTo(self.mBg)
  display.newSprite("#title6.png", 100, 290):addTo(frame)
  local str = ""
  if self.mUnoinList[1] then
    str = self.mUnoinList[1].bulletin
  end
  local params = {
    text = str,
    size = 20,
    font = GameManager.FONTNAME_TTF,
    lineWidth = 188
  }
  local newStr = DataUtils.getNewStrWithAlign(params)
  self.mNoticeLabel = DYLabelTTF.new({
    text = newStr,
    size = 20,
    color = display.COLOR_WHITE,
    font = GameManager.FONTNAME_TTF,
    dyalign = "TOP_LEFT"
  }, {}):pos(10, 260):addTo(frame)
end

function M:loadPageBtn()
  local p1 = display.newSprite("#adorn1.png"):pos(self.mBg:getContentSize().width * 0.13, self.mBg:getContentSize().height * 0.25):addTo(self.mBg)
  local p2 = display.newSprite("#adorn1.png"):pos(self.mBg:getContentSize().width * 0.7, self.mBg:getContentSize().height * 0.25):addTo(self.mBg)
  p2:setScaleX(-1)
  self.mLeftBtn = cc.ui.UIPushButton.new({
    normal = "#btn_left.png",
    pressed = "#btn_left.png",
    disabled = "#btn_left1.png"
  }):onButtonPressed(function(event)
    event.target:setScale(0.9)
  end):onButtonRelease(function(event)
    event.target:setScale(1)
  end):onButtonClicked(function()
    self:toLastPage()
  end):align(display.CENTER, self.mBg:getContentSize().width * 0.3, self.mBg:getContentSize().height * 0.29):addTo(self.mBg)
  self.mRightBtn = cc.ui.UIPushButton.new({
    normal = "#btn_left.png",
    pressed = "#btn_left.png",
    disabled = "#btn_left1.png"
  }):onButtonPressed(function(event)
    event.target:setScale(-0.9, 0.9)
  end):onButtonRelease(function(event)
    event.target:setScale(-1, 1)
  end):onButtonClicked(function()
    self:toNextPage()
  end):align(display.CENTER, self.mBg:getContentSize().width * 0.52, self.mBg:getContentSize().height * 0.29):addTo(self.mBg)
  self.mRightBtn:setScaleX(-1)
  self.mPageLabel = DYLabelTTF.new({
    text = self.mCurrPage .. "/" .. self.mMaxPage,
    size = 24,
    color = display.COLOR_WHITE,
    font = GameManager.FONTNAME_TTF
  }, {}):pos(self.mBg:getContentSize().width * 0.41, self.mBg:getContentSize().height * 0.29):addTo(self.mBg)
  self:pageTipUpdate()
end

function M:loadSearchFunc()
  self.mSearchLabel = ""
  local editBox = cc.ui.UIInput.new({
    image = "#frame_input.png",
    size = cc.size(395, 57),
    x = 390,
    y = 110,
    listener = function(event, editbox)
      if event == "began" then
        self:onEditBoxBegan(editbox)
      elseif event == "ended" then
        self:onEditBoxEnded(editbox)
      elseif event == "return" then
        self:onEditBoxReturn(editbox)
      elseif event == "changed" then
        self:onEditBoxChanged(editbox)
      else
        printf("EditBox event %s", tostring(event))
      end
    end
  })
  editBox:setPlaceHolder(DYLang.getString("S1709", ""))
  editBox:setPlaceholderFontColor(cc.c3b(151, 151, 151))
  editBox:setPlaceholderFontName(GameManager.FONTNAME_TTF)
  editBox:setPlaceholderFontSize(24)
  editBox:setFontName(GameManager.FONTNAME_TTF)
  editBox:setFontSize(24)
  editBox:setFontColor(cc.c3b(60, 37, 14))
  editBox:setReturnType(cc.KEYBOARD_RETURNTYPE_SEND)
  self.mBg:addChild(editBox)
  cc.ui.UIPushButton.new({
    normal = "#btn_search.png",
    pressed = "#btn_search.png"
  }):onButtonPressed(function(event)
    event.target:setScale(0.9)
  end):onButtonRelease(function(event)
    event.target:setScale(1)
  end):onButtonClicked(function()
    self:searchCallback()
  end):align(display.CENTER, 652, 115):addTo(self.mBg)
end

function M:getUnionInfo(info)
  local pNode = display.newNode()
  pNode:setContentSize(708, 54)
  pNode.info = info
  local totalNum = info.max_count
  local posArr = {
    42,
    165,
    270,
    360,
    506
  }
  local textStr = {
    info.id,
    info.name,
    info.level,
    info.cur_count .. "/" .. totalNum,
    info.leader
  }
  local label1 = DYLabelTTF.new({
    text = info.id,
    size = 22,
    color = display.COLOR_WHITE,
    font = GameManager.FONTNAME_TTF
  }, {})
  local label2 = DYLabelTTF.new({
    text = info.name,
    size = 22,
    color = cc.c3b(255, 237, 173),
    font = GameManager.FONTNAME_TTF
  }, {})
  local label3 = DYLabelTTF.new({
    text = info.level,
    size = 22,
    color = cc.c3b(7, 255, 13),
    font = GameManager.FONTNAME_TTF
  }, {})
  local label4 = DYLabelTTF.new({
    text = info.cur_count .. "/" .. totalNum,
    size = 22,
    color = cc.c3b(7, 255, 13),
    font = GameManager.FONTNAME_TTF
  }, {})
  local label5 = DYLabelTTF.new({
    text = info.leader,
    size = 22,
    color = cc.c3b(73, 43, 0),
    font = GameManager.FONTNAME_TTF
  })
  local labelArr = {
    label1,
    label2,
    label3,
    label4,
    label5
  }
  for i = 1, #textStr do
    local label = labelArr[i]
    label:pos(posArr[i], pNode:getContentSize().height * 0.5)
    label:addTo(pNode)
  end
  return pNode
end

function M:toLastPage()
  self.mCurrPage = self.mCurrPage - 1
  self:updateUnionList(self.mCurrContents)
end

function M:toNextPage()
  self.mCurrPage = self.mCurrPage + 1
  self:updateUnionList(self.mCurrContents)
end

function M:pageTipUpdate()
  self.mPageLabel:setString(self.mCurrPage .. "/" .. self.mMaxPage)
  if self.mCurrPage <= 1 then
    self.mLeftBtn:setButtonEnabled(false)
  else
    self.mLeftBtn:setButtonEnabled(true)
  end
  if self.mMaxPage <= self.mCurrPage then
    self.mRightBtn:setButtonEnabled(false)
  else
    self.mRightBtn:setButtonEnabled(true)
  end
end

function M:selectUnion(idx, info)
  self.mMark:setPositionY(348 - 54 * idx)
  local params = {
    text = info.bulletin,
    size = 20,
    font = GameManager.FONTNAME_TTF,
    lineWidth = 188
  }
  local newStr = DataUtils.getNewStrWithAlign(params)
  self.mNoticeLabel:setString(newStr)
end

function M:onTouch(event, x, y)
  if event == "began" then
    for i = 1, #self.mCurUnionList do
      local content = self.mCurUnionList[i]
      local touchInSprite = cc.rectContainsPoint(content:getCascadeBoundingBox(), cc.p(x, y))
      if touchInSprite then
        self:selectUnion(i, content.info)
      end
    end
    return true
  end
  if event == "moved" then
  end
  if event == "ended" then
  end
end

function M:onEditBoxBegan(editbox)
  printf("editBox1 event began : text = %s", editbox:getText())
end

function M:onEditBoxEnded(editbox)
  printf("editBox1 event ended : %s", editbox:getText())
end

function M:onEditBoxReturn(editbox)
  printf("editBox1 event return : %s", editbox:getText())
  self.mSearchLabel = editbox:getText()
end

function M:onEditBoxChanged(editbox)
  printf("editBox1 event changed : %s", editbox:getText())
end

function M:searchCallback()
  if self.mSearchLabel == "" then
    self.mCurrPage = 1
    self.mMaxPage = math.ceil(#self.mContents / 6)
    self.mCurrContents = clone(self.mContents)
    self:updateUnionList(self.mContents)
    return
  end
  local symbol = tonumber(self.mSearchLabel)
  if not symbol then
    self:matchWithName()
  else
    self:matchWithID()
  end
end

function M:matchWithName()
  local list = {}
  for i = 1, #self.mContents do
    local content = self.mContents[i]
    local name = content.info.name
    local isFind = string.find(name, self.mSearchLabel)
    if isFind then
      table.insert(list, content)
    end
  end
  self.mCurrPage = 1
  self.mMaxPage = math.ceil(#list / 6)
  self.mCurrContents = list
  self:updateUnionList(self.mCurrContents)
end

function M:matchWithID()
  local list = {}
  for i = 1, #self.mContents do
    local content = self.mContents[i]
    local id = content.info.id
    if id == tonumber(self.mSearchLabel) then
      table.insert(list, content)
      break
    end
  end
  self.mCurrPage = 1
  self.mMaxPage = math.ceil(#list / 6)
  self.mCurrContents = list
  self:updateUnionList(self.mCurrContents)
end

function M:updateUnionList(list)
  self:pageTipUpdate()
  for i = 1, #self.mCurUnionList do
    local content = self.mCurUnionList[i]
    content:hide()
  end
  self.mCurUnionList = {}
  local beginNum = (self.mCurrPage - 1) * 6 + 1
  local endNum = beginNum + 5
  for i = beginNum, endNum do
    local content = list[i]
    if content then
      content:show()
      content:setPosition(0, 318 - 54 * (i - (self.mCurrPage - 1) * 6))
      table.insert(self.mCurUnionList, content)
      if i == beginNum then
        self:selectUnion(1, content.info)
      end
    end
  end
end

function M:closeCallBack()
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  self:runAction(cc.RemoveSelf:create())
end

function M:onKeypad(keyCode, event)
  DDLOG("Key %d was on pressed!", keyCode)
  if keyCode == cc.KeyCode.KEY_ESCAPE then
    self:closeCallBack()
    return true
  end
  return false
end

function M:onEnter()
  DDLOG(CLASS_NAME .. ": onEnter")
  DYKeypadMgr.regKeyHandler(self.mKeypadListener)
end

function M:onExit()
  DDLOG(CLASS_NAME .. ": onExit")
  display.removeSpriteFramesWithFile("union/ui_union_apply.plist", "union/ui_union_apply.png")
  DYKeypadMgr.unregKeyHandler(self.mKeypadListener)
end

return M
