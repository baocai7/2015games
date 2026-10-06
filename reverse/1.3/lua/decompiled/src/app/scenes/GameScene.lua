local CLASS_NAME = "GameScene"
local M = {}
M = class(CLASS_NAME, function()
  return display.newScene(CLASS_NAME)
end)

function M:ctor(mode)
  DDLOG(CLASS_NAME .. ": onCreate")
  local num = math.random(0, 1)
  if audio.isMusicPlaying() then
    DYSoundMgr.stopMusic(true)
  end
  if 0 == GameManager.MODE and 0 == GameManager.STAGE_NUM then
    DYSoundMgr.playMusic(DY_SND.sound_stage0_music)
  else
    DYSoundMgr.playMusic(DY_SND["bgm_battle" .. num])
  end
  self:loadRes()
  self:initData()
  self:initUI()
end

function M:initData()
  GameData = require("app.game.GameData")
  GameData.reset()
  DYComponent = DYComponent or require("app.component.ComponetMgr")
  if 6 == GameManager.MODE or 9 == GameManager.MODE then
    BMgrOL = require("app.sprites.pvp.BattleMgrOL")
    SpriteViewMgr = require("app.sprites.pvp.SpriteViewMgr")
    BMgrOL.init()
    BMgr = nil
  else
    BMgrOL = BMgrOL or require("app.sprites.pvp.BattleMgrOL")
    BMgr = BMgrOL
    SpriteViewMgr = require("app.sprites.pvp.SpriteViewMgr")
    BMgrOL.init()
  end
  self:loadRelicsProps()
end

function M:loadRelicsProps()
  GameData.RELICS_ELEMENT_PROPS_BUDDHA = {
    0,
    0,
    0,
    0,
    0
  }
  GameData.RELICS_ELEMENT_PROPS_MONSTER = {
    0,
    0,
    0,
    0,
    0
  }
  for i = 1, #GameManager.RELICS_LIST do
    local data = DataUtils.getEquipmentModel(GameManager.RELICS_LIST[i])
    if 1 < #data.relicsParam then
      local id, num = tonumber(data.relicsParam[1]), tonumber(data.relicsParam[2])
      local index = id - 4
      GameData.RELICS_ELEMENT_PROPS_BUDDHA[index] = GameData.RELICS_ELEMENT_PROPS_BUDDHA[index] + num
    end
  end
  for i = 1, #GameManager.ENEMY_RELICS_LIST do
    local data = DataUtils.getEquipmentModel(GameManager.ENEMY_RELICS_LIST[i])
    if 1 < #data.relicsParam then
      local id, num = tonumber(data.relicsParam[1]), tonumber(data.relicsParam[2])
      local index = id - 4
      GameData.RELICS_ELEMENT_PROPS_MONSTER[index] = GameData.RELICS_ELEMENT_PROPS_MONSTER[index] + num
    end
  end
end

function M:initUI()
  local gameLayer
  if 0 == GameManager.MODE then
    local LayerNormal
    if 0 == GameManager.STAGE_NUM then
      LayerNormal = require("app.game.layers.LayerStage0")
    else
      LayerNormal = require("app.game.layers.LayerNormal")
    end
    gameLayer = LayerNormal.new()
  elseif 1 == GameManager.MODE then
    local LayerNormal = require("app.game.layers.LayerElite")
    gameLayer = LayerNormal.new()
  elseif 2 == GameManager.MODE then
    local LayerInfinite = require("app.game.layers.LayerInfinite")
    gameLayer = LayerInfinite.new()
  elseif 3 == GameManager.MODE then
    local LayerPurgatory = require("app.game.layers.LayerPurgatory")
    gameLayer = LayerPurgatory.new()
  elseif 4 == GameManager.MODE then
    local LayerTravel = require("app.game.layers.LayerTravel")
    gameLayer = LayerTravel.new()
  elseif 5 == GameManager.MODE then
    local LayerPVP = require("app.game.layers.LayerPVP")
    gameLayer = LayerPVP.new()
  elseif 6 == GameManager.MODE then
    local LayerPVPOnline = require("app.game.layers.LayerPVPOnline")
    gameLayer = LayerPVPOnline.new()
  elseif 7 == GameManager.MODE then
    local LayerBabel = require("app.game.layers.LayerBabel")
    gameLayer = LayerBabel.new()
  elseif 8 == GameManager.MODE then
    local LayerUnino = require("app.game.layers.LayerUnionFight")
    GameManager.STAGE_NUM = 1
    gameLayer = LayerUnino.new(GameManager.UNION_FIGHT_MODE or 1)
  elseif 9 == GameManager.MODE then
    local LayerPVPAI = require("app.game.layers.LayerPVPAI")
    gameLayer = LayerPVPAI.new()
  elseif 10 == GameManager.MODE then
    local LayerAggress = require("app.game.layers.LayerAggress")
    gameLayer = LayerAggress.new()
  end
  self:addChild(gameLayer)
