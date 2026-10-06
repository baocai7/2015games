local LayerPVPLackTime = require("app.layers.LayerPVPLackTime")
local WSToast = require("app.utils.WSToast")
local NoviceGuide = require("app.utils.NoviceGuide")
local CLASS_NAME = "LayerPVPTeam"
local M = {}
local M = {}
M = class("LayerPVPTeam", function()
  return display.newLayer()
end)
M.ATTACK = 1
M.GUARD = 2
M.UNION = 3
local MAX_BUDDHA_NUM = 5

function M:ctor(mType, cb, team)
  DDLOG(CLASS_NAME .. ": onCreate")
  self.mKeypadListener = handler(self, self.onKeypad)
  self:setNodeEventEnabled(true)
  self.mType = mType or M.ATTACK
  self.mCELabel = nil
  self.mSPLabel = nil
  self.mSP = 0
  self.mCE = 0
  self.mMaxSP = 0
  self.mTmpTeam = team
  self.mTeamInfo = team or {}
  self.mTeamChanged = false
  self.mRestTime = 0
  if cb then
    self.cb = cb
  end
  self.mTeamIconTable = {}
  self.mGridIconTable = {}
  self.mTabIconTable = {}
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  self.mNode = display.newNode():pos(display.cx, display.cy):addTo(self, 1)
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  self:initData()
  self:initUI()
  self:dealUserGuide()
end

local function newBuddhaIcon(buddhaModel)
  local iconFrame = display.newSprite(string.format("common_ui/frame%d.png", buddhaModel.quality))
  local icon = display.newSprite(buddhaModel.npcIcon):pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.5):addTo(iconFrame)
  if 0 == buddhaModel.isRebel then
    icon:setScaleX(-1)
  end
  local starPic = display.newSprite(string.format("upgrade/star%d.png", buddhaModel.starLevel)):pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height):addTo(iconFrame, 1)
  return iconFrame
end

