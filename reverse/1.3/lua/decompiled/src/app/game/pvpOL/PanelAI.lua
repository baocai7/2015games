local M = {}
M = class("PanelAI", function()
  return display.newNode()
end)
M.FRAME_SEC = 0.02
M.CIMELIA_CD_RATE = 2
M.SPIRIT_NUM = 1001
M.BUDDHA_CARD = 1002
M.WAND_SKILL = 1003
M.TOWER_SKILL = 1004

function M:ctor(callback)
  self.mCallback = callback
  self:initData()
  self:schedule(handler(self, self.updateLogic), 0.020833333333333332)
  self:setNodeEventEnabled(true)
end

function M:initData()
  self.mMode = CloudData.COMPETE_MODE
  M.FRAME_SEC = 1 / GameData.FRAME_PER_SECOND
  self:initSpiritData()
  self:initTeamData()
  self:initCimeliaData()
end

function M:initSpiritData()
  self.mSpiritLevel = 1
  self.mMaxSpiritLevel = #DataRetainer.SPIRIT_INFO - 1
  self.mSpiritModel = DataUtils.getSpiritModelForAI(self.mSpiritLevel)
  self.mCostNum = self.mSpiritModel.costNum
  self.mMaxSpirit = self.mSpiritModel.limitNum + Const.MaxSpirit + GameData.getSpiritLimit()
  self.mSpiritSpeed = self.mSpiritModel.growSpeed * 10
  self.mCanUpSpirit = false
  self.mIsFullSpirit = false
  self.mCurrentSpirit = Const.PVPCurSprite or 0
  if self.mCurrentSpirit >= self.mMaxSpirit then
    self.mCurrentSpirit = self.mMaxSpirit
  end
  if self.mCurrentSpirit >= self.mCostNum then
    self.mCanUpSpirit = true
  end
end

function M:initTeamData()
  local tFunc = {
    [Const.GameType.NomalType] = function()
      self:normalTeam()
    end,
    [Const.GameType.CardType] = function()
      self:cardTeam()
    end
  }
  tFunc[self.mMode]()
end

function M:initCimeliaData()
  self.mCimeliaData = {}
  local atkCimelia = {
    cd = GameData.CIMELIA_ATK_ENEMY.skillCDTime * M.CIMELIA_CD_RATE,
    tags = GameData.CIMELIA_ATK_ENEMY.aiTags,
    isValid = false
  }
  local defCimelia = {
    cd = GameData.CIMELIA_DEF_ENEMY.skillCDTime * M.CIMELIA_CD_RATE,
    tags = GameData.CIMELIA_DEF_ENEMY.aiTags
  }
  self.mCimeliaData = {atkCimelia = atkCimelia, defCimelia = defCimelia}
end

function M:normalTeam()
  self.mTeamData = {}
  for i = 1, #CloudData.ENEMY_ATTACK_TEAM do
    local buddhaId = CloudData.ENEMY_ATTACK_TEAM[i]
    local buddhaData = DataUtils.getBuddhaModelForAI(buddhaId)
    buddhaData.cd = buddhaData.cdTime
    buddhaData.isReady = false
    table.insert(self.mTeamData, buddhaData)
  end
end

function M:cardTeam()
  local tempTable = {}
  self.mCardArray = {}
  for i = 1, #CloudData.ENEMY_ATTACK_TEAM do
    local buddhaId = CloudData.ENEMY_ATTACK_TEAM[i]
    local buddhaData = DataUtils.getBuddhaModelForAI(buddhaId)
    buddhaData.cd = 0
    buddhaData.isReady = false
    buddhaData.tag = M.BUDDHA_CARD
    table.insert(tempTable, buddhaData)
    table.insert(tempTable, buddhaData)
  end
  local cimeliaModel1 = GameData.CIMELIA_ATK_ENEMY
  cimeliaModel1.cd = 0
  cimeliaModel1.isReady = false
  cimeliaModel1.tag = M.WAND_SKILL
  cimeliaModel1.cost = Const.CardMode.CimeliaAtkCost
  table.insert(tempTable, cimeliaModel1)
  local cimeliaModel2 = GameData.CIMELIA_DEF_ENEMY
  cimeliaModel2.cd = 0
  cimeliaModel2.isReady = false
  cimeliaModel2.tag = M.TOWER_SKILL
  cimeliaModel2.cost = Const.CardMode.CimeliaDefCost
  table.insert(tempTable, cimeliaModel2)
  local spiritModel = {
    cost = 0,
    value = Const.CardMode.SpiritRecover,
    cd = 0,
    isReady = false,
    tag = M.SPIRIT_NUM,
    aiTags = ""
  }
  table.insert(tempTable, spiritModel)
  table.insert(tempTable, spiritModel)
  for i = 1, #tempTable do
    local endNum = #tempTable + 1 - i
    local randomNum = math.random(1, endNum)
    self.mCardArray[i] = tempTable[randomNum]
    tempTable[randomNum] = tempTable[endNum]
  end
  self.mNewCardArr = {}
  self.mIndex = 7
  self.mTeamData = {}
  for i = 1, self.mIndex do
    local info = self.mCardArray[i]
    table.insert(self.mTeamData, info)
  end
