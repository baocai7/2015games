local CLASS_NAME = "LayerCommon"
local M = {}
M = class(CLASS_NAME, function()
  return display.newLayer()
end)
local UNION_COST = 1000

function M:ctor(params, callbcak)
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  self.mCallback = callbcak
  params.type = params.type or 1
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  self.mNode = display.newNode():scale(0):pos(display.cx, display.cy):addTo(self, 1)
  local popupLayer = transition.sequence({
    cc.ScaleTo:create(0.2, 1.1),
    cc.ScaleTo:create(0.1, 1)
  })
  self.mNode:runAction(popupLayer)
  self:initUI(params)
  self.mKeypadListener = handler(self, self.onKeypad)
  self:setNodeEventEnabled(true)
end

function M:initUI(params)
  local bg = display.newSprite("common_ui/common_dialog.png"):addTo(self.mNode)
  self.mBg = bg
  if params.title then
    local p1 = display.newSprite("union/adorn2.png"):pos(bg:getContentSize().width * 0.25, bg:getContentSize().height * 0.82):addTo(bg)
    local p2 = display.newSprite("union/adorn2.png"):pos(bg:getContentSize().width * 0.75, bg:getContentSize().height * 0.82):addTo(bg)
    p2:setScaleX(-1)
    display.newSprite(params.title):pos(bg:getContentSize().width * 0.5, bg:getContentSize().height * 0.84):addTo(bg)
  end
  local tFunc = {
    [1] = function()
      self:loadCommonContent(params)
    end,
    [2] = function()
      self:loadCreateContent(params)
    end,
    [3] = function()
      self:loadNoticeContent(params)
    end
  }
  tFunc[params.type]()
  cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png"
  }):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S1636", ""),
    size = 30,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(25, 30, 3)
  })):onButtonClicked(function()
    self:closeCallBack()
  end):align(display.CENTER, bg:getContentSize().width * 0.3, bg:getContentSize().height * 0.2):addTo(bg)
end

function M:loadCommonContent(params)
  local offsetY = params.title and 0 or 50
  local frame = display.newScale9Sprite("common_ui/common_frame11.png", 0, 0, cc.size(523, 155 + offsetY), cc.rect(50, 50, 2, 2)):pos(self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.54 + offsetY * 0.5):addTo(self.mBg)
  self.mFrame = frame
  DYLabelTTF.new({
    text = params.text,
    size = 24,
    color = cc.c3b(73, 43, 0),
    font = GameManager.FONTNAME_TTF
  }):pos(self.mFrame:getContentSize().width * 0.5, self.mFrame:getContentSize().height * 0.5):addTo(self.mFrame)
  cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png",
    disabled = "common_ui/btn_disabled1.png"
  }):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S1637", ""),
    size = 30,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(25, 30, 3)
  })):onButtonClicked(function()
    if self.mCallback then
      self.mCallback()
    end
    self:closeCallBack()
  end):align(display.CENTER, self.mBg:getContentSize().width * 0.7, self.mBg:getContentSize().height * 0.2):addTo(self.mBg)
end

