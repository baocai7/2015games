local LayerItem = require("app.layers.LayerItem")
local NoviceGuide = require("app.utils.NoviceGuide")
local M = {}
M = class("LayerBuddhaBreak", function()
  return display.newLayer()
end)

function M:ctor(buddhaModel, handler_)
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  self.mNode = display.newNode():pos(display.cx, display.cy):addTo(self, 1)
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  if handler_ then
    self.mHandler = handler_
  end
  self:initData(buddhaModel)
  self:initUI()
  self:dealUserGuide()
  self.mKeypadListener = handler(self, self.onKeypad)
  self:setNodeEventEnabled(true)
end

function M:initData(buddhaModel)
  self.mBuddhaModel = buddhaModel
  self.mModelId = buddhaModel.npcModelId
  self.mBreakTimes = math.floor(self.mBuddhaModel.level / 10)
  self.mBreakData = DataUtils.getBreakDataModel(self.mBuddhaModel.npcId, self.mBreakTimes + 1)
  self.mBreakAddParam = {
    buddhaModel.lifeParamK,
    buddhaModel.attackParamK,
    buddhaModel.phyDefenceParamK,
    buddhaModel.magDefenceParamK
  }
  self.mParams = {skillId = 0, isBreakSuccess = false}
  self.mFileInfo = {}
end

function M:initUI()
  self.mBg = display.newSprite("upgrade/break_bg.png"):addTo(self.mNode)
  self.mBg:setTouchEnabled(false)
  self.mBg:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    if event.name == "began" then
      return true
    elseif event.name == "ended" then
      self:closeCallBack()
    end
  end)
  self.mArmature = ccs.Armature:create(self.mBuddhaModel.armatureFile)
  self.mArmature:setPosition(self.mBg:getContentSize().width * 0.48, self.mBg:getContentSize().height * 0.45 + self.mBuddhaModel.upMove)
  self.mArmature:setScale(self.mBuddhaModel.zoomMultiple)
  self.mArmature:getAnimation():playWithIndex(1)
  if 0 == self.mBuddhaModel.isRebel then
    self.mArmature:setScaleX(-1 * self.mBuddhaModel.zoomMultiple)
  end
  self.mBg:addChild(self.mArmature, 3)
  self:breakCost()
  self.mBackBtn = cc.ui.UIPushButton.new({
    normal = "upgrade/back.png",
    pressed = "upgrade/back.png"
  }):align(display.CENTER, display.width * 0.05, display.height * 0.95):onButtonPressed(function(event)
    event.target:setScale(0.9)
  end):onButtonRelease(function(event)
    event.target:setScale(1)
  end):onButtonClicked(function()
    self:closeCallBack()
  end):addTo(self, 10)
end

