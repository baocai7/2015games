local IconItem = require("app.icons.IconItem")
local CLASS_NAME = "LayerPurgatoryBox"
local M = {}
M = class(CLASS_NAME, function()
  return display.newLayer()
end)

function M:ctor(stageId, index)
  print(stageId .. "    " .. index)
  self.mKeypadListener = handler(self, self.onKeypad)
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  self.mNode = display.newNode():pos(display.cx, display.cy):addTo(self, 1)
  self.mTitle = ""
  self.mTurn = 1
  self.mPercent = 0
  self.mNormalReward = {}
  self.mRandomReward = {}
  self.mStageId = checknumber(stageId)
  self.mShowStage = self.mStageId
  self.mIndex = checknumber(index)
  self.mBg = nil
  self.mTurnImg = nil
  self.mTitleLab = nil
  self.mBossHpLab = nil
  self.mNorRewardList = nil
  self.mRanRewardList = nil
  self.mSwitchLab = nil
  self:initData()
  self:initBg()
  self:setNodeEventEnabled(true)
end

function M:initData()
  local purgatoryInfo = DYCommon.getDataByTag(DataRetainer.PURGATORY_STAGE_INFO, "id", checkstring(self.mShowStage))[1]
  if not purgatoryInfo then
    DDERROR("purgatoryInfo index : %d with error data", checknumber(self.mShowStage))
    self:closeCallBack()
    return
  end
  local bossInfo = DataUtils.getMonsterModel(checknumber(purgatoryInfo.monsterId))
  if not bossInfo then
    DDERROR("bossInfo id : %d with error data", checknumber(purgatoryInfo.monsterId))
    self:closeCallBack()
    return
  end
  self.mTitle = checkstring(bossInfo.npcName)
  self.mTurn = math.ceil(self.mShowStage / 8)
  local boxInfo = DYCommon.getDataByTag(DataRetainer.PURGATORY_BOX, "stageId", checkstring(self.mShowStage))[1]
  if not boxInfo then
    DDERROR("purgatory_box info index : %d with error data", checknumber(self.mShowStage))
    self:closeCallBack()
    return
  end
  local percentInfo = {
    80,
    50,
    0
  }
  self.mPercent = checknumber(percentInfo[self.mIndex])
  self.mNormalReward = {}
  local fixed = split(boxInfo["fixedBox" .. self.mIndex], ";")
  for i = 1, #fixed do
    local data = split(fixed[i], ",")
    local id = checknumber(data[1])
    if 0 < id then
      local info = {
        id = id,
        num = checknumber(data[2])
      }
      table.insert(self.mNormalReward, info)
    end
  end
  self.mRandomReward = {}
  local random = split(boxInfo["randomBox" .. self.mIndex], ";")
  for i = 1, #random do
    local id = checknumber(random[i])
    if 0 < id then
      local info = {id = id}
      table.insert(self.mRandomReward, info)
    end
  end
end

function M:initBg()
  local h = 486
  if self.mRandomReward and #self.mRandomReward > 0 then
    h = 691
  end
  local bg = display.newScale9Sprite("common_ui/common_dialog.png", 0, 0, cc.size(598, h), cc.rect(300, 140, 1, 1)):addTo(self.mNode)
  self.mBg = bg
  cc.ui.UIPushButton.new({
    normal = "common_ui/close_normal.png",
    pressed = "common_ui/close_pressed.png"
  }):align(display.TOP_RIGHT, bg:getContentSize().width + 10, bg:getContentSize().height + 10):addTo(bg):onButtonClicked(function()
    self:closeCallBack()
  end)
  self:addContent()
  self:addButton()
  self:addNormalreward()
  self:addRandomreward()
end

