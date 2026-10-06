local WSToast = require("app.utils.WSToast")
local LayerPVPMatchInfo = require("app.layers.LayerPVPMatchInfo")
local LayerPVPTeam = require("app.layers.LayerPVPTeam")
local CLASS_NAME = "LayerPVPLog"
local M = {}
M = class(CLASS_NAME, function()
  return display.newLayer()
end)

function M:ctor(time)
  DDLOG(CLASS_NAME .. ": onCreate")
  self.mKeypadListener = handler(self, self.onKeypad)
  self:setNodeEventEnabled(true)
  self.mNode = nil
  self.mLogTable = CloudData.PVP_INFO.fightLog or {}
  self.mCommondTime = time
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  self.mNode = display.newNode():scale(0):pos(display.cx, display.cy):addTo(self, 1)
  local popupLayer = transition.sequence({
    cc.ScaleTo:create(0.2, 1.1),
    cc.ScaleTo:create(0.1, 1)
  })
  self.mNode:runAction(popupLayer)
  self:initUI()
end

function M:initUI()
  self.mBg = display.newSprite("pvp/log_bg.png"):addTo(self.mNode)
  cc.ui.UIPushButton.new({
    normal = "common_ui/close_normal.png",
    pressed = "common_ui/close_pressed.png"
  }):onButtonClicked(function()
    self:closeCallBack()
  end):align(display.TOP_RIGHT, self.mBg:getContentSize().width, self.mBg:getContentSize().height):addTo(self.mBg, 1)
  self.mList = cc.ui.UIListView.new({
    viewRect = cc.rect(67, 60, 880, 492),
    direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
  }):addTo(self.mBg)
  if not self.mLogTable then
    return
  end
  for i = 1, #self.mLogTable do
    self:newLogIcon(i)
  end
  self.mList:reload()
end

local function getTime(t, standard)
  local time = tonumber(standard) - tonumber(t)
  if not time or time < 0 then
    return ""
  end
  local day = math.floor(time / 86400)
  time = time % 86400
  local hour = math.floor(time / 3600)
  if 0 < day then
    local str = day .. DYLang.getString("S806", "")
    return str
  elseif 0 < hour then
    local str = hour .. DYLang.getString("S807", "")
    return str
  else
    local minutes = math.floor(time / 60)
    if 0 < minutes then
      local str = minutes .. DYLang.getString("S808", "")
      return str
    else
      return "1\229\136\134\233\146\159\229\134\133"
    end
  end
end