function M:loadCreateContent()
  self.mStep = 1
  local frame = display.newScale9Sprite("common_ui/common_frame11.png", 0, 0, cc.size(523, 155), cc.rect(50, 50, 2, 2)):pos(self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.54):addTo(self.mBg)
  self.mFrame = frame
  local lb1 = DYLabelTTF.new({
    text = DYLang.getString("S1638", ""),
    size = 24,
    color = cc.c3b(73, 43, 0),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):pos(7, self.mFrame:getContentSize().height * 0.7):addTo(self.mFrame)
  self.mEditLabel = ""
  local editBox = cc.ui.UIInput.new({
    image = "#frame_input.png",
    size = cc.size(395, 57),
    x = 310,
    y = lb1:getPositionY(),
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
  editBox:setPlaceHolder(DYLang.getString("S1639", ""))
  editBox:setPlaceholderFontColor(cc.c3b(151, 151, 151))
  editBox:setPlaceholderFontName(GameManager.FONTNAME_TTF)
  editBox:setPlaceholderFontSize(24)
  editBox:setFontName(GameManager.FONTNAME_TTF)
  editBox:setFontSize(24)
  editBox:setFontColor(cc.c3b(60, 37, 14))
  editBox:setReturnType(cc.KEYBOARD_RETURNTYPE_SEND)
  self.mFrame:addChild(editBox)
  local lb2 = DYLabelTTF.new({
    text = DYLang.getString("S1640", ""),
    size = 24,
    color = cc.c3b(73, 43, 0),
    font = GameManager.FONTNAME_TTF
  }):pos(150, self.mFrame:getContentSize().height * 0.22):addTo(self.mFrame)
  local pic = display.newSprite("item_icon/pic_peach.png"):pos(200, lb2:getPositionY()):addTo(self.mFrame)
  DYLabelTTF.new({
    text = UNION_COST,
    size = 24,
    color = cc.c3b(12, 255, 0),
    font = GameManager.FONTNAME_TTF
  }, {}):pos(260, lb2:getPositionY()):addTo(self.mFrame)
  cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png",
    disabled = "common_ui/btn_disabled1.png"
  }):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S1641", ""),
    size = 30,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(25, 30, 3)
  })):onButtonClicked(function()
    self:createCallback()
  end):align(display.CENTER, self.mBg:getContentSize().width * 0.7, self.mBg:getContentSize().height * 0.2):addTo(self.mBg)
end

function M:createCallback()
  if 1 == self.mStep then
    if self.mEditLabel == "" then
      WSToast.new(DYLang.getString("S1642", "")):addTo(self, 20)
      return
    end
    if not DataUtils.isChatLegal(self.mEditLabel) then
      WSToast.new(DYLang.getString("S1643", "")):addTo(self, 20)
      return
    end
    if string.len(self.mEditLabel) > 18 then
      WSToast.new(DYLang.getString("S1644", "")):addTo(self, 20)
      return
    end
    self.mStep = 2
    self.mFrame:removeAllChildren()
    local lb1 = DYLabelTTF.new({
      text = DYLang.getString("S1645", ""),
      size = 24,
      color = cc.c3b(73, 43, 0),
      font = GameManager.FONTNAME_TTF,
      dyalign = "CENTER_LEFT"
    }):pos(72, self.mFrame:getContentSize().height * 0.5):addTo(self.mFrame)
    local pic = display.newSprite("item_icon/pic_peach.png"):pos(200, lb1:getPositionY()):addTo(self.mFrame)
    local lb2 = DYLabelTTF.new({
      text = UNION_COST,
      size = 24,
      color = cc.c3b(12, 255, 0),
      font = GameManager.FONTNAME_TTF,
      dyalign = "CENTER_LEFT"
    }, {}):pos(pic:getPositionX() + pic:getContentSize().width * 0.52, lb1:getPositionY()):addTo(self.mFrame)
    local lb2 = DYLabelTTF.new({
      text = DYLang.getString("S1646", ""),
      size = 24,
      color = cc.c3b(73, 43, 0),
      font = GameManager.FONTNAME_TTF,
      dyalign = "CENTER_LEFT"
    }):pos(lb2:getPositionX() + lb2:getContentSize().width * 1.05, lb1:getPositionY()):addTo(self.mFrame)
  elseif 2 == self.mStep then
    self:confirmToCreate()
  end
end

function M:confirmToCreate()
  local function tFuncEvent(param)
    DDLOG(" ================ CREATE_UNION !!!!!!!")
    
    dump(param, " param : ")
    if 0 == param.ret_code then
      DDLOG(" ================ \229\136\155\229\187\186\230\136\144\229\138\159 !!!!!!!")
      CloudData.UNION_ID = param.clan_id
      display.replaceScene(require("union.scenes.SceneUnion").new())
    else
      DDLOG(" ================ \229\136\155\229\187\186\229\164\177\232\180\165 !!!!!!!")
      local errMsg = param.err_msg or "UNKNOWN"
      WSToast.new(errMsg):addTo(self, 20)
    end
  end
  
  self:safeSocketRequest("CMD_CREATE_UNION", {
    name = self.mEditLabel
  }, tFuncEvent)