function M:addContent()
  display.newSprite("#box_tip" .. self.mTurn .. ".png"):scale(1.1):align(display.CENTER_RIGHT, 265, self.mBg:getContentSize().height - 70):addTo(self.mBg)
  DYLabelTTF.new({
    text = self.mTitle,
    size = 30,
    color = cc.c3b(255, 200, 53),
    dyalign = "CENTER_LEFT",
    font = GameManager.FONTNAME_TTF
  }, {
    lineWidth = 2,
    lineColor = cc.c3b(0, 0, 0, 255)
  }):align(display.CENTER_LEFT, 291, self.mBg:getContentSize().height - 70):addTo(self.mBg)
  local boxStr = display.newSprite("stage/box_text.png"):align(display.CENTER_LEFT, 60, self.mBg:getContentSize().height - 127):addTo(self.mBg)
  local str = "(BOSS\229\137\169\228\189\153\232\161\128\233\135\143" .. self.mPercent .. "%\229\143\175\233\162\134\229\143\150)"
  DYLabelTTF.new({
    text = str,
    size = 22,
    color = cc.c3b(53, 255, 6),
    dyalign = "CENTER_LEFT",
    font = GameManager.FONTNAME_TTF
  }, {
    lineWidth = 2,
    lineColor = cc.c3b(0, 0, 0, 255)
  }):align(display.CENTER_LEFT, boxStr:getContentSize().width + 10, boxStr:getContentSize().height * 0.5):addTo(boxStr)
end

function M:addButton()
  if self.mTurn == 8 and self.mStageId >= self.mShowStage then
    return
  end
  local str = DYLang.getString("S785", "")
  if self.mShowStage > self.mStageId then
    str = DYLang.getString("S788", "")
  end
  cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png"
  }):align(display.CENTER, self.mBg:getContentSize().width * 0.5, 71):addTo(self.mBg):setButtonLabel("normal", DYLabelTTF.new({
    text = str,
    size = 30,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(25, 30, 3)
  })):onButtonClicked(function()
    self:clickSwitchBtn()
  end)
end

function M:addNormalreward()
  if not self.mNormalReward or #self.mNormalReward == 0 then
    return
  end
  local norStr = display.newSprite("#reward_nor.png"):align(display.CENTER_LEFT, 60, self.mBg:getContentSize().height - 184):addTo(self.mBg)
  display.newSprite("#award_str.png"):align(display.CENTER_LEFT, norStr:getContentSize().width + 10, norStr:getContentSize().height * 0.5):addTo(norStr)
  local frame = display.newScale9Sprite("common_ui/common_frame11.png", 0, 0, cc.size(514, 150), cc.rect(50, 50, 2, 2)):pos(self.mBg:getContentSize().width * 0.5, norStr:getPositionY() - 106):addTo(self.mBg)
  local norlist = cc.ui.UIListView.new({
    viewRect = cc.rect(7, 15, 501, 120),
    direction = cc.ui.UIScrollView.DIRECTION_HORIZONTAL
  }):addTo(frame)
  for i = 1, #self.mNormalReward do
    local item = norlist:newItem()
    local content = IconItem.new(self.mNormalReward[i].id, self.mNormalReward[i].num)
    content:showItemTip()
    content:setScale(0.9)
    item:addContent(content)
    item:setItemSize(120, 120)
    norlist:addItem(item)
  end
  norlist:reload()
end

function M:addRandomreward()
  if not self.mRandomReward or #self.mRandomReward == 0 then
    return
  end
  local ranStr = display.newSprite("#reward_ran.png"):align(display.CENTER_LEFT, 60, 297):addTo(self.mBg)
  local frame = display.newScale9Sprite("common_ui/common_frame11.png", 0, 0, cc.size(514, 150), cc.rect(50, 50, 2, 2)):pos(self.mBg:getContentSize().width * 0.5, ranStr:getPositionY() - 101):addTo(self.mBg)
  local ranlist = cc.ui.UIListView.new({
    viewRect = cc.rect(7, 15, 501, 120),
    direction = cc.ui.UIScrollView.DIRECTION_HORIZONTAL
  }):addTo(frame)
  for i = 1, #self.mRandomReward do
    local item = ranlist:newItem()
    local content = IconItem.new(self.mRandomReward[i].id)
    content:showItemTip()
    content:setScale(0.9)
    item:addContent(content)
    item:setItemSize(120, 120)
    ranlist:addItem(item)
  end
  ranlist:reload()
end

function M:clickSwitchBtn()
  self.mBg:runAction(cc.RemoveSelf:create())
  if self.mShowStage > self.mStageId then
    self.mShowStage = self.mStageId
  else
    self.mShowStage = self.mStageId + 8
  end
  self:initData()
  self:initBg()
end

function M:closeCallBack()
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
