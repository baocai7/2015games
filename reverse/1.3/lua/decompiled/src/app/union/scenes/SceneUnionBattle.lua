local WSToast = require("app.utils.WSToast")
local LayerFairyland = require("app.union.layers.LayerFairyland")
local LayerBattleAward = require("app.union.layers.LayerBattleAward")
local LayerBattleResult = require("app.union.layers.LayerBattleResult")
local LayerBooty = require("app.union.layers.LayerBooty")
local IconPkBubble = require("app.icons.IconPkBubble")
local LayerRule = require("app.layers.LayerRule")
local Tip = require("app.union.layers.LayerTip")
local CLASS_NAME = "SceneUnionBattle"
local M = {}
M = class(CLASS_NAME, function()
  return display.newScene()
end)

function M:ctor(pTag, callback)
  DDLOG(CLASS_NAME .. ": onCreate")
  self.mTag = pTag
  self.mCallback = callback
  DYSoundMgr.playMusic(DY_SND.bgm_theme_day)
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  self:initBaseUI()
  
  local function tFunc(event)
    dump(event)
    if self.initData and self.initUI then
      self:initData(event)
      self:initUI()
    else
      return
    end
    if self.mTag == Const.UNION_FIGHT_END then
      LayerBattleResult.new():addTo(self, 20)
    end
  end
  
  self:safeSocketRequest("CMD_GET_CLAN_COMPETE_DATA", nil, tFunc)
  self:initPkBubble()
  self.mKeypadListener = handler(self, self.onKeypad)
  self:setNodeEventEnabled(true)
end

function M:initData(event)
  local param = event.defence_clan_info
  local dominate = {}
  dominate.icon = "buddha_icon/buddha" .. param.leader_icon .. ".png"
  if param.leader_icon == "" then
    dominate.icon = nil
  end
  dominate.server = param.server_name
  dominate.union_name = param.clan_name
  dominate.user_name = param.leader_name
  self.mDominate = dominate
  self.mIsOpen = event.is_open
  self.mUnion_Pos = CloudData.UNION_POS
  self.mPosition = event.my_position
  CloudData.LAST_BATTLE_RESULT = event.last_compete_result or {}
  CloudData.MY_CLAN_RANK = event.my_clan_rank_list or {}
  CloudData.IS_UNION_BATTLE_OPEN = event.is_open
end

function M:initPkBubble()
  self.mPkBubble = IconPkBubble.new():addTo(self, 900)
end

function M:initUI()
  self:loadCenterBtn()
  M.createCenterUI(self.mDominate):pos(645, 465):addTo(self.mBg, 2)
  self:initBottomUI()
end

function M:initBaseUI()
  self.mBg = display.newSprite("union/battle/bg.jpg", display.cx, display.cy):addTo(self)
  display.newSprite("union/battle/title.png", display.cx, display.height * 0.92):addTo(self)
  LayerRule.newRuleIcon(LayerRule.UNIONBATTLE):pos(197, 690):addTo(self.mBg, 2)
  cc.ui.UIPushButton.new({
    normal = "union/btn_back.png",
    pressed = "union/btn_back.png"
  }):pos(1080, 685):onButtonPressed(function(event)
    event.target:setScale(0.9)
  end):onButtonRelease(function(event)
    event.target:setScale(1)
  end):onButtonClicked(function()
    self:closeCallBack()
  end):addTo(self.mBg, 2)
end

function M:loadCenterBtn()
  local M_NAME = {
    "union/battle/jiangli.png",
    "union/battle/fudi.png",
    "union/battle/zhanbao.png",
    "union/battle/zhanlipin.png"
  }
  local M_POS = {
    {x = 315, y = 315},
    {x = 970, y = 320},
    {x = 315, y = 145},
    {x = 985, y = 135}
  }
  for i = 1, #M_POS do
    local button = display.newSprite(M_NAME[i]):pos(M_POS[i].x, M_POS[i].y):addTo(self.mBg)
    M.bindClickEvent(button, function()
      self:onEventCenterFunc(i)
    end)
  end
end

function M:initBottomUI()
  local index = 1
  if self.mIsOpen then
    index = 2
  end
  local M_NAME = {
    "union/battle/xfbaoming.png",
    "union/battle/jinrudaochang.png"
  }
  self.mButtomBtn = display.newSprite(M_NAME[index]):pos(640, 140):addTo(self.mBg)
  local label = display.newNode():addTo(self.mBg)
  local text1 = cc.ui.UILabel.new({
    size = 24,
    text = DYLang.getString("S1756", ""),
    color = cc.c3b(255, 255, 255),
    font = GameManager.FONTNAME_TTF
  }):addTo(label)
  text1:enableOutline(cc.c4b(0, 0, 0, 255), 2)
  local text2 = cc.ui.UILabel.new({
    size = 24,
    text = "20:30",
    color = cc.c3b(23, 255, 23),
    font = GameManager.FONTNAME_TTF
  }):pos(84, 0):addTo(label)
  text2:enableOutline(cc.c4b(0, 0, 0, 255), 2)
  label:setPosition(cc.p(532, 50))
  if self.mIsOpen then
    M.bindClickEvent(self.mButtomBtn, function()
      self:enterNext()
    end)
  else
    M.bindClickEvent(self.mButtomBtn, function()
      self:clickSign()
    end)
  end
end