end

function M:loadNoticeContent()
  self.mEditLabel = ""
  local editBox = cc.ui.UIInput.new({
    image = "union/frame_input.png",
    size = cc.size(395, 57),
    x = self.mBg:getContentSize().width * 0.5,
    y = self.mBg:getContentSize().height * 0.54,
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
  editBox:setPlaceHolder(DYLang.getString("S1647", ""))
  editBox:setPlaceholderFontColor(cc.c3b(151, 151, 151))
  editBox:setPlaceholderFontName(GameManager.FONTNAME_TTF)
  editBox:setPlaceholderFontSize(24)
  editBox:setFontName(GameManager.FONTNAME_TTF)
  editBox:setFontSize(24)
  editBox:setFontColor(cc.c3b(60, 37, 14))
  editBox:setReturnType(cc.KEYBOARD_RETURNTYPE_SEND)
  editBox:setMaxLength(500)
  self.mBg:addChild(editBox)
  cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png",
    disabled = "common_ui/btn_disabled1.png"
  }):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S1648", ""),
    size = 30,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(25, 30, 3)
  })):onButtonClicked(function()
    self:modifyCallback()
  end):align(display.CENTER, self.mBg:getContentSize().width * 0.7, self.mBg:getContentSize().height * 0.2):addTo(self.mBg)
end

function M:modifyCallback()
  if self.mEditLabel == "" then
    WSToast.new(DYLang.getString("S1649", "")):addTo(self, 20)
    return
  end
  if not DataUtils.isChatLegal(self.mEditLabel) then
    WSToast.new(DYLang.getString("S1643", "")):addTo(self, 20)
    return
  end
  if string.len(self.mEditLabel) > 180 then
    WSToast.new(DYLang.getString("S1651", "")):addTo(self, 20)
    return
  end
  
  local function tFuncEvent(param)
    DDLOG(" ================ MODIFY_NOTICE !!!!!!!")
    if 0 == param.ret_code then
      DDLOG(" ================ \228\191\174\230\148\185\230\136\144\229\138\159 !!!!!!!")
      if self.mCallback then
        self.mCallback({
          content = self.mEditLabel
        })
      end
      self:closeCallBack()
    else
      local errMsg = param.err_msg or "UNKNOWN"
      WSToast.new(errMsg):addTo(self, 20)
    end
  end
  
  self:safeSocketRequest("CMD_MODIFY_NOTICE", {
    content = self.mEditLabel
  }, tFuncEvent)
end

function M:onEditBoxBegan(editbox)
  printf("editBox1 event began : text = %s", editbox:getText())
end

function M:onEditBoxEnded(editbox)
  printf("editBox1 event ended : %s", editbox:getText())
end

function M:onEditBoxReturn(editbox)
  printf("editBox1 event return : %s", editbox:getText())
  self.mEditLabel = editbox:getText()
end

function M:onEditBoxChanged(editbox)
  printf("editBox1 event changed : %s", editbox:getText())
end

function M:closeCallBack()
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  local popupLayer = transition.sequence({
    cc.ScaleTo:create(0, 1),
    cc.ScaleTo:create(0.1, 1.1),
    cc.ScaleTo:create(0.2, 0),
    cc.CallFunc:create(function()
      self:removeSelf()
    end)
  })
  self.mNode:runAction(popupLayer)
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
  DYKeypadMgr.regKeyHandler(self.mKeypadListener)
end

function M:onExit()
  DYKeypadMgr.unregKeyHandler(self.mKeypadListener)
end

return M