local function newListIcon(buddhaModel, self)
  local teamIcon = display.newScale9Sprite("common_ui/common_frame4.png", 0, 0, cc.size(160, 215), cc.rect(40, 35, 2, 2))
  teamIcon:setOpacity(0)
  teamIcon:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    return self:onTouchIcon(event, buddhaModel)
  end)
  teamIcon:setTouchEnabled(true)
  teamIcon:setTouchSwallowEnabled(false)
  local icon = newBuddhaIcon(buddhaModel)
  icon:setPosition(teamIcon:getContentSize().width * 0.5, teamIcon:getContentSize().height * 0.62)
  teamIcon:addChild(icon)
  local pTypePic = display.newSprite(string.format("team/symbol%d.png", buddhaModel.symbol)):pos(icon:getContentSize().width * 0.5, icon:getContentSize().height * 0.5):addTo(icon)
  cc.ui.UILabel.new({
    UILabelType = 1,
    text = "L" .. buddhaModel.level,
    font = "fonts/white_num.fnt"
  }):align(display.BOTTOM_RIGHT, icon:getContentSize().width * 0.91, icon:getContentSize().height * 0.02):addTo(icon)
  local spiritFrame = display.newSprite("team/spirit_frame.png"):pos(teamIcon:getContentSize().width * 0.45, teamIcon:getContentSize().height * 0.24):addTo(teamIcon)
  cc.ui.UILabel.new({
    UILabelType = 1,
    text = buddhaModel.consume,
    font = "fonts/white_num.fnt"
  }):align(display.CENTER, spiritFrame:getContentSize().width * 0.63, spiritFrame:getContentSize().height * 0.4):addTo(spiritFrame)
  local cd = math.ceil(buddhaModel.cdTime)
  local cdLabel = cc.ui.UILabel.new({
    text = string.format(DYLang.getString("S836", ""), cd),
    size = 20,
    color = cc.c3b(255, 246, 7),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_TOP, teamIcon:getContentSize().width * 0.5, teamIcon:getContentSize().height * 0.14):addTo(teamIcon)
  cdLabel:enableOutline(cc.c4b(0, 0, 0, 255), 2)
  return teamIcon
end

function M:initData()
  self.mMaxSP = DataUtils.getMaxSP(CloudData.USER_LEVEL)
  self.mBuddhaModelTable = {
    {},
    {},
    {},
    {}
  }
  local buddhaIds = DataUtils.getBuddhaIdsTableTeamScene()
  for k, v in pairs(buddhaIds) do
    local buddhaModel = DataUtils.getBuddhaModelPVP(v)
    table.insert(self.mBuddhaModelTable[1], buddhaModel)
    for i = 1, 3 do
      if i == buddhaModel.buddhaType then
        table.insert(self.mBuddhaModelTable[i + 1], buddhaModel)
      end
    end
  end
  local team
  if self.mType == M.UNION then
    team = self.mTeamInfo
  else
    local info = CloudData.PVP_INFO or {}
    if self.mType == M.ATTACK then
      team = info.attackTeam or {}
    else
      team = info.defenseTeam or {}
    end
    if team == "" then
      team = {}
    end
    self.mRestTime = checknumber(info.leftFightCount)
  end
  self.mTeamInfo = {}
  if type(team) ~= "table" then
    DDTRACE("LayerPVPTeam.initData", string.format("mType: %s, team: %s", checkstring(self.mType), checkstring(team)))
    return
  end
  for k, v in pairs(team) do
    local info = {}
    info.buddhaId = tonumber(k)
    info.num = tonumber(v)
    info.model = DataUtils.getBuddhaModelPVP(tonumber(k))
    local tag = false
    for i = 1, #self.mTeamInfo do
      if info.model.cdTime < self.mTeamInfo[i].model.cdTime then
        table.insert(self.mTeamInfo, i, info)
        tag = true
        break
      end
    end
    if not tag then
      table.insert(self.mTeamInfo, info)
    end
  end
  for i = 1, #self.mTeamInfo do
    local model = DataUtils.getBuddhaModelPVP(self.mTeamInfo[i].buddhaId)
    self.mTeamInfo[i].model = model
  end
end

function M:initUI()
  self.mBg = display.newSprite("team/bg.png", 45, 70):addTo(self.mNode)
  cc.ui.UIPushButton.new({
    normal = "common_ui/close_normal.png",
    pressed = "common_ui/close_pressed.png"
  }):onButtonClicked(function()
    self:clickCloseBtn()
  end):align(display.CENTER, self.mBg:getContentSize().width * 0.97, self.mBg:getContentSize().height * 0.95):addTo(self.mBg, 2)
  self:initTabBtn()
  self:changeTab(1)
  local frame = display.newSprite("team/ce_panel.png"):pos(self.mBg:getContentSize().width * 0.35, self.mBg:getContentSize().height * 0.1):addTo(self.mBg, 1)
  self.mCELabel = cc.ui.UILabel.new({
    text = "",
    size = 25,
    color = display.COLOR_WHITE,
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, frame:getContentSize().width * 0.62, frame:getContentSize().height * 0.45):addTo(frame)
  self.mCELabel:enableOutline(cc.c4b(0, 0, 0, 255), 2)
  local frame1 = display.newSprite("pvp/spirit.png"):pos(self.mBg:getContentSize().width * 0.65, self.mBg:getContentSize().height * 0.1):addTo(self.mBg, 1)
  self.mSPLabel = cc.ui.UILabel.new({
    text = "",
    size = 25,
    color = display.COLOR_WHITE,
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, frame1:getContentSize().width * 0.62, frame1:getContentSize().height * 0.45):addTo(frame1)
  self.mSPLabel:enableOutline(cc.c4b(0, 0, 0, 255), 2)
  local panel = display.newSprite("team/team_panel.png"):align(display.CENTER_TOP, self.mBg:getContentSize().width * 0.39, 0):addTo(self.mBg)
  for i = 1, 6 do
    local icon = display.newSprite("team/grid_frame.png"):pos(panel:getContentSize().width * (0.16 * i - 0.06), panel:getContentSize().height * 0.5):addTo(panel)
    icon:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
      return self:onTouchGrid(event, i)
    end)
    icon:setTouchEnabled(true)
    table.insert(self.mGridIconTable, icon)
  end
  self:showTeam()
  display.newSprite("pvp/line.png"):align(display.BOTTOM_LEFT, panel:getContentSize().width, -5):addTo(panel)
  local str = DYLang.getString("S837", "")
  if self.mType == M.GUARD or self.mType == M.UNION then
    str = DYLang.getString("S838", "")
  end
  local newLabel = cc.ui.UILabel.new({
    UILabelType = 2,
    text = str,
    size = 30,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  })
  newLabel:enableOutline(cc.c4b(147, 78, 1, 255), 2)
  cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal.png",
    pressed = "common_ui/btn_pressed.png"
  }, {scale9 = true}):onButtonClicked(function()
    self:confirmTeamInfo()
  end):setButtonSize(130, 61):setButtonLabel("normal", newLabel):align(display.CENTER_LEFT, panel:getContentSize().width, panel:getContentSize().height * 0.75):addTo(panel, 2)
  local resetLabel = cc.ui.UILabel.new({
    UILabelType = 2,
    text = DYLang.getString("S839", ""),
    size = 30,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  })
  resetLabel:enableOutline(cc.c4b(147, 78, 1, 255), 2)
  cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal.png",
    pressed = "common_ui/btn_pressed.png"
  }, {scale9 = true}):setButtonSize(130, 61):align(display.CENTER_LEFT, panel:getContentSize().width, panel:getContentSize().height * 0.25):addTo(panel):setButtonLabel("normal", resetLabel):onButtonClicked(function()
    self:resetTeam()
  end)
