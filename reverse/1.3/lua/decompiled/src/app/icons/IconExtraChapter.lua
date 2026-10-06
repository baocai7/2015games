local M = {}
M = class("IconExtraChapter", function()
  return display.newNode()
end)

function M:ctor(chapterNum)
  self.mChapterNum = chapterNum
  self.mIcon = nil
  self.mIsUnlock = false
  self.mIsToUnlock = false
  self.mLockIcon = nil
  self.mShowTip = false
  self.mChapterMaxNum = 0
  self.mPieceTable = {}
  if CloudData.CHAPTER_INFO_TABLE == nil or CloudData.CHAPTER_INFO_TABLE.main == nil then
    self:runAction(cc.RemoveSelf:create())
    return
  end
  self:initData()
  self:initBg()
end

function M:initData()
  local mainProgress = tonumber(CloudData.CHAPTER_INFO_TABLE.main.stageId) % 10000
  local eliteProgress = tonumber(CloudData.CHAPTER_INFO_TABLE.elite.stageId) % 20000
  local mainchapterNum = math.floor(mainProgress / 10) + 1
  self.mChapterMaxNum = math.floor(eliteProgress / 4) + 1
  local chapterInfo = DYCommon.getDataByTag(DataRetainer.ELITE_CHAPTER_INFO, "id", tostring(self.mChapterNum))[1]
  if not chapterInfo then
    DDERROR("eliteChapterInfo index : %d with error data", tonumber(self.mChapterNum))
    return
  end
  self.mUnlockChapterLevel = tonumber(chapterInfo.unlockChapterId)
  local idTable = split(chapterInfo.pieceId, ";")
  for i = 1, #idTable do
    self.mPieceTable[i] = tonumber(idTable[i])
  end
  if mainchapterNum <= self.mUnlockChapterLevel or self.mChapterNum > self.mChapterMaxNum then
    self.mIsUnlock = false
    self.mIsToUnlock = false
    if self.mChapterNum == self.mChapterMaxNum then
      self.mShowTip = true
    end
  elseif self.mChapterNum == self.mChapterMaxNum and not DataUtils.getExtraChapterIsUnlock(self.mChapterNum) then
    self.mIsUnlock = false
    self.mIsToUnlock = true
  else
    self.mIsUnlock = true
    self.mIsToUnlock = false
  end
end

function M:initBg()
  if self.mIsUnlock then
    self.mIcon = display.newSprite("stage/stage_icon" .. self.mChapterNum .. ".png")
    for i = 1, 4 do
      if self.mPieceTable[i] then
        local pieceBg = display.newSprite("stage/piece_icon.png"):align(display.CENTER_TOP, self.mIcon:getContentSize().width * (0.21 * i + 0.07), 5):addTo(self.mIcon)
        local model = DataUtils.getBuddhaFeatureInfo(self.mPieceTable[i])
        if model then
          display.newSprite(model.npcIcon):scale(0.36):align(display.CENTER, pieceBg:getContentSize().width * 0.5, pieceBg:getContentSize().height * 0.5):addTo(pieceBg)
        end
      end
    end
  elseif self.mShowTip then
    self.mIcon = display.newGraySprite("stage/stage_icon" .. self.mChapterNum .. ".png", {
      0.2,
      0.3,
      0.5,
      0.1
    })
    self.mLockIcon = display.newSprite("stage/lock_pic.png", self.mIcon:getContentSize().width * 0.5 + 10, self.mIcon:getContentSize().height * 0.5):scale(1.5):addTo(self.mIcon, 1)
    local starBg = display.newSprite("stage/gray.png", self.mIcon:getContentSize().width * 0.59, -self.mIcon:getContentSize().height * 0.05):addTo(self.mIcon)
    starBg:setScaleX(1.5)
    local tipLabel = cc.ui.UILabel.new({
      text = DYLang.getString("S374", "") .. self.mUnlockChapterLevel .. DYLang.getString("S375", ""),
      size = 18,
      color = cc.c3b(255, 235, 12),
      font = GameManager.FONTNAME_TTF
    }):align(display.CENTER, starBg:getContentSize().width * 0.5, starBg:getContentSize().height * 0.5):addTo(starBg)
    tipLabel:setScaleX(0.6666666666666666)
  else
    self.mIcon = display.newGraySprite("stage/stage_icon" .. self.mChapterNum .. ".png", {
      0.2,
      0.3,
      0.5,
      0.1
    })
    self.mLockIcon = display.newSprite("stage/lock_pic.png", self.mIcon:getContentSize().width * 0.5 + 10, self.mIcon:getContentSize().height * 0.5):scale(1.5):addTo(self.mIcon, 1)
  end
  self.mNewMark = display.newSprite("common_ui/red_point.png"):hide():scale(0.8):align(display.CENTER, 152, 30):addTo(self.mIcon)
  self:checkNewBox()
  if self.mIsToUnlock then
    self:playUnlockAnimation()
  elseif self.mChapterMaxNum == self.mChapterNum and self.mIsUnlock then
    self:runArrowAnimation()
  elseif self.mChapterMaxNum - 1 == self.mChapterNum and self.mIsUnlock then
    self:showPassAni()
  end
  self:setContentSize(cc.size(self.mIcon:getContentSize().width, self.mIcon:getContentSize().height))
  self:addChild(self.mIcon)