function M:breakCost()
  self.mCostBg = display.newScale9Sprite("gamescene/team_frame.png", 640, 90, cc.size(1280, 180), cc.rect(50, 30, 2, 2)):opacity(0):addTo(self.mBg)
  local count = #self.mBreakData.costItem
  local pos = {
    [1] = {
      p1 = 360,
      p2 = 510,
      p3 = 860,
      offsetX = 210
    },
    [2] = {
      p1 = 240,
      p2 = 375,
      p3 = 920,
      offsetX = 210
    },
    [3] = {
      p1 = 130,
      p2 = 270,
      p3 = 1048,
      offsetX = 210
    }
  }
  local params = pos[count]
  local costLabel = DYLabelTTF.new({
    text = DYLang.getString("S541", ""),
    size = 28,
    color = cc.c3b(255, 250, 28),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):pos(params.p1, self.mCostBg:getContentSize().height * 0.5):addTo(self.mCostBg)
  local isOk = true
  for i = 1, count do
    local costFrame = display.newSprite("upgrade/cost_frame.png"):align(display.CENTER_LEFT, params.p2 + params.offsetX * (i - 1), self.mCostBg:getContentSize().height * 0.5):addTo(self.mCostBg)
    local itemId = self.mBreakData.costItem[i]
    local itemModel = DataUtils.getItemModel(itemId)
    local itemFrame = display.newSprite(string.format("common_ui/frame%d.png", itemModel.quality)):scale(0.8):pos(costFrame:getContentSize().width * 0.23, costFrame:getContentSize().height * 0.5):addTo(costFrame)
    display.newSprite(itemModel.itemIcon):pos(itemFrame:getContentSize().width * 0.5, itemFrame:getContentSize().height * 0.5):addTo(itemFrame)
    itemFrame:setTouchEnabled(true)
    itemFrame:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
      local name, x, y = event.name, event.x, event.y
      local touchInSprite = cc.rectContainsPoint(itemFrame:getCascadeBoundingBox(), cc.p(x, y))
      if name == "began" then
        LayerItem.new(LayerItem.TYPE_LAYER, itemId):addTo(self, 20)
        return true
      elseif name == "moved" then
      elseif name == "ended" then
      end
    end)
    local currNum = itemModel.currNum
    local costNum = tonumber(self.mBreakData.costNum[i])
    local lb = DYLabelTTF.new({
      UILabelType = 2,
      text = string.format("%d/%d", currNum, costNum),
      size = 24,
      color = display.COLOR_WHITE,
      font = GameManager.FONTNAME_TTF
    }):align(display.CENTER, costFrame:getContentSize().width * 0.75, costFrame:getContentSize().height * 0.5):addTo(costFrame, 1)
    if currNum < costNum then
      self.mBg:setTouchEnabled(true)
      isOk = false
      lb:setColor(cc.c3b(255, 0, 0))
    end
  end
  self.mBreakBtn = cc.ui.UIPushButton.new({
    normal = "upgrade/btn_break1.png",
    pressed = "upgrade/btn_break2.png"
  }):onButtonClicked(function()
    self:breakCallBack(isOk)
  end):align(display.CENTER, params.p3, self.mCostBg:getContentSize().height * 0.5):addTo(self.mCostBg)
end

function M:breakCallBack(flag)
  if not flag then
    WSToast.new(DYLang.getString("S542", "")):addTo(self, 20)
    return
  end
  self.mBreakBtn:setButtonEnabled(false)
  
  local function tFuncListener(jsonTable)
    if jsonTable.errorCode > 0 then
      local errMsg = jsonTable.errorMsg or "UNKNOWN"
      WSToast.new(errMsg):addTo(self, 20)
      return
    end
    DYSoundMgr.playEffect(DY_SND.sfx_advanced)
    CloudData.NPC_INFO[self.mBuddhaModel.npcId].level = jsonTable.data.buddhaLevel
    local skillIds = jsonTable.data.skillIds
    for i = 1, #skillIds do
      local skillId = skillIds[i]
      if skillId ~= 0 then
        CloudData.NPC_INFO[tonumber(self.mBuddhaModel.npcId)].skills[tostring(skillId)] = 1
      end
    end
    for k, v in pairs(jsonTable.data.things) do
      CloudData.GAME_ITEM_INFO[k] = v
    end
    self.mBuddhaModel = DataUtils.getBuddhaModel(self.mBuddhaModel.npcId)
    self.mParams.skillIds = skillIds
    self.mParams.isBreakSuccess = true
    self:playAnimation()
    for i = 1, #self.mBreakData.costItem do
      local itemId = self.mBreakData.costItem[i]
      local costNum = tonumber(self.mBreakData.costNum[i])
      DYAnalyze.item.consume(itemId, "", costNum, "Break_cost")
    end
  end
  
  local params = {}
  params.buddhaId = self.mBuddhaModel.npcId
  DYHttpMgr.npcBreak(tFuncListener, params)
end

function M:playAnimation()
  self.mBackBtn:setButtonEnabled(false)
  DYRes.loadSheet("upgrade/break_tx.plist")
  DYRes.loadSheet("upgrade/break_tx1.plist")
  DYRes.loadSheet("upgrade/break_tx2.plist")
  DYRes.loadSheet("upgrade/break_tx3.plist")
  DYRes.loadSheet("upgrade/break_tx4.plist")
  DYRes.loadSheet("upgrade/break_tx5.plist")
  local frames = display.newFrames("hengx%d.png", 1, 17)
  local animation = display.newAnimation(frames, 0.04)
  local emptyPic = display.newSprite():pos(self.mCostBg:getContentSize().width * 0.5, self.mCostBg:getContentSize().height * 0.5):scale(5):addTo(self.mCostBg, 5)
  emptyPic:playAnimationOnce(animation, true, function()
    self.mCostBg:removeSelf()
    self:playAnimation1()
  end)
