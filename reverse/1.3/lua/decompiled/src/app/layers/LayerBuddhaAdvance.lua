local M = {}
M = class("LayerBuddhaAdvance", function()
  return display.newLayer()
end)

function M:ctor(buddhaModel, handler_)
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  self.mNode = display.newNode():pos(display.cx, display.cy):scale(0):addTo(self, 1)
  local popupLayer = transition.sequence({
    cc.ScaleTo:create(0.2, 1.1),
    cc.ScaleTo:create(0.1, 1)
  })
  self.mNode:runAction(popupLayer)
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  if handler_ then
    self.mHandler = handler_
  end
  self:initData(buddhaModel)
  self:initUI()
end

function M:initData(buddhaModel)
  self.mBuddhaModel = buddhaModel
  self.mName = buddhaModel.npcName
  self.mIcon = buddhaModel.npcIcon
  self.mQuality = buddhaModel.quality
  self.mStarLevel = buddhaModel.starLevel
  self.mLifeAdd = buddhaModel.lifeParamK * 15 * ((self.mStarLevel + 1) ^ 2 - self.mStarLevel ^ 2)
  self.mAttackAdd = buddhaModel.attackParamK * 15 * ((self.mStarLevel + 1) ^ 2 - self.mStarLevel ^ 2)
  self.mPhyDefAdd = buddhaModel.phyDefenceParamK * 15 * ((self.mStarLevel + 1) ^ 2 - self.mStarLevel ^ 2)
  self.mMagDefAdd = buddhaModel.magDefenceParamK * 15 * ((self.mStarLevel + 1) ^ 2 - self.mStarLevel ^ 2)
  self.mIsAdvanceSuccess = false
end

function M:initUI()
  self.mBg = display.newScale9Sprite("common_ui/common_dialog.png", 0, -10, cc.size(598, 641), cc.rect(300, 140, 1, 1)):addTo(self.mNode)
  display.newSprite("upgrade/title1.png"):pos(self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.92):addTo(self.mBg)
  self:advanceInfo()
  self:addAdvanceBtn()
  cc.ui.UIPushButton.new({
    normal = "common_ui/close_normal.png",
    pressed = "common_ui/close_pressed.png"
  }):align(display.CENTER, self.mBg:getContentSize().width * 0.96, self.mBg:getContentSize().height * 0.96):onButtonClicked(function()
    self:closeCallBack()
  end):addTo(self.mBg)
end

function M:advanceInfo()
  local currFrame = display.newSprite(string.format("common_ui/frame%d.png", self.mQuality)):pos(self.mBg:getContentSize().width * 0.2, self.mBg:getContentSize().height * 0.72):addTo(self.mBg)
  local icon = display.newSprite(self.mIcon):pos(currFrame:getContentSize().width * 0.5, currFrame:getContentSize().height * 0.5):addTo(currFrame)
  if 0 == self.mBuddhaModel.isRebel then
    icon:setScaleX(-1)
  end
  DYLabelTTF.new({
    text = self.mName,
    size = 24,
    color = cc.c3b(255, 235, 2),
    font = GameManager.FONTNAME_TTF
  }, {}):pos(currFrame:getPositionX(), currFrame:getPositionY() + currFrame:getContentSize().height * 0.5 + 20):addTo(self.mBg)
  display.newSprite(string.format("upgrade/star%d.png", self.mStarLevel)):pos(currFrame:getPositionX(), currFrame:getPositionY() - currFrame:getContentSize().height * 0.5 - 20):addTo(self.mBg)
  local nextFrame = display.newSprite(string.format("common_ui/frame%d.png", self.mQuality)):pos(self.mBg:getContentSize().width * 0.8, self.mBg:getContentSize().height * 0.72):addTo(self.mBg)
  self.mNextIcon = display.newSprite(self.mIcon):pos(nextFrame:getContentSize().width * 0.5, nextFrame:getContentSize().height * 0.5):addTo(nextFrame)
  if 0 == self.mBuddhaModel.isRebel then
    self.mNextIcon:setScaleX(-1)
  end
  DYLabelTTF.new({
    text = self.mName,
    size = 24,
    color = cc.c3b(255, 235, 2),
    font = GameManager.FONTNAME_TTF
  }, {}):pos(nextFrame:getPositionX(), nextFrame:getPositionY() + nextFrame:getContentSize().height * 0.5 + 20):addTo(self.mBg)
  display.newSprite(string.format("upgrade/star%d.png", self.mStarLevel + 1)):pos(nextFrame:getPositionX(), nextFrame:getPositionY() - nextFrame:getContentSize().height * 0.5 - 20):addTo(self.mBg)
  local frame = display.newScale9Sprite("common_ui/common_frame11.png", 0, 0, cc.size(477, 206), cc.rect(50, 50, 2, 2)):pos(self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.4):addTo(self.mBg)
  local tb = {
    DYLang.getString("S512", ""),
    DYLang.getString("S513", ""),
    DYLang.getString("S514", ""),
    DYLang.getString("S515", "")
  }
  local num = {
    self.mLifeAdd,
    self.mAttackAdd,
    self.mMagDefAdd,
    self.mPhyDefAdd
  }
  for i = 1, #tb do
    DYLabelTTF.new({
      text = tb[i],
      size = 30,
      color = cc.c3b(255, 245, 88),
      font = GameManager.FONTNAME_TTF,
      dyalign = "CENTER_LEFT"
    }, {}):pos(frame:getContentSize().width * 0.08, frame:getContentSize().height * (1 - i * 0.2)):addTo(frame)
    DYLabelTTF.new({
      text = num[i],
      size = 30,
      color = cc.c3b(44, 255, 44),
      font = GameManager.FONTNAME_TTF,
      dyalign = "CENTER_LEFT"
    }, {}):pos(frame:getContentSize().width * 0.48, frame:getContentSize().height * (1 - i * 0.2)):addTo(frame)
    display.newSprite("upgrade/up.png"):pos(frame:getContentSize().width * 0.82, frame:getContentSize().height * (1 - i * 0.2)):addTo(frame)
  end
  display.newSprite("upgrade/to.png"):pos(self.mBg:getContentSize().width * 0.5, currFrame:getPositionY()):addTo(self.mBg)
