local PanelTopInfo = require("app.pvponline.PanelTopInfo")
local LayerTeam = require("app.layers.LayerTeam")
local LayerMatchPVPOL = require("app.layers.LayerMatchPVPOL")
local LayerPVPOlRankAward = require("app.pvponline.LayerPVPOlRankAward")
local LayerRule = require("app.layers.LayerRule")
local DYClass = "LayerRankInfo"
local M = {}
M = class(DYClass, function()
  return display.newScene(DYClass)
end)
local TIP_CONTENT = {
  [1] = "Tip:\230\175\143\230\151\165\229\137\14110\230\172\161\230\140\145\230\136\152\229\143\175\232\142\183\229\190\151\232\167\146\230\150\151\229\184\129",
  [2] = "Tip:19:00-22:00\228\184\186\229\141\161\230\167\189\229\140\185\233\133\141\230\168\161\229\188\143",
  [3] = "Tip:\229\176\129\231\165\158\228\185\139\230\136\152\233\135\135\231\148\168\229\141\161\230\167\189\230\168\161\229\188\143\229\175\185\230\136\152"
}

function M:ctor()
  self.mNode = display.newNode():pos(display.cx, display.cy):addTo(self)
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  self.mKeypadListener = handler(self, self.onKeypad)
  self:setNodeEventEnabled(true)
end

