local M = {}
M = class("IconExtraStage", function()
  return display.newNode()
end)

function M:ctor(stageNum)
  self.mBg = nil
  self.mStageNum = stageNum
  self.mIsSelected = false
  self.mIsUnlock = false
  self.mBuddhaPic = ""
  local stageInfo = DYCommon.getDataByTag(DataRetainer.STAGE_INFO, "id", tostring(self.mStageNum + 20000))[1]
  if not stageInfo then
    DDERROR("stageInfo index : %d with error data", tonumber(self.mStageNum + 20000))
    return
  end
  local id = tonumber(stageInfo.monsterId)
  local monsterInfo = DataUtils.getMonsterModel(id)
  self.mBuddhaPic = monsterInfo.npcIcon
  local progress = tonumber(CloudData.CHAPTER_INFO_TABLE.elite.stageId) % 20000
  local curStage = progress + 1
  if curStage < self.mStageNum then
    self:showGrayIcon()
  elseif curStage > self.mStageNum then
    self:initNormalIcon(false)
  else
    self:initNormalIcon(true)
  end
end

function M:initNormalIcon(tag)
  self.mIsUnlock = true
  local num = (self.mStageNum - 1) % 4 + 1
  local mark = "stage/psaa_elite.png"
  if tag then
    mark = "stage/challenge.png"
  end
  self.mBg = display.newSprite("stage/bg_elite_pass.png"):addTo(self)
  display.newSprite("stage/elite_num" .. num .. ".png", self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.91):addTo(self.mBg, 1)
  local frame = display.newSprite("common_ui/frame3.png", self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.55):scale(0.8):addTo(self.mBg, 1)
  display.newSprite(self.mBuddhaPic, frame:getContentSize().width * 0.5, frame:getContentSize().height * 0.5):addTo(frame)
  display.newSprite(mark, self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.23):addTo(self.mBg, 1)
end

function M:showGrayIcon()
  self.mIsUnlock = false
  local num = (self.mStageNum - 1) % 4 + 1
  self.mBg = display.newSprite("stage/bg_elite_gray.png"):addTo(self)
  display.newSprite("stage/elite_num_gray" .. num .. ".png", self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.91):addTo(self.mBg, 1)
  local frame = display.newGraySprite("common_ui/frame3.png", {
    0.2,
    0.3,
    0.5,
    0.1
  }):scale(0.8):pos(self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.55):addTo(self.mBg, 1)
  display.newGraySprite(self.mBuddhaPic, {
    0.2,
    0.3,
    0.5,
    0.1
  }):pos(frame:getContentSize().width * 0.5, frame:getContentSize().height * 0.5):addTo(frame)
  local str = DYLang.getString("S376", "") .. num - 1 .. DYLang.getString("S377", "")
  cc.ui.UILabel.new({
    text = str,
    size = 20,
    dimensions = cc.size(123, 60),
    align = cc.ui.TEXT_ALIGN_CENTER,
    color = cc.c3b(205, 0, 0),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.23):addTo(self.mBg)
end

function M:initIcon1()
  local progress = tonumber(CloudData.CHAPTER_INFO_TABLE.elite.stageId) % 20000
  local curStage = progress + 1
  if curStage < self.mStageNum then
    self.mBg = display.newSprite("stage/bg_lock.png"):addTo(self)
    self.mIsUnlock = false
  elseif self.mStageNum == curStage then
    self.mBg = display.newSprite("stage/bg_cur.png"):addTo(self)
    self.mIsUnlock = true
  else
    self.mBg = display.newSprite("stage/bg_unlock.png"):addTo(self)
    display.newSprite("stage/pass.png", self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.14):addTo(self.mBg, 1)
    self.mIsUnlock = true
  end
  local titleColor, icon
  if self.mIsUnlock then
    titleColor = cc.c3b(255, 235, 12)
    local frame = display.newSprite("common_ui/frame3.png", self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.47):addTo(self.mBg, 1)
    display.newSprite(self.mBuddhaPic, frame:getContentSize().width * 0.5, frame:getContentSize().height * 0.5):addTo(frame)
  else
    titleColor = cc.c3b(148, 148, 148)
    local frame = display.newGraySprite("common_ui/frame3.png", {
      0.2,
      0.3,
      0.5,
      0.1
    }):pos(self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.47):addTo(self.mBg, 1)
    display.newGraySprite(self.mBuddhaPic, {
      0.2,
      0.3,
      0.5,
      0.1
    }):pos(frame:getContentSize().width * 0.5, frame:getContentSize().height * 0.5):addTo(frame)
  end
  cc.ui.UILabel.new({
    text = string.format(DYLang.getString("S378", "") .. self.mStageNum .. " \229\133\179"),
    size = 30,
    color = titleColor,
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.76):addTo(self.mBg)
end

return M
