local M = {}
M = class("IconStage", function()
  return display.newNode()
end)

function M:ctor(stageNum)
  self.mBg = nil
  self.mStageNum = stageNum
  self.mIsUnlock = false
  self.mSelectedRing = nil
  self.mStars = 0
  self.mModel = 0
  self.mTitle = ""
  self.mTreasureIcon = nil
  self:initData()
end

function M:initData()
  local stageInfo = DYCommon.getDataByTag(DataRetainer.STAGE_INFO, "id", tostring(self.mStageNum + 10000))[1]
  if not stageInfo then
    DDERROR("stageInfo index : %d with error data", tonumber(self.mStageNum + 10000))
    return
  end
  self.mModel = tonumber(stageInfo.gameMode)
  if self.mStageNum % 10 == 5 then
    self.mTitle = DYLang.getString("S399", "")
  elseif self.mStageNum % 10 == 0 then
    self.mTitle = "Boss"
  elseif self.mModel == 1 then
    self.mTitle = DYLang.getString("S400", "")
  elseif self.mModel == 2 then
    self.mTitle = DYLang.getString("S401", "")
  else
    self.mTitle = DYLang.getString("S402", "") .. self.mStageNum .. " \229\133\179"
  end
  local info = CloudData.CHAPTER_INFO_TABLE.main.stageInfo[tostring(self.mStageNum + 10000)]
  if info ~= nil and 0 < tonumber(info.starCount) then
    self.mStars = tonumber(info.starCount)
  end
  local progress = tonumber(CloudData.CHAPTER_INFO_TABLE.main.stageId) % 10000
  local curStage = progress + 1
  if curStage < self.mStageNum then
    self:initGrayIcon()
  elseif curStage > self.mStageNum then
    self:initNormalIcon(true)
  else
    self:initNormalIcon(false)
  end
end

local function getTitle(stage, model)
  if stage % 10 == 5 then
    return "stage_title_elite"
  elseif stage % 10 == 0 then
    return "stage_title_boss"
  elseif model == 1 then
    return "stage_title_card"
  elseif model == 2 then
    return "stage_title_help"
  else
    return
  end
end

function M:initNormalIcon(tag)
  self.mIsUnlock = true
  self.mBg = display.newSprite("stage/icon_normal.png"):addTo(self)
  if tag then
    display.newSprite("stage/pass_main.png", self.mBg:getContentSize().width * 0.24, self.mBg:getContentSize().height * 0.91):addTo(self.mBg, 2)
  end
  display.newSprite("stage/treasure_bg.png", self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.47):addTo(self.mBg)
  local treasurePieceQuality = DataUtils.getTreasurePieceQuality(self.mStageNum)
  if treasurePieceQuality ~= 0 then
    self.mTreasureIcon = display.newSprite("treasure/piece" .. treasurePieceQuality .. ".png", self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.47):addTo(self.mBg)
  end
  for i = 1, self.mStars do
    display.newSprite("stage/star.png", self.mBg:getContentSize().width * (0.1 + i * 0.2), self.mBg:getContentSize().height * 0.17):addTo(self.mBg)
  end
  for i = 3, self.mStars + 1, -1 do
    display.newSprite("stage/star_gray.png"):pos(self.mBg:getContentSize().width * (0.1 + i * 0.2), self.mBg:getContentSize().height * 0.17):addTo(self.mBg)
  end
  local img = getTitle(self.mStageNum, self.mModel)
  if img then
    display.newSprite("stage/" .. img .. ".png"):pos(self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.78):addTo(self.mBg)
  else
    cc.ui.UILabel.new({
      text = DYLang.getString("S402", "") .. self.mStageNum .. " \229\133\179",
      size = 25,
      color = cc.c3b(109, 66, 9),
      font = GameManager.FONTNAME_TTF
    }):align(display.CENTER, self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.78):addTo(self.mBg)
  end
end

function M:initGrayIcon()
  self.mIsUnlock = false
  self.mBg = display.newSprite("stage/icon_gray.png"):addTo(self)
  display.newSprite("stage/lock.png"):pos(self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.39):addTo(self.mBg)
  local img = getTitle(self.mStageNum, self.mModel)
  if img then
    display.newSprite("stage/" .. img .. "1.png"):pos(self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.78):addTo(self.mBg)
  else
    cc.ui.UILabel.new({
      text = DYLang.getString("S402", "") .. self.mStageNum .. " \229\133\179",
      size = 25,
      color = cc.c3b(188, 187, 187),
      font = GameManager.FONTNAME_TTF
    }):align(display.CENTER, self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.78):addTo(self.mBg)
  end
end

function M:setSelected()
  if self.mSelectedRing then
    self.mSelectedRing:removeSelf()
    self.mSelectedRing = nil
  end
  self.mSelectedRing = display.newScale9Sprite("common_ui/frame_selected.png", 0, 0, cc.size(180, 215), cc.rect(55, 55, 5, 5)):pos(self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.5):addTo(self.mBg, 1)
end

function M:updateTreasure()
  local quality = DataUtils.getTreasurePieceQuality(self.mStageNum)
  if self.mTreasureIcon then
    self.mTreasureIcon:setTexture("treasure/piece" .. quality .. ".png")
  elseif 0 < quality then
    self.mTreasureIcon = display.newSprite("treasure/piece" .. quality .. ".png", self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.47):addTo(self.mBg)
  end
end

function M:setNormal()
  if self.mSelectedRing then
    self.mSelectedRing:removeSelf()
    self.mSelectedRing = nil
  end
end

return M