end

function M:updateLogic()
  self:checkSpiritPool()
  self:checkBuddhaStatus()
  self:checkCimeliaStatus()
end

function M:checkSpiritPool()
  if self.mCurrentSpirit >= self.mMaxSpirit then
    self.mCurrentSpirit = self.mMaxSpirit
    self.mIsFullSpirit = true
    return
  end
  self.mIsFullSpirit = false
  self.mCurrentSpirit = self.mCurrentSpirit + M.FRAME_SEC * self.mSpiritSpeed
  if self.mSpiritLevel < self.mMaxSpiritLevel and self.mCurrentSpirit >= self.mCostNum then
    self.mCanUpSpirit = true
  end
end

function M:checkBuddhaStatus()
  for i = 1, #self.mTeamData do
    local buddhaData = self.mTeamData[i]
    buddhaData.cd = buddhaData.cd - M.FRAME_SEC
    if buddhaData.cd <= 0 then
      buddhaData.cd = 0
    end
    if self.mCurrentSpirit >= buddhaData.cost and 0 == buddhaData.cd then
      buddhaData.isReady = true
    else
      buddhaData.isReady = false
    end
  end
end

function M:checkCimeliaStatus()
  self.mCimeliaData.atkCimelia.cd = self.mCimeliaData.atkCimelia.cd - M.FRAME_SEC
  self.mCimeliaData.defCimelia.cd = self.mCimeliaData.defCimelia.cd - M.FRAME_SEC
  self.mCimeliaData.atkCimelia.isValid = self:isCimeliaAtkValid()
  if self.mCimeliaData.atkCimelia.cd <= 0 then
    self.mCimeliaData.atkCimelia.cd = 0
  end
  if self.mCimeliaData.defCimelia.cd <= 0 then
    self.mCimeliaData.defCimelia.cd = 0
  end
end

function M:upgradeSpirit()
  self.mSpiritLevel = self.mSpiritLevel + 1
  self:updateSpirit(self.mCostNum)
  self.mCanUpSpirit = false
  if self.mSpiritLevel > self.mMaxSpiritLevel then
    return
  end
  self.mSpiritModel = DataUtils.getSpiritModelForAI(self.mSpiritLevel)
  self.mCostNum = self.mSpiritModel.costNum
  self.mMaxSpirit = self.mSpiritModel.limitNum + Const.MaxSpirit + GameData.getSpiritLimit()
  self.mSpiritSpeed = self.mSpiritModel.growSpeed * 10
end

function M:createBuddha(params)
  local tFunc = {
    [Const.GameType.NomalType] = function()
      self:createBuddhaNormal(params)
    end,
    [Const.GameType.CardType] = function()
      self:createBuddhaCard(params)
    end
  }
  tFunc[self.mMode]()
end

function M:playCimelia(params)
  if "atk" == params.cimeliaType then
    self.mCimeliaData.atkCimelia.cd = GameData.CIMELIA_ATK_ENEMY.skillCDTime * M.CIMELIA_CD_RATE
  else
    self.mCimeliaData.defCimelia.cd = GameData.CIMELIA_DEF_ENEMY.skillCDTime * M.CIMELIA_CD_RATE
  end
end

function M:createBuddhaNormal(params)
  DYSoundMgr.playEffect(DY_SND.sfx_buddha_makeup)
  local buddhaData = self.mTeamData[params.idx]
  BMgrOL.createPVPMonster(buddhaData.buddhaId)
  buddhaData.cd = buddhaData.cdTime
  buddhaData.isReady = false
  self:updateSpirit(buddhaData.cost)
end