end

function M:initTabBtn()
  local btnImgTable = {
    {
      normal = "team/btn_all2.png",
      pressed = "team/btn_all2.png",
      disabled = "team/btn_all1.png"
    },
    {
      normal = "team/btn_front2.png",
      pressed = "team/btn_front2.png",
      disabled = "team/btn_front1.png"
    },
    {
      normal = "team/btn_mid2.png",
      pressed = "team/btn_mid2.png",
      disabled = "team/btn_mid1.png"
    },
    {
      normal = "team/btn_back2.png",
      pressed = "team/btn_back2.png",
      disabled = "team/btn_back1.png"
    }
  }
  for i = 1, #btnImgTable do
    local btn = cc.ui.UIPushButton.new(btnImgTable[i]):align(display.CENTER_LEFT, -90, self.mBg:getContentSize().height * (1 - i * 0.15)):onButtonClicked(function()
      DYSoundMgr.playEffect(DY_SND.sfx_touch)
      self:changeTab(i)
    end):addTo(self.mBg)
    table.insert(self.mTabIconTable, btn)
    if 1 == i then
      btn:setButtonEnabled(false)
    end
  end
end

function M:changeTab(tab)
  local index = tab or 1
  for i = 1, #self.mTabIconTable do
    self.mTabIconTable[i]:setButtonEnabled(true)
  end
  self.mTabIconTable[index]:setButtonEnabled(false)
  self.mTeamIconTable = {}
  if self.mListView then
    self.mListView:runAction(cc.RemoveSelf:create())
    self.mListView = nil
  end
  self:showBuddhaList(index)
end

function M:showBuddhaList(index)
  self.mListView = cc.ui.UIListView.new({
    viewRect = cc.rect(70, 110, 850, 420),
    direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
  }):addTo(self.mBg)
  local buddhaInfo = self.mBuddhaModelTable[index]
  local totalNum = #buddhaInfo
  local row = math.ceil(totalNum / 5)
  local column = totalNum % 5
  local endNum = 5
  for i = 1, row do
    if i == row and column ~= 0 then
      endNum = column
    end
    local item = self.mListView:newItem()
    local content = display.newNode()
    for count = 1, endNum do
      local buddhaModel = buddhaInfo[(i - 1) * 5 + count]
      local teamIcon = newListIcon(buddhaModel, self)
      teamIcon:setPosition(170 * count - 85, 100)
      content:addChild(teamIcon)
      table.insert(self.mTeamIconTable, teamIcon)
    end
    content:setContentSize(850, 220)
    item:addContent(content)
    item:setItemSize(850, 220)
    self.mListView:addItem(item)
  end
  self.mListView:reload()
end

function M:showTeam()
  for i = 1, 6 do
    self.mGridIconTable[i]:removeAllChildren()
  end
  self.mSP = 0
  self.mCE = 0
  for i = 1, #self.mTeamInfo do
    if 6 < i then
      break
    end
    local icon = newBuddhaIcon(self.mTeamInfo[i].model)
    icon:setPosition(self.mGridIconTable[i]:getContentSize().width * 0.5, self.mGridIconTable[i]:getContentSize().height * 0.53)
    self.mGridIconTable[i]:addChild(icon)
    self.mGridIconTable[i].numLabel = cc.ui.UILabel.new({
      text = self.mTeamInfo[i].num,
      size = 20,
      color = cc.c3b(255, 255, 255),
      font = GameManager.FONTNAME_TTF
    }):align(display.BOTTOM_RIGHT, icon:getContentSize().width * 0.9, icon:getContentSize().height * 0.05):addTo(icon, 1)
    self.mGridIconTable[i].numLabel:enableOutline(cc.c4b(0, 0, 0, 255), 2)
    self.mSP = self.mSP + self.mTeamInfo[i].model.consume * self.mTeamInfo[i].num
    self.mCE = self.mCE + (self.mTeamInfo[i].model.attackAssessment - self.mTeamInfo[i].model.fateCE) * self.mTeamInfo[i].num
  end
  self.mSPLabel:setString(self.mMaxSP - self.mSP)
  self.mCELabel:setString(self.mCE)
