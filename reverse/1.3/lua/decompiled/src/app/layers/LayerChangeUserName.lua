local M = {}
M = class("LayerChangeUserName", function()
  return display.newLayer()
end)

function M:ctor(handler_)
  math.randomseed(os.time())
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  self.emptyNode_ = display.newNode()
  self.emptyNode_:setPosition(display.cx, display.height * 0.78)
  self:addChild(self.emptyNode_)
  self.emptyNode_:setScale(0)
  local popupLayer = transition.sequence({
    cc.ScaleTo:create(0.2, 1.1),
    cc.ScaleTo:create(0.1, 1)
  })
  self.emptyNode_:runAction(popupLayer)
  if handler_ then
    self.mHandler = handler_
  end
  self:initUI_()
end

function M:initUI_()
  local bg = display.newSprite("common_ui/common_dialog.png", 0, -20):addTo(self.emptyNode_)
  DYLabelTTF.new({
    text = DYLang.getString("S564", ""),
    size = 32,
    color = cc.c3b(255, 252, 18),
    font = GameManager.FONTNAME_TTF
  }, {}):align(display.CENTER, bg:getContentSize().width * 0.5, bg:getContentSize().height * 0.86):addTo(bg)
  self.randomNameLable_ = ""
  self.editBox_ = cc.ui.UIInput.new({
    image = "user_center/text_name.png",
    size = cc.size(445, 67),
    x = bg:getContentSize().width * 0.06,
    y = bg:getContentSize().height * 0.62,
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
  self.editBox_:setPlaceHolder(DYLang.getString("S565", ""))
  self.editBox_:setPlaceholderFontColor(cc.c3b(136, 116, 49))
  self.editBox_:setPlaceholderFontName(GameManager.FONTNAME_TTF)
  self.editBox_:setPlaceholderFontSize(24)
  self.editBox_:setFontName(GameManager.FONTNAME_TTF)
  self.editBox_:setFontSize(35)
  self.editBox_:setFontColor(cc.c3b(60, 37, 14))
  self.editBox_:setAnchorPoint(0, 0.5)
  self.editBox_:setReturnType(cc.KEYBOARD_RETURNTYPE_SEND)
  bg:addChild(self.editBox_)
  display.newSprite("user_center/text.png"):pos(bg:getContentSize().width * 0.5, bg:getContentSize().height * 0.44):addTo(bg, 2)
  cc.ui.UIPushButton.new({
    normal = "user_center/dice.png",
    pressed = "user_center/dice.png"
  }):align(display.CENTER, bg:getContentSize().width * 0.88, bg:getContentSize().height * 0.62):onButtonClicked(function()
    self:randomName_()
  end):addTo(bg)
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
    self:confirmCallBack_()
  end):align(display.CENTER, bg:getContentSize().width * 0.7, bg:getContentSize().height * 0.22):addTo(bg)
  self.mCancelBtn = cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png"
  }):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S567", ""),
    size = 30,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(25, 30, 3)
  })):onButtonClicked(function()
    self:closeCallBack_()
  end):align(display.CENTER, bg:getContentSize().width * 0.3, bg:getContentSize().height * 0.22):addTo(bg)
end

function M:randomName_()
  local table1 = DataRetainer.USER_NAME_INFO[1]
  local table2 = DataRetainer.USER_NAME_INFO[2]
  local table3 = DataRetainer.USER_NAME_INFO[3]
  math.random(1, 10000)
  local lastName = table1[math.random(2, #table1)]
  local givenName = ""
  if math.random(1, 100) > 50 then
    givenName = table2[math.random(2, #table2)]
  else
    givenName = table3[math.random(2, #table3)]
  end
  self.editBox_:setText(string.format("%s%s", lastName, givenName))
  self:onEditBoxReturn(self.editBox_)
end

function M:confirmCallBack_()
  if tostring(CloudData.UID) ~= tostring(CloudData.USER_NAME) and CloudData.PEACH < CloudData.UPDATE_NICK_COST then
    local tip = WSToast.new(DYLang.getString("S568", ""))
    self:addChild(tip, 20)
    return
  elseif self.textInput_ == nil or self.textInput_ == "" then
    local toast = WSToast.new(DYLang.getString("S569", ""))
    self:addChild(toast, 10)
    return
  elseif not DataUtils.isChatLegal(self.textInput_) then
    local toast = WSToast.new(DYLang.getString("S570", ""))
    self:addChild(toast, 10)
    return
  end
  
  local function tFuncListener(jsonTable)
    if 0 == jsonTable.errorCode then
      CloudData.PEACH = jsonTable.data.peach
      CloudData.USER_NAME = self.textInput_
      if self.mHandler then
        self.mHandler(self.textInput_)
      end
      self:closeCallBack_()
    else
      local msg = jsonTable.errorMsg or DYLang.getString("S571", "")
      local toast = WSToast.new(msg)
      self:addChild(toast, 10)
    end
  end
  
  local params = {}
  params.nick = self.textInput_
  DYHttpMgr.changeNickName(tFuncListener, params)
end

function M:onEditBoxBegan(editbox)
  printf("editBox1 event began : text = %s", editbox:getText())
  self.textInput_ = editbox:getText()
end

function M:onEditBoxEnded(editbox)
  printf("editBox1 event ended : %s", editbox:getText())
  self.textInput_ = editbox:getText()
end

function M:onEditBoxReturn(editbox)
  printf("editBox1 event return : %s", editbox:getText())
  self.textInput_ = editbox:getText()
end

function M:onEditBoxChanged(editbox)
  printf("editBox1 event changed : %s", editbox:getText())
  self.textInput_ = editbox:getText()
end

function M:closeCallBack_()
  local popupLayer = transition.sequence({
    cc.ScaleTo:create(0, 1),
    cc.ScaleTo:create(0.1, 1.1),
    cc.ScaleTo:create(0.2, 0),
    cc.CallFunc:create(function()
      self:removeSelf()
    end)
  })
  self.emptyNode_:runAction(popupLayer)
end

return M