local function getPlayerIcon(playerInfo)
  local iconFrame = display.newSprite("common_ui/frame_battle.png")
  display.newSprite("buddha_icon/buddha" .. playerInfo.icon .. ".png"):pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.5):addTo(iconFrame)
  DYLabelTTF.new({
    text = string.format("\227\128\138%s\227\128\139", playerInfo.server),
    size = 27,
    color = cc.c3b(24, 120, 240),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):pos(iconFrame:getContentSize().width + 10, iconFrame:getContentSize().height * 0.5 + 40):addTo(iconFrame)
  DYLabelTTF.new({
    text = playerInfo.nick,
    size = 27,
    color = cc.c3b(79, 47, 10),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):pos(iconFrame:getContentSize().width + 10, iconFrame:getContentSize().height * 0.5):addTo(iconFrame)
  DYLabelTTF.new({
    text = "LV." .. playerInfo.level,
    size = 27,
    color = cc.c3b(79, 47, 10),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):pos(iconFrame:getContentSize().width + 10, iconFrame:getContentSize().height * 0.5 - 40):addTo(iconFrame)
  return iconFrame
end

function M:initData()
  self.mCanBeClicked = true
  self.mTipTag = math.random(1, #TIP_CONTENT)
end

function M:initUI()
  local panel = PanelTopInfo.new({
    type = PanelTopInfo.TYPE_RANK
  }):addTo(self.mNode)
  self.mPanel = panel
  local bg = display.newSprite("pvp_ol/bg_rankInfo.png", 640, 320):addTo(panel.mBg)
  self.mBg = bg
  local p = display.newSprite("#label_season.png"):pos(bg:getContentSize().width * 0.25, bg:getContentSize().height * 0.85):addTo(bg)
  DYLabelTTF.new({
    text = string.format("\239\188\136%s\239\188\137", CloudData.SEASON_DURATION),
    size = 24,
    color = cc.c3b(12, 255, 126),
    dyalign = "CENTER_LEFT",
    font = GameManager.FONTNAME_TTF
  }, {}):pos(p:getPositionX() + p:getContentSize().width * 0.5, p:getPositionY()):addTo(bg)
  local figheMode = {
    DYLang.getString("S1182", ""),
    DYLang.getString("S1183", "")
  }
  DYLabelTTF.new({
    text = string.format("%s", figheMode[CloudData.COMPETE_MODE]),
    size = 24,
    color = cc.c3b(0, 170, 240),
    font = GameManager.FONTNAME_TTF
  }, {}):pos(p:getPositionX(), p:getPositionY() - 48):addTo(bg)
  self.mTip = DYLabelTTF.new({
    text = TIP_CONTENT[self.mTipTag],
    size = 24,
    color = cc.c3b(9, 255, 43),
    font = GameManager.FONTNAME_TTF
  }, {}):pos(bg:getContentSize().width * 0.5, 40):addTo(bg, 1)
  LayerRule.newRuleIcon(LayerRule.PVPOLRANK):align(display.CENTER, bg:getContentSize().width * 0.08, bg:getContentSize().height * 0.9):addTo(bg, 2)
  display.newSprite("#line1.png", 547, 330):addTo(self.mBg)
  self:initBuddhaInfo()
  self:initTopThree()
  self:initFuncBtn()
  self:schedule(function()
    self:updateTip()
  end, 10)
end

function M:initBuddhaInfo()
  local iconFrame = display.newSprite("common_ui/frame_battle.png"):align(display.CENTER_LEFT, self.mBg:getContentSize().width * 0.08, self.mBg:getContentSize().height * 0.63):addTo(self.mBg)
  display.newSprite(CloudData.USER_ICON):pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.5):addTo(iconFrame)
  DYLabelTTF.new({
    text = "LV." .. CloudData.USER_LEVEL,
    size = 24,
    color = display.COLOR_WHITE,
    font = GameManager.FONTNAME_TTF,
    dyalign = "RIGHT_CENTER"
  }, {}):pos(iconFrame:getContentSize().width - 10, 22):addTo(iconFrame)
  local nameFrame = display.newSprite("pvp_ol/name_bg.png"):align(display.CENTER_LEFT, iconFrame:getPositionX() + iconFrame:getContentSize().width + 5, iconFrame:getPositionY() + 40):addTo(self.mBg)
  DYLabelTTF.new({
    text = CloudData.USER_NAME,
    size = 24,
    color = display.COLOR_WHITE,
    font = GameManager.FONTNAME_TTF
  }):pos(nameFrame:getContentSize().width * 0.5, nameFrame:getContentSize().height * 0.5):addTo(nameFrame)
  local winCount = CloudData.GRADE_INFO.win_count
  local loseCount = CloudData.GRADE_INFO.lost_count
  local rate = 0
  if 0 < winCount + loseCount then
    rate = math.round(winCount / (winCount + loseCount) * 100)
  end
  local offsetX = 5
  local tb1 = {
    DYLang.getString("S1184", ""),
    DYLang.getString("S1185", ""),
    DYLang.getString("S1186", "")
  }
  local tb2 = {
    winCount,
    loseCount,
    rate
  }
  for i = 1, 3 do
    local lb1 = DYLabelTTF.new({
      text = tb1[i],
      size = 26,
      color = cc.c3b(252, 255, 18),
      font = GameManager.FONTNAME_TTF,
      dyalign = "CENTER_LEFT"
    }, {
      lineColor = cc.c3b(81, 57, 7)
    }):pos(iconFrame:getPositionX() + iconFrame:getContentSize().width + offsetX, iconFrame:getPositionY() - 45):addTo(self.mBg)
    local str = tb2[i]
    if 3 == i then
      str = tb2[i] .. "%"
    end
    local lb2 = DYLabelTTF.new({
      text = str,
      size = 22,
      color = cc.c3b(7, 149, 0),
      font = GameManager.FONTNAME_TTF,
      dyalign = "CENTER_LEFT"
    }):pos(lb1:getPositionX() + lb1:getContentSize().width + 3, lb1:getPositionY()):addTo(self.mBg)
    offsetX = offsetX + lb1:getContentSize().width + lb2:getContentSize().width + 15
  end
  local lb1 = DYLabelTTF.new({
    text = DYLang.getString("S1187", ""),
    size = 24,
    color = cc.c3b(252, 255, 18),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {
    lineColor = cc.c3b(81, 57, 7)
  }):pos(iconFrame:getPositionX() + iconFrame:getContentSize().width + 5, iconFrame:getPositionY() - 5):addTo(self.mBg)
  DYLabelTTF.new({
    text = CloudData.GRADE_INFO.score,
    size = 24,
    color = cc.c3b(7, 149, 0),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):pos(lb1:getPositionX() + lb1:getContentSize().width, lb1:getPositionY()):addTo(self.mBg)
  display.newSprite("#line2.png", 307, 330):addTo(self.mBg)
  local gradeData = DataUtils.getPVPGradeInfo(CloudData.GRADE_INFO.score)
  local iconFrame = display.newSprite("#grade" .. gradeData.grade .. ".png"):align(display.CENTER_LEFT, self.mBg:getContentSize().width * 0.08, self.mBg:getContentSize().height * 0.37):addTo(self.mBg)
  local name = display.newSprite("#name" .. gradeData.grade .. ".png"):align(display.CENTER_LEFT, iconFrame:getPositionX() + iconFrame:getContentSize().width, iconFrame:getPositionY() + 30):addTo(self.mBg)
  if 0 < gradeData.level then
    local levelLabel = display.newSprite("#level" .. gradeData.level .. ".png"):align(display.CENTER_LEFT, name:getPositionX() + name:getContentSize().width, iconFrame:getPositionY() + 30):addTo(self.mBg)
  end
  local barBg = display.newSprite("upgrade/bar_bg.png"):align(display.CENTER_LEFT, iconFrame:getPositionX() + iconFrame:getContentSize().width - 5, iconFrame:getPositionY() - 30):addTo(self.mBg)
  local currNum = gradeData.leftScore
  local needNum = gradeData.countScore
  local lb = DYLabelTTF.new({
    text = string.format("%d/%d", currNum, needNum),
    size = 20,
    color = display.COLOR_WHITE,
    font = GameManager.FONTNAME_TTF
  }, {}):pos(barBg:getContentSize().width * 0.5, barBg:getContentSize().height * 0.5):addTo(barBg, 1)
  if needNum < 0 then
    lb:setString("max")
  end
  local progressTimer = cc.ProgressTimer:create(display.newSprite("upgrade/bar_pro.png")):addTo(barBg)
  progressTimer:setType(cc.PROGRESS_TIMER_TYPE_BAR)
  progressTimer:setPosition(barBg:getContentSize().width * 0.5, barBg:getContentSize().height * 0.5)
  progressTimer:setMidpoint(cc.p(0, 0))
  progressTimer:setBarChangeRate(cc.p(1, 0))
  progressTimer:setPercentage(currNum / needNum * 100)
end

function M:initTopThree()
  local frame = display.newSprite("pvp_ol/bg_top3.png"):pos(self.mBg:getContentSize().width * 0.75, self.mBg:getContentSize().height * 0.66):addTo(self.mBg)
  local gradeFrame = display.newSprite("#frame_grade.png"):pos(frame:getContentSize().width * 0.5, -30):addTo(frame)
  local lb1 = DYLabelTTF.new({
    text = DYLang.getString("S1188", ""),
    size = 30,
    color = cc.c3b(255, 228, 0),
    font = GameManager.FONTNAME_TTF
  }, {}):pos(gradeFrame:getContentSize().width * 0.45, gradeFrame:getContentSize().height * 0.42):addTo(gradeFrame)
  local rankStr = CloudData.GRADE_INFO.ranking + 1
  if 0 > CloudData.GRADE_INFO.ranking then
    rankStr = DYLang.getString("S1189", "")
  end
  DYLabelTTF.new({
    text = rankStr,
    size = 30,
    color = cc.c3b(30, 255, 0),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {}):pos(lb1:getPositionX() + lb1:getContentSize().width * 0.5, lb1:getPositionY()):addTo(gradeFrame)
  for i = 1, 3 do
    local playerInfo = CloudData.COMPETE_LIST[i]
    if not playerInfo then
      return
    end
    local iconFrame = getPlayerIcon(playerInfo):scale(0.65):align(display.CENTER_LEFT, frame:getContentSize().width * 0.33, frame:getContentSize().height * (0.915 - 0.25 * i)):addTo(frame)
    local pTip
    iconFrame:setTouchEnabled(true)
    iconFrame:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
      local name, x, y = event.name, event.x, event.y
      if name == "began" then
        pTip = self:teamInfoShow(playerInfo.team)
        pTip:setPosition(self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.5)
        pTip:addTo(self.mBg, 5)
        return true
      end
      if name == "moved" then
        pTip:show()
      elseif name == "ended" then
        pTip:removeSelf()
        pTip = nil
      end
    end)
  end
end

function M:initFuncBtn()
  local bg = self.mBg
  cc.ui.UIPushButton.new({
    normal = "#btn_reward1.png",
    pressed = "#btn_reward2.png"
  }):onButtonClicked(function()
    self:buttonListener(1)
  end):align(display.CENTER, bg:getContentSize().width * 0.16, bg:getContentSize().height * 0.2):addTo(bg)
  cc.ui.UIPushButton.new({
    normal = "#btn_rank1.png",
    pressed = "#btn_rank2.png"
  }):onButtonClicked(function()
    self:buttonListener(2)
  end):align(display.CENTER, bg:getContentSize().width * 0.38, bg:getContentSize().height * 0.2):addTo(bg)
  cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png"
  }):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S1190", ""),
    size = 26,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(25, 30, 3)
  })):onButtonClicked(function()
    self:buttonListener(3)
  end):align(display.CENTER, bg:getContentSize().width * 0.66, bg:getContentSize().height * 0.18):addTo(bg)
  cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png"
  }):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S1191", ""),
    size = 26,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(25, 30, 3)
  })):onButtonClicked(function()
    self:buttonListener(4)
  end):align(display.CENTER, bg:getContentSize().width * 0.84, bg:getContentSize().height * 0.18):addTo(bg)
  cc.ui.UIPushButton.new({
    normal = "pvp_ol/icon_zoom.png",
    pressed = "pvp_ol/icon_zoom.png"
  }):onButtonPressed(function(event)
    event.target:setScale(0.9)
  end):onButtonRelease(function(event)
    event.target:setScale(1)
  end):onButtonClicked(function()
    self:buttonListener(5)
  end):align(display.CENTER, bg:getContentSize().width * 0.63, bg:getContentSize().height * 0.29):addTo(bg)