end

function M:playAnimation1()
  local frames = display.newFrames("nengliang%d.png", 1, 20)
  local animation = display.newAnimation(frames, 0.05)
  local emptyPic = display.newSprite():pos(self.mArmature:getPositionX(), self.mArmature:getPositionY() + 80):scale(2):addTo(self.mBg, 10)
  emptyPic:playAnimationOnce(animation, true, function()
    self:playAnimation2()
  end)
end

function M:playAnimation2()
  local pos = cc.p(self.mArmature:getPositionX(), self.mArmature:getPositionY() + 180)
  local pLight = display.newSprite("upgrade/light.png"):scale(5):pos(pos.x, pos.y - 180):addTo(self.mBg)
  pLight:runAction(cc.RepeatForever:create(cc.RotateBy:create(15, 360)))
  local frames = display.newFrames("nenglsk%d.png", 1, 30)
  local animation = display.newAnimation(frames, 0.05)
  local emptyPic = display.newSprite():pos(pos.x, pos.y):scale(2):addTo(self.mBg, 10)
  emptyPic:playAnimationOnce(animation, true, function()
    self.mBackBtn:setButtonEnabled(true)
    self.mBg:setTouchEnabled(true)
  end)
  if self.mModelId ~= self.mBuddhaModel.npcModelId then
    self.mArmature:removeSelf()
    self.mArmature = nil
    local fi = self.mBuddhaModel.armatureFile
    local pArmatureFile = string.format("armature/%s/%s.csb", fi, fi)
    DYRes.loadFileInfo(pArmatureFile, self.mFileInfo)
    self.mArmature = ccs.Armature:create(fi)
    self.mArmature:setPosition(self.mBg:getContentSize().width * 0.48, self.mBg:getContentSize().height * 0.45 + self.mBuddhaModel.upMove)
    self.mArmature:setScale(self.mBuddhaModel.zoomMultiple)
    self.mArmature:getAnimation():playWithIndex(1)
    if 0 == self.mBuddhaModel.isRebel then
      self.mArmature:setScaleX(-1 * self.mBuddhaModel.zoomMultiple)
    end
    self.mBg:addChild(self.mArmature, 3)
  end
  local frames1 = display.newFrames("guangsufs%d.png", 1, 21)
  local animation1 = display.newAnimation(frames1, 0.05)
  local emptyPic1 = display.newSprite():pos(pos.x, pos.y - 100):scale(6):addTo(self.mBg, 1)
  emptyPic1:playAnimationForever(animation1, 0)
  local frames2 = display.newFrames("%d.png", 1, 15)
  local animation2 = display.newAnimation(frames2, 0.05)
  local emptyPic2 = display.newSprite():pos(pos.x, pos.y):scale(2):addTo(self.mBg, 1)
  emptyPic2:playAnimationOnce(animation2, true, function()
    self:playAnimation3()
  end)
  self:breakInfoShow()
end

function M:playAnimation3()
  local pos = cc.p(self.mArmature:getPositionX(), self.mArmature:getPositionY() + 180)
  local frames = display.newFrames("nizixg%d.png", 1, 22)
  local animation = display.newAnimation(frames, 0.1)
  local emptyPic = display.newSprite():pos(pos.x, pos.y - 20):scale(2):addTo(self.mBg, 10)
  emptyPic:playAnimationForever(animation, 0)
end

