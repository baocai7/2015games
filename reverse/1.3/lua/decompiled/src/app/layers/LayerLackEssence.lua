local LayerLackPeach = require("app.layers.LayerLackPeach")
local CLASS_NAME = "LayerLackEssence"
local M = {}
M = class(CLASS_NAME, function()
  return display.newLayer()
end)

function M:ctor()
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  self.mNode = display.newNode():scale(0):pos(display.cx, display.cy):addTo(self, 1)
  local popupLayer = transition.sequence({
    cc.ScaleTo:create(0.2, 1.1),
    cc.ScaleTo:create(0.1, 1)
  })
  self.mNode:runAction(popupLayer)
  self:initData()
  self:initUI()
  self.mKeypadListener = handler(self, self.onKeypad)
  self:setNodeEventEnabled(true)
end

function getPeachNum(num)
  local costInfo = DYCommon.getDataByTag(DataRetainer.PVP_COUNT_CONSUME, "id", tostring(num))[1]
  if not costInfo then
    DDERROR("pvp countConsume: %d with error data", tonumber(num))
    return 0
  end
  return tonumber(costInfo.miningPeach) or 0
end

function M:initData()
  local vipInfo = DataUtils.getVipPrivilege(CloudData.VIP_LEVEL)
  self.mCountMiningNum = vipInfo.miningCount
  self.mEssenceNum = CloudData.USER_LEVEL * 500 + 10000
end

function M:initUI()
  local bg = display.newScale9Sprite("common_ui/common_dialog.png", 0, 0, cc.size(612, 420), cc.rect(300, 140, 1, 1)):addTo(self.mNode)
  self.mBg = bg
  display.newSprite("upgrade/title2.png"):pos(self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.88):addTo(self.mBg)
  local iconFrame = display.newSprite("common_ui/frame1.png"):align(display.CENTER_LEFT, bg:getContentSize().width * 0.1, bg:getContentSize().height * 0.66):addTo(bg)
  display.newSprite("item_icon/icon_2.png"):pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.5):addTo(iconFrame)
  local lb1 = DYLabelTTF.new({
    text = DYLang.getString("S725", ""),
    color = cc.c3b(255, 231, 13),
    size = 30,
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {}):pos(iconFrame:getPositionX() + iconFrame:getContentSize().width + 5, iconFrame:getPositionY() + 25):addTo(bg)
  local currNum = self.mCountMiningNum - CloudData.MINING_NUM
  local maxNum = self.mCountMiningNum
  self.mLabel = DYLabelTTF.new({
    text = string.format("\239\188\136\228\187\138\230\151\165\229\143\175\231\130\188\229\140\150\230\172\161\230\149\176\239\188\154%d/%d\239\188\137", currNum, maxNum),
    color = cc.c3b(16, 255, 33),
    size = 22,
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {}):pos(lb1:getPositionX() + lb1:getContentSize().width + 5, iconFrame:getPositionY() + 25):addTo(bg)
  DYLabelTTF.new({
    text = DYLang.getString("S726", ""),
    color = cc.c3b(47, 253, 255),
    size = 24,
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {}):pos(iconFrame:getPositionX() + iconFrame:getContentSize().width + 5, iconFrame:getPositionY() - 25):addTo(bg)
  local frame = display.newScale9Sprite("common_ui/common_frame11.png", 0, 0, cc.size(516, 79), cc.rect(50, 50, 2, 2)):pos(bg:getContentSize().width * 0.5, bg:getContentSize().height * 0.4):addTo(self.mBg)
  local textFrame1 = display.newScale9Sprite("common_ui/num_bg.png", 0, 0, cc.size(160, 40), cc.rect(50, 17, 1, 1)):pos(frame:getContentSize().width * 0.22, frame:getContentSize().height * 0.5):addTo(frame)
  display.newSprite("item_icon/pic_peach.png", 10, textFrame1:getContentSize().height * 0.5):addTo(textFrame1)
  local costPeach = 0
  if CloudData.MINING_NUM >= self.mCountMiningNum then
    costPeach = getPeachNum(CloudData.MINING_NUM)
  else
    costPeach = getPeachNum(CloudData.MINING_NUM + 1)
  end
  self.peachLabel = cc.ui.UILabel.new({
    text = costPeach,
    size = 24,
    color = display.COLOR_WHITE,
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, textFrame1:getContentSize().width * 0.5, textFrame1:getContentSize().height * 0.5):addTo(textFrame1)
  local textFrame2 = display.newScale9Sprite("common_ui/num_bg.png", 0, 0, cc.size(160, 40), cc.rect(50, 17, 1, 1)):pos(frame:getContentSize().width * 0.78, frame:getContentSize().height * 0.5):addTo(frame)
  display.newSprite("item_icon/pic_essence.png", 10, textFrame2:getContentSize().height * 0.5):addTo(textFrame2)
  self.essenceLabel = cc.ui.UILabel.new({
    text = self.mEssenceNum,
    size = 24,
    color = display.COLOR_WHITE,
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, textFrame2:getContentSize().width * 0.5, textFrame2:getContentSize().height * 0.5):addTo(textFrame2, 1)
  display.newSprite("upgrade/to.png"):scale(0.75):pos(frame:getContentSize().width * 0.5, frame:getContentSize().height * 0.5):addTo(frame)
  cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png"
  }):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S727", ""),
    size = 30,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(25, 30, 3)
  })):onButtonClicked(function()
    self:closeCallBack()
  end):align(display.CENTER, bg:getContentSize().width * 0.3, bg:getContentSize().height * 0.2):addTo(bg)
  self.mUseBtn = cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png",
    disabled = "common_ui/btn_disabled1.png"
  }):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S728", ""),
    size = 30,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(25, 30, 3)
  })):setButtonLabel("disabled", DYLabelTTF.new({
    text = DYLang.getString("S728", ""),
    size = 30,
    color = cc.c3b(202, 199, 199),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(40, 40, 40)
  })):onButtonClicked(function()
    self:useCallBack()
  end):align(display.CENTER, bg:getContentSize().width * 0.7, bg:getContentSize().height * 0.2):addTo(bg)
  if CloudData.MINING_NUM >= self.mCountMiningNum then
    self.mUseBtn:setButtonEnabled(false)
  end