end

function M:addAdvanceBtn()
  local frame1 = display.newSprite(string.format("common_ui/frame%d.png", self.mQuality)):pos(self.mBg:getContentSize().width * 0.15, self.mBg:getContentSize().height * 0.15):scale(0.56):addTo(self.mBg)
  self.mPieceIcon = display.newSprite(self.mBuddhaModel.pieceIcon):pos(frame1:getContentSize().width * 0.5, frame1:getContentSize().height * 0.5):addTo(frame1, 1)
  local barBg = display.newSprite("upgrade/bar_bg.png"):pos(self.mBg:getContentSize().width * 0.4, self.mBg:getContentSize().height * 0.15):addTo(self.mBg)
  local currPieceNum = self.mBuddhaModel.currPieceNum
  local needPieceNum = self.mBuddhaModel.advanceCostNum
  self.mPieceNumLabel = DYLabelTTF.new({
    UILabelType = 2,
    text = string.format("%d/%d", currPieceNum, needPieceNum),
    size = 20,
    color = display.COLOR_WHITE,
    font = GameManager.FONTNAME_TTF
  }, {}):pos(barBg:getContentSize().width * 0.5, barBg:getContentSize().height * 0.5):addTo(barBg, 1)
  self.mProgressTimer = cc.ProgressTimer:create(display.newSprite("upgrade/bar_pro.png")):addTo(barBg)
  self.mProgressTimer:setType(cc.PROGRESS_TIMER_TYPE_BAR)
  self.mProgressTimer:setPosition(barBg:getContentSize().width * 0.5, barBg:getContentSize().height * 0.5)
  self.mProgressTimer:setMidpoint(cc.p(0, 0))
  self.mProgressTimer:setBarChangeRate(cc.p(1, 0))
  self.mProgressTimer:setPercentage(currPieceNum / needPieceNum * 100)
  self.mAdvancedBtn = cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png",
    disabled = "common_ui/btn_disabled1.png"
  }):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S516", ""),
    size = 30,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(25, 30, 3)
  })):setButtonLabel("disabled", DYLabelTTF.new({
    text = DYLang.getString("S516", ""),
    size = 30,
    color = cc.c3b(202, 199, 199),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(40, 40, 40)
  })):onButtonClicked(function()
    self:advanceCallBack()
  end):align(display.CENTER, self.mBg:getContentSize().width * 0.8, self.mBg:getContentSize().height * 0.15):addTo(self.mBg)
  if currPieceNum < needPieceNum then
    self:performWithDelay(function()
      self.mAdvancedBtn:setButtonEnabled(false)
    end, 0)
  end
end

function M:advanceCallBack()
  self.mAdvancedBtn:setButtonEnabled(false)
  
  local function tFuncListener(jsonTable)
    if jsonTable.errorCode > 0 then
      local errMsg = jsonTable.errorMsg or "UNKNOWN"
      WSToast.new(errMsg):addTo(self, 20)
      return
    end
    DYSoundMgr.playEffect(DY_SND.sfx_buddha_js)
    CloudData.NPC_INFO[self.mBuddhaModel.npcId].star = jsonTable.data.starLevel
    CloudData.GAME_ITEM_INFO[tostring(self.mBuddhaModel.pieceID)] = jsonTable.data.pieceCount
    self.mBuddhaModel = DataUtils.getBuddhaModel(self.mBuddhaModel.npcId)
    self.mIsAdvanceSuccess = true
    local needPieceNum = self.mBuddhaModel.advanceCostNum
    DYAnalyze.item.consume(self.mBuddhaModel.pieceID, "", needPieceNum, "Advance_cost")
    self:closeCallBack()
  end
  
  local params = {}
  params.buddhaId = self.mBuddhaModel.npcId
  DYHttpMgr.npcAddStar(tFuncListener, params)
end

function M:closeCallBack()
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  local popupLayer = transition.sequence({
    cc.ScaleTo:create(0, 1),
    cc.ScaleTo:create(0.1, 1.1),
    cc.ScaleTo:create(0.2, 0),
    cc.CallFunc:create(function()
      self.mHandler(self.mBuddhaModel, self.mIsAdvanceSuccess)
      self:removeSelf()
    end)
  })
  self.mNode:runAction(popupLayer)
end

return M
