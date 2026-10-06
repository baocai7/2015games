local CimeliaSkillView = import("app.sprites.pvp.CimeliaSkillView")
local FRAME_SEC = GameManager.FRAME_SEC
local DYClass = "CimeliaSkill"
local M = {}
M = class(DYClass)

function M:ctor(params)
  if "atk" == params.cimeliaType then
    self.mData = params.atk
  elseif "def" == params.cimeliaType then
    self.mData = params.def
  end
  self.mCimeliaType = params.cimeliaType
  if GameManager.MODE ~= 6 and GameManager.MODE ~= 9 then
    BMgrOL = BMgr
  end
  self.mSkillModel = DataUtils.getCimeliaSkillModel(self.mData.skillId)
  self:initData()
end

function M:initData()
  self.mCastDistance = self.mData.atkDis * Const.Zoom0 or -1
  self.mAttackType = self.mSkillModel.attackType
end

function M:getSkillEffectTargets(castPos)
  local npcList = {}
  local targetList = {}
  local getNpcList = {
    [1] = {
      [FLAG_TOWER_BUDDHA] = function()
        return BMgrOL.getMonsterList()
      end,
      [FLAG_TOWER_MONSTER] = function()
        return BMgrOL.getBuddhaList()
      end
    },
    [2] = {
      [FLAG_TOWER_BUDDHA] = function()
        return BMgrOL.getBuddhaList()
      end,
      [FLAG_TOWER_MONSTER] = function()
        return BMgrOL.getMonsterList()
      end
    }
  }
  local npcList = getNpcList[self.mSkillModel.target][self.mData.flag]()
  local maxNum = self.mSkillModel.attTargetMaxNum
  if -1 == maxNum then
    maxNum = #npcList
  end
  if #npcList == 0 then
    return {nil}
  end
  if 3 == self.mSkillModel.range then
    targetList = npcList
  elseif 1 == self.mSkillModel.range then
    for _, v in pairs(npcList) do
      if math.abs(v:getPositionX() - castPos.x) < self.mCastDistance * 0.5 then
        table.insert(targetList, v)
      end
    end
  elseif 2 == self.mSkillModel.range then
    for _, v in pairs(npcList) do
      if math.abs(v:getPositionX() - castPos.x) < self.mCastDistance then
        table.insert(targetList, v)
      end
    end
  end
  if maxNum > #targetList then
    maxNum = #targetList
  end
  targetList = {
    unpack(targetList, 1, maxNum)
  }
  return targetList
end

local function getNearestTargets(self, npcList)
  if #npcList == 0 then
    return nil
  end
  table.sort(npcList, function(a, b)
    if FLAG_TOWER_MONSTER == self.mData.flag then
      return a:getPositionX() < b:getPositionX()
    elseif FLAG_TOWER_BUDDHA == self.mData.flag then
      return a:getPositionX() > b:getPositionX()
    end
  end)
  return npcList
end

function M:getSkillCastPos()
  if 1 == self.mSkillModel.target then
    local tFunc = {
      [1] = {
        [FLAG_TOWER_BUDDHA] = function()
          local npcList = BMgrOL.getMonsterList()
          local npc = getNearestTargets(self, npcList)
          if npc then
            return cc.p(npc[1]:getPosition())
          else
            return BMgrOL.getMonsterPos()
          end
        end,
        [FLAG_TOWER_MONSTER] = function()
          local npcList = BMgrOL.getBuddhaList()
          local npc = getNearestTargets(self, npcList)
          if npc then
            return cc.p(npc[1]:getPosition())
          else
            return BMgrOL.getBuddhaPos()
          end
        end
      },
      [2] = {
        [FLAG_TOWER_BUDDHA] = function()
          return BMgrOL.getBuddhaPos()
        end,
        [FLAG_TOWER_MONSTER] = function()
          return BMgrOL.getMonsterPos()
        end
      },
      [3] = {
        [FLAG_TOWER_BUDDHA] = function()
          return cc.p(GameData.BG:getContentSize().width * 0.5, GameData.BG:getContentSize().height * 0.5)
        end,
        [FLAG_TOWER_MONSTER] = function()
          return cc.p(GameData.BG:getContentSize().width * 0.5, GameData.BG:getContentSize().height * 0.5)
        end
      }
    }
    local pos = tFunc[self.mSkillModel.range][self.mData.flag]()
    return pos
  else
    local tFunc = {
      [1] = {
        [FLAG_TOWER_BUDDHA] = function()
          local npcList = BMgrOL.getBuddhaList()
          local npc = getNearestTargets(self, npcList)
          if npc then
            return cc.p(npc[1]:getPosition())
          else
            return BMgrOL.getBuddhaPos()
          end
        end,
        [FLAG_TOWER_MONSTER] = function()
          local npcList = BMgrOL.getMonsterList()
          local npc = getNearestTargets(self, npcList)
          if npc then
            return cc.p(npc[1]:getPosition())
          else
            return BMgrOL.getMonsterPos()
          end
        end
      },
      [2] = {
        [FLAG_TOWER_BUDDHA] = function()
          return BMgrOL.getBuddhaPos()
        end,
        [FLAG_TOWER_MONSTER] = function()
          return BMgrOL.getMonsterPos()
        end
      },
      [3] = {
        [FLAG_TOWER_BUDDHA] = function()
          return cc.p(GameData.BG:getContentSize().width * 0.5, GameData.BG:getContentSize().height * 0.5)
        end,
        [FLAG_TOWER_MONSTER] = function()
          return cc.p(GameData.BG:getContentSize().width * 0.5, GameData.BG:getContentSize().height * 0.5)
        end
      }
    }
    local pos = tFunc[self.mSkillModel.range][self.mData.flag]()
    return pos
  end
