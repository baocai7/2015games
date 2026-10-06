local DataLabelIcon = require("app.icons.DataLabelIcon")
local IconBossInfo = require("app.aggress.icons.IconBossInfo")
local LayerRewardPreview = require("app.aggress.layers.LayerRewardPreview")
local LayerBossDetail = require("app.aggress.layers.LayerBossDetail")
local LayerRule = require("app.layers.LayerRule")
local IconPkBubble = require("app.icons.IconPkBubble")
local CLASS_NAME = "LayerBossRelated"
local M = {}
M = class(CLASS_NAME, function()
  return display.newLayer()
end)
local AS_TYPE = {
  ["1"] = "FIGHT",
  ["2"] = "STRUGGLE",
  ["3"] = "ESCAPE",
  ["4"] = "KILL"
}

function M.scene()
  local scene = display.newScene()
  local layer = M.new()
  layer:addTo(scene)
  local pkBubble = IconPkBubble.new()
  scene:addChild(pkBubble, 900)
  scene.mPkBubble = pkBubble
  return scene
end

function M:ctor(index)
  DDLOG(CLASS_NAME .. ": onCreate")
  self.mCoreNode = display.newNode():pos(display.cx, display.cy):addTo(self, 1)
  self.mBg = nil
  self.mBtnBack = nil
  self.mBtnRewardPreview = nil
  self.mBtnReadme = nil
  self.mBossData = nil
  self.mFileInfo = {}
  self:initData()
  self:layoutUI()
  self.mKeypadListener = handler(self, self.onKeypad)
  self:setNodeEventEnabled(true)
end

function M:initData()
  self.mBossData = {}
  
  local function tFuncListener(resp)
    DDLOG("listAggressBoss return")
    if not self.class or self.class.__cname ~= CLASS_NAME then
      return
    end
    if resp.errorCode ~= 0 then
      local toast = WSToast.new(resp.errorMsg, 2):addTo(self, 20)
      return
    end
    for i = 1, #resp.data.bossList do
      local boss = resp.data.bossList[i]
      local data = {
        bid = boss.id,
        mid = boss.bossId,
        energyCost = boss.energyCost,
        stageId = boss.stageId,
        level = boss.level,
        userUid = boss.findUid,
        userNick = boss.findNick,
        curHP = boss.blood,
        totalHP = 0,
        state = AS_TYPE[checkstring(boss.status)],
        meetTime = boss.meetTime,
        damageRank = boss.damageRank
      }
      table.insert(self.mBossData, data)
    end
    self:resetBossList()
  end
  
  self:safeHttpRequest("aggressInit", tFuncListener)
end

function M:layoutUI()
  self:addBg()
  self:addContent()
end

function M:addBg()
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  self.mBg = display.newSprite("aggress/img_boss_background.jpg", 0, 0):addTo(self.mCoreNode)
  self.mBtnBack = cc.ui.UIPushButton.new({
    normal = "common_ui/backBtn_normal.png",
    pressed = "common_ui/backBtn_pressed.png"
  }):align(display.CENTER, 145, 680):onButtonClicked(function()
    self:onClickBack()
  end):addTo(self.mBg, 1)
  local energyLabel = DataLabelIcon.new(DataLabelIcon.LABEL_TYPE_ENERGY, true)
  energyLabel:setPosition(cc.p(display.width * -0.23, display.height * 0.46))
  self.mCoreNode:addChild(energyLabel)
  local essenceLabel = DataLabelIcon.new(DataLabelIcon.LABEL_TYPE_ESSENCE, true)
  essenceLabel:setPosition(cc.p(display.width * 0.06, display.height * 0.46))
  self.mCoreNode:addChild(essenceLabel)
  local peachLabel = DataLabelIcon.new(DataLabelIcon.LABEL_TYPE_PEACH, true)
  peachLabel:setPosition(cc.p(display.width * 0.35, display.height * 0.46))
  self.mCoreNode:addChild(peachLabel)
end

function M:addContent()
  local node = self.mBg
  self.mBtnReadme = LayerRule.newRuleIcon(LayerRule.AGGRESS):align(display.CENTER, 405, 615):addTo(self.mBg, 1)
end

function M:resetBossList()
  local node = self.mBg
  local lvBoss = cc.ui.UIListView.new({
    viewRect = cc.rect(386, 90, 740, 480),
    direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
  }):onTouch(handler(self, self.onTouchBossList)):addTo(node)
  for i = 1, #self.mBossData do
    local item = lvBoss:newItem()
    local icon = IconBossInfo.new(handler(self, self.onEventIconBossInfo), self.mBossData[i])
    local content = icon
    item:addContent(content)
    item:setItemSize(732, 140)
    lvBoss:addItem(item)
  end
  lvBoss:reload()
end

function M:onTouchBossList(event)
  local node = self.mCoreNode
  if "clicked" == event.name then
    local cb = handler(self, self.onEventLayerBossInfo)
    local param = self.mBossData[event.itemPos]
    local layer = LayerBossDetail.new(cb, param):pos(0 - display.cx, 0 - display.cy)
    layer:addTo(node, 10)
  end
end

function M:onEventLayerBossInfo(tag, param)
end

function M:onEventIconBossInfo(tag, param)
  local node = self.mCoreNode
  if not param then
    return
  end
  local data = DYCommon.getDataByTag(DataRetainer.AGGRESS_STAGE_INFO, "id", checkstring(param.stageId))
  local layer = LayerRewardPreview.new(data[1])
  layer:addTo(node)
end

function M:onClickBack()
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  local scene = require("app.scenes.ChapterScene").new()
  display.replaceScene(scene, "fade", 0.2)
end

function M:onKeypad(keyCode, event)
  DDLOG("Key %d was on pressed!", keyCode)
  if keyCode == cc.KeyCode.KEY_ESCAPE then
    self:onClickBack()
    return true
  end
  return false
end

function M:onEnter()
  DDLOG(CLASS_NAME .. ": onEnter")
  DYKeypadMgr.regKeyHandler(self.mKeypadListener)
end

function M:onExit()
  DDLOG(CLASS_NAME .. ": onExit")
  DYKeypadMgr.unregKeyHandler(self.mKeypadListener)
  DYNotification.removeAllObservers(self)
  DYRes.unloadFileInfo(self.mFileInfo)
end

return M