end

function M:useCallBack()
  local costPeach = getPeachNum(CloudData.MINING_NUM + 1)
  if costPeach > CloudData.PEACH then
    local pLayer = LayerLackPeach.new()
    self:addChild(pLayer, 20)
    return
  end
  
  local function tFuncListener(jsonTable)
    if jsonTable.errorCode > 0 then
      local errMsg = jsonTable.errorMsg or "UNKNOWN"
      WSToast.new(errMsg):addTo(self, 20)
      return
    end
    DYSoundMgr.playEffect(DY_SND.sfx_essence_get)
    CloudData.PEACH = jsonTable.data.peach
    CloudData.ESSENCE = jsonTable.data.essence
    CloudData.MINING_NUM = jsonTable.data.miningTimes
    self.mCritNum = jsonTable.data.critNum
    local currNum = self.mCountMiningNum - CloudData.MINING_NUM
    self.mLabel:setString(string.format("\239\188\136\228\187\138\230\151\165\229\143\175\231\130\188\229\140\150\230\172\161\230\149\176\239\188\154%d/%d\239\188\137", currNum, self.mCountMiningNum))
    if CloudData.MINING_NUM >= self.mCountMiningNum then
      self.mUseBtn:setButtonEnabled(false)
    else
      local costPeach = getPeachNum(CloudData.MINING_NUM + 1)
      self.peachLabel:setString(costPeach)
    end
    self:numberAction()
    local essenceNum = self.mEssenceNum * self.mCritNum
    DYAnalyze.item.get("2", "", essenceNum, "LianHua")
  end
  
  DYHttpMgr.exchangeEssence(tFuncListener)
end

function M:numberAction()
  local delayTime = 0
  if self.mCritNum > 1 then
    local critPic = display.newSprite("spin/crit.png"):pos(self.mBg:getContentSize().width * 0.42, self.mBg:getContentSize().height * 0.42):scale(0):addTo(self.mBg, 2)
    local critNum = cc.ui.UILabel.new({
      UILabelType = 1,
      text = string.format("*%d", self.mCritNum),
      font = "fonts/colorNum.fnt"
    }):scale(0):align(display.CENTER_LEFT, self.mBg:getContentSize().width * 0.55, self.mBg:getContentSize().height * 0.48):addTo(self.mBg, 2)
    local ac1 = cc.ScaleTo:create(0.25, 1)
    local ac11 = cc.ScaleTo:create(0.25, 1)
    local ac2 = cc.MoveTo:create(0.75, cc.p(self.mBg:getContentSize().width * 0.42, self.mBg:getContentSize().height))
    local ac22 = cc.MoveTo:create(0.75, cc.p(self.mBg:getContentSize().width * 0.55, self.mBg:getContentSize().height * 1.06))
    local ac3 = cc.FadeOut:create(0.75)
    local ac33 = cc.FadeOut:create(0.75)
    local seq = transition.sequence({
      ac1,
      cc.Spawn:create(ac2, ac3),
      cc.CallFunc:create(function()
        critPic:removeSelf()
      end)
    })
    local seq1 = transition.sequence({
      ac11,
      cc.Spawn:create(ac22, ac33),
      cc.CallFunc:create(function()
        critNum:removeSelf()
      end)
    })
    critPic:runAction(seq)
    critNum:runAction(seq1)
    delayTime = 0.25
  end
  local essenceNum = self.mEssenceNum * self.mCritNum
  local lb = cc.ui.UILabel.new({
    UILabelType = 1,
    text = "+" .. essenceNum,
    font = "fonts/colorNum.fnt"
  }):align(display.CENTER, self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.2):scale(0.72):opacity(0):addTo(self.mBg, 2)
  local moveTo = cc.MoveTo:create(0.75, cc.p(self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.78))
  local spawn1 = cc.Spawn:create(moveTo, cc.FadeIn:create(0.5))
  lb:runAction(transition.sequence({
    cc.DelayTime:create(delayTime),
    spawn1,
    cc.CallFunc:create(function()
      lb:removeSelf()
    end)
  }))
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

function M:onKeypad(keyCode, event)
  DDLOG("Key %d was on pressed!", keyCode)
  if keyCode == cc.KeyCode.KEY_ESCAPE then
    self:closeCallBack()
    return true
  end
  return false
end

function M:onEnter()
  DYKeypadMgr.regKeyHandler(self.mKeypadListener)
end

function M:onExit()
  DYKeypadMgr.unregKeyHandler(self.mKeypadListener)
end

return M
