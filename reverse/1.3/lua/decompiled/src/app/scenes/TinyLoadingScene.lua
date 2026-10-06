local ResCim = require("app.profiles.resouceCim")
local GameData = require("app.game.GameData")
local TinyLoadingScene = {}
TinyLoadingScene = class("TinyLoadingScene", function()
  return display.newScene("TinyLoadingScene")
end)

function TinyLoadingScene:ctor(destination_scene, mode)
  self.destination_scene_ = destination_scene
  self.mode_ = mode
  if audio.isMusicPlaying() then
    DYSoundMgr.stopMusic(true)
  end
  local soundFile = DY_SND.sfx_go_1
  if "GAME_SCENE" == destination_scene then
    soundFile = DY_SND.sfx_go
    GameManager.IS_USER_BUSY = 1
  else
    GameManager.IS_USER_BUSY = 0
  end
  DYSoundMgr.playEffect(soundFile)
  self.mLabel = cc.ui.UILabel.new({
    text = DYLang.getString("S1428", ""),
    size = 24,
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, display.cx, display.bottom + 50):addTo(self, 5)
  self:initUI()
end

function TinyLoadingScene:initUI()
  display.newSprite("tiny_loading/bg.jpg", display.cx, display.cy):addTo(self)
  local logo = display.newSprite(Game.LOGO_PATH)
  logo:setScale(0.3)
  logo:setPosition(120, display.height * 0.9)
  self:addChild(logo)
  local random1 = math.random(1, 44)
  local hint = display.newSprite(string.format("tiny_loading/hint%d.png", random1))
  hint:setPosition(display.cx - display.height * 0.3, display.cy)
  self:addChild(hint)
  local random2 = math.random(1, 5)
  local role = display.newSprite(string.format("tiny_loading/role%d.png", random2))
  role:setPosition(display.cx + display.height * 0.4, display.cy)
  self:addChild(role)
  local armature = ccs.Armature:create("huanchonghouzi")
  armature:setPosition(display.width * 0.06, display.height * 0.04)
  armature:setScaleX(-1)
  armature:getAnimation():playWithIndex(0)
  self:addChild(armature, 10)
  armature:runAction(transition.sequence({
    cc.MoveBy:create(2, cc.p(display.width * 0.88, 0))
  }))
  self:loadLogic()
end

function TinyLoadingScene:tryLoadArmatureAsync(delay)
  local function tFuncLoad()
    self:loadArmatureAsync()
  end
  
  local function tFuncRelease()
    display.removeUnusedSpriteFrames()
    self:performWithDelay(tFuncLoad, 0)
  end
  
  self:performWithDelay(tFuncRelease, delay)
end

function TinyLoadingScene:loadLogic()
  DYRes.unloadFileInfo(GameData.S_FILE_INFO)
  GameData.S_FILE_INFO = {}
  if self.destination_scene_ == "GAME_SCENE" then
    self:analyze()
    cc.Texture2D:setDefaultAlphaPixelFormat(cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A4444)
    self:tryLoadArmatureAsync(3)
  elseif self.destination_scene_ == "CHAPTER_SCENE" then
    self:performWithDelay(function()
      local nextScene = require("scenes.ChapterScene").new()
      display.replaceScene(nextScene, "fade", 0.2)
    end, 2)
  elseif self.destination_scene_ == "SCENE_STAGE" then
    self:performWithDelay(function()
      display.replaceScene(require("scenes.SceneStage").new(unpack(self.mode_)))
    end, 2)
  elseif self.destination_scene_ == "SCENE_PURGATORY" then
    self:performWithDelay(function()
      display.replaceScene(require("scenes.ScenePurgatory").new(self.mode_))
    end, 2)
  elseif self.destination_scene_ == "INFINITE_MODE_ENTRANCE" then
    self:performWithDelay(function()
      display.replaceScene(require("scenes.InfiniteModeEntrance").new(self.mode_))
    end, 2)
  elseif self.destination_scene_ == "SCENE_TRAVEL" then
    self:performWithDelay(function()
      display.replaceScene(require("scenes.SceneTravel").new())
    end, 2)
  elseif self.destination_scene_ == "SCENE_PVP" then
    self:performWithDelay(function()
      display.replaceScene(require("scenes.ScenePVP").new())
    end, 2)
  elseif self.destination_scene_ == "SCENE_BABEL" then
    self:performWithDelay(function()
      display.replaceScene(require("babel.SceneBabel").new(self.mode_))
    end, 2)
  elseif self.destination_scene_ == "SCENE_PVPOL_RANK" then
    self:performWithDelay(function()
      display.removeUnusedSpriteFrames()
      display.replaceScene(require("app.pvponline.LayerRankInfo").new())
    end, 2)
  elseif self.destination_scene_ == "SCENE_PVPOL_COMPETE" then
    self:performWithDelay(function()
      display.removeUnusedSpriteFrames()
      display.replaceScene(require("app.pvponline.LayerCompeteInfo").new())
    end, 2)
  elseif self.destination_scene_ == "SCENE_UNION" then
    self:performWithDelay(function()
      display.removeUnusedSpriteFrames()
      display.replaceScene(require("app.union.scenes.SceneUnion").new(self.mode_))
    end, 2)
  elseif self.destination_scene_ == "SCENE_UNION_BATTLE" then
    self:performWithDelay(function()
      display.removeUnusedSpriteFrames()
      display.replaceScene(require("app.union.scenes.SceneUnionBattle").new())
    end, 2)
  elseif self.destination_scene_ == "SCENE_UNION_BATTLE_MAIN" then
    self:performWithDelay(function()
      display.removeUnusedSpriteFrames()
      display.replaceScene(require("app.union.scenes.SceneUnionBattleMain").new(self.mode_))
    end, 2)
  elseif self.destination_scene_ == "SCENE_UNION_BATTLE_MATCH" then
    self:performWithDelay(function()
      display.removeUnusedSpriteFrames()
      display.replaceScene(require("app.union.scenes.SceneUnionBattleMatch").new())
    end, 2)
  elseif self.destination_scene_ == "SCENE_AGGRESS" then
    self:performWithDelay(function()
      display.removeUnusedSpriteFrames()
      local nextScene = require("app.aggress.layers.LayerBossRelated").scene()
      display.replaceScene(nextScene, "fade", 0.2)
    end, 2)
  end
end

function TinyLoadingScene:loadArmatureAsync()
  print("GameManager.STAGE_ID : " .. GameManager.STAGE_ID)
  print("GameManager.MODE : " .. GameManager.MODE)
  self.mArmatureFiles = {}
  GameManager.RELICS_LIST = {}
  GameManager.ENEMY_RELICS_LIST = {}
  if 5 == GameManager.MODE then
    for k, v in pairs(GameManager.PVP_ENEMY_INFO.team) do
      if tonumber(k) ~= 0 then
        local monsterModel = DataUtils.getPVPMonsterModel(tonumber(k))
        local file = string.format("armature/%s/%s.csb", monsterModel.armatureFile, monsterModel.armatureFile)
        table.insert(self.mArmatureFiles, file)
        for i = 1, #monsterModel.equipmentList do
          local ueid = monsterModel.equipmentList[i]
          local eData = CloudData.ENEMY_EQUIPMENTS[ueid]
          if eData and eData.shenbing then
            table.insert(GameManager.ENEMY_RELICS_LIST, eData.equipmentId)
          end
        end
      end
    end
    for k, v in pairs(GameManager.PVP_BUDDHA_INFO.team) do
      if tonumber(k) ~= 0 then
        local buddhaModel = DataUtils.getBuddhaModel(tonumber(k))
        local file = string.format("armature/%s/%s.csb", buddhaModel.armatureFile, buddhaModel.armatureFile)
        table.insert(self.mArmatureFiles, file)
        for i = 1, #buddhaModel.equipmentList do
          local ueid = buddhaModel.equipmentList[i]
          local eData = CloudData.EQUIPMENT_INFO[ueid]
          if eData and eData.shenbing then
            table.insert(GameManager.RELICS_LIST, eData.equipmentId)
          end
        end
      end
    end
  elseif 6 == GameManager.MODE then
    for i = 1, #CloudData.ENEMY_ATTACK_TEAM do
      local monsterId = tonumber(CloudData.ENEMY_ATTACK_TEAM[i])
      local monsterModel = DataUtils.getModelForPVPOnline("enemy", monsterId)
      local file = string.format("armature/%s/%s.csb", monsterModel.armatureFile, monsterModel.armatureFile)
      table.insert(self.mArmatureFiles, file)
      for k = 1, #monsterModel.equipmentList do
        local ueid = monsterModel.equipmentList[k]
        local eData = CloudData.ENEMY_EQUIPMENTS[ueid]
        if eData and eData.shenbing then
          table.insert(GameManager.ENEMY_RELICS_LIST, eData.equipmentId)
        end
      end
    end
    for j = 1, #CloudData.BUDDHA_ATTACK_TEAM do
      local buddhaId = tonumber(CloudData.BUDDHA_ATTACK_TEAM[j])
      local buddhaModel = DataUtils.getModelForPVPOnline("buddha", buddhaId)
      local file = string.format("armature/%s/%s.csb", buddhaModel.armatureFile, buddhaModel.armatureFile)
      table.insert(self.mArmatureFiles, file)
      for k = 1, #buddhaModel.equipmentList do
        local ueid = buddhaModel.equipmentList[k]
        local eData = CloudData.BUDDHA_EQUIPMENTS[ueid]
        if eData and eData.shenbing then
          table.insert(GameManager.RELICS_LIST, eData.equipmentId)
        end
      end
    end
  else
    local monsterIdTable = DataUtils.getMonsterIdInStage(GameManager.MODE, GameManager.STAGE_ID)
    if 0 == GameManager.STAGE_NUM and 0 == GameManager.MODE then
      local file = "skillcimelia/tajinengdonghua/tajinengdonghua.csb"
      table.insert(self.mArmatureFiles, file)
    end
    for i, monsterId in pairs(monsterIdTable) do
      if 0 ~= tonumber(monsterId) then
        local monsterModel = DataUtils.getMonsterModel(monsterId)
        local file = string.format("armature/%s/%s.csb", monsterModel.armatureFile, monsterModel.armatureFile)
        table.insert(self.mArmatureFiles, file)
      end
    end
    local teamInfo = DataUtils.getBuddhaTableOnTeam()
    for i, buddhaId in pairs(teamInfo) do
      if buddhaId ~= "" then
        local buddhaModel = DataUtils.getBuddhaModel(tonumber(buddhaId))
        local file = string.format("armature/%s/%s.csb", buddhaModel.armatureFile, buddhaModel.armatureFile)
        table.insert(self.mArmatureFiles, file)
        for i = 1, #buddhaModel.equipmentList do
          local ueid = buddhaModel.equipmentList[i]
          local eData = CloudData.EQUIPMENT_INFO[ueid]
          if eData and eData.shenbing then
            table.insert(GameManager.RELICS_LIST, eData.equipmentId)
          end
        end
      end
    end
  end
  local skillId_buddha = DataUtils.getBuddhaCimeliaSkill()
  local skillIds_monster = {}
  if GameManager.MODE < 5 and GameManager.MODE ~= 2 or GameManager.MODE == 10 then
    skillIds_monster = DataUtils.getMonsterCimeliaSkill(GameManager.MODE, GameManager.STAGE_ID) or {}
  end
  table.insert(skillIds_monster, skillId_buddha)
  local skillIds = table.unique(skillIds_monster)
  for k, v in pairs(skillIds) do
    if 0 < v and v < 588001 then
      local tmpData = DataUtils.getCimeliaSkillModel(v)
      local file = string.format("skillcimelia/%s/%s.csb", tmpData.name, tmpData.name)
      table.insert(self.mArmatureFiles, file)
    elseif 588001 <= v then
      local file = "skillcimelia/tajinengdonghua/tajinengdonghua.csb"
      table.insert(self.mArmatureFiles, file)
    end
  end
  
  local function dataLoaded(percent)
    if nil ~= self.mLabel then
      self.mLabel:setString(string.format(DYLang.getString("S1429", ""), 30 + percent * 60))
      print(DYLang.getString("S43", ""), percent)
    end
    if 1 <= percent and self.enterGameScene then
      self:enterGameScene()
    end
  end
  
  for i = 1, #self.mArmatureFiles do
    local file = self.mArmatureFiles[i]
    print("armature file : " .. file)
    DYRes.loadFileInfoAsync(file, GameData.S_FILE_INFO, dataLoaded)
    print("=============== load success")
  end
end

function TinyLoadingScene:analyze()
  local id = tonumber(GameManager.STAGE_ID) % 10000
  if tonumber(GameManager.MODE) == 5 then
    id = 0
  end
  local modetable = {
    [1] = DYLang.getString("S1431", ""),
    [2] = DYLang.getString("S1432", ""),
    [3] = DYLang.getString("S1433", ""),
    [4] = DYLang.getString("S1434", ""),
    [5] = DYLang.getString("S1435", ""),
    [6] = DYLang.getString("S1436", ""),
    [7] = DYLang.getString("S1437", "")
  }
  local mode = modetable[tonumber(GameManager.MODE) + 1] or ""
  local str = mode .. "_" .. id
  DYAnalyze.levels.begin(str)
end

function TinyLoadingScene:loadAnimationAsync()
  if 5 == GameManager.MODE or 6 == GameManager.MODE or 9 == GameManager.MODE then
    self:enterGameScene()
    return
  end
  local skillId_buddha = DataUtils.getBuddhaCimeliaSkill()
  local skillIds_monster = {}
  if 5 > GameManager.MODE and GameManager.MODE ~= 2 then
    skillIds_monster = DataUtils.getMonsterCimeliaSkill(GameManager.MODE, GameManager.STAGE_ID)
  end
  table.insert(skillIds_monster, skillId_buddha)
  local skillIds = table.unique(skillIds_monster)
  for k, v in pairs(skillIds) do
    if 0 < v and v < 588001 then
      local tmpData = DataUtils.getCimeliaSkillModel(v)
      local filePath = string.format("skillcimelia/%s/%s.csb", tmpData.name, tmpData.name)
      DYRes.loadFileInfo(filePath, GameData.S_FILE_INFO)
    elseif 588001 <= v then
      DYRes.loadFileInfo("skillcimelia/tajinengdonghua/tajinengdonghua.csb", GameData.S_FILE_INFO)
    end
  end
  self:enterGameScene()
end

function TinyLoadingScene:enterGameScene()
  cc.Texture2D:setDefaultAlphaPixelFormat(cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888)
  print(string.format(DYLang.getString("S1438", ""), GameManager.STAGE_NUM))
  display.replaceScene(require("scenes.GameScene").new(self.mode_), "FADETR", 1)
end

function TinyLoadingScene:onEnter()
end

function TinyLoadingScene:onExit()
end

return TinyLoadingScene