function M:newLogIcon(index)
  local item = self.mList:newItem()
  local content = display.newScale9Sprite("common_ui/common_frame10.png", 0, 0, cc.size(876, 168), cc.rect(45, 45, 2, 2))
  item:addContent(content)
  item:setItemSize(941, 175)
  self.mList:addItem(item)
  local info = self.mLogTable[index]
  if not info then
    return
  end
  local img = "pvp/win.png"
  if tonumber(info.isWin) == 0 then
    img = "pvp/lose.png"
  end
  display.newSprite(img):align(display.LEFT_TOP, 15, content:getContentSize().height):addTo(content)
  local myIcon = display.newSprite("common_ui/frame3.png", 346, content:getContentSize().height * 0.6):scale(0.9):addTo(content)
  if info.selfIcon == "" then
    info.selfIcon = nil
  end
  display.newSprite(GameManager.USER_ICON_PATH .. info.selfIcon .. ".png"):pos(myIcon:getContentSize().width * 0.5, myIcon:getContentSize().height * 0.5):addTo(myIcon)
  local myLevel = cc.ui.UILabel.new({
    UILabelType = 2,
    text = "LV." .. info.selfLevel,
    size = 20,
    color = cc.c3b(255, 255, 255),
    font = GameManager.FONTNAME_TTF
  }):align(display.BOTTOM_RIGHT, myIcon:getContentSize().width * 0.98, myIcon:getContentSize().height * 0.05):addTo(myIcon)
  myLevel:enableOutline(cc.c4b(0, 0, 0, 255), 2)
  cc.ui.UILabel.new({
    UILabelType = 2,
    text = info.selfName,
    size = 22,
    color = cc.c3b(53, 26, 3),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_TOP, myIcon:getContentSize().width * 0.5, -10):addTo(myIcon)
  local opponentIcon = display.newSprite("common_ui/frame3.png", 627, content:getContentSize().height * 0.6):scale(0.9):addTo(content)
  if info.targetIcon == "" then
    info.targetIcon = nil
  end
  display.newSprite(GameManager.USER_ICON_PATH .. info.targetIcon .. ".png"):pos(opponentIcon:getContentSize().width * 0.5, opponentIcon:getContentSize().height * 0.5):addTo(opponentIcon)
  local opponentLevel = cc.ui.UILabel.new({
    UILabelType = 2,
    text = "LV." .. info.targetLevel,
    size = 20,
    color = cc.c3b(255, 255, 255),
    font = GameManager.FONTNAME_TTF
  }):align(display.BOTTOM_RIGHT, opponentIcon:getContentSize().width * 0.98, opponentIcon:getContentSize().height * 0.05):addTo(opponentIcon)
  opponentLevel:enableOutline(cc.c4b(0, 0, 0, 255), 2)
  cc.ui.UILabel.new({
    UILabelType = 2,
    text = info.targetName,
    size = 22,
    color = cc.c3b(53, 26, 3),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_TOP, opponentIcon:getContentSize().width * 0.5, -10):addTo(opponentIcon)
  local featLabel = cc.ui.UILabel.new({
    UILabelType = 2,
    text = DYLang.getString("S809", "") .. info.medalPrize,
    size = 28,
    color = cc.c3b(55, 255, 34),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, 210, 28):addTo(content)
  featLabel:enableOutline(cc.c4b(0, 0, 0, 255), 2)
  local vsImg = "pvp/vs_left.png"
  if tonumber(info.isAttacking) == 1 then
    vsImg = "pvp/vs_right.png"
  end
  local vsIcon = display.newSprite(vsImg):pos(488, content:getContentSize().height * 0.5):addTo(content)
  if tonumber(info.isRevenge) == 1 then
    display.newSprite("pvp/revenge.png"):pos(484, content:getContentSize().height * 0.8):addTo(content)
    vsIcon:setPositionY(content:getContentSize().height * 0.5)
  end
  local str = getTime(info.fightTime, self.mCommondTime)
  local timeLabel = cc.ui.UILabel.new({
    UILabelType = 2,
    text = str,
    size = 22,
    color = cc.c3b(232, 200, 163),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, 488, 28):addTo(content)
  timeLabel:enableOutline(cc.c4b(83, 54, 20, 255), 2)
  local detailLabel = cc.ui.UILabel.new({
    UILabelType = 2,
    text = DYLang.getString("S810", ""),
    size = 30,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  })
  detailLabel:enableOutline(cc.c4b(25, 30, 3, 255), 2)
  local detailBtn = cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png"
  }):onButtonPressed(function()
    self:showDetail(index)
  end):scale(0.9):setButtonLabel("normal", detailLabel):align(display.CENTER, 783, content:getContentSize().height * 0.5):addTo(content)
  if tonumber(info.isAttacking) ~= 1 and tonumber(info.isWin) == 0 then
    detailBtn:setPositionY(content:getContentSize().height * 0.7)
    local revengeLabel = cc.ui.UILabel.new({
      UILabelType = 2,
      text = DYLang.getString("S811", ""),
      size = 30,
      color = cc.c3b(255, 240, 0),
      font = GameManager.FONTNAME_TTF
    })
    revengeLabel:enableOutline(cc.c4b(25, 30, 3, 255), 2)
    cc.ui.UIPushButton.new({
      normal = "common_ui/btn_normal1.png",
      pressed = "common_ui/btn_pressed1.png"
    }):onButtonPressed(function()
      self:fight(index)
    end):scale(0.9):setButtonLabel("normal", revengeLabel):align(display.CENTER, 783, content:getContentSize().height * 0.3):addTo(content)
  end
  cc.ui.UILabel.new({
    UILabelType = 2,
    text = DYLang.getString("S812", ""),
    size = 24,
    color = cc.c3b(53, 26, 3),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, 136, 142):addTo(content)
  local curRank = (tonumber(info.newRanking) or 10004) + 1
  local preRank = (tonumber(info.oldRanking) or 10004) + 1
  local curInc = preRank - curRank
  if 10004 < curRank then
    curRank = DYLang.getString("S813", "")
  elseif curRank <= 0 then
    curRank = ""
  end
  cc.ui.UILabel.new({
    UILabelType = 2,
    text = curRank,
    size = 25,
    color = cc.c3b(53, 26, 3),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, 210, 112):addTo(content)
  local rankIncLabel = cc.ui.UILabel.new({
    UILabelType = 2,
    text = "",
    size = 28,
    color = cc.c3b(254, 59, 59),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, 210, 80):addTo(content)
  rankIncLabel:enableOutline(cc.c4b(0, 0, 0, 255), 2)
  if curInc == 0 then
    rankIncLabel:setColor(cc.c3b(255, 255, 255))
    rankIncLabel:setString("( - )")
  elseif 0 < curInc then
    rankIncLabel:setColor(cc.c3b(55, 255, 34))
    rankIncLabel:setString("(" .. curInc .. ")")
    display.newSprite("war_result/up.png"):pos(rankIncLabel:getPositionX() - rankIncLabel:getContentSize().width / 2 - 15, 80):addTo(content)
  else
    curInc = -curInc
    rankIncLabel:setColor(cc.c3b(254, 59, 59))
    rankIncLabel:setString("(" .. curInc .. ")")
    display.newSprite("war_result/down.png"):pos(rankIncLabel:getPositionX() - rankIncLabel:getContentSize().width / 2 - 15, 80):addTo(content)
  end
end

function M:showDetail(index)
  local logInfo = self.mLogTable[index]
  if not logInfo then
    return
  end
  local team = json.decode(logInfo.targetTeam) or {}
  local teamTable = {}
  for i = 1, #team do
    teamTable[i] = {}
    teamTable[i].id = tonumber(team[i].id)
    teamTable[i].num = tonumber(team[i].num)
    teamTable[i].cd = tonumber(team[i].cd)
    teamTable[i].level = tonumber(team[i].level) or 1
    teamTable[i].star = tonumber(team[i].star) or 0
    local info = {
      buddhaId = teamTable[i].id,
      level = teamTable[i].level,
      star = teamTable[i].star
    }
    local model = DataUtils.getBuddhaFeatureInfo(teamTable[i].id, teamTable[i].level)
    teamTable[i].quality = model.quality
    teamTable[i].isRebel = model.isRebel
    teamTable[i].icon = model.npcIcon
    teamTable[i].name = model.npcName
    teamTable[i].tag1 = model.tag1
    teamTable[i].tag2 = model.tag2
    teamTable[i].tag3 = model.tag3
  end
  local info = {
    uid = logInfo.targetUid,
    icon = GameManager.USER_ICON_PATH .. logInfo.targetIcon .. ".png",
    nick = logInfo.targetName,
    level = logInfo.targetLevel,
    sword = logInfo.targetPower,
    buddhaInfo = teamTable
  }
  local detail = LayerPVPMatchInfo.new(info)
  self:addChild(detail, 10)
end

function M:fight(index)
  local function tFuncListener(jsonTable)
    if jsonTable.errorCode ~= 0 then
      local errMsg = jsonTable.errorMsg or "UNKNOWN"
      
      local toast = WSToast.new(errMsg, 2)
      self:addChild(toast, 20)
    else
      local info = jsonTable.data.targetData
      if info == nil then
        DDERROR("opponent info in pvp revenge is null")
        local t = WSToast.new(DYLang.getString("S814", ""), 1)
        self:addChild(t, 100)
        return
      end
      CloudData.savePVPEnemyInfo(info)
      GameManager.IS_REVENGE = 1
      GameManager.STAGE_NUM = 0
      local buddhaList = json.decode(info.defenseTeam) or {}
      local sword = 0
      local cdTable = {}
      if buddhaList then
        local no = 1
        for id, num in pairs(buddhaList) do
          local model = DataUtils.getPVPMonsterModel(id)
          cdTable[no] = {}
          cdTable[no].id = tonumber(id)
          cdTable[no].num = tonumber(num)
          cdTable[no].cd = tonumber(model.cdTime) or 0
          cdTable[no].level = tonumber(model.level) or 1
          cdTable[no].star = tonumber(model.starLevel) or 0
          no = no + 1
          sword = sword + tonumber(model.attackAssessment) * tonumber(num)
        end
      end
      local SP = DataUtils.getMaxSP(info.level)
      GameManager.PVP_ENEMY_INFO = {
        team = json.decode(info.defenseTeam) or {},
        nick = info.nick,
        spirit = SP,
        uid = info.uid,
        sword = sword,
        buddhaInfo = cdTable
      }
      local team = LayerPVPTeam.new(LayerPVPTeam.ATTACK)
      self:addChild(team, 20)
    end
  end
  
  local params = {}
  params.targetID = checknumber(self.mLogTable[index] and self.mLogTable[index].targetUid)
  DYHttpMgr.pvpRevenge(tFuncListener, params)
end

function M:iconCallBack(layer, tag)
  if tag == TAG_REVENGE_LAYER then
    self:addChild(layer, 100, 12345)
    self.mSchedule = self:schedule(function()
      if not self:getChildByTag(12345) then
        self:stopAction(self.mSchedule)
        local attack = PVPAttackTeamLayer.new()
        self:addChild(attack, 10)
      end
    end, 0.1)
  else
    self:addChild(layer, 10)
  end
end

function M:closeCallBack()
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  local popupLayer = transition.sequence({
    cc.ScaleTo:create(0, 1),
    cc.ScaleTo:create(0.1, 1.1),
    cc.ScaleTo:create(0.2, 0),
    cc.CallFunc:create(function()
      self:removeSelf()
    end)
  })
  self.mNode:runAction(popupLayer)
end

function M:toGetData()
  self:initUI()
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