function M:breakInfoShow()
  local index = 1
  local tb = {
    DYLang.getString("S543", ""),
    DYLang.getString("S544", ""),
    DYLang.getString("S545", ""),
    DYLang.getString("S546", ""),
    DYLang.getString("S547", ""),
    DYLang.getString("S548", ""),
    DYLang.getString("S549", ""),
    DYLang.getString("S550", ""),
    DYLang.getString("S551", ""),
    DYLang.getString("S552", "")
  }
  for i = 1, 4 do
    local name = DYLabelTTF.new({
      text = tb[i],
      size = 25,
      color = cc.c3b(249, 189, 96),
      font = GameManager.FONTNAME_TTF,
      dyalign = "CENTER_RIGHT"
    }):pos(1000, 700 - 40 * i):addTo(self.mBg, 4)
    local rate = (self.mBreakTimes + 1) * 4
    local numLabel = DYLabelTTF.new({
      text = math.round(self.mBreakAddParam[i] * rate),
      size = 25,
      color = display.COLOR_GREEN,
      font = GameManager.FONTNAME_TTF,
      dyalign = "CENTER_LEFT"
    }):pos(name:getPositionX(), name:getPositionY()):addTo(self.mBg, 4)
    display.newSprite("upgrade/up.png"):pos(name:getPositionX() + 130, name:getPositionY()):addTo(self.mBg, 4)
    index = index + 1
  end
  for i = 5, 8 do
    local addType = self.mBreakData.addType[i - 4]
    local addNum = self.mBreakData.addNum[i - 4]
    if addType then
      local name = DYLabelTTF.new({
        text = tb[addType - 1],
        size = 25,
        color = cc.c3b(249, 189, 96),
        font = GameManager.FONTNAME_TTF,
        dyalign = "CENTER_RIGHT"
      }):pos(1000, 700 - 40 * i):addTo(self.mBg, 4)
      local numLabel = DYLabelTTF.new({
        text = addNum .. "%",
        size = 25,
        color = display.COLOR_GREEN,
        font = GameManager.FONTNAME_TTF,
        dyalign = "CENTER_LEFT"
      }):pos(name:getPositionX(), name:getPositionY()):addTo(self.mBg, 4)
      display.newSprite("upgrade/up.png"):pos(name:getPositionX() + 130, name:getPositionY()):addTo(self.mBg, 4)
      index = index + 1
    end
  end
  local lb = DYLabelTTF.new({
    text = DYLang.getString("S553", ""),
    size = 25,
    color = cc.c3b(249, 189, 96),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_RIGHT"
  }):pos(1000, 680 - 40 * index):addTo(self.mBg, 4)
  local rateNum1 = (self.mBreakTimes + 1) * (self.mBreakAddParam[1] / 100 + self.mBreakAddParam[2] / 20 + self.mBreakAddParam[3] / 4 + self.mBreakAddParam[4] / 4)
  local rateNum2 = (self.mBreakTimes + 2) * (self.mBreakAddParam[1] / 100 + self.mBreakAddParam[2] / 20 + self.mBreakAddParam[3] / 4 + self.mBreakAddParam[4] / 4)
  DYLabelTTF.new({
    text = string.format("%.1f", rateNum1),
    size = 25,
    color = display.COLOR_WHITE,
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):pos(lb:getPositionX(), lb:getPositionY()):addTo(self.mBg, 4)
  DYLabelTTF.new({
    text = string.format("%.1f", rateNum2),
    size = 25,
    color = display.COLOR_GREEN,
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):pos(lb:getPositionX() + 105, lb:getPositionY()):addTo(self.mBg, 4)
  display.newSprite("upgrade/to.png"):pos(lb:getPositionX() + 70, lb:getPositionY()):scale(0.5):addTo(self.mBg, 4)
  display.newSprite("upgrade/line_up.png", 1020, 690):addTo(self.mBg, 4)
  display.newSprite("upgrade/line_down.png", 1020, lb:getPositionY() - 30):addTo(self.mBg, 4)
end

function M:closeCallBack()
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  self.mHandler(self.mBuddhaModel, self.mParams)
  self:removeSelf()
end

function M:dealUserGuide()
  local stageProgress = Const.STAGE_PROGRESS or CloudData.MAIN_STAGE_PROGRESS
  local userLevel = CloudData.USER_LEVEL
end

function M:onKeypad(keyCode, event)
  DDLOG("Key %d was on pressed!", keyCode)
  if keyCode == cc.KeyCode.KEY_ESCAPE then
    return true
  end
  return false
end

function M:onEnter()
  DYKeypadMgr.regKeyHandler(self.mKeypadListener)
end

function M:onExit()
  DYKeypadMgr.unregKeyHandler(self.mKeypadListener)
  DYRes.unloadFileInfo(self.mFileInfo)
  self.mFileInfo = {}
  DYRes.unloadSheet("upgrade/break_tx.plist")
  DYRes.unloadSheet("upgrade/break_tx1.plist")
  DYRes.unloadSheet("upgrade/break_tx2.plist")
  DYRes.unloadSheet("upgrade/break_tx3.plist")
  DYRes.unloadSheet("upgrade/break_tx4.plist")
  DYRes.unloadSheet("upgrade/break_tx5.plist")
end

return M
