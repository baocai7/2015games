local LayerPlaceBattle = require("app.activity.place.LayerPlaceBattle")
local LayerPlaceRankList = require("app.activity.place.LayerPlaceRankList")
local LayerPlaceGetReward = require("app.activity.place.LayerPlaceGetReward")
local LayerPlacePreReward = require("app.activity.place.LayerPlacePreReward")
local WSToast = require("app.utils.WSToast")
local PanelTimer = require("app.activity.place.PanelTimer")
local LayerRule = require("app.layers.LayerRule")
local M = {}
M = class("LayerPlaceMain", function()
  return display.newLayer()
end)
local TYPE_LIST = {
  [1] = "nian",
  [3] = "duanwu"
}
local ACT_TYPE = TYPE_LIST[CloudData.FESTIVAL_ACT_TYPE]

function M:ctor()
  self.mNode = display.newNode():addTo(self, 1)
  self.mBg = display.newSprite(string.format("new_year/place/place_bg_%s.png", ACT_TYPE)):addTo(self.mNode)
  local layerPlaceBattle = LayerPlaceBattle.new({type = ACT_TYPE})
  layerPlaceBattle:align(display.CENTER, self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.6)
  layerPlaceBattle:addTo(self.mBg)
  self.mBattleLayer = layerPlaceBattle
  self.mDataTable = {}
  
  local function tFuncListener()
    self:initData()
  end
  
  local power = M.getAllBuddhaCE()
  local strAppSecret = "AFDASDFA47#$%@568%^076"
  local strSign = string.format("%s&power=%s&token=%s&uid=%s", strAppSecret .. "", power .. "", CloudData.TOKEN .. "", CloudData.UID .. "")
  local params = {}
  params.power = power
  params.sign = crypto.md5(strSign, false)
  DYHttpMgr.requestUpdateFullPower(tFuncListener, params)
end

local function M_createDpsIcon(dpsLabel)
  local node = display.newNode()
  local icon = display.newSprite(string.format("new_year/place/dps_%s.png", ACT_TYPE)):addTo(node)
  node.dpsNumber = cc.ui.UILabel.new({
    UILabelType = 1,
    text = string.format(dpsLabel),
    font = "fonts/greenNum.fnt"
  }):scale(0.7):align(display.LEFT_CENTER, icon:getContentSize().width * 0.3, 0):addTo(node, 1)
  return node
end

local function M_createLabel(str1, str2)
  local node = display.newNode()
  node.label1 = DYLabelTTF.new({
    text = "" .. str1,
    size = 26,
    color = cc.c3b(73, 43, 0),
    font = GameManager.FONTNAME_TTF
  })
  node.label1:align(display.LEFT_CENTER, -100, 0)
  node.label1:addTo(node)
  node.label2 = DYLabelTTF.new({
    text = "" .. str2,
    size = 24,
    color = display.COLOR_GREEN,
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(25, 30, 3)
  })
  node.label2:align(display.LEFT_CENTER, 10, 0)
  node.label2:addTo(node)
  
  function node:setString(str)
    node.label2:setString(str)
  end
  
  function node:getString()
    return node.label2:getString()
  end
  
  return node
end

local function M_createRankTableInfo(rankNum, rankName, rankDam)
  local width, height = 282, 35
  local sp = display.newNode()
  sp:size(width, height)
  local label1 = DYLabelTTF.new({
    text = "" .. rankNum,
    size = 20,
    color = cc.c3b(255, 178, 43),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(25, 30, 3)
  }):align(display.LEFT_CENTER, width * 0.1, 0):addTo(sp)
  local label2 = DYLabelTTF.new({
    text = "" .. rankName,
    size = 20,
    color = cc.c3b(247, 221, 156),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(25, 30, 3)
  }):align(display.LEFT_CENTER, width * 0.3, 0):addTo(sp)
  local label3 = DYLabelTTF.new({
    text = "" .. rankDam,
    size = 20,
    color = cc.c3b(76, 234, 60),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(25, 30, 3)
  }):align(display.LEFT_CENTER, width * 0.7, 0):addTo(sp)
  sp.mLabel1 = label1
  sp.mLabel2 = label2
  sp.mLabel3 = label3
  
  function sp:refresh(rankNum, rankName, rankDam)
    sp.mLabel1:setString(rankNum)
    sp.mLabel2:setString(rankName)
    sp.mLabel3:setString(rankDam)
  end
  
  return sp
