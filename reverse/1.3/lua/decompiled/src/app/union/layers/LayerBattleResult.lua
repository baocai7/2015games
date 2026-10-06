local CLASS_NAME = "LayerBattleResult"
local M = {}
M = class(CLASS_NAME, function()
  return display.newLayer()
end)

function M:ctor()
  DDLOG(CLASS_NAME .. ": onCreate")
  self.mKeypadListener = handler(self, self.onKeypad)
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  self.mNode = display.newNode():pos(display.cx, display.cy):addTo(self, 1)
  self.mWinner = ""
  self.mWinRegion = ""
  self.mGuardInfo = {}
  self.mAttackInfo = {}
  self.mIsAttackSucc = false
  self.mBg = nil
  self:initData()
  self:initBg()
  self:setNodeEventEnabled(true)
end

function M:initData()
  local info = CloudData.LAST_BATTLE_RESULT or {}
  self.mGuardInfo = info.last_defence_clan or {}
  self.mAttackInfo = info.attack_clan_rank_list or {}
  self.mIsAttackSucc = info.is_challenge_success
  if self.mIsAttackSucc and self.mAttackInfo[1] then
    self.mWinner = checkstring(self.mAttackInfo[1].clan_name)
    self.mWinRegion = checkstring(self.mAttackInfo[1].server_name)
  else
    self.mWinner = checkstring(self.mGuardInfo.clan_name)
    self.mWinRegion = checkstring(self.mGuardInfo.server_name)
  end
end

function M:initBg()
  local bg = display.newSprite("task/bg.png", 30, 0):addTo(self.mNode)
  self.mBg = bg
  cc.ui.UIPushButton.new({
    normal = "common_ui/close_normal.png",
    pressed = "common_ui/close_pressed.png"
  }):align(display.TOP_RIGHT, self.mBg:getContentSize().width, self.mBg:getContentSize().height):onButtonClicked(function()
    self:closeCallBack()
  end):addTo(self.mBg, 1)
  local titleBg = display.newSprite("common_ui/title_frame.png", 500, 660):addTo(bg)
  display.newSprite("union/battle/battle_result.png", 217, 49):addTo(titleBg)
  self:addContent()
  self:initGuardInfo()
  self:initAttackInfo()
end

function M:addContent()
  if not self.mWinner or self.mWinner == "" then
    return
  end
  local halo = display.newSprite("union/battle/halo.png"):pos(767, 496):addTo(self.mBg)
  halo:runAction(cc.RepeatForever:create(cc.RotateBy:create(0.5, 90)))
  local nameBg = display.newSprite("union/battle/congratulation.png"):pos(767, 496):addTo(self.mBg)
  DYLabelTTF.new({
    text = self.mWinner,
    size = 35,
    color = cc.c3b(236, 28, 244),
    dyalign = "CENTER",
    font = GameManager.FONTNAME_TTF
  }, {
    lineWidth = 2,
    lineColor = cc.c3b(0, 0, 0, 255)
  }):align(display.CENTER, nameBg:getContentSize().width * 0.5, 45):addTo(nameBg)
  DYLabelTTF.new({
    text = "\227\128\144" .. self.mWinRegion .. "\227\128\145",
    size = 25,
    color = cc.c3b(119, 219, 252),
    dyalign = "CENTER",
    font = GameManager.FONTNAME_TTF
  }, {
    lineWidth = 2,
    lineColor = cc.c3b(0, 0, 0, 255)
  }):align(display.CENTER, nameBg:getContentSize().width * 0.5, -19):addTo(nameBg)
  local img = "union/battle/win_guard.png"
  if self.mIsAttackSucc then
    img = "union/battle/win_attack.png"
  end
  display.newSprite(img):pos(767, 267):addTo(self.mBg)
  local confirmBtn = cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal.png",
    pressed = "common_ui/btn_pressed.png"
  }):align(display.CENTER, 767, 147):addTo(self.mBg):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S1608", ""),
    size = 32,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(25, 30, 3)
  })):onButtonClicked(function()
    self:closeCallBack()
  end)
end