end

function M:runArrowAnimation()
  local point1 = cc.p(self.mIcon:getContentSize().width * 0.5 + 15, self.mIcon:getContentSize().height * 0.5 + 75)
  local point2 = cc.p(self.mIcon:getContentSize().width * 0.5 + 15, self.mIcon:getContentSize().height * 0.5 + 100)
  local mark = display.newSprite("stage/mark.png", point2.x, point2.y):addTo(self.mIcon, 2)
  mark:runAction(cc.RepeatForever:create(transition.sequence({
    cc.MoveTo:create(0.5, point1),
    cc.MoveTo:create(0.5, point2)
  })))
end

function M:playUnlockAnimation()
  if self.mLockIcon == nil then
    return
  end
  display.addSpriteFrames("animation/jiesuo.plist", "animation/jiesuo.png")
  local frames1 = display.newFrames("jiesuo%d.png", 1, 30)
  local animation1 = display.newAnimation(frames1, 0.07)
  local animate1 = cc.Animate:create(animation1)
  local chapterIcon = display.newSprite("stage/stage_icon" .. self.mChapterNum .. ".png"):opacity(0):addTo(self, 1)
  local delay1 = cc.DelayTime:create(2.2)
  local delay2 = cc.DelayTime:create(2)
  local delay3 = cc.DelayTime:create(2)
  local fadeOut = cc.FadeOut:create(0.3)
  local fadeIn = cc.FadeIn:create(0.3)
  self.mLockIcon:runAction(animate1)
  self.mIcon:runAction(transition.sequence({delay2, fadeOut}))
  chapterIcon:runAction(transition.sequence({
    delay3,
    fadeIn,
    cc.CallFunc:create(function()
      self.mIcon = nil
      self.mIcon = chapterIcon
      for i = 1, 4 do
        if self.mPieceTable[i] then
          local pieceBg = display.newSprite("stage/piece_icon.png"):align(display.CENTER_TOP, self.mIcon:getContentSize().width * (0.21 * i + 0.07), 5):addTo(self.mIcon)
          local model = DataUtils.getBuddhaFeatureInfo(self.mPieceTable[i])
          if model then
            display.newSprite(model.npcIcon):scale(0.36):align(display.CENTER, pieceBg:getContentSize().width * 0.5, pieceBg:getContentSize().height * 0.5):addTo(pieceBg)
          end
        end
      end
      DataUtils.setExtraChapterIsUnlock(self.mChapterNum, true)
      self.mIsUnlock = true
      self.mIsToUnlock = false
      self:runArrowAnimation()
    end)
  }))
end

function M:showPassAni()
  if CloudData.SHOW_DUNGEON_PASS_ANI == 1 then
    self.mFileInfo = {}
    DYRes.loadFileInfo("animation/tongguan/tongguan.csb", self.mFileInfo)
    DYRes.loadSheet("animation/shengli_xingxing.plist")
    local emptySp = display.newSprite():pos(self.mIcon:getContentSize().width * 0.5 + 10, self.mIcon:getContentSize().height * 0.5 - 20):addTo(self.mIcon, 5)
    local armature = ccs.Armature:create("tongguan")
    armature:getAnimation():setSpeedScale(0.7)
    emptySp:addChild(armature)
    local popuplayer = transition.sequence({
      cc.DelayTime:create(0.3),
      cc.CallFunc:create(function()
        armature:getAnimation():playWithIndex(0)
      end),
      cc.DelayTime:create(2),
      cc.CallFunc:create(function()
        emptySp:runAction(cc.RemoveSelf:create())
        DYRes.unloadFileInfo(self.mFileInfo)
        self.mFileInfo = {}
      end)
    })
    emptySp:runAction(popuplayer)
    local frames1 = display.newFrames("shengli-xingxing%d.png", 1, 19)
    local animation1 = display.newAnimation(frames1, 0.05)
    local animate1 = cc.Animate:create(animation1)
    local emptySp1 = display.newSprite():pos(self.mIcon:getContentSize().width * 0.5 + 10, self.mIcon:getContentSize().height * 0.5):addTo(self.mIcon, 5)
    local func1 = cc.CallFunc:create(function()
      emptySp1:runAction(cc.RemoveSelf:create())
      DYRes.unloadSheet("animation/shengli_xingxing.plist")
    end)
    emptySp1:runAction(transition.sequence({
      cc.DelayTime:create(1.4),
      animate1,
      func1
    }))
  end
end

function M:checkNewBox()
  local num = CloudData.DUNGEON_ELITE_BOX_NUM[tostring(self.mChapterNum)] or 0
  if 0 < num and self.mNewMark then
    self.mNewMark:show()
  elseif self.mNewMark then
    self.mNewMark:hide()
  end
end

function M:getMyBoundingBox()
  local point = cc.p(self:getPositionX(), self:getPositionY())
  local worldpoint = self:getParent():convertToWorldSpace(point)
  local rect = cc.rect(worldpoint.x - self:getContentSize().width * 0.5, worldpoint.y - self:getContentSize().height * 0.5, self:getContentSize().width, self:getContentSize().height)
  return rect
end

return M