end

local function M_createRankTable(tb)
  local sp = display.newNode()
  sp:size(282, 116)
  local rankTitle = display.newSprite(string.format("new_year/place/top3_%s.png", ACT_TYPE)):pos(0, 75):addTo(sp)
  local frame = display.newScale9Sprite("new_year/place/frame282_116.png", 0, 0, cc.size(282, 116), cc.rect(40, 40, 1, 1)):addTo(sp)
  sp.textList = {}
  for i = 1, #tb do
    local tmp = M_createRankTableInfo(i, tb[i].nick, tb[i].hurt):pos(-141, 30 - 33 * (i - 1)):addTo(sp)
    table.insert(sp.textList, tmp)
  end
  return sp
end

function M:createBombIcon(value, count, maxCount)
  local normalImg = string.format("new_year/place/bomb_%s1.png", ACT_TYPE)
  local pressedImg = string.format("new_year/place/bomb_%s2.png", ACT_TYPE)
  local node = display.newNode()
  local icon = cc.ui.UIPushButton.new({normal = normalImg, pressed = pressedImg}):pos(0, 0):addTo(node):onButtonClicked(function()
    self:bombBtnTouch()
  end)
  local labelIcon = display.newSprite("new_year/place/cost_peach.png"):pos(0, -icon:getContentSize().height - 40):addTo(node, 1)
  node.mLabel = DYLabelTTF.new({
    text = value .. "",
    size = 20,
    color = cc.c3b(255, 178, 43),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(25, 30, 3)
  }):pos(labelIcon:getContentSize().width * 0.7, labelIcon:getContentSize().height * 0.4):addTo(labelIcon, 2)
  node.mCount = cc.ui.UILabel.new({
    UILabelType = 1,
    text = string.format("%d/%d", count, maxCount),
    font = "fonts/yellowNum.fnt"
  }):scale(0.55):align(display.CENTER_LEFT, labelIcon:getContentSize().width * 0.5, 0):addTo(node, 4)
  return node
end

function M:createInspireIcon(value, count)
  local node = display.newNode()
  local icon = cc.ui.UIPushButton.new({
    normal = "new_year/place/inspire.png",
    pressed = "new_year/place/inspire2.png"
  }):pos(0, 0):addTo(node):onButtonClicked(function()
    self:inspireBtnTouch()
  end)
  local labelIcon = display.newSprite("new_year/place/cost_peach.png"):pos(0, -icon:getContentSize().height - 40):addTo(node, 1)
  node.mLabel = DYLabelTTF.new({
    text = value .. "",
    size = 20,
    color = cc.c3b(255, 178, 43),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(25, 30, 3)
  }):pos(labelIcon:getContentSize().width * 0.7, labelIcon:getContentSize().height * 0.4):addTo(labelIcon, 2)
  node.mCount = cc.ui.UILabel.new({
    UILabelType = 1,
    text = string.format("*%d", count),
    font = "fonts/yellowNum.fnt"
  }):scale(0.55):align(display.CENTER_LEFT, labelIcon:getContentSize().width * 0.5, 0):addTo(node, 4)
  return node
end

