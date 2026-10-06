local TreasurePieceIcon = require("app.icons.TreasurePieceIcon")
local TreasurePage = class("TreasurePage", function()
  return display.newNode()
end)

function TreasurePage:ctor(treasureId)
  self.mTreasureId = treasureId
  self:performWithDelay(function()
    self:initTreasureData(self.mTreasureId)
    self:initPiecePosition()
    self:initScrollView()
  end, 0.01)
end

function TreasurePage:initTreasureData(treasureId)
  local treasureModel = DataUtils.getTreasureModel(treasureId)
  self.treasureId_ = tonumber(treasureModel.treasureId_)
  self.treasureName_ = treasureModel.treasureName_
  self.treasureDesc_ = treasureModel.treasureDesc_
  self.treasureIconPath_ = treasureModel.treasureIconPath_
  self.attribIconPath_ = treasureModel.attribIconPath_
  self.attribNamePath_ = treasureModel.attribNamePath_
  self.treasureEffect_ = treasureModel.treasureEffect_
  self.isTreasureEffective_ = treasureModel.isTreasureEffective_
  self.effectIncreaseRate_ = tonumber(treasureModel.effectIncreaseRate_)
  self.treasurePieceIconTable_ = {}
end

function TreasurePage:initPiecePosition()
  local point1 = cc.p(725, 564)
  local point2 = cc.p(819, 467)
  local point3 = cc.p(825, 331)
  local point4 = cc.p(758, 200)
  local point5 = cc.p(624, 147)
  local point6 = cc.p(479, 183)
  local point7 = cc.p(398, 292)
  local point8 = cc.p(393, 424)
  local point9 = cc.p(463, 544)
  local point10 = cc.p(587, 583)
  self.piecePosTable_ = {
    point1,
    point2,
    point3,
    point4,
    point5,
    point6,
    point7,
    point8,
    point9,
    point10
  }
end

