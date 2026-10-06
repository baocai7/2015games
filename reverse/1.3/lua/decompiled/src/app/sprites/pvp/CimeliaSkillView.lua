local DYClass = "CimeliaSkillView"
local M = {}
M = class(DYClass, function()
  return display.newNode()
end)

function M:ctor(model)
  self.mModel = model
  self.mFaceTo = 1
  if FLAG_TOWER_MONSTER == model.flag then
    self.mFaceTo = -1
  end
  DYSoundMgr.playEffect(model.soundFile)
  self[model.skillName](self)
end

function M:skillShow(cType)
  local tFunc = {
    [1] = function()
      self:loadSkillType1()
    end,
    [2] = function()
      self:loadSkillType2()
    end,
    [3] = function()
      self:loadSkillType3()
    end
  }
  tFunc[cType]()
end

function M:dianbing()
  local filePath = string.format("skillcimelia/%s/%s.csb", self.mModel.skillName, self.mModel.skillName)
  DYRes.loadFileInfo(filePath, GameData.S_FILE_INFO)
  local offsetX = 150
  local offsetY = 0
  local countNum = math.ceil((BMgrOL.getBuddhaPos().x - BMgrOL.getMonsterPos().x) / offsetX)
  local posX, posY = BMgrOL.getMonsterPos().x, BMgrOL.getMonsterPos().y
  if -1 == self.mFaceTo then
    posX, posY = BMgrOL.getBuddhaPos().x, BMgrOL.getBuddhaPos().y
  end
  for i = 1, countNum do
    self:performWithDelay(function()
      local armature = ccs.Armature:create(self.mModel.skillName)
      armature:getAnimation():playWithIndex(0)
      armature:setPosition(offsetX * (i - 1), offsetY)
      self:addChild(armature)
    end, 0.1 * (i - 1))
  end
  self:setPosition(posX, posY)
  self:setScaleX(self.mFaceTo)
  GameData.SKILL_DELAY = math.ceil(countNum / 2) * 0.1
end

function M:ximingzhang()
  local filePath = string.format("skillcimelia/%s/%s.csb", self.mModel.skillName, self.mModel.skillName)
  DYRes.loadFileInfo(filePath, GameData.S_FILE_INFO)
  local posX, posY = BMgrOL.getBuddhaPos().x, BMgrOL.getBuddhaPos().y
  if -1 == self.mFaceTo then
    posX, posY = BMgrOL.getMonsterPos().x, BMgrOL.getMonsterPos().y
  end
  local armature = ccs.Armature:create(self.mModel.skillName)
  armature:getAnimation():playWithIndex(0)
  armature:setPosition(0, 0)
  self:setPosition(posX, posY)
  self:setScaleX(self.mFaceTo)
  self:addChild(armature)
  GameData.SKILL_DELAY = 0.5
end

function M:shenshuizhang()
  local filePath = string.format("skillcimelia/%s/%s.csb", self.mModel.skillName, self.mModel.skillName)
  DYRes.loadFileInfo(filePath, GameData.S_FILE_INFO)
  local armature = ccs.Armature:create(self.mModel.skillName)
  armature:getAnimation():playWithIndex(0)
  armature:setPosition(0, 0)
  self:setPosition(self.mModel.castPos.x, self.mModel.castPos.y)
  self:addChild(armature)
  GameData.SKILL_DELAY = 0.5
end

function M:xishazhang()
  local filePath = string.format("skillcimelia/%s/%s.csb", self.mModel.skillName, self.mModel.skillName)
  DYRes.loadFileInfo(filePath, GameData.S_FILE_INFO)
  local offsetX = 210
  local countNum = math.ceil(self.mModel.atkDis / offsetX)
  local posX, posY = self.mModel.castPos.x, self.mModel.castPos.y
  for i = 1, countNum do
    self:performWithDelay(function()
      local armature = ccs.Armature:create(self.mModel.skillName)
      armature:getAnimation():playWithIndex(0)
      armature:setPosition(-offsetX * (i - 1), 0)
      self:addChild(armature)
    end, 0.2 * (i - 1))
  end
  self:setPosition(posX, posY)
  self:setScaleX(self.mFaceTo)
  GameData.SKILL_DELAY = math.ceil(countNum / 2) * 0.2