end

function M:onTouchIcon(event, buddhaModel)
  if "began" == event.name then
    self.mBeginPos = cc.p(event.x, event.y)
    return true
  elseif "ended" == event.name then
    local pos = cc.p(event.x, event.y)
    if math.abs(pos.x - self.mBeginPos.x) < 50 and math.abs(pos.y - self.mBeginPos.y) < 50 then
      self:putBuddhaOnTeam(buddhaModel)
    end
  end
end

function M:putBuddhaOnTeam(buddhaModel)
  if not buddhaModel then
    return
  end
  if self.mSound then
    DYSoundMgr.stopEffect(self.mSound)
  end
  self.mSound = DYSoundMgr.playEffect(buddhaModel.buddhaSound)
  local spirit = self.mSP + buddhaModel.consume
  if spirit > self.mMaxSP then
    local t = WSToast.new(DYLang.getString("S840", ""), 1)
    self:addChild(t, 100)
    return
  end
  self.mTeamChanged = true
  for i = 1, 6 do
    if self.mTeamInfo[i] == nil or self.mTeamInfo[i].model.cdTime > buddhaModel.cdTime and 6 > #self.mTeamInfo then
      local buddhaInfo = {}
      buddhaInfo.buddhaId = buddhaModel.buddhaId
      buddhaInfo.model = buddhaModel
      buddhaInfo.num = 1
      table.insert(self.mTeamInfo, i, buddhaInfo)
      self:showTeam()
      break
    elseif self.mTeamInfo[i].buddhaId == buddhaModel.buddhaId then
      if self.mTeamInfo[i].num >= MAX_BUDDHA_NUM then
        local t = WSToast.new(DYLang.getString("S841", ""), 1)
        self:addChild(t, 100)
        return
      end
      self.mTeamInfo[i].num = self.mTeamInfo[i].num + 1
      self.mGridIconTable[i].numLabel:setString(self.mTeamInfo[i].num)
      self.mSP = spirit
      self.mSPLabel:setString(self.mMaxSP - self.mSP)
      self.mCE = self.mCE + buddhaModel.attackAssessment - buddhaModel.fateCE
      self.mCELabel:setString(self.mCE)
      break
    end
  end
end

function M:onTouchGrid(event, index)
  if "began" == event.name then
    self.mBeginPos = cc.p(event.x, event.y)
    return true
  elseif "ended" == event.name then
    local pos = cc.p(event.x, event.y)
    if math.abs(pos.x - self.mBeginPos.x) < 20 and math.abs(pos.y - self.mBeginPos.y) < 20 then
      self:putBuddhaDownTeam(index)
    end
  end
end

function M:putBuddhaDownTeam(index)
  print("index = " .. index)
  if self.mTeamInfo[index] == nil or self.mTeamInfo[index].num == 0 then
    return
  end
  self.mTeamChanged = true
  self.mSP = self.mSP - self.mTeamInfo[index].model.consume
  self.mSPLabel:setString(self.mMaxSP - self.mSP)
  self.mCE = self.mCE - (self.mTeamInfo[index].model.attackAssessment - self.mTeamInfo[index].model.fateCE)
  self.mCELabel:setString(self.mCE)
  local num = self.mTeamInfo[index].num
  if num == 1 then
    self.mGridIconTable[index]:removeAllChildren()
    table.remove(self.mTeamInfo, index)
    self:showTeam()
  else
    self.mTeamInfo[index].num = num - 1
    self.mGridIconTable[index].numLabel:setString(self.mTeamInfo[index].num)
  end
end

function M:confirmTeamInfo()
  if #self.mTeamInfo == 0 then
    local toast = WSToast.new(DYLang.getString("S842", ""), 1.5)
    self:addChild(toast, 100)
    return
  elseif self.mSP > self.mMaxSP then
    local t = WSToast.new(DYLang.getString("S840", ""), 1)
    self:addChild(t, 100)
    return
  elseif self.mType == M.ATTACK then
    self:startFight()
  elseif self.mType == M.UNION then
    self:submitUnionTeam()
  elseif self.mTeamChanged then
    self:save()
  else
    self:closeCallBack()
  end
