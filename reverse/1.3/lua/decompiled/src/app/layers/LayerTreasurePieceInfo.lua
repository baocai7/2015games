local CLASS_NAME = "LayerTreasurePieceInfo"
local NoviceGuide = require("app.utils.NoviceGuide")
local M = {}
M = class(CLASS_NAME, function()
  return display.newLayer(CLASS_NAME)
end)

function M:ctor(pieceId, cb)
  DDLOG(CLASS_NAME .. ": onCreate")
  self.mKeypadListener = handler(self, self.onKeypad)
  self.mCoreNode = display.newNode():pos(display.cx, display.cy):addTo(self)
  self.mPieceId = pieceId
  self.mPieceData = {}
  self.mBtnFindTreasure = nil
  self.mCallback = cb
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  self:layoutUI()
  self:enableTouch()
  self:setNodeEventEnabled(true)
  self:dealUserGuide()
end

function M:onKeypad(keyCode, event)
  DDLOG("Key %d was on pressed!", keyCode)
  if keyCode == cc.KeyCode.KEY_ESCAPE then
    self:hide()
  end
  return true
end

function M:onEnter()
  DDLOG(CLASS_NAME .. ": onEnter")
  DYKeypadMgr.regKeyHandler(self.mKeypadListener)
end

function M:onExit()
  DDLOG(CLASS_NAME .. ": onExit")
  DYKeypadMgr.unregKeyHandler(self.mKeypadListener)
end

function M:enableTouch()
  local function onTouch(event)
    local touchEvent = {
      began = function()
        self:onTouchBegan(event.name, event.x, event.y)
      end,
      moved = function()
        self:onTouchMoved(event.name, event.x, event.y)
      end,
      ended = function()
        self:onTouchEnded(event.name, event.x, event.y)
      end
    }
    touchEvent[event.name]()
  end
  
  self:setTouchEnabled(true)
  self:addNodeEventListener(cc.NODE_TOUCH_EVENT, onTouch)
end

function M:onTouchBegan(event, px, py)
  self:hide()
  return true
end

function M:onTouchMoved(event, px, py)
end

function M:onTouchEnded(event, px, py)
end

function M:layoutUI()
  self:initData()
  self:addBg()
  self:addContent()
end

function M:initData()
  local pieceId = self.mPieceId
  local data = self.mPieceData
  local treasurePieceModel = DataUtils.getTreasurePieceModel(pieceId)
  data.id = tonumber(treasurePieceModel.treasurePieceId_)
  data.name = treasurePieceModel.treasurePieceName_
  data.desc = treasurePieceModel.treasurePieceDesc_
  data.quality = tonumber(treasurePieceModel.treasurePieceQuality_)
end

function M:addBg()
  local node = self.mCoreNode
  display.newColorLayer(cc.c4b(0, 0, 0, 128)):addTo(self, -1)
  display.newSprite("war_result/bg.png"):addTo(node)
end

function M:addContent()
  local node = self.mCoreNode
  local data = self.mPieceData
  local piecePic = display.newSprite(string.format("treasure/alert/piece" .. data.quality .. ".png"), -170, -20)
  piecePic:addTo(node, 1)
  local label = cc.ui.UILabel.new({
    UILabelType = 2,
    text = DYLang.getString("S978", ""),
    size = 26,
    color = cc.c3b(248, 255, 15),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, -90, 20)
  node:addChild(label, 1)
  label:setAnchorPoint(0, 1)
  local label = cc.ui.UILabel.new({
    UILabelType = 2,
    text = data.desc,
    size = 24,
    color = display.COLOR_WHITE,
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, -20, 20)
  node:addChild(label, 1)
  label:setAnchorPoint(0, 1)
  local label = cc.ui.UILabel.new({
    UILabelType = 2,
    text = DYLang.getString("S979", ""),
    size = 26,
    color = cc.c3b(248, 255, 15),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, -90, -35)
  node:addChild(label, 1)
  label:setAnchorPoint(0, 1)
  local label = cc.ui.UILabel.new({
    UILabelType = 2,
    text = string.format(DYLang.getString("S980", ""), data.id),
    size = 24,
    color = cc.c3b(124, 250, 13),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, -20, -35)
  node:addChild(label, 1)
  label:setAnchorPoint(0, 1)
  local label = cc.ui.UILabel.new({
    UILabelType = 2,
    text = data.name,
    size = 28,
    color = display.COLOR_WHITE,
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, -170, 75)
  node:addChild(label, 1)
  label:setAnchorPoint(0.5, 0.5)
  local button = cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal.png",
    pressed = "common_ui/btn_pressed.png",
    disabled = "common_ui/btn_disabled.png"
  }):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S981", ""),
    size = 30,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(143, 78, 1),
    lineWidth = 2
  })):setButtonLabel("disabled", DYLabelTTF.new({
    text = DYLang.getString("S981", ""),
    size = 30,
    color = cc.c3b(202, 199, 199),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(40, 40, 40),
    lineWidth = 2
  })):onButtonClicked(function()
    local scene = require("app.scenes.SceneStage").new(1, math.ceil(data.id / 10), (data.id - 1) % 10 + 1)
    display.replaceScene(scene)
  end):align(display.CENTER, 170, -55):zorder(2):addTo(node, 2)
  if CloudData.MAIN_STAGE_PROGRESS < data.id then
    self:performWithDelay(function()
      button:setButtonEnabled(false)
    end, 0)
  end
end

function M:show()
  local scene = cc.Director:getInstance():getRunningScene()
  scene:addChild(self, 20)
  local node = self.mCoreNode
  node:setScale(0)
  node:runAction(transition.sequence({
    cc.ScaleTo:create(0.2, 1.1),
    cc.ScaleTo:create(0.1, 1)
  }))
end

function M:hide()
  local node = self.mCoreNode
  node:runAction(transition.sequence({
    cc.ScaleTo:create(0.1, 1.1),
    cc.ScaleTo:create(0.2, 0)
  }))
  self:runAction(cc.Sequence:create(cc.DelayTime:create(0.3), cc.RemoveSelf:create()))
  self:invokeCallback(0)
end

function M:invokeCallback(tag, param1, param2)
  if self.mCallback then
    self.mCallback(tag, param1, param2)
  end
end

function M:dealUserGuide()
  local stageProgress = Const.STAGE_PROGRESS or CloudData.MAIN_STAGE_PROGRESS
end

return M
