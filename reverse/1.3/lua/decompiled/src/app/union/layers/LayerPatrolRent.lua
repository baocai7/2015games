local DYClass = "LayerPatrolRent"
local M = {}
M = class(DYClass, function()
  return display.newLayer()
end)

function M.scene(cb)
  local scene = display.newScene()
  scene:addChild(M.new(cb))
  return scene
end

function M:ctor(info, callback)
  self.mNode = display.newNode():pos(display.cx, display.cy):addTo(self)
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  self.mCallback = callback
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  self.mMarkId = checknumber(info.id)
  self.mRentId = self.mMarkId
  self.mRentStar = 0
  self.mRentLv = 0
  self.mIdInTeam = {}
  self.mBuddhaInfo = {}
  self.mBg = nil
  self.mGrid = nil
  self.mCanBeClicked = false
  self.mIsClosed = false
  local strKeys = {
    DY_KEY.kBuddhaOnTeam,
    DY_KEY.kTeamPurgatory,
    DY_KEY.kAssistPurgatory,
    DY_KEY.kBuddhaOnAssist
  }
  for i = 1, #strKeys do
    local stringBuddhaIds = DYStat.getValueStr(strKeys[i], "")
    local tempTable = explode(",", stringBuddhaIds)
    for k, v in pairs(tempTable) do
      if "" ~= v then
        table.insert(self.mIdInTeam, v)
      end
    end
  end
  self:initUI()
  self.mKeypadListener = handler(self, self.onKeypad)
  self:setNodeEventEnabled(true)
end