end

function M:updateTip()
  self.mTipTag = self.mTipTag + 1
  if self.mTipTag > #TIP_CONTENT then
    self.mTipTag = 1
  end
  self.mTip:setString(TIP_CONTENT[self.mTipTag])
end

function M:buttonListener(tag)
  DDLOG("tag : %d", tag)
  if not self.mCanBeClicked then
    return
  end
  self.mCanBeClicked = false
  local tFunc = {
    [1] = function()
      LayerPVPOlRankAward.new():addTo(self, 20)
    end,
    [2] = function()
      self:rankCallback()
    end,
    [3] = function()
      local function tFunc(attackTeam, helpTeam)
        local params = {}
        
        params.attackTeam = attackTeam
        params.helpTeam = helpTeam
        self:safeSocketRequest("CMD_UPDATE_TEAM", params)
      end
      
      LayerTeam.new(LayerTeam.TEAM_NORMAL, tFunc):addTo(self, 20)
    end,
    [4] = function()
      self:matchCallback()
    end,
    [5] = function()
      self:currRankCallback()
    end
  }
  tFunc[tag]()
  self:performWithDelay(function()
    self.mCanBeClicked = true
  end, 1)
end

function M:rankCallback()
  local pMaskLayer = display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, 15)
  local frame = display.newSprite("pvp_ol/bg_ranking.png"):pos(display.cx, display.cy):addTo(pMaskLayer)
  cc.ui.UIPushButton.new({
    normal = "common_ui/close_normal.png",
    pressed = "common_ui/close_pressed.png"
  }):scale(0.9):onButtonClicked(function()
    pMaskLayer:runAction(cc.RemoveSelf:create())
  end):align(display.CENTER, frame:getContentSize().width * 0.95, frame:getContentSize().height * 0.92):addTo(frame, 2)
  
  local function getCellItemAtIndex(idx)
    local cellItem = display.newScale9Sprite("pvp_ol/cell_reward.png", 0, 0, cc.size(440, 115), cc.rect(30, 30, 1, 1))
    if idx < 4 then
      display.newSprite(string.format("ranking/rank%d.png", idx)):pos(cellItem:getContentSize().width * 0.15, cellItem:getContentSize().height * 0.5):addTo(cellItem)
    else
      local lb = cc.ui.UILabel.new({
        text = idx,
        size = 36,
        color = cc.c3b(101, 58, 8),
        font = GameManager.FONTNAME_TTF
      }):align(display.CENTER, cellItem:getContentSize().width * 0.14, cellItem:getContentSize().height * 0.5):addTo(cellItem)
    end
    local iconFrame = getPlayerIcon(CloudData.COMPETE_LIST[idx]):scale(0.68):align(display.CENTER_LEFT, cellItem:getContentSize().width * 0.33, cellItem:getContentSize().height * 0.5):addTo(cellItem)
    return cellItem
  end
  
  local listView = cc.ui.UIListView.new({
    viewRect = cc.rect(78, 72, 440, 485),
    direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
  }):addTo(frame)
  for i = 1, #CloudData.COMPETE_LIST do
    local item = listView:newItem()
    local content = getCellItemAtIndex(i)
    item:addContent(content)
    item:setItemSize(440, 120)
    listView:addItem(item)
  end
  listView:reload()