end

function M:ruoshuizhang()
  local filePath = string.format("skillcimelia/%s/%s.csb", self.mModel.skillName, self.mModel.skillName)
  DYRes.loadFileInfo(filePath, GameData.S_FILE_INFO)
  local armature = ccs.Armature:create(self.mModel.skillName)
  armature:getAnimation():playWithIndex(0)
  armature:setPosition(0, 0)
  self:setPosition(self.mModel.castPos.x, self.mModel.castPos.y)
  self:setScaleX(self.mFaceTo)
  self:addChild(armature)
  GameData.SKILL_DELAY = 0.5
end

function M:jumangzhang()
  local filePath = string.format("skillcimelia/%s/%s.csb", self.mModel.skillName, self.mModel.skillName)
  DYRes.loadFileInfo(filePath, GameData.S_FILE_INFO)
  local posX, posY = BMgrOL.getBuddhaPos().x, BMgrOL.getBuddhaPos().y
  if -1 == self.mFaceTo then
    posX, posY = BMgrOL.getMonsterPos().x, BMgrOL.getMonsterPos().y
  end
  local armature = ccs.Armature:create(self.mModel.skillName)
  armature:getAnimation():playWithIndex(0)
  armature:setPosition(-400, 0)
  self:addChild(armature)
  self:setPosition(posX, posY)
  self:setScaleX(self.mFaceTo)
  self:performWithDelay(function()
    armature:getAnimation():playWithIndex(1)
    local point = cc.p(-(self.mModel.atkDis - 200) * self.mFaceTo, 0)
    local time = self.mModel.atkDis / 2400
    local seq = transition.sequence({
      cc.MoveBy:create(time, point),
      cc.CallFunc:create(function()
        self:removeSelf()
      end)
    })
    self:runAction(seq)
  end, 0.75)
  GameData.SKILL_DELAY = 0.75
end

function M:leimuruyi()
  local filePath = string.format("skillcimelia/%s/%s.csb", self.mModel.skillName, self.mModel.skillName)
  DYRes.loadFileInfo(filePath, GameData.S_FILE_INFO)
  local offsetX = 180
  local countNum = math.ceil(self.mModel.atkDis / offsetX)
  local posX, posY = BMgrOL.getBuddhaPos().x, BMgrOL.getBuddhaPos().y
  if -1 == self.mFaceTo then
    posX, posY = BMgrOL.getMonsterPos().x, BMgrOL.getMonsterPos().y
  end
  for i = 1, countNum do
    self:performWithDelay(function()
      local armature = ccs.Armature:create(self.mModel.skillName)
      armature:getAnimation():playWithIndex(0)
      armature:setPosition(-offsetX * (i - 1), 0)
      self:addChild(armature)
    end, 0.2 * (i - 1))
  end
  self:setPosition(posX, posY)
  self:setScaleX(self.mFaceTo)
  GameData.SKILL_DELAY = math.ceil(countNum / 2) * 0.2
end

function M:wutongzhang()
  local filePath = string.format("skillcimelia/%s/%s.csb", self.mModel.skillName, self.mModel.skillName)
  DYRes.loadFileInfo(filePath, GameData.S_FILE_INFO)
  local posX, posY = BMgrOL.getBuddhaPos().x, BMgrOL.getBuddhaPos().y
  if -1 == self.mFaceTo then
    posX, posY = BMgrOL.getMonsterPos().x, BMgrOL.getMonsterPos().y
  end
  local armature = ccs.Armature:create(self.mModel.skillName)
  armature:getAnimation():playWithIndex(0)
  armature:setPosition(-500, 0)
  self:addChild(armature)
  self:setPosition(posX, posY)
  self:setScaleX(self.mFaceTo)
  GameData.SKILL_DELAY = 0.5
end

