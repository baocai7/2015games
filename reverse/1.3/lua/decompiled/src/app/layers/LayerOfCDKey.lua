local WSToast = require("app.utils.WSToast")
local LayerBoxShow = require("app.layers.LayerBoxShow")
local M = {}
M = class("LayerOfCDKey", function()
  return display.newLayer()
end)

function M:ctor()
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  self.emptyNode_ = display.newNode()
  self.emptyNode_:setPosition(display.cx, display.height * 0.72)
  self:addChild(self.emptyNode_)
  self.emptyNode_:setScale(0)
  local popupLayer = transition.sequence({
    cc.ScaleTo:create(0.2, 1.1),
    cc.ScaleTo:create(0.1, 1)
  })
  self.emptyNode_:runAction(popupLayer)
  self:initUI_()
end

function M:initUI_()
  local bg = display.newSprite("common_ui/common_dialog.png"):addTo(self.emptyNode_)
  DYLabelTTF.new({
    text = DYLang.getString("S769", ""),
    size = 32,
    color = cc.c3b(255, 252, 18),
    font = GameManager.FONTNAME_TTF
  }, {}):align(display.CENTER, bg:getContentSize().width * 0.5, bg:getContentSize().height * 0.88):addTo(bg)
  local editBox = cc.ui.UIInput.new({
    image = "user_center/text_name.png",
    size = cc.size(445, 67),
    x = bg:getContentSize().width * 0.5,
    y = bg:getContentSize().height * 0.57,
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
  editBox:setPlaceHolder(DYLang.getString("S770", ""))
  editBox:setPlaceholderFontColor(cc.c3b(136, 116, 49))
  editBox:setPlaceholderFontName(GameManager.FONTNAME_TTF)
  editBox:setPlaceholderFontSize(24)
  editBox:setFontName(GameManager.FONTNAME_TTF)
  editBox:setFontSize(35)
  editBox:setFontColor(cc.c3b(60, 37, 14))
  editBox:setReturnType(cc.KEYBOARD_RETURNTYPE_SEND)
  bg:addChild(editBox)
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
  end):align(display.CENTER, bg:getContentSize().width * 0.7, bg:getContentSize().height * 0.25):addTo(bg)
  cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png"
  }):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S772", ""),
    size = 30,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(25, 30, 3)
  })):onButtonClicked(function()
    self:closeCallBack_()
  end):align(display.CENTER, bg:getContentSize().width * 0.3, bg:getContentSize().height * 0.25):addTo(bg)
end

function M:confirmCallBack_()
  local codeInput = string.trim(checkstring(self.codeInput_))
  if codeInput == "" then
    local toast = WSToast.new(DYLang.getString("S769", ""))
    toast:setPosition(0, 0)
    self.emptyNode_:addChild(toast, 200)
    return
  end
  
  local function tFuncListener(jsonTable)
    if 0 == jsonTable.errorCode then
      local awards = {}
      for k, v in pairs(jsonTable.data.rewardGain) do
        local info = {
          id = tonumber(k),
          num = tonumber(v)
        }
        table.insert(awards, info)
        DYAnalyze.item.get(k, "", v, "CDKey")
      end
      local awardTable = {boxInfo = awards}
      local tip = LayerBoxShow.new(awardTable, LayerBoxShow.AWARD_GET)
      display.getRunningScene():addChild(tip, 20)
      for id, num in pairs(jsonTable.data.reward) do
        DataUtils.updateItemNum(id, num)
      end
      self:runAction(cc.RemoveSelf:create())
    else
      local msg = jsonTable.errorMsg or "UNKNOWN"
      local toast = WSToast.new(msg)
      toast:setPosition(0, 0)
      self.emptyNode_:addChild(toast, 200)
    end
  end
  
  local params = {}
  params.code = codeInput
  DYHttpMgr.codeExchange(tFuncListener, params)
end

function M:onEditBoxBegan(editbox)
  printf("editBox1 event began : text = %s", editbox:getText())
  self.codeInput_ = editbox:getText()
end

function M:onEditBoxEnded(editbox)
  printf("editBox1 event ended : %s", editbox:getText())
  self.codeInput_ = editbox:getText()
end

function M:onEditBoxReturn(editbox)
  printf("editBox1 event return : %s", editbox:getText())
  self.codeInput_ = editbox:getText()
end

function M:onEditBoxChanged(editbox)
  printf("editBox1 event changed : %s", editbox:getText())
  self.codeInput_ = editbox:getText()
end

function M:closeCallBack_()
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  local popupLayer = transition.sequence({
    cc.ScaleTo:create(0, 1),
    cc.ScaleTo:create(0.1, 1.1),
    cc.ScaleTo:create(0.2, 0),
    cc.CallFunc:create(function()
      self:runAction(cc.RemoveSelf:create())
    end)
  })
  self.emptyNode_:runAction(popupLayer)
end

return M