function M:initUI()
  cc.ui.UIPushButton.new({
    normal = "common_ui/close_normal.png",
    pressed = "common_ui/close_pressed.png"
  }):align(display.TOP_RIGHT, self.mBg:getContentSize().width * 0.99, self.mBg:getContentSize().height * 0.99):addTo(self.mBg, 2):onButtonClicked(function()
    self:closeCallBack()
  end)
  LayerRule.newRuleIcon(LayerRule.PLACE):align(display.CENTER, self.mBg:getContentSize().width * 0.05, self.mBg:getContentSize().height * 0.95):addTo(self.mBg)
  self.mBoxBtn = cc.ui.UIPushButton.new({
    normal = "new_year/place/box1.png",
    pressed = "new_year/place/box2.png"
  }):align(display.CENTER, self.mBg:getContentSize().width * 0.153, self.mBg:getContentSize().height * 0.44):addTo(self.mBg, 5):onButtonClicked(function()
    LayerPlaceGetReward.new():pos(-display.cx, -display.cy):addTo(self.mNode)
    self.mBoxBtn:hide()
  end)
  if self.mDataTable.canReward == 0 then
    self.mBoxBtn:hide()
  end
  cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal.png",
    pressed = "common_ui/btn_pressed.png"
  }):setButtonLabel("normal", DYLabelTTF.new({
    text = "\229\165\150\229\138\177\233\162\132\232\167\136",
    size = 26,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(25, 30, 3)
  })):onButtonClicked(function()
    LayerPlacePreReward.new(1, ACT_TYPE):pos(-display.cx, -display.cy):addTo(self.mNode, 20)
  end):scale(0.8):align(display.CENTER, self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.17):addTo(self.mBg)
  cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal.png",
    pressed = "common_ui/btn_pressed.png"
  }):setButtonLabel("normal", DYLabelTTF.new({
    text = "\230\142\146\232\161\140\230\166\156",
    size = 26,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(25, 30, 3)
  })):onButtonClicked(function()
    LayerPlaceRankList.new({type = ACT_TYPE}):addTo(self.mNode, 50)
  end):scale(0.8):align(display.CENTER, self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.28):addTo(self.mBg)
  self.mMyDpsLabel = M_createDpsIcon(self.mDpsNumber):align(display.CENTER, self.mBg:getContentSize().width * 0.73, self.mBg:getContentSize().height * 0.17):addTo(self.mBg)
  self.mTop3List = M_createRankTable(self.mDataTable.rankList):align(display.LEFT_BOTTOM, 230, 140):addTo(self.mBg)
  self.myRank = M_createLabel("\230\136\145\231\154\132\230\142\146\229\144\141", self.mDataTable.myRank):align(display.CENTER, self.mBg:getContentSize().width * 0.75, self.mBg:getContentSize().height * 0.3):addTo(self.mBg)
  local textStr = {
    nian = "\230\136\145\231\154\132\228\188\164\229\174\179",
    duanwu = "\230\136\145\231\154\132\232\136\170\231\168\139"
  }
  self.mMyHarmLabel = M_createLabel(textStr[ACT_TYPE], self.mDataTable.harmSum):align(display.CENTER, self.mBg:getContentSize().width * 0.75, self.mBg:getContentSize().height * 0.25):addTo(self.mBg)
  self.mInspireBtn = self:createInspireIcon(self.mDataTable.inspireNextCost, self.mDataTable.inspireTimes):align(display.CENTER, self.mBg:getContentSize().width * 0.8, self.mBg:getContentSize().height * 0.45):addTo(self.mBg)
  self.mBombBtn = self:createBombIcon(self.mDataTable.marroonNextCost, 50 - self.mDataTable.marroonTimes, 50):align(display.CENTER, self.mBg:getContentSize().width * 0.63, self.mBg:getContentSize().height * 0.45):addTo(self.mBg)
  local timerPanel = PanelTimer.new(self.mDataTable.leftTime, function()
    self:timeUp()
  end):align(display.CENTER, display.width * 0.16, display.height * 0.75):addTo(self.mBg)
end