function TreasurePage:initScrollView()
  local nGoldPieceNum = 0
  local nSilverPieceNum = 0
  local nCopperPieceNum = 0
  local bg = display.newSprite("treasure/treasure_frame.png")
  bg:setAnchorPoint(0, 0)
  self:addChild(bg)
  display.newSprite(string.format("treasure/treasure" .. self.treasureId_ .. "_name.png"), 196, 614):addTo(bg)
  display.newSprite(string.format(self.attribNamePath_), 196, 160):addTo(bg, 1)
  cc.ui.UILabel.new({
    UILabelType = cc.ui.UILabel.LABEL_TYPE_TTF,
    text = self.treasureEffect_,
    size = 20,
    color = cc.c3b(32, 13, 6)
  }):align(display.CENTER, 196, 125):addTo(bg, 1)
  display.newSprite(string.format(self.attribIconPath_), 196, 220):scale(0.75):addTo(bg, 1)
  for i = 1, 10 do
    local treasurePieceId = (self.treasureId_ - 1) * 10 + i
    local treasurePieceModel = DataUtils.getTreasurePieceModel(treasurePieceId)
    local treasurePiecePos = self.piecePosTable_[i]
    local treasurePieceIcon = TreasurePieceIcon.new(treasurePieceModel)
    treasurePieceIcon:setPosition(treasurePiecePos)
    bg:addChild(treasurePieceIcon, 1)
    table.insert(self.treasurePieceIconTable_, treasurePieceIcon)
    local quality = tonumber(treasurePieceModel.treasurePieceQuality_)
    if quality == 1 then
      nCopperPieceNum = nCopperPieceNum + 1
    elseif quality == 2 then
      nSilverPieceNum = nSilverPieceNum + 1
    elseif quality == 3 then
      nGoldPieceNum = nGoldPieceNum + 1
    end
  end
  local pieceLabel = display.newSprite("treasure/label1.png", 140, 560):addTo(bg, 1)
  local goldPieceNumLabel = cc.ui.UILabel.new({
    UILabelType = 2,
    text = nGoldPieceNum,
    size = 26,
    color = cc.c3b(41, 20, 2),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, 255, 510):addTo(bg, 1)
  local upPic1 = display.newSprite("treasure/up.png", 295, 520):addTo(bg, 1)
  upPic1:setVisible(false)
  local upNumLabel1 = DYLabelTTF.new({
    text = "",
    font = GameManager.FONTNAME_TTF,
    size = 18,
    color = cc.c3b(0, 255, 0)
  }, {}):pos(295, 495):addTo(bg, 1)
  upNumLabel1:setVisible(false)
  local silverPieceNumLabel = cc.ui.UILabel.new({
    UILabelType = 2,
    text = nSilverPieceNum,
    size = 26,
    color = cc.c3b(41, 20, 2),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, 255, 460):addTo(bg, 1)
  local upPic2 = display.newSprite("treasure/up.png", 295, 470):addTo(bg, 1)
  upPic2:setVisible(false)
  local upNumLabel2 = DYLabelTTF.new({
    text = "",
    font = GameManager.FONTNAME_TTF,
    size = 18,
    color = cc.c3b(0, 255, 0)
  }, {}):pos(295, 445):addTo(bg, 1)
  upNumLabel2:setVisible(false)
  local copperPieceNumLabel = cc.ui.UILabel.new({
    UILabelType = 2,
    text = nCopperPieceNum,
    size = 26,
    color = cc.c3b(41, 20, 2),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, 255, 410):addTo(bg, 1)
  local upPic3 = display.newSprite("treasure/up.png", 295, 420):addTo(bg, 1)
  upPic3:setVisible(false)
  local upNumLabel3 = DYLabelTTF.new({
    text = "",
    font = GameManager.FONTNAME_TTF,
    size = 18,
    color = cc.c3b(0, 255, 0)
  }, {}):pos(295, 395):addTo(bg, 1)
  upNumLabel3:setVisible(false)
  local progressLabel = display.newSprite("treasure/treasure_label1.png", 196, 355):addTo(bg, 1)
  self.treasurePic_ = display.newSprite("treasure/treasure0_pic.png")
  self.treasurePic_:setPosition(610, 380)
  bg:addChild(self.treasurePic_)
  local isTreasureCompleted = self.isTreasureEffective_
  if isTreasureCompleted then
    pieceLabel:setTexture("treasure/label2.png")
    progressLabel:setTexture("treasure/treasure_label2.png")
    upPic1:setVisible(true)
    upPic2:setVisible(true)
    upPic3:setVisible(true)
    local upNum1 = nGoldPieceNum
    local upNum2 = nSilverPieceNum * 0.5
    local upNum3 = nCopperPieceNum * 0.3
    local increaseRate = self.effectIncreaseRate_
    upNumLabel1:setVisible(true)
    upNumLabel1:setString(string.format("%.1f%%", upNum1))
    upNumLabel2:setVisible(true)
    upNumLabel2:setString(string.format("%.1f%%", upNum2))
    upNumLabel3:setVisible(true)
    upNumLabel3:setString(string.format("%.1f%%", upNum3))
    DYLabelTTF.new({
      text = string.format("%.1f%%", increaseRate),
      color = cc.c3b(0, 255, 0),
      font = GameManager.FONTNAME_TTF,
      size = 24
    }, {}):pos(200, progressLabel:getContentSize().height * 0.5):addTo(progressLabel, 1)
    if DataUtils.getIsTreasureUnlockAnimationPlayed(self.treasureId_) then
      self.treasurePic_:setTexture(self.treasureIconPath_)
      display.addSpriteFrames("animation/shengli_xingxing.plist", "animation/shengli_xingxing.png")
      local frames = display.newFrames("shengli-xingxing%d.png", 1, 19)
      local animation = display.newAnimation(frames, 0.12)
      local emptySp = display.newSprite():scale(1.2):pos(self.treasurePic_:getContentSize().width * 0.5, self.treasurePic_:getContentSize().height * 0.5):addTo(self.treasurePic_, 1)
      emptySp:playAnimationForever(animation)
    else
      self:playUnlockAnimation_()
      DYNotification.post(DY_KEY.kUnlockTreasure, self.treasureId_)
    end
  else
    local currPieceNum = nGoldPieceNum + nSilverPieceNum + nCopperPieceNum
    cc.ui.UILabel.new({
      UILabelType = 1,
      text = currPieceNum,
      font = "fonts/red.fnt"
    }):align(display.CENTER, progressLabel:getContentSize().width * 0.7, progressLabel:getContentSize().height * 0.46):scale(0.9):addTo(progressLabel)
    cc.ui.UILabel.new({
      UILabelType = 1,
      text = "/10",
      font = "fonts/whiteNum.fnt"
    }):align(display.CENTER, progressLabel:getContentSize().width * 0.85, progressLabel:getContentSize().height * 0.54):scale(0.75):addTo(progressLabel)
  end
end

function TreasurePage:playUnlockAnimation_()
  DYSoundMgr.playEffect(DY_SND.sfx_treasure_get)
  display.addSpriteFrames("animation/treasure_tx.plist", "animation/treasure_tx.png")
  local frames = display.newFrames("treasure_pic%d.png", 1, 20)
  local animation = display.newAnimation(frames, 0.1)
  local emptySp = display.newSprite():pos(self.treasurePic_:getContentSize().width * 0.5, self.treasurePic_:getContentSize().height * 0.5):addTo(self.treasurePic_, 1)
  emptySp:playAnimationOnce(animation, true, function()
    DataUtils.setIsTreasureUnlockAnimationPlayed(self.treasureId_, true)
  end)
  self.treasurePic_:runAction(transition.sequence({
    cc.FadeOut:create(2),
    cc.CallFunc:create(function()
      self.treasurePic_:setTexture(self.treasureIconPath_)
      self.treasurePic_:setOpacity(255)
    end)
  }))
  display.addSpriteFrames("animation/shengli_xingxing.plist", "animation/shengli_xingxing.png")
  local frames = display.newFrames("shengli-xingxing%d.png", 1, 19)
  local animation = display.newAnimation(frames, 0.12)
  local emptySp = display.newSprite():scale(1.2):pos(self.treasurePic_:getContentSize().width * 0.5, self.treasurePic_:getContentSize().height * 0.5):addTo(self.treasurePic_, 1)
  emptySp:playAnimationForever(animation)
  local newPic = display.newSprite(self.treasureIconPath_):opacity(0):pos(self.treasurePic_:getPosition()):addTo(self.treasurePic_:getParent())
  newPic:runAction(transition.sequence({
    cc.FadeIn:create(2),
    cc.CallFunc:create(function()
      newPic:removeSelf()
    end)
  }))
end

return TreasurePage