end

function M:castSkill()
  local params = {}
  params.flag = self.mData.flag
  params.skillName = self.mSkillModel.name
  params.soundFile = self.mSkillModel.soundFile
  params.castPos = self:getSkillCastPos()
  params.targets = self:getSkillEffectTargets(params.castPos)
  params.atkDis = self.mCastDistance
  self.mTargets = params.targets
  CimeliaSkillView.new(params):addTo(GameData.BG, 100)
end

function M:castSkillTower(_targets)
  local skillType = self.mSkillModel.attackType
  local targets = _targets or self:getSkillEffectTargets()
  DYSoundMgr.playEffect(self.mSkillModel.soundFile)
  if not targets or #targets == 0 then
    return
  end
  BMgrOL.getBuddhaTower():showShadow()
  
  local function tAddBuff(target)
    if #self.mSkillModel.buff == 0 then
      return
    end
    for j = 1, #self.mSkillModel.buff do
      local buff = self.mSkillModel.buff[j]
      local randNum = BMgrOL.RANDOM:random(1, 100)
      if randNum <= buff.Prob then
        print("add buff id : " .. buff.ID)
        target:addBuff(target, buff.ID, buff.CheckTime, buff.Time, buff.Value)
      end
    end
  end
  
  for _, v in pairs(targets) do
    if 3 == skillType then
      v:increaseHP(self.mSkillModel.skillParam[1].value, true)
    end
    if 8 == skillType and self.mData.flag == FLAG_TOWER_BUDDHA then
      GameData.resetBuddhaCDTime()
    end
    tAddBuff(v)
  end
end

function M:castPVETowerSkill()
  DYSoundMgr.playEffect(self.mSkillModel.soundFile)
  local tFunc = {monsterYaofeng = 1, monsterMeihuo = 2}
  local aniIndex = tFunc[self.mSkillModel.name]
  local tmpLayer = display.newLayer():addTo(cc.Director:getInstance():getRunningScene())
  tmpLayer:setTouchSwallowEnabled(false)
  DYRes.loadFileInfo("skillcimelia/tajinengdonghua/tajinengdonghua.csb", GameData.S_FILE_INFO)
  local armature = ccs.Armature:create("tajinengdonghua")
  armature:addTo(tmpLayer, 1)
  armature:getAnimation():playWithIndex(aniIndex)
  armature:setPosition(cc.p(display.cx, display.cy))
  self:castSkillTower()
end

function M:updateNpcBlood()
  if not self.mTargets or #self.mTargets == 0 then
    return
  end
  local atkNum = self.mSkillModel.skillParam[1].value / 100 * self.mData.atk
  local harmNum = self.mSkillModel.skillParam[2].value
  local params = {}
  params.atkNum = atkNum
  params.harmNum = harmNum
  params.attackType = self.mData.aktType
  params.hitRate = self.mData.hitRate
  params.critRate = self.mData.critRate
  params.critHarmRate = self.mData.critHarmRate
  params.phyDefIgnore = self.mData.phyDefIgnore
  params.magDefIgnore = self.mData.magDefIgnore
  params.element = self.mData.element
  params.elementValue = self.mData.elementValue
  params.flag = 1
  if self.mData.flag == FLAG_TOWER_MONSTER then
    params.flag = 2
  end
  print("count : " .. #self.mTargets)
  
  local function tAddBuff(target)
    if #self.mSkillModel.buff == 0 then
      return
    end
    for j = 1, #self.mSkillModel.buff do
      local buff = self.mSkillModel.buff[j]
      local randNum = BMgrOL.RANDOM:random(1, 100)
      if randNum <= buff.Prob then
        print("add buff id : " .. buff.ID)
        target:addBuff(target, buff.ID, buff.CheckTime, buff.Time, buff.Value)
      end
    end
  end
  
  for _, v in pairs(self.mTargets) do
    local damage, harmType = BMgrOL.cimeliaDemage(params, v)
    v:decreaseHP(damage, harmType)
    tAddBuff(v)
  end
end

return M