function M:initData()
  self.mCount = 0
  
  local function tFuncListener(jsonTable)
    self.mDataTable.harmSum = tonumber(jsonTable.data.hurt)
    self.mDataTable.inspireTimes = tonumber(jsonTable.data.inspireTimes)
    self.mDataTable.leftinspireTimes = tonumber(jsonTable.data.leftinspireTimes)
    self.mDataTable.inspireNextCost = tonumber(jsonTable.data.inspireNextCost)
    self.mDataTable.marroonNextCost = tonumber(jsonTable.data.marroonNextCost)
    self.mDataTable.marroonTimes = tonumber(jsonTable.data.marroonTimes)
    self.mDataTable.leftMarroonTimes = tonumber(jsonTable.data.leftMarroonTimes)
    self.mDataTable.myRank = tonumber(jsonTable.data.myRank)
    self.mDataTable.rankList = jsonTable.data.rankList
    self.mDataTable.canReward = tonumber(jsonTable.data.canReward)
    self.mDataTable.leftTime = tonumber(jsonTable.data.leftTime)
    self.mRawDps = tonumber(jsonTable.data.power)
    self.mDpsNumber = math.floor(self.mRawDps * (1 + self.mDataTable.inspireTimes * 0.1))
    self:initUI()
    self:schedule(function()
      self:update()
    end, 1)
  end
  
  local params = {}
  DYHttpMgr.requestPlaceActiveInit(tFuncListener)
end

function M:update()
  self.mCount = self.mCount + 1
  self:playerHarmAction(self.mDpsNumber)
  if self.mCount >= 10 then
    self:refreshRank()
    self.mCount = 0
  end
end

function M:playerHarmAction(num)
  local currNum = tonumber(self.mDataTable.harmSum)
  self.mDataTable.harmSum = self.mDataTable.harmSum + num
  local currNum1 = currNum + num
  local ac = transition.sequence({
    DYRollnum:create(0.5, currNum, currNum1)
  })
  self.mMyHarmLabel.label2:runAction(ac)
end

function M:playerDpsAction(num)
  local currNum = tonumber(self.mDpsNumber)
  self.mDpsNumber = self.mDpsNumber + num
  local currNum1 = currNum + num
  local ac = transition.sequence({
    DYRollnum:create(0.5, currNum, currNum1)
  })
  self.mMyDpsLabel.dpsNumber:runAction(ac)
end

function M:closeCallBack()
  DYRes.unloadFileInfo(GameData.S_FILE_INFO)
  GameData.S_FILE_INFO = {}
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  if self.cb then
    self.cb()
  end
  display.replaceScene(require("scenes.ChapterScene").new())
end