function M:initGuardInfo()
  display.newSprite("union/battle/guard_name.png"):pos(337, 590):addTo(self.mBg)
  local frame = display.newScale9Sprite("pvp_ol/cell_reward.png", 337, 518, cc.size(525, 86), cc.rect(30, 30, 1, 1)):addTo(self.mBg)
  local region = checkstring(self.mGuardInfo.server_name)
  if region == "" then
    return
  end
  DYLabelTTF.new({
    text = "\227\128\144" .. region .. "\227\128\145",
    size = 22,
    color = cc.c3b(119, 219, 252),
    dyalign = "CENTER",
    font = GameManager.FONTNAME_TTF
  }, {
    lineWidth = 2,
    lineColor = cc.c3b(0, 0, 0, 255)
  }):align(display.CENTER, 60, 43):addTo(frame)
  DYLabelTTF.new({
    text = checkstring(self.mGuardInfo.clan_name),
    size = 25,
    color = cc.c3b(255, 221, 26),
    dyalign = "CENTER_LEFT",
    font = GameManager.FONTNAME_TTF
  }, {
    lineWidth = 2,
    lineColor = cc.c3b(0, 0, 0, 255)
  }):align(display.CENTER_LEFT, 120, 43):addTo(frame)
  DYLabelTTF.new({
    text = DYLang.getString("S1609", ""),
    size = 25,
    color = cc.c3b(255, 221, 26),
    dyalign = "CENTER_RIGHT",
    font = GameManager.FONTNAME_TTF
  }, {
    lineWidth = 2,
    lineColor = cc.c3b(0, 0, 0, 255)
  }):align(display.CENTER_RIGHT, 397, 43):addTo(frame)
  DYLabelTTF.new({
    text = checknumber(self.mGuardInfo.score),
    size = 25,
    color = cc.c3b(73, 251, 11),
    dyalign = "CENTER_LEFT",
    font = GameManager.FONTNAME_TTF
  }, {
    lineWidth = 2,
    lineColor = cc.c3b(0, 0, 0, 255)
  }):align(display.CENTER_LEFT, 402, 43):addTo(frame)
end

function M:initAttackInfo()
  display.newSprite("union/battle/attack_list.png"):pos(337, 445):addTo(self.mBg)
  local frame = display.newScale9Sprite("pvp_ol/cell_reward.png", 337, 261, cc.size(525, 317), cc.rect(30, 30, 1, 1)):addTo(self.mBg)
  if not self.mAttackInfo or #self.mAttackInfo == 0 then
    return
  end
  local list = cc.ui.UIListView.new({
    bgColor = cc.c4b(255, 255, 255, 120),
    viewRect = cc.rect(75, 108, 525, 310),
    direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
  }):addTo(self.mBg, 2)
  for i = 1, #self.mAttackInfo do
    local item = list:newItem()
    local content = display.newNode()
    content:setContentSize(525, 105)
    local info = self.mAttackInfo[i]
    local rank
    if i < 4 then
      rank = display.newSprite(string.format("ranking/rank%d.png", i)):pos(60, 52):addTo(content)
    else
      rank = cc.ui.UILabel.new({
        text = i,
        size = 36,
        color = cc.c3b(101, 58, 8),
        font = GameManager.FONTNAME_TTF
      }):align(display.CENTER, 60, 52):addTo(content)
    end
    DYLabelTTF.new({
      text = checkstring(info.clan_name),
      size = 25,
      color = cc.c3b(255, 221, 26),
      dyalign = "CENTER_LEFT",
      font = GameManager.FONTNAME_TTF
    }, {
      lineWidth = 2,
      lineColor = cc.c3b(0, 0, 0, 255)
    }):align(display.CENTER_LEFT, 120, rank:getPositionY() + 20):addTo(content)
    local region = checkstring(info.server_name)
    DYLabelTTF.new({
      text = "\227\128\144" .. region .. "\227\128\145",
      size = 22,
      color = cc.c3b(119, 219, 252),
      dyalign = "CENTER_LEFT",
      font = GameManager.FONTNAME_TTF
    }, {
      lineWidth = 2,
      lineColor = cc.c3b(0, 0, 0, 255)
    }):align(display.CENTER_LEFT, 120, rank:getPositionY() - 18):addTo(content)
    DYLabelTTF.new({
      text = DYLang.getString("S1609", ""),
      size = 25,
      color = cc.c3b(255, 221, 26),
      dyalign = "CENTER_RIGHT",
      font = GameManager.FONTNAME_TTF
    }, {
      lineWidth = 2,
      lineColor = cc.c3b(0, 0, 0, 255)
    }):align(display.CENTER_RIGHT, 397, rank:getPositionY()):addTo(content)
    DYLabelTTF.new({
      text = checknumber(info.score),
      size = 25,
      color = cc.c3b(73, 251, 11),
      dyalign = "CENTER_LEFT",
      font = GameManager.FONTNAME_TTF
    }, {
      lineWidth = 2,
      lineColor = cc.c3b(0, 0, 0, 255)
    }):align(display.CENTER_LEFT, 402, rank:getPositionY()):addTo(content)
    item:addContent(content)
    item:setItemSize(525, 105)
    list:addItem(item)
  end
  list:reload()
end

function M:closeCallBack()
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  self:runAction(cc.RemoveSelf:create())
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
  DYKeypadMgr.unregKeyHandler(self.mKeypadListener)
end

return M