function M:createBuddhaCard(params)
  self.mIndex = self.mIndex + 1
  if self.mIndex > #self.mCardArray then
    self.mIndex = 1
    self.mCardArray = clone(self.mNewCardArr)
    self.mNewCardArr = {}
  end
  local info = self.mTeamData[params.idx]
  table.insert(self.mNewCardArr, info)
  table.remove(self.mTeamData, params.idx)
  local newInfo = self.mCardArray[self.mIndex]
  newInfo.isReady = false
  table.insert(self.mTeamData, newInfo)
  self:updateSpirit(info.cost)
  local tFunc = {
    [M.SPIRIT_NUM] = function()
      self:cardSpiritUse(info.value)
    end,
    [M.BUDDHA_CARD] = function()
      self:cardBuddhaUse(info.buddhaId)
    end,
    [M.WAND_SKILL] = function()
      self:cardWandUse()
    end,
    [M.TOWER_SKILL] = function()
      self:cardTowerUse()
    end
  }
  tFunc[info.tag]()
end

function M:cardSpiritUse(value)
  DYSoundMgr.playEffect(DY_SND.sfx_lq_upgrade)
  self.mCurrentSpirit = self.mCurrentSpirit + value
end

function M:cardBuddhaUse(buddhaId)
  DYSoundMgr.playEffect(DY_SND.sfx_buddha_makeup)
  BMgrOL.createPVPMonster(buddhaId)
end

function M:cardWandUse()
  self.mCallback({
    tag = M.WAND_SKILL
  })
end

function M:cardTowerUse()
  self.mCallback({
    tag = M.TOWER_SKILL
  })
end

function M:updateSpirit(value)
  self.mCurrentSpirit = self.mCurrentSpirit - value
  self.mCanUpSpirit = false
  if self.mCurrentSpirit >= self.mCostNum then
    self.mCanUpSpirit = true
  end
end

function M:isCimeliaAtkValid()
  local bRes = false
  if self.mCimeliaData.atkCimelia.cd > 0 then
    return bRes
  end
  local atkDis = GameData.CIMELIA_ATK_ENEMY.atkDistance
  local enemys = BMgrOL.getBuddhaList()
  local towerX = BMgrOL.getMonsterPos().x
  for k, enemy in pairs(enemys) do
    local dist = enemy:getPositionX() - towerX
    if atkDis >= dist then
      bRes = true
      break
    end
  end
  return bRes
end

function M:getCurrSpiritNum()
  return self.mCurrentSpirit
end

function M:getSpiritLevel()
  return self.mSpiritLevel
end

function M:isSpiritFull()
  return self.mIsFullSpirit
end

function M:isSpiritMaxLevel()
  return self.mSpiritLevel == self.mMaxSpiritLevel
end

function M:isCanUpSpirit()
  return self.mCanUpSpirit
end

function M:getCurrTeamData()
  return self.mTeamData
end

function M:getCimeliaData()
  return self.mCimeliaData
end

function M:updateSpiritLevel(deltaLevel)
  if 1 == self.mSpiritLevel and deltaLevel < 0 then
    return
  end
  if self.mMaxSpiritLevel == self.mSpiritLevel and 0 < deltaLevel then
    return
  end
  self.mSpiritLevel = self.mSpiritLevel + deltaLevel
  if 1 >= self.mSpiritLevel then
    self.mSpiritLevel = 1
  end
  if self.mSpiritLevel >= self.mMaxSpiritLevel then
    self.mSpiritLevel = self.mMaxSpiritLevel
  end
  self.mSpiritModel = DataUtils.getSpiritModelForAI(self.mSpiritLevel)
  self.mCostNum = self.mSpiritModel.costNum
  self.mMaxSpirit = self.mSpiritModel.limitNum + Const.MaxSpirit + GameData.getSpiritLimit()
  self.mSpiritSpeed = self.mSpiritModel.growSpeed * 10
  if self.mCurrentSpirit >= self.mMaxSpirit then
    self.mCurrentSpirit = self.mMaxSpirit
  end
  if self.mCurrentSpirit >= self.mCostNum then
    self.mCanUpSpirit = true
  end
end

function M:updateSpiritValue(deltaValue)
  self.mCurrentSpirit = self.mCurrentSpirit + deltaValue
  if self.mCurrentSpirit <= 0 then
    self.mCurrentSpirit = 0
  end
end

function M:onNotify(name, param)
  if name == DY_KEY.kUpdateSpiritLevel then
    if not param.isBuddha then
      self:updateSpiritLevel(param.delta)
    end
  elseif name == DY_KEY.kUpdateSpiritValue and not param.isBuddha then
    self:updateSpiritValue(param.delta)
  end
end

function M:onEnter()
  DYNotification.registerScriptObserver(self, handler(self, self.onNotify), DY_KEY.kUpdateSpiritLevel)
  DYNotification.registerScriptObserver(self, handler(self, self.onNotify), DY_KEY.kUpdateSpiritValue)
end

function M:onExit()
  DYNotification.removeAllObservers(self)
end

return M