function M:refreshRank()
  local function tFuncListener(jsonTable)
    self.mDataTable.rankList = jsonTable.data.rankList
    
    DDLOG(#self.mTop3List.textList)
    for i = 1, #self.mTop3List.textList do
      self.mTop3List.textList[i]:refresh(i, jsonTable.data.rankList[i].nick, jsonTable.data.rankList[i].hurt)
    end
    self.myRank:setString(jsonTable.data.myRank)
  end
  
  DYHttpMgr.requestRankFresh(tFuncListener)
end

function M:bombBtnTouch()
  self.mBombBtn:setTouchEnabled(false)
  
  local function tFuncListener(jsonTable)
    self.mBombBtn:setTouchEnabled(true)
    if jsonTable.errorCode > 0 then
      local toast = WSToast.new(jsonTable.errorMsg or "UNKONWN", 2)
      self.mBg:addChild(toast, 60)
    else
      DYSoundMgr.playEffect(DY_SND.sfx_bianpao)
      self.mBombBtn.mCount:setString(string.format("%d/%d", 50 - jsonTable.data.useTimes, 50))
      local animationName, animationIndex, isMove = "", 0, false
      if ACT_TYPE == "nian" then
        animationName = "paozhuzha"
        self:performWithDelay(function()
          self.mBattleLayer.mBoss.mState = "Hurt"
        end, 0.6)
      else
        animationName, animationIndex, isMove = "longzhou", 3, true
        self:performWithDelay(function()
          self.mBattleLayer:onSpeedUp()
        end, 0.6)
      end
      local animation = M.createAnimation(animationName, cb)
      animation:setPosition(display.width * 0.45, display.height * 0.4)
      animation:addTo(self.mBg, 60)
      animation:getAnimation():playWithIndex(animationIndex)
      if isMove then
        animation:moveTo(1, 0, display.height * 0.55)
      end
      self:playerHarmAction(jsonTable.data.harm)
      self.mBombBtn.mLabel:setString(jsonTable.data.nextCost .. "")
      self:performWithDelay(function()
        self:showCriNumber(jsonTable.data.harm)
      end, 0.6)
    end
  end
  
  DYHttpMgr.requestPlaceActiveBomb(tFuncListener, nil)
end

function M:inspireBtnTouch()
  self.mInspireBtn:setTouchEnabled(false)
  
  local function tFuncListener(jsonTable)
    self.mInspireBtn:setTouchEnabled(true)
    if jsonTable.errorCode > 0 then
      local toastMsg = jsonTable.errorMsg or "UNKONWN"
      local toast = WSToast.new(toastMsg, 2)
      self.mBg:addChild(toast, 60)
    else
      DYSoundMgr.playEffect(DY_SND.sfx_guwu)
      self.mInspireBtn.mCount:setString(string.format("*%d", jsonTable.data.useTimes))
      local animation = M.createAnimation("nianguai1")
      animation:setPosition(display.width * 0.65, display.height * 0.4)
      animation:scale(0.6)
      animation:setScaleX(-0.6)
      animation:addTo(self.mBg, 60)
      animation:getAnimation():playWithIndex(4)
      self:playerDpsAction(math.floor(self.mRawDps * 0.1))
      self.mInspireBtn.mLabel:setString(jsonTable.data.nextCost .. "")
      self.mBattleLayer:addATKBuff()
    end
  end
  
  DYHttpMgr.requestPlaceActiveInspire(tFuncListener, nil)
end

function M:showCriNumber(damage)
  local tmpNode = SpriteViewMgr.showDamage(damage, 5)
  tmpNode:setScale(1)
  tmpNode:setPosition(display.width * 0.3, display.height * 0.8)
  tmpNode:setCascadeOpacityEnabled(true)
  local spawn = cc.Spawn:create(cc.MoveBy:create(1.2, cc.p(0, 120)), cc.FadeOut:create(1.2))
  tmpNode:runAction(transition.sequence({
    spawn,
    cc.CallFunc:create(function()
      tmpNode:removeSelf()
    end)
  }))
  tmpNode:addTo(self.mBg, 50)
end

function M:timeUp()
  require("app.activity.place.LayerPlaceMain").new():addTo(self:getParent(), 20)
  self:runAction(cc.RemoveSelf:create())
end

function M.getAllBuddhaCE()
  local totalBuddhaCE = 0
  local tableNpcModel = {}
  local npcNumTotal = #DataRetainer.BUDDHA_INFO - 1
  for id = 1, npcNumTotal do
    tableNpcModel[#tableNpcModel + 1] = DataUtils.getBuddhaModel(id, true)
  end
  local tempTable2 = {}
  for i = 1, #tableNpcModel do
    local npcModel = tableNpcModel[i]
    if 1 == npcModel.buddhaState or 2 == npcModel.buddhaState then
      totalBuddhaCE = totalBuddhaCE + npcModel.attackAssessment
    end
  end
  return math.floor(math.sqrt(totalBuddhaCE))
end

function M.createAnimation(modelName, cb)
  ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(string.format("armature/%s/%s.csb", modelName, modelName))
  local armature = ccs.Armature:create(modelName)
  
  local function animationEvent(armatureBack, movementType, movementID)
    local id = movementID
    if movementType == ccs.MovementEventType.complete then
      armature:removeFromParent()
      if cb then
        cb()
      end
    end
  end
  
  armature:getAnimation():setMovementEventCallFunc(animationEvent)
  return armature
end

return M