function M:initUI()
  local bg = display.newSprite("union/patrol/img_rent_bottom.png", 0, 0):addTo(self.mNode)
  self.mBg = bg
  cc.ui.UIPushButton.new({
    normal = "common_ui/close_normal.png",
    pressed = "common_ui/close_pressed.png"
  }):align(display.CENTER, 931, 633):onButtonClicked(function()
    self:clickClose()
  end):addTo(bg, 2)
  self:loadBuddha()
  self:loadTeam()
  self.mCanBeClicked = true
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
  local teamIcon = display.newScale9Sprite("common_ui/common_frame4.png", 0, 0, cc.size(122, 187), cc.rect(40, 35, 2, 2))
  teamIcon:setOpacity(0)
  teamIcon:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    return self:onTouchIcon(event, buddhaModel)
  end)
  teamIcon:setTouchEnabled(true)
  teamIcon:setTouchSwallowEnabled(false)
  local icon = newBuddhaIcon(buddhaModel)
  icon:setPosition(61, 127)
  teamIcon:addChild(icon)
  local pTypePic = display.newSprite(string.format("team/symbol%d.png", buddhaModel.symbol)):pos(59, 59):addTo(icon)
  DYLabelTTF.new({
    text = DYLang.getString("STR_LV", "") .. buddhaModel.level,
    size = 24,
    color = display.COLOR_WHITE,
    font = GameManager.FONTNAME_TTF,
    dyalign = "BOTTOM_RIGHT"
  }, {
    lineColor = cc.c3b(0, 0, 0)
  }):align(display.BOTTOM_RIGHT, icon:getContentSize().width * 0.91, icon:getContentSize().height * 0.02):addTo(icon)
  local spiritFrame = display.newSprite("union/patrol/img_stone.png"):pos(61, 42):addTo(teamIcon)
  cc.ui.UILabel.new({
    text = buddhaModel.consume,
    size = 24,
    color = cc.c3b(80, 30, 0),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, spiritFrame:getContentSize().width * 0.63, spiritFrame:getContentSize().height * 0.4):addTo(spiritFrame)
  local mask
  
  function teamIcon.select()
    teamIcon:setTouchEnabled(false)
    if mask then
      mask:runAction(cc.RemoveSelf:create())
      mask = nil
    end
    mask = display.newSprite("union/patrol/img_icon_fighting.png"):pos(59, 59):addTo(icon, 2)
  end
  
  function teamIcon.unselect()
    teamIcon:setTouchEnabled(true)
    if mask then
      mask:runAction(cc.RemoveSelf:create())
      mask = nil
    end
  end
  
  function teamIcon.disable(target, str)
    teamIcon:setTouchEnabled(false)
    local maskFrame = display.newSprite("union/patrol/img_icon_inf.png"):pos(59, 59):addTo(icon, 1)
    DYLabelTTF.new({
      text = str,
      size = 24,
      color = display.COLOR_WHITE,
      font = GameManager.FONTNAME_TTF,
      dyalign = "CENTER"
    }, {
      lineColor = cc.c3b(90, 30, 50)
    }):align(display.CENTER, 59, 57):addTo(maskFrame)
  end
  
  if buddhaModel.inTask ~= 0 then
    teamIcon:disable(DYLang.getString("STR_IN_PATROL", ""))
  end
  return teamIcon
end

function M:loadBuddha()
  local buddhaIds = DataUtils.getBuddhaIdsTableTeamScene()
  local list = cc.ui.UIListView.new({
    viewRect = cc.rect(90, 175, 790, 430),
    direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
  }):addTo(self.mBg)
  local totalNum = #buddhaIds
  local row = math.ceil(totalNum / 6)
  local column = totalNum % 6
  local endNum = 6
  for i = 1, row do
    if i == row and column ~= 0 then
      endNum = column
    end
    local item = list:newItem()
    local content = display.newNode()
    for count = 1, endNum do
      local index = (i - 1) * 6 + count
      local id = buddhaIds[index]
      local buddhaModel = DataUtils.getBuddhaModelPatrol(id)
      if checknumber(id) == checknumber(self.mMarkId) then
        buddhaModel.inTask = 0
      end
      local teamIcon = newListIcon(buddhaModel, self)
      teamIcon:setPosition(130 * count - 65, 80)
      content:addChild(teamIcon)
      if buddhaModel.inTask == 0 then
        self.mBuddhaInfo[checkstring(id)] = teamIcon
      end
    end
    content:setContentSize(780, 187)
    item:addContent(content)
    item:setItemSize(780, 187)
    list:addItem(item)
  end
  list:reload()
  for i = 1, #self.mIdInTeam do
    local id = checkstring(self.mIdInTeam[i])
    if self.mBuddhaInfo[id] then
      self.mBuddhaInfo[id]:disable(DYLang.getString("STR_IN_TEAM", ""))
      self.mBuddhaInfo[id] = nil
    end
  end
end

function M:loadTeam()
  local icon = cc.ui.UIPushButton.new("common_ui/frame0.png"):align(display.CENTER, 480, 78):onButtonPressed(function(event)
    event.target:setScale(0.9)
  end):onButtonRelease(function(event)
    event.target:setScale(1)
  end):onButtonClicked(function()
    self:putBuddhaDownTeam()
  end):addTo(self.mBg)
  self.mGrid = icon
  display.newSprite("wiki/q0.png"):pos(0, 0):addTo(icon)
  if self.mRentId ~= 0 then
    local buddhaModel = DataUtils.getBuddhaModelPatrol(self.mRentId)
    local icon = newBuddhaIcon(buddhaModel)
    icon:setPosition(self.mGrid:getContentSize().width * 0.5, self.mGrid:getContentSize().height * 0.53)
    self.mGrid:addChild(icon)
    self.mGrid.icon = icon
    local id = checkstring(self.mRentId)
    if self.mBuddhaInfo[id] then
      self.mBuddhaInfo[id]:select()
    end
    self.mRentStar = checknumber(buddhaModel.starLevel)
    self.mRentLv = checknumber(buddhaModel.level)
  end
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
  if not buddhaModel or self.mRentId ~= 0 or not self.mCanBeClicked then
    return
  end
  self.mCanBeClicked = false
  if self.mSound then
    DYSoundMgr.stopEffect(self.mSound)
  end
  self.mSound = DYSoundMgr.playEffect(buddhaModel.buddhaSound)
  self.mRentId = checknumber(buddhaModel.npcId)
  self.mRentStar = checknumber(buddhaModel.starLevel)
  self.mRentLv = checknumber(buddhaModel.level)
  local icon = newBuddhaIcon(buddhaModel)
  icon:setPosition(self.mGrid:getContentSize().width * 0.5, self.mGrid:getContentSize().height * 0.53)
  self.mGrid:addChild(icon)
  self.mGrid.icon = icon
  local id = checkstring(self.mRentId)
  if self.mBuddhaInfo[id] then
    self.mBuddhaInfo[id]:select()
  end
  self.mCanBeClicked = true
end

function M:putBuddhaDownTeam()
  if not self.mRentId or not self.mCanBeClicked then
    return
  end
  self.mCanBeClicked = false
  local id = checkstring(self.mRentId)
  self.mRentId = 0
  if self.mBuddhaInfo[id] then
    self.mBuddhaInfo[id]:unselect()
  end
  if self.mGrid.icon then
    self.mGrid.icon:runAction(cc.RemoveSelf:create())
    self.mGrid.icon = nil
  end
  self.mCanBeClicked = true
end

function M:clickClose()
  if self.mIsClosed then
    return
  end
  self.mIsClosed = true
  if self.mSound then
    DYSoundMgr.stopEffect(self.mSound)
  end
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  
  local function tFuncListener(json)
    if not (self and self.class) or self.class.__cname ~= DYClass then
      return
    elseif checknumber(json.errorCode) ~= 0 then
      self.mRentId = self.mMarkId
      local msg = json.errorMsg or "UNKNOWN"
      local toast = WSToast.new(msg, 2)
      self:addChild(toast, 20)
    else
      if CloudData.NPC_INFO[self.mMarkId] then
        CloudData.NPC_INFO[self.mMarkId].inTask = 0
      end
      if CloudData.NPC_INFO[self.mRentId] then
        CloudData.NPC_INFO[self.mRentId].inTask = 1
      end
      self:closeCallBack()
    end
  end
  
  if self.mRentId == self.mMarkId then
    self:closeCallBack()
  else
    local params = {
      clanId = CloudData.UNION_INFO.id,
      buddhaId = self.mRentId
    }
    DYHttpMgr.changeRentId(tFuncListener, params)
  end
end

function M:closeCallBack()
  if self.mCallback then
    self.mCallback(self.mRentId)
  end
  self:runAction(cc.RemoveSelf:create())
end

function M:changeRentId()
end

function M:onKeypad(keyCode, event)
  DDLOG("Key %d was on pressed!", keyCode)
  if keyCode == cc.KeyCode.KEY_ESCAPE then
    self:clickClose()
    return true
  end
  return false
end

function M:onEnter()
  DDLOG(DYClass .. ": onEnter")
  DYKeypadMgr.regKeyHandler(self.mKeypadListener)
end

function M:onExit()
  DDLOG(DYClass .. ": onExit")
  DYKeypadMgr.unregKeyHandler(self.mKeypadListener)
end

return M
