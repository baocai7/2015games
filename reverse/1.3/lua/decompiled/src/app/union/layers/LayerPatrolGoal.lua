local IconItem = require("app.icons.IconItem")
local IconBox = require("app.icons.IconBox")
local DYClass = "LayerPatrolGoal"
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
  self.mMaxIntegral = checknumber(info and info.maxDistri)
  self.mGoalIntegralSum = checknumber(info and info.curPro)
  self.mGoalIntegralMax = checknumber(info and info.maxPro)
  self.mMyIntegral = checknumber(info and info.integral)
  self.mMyRank = checknumber(info and info.rank)
  self.mTimeLeft = checkstring(info and info.time)
  self.mBoxes = info.box or {}
  self.mMaxReward = {}
  self.mCanBeClicked = false
  self.mBg = nil
  self.mBoxIcon = {}
  self:initUI()
  self:initData()
  self.mKeypadListener = handler(self, self.onKeypad)
  self:setNodeEventEnabled(true)
end

function M:initUI()
  local bg = display.newSprite("union/patrol/img_goal_bottom.png", 0, 0):addTo(self.mNode)
  self.mBg = bg
  display.newSprite("union/patrol/img_patrol_title3.png", 235, 655):addTo(self.mNode)
  cc.ui.UIPushButton.new({
    normal = "common_ui/close_normal.png",
    pressed = "common_ui/close_pressed.png"
  }):align(display.CENTER, 418, 651):onButtonClicked(function()
    self:closeCallBack()
  end):addTo(bg, 2)
end

function M:initData()
  local mark = false
  local sum = DataUtils.getPatrolGoalSum()
  for i = 1, sum do
    local info = DataUtils.getPatrolGoal(i)
    local state = checknumber(self.mBoxes[checkstring(i + 1)])
    if self.mGoalIntegralSum < info.integral then
      self.mBoxes[i] = {
        state = state,
        num = info.integral,
        tag = 0
      }
      if not mark then
        self.mMaxReward = info.extra
        mark = true
      end
    elseif info.integral > 0 then
      self.mBoxes[i] = {
        state = state,
        num = info.integral,
        tag = 1
      }
    elseif not mark then
      self.mMaxReward = info.extra
      mark = true
    end
  end
  self:loadGoalUI()
  self:loadContriProReward()
  self.mCanBeClicked = true
end

