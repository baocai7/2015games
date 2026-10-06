local WSToast = require("app.utils.WSToast")
local LayerRecharge = require("app.layers.LayerRecharge")
local CLASS_NAME = "LayerLackPeach"
local M = {}
M = class(CLASS_NAME, function()
  return display.newLayer()
end)

function M:ctor()
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  self.mNode = display.newNode():scale(0):pos(display.cx, display.cy):addTo(self, 1)
  local popupLayer = transition.sequence({
    cc.ScaleTo:create(0.2, 1.1),
    cc.ScaleTo:create(0.1, 1)
  })
  self.mNode:runAction(popupLayer)
  self:initUI()
end

function M:initUI()
  local bg = display.newSprite("common_ui/common_dialog.png"):addTo(self.mNode)
  local frame = display.newScale9Sprite("common_ui/common_frame11.png", 0, 0, cc.size(502, 181), cc.rect(50, 50, 2, 2)):pos(bg:getContentSize().width * 0.5, bg:getContentSize().height * 0.55):addTo(bg)
  DYLabelTTF.new({
    text = DYLang.getString("S730", ""),
    color = cc.c3b(255, 246, 8),
    size = 32,
    font = GameManager.FONTNAME_TTF
  }, {}):pos(frame:getContentSize().width * 0.5, frame:getContentSize().height * 0.5):addTo(frame)
  local text1 = DYLabelTTF.new({
    text = DYLang.getString("S731", ""),
    size = 30,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(25, 30, 3)
  })
  local text2 = DYLabelTTF.new({
    text = DYLang.getString("S6", ""),
    size = 30,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(25, 30, 3)
  })
  cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png"
  }):setButtonLabel("normal", text1):onButtonClicked(function()
    self:closeCallBack()
  end):align(display.CENTER, bg:getContentSize().width * 0.3, bg:getContentSize().height * 0.2):addTo(bg)
  cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png"
  }):setButtonLabel("normal", text2):onButtonClicked(function()
    self:rechargeCallBack()
  end):align(display.CENTER, bg:getContentSize().width * 0.7, bg:getContentSize().height * 0.2):addTo(bg)
end

function M:rechargeCallBack()
  local layer = LayerRecharge.new()
  display.getRunningScene():addChild(layer, 100)
  self:closeCallBack()
end

function M:closeCallBack()
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  local popupLayer = transition.sequence({
    cc.ScaleTo:create(0, 1),
    cc.ScaleTo:create(0.1, 1.1),
    cc.ScaleTo:create(0.2, 0),
    cc.CallFunc:create(function()
      self:runAction(cc.RemoveSelf:create())
    end)
  })
  self.mNode:runAction(popupLayer)
end

return M