end

function M:matchCallback()
  if 2 == CloudData.COMPETE_MODE then
    local teamInfo = DataUtils.getBuddhaTableOnTeam()
    if #teamInfo < 6 then
      WSToast.new(DYLang.getString("S1192", ""), 2):addTo(self, 20)
      return
    end
  end
  
  local function tFuncEvent(param)
    DDLOG(" ================ MATCH_READY !!!!!!!")
    if param.is_open then
      LayerMatchPVPOL.new():addTo(self, 20)
    else
      WSToast.new(DYLang.getString("S1194", "")):addTo(self, 20)
    end
  end
  
  self:safeSocketRequest("CMD_MATCH_STATUS", nil, tFuncEvent)
end

function M:currRankCallback()
  local pMaskLayer = display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, 15)
  local frame = display.newSprite("pvp_ol/bg_ranking1.png", display.cx, display.cy):addTo(pMaskLayer)
  cc.ui.UIPushButton.new({
    normal = "common_ui/close_normal.png",
    pressed = "common_ui/close_pressed.png"
  }):scale(0.9):onButtonClicked(function()
    pMaskLayer:runAction(cc.RemoveSelf:create())
  end):align(display.CENTER, frame:getContentSize().width * 0.95, frame:getContentSize().height * 0.92):addTo(frame, 2)
  
  local function getCellItemAtIndex(idx)
    local cellItem = display.newScale9Sprite("pvp_ol/cell_reward.png", 0, 0, cc.size(440, 115), cc.rect(30, 30, 1, 1))
    local rank = #CloudData.CURR_RANK_LIST - idx + 1
    if rank < 4 then
      display.newSprite(string.format("ranking/rank%d.png", rank)):pos(cellItem:getContentSize().width * 0.15, cellItem:getContentSize().height * 0.5):addTo(cellItem)
    else
      local lb = cc.ui.UILabel.new({
        text = rank,
        size = 36,
        color = cc.c3b(101, 58, 8),
        font = GameManager.FONTNAME_TTF
      }):align(display.CENTER, cellItem:getContentSize().width * 0.14, cellItem:getContentSize().height * 0.5):addTo(cellItem)
    end
    local rankData = CloudData.CURR_RANK_LIST[idx]
    local iconFrame = getPlayerIcon(rankData):scale(0.68):align(display.CENTER_LEFT, cellItem:getContentSize().width * 0.3, cellItem:getContentSize().height * 0.5):addTo(cellItem)
    DYLabelTTF.new({
      text = string.format("\231\167\175\229\136\134:%d", rankData.score),
      size = 18,
      color = cc.c3b(180, 110, 40),
      font = GameManager.FONTNAME_TTF,
      dyalign = "CENTER_LEFT"
    }):pos(310, 22):addTo(cellItem)
    return cellItem
  end
  
  if 0 == #CloudData.CURR_RANK_LIST then
    return
  end
  local listView = cc.ui.UIListView.new({
    viewRect = cc.rect(78, 72, 440, 485),
    direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
  }):addTo(frame)
  for i = #CloudData.CURR_RANK_LIST, 1, -1 do
    local item = listView:newItem()
    local content = getCellItemAtIndex(i)
    item:addContent(content)
    item:setItemSize(440, 120)
    listView:addItem(item)
  end
  listView:reload()