function M:pengmuzhang()
  local filePath = string.format("skillcimelia/%s/%s.csb", self.mModel.skillName, self.mModel.skillName)
  DYRes.loadFileInfo(filePath, GameData.S_FILE_INFO)
  local offsetX = 45
  local countNum = math.ceil(self.mModel.atkDis / offsetX)
  local posX, posY = BMgrOL.getBuddhaPos().x, BMgrOL.getBuddhaPos().y
  if -1 == self.mFaceTo then
    posX, posY = BMgrOL.getMonsterPos().x, BMgrOL.getMonsterPos().y
  end
  self.mArmatureList = {}
  
  local function tRemoveArmature()
    for k, v in pairs(self.mArmatureList) do
      local seq = transition.sequence({
        cc.FadeOut:create(1),
        cc.CallFunc:create(function()
          v:removeSelf()
        end)
      })
      v:runAction(seq)
    end
    self.mArmatureList = {}
  end
  
  for i = 1, countNum do
    self:performWithDelay(function()
      local armature = ccs.Armature:create(self.mModel.skillName)
      armature:getAnimation():playWithIndex(0)
      armature:setPosition(-offsetX * (i - 1), 10 + i % 2 * 40)
      armature:setScale(0.4)
      table.insert(self.mArmatureList, armature)
      self:addChild(armature, 1 - i % 2)
      if i == countNum then
        tRemoveArmature()
      end
    end, 0.07 * (i - 1))
  end
  self:setPosition(posX, posY)
  self:setScaleX(self.mFaceTo)
  GameData.SKILL_DELAY = math.ceil(countNum / 2) * 0.07
end

function M:xingfengzhang()
  local filePath = string.format("skillcimelia/%s/%s.csb", self.mModel.skillName, self.mModel.skillName)
  DYRes.loadFileInfo(filePath, GameData.S_FILE_INFO)
  local posX, posY = BMgrOL.getBuddhaPos().x, BMgrOL.getBuddhaPos().y
  if -1 == self.mFaceTo then
    posX, posY = BMgrOL.getMonsterPos().x, BMgrOL.getMonsterPos().y
  end
  local armature = ccs.Armature:create(self.mModel.skillName)
  armature:getAnimation():playWithIndex(0)
  armature:setPosition(0, 0)
  self:addChild(armature)
  self:setPosition(posX, posY)
  local point = cc.p(-self.mModel.atkDis * self.mFaceTo, 0)
  local time = self.mModel.atkDis / 600
  local seq = transition.sequence({
    cc.MoveBy:create(time, point),
    cc.CallFunc:create(function()
      self:removeSelf()
    end)
  })
  self:runAction(seq)
  GameData.SKILL_DELAY = time
end

function M:huoyuzhang()
  local filePath = string.format("skillcimelia/%s/%s.csb", self.mModel.skillName, self.mModel.skillName)
  DYRes.loadFileInfo(filePath, GameData.S_FILE_INFO)
  local posX, posY = BMgrOL.getBuddhaPos().x, BMgrOL.getBuddhaPos().y
  if -1 == self.mFaceTo then
    posX, posY = BMgrOL.getMonsterPos().x, BMgrOL.getMonsterPos().y
  end
  local armature = ccs.Armature:create(self.mModel.skillName)
  armature:getAnimation():playWithIndex(0)
  armature:setPosition(-510, 0)
  self:addChild(armature)
  self:setPosition(posX, posY - 50)
  self:setScaleX(self.mFaceTo)
  GameData.SKILL_DELAY = 1.5
end

function M:chimangzhang()
  local filePath = string.format("skillcimelia/%s/%s.csb", self.mModel.skillName, self.mModel.skillName)
  DYRes.loadFileInfo(filePath, GameData.S_FILE_INFO)
  local posX, posY = BMgrOL.getBuddhaPos().x, BMgrOL.getBuddhaPos().y
  if -1 == self.mFaceTo then
    posX, posY = BMgrOL.getMonsterPos().x, BMgrOL.getMonsterPos().y
  end
  for i = 1, 2 do
    self:performWithDelay(function()
      local armature = ccs.Armature:create(self.mModel.skillName)
      armature:getAnimation():playWithIndex(0)
      armature:setPosition(-510 + 100 * (i - 1), -50)
      self:addChild(armature)
    end, 0.3 * (i - 1))
  end
  self:setPosition(posX, posY)
  self:setScaleX(self.mFaceTo)
  GameData.SKILL_DELAY = 0.5