end

function M:submitUnionTeam()
  DDLOG(DYLang.getString("S844", ""))
  local teamInfo = {}
  local cdTable = {}
  for i = 1, #self.mTeamInfo do
    local buddhaId = self.mTeamInfo[i].buddhaId
    local buddhaNum = self.mTeamInfo[i].num
    teamInfo[tostring(buddhaId)] = buddhaNum
  end
  
  local function tFunc(param)
    dump(param)
    if param.ret_code == 0 then
      WSToast.new(DYLang.getString("S845", "")):addTo(display.getRunningScene(), 20)
      self:clickCloseBtn()
      self:clickCloseBtn()
    else
      WSToast.new(param.err_msg):addTo(self, 20)
    end
  end
  
  self.mUnionTeam = teamInfo
  self:safeSocketRequest("CMD_SET_CLAN_COMPETE_TEAM", {team = teamInfo}, tFunc)
end

function M:startFight()
  local teamInfo = {}
  local cdTable = {}
  for i = 1, #self.mTeamInfo do
    local buddhaId = self.mTeamInfo[i].buddhaId
    local buddhaNum = self.mTeamInfo[i].num
    teamInfo[tostring(buddhaId)] = buddhaNum
    local model = self.mTeamInfo[i].model
    cdTable[i] = {
      id = buddhaId,
      num = buddhaNum,
      cd = model.cdTime,
      level = model.level,
      star = model.starLevel
    }
  end
  GameManager.PVP_BUDDHA_INFO = {
    team = teamInfo,
    nick = CloudData.USER_NAME,
    spirit = self.mMaxSP,
    sword = self.mCE,
    buddhaInfo = cdTable
  }
  if self.mRestTime <= 0 and GameManager.MODE ~= 7 then
    local tip = LayerPVPLackTime.new()
    self:addChild(tip, 100)
  else
    local teamStr = json.encode(teamInfo)
    if GameManager.MODE == 7 then
      if self.cb then
        self.cb("FIGHT", teamInfo)
      end
      return
    end
    
    local function tFuncListener(jsonTable)
      if jsonTable.errorCode ~= 0 then
        local toast = WSToast.new(jsonTable.errorMsg, 2)
        self:addChild(toast, 20)
      else
        CloudData.PVP_INFO.attackTeam = teamInfo
        display.replaceScene(require("scenes.TinyLoadingScene").new("GAME_SCENE"))
      end
    end
    
    local params = {}
    params.AttackTeam = teamStr
    DYHttpMgr.costPVPRaceNum(tFuncListener, params)
  end
end

function M:save()
  local team = {}
  for i = 1, #self.mTeamInfo do
    team[tostring(self.mTeamInfo[i].buddhaId)] = self.mTeamInfo[i].num
  end
  local teamStr = json.encode(team)
  
  local function tFuncListener(jsonTable)
    if jsonTable.errorCode ~= 0 then
      local toast = WSToast.new(jsonTable.errorMsg, 2)
      self:addChild(toast, 20)
    else
      if GameManager.MODE == 7 then
        if self.cb then
          self.cb("SAVE", team)
        end
        self:closeCallBack()
        return
      end
      CloudData.PVP_INFO.defenseTeam = team
      if self.cb then
        self.cb()
      end
      self:closeCallBack()
    end
  end
  
  local params = {}
  params.DefenceTeam = teamStr
  params.power = self.mCE
  DYHttpMgr.updatePVPGuardTeam(tFuncListener, params)
end

function M:resetTeam(warResult)
  DYSoundMgr.playEffect(DY_SND.sfx_touch)
  self.mTeamInfo = {}
  self:showTeam()
end

function M:dealUserGuide()
  local stageProgress = Const.STAGE_PROGRESS or CloudData.MAIN_STAGE_PROGRESS
  local userLevel = CloudData.USER_LEVEL
end

function M:clickCloseBtn()
  if self.mType == M.UNION and self.cb then
    self.mUnionTeam = self.mUnionTeam or self.mTmpTeam or {}
    self.cb(self.mUnionTeam)
  end
  self:closeCallBack()
end

function M:closeCallBack()
  if self.mSound then
    DYSoundMgr.stopEffect(self.mSound)
  end
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  self:runAction(cc.RemoveSelf:create())
end

function M:onKeypad(keyCode, event)
  DDLOG("Key %d was on pressed!", keyCode)
  if keyCode == cc.KeyCode.KEY_ESCAPE then
    self:clickCloseBtn()
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