end

function M:teamInfoShow(teamInfo)
  local bg = display.newSprite("ranking/bg_team.png")
  if type(teamInfo) ~= "table" then
    teamInfo = json.decode(teamInfo)
  end
  if teamInfo == nil or #teamInfo == 0 then
    return bg
  end
  for i = 1, #teamInfo do
    local buddhaInfo = teamInfo[i]
    local buddhaModel = DataUtils.getOtherPlayerTeamInfo(buddhaInfo)
    local iconFrame = display.newSprite(string.format("common_ui/frame%d.png", buddhaModel.quality)):scale(0.95):pos(bg:getContentSize().width * (0.15 * i - 0.1) + 55, bg:getContentSize().height * 0.55):addTo(bg)
    local icon = display.newSprite(buddhaModel.icon):pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.5):addTo(iconFrame)
    if 0 == buddhaModel.isRebel then
      icon:setScaleX(-1)
    end
    DYLabelTTF.new({
      text = "LV." .. buddhaModel.level,
      size = 24,
      color = cc.c3b(101, 58, 8),
      font = GameManager.FONTNAME_TTF
    }):pos(iconFrame:getPositionX(), iconFrame:getPositionY() - 70):addTo(bg)
    display.newSprite(string.format("upgrade/star%d.png", buddhaModel.starLevel)):pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height):addTo(iconFrame)
  end
  return bg
end

function M:touchListener(event)
end

function M:onKeypad(keyCode, event)
  DDLOG("Key %d was on pressed!", keyCode)
  if keyCode == cc.KeyCode.KEY_ESCAPE then
    self.mPanel:returnCallBack()
    return true
  end
  return false
end

function M:onEnter()
  DDLOG(DYClass .. ": onEnter")
  display.addSpriteFrames("pvp_ol/ui_pvp_match.plist", "pvp_ol/ui_pvp_match.png")
  display.addSpriteFrames("pvp_ol/ui_pvp_level.plist", "pvp_ol/ui_pvp_level.png")
  GameManager.MODE = 0
  GameManager.IS_USER_BUSY = 0
  self:initData()
  self:initUI()
  DYKeypadMgr.regKeyHandler(self.mKeypadListener)
end

function M:onExit()
  DDLOG(DYClass .. ": onExit")
  DYKeypadMgr.unregKeyHandler(self.mKeypadListener)
end

return M