end

function M:meihuozhang()
  local filePath = string.format("skillcimelia/%s/%s.csb", self.mModel.skillName, self.mModel.skillName)
  DYRes.loadFileInfo(filePath, GameData.S_FILE_INFO)
  local posX, posY = GameData.BG:getContentSize().width * 0.5, BMgrOL.getBuddhaPos().y
  if -1 == self.mFaceTo then
    posX, posY = GameData.BG:getContentSize().width * 0.5, BMgrOL.getMonsterPos().y
  end
  local armature = ccs.Armature:create(self.mModel.skillName)
  armature:getAnimation():playWithIndex(0)
  armature:setPosition(0, -50)
  self:addChild(armature)
  self:setPosition(posX, posY)
  GameData.SKILL_DELAY = 0.5
end

function M:yanjingzhang()
  local filePath = string.format("skillcimelia/%s/%s.csb", self.mModel.skillName, self.mModel.skillName)
  DYRes.loadFileInfo(filePath, GameData.S_FILE_INFO)
  local offsetX = 150
  local countNum = math.ceil(self.mModel.atkDis / offsetX)
  local posX, posY = self.mModel.castPos.x + self.mModel.atkDis * 0.5 * self.mFaceTo, self.mModel.castPos.y
  for i = 1, countNum do
    self:performWithDelay(function()
      local armature = ccs.Armature:create(self.mModel.skillName)
      armature:getAnimation():playWithIndex(0)
      armature:setPosition(-offsetX * (i - 1), 0)
      self:addChild(armature)
    end, 0.25 * (i - 1))
  end
  self:setPosition(posX, posY)
  self:setScaleX(self.mFaceTo)
  GameData.SKILL_DELAY = math.ceil(countNum / 2) * 0.25
end

function M:muhuozhang()
  local filePath = string.format("skillcimelia/%s/%s.csb", self.mModel.skillName, self.mModel.skillName)
  DYRes.loadFileInfo(filePath, GameData.S_FILE_INFO)
  local posX, posY = BMgrOL.getBuddhaPos().x, BMgrOL.getBuddhaPos().y
  if -1 == self.mFaceTo then
    posX, posY = BMgrOL.getMonsterPos().x, BMgrOL.getMonsterPos().y
  end
  for i = 1, 3 do
    local armature = ccs.Armature:create(self.mModel.skillName)
    armature:getAnimation():playWithIndex(0)
    armature:setPosition(-160 + 60 * i, 70 - i * 30)
    self:addChild(armature)
    local point = cc.p(-(self.mModel.atkDis + 60 * i), 0)
    local time = self.mModel.atkDis / 700
    local seq = transition.sequence({
      cc.MoveBy:create(time, point),
      cc.CallFunc:create(function()
        armature:removeSelf()
      end)
    })
    armature:runAction(seq)
  end
  self:setScaleX(self.mFaceTo)
  self:setPosition(posX, posY)
  GameData.SKILL_DELAY = self.mModel.atkDis / 700
end

function M:jinjin()
  local filePath = string.format("skillcimelia/%s/%s.csb", self.mModel.skillName, self.mModel.skillName)
  DYRes.loadFileInfo(filePath, GameData.S_FILE_INFO)
  local posX, posY = BMgrOL.getBuddhaPos().x, BMgrOL.getBuddhaPos().y
  if -1 == self.mFaceTo then
    posX, posY = BMgrOL.getMonsterPos().x, BMgrOL.getMonsterPos().y
  end
  local armature = ccs.Armature:create(self.mModel.skillName)
  armature:getAnimation():playWithIndex(0)
  armature:setPosition(-200, -20)
  self:addChild(armature)
  self:setPosition(posX, posY)
  self:setScaleX(self.mFaceTo)
  GameData.SKILL_DELAY = 0.5
end