function M.createCenterUI(param)
  local node = display.newSprite("union/battle/wangzuo.png")
  local iconFrame = display.newSprite("union/battle/touxiangkuang.png"):scale(0.75):pos(187, 111):addTo(node, 15)
  local _iconFrame = display.newSprite("common_ui/frame_battle.png"):pos(63, 52):addTo(iconFrame, -2)
  node.mUnionIcon = display.newSprite(param.icon):pos(67, 58):addTo(iconFrame, -1)
  local name_frame = display.newSprite("union/battle/name_frame.png"):align(display.CENTER, node:getContentSize().width * 0.5, 286):addTo(node)
  cc.ui.UILabel.new({
    size = 24,
    text = param.server,
    color = cc.c3b(13, 229, 255),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, name_frame:getContentSize().width * 0.5, name_frame:getContentSize().height * 0.5):addTo(name_frame)
  local name_frame = display.newSprite("union/battle/name_frame.png"):align(display.CENTER, node:getContentSize().width * 0.5, 250):addTo(node)
  cc.ui.UILabel.new({
    size = 24,
    text = param.union_name,
    color = cc.c3b(255, 255, 255),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, name_frame:getContentSize().width * 0.5, name_frame:getContentSize().height * 0.5):addTo(name_frame)
  local name_frame = display.newSprite("union/battle/name_frame.png"):align(display.CENTER, node:getContentSize().width * 0.5, 18):addTo(node)
  local l = cc.ui.UILabel.new({
    size = 24,
    text = param.user_name,
    color = cc.c3b(255, 255, 255),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, name_frame:getContentSize().width * 0.5, name_frame:getContentSize().height * 0.5):addTo(name_frame)
  l:enableOutline(cc.c4b(0, 0, 0, 255), 2)
  return node
end

function M:closeCallBack()
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  local nextScene = require("union.scenes.SceneUnion").new()
  display.replaceScene(nextScene, "fade", 0.2)
end

function M:clickSign()
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  if self.mPosition == Const.UNION_FIGHT_ATTACK or self.mPosition == Const.UNION_FIGHT_DEFENCE then
    WSToast.new(DYLang.getString("S1760", "")):pos(display.cx, display.cy):addTo(self)
    return
  end
  if self.mUnion_Pos == Const.UNION_POS.MEMBER then
    WSToast.new("\229\143\170\230\156\137\228\187\153\229\176\138\229\146\140\233\149\191\232\128\129\230\137\141\232\131\189\230\138\165\229\144\141\228\187\153\229\186\156\230\136\152\239\188\129"):addTo(self)
    return
  end
  local tmpBoss = DataUtils.getUnionBossData(1)
  if tmpBoss.skillAddNum == 0 then
    WSToast.new(DYLang.getString("S1762", "")):pos(display.cx, display.cy):addTo(self)
    return
  end
  
  local function tipSign()
    local function tFunc(event)
      dump(event)
      
      if event.ret_code > 0 then
        WSToast.new(event.err_msg):pos(display.cx, display.cy):addTo(self)
        return
      else
        WSToast.new(DYLang.getString("S1763", "")):pos(display.cx, display.cy):addTo(self)
        self.mPosition = Const.UNION_FIGHT_ATTACK
      end
    end
    
    self:safeSocketRequest("CMD_CLAN_COMPETE_SIGN_UP", nil, tFunc)
  end
  
  Tip.new(DYLang.getString("S1764", ""), function()
    tipSign()
  end):addTo(self, 50)
end

function M:enterNext()
  if self.mPosition == Const.UNION_FIGHT_ATTACK or self.mPosition == Const.UNION_FIGHT_DEFENCE then
    display.replaceScene(require("app.union.scenes.SceneUnionBattleMain").new())
  else
    WSToast.new(DYLang.getString("S1765", "")):pos(display.cx, display.cy):addTo(self)
  end
end

function M:onEventCenterFunc(idx)
  local tFunc = {
    [1] = function()
      LayerBattleAward.new():addTo(self, 20)
    end,
    [2] = function()
      LayerFairyland.new():addTo(self, 20)
    end,
    [3] = function()
      LayerBattleResult.new():addTo(self, 20)
    end,
    [4] = function()
      LayerBooty.new():addTo(self, 20)
    end
  }
  tFunc[idx]()
end

function M.bindClickEvent(node, tFunc)
  node:setTouchEnabled(true)
  node:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    local name, x, y = event.name, event.x, event.y
    if name == "began" then
      node.pointBegan = {x = x, y = y}
      return true
    elseif name == "ended" then
      local pointEnd = {x = x, y = y}
      if math.abs(node.pointBegan.x - pointEnd.x) < 50 and math.abs(node.pointBegan.y - pointEnd.y) < 50 then
        node:runAction(transition.sequence({
          cc.ScaleTo:create(0.1, 1.2),
          cc.ScaleTo:create(0.1, 1),
          cc.CallFunc:create(function()
            tFunc()
          end)
        }))
      end
    end
  end)
  return node
end

function M:onKeypad(keyCode, event)
  DDLOG("Key %d was on pressed!", keyCode)
  if keyCode == cc.KeyCode.KEY_ESCAPE then
    self:closeCallBack()
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
  DYSoundMgr.stopMusic(DY_SND.bgm_theme_day)
  display.removeUnusedSpriteFrames()
  DYKeypadMgr.unregKeyHandler(self.mKeypadListener)
end

return M