end

function M:loadRes()
  DYRes.loadSheet("animation/dadouyanwu.plist")
  DYRes.loadSheet("animation/wofangsiwangyan.plist")
  DYRes.loadSheet("animation/siwanglinghun.plist")
  DYRes.loadSheet("animation/lingqi.plist")
  DYRes.loadSheet("animation/shengli_xingxing.plist")
  DYRes.loadSheet("buff/buffball.plist")
  DYRes.loadSheet("buff/wandPic.plist")
  DYRes.loadSheet("buff/buff_effect.plist")
  DYRes.loadSheet("buff/buff_gain.plist")
  DYRes.loadSheet("buff/buff_meihuo.plist")
  DYRes.loadSheet("buff/buff_harm_decrease.plist")
  DYRes.loadSheet("buff/buff_psy.plist")
  DYRes.loadSheet("buff/buff_some.plist")
  DYRes.loadSheet("buff/buff_meihuo.plist")
  DYRes.loadSheet("buff/buff_stun.plist")
  DYRes.loadSheet("buff/buff_phy_harm_decrease.plist")
  DYRes.loadSheet("buff/buff_mag_harm_decrease.plist")
  DYRes.loadSheet("buff/buff_life_add.plist")
  DYRes.loadSheet("buff/buff_mag_def.plist")
  DYRes.loadSheet("buff/buff_mag_atk.plist")
  DYRes.loadSheet("buff/buff_phy_def.plist")
  DYRes.loadSheet("buff/buff_atk.plist")
  DYRes.loadSheet("buff/buff_area_burn.plist")
  DYRes.loadSheet("buff/buff_speed.plist")
  DYRes.loadSheet("buff/buff_area_posion.plist")
  DYRes.loadSheet("buff/buff_liferecovery.plist")
  DYRes.loadSheet("buff/buff_freeze.plist")
  DYRes.loadSheet("buff/buff_resist.plist")
  DYRes.loadSheet("buff/relive.plist")
  DYRes.loadSheet("buff/cimlia_tx.plist")
end

function M:unloadRes()
  DYRes.unloadSheet("animation/dadouyanwu.plist")
  DYRes.unloadSheet("animation/wofangsiwangyan.plist")
  DYRes.unloadSheet("animation/siwanglinghun.plist")
  DYRes.unloadSheet("animation/lingqi.plist")
  DYRes.unloadSheet("animation/shengli_xingxing.plist")
  DYRes.unloadSheet("buff/buffball.plist")
  DYRes.unloadSheet("buff/wandPic.plist")
  DYRes.unloadSheet("buff/buff_gain.plist")
  DYRes.unloadSheet("buff/buff_effect.plist")
  DYRes.unloadSheet("buff/buff_meihuo.plist")
  DYRes.unloadSheet("buff/buff_harm_decrease.plist")
  DYRes.unloadSheet("buff/buff_psy.plist")
  DYRes.unloadSheet("buff/buff_some.plist")
  DYRes.unloadSheet("buff/buff_meihuo.plist")
  DYRes.unloadSheet("buff/buff_stun.plist")
  DYRes.unloadSheet("buff/buff_phy_harm_decrease.plist")
  DYRes.unloadSheet("buff/buff_mag_harm_decrease.plist")
  DYRes.unloadSheet("buff/buff_life_add.plist")
  DYRes.unloadSheet("buff/buff_mag_def.plist")
  DYRes.unloadSheet("buff/buff_mag_atk.plist")
  DYRes.unloadSheet("buff/buff_phy_def.plist")
  DYRes.unloadSheet("buff/buff_atk.plist")
  DYRes.unloadSheet("buff/buff_area_burn.plist")
  DYRes.unloadSheet("buff/buff_speed.plist")
  DYRes.unloadSheet("buff/buff_area_posion.plist")
  DYRes.unloadSheet("buff/buff_liferecovery.plist")
  DYRes.unloadSheet("buff/buff_freeze.plist")
  DYRes.unloadSheet("buff/buff_resist.plist")
  DYRes.unloadSheet("buff/relive.plist")
  DYRes.unloadSheet("buff/cimlia_tx.plist")
end

function M:onEnter()
  DDLOG(CLASS_NAME .. ": onEnter")
end

function M:onExit()
  DDLOG(CLASS_NAME .. ": onExit")
  self:unloadRes()
end

return M