function M:lietianzhang()
  local filePath = string.format("skillcimelia/%s/%s.csb", self.mModel.skillName, self.mModel.skillName)
  DYRes.loadFileInfo(filePath, GameData.S_FILE_INFO)
  local posX, posY = self.mModel.castPos.x, self.mModel.castPos.y
  local offsetY = 0
  local armature = ccs.Armature:create(self.mModel.skillName)
  armature:getAnimation():playWithIndex(0)
  armature:setPosition(0, offsetY)
  self:addChild(armature)
  self:setPosition(posX, posY)
  self:setScaleX(self.mFaceTo)
  GameData.SKILL_DELAY = 0.5
end

function M:ruishizhang()
  local filePath = string.format("skillcimelia/%s/%s.csb", self.mModel.skillName, self.mModel.skillName)
  DYRes.loadFileInfo(filePath, GameData.S_FILE_INFO)
  local offsetX = 100
  local countNum = math.ceil(self.mModel.atkDis / offsetX)
  local posX, posY = self.mModel.castPos.x + self.mModel.atkDis * 0.5 * self.mFaceTo, self.mModel.castPos.y
  for i = 1, countNum do
    self:performWithDelay(function()
      local armature = ccs.Armature:create(self.mModel.skillName)
      armature:getAnimation():playWithIndex(0)
      armature:setPosition(-offsetX * (i - 1), -10)
      self:addChild(armature, i)
    end, 0.15 * (i - 1))
  end
  self:setPosition(posX, posY)
  self:setScaleX(self.mFaceTo)
  GameData.SKILL_DELAY = math.ceil(countNum / 2) * 0.2
end

function M:pofengzhang()
  local filePath = string.format("skillcimelia/%s/%s.csb", self.mModel.skillName, self.mModel.skillName)
  DYRes.loadFileInfo(filePath, GameData.S_FILE_INFO)
  local posX, posY = self.mModel.castPos.x, self.mModel.castPos.y
  local armature = ccs.Armature:create(self.mModel.skillName)
  armature:getAnimation():playWithIndex(0)
  armature:setPosition(0, 0)
  self:addChild(armature)
  self:setPosition(posX, posY)
  self:setScaleX(self.mFaceTo)
  GameData.SKILL_DELAY = 0.5
end

function M:diaokezhang()
  local filePath = string.format("skillcimelia/%s/%s.csb", self.mModel.skillName, self.mModel.skillName)
  DYRes.loadFileInfo(filePath, GameData.S_FILE_INFO)
  local posX, posY = BMgrOL.getBuddhaPos().x, BMgrOL.getBuddhaPos().y
  if -1 == self.mFaceTo then
    posX, posY = BMgrOL.getMonsterPos().x, BMgrOL.getMonsterPos().y
  end
  local armature = ccs.Armature:create(self.mModel.skillName)
  armature:getAnimation():playWithIndex(0)
  armature:setPosition(-450, 0)
  self:addChild(armature)
  self:setPosition(posX, posY)
  self:setScaleX(self.mFaceTo)
  GameData.SKILL_DELAY = 0.4
end

function M:nvwazhang()
  local filePath = string.format("skillcimelia/%s/%s.csb", self.mModel.skillName, self.mModel.skillName)
  DYRes.loadFileInfo(filePath, GameData.S_FILE_INFO)
  local posX, posY = self.mModel.castPos.x, BMgrOL.getBuddhaPos().y
  if -1 == self.mFaceTo then
    posX, posY = self.mModel.castPos.x, BMgrOL.getMonsterPos().y
  end
  local armature = ccs.Armature:create(self.mModel.skillName)
  armature:getAnimation():playWithIndex(0)
  armature:setPosition(-100, 0)
  self:addChild(armature)
  self:setPosition(posX, posY)
  self:setScaleX(self.mFaceTo)
  GameData.SKILL_DELAY = 0.5
end

function M:wugouzhang()
  local filePath = string.format("skillcimelia/%s/%s.csb", self.mModel.skillName, self.mModel.skillName)
  DYRes.loadFileInfo(filePath, GameData.S_FILE_INFO)
  local posX, posY = self.mModel.castPos.x, BMgrOL.getBuddhaPos().y
  if -1 == self.mFaceTo then
    posX, posY = self.mModel.castPos.x, BMgrOL.getMonsterPos().y
  end
  local armature = ccs.Armature:create(self.mModel.skillName)
  armature:getAnimation():playWithIndex(0)
  armature:setPosition(0, 0)
  self:addChild(armature)
  self:setPosition(posX, posY)
  self:setScaleX(self.mFaceTo)
  GameData.SKILL_DELAY = 0.5