function M:loadGoalUI()
  cc.ui.UILabel.new({
    text = DYLang.getString("MAX_INTEGRAL", "") .. self.mMaxIntegral,
    size = 24,
    color = cc.c3b(80, 30, 0),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, 235, 579):addTo(self.mBg)
  cc.ui.UILabel.new({
    text = DYLang.getString("MAX_INTEGRAL_REWARD", ""),
    size = 24,
    color = cc.c3b(180, 120, 80),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, 76, 518):addTo(self.mBg)
  for i = 1, #self.mMaxReward do
    local icon = IconItem.new(self.mMaxReward[i].id)
    icon:showItemTip()
    icon:setScale(0.6)
    icon:setPosition(31 + 80 * i, 460)
    self.mBg:addChild(icon)
    cc.ui.UILabel.new({
      UILabelType = 1,
      text = checknumber(self.mMaxReward[i].num),
      font = "fonts/whiteNum.fnt"
    }):align(display.BOTTOM_RIGHT, 50, -45):scale(1):addTo(icon, 1)
  end
  cc.ui.UILabel.new({
    text = DYLang.getString("STR_INTEGRAL_DIS", ""),
    size = 24,
    color = cc.c3b(180, 120, 80),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, 76, 376):addTo(self.mBg)
  local str = DYLang.getString("STR_CUR_PROGRESS", "") .. string.format(" %d/%d", self.mGoalIntegralSum, self.mGoalIntegralMax)
  cc.ui.UILabel.new({
    text = str,
    size = 24,
    color = cc.c3b(80, 30, 0),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, 58, 198):addTo(self.mBg)
  cc.ui.UILabel.new({
    text = DYLang.getString("STR_MY_INTEGRAL", "") .. " " .. self.mMyIntegral,
    size = 24,
    color = cc.c3b(80, 30, 0),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, 58, 159):addTo(self.mBg)
  local str = self.mMyRank
  if 0 >= self.mMyRank then
    str = DYLang.getString("S762", "")
  end
  cc.ui.UILabel.new({
    text = DYLang.getString("STR_NY_RANK", "") .. " " .. str,
    size = 24,
    color = cc.c3b(80, 30, 0),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, 58, 117):addTo(self.mBg)
  cc.ui.UILabel.new({
    text = DYLang.getString("STR_LAST_TIME", "") .. " " .. self.mTimeLeft,
    size = 24,
    color = cc.c3b(80, 30, 0),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, 58, 77):addTo(self.mBg)
end

function M:loadContriProReward()
  local barBg = display.newSprite("union/patrol/img_detail_bar_01.png"):pos(235, 328):addTo(self.mBg)
  local mark = checknumber(self.mBoxes[1] and self.mBoxes[1].num)
  local max = DataUtils.getMaxPatrolGoal()
  local rate = (self.mGoalIntegralSum - mark) / (max - mark) * 100
  rate = 0 < rate and rate or 0
  rate = rate <= 100 and rate or 100
  self.mContriPro = cc.ProgressTimer:create(display.newSprite("union/patrol/img_detail_bar_02.png")):addTo(barBg)
  self.mContriPro:setType(cc.PROGRESS_TIMER_TYPE_BAR)
  self.mContriPro:setPosition(barBg:getContentSize().width * 0.5, barBg:getContentSize().height * 0.5)
  self.mContriPro:setMidpoint(cc.p(0, 0))
  self.mContriPro:setBarChangeRate(cc.p(1, 0))
  self.mContriPro:setPercentage(rate)
  for i = 1, #self.mBoxes do
    local state = checknumber(self.mBoxes[i].state)
    local num = checknumber(self.mBoxes[i].num)
    local tag = checknumber(self.mBoxes[i].tag)
    local per = (num - mark) / (max - mark)
    local boxState = 0
    if tag == 1 then
      if 0 == state then
        boxState = 1
      elseif 1 == state then
        boxState = 2
      end
    end
    local box = IconBox.new(i, boxState)
    box:setPosition(barBg:getContentSize().width * per, barBg:getContentSize().height * 0.5)
    box:setScale(0.7142857142857143)
    barBg:addChild(box)
    self.mBoxIcon[i] = box
    local lb = DYLabelTTF.new({
      text = num,
      size = 24,
      color = cc.c3b(80, 30, 0),
      font = GameManager.FONTNAME_TTF
    }):pos(box:getPositionX(), box:getPositionY() - 46):addTo(barBg)
    local pNode = display.newNode():pos(box:getPositionX(), box:getPositionY()):addTo(barBg, 1)
    pNode:setAnchorPoint(0.5, 0.5)
    pNode:setContentSize(85, 85)
    pNode:setTouchEnabled(true)
    pNode:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
      if event.name == "began" then
        return true
      elseif event.name == "ended" then
        self:getBoxReward(i)
      end
    end)
  end
end

function M:getBoxReward(index)
  if not self.mCanBeClicked or not self.mBoxIcon[index] then
    return
  end
  self.mCanBeClicked = false
  local state = checknumber(self.mBoxes[index].state)
  local tag = checknumber(self.mBoxes[index].tag)
  local id = index + 1
  local info = DataUtils.getPatrolGoal(id)
  local boxInfo = {
    boxInfo = info.item
  }
  if state == 0 and tag == 0 then
    DYSoundMgr.playEffect(DY_SND.sfx_touch)
    self.mBoxIcon[index]:showBox(boxInfo)
    self.mCanBeClicked = true
  elseif state == 0 and tag == 1 then
    local function tFuncListener(json)
      if not (self and self.class) or self.class.__cname ~= DYClass then
        return
      elseif checknumber(json.errorCode) ~= 0 then
        local msg = json.errorMsg or "UNKNOWN"
        local toast = WSToast.new(msg, 2)
        self:addChild(toast, 20)
        self.mCanBeClicked = true
      else
        self.mBoxes[index].state = 1
        local rewardInfo = json.data and json.data.drop or {}
        for id, sum in pairs(rewardInfo) do
          DataUtils.updateItemNum(id, sum)
        end
        local dropGain = json.data and json.data.dropGain or {}
        local awardInfo = {}
        for k, v in pairs(dropGain) do
          table.insert(awardInfo, {
            id = checknumber(k),
            num = checknumber(v)
          })
        end
        self.mBoxIcon[index]:openBox({boxInfo = awardInfo})
        self.mCanBeClicked = true
      end
    end
    
    local params = {
      clanId = CloudData.UNION_INFO.id,
      id = id
    }
    DYHttpMgr.patrolGoalBox(tFuncListener, params)
  else
    self.mCanBeClicked = true
  end
end

function M:updateGoalState()
end

function M:closeCallBack()
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  if self.mCallback then
    local info = {}
    local isNew = false
    for i = 1, #self.mBoxes do
      local state = checknumber(self.mBoxes[i].state)
      local tag = checknumber(self.mBoxes[i].tag)
      info[checkstring(i + 1)] = state
      if state == 0 and tag == 1 then
        isNew = true
      end
    end
    self.mCallback(info, isNew)
  end
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
  DDLOG(DYClass .. ": onEnter")
  DYKeypadMgr.regKeyHandler(self.mKeypadListener)
end

function M:onExit()
  DDLOG(DYClass .. ": onExit")
  DYKeypadMgr.unregKeyHandler(self.mKeypadListener)
end

return M