end

function M:tuyunzhang()
  local filePath = string.format("skillcimelia/%s/%s.csb", self.mModel.skillName, self.mModel.skillName)
  DYRes.loadFileInfo(filePath, GameData.S_FILE_INFO)
  local posX, posY = self.mModel.castPos.x, self.mModel.castPos.y
  local armature = ccs.Armature:create(self.mModel.skillName)
  armature:getAnimation():playWithIndex(0)
  armature:setPosition(0, -25)
  self:addChild(armature)
  self:setScaleX(self.mFaceTo)
  self:setPosition(posX, posY)
  GameData.SKILL_DELAY = 0.5
end

function M:jinjizhang()
  local filePath = string.format("skillcimelia/%s/%s.csb", self.mModel.skillName, self.mModel.skillName)
  DYRes.loadFileInfo(filePath, GameData.S_FILE_INFO)
  local posX, posY = self.mModel.castPos.x, BMgrOL.getBuddhaPos().y
  if -1 == self.mFaceTo then
    posX, posY = self.mModel.castPos.x, BMgrOL.getMonsterPos().y
  end
  local armature = ccs.Armature:create(self.mModel.skillName)
  armature:getAnimation():playWithIndex(0)
  armature:setPosition(0, 20)
  self:addChild(armature)
  self:setPosition(posX, posY)
  GameData.SKILL_DELAY = 0.5
end

function M:yunnizhang()
  local filePath = string.format("skillcimelia/%s/%s.csb", self.mModel.skillName, self.mModel.skillName)
  DYRes.loadFileInfo(filePath, GameData.S_FILE_INFO)
  local offsetX = 100
  local countNum = math.round(self.mModel.atkDis / offsetX)
  local posX, posY = self.mModel.castPos.x + self.mModel.atkDis * 0.5 * self.mFaceTo, self.mModel.castPos.y
  for i = 1, countNum do
    self:performWithDelay(function()
      local armature = ccs.Armature:create(self.mModel.skillName)
      armature:getAnimation():playWithIndex(0)
      armature:setPosition(-offsetX * (i - 1), 0)
      self:addChild(armature)
    end, 0.2 * (i - 1))
  end
  self:setScaleX(self.mFaceTo)
  self:setPosition(posX, posY)
  GameData.SKILL_DELAY = (countNum - 1) * 0.2
end

function M:shengunzhang()
  local filePath = string.format("skillcimelia/%s/%s.csb", self.mModel.skillName, self.mModel.skillName)
  DYRes.loadFileInfo(filePath, GameData.S_FILE_INFO)
  local offsetX = (BMgrOL.getBuddhaPos().x - BMgrOL.getMonsterPos().x) * 0.5
  local offsetY = -50
  local posX, posY = BMgrOL.getBuddhaPos().x, BMgrOL.getBuddhaPos().y
  if -1 == self.mFaceTo then
    posX, posY = BMgrOL.getMonsterPos().x, BMgrOL.getMonsterPos().y
  end
  local armature = ccs.Armature:create(self.mModel.skillName)
  armature:getAnimation():playWithIndex(0)
  armature:setPosition(-offsetX, offsetY)
  self:addChild(armature)
  self:setScaleX(self.mFaceTo)
  self:setPosition(posX, posY)
  GameData.SKILL_DELAY = 0.45
end

function M:monsterQiuku()
  local tmpLayer = display.newLayer():addTo(cc.Director:getInstance():getRunningScene())
  tmpLayer:setTouchSwallowEnabled(false)
  DYRes.loadFileInfo("skillcimelia/tajinengdonghua/tajinengdonghua.csb", GameData.S_FILE_INFO)
  local armature = ccs.Armature:create("tajinengdonghua")
  armature:addTo(tmpLayer, 1)
  armature:getAnimation():playWithIndex(0)
  armature:setPosition(cc.p(display.cx, display.cy))
  GameData.SKILL_DELAY = 0.2
end

return M
