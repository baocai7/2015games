local NewFellowLayer = require("app.layers.NewFellowLayer")
local LayerItem = require("app.layers.LayerItem")
local NoviceGuide = require("app.utils.NoviceGuide")
local M = {}
M = class("LayerSummon", function()
  return display.newLayer()
end)

function M:ctor(summonType, itemList, itemNumList, tHandler)
  self.mCallback = tHandler
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  self.mEmptyNode = display.newNode()
  self.mEmptyNode:setPosition(display.cx, display.cy)
  self:addChild(self.mEmptyNode)
  self.mEmptyNode:setScale(0)
  local popupLayer = transition.sequence({
    cc.ScaleTo:create(0.2, 1.1),
    cc.ScaleTo:create(0.1, 1)
  })
  self.mEmptyNode:runAction(popupLayer)
  display.addSpriteFrames("summon_scene/light_tx.plist", "summon_scene/light_tx.png")
  self.mItemList = itemList
  self.mItemNumList = itemNumList
  self.mIsRepeat = false
  self.mItemModelTable = {}
  if 1 == summonType then
    self:generateSingleNpc_()
  else
    self:generateSummonTenNpcs_()
  end
end

function M:generateSingleNpc_()
  local itemId = self.mItemList[1]
  local itemModel = DataUtils.getItemModelWithColor(itemId)
  itemModel.itemNum = self.mItemNumList[1]
  table.insert(self.mItemModelTable, itemModel)
  self:initSingleSummonUI(itemModel)
end

function M:generateSummonTenNpcs_()
  for i = 1, #self.mItemList do
    local itemId = self.mItemList[i]
    local itemModel = DataUtils.getItemModelWithColor(itemId)
    itemModel.itemNum = self.mItemNumList[i]
    table.insert(self.mItemModelTable, itemModel)
  end
  self.mBg = display.newSprite("summon_scene/alert_frame.png"):addTo(self.mEmptyNode)
  display.newSprite("summon_scene/summon_label.png", self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 1.1):addTo(self.mBg)
  self.mRepeatBtn = cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png"
  }):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S932", ""),
    size = 30,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(25, 30, 3)
  })):align(display.CENTER, self.mBg:getContentSize().width * 0.36, -self.mBg:getContentSize().height * 0.2):onButtonClicked(function(event)
    event.target:setButtonEnabled(false)
    self.mIsRepeat = true
    self:closeCallBack_()
  end):hide():addTo(self.mBg)
  self.mEnsureBtn = cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png"
  }):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S933", ""),
    size = 30,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(25, 30, 3)
  })):align(display.CENTER, self.mBg:getContentSize().width * 0.64, -self.mBg:getContentSize().height * 0.2):onButtonClicked(function()
    self:closeCallBack_()
  end):hide():addTo(self.mBg)
  self.mIndex = 1
  self.mIsInProgress = false
  self.mSchedule = self:schedule(function()
    self:initMultipleSummonUI()
  end, 0.1)
end

function M:initSingleSummonUI(itemModel)
  local bg = display.newSprite("summon_scene/alert_frame.png"):addTo(self.mEmptyNode)
  local repeatBtn = cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png"
  }):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S934", ""),
    size = 30,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(25, 30, 3)
  })):align(display.CENTER, bg:getContentSize().width * 0.36, -bg:getContentSize().height * 0.2):onButtonClicked(function(event)
    event.target:setButtonEnabled(false)
    self.mIsRepeat = true
    self:closeCallBack_()
  end):hide():addTo(bg)
  local ensureBtn = cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png"
  }):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S933", ""),
    size = 30,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(25, 30, 3)
  })):align(display.CENTER, bg:getContentSize().width * 0.64, -bg:getContentSize().height * 0.2):onButtonClicked(function()
    self:closeCallBack_()
  end):hide():addTo(bg)
  local itemId = itemModel.itemId
  local itemName = itemModel.name
  local itemIcon = itemModel.icon
  local nameColor = itemModel.color
  local itemQuality = itemModel.quality
  local itemNum = itemModel.itemNum
  display.newSprite("summon_scene/summon_label.png", bg:getContentSize().width * 0.5, bg:getContentSize().height * 1.1):addTo(bg)
  local iconFrame = display.newSprite(string.format("common_ui/frame" .. itemQuality .. ".png"), bg:getContentSize().width * 0.5, bg:getContentSize().height * 1.3):scale(0):addTo(bg)
  local pLayer
  iconFrame:setTouchEnabled(true)
  iconFrame:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    local name, x, y = event.name, event.x, event.y
    local touchInSprite = cc.rectContainsPoint(iconFrame:getCascadeBoundingBox(), cc.p(x, y))
    if name == "began" then
      if not pLayer then
        pLayer = LayerItem.new(LayerItem.TYPE_TIP, itemId):pos(iconFrame:getContentSize().width + 220, iconFrame:getContentSize().height * 0.5):addTo(iconFrame, 20)
      end
      return true
    elseif name == "moved" then
      pLayer:show()
    elseif name == "ended" then
      pLayer:removeSelf()
      pLayer = nil
    end
  end)
  local icon = display.newSprite(itemIcon, iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.5):addTo(iconFrame)
  local name = cc.ui.UILabel.new({
    UILabelType = 2,
    text = itemName,
    size = 24,
    color = nameColor,
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, iconFrame:getContentSize().width * 0.5, -iconFrame:getContentSize().height * 0.25):addTo(iconFrame)
  cc.ui.UILabel.new({
    UILabelType = 1,
    text = string.format("*%d", itemNum),
    font = "fonts/whiteNum.fnt"
  }):align(display.CENTER_RIGHT, iconFrame:getContentSize().width * 0.95, iconFrame:getContentSize().height * 0.15):scale(0.5):addTo(iconFrame, 2)
  if itemQuality == 4 or itemQuality == 6 then
    local frames = display.newFrames("light%d.png", 1, 18)
    local animation = display.newAnimation(frames, 0.1)
    local emptyPic = display.newSprite():pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.5):addTo(iconFrame, 2)
    emptyPic:playAnimationForever(animation, 0)
  end
  if 5 <= itemQuality then
    local p = display.newSprite("summon_scene/frame" .. itemQuality .. ".png"):pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.5):addTo(iconFrame, -1)
    local seq = transition.sequence({
      cc.FadeOut:create(1),
      cc.FadeIn:create(1)
    })
    p:runAction(cc.RepeatForever:create(seq))
  end
  local num = CloudData.GAME_ITEM_INFO[tostring(itemId)]
  if num == nil then
    local pNew = display.newSprite("common_ui/new.png"):pos(iconFrame:getContentSize().width * 0.8, iconFrame:getContentSize().height * 0.86):addTo(iconFrame, 1)
    local seq = transition.sequence({
      cc.FadeOut:create(0.5),
      cc.FadeIn:create(0.5)
    })
    pNew:runAction(cc.RepeatForever:create(seq))
  end
  DYAnalyze.item.get(itemId, "", itemNum, "SummonScene")
  local spawn_ = cc.Spawn:create(cc.ScaleTo:create(0.1, 1), cc.MoveTo:create(0.1, cc.p(bg:getContentSize().width * 0.5, bg:getContentSize().height * 0.5)))
  iconFrame:runAction(transition.sequence({
    cc.DelayTime:create(0.85),
    spawn_,
    cc.CallFunc:create(function()
      self:dealUserGuide()
      repeatBtn:show()
      ensureBtn:show()
    end),
    cc.CallFunc:create(function()
      self:newFellowAction_(1)
    end)
  }))
end

function M:initMultipleSummonUI()
  if self.mIndex == #self.mItemModelTable + 1 then
    self:stopAction(self.mSchedule)
  elseif not self.mIsInProgress then
    self.mIsInProgress = true
    local index = self.mIndex
    local itemModel = self.mItemModelTable[index]
    local itemId = itemModel.itemId
    local itemName = itemModel.name
    local itemIcon = itemModel.icon
    local nameColor = itemModel.color
    local itemQuality = itemModel.quality
    local itemNum = itemModel.itemNum
    local iconFrame = display.newSprite(string.format("common_ui/frame" .. itemQuality .. ".png"), self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 1.3):scale(0):addTo(self.mBg)
    local pLayer
    iconFrame:setTouchEnabled(true)
    iconFrame:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
      local name, x, y = event.name, event.x, event.y
      local touchInSprite = cc.rectContainsPoint(iconFrame:getCascadeBoundingBox(), cc.p(x, y))
      if name == "began" then
        if not pLayer then
          pLayer = LayerItem.new(LayerItem.TYPE_TIP, itemId):pos(iconFrame:getPositionX(), iconFrame:getPositionY()):addTo(self.mBg, 20)
        end
        return true
      elseif name == "moved" then
        pLayer:show()
      elseif name == "ended" then
        pLayer:removeSelf()
        pLayer = nil
      end
    end)
    local icon = display.newSprite(itemIcon, iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.5):addTo(iconFrame)
    local name = cc.ui.UILabel.new({
      UILabelType = 2,
      text = itemName,
      size = 24,
      color = nameColor,
      font = GameManager.FONTNAME_TTF
    }):align(display.CENTER, iconFrame:getContentSize().width * 0.5, -iconFrame:getContentSize().height * 0.25):addTo(iconFrame)
    cc.ui.UILabel.new({
      UILabelType = 1,
      text = string.format("*%d", itemNum),
      font = "fonts/whiteNum.fnt"
    }):align(display.CENTER_RIGHT, iconFrame:getContentSize().width * 0.95, iconFrame:getContentSize().height * 0.15):scale(0.5):addTo(iconFrame, 2)
    local movetoPoint
    if index < 6 then
      movetoPoint = cc.p(self.mBg:getContentSize().width * 0.1 * (index * 1.5 + 0.5), self.mBg:getContentSize().height * 0.78)
    else
      movetoPoint = cc.p(self.mBg:getContentSize().width * 0.1 * ((index - 5) * 1.5 + 0.5), self.mBg:getContentSize().height * 0.3)
    end
    local spawn_ = cc.Spawn:create(cc.ScaleTo:create(0.1, 1), cc.MoveTo:create(0.1, movetoPoint))
    if index == #self.mItemModelTable then
      iconFrame:runAction(transition.sequence({
        cc.DelayTime:create(0.75 + index * 0.15),
        spawn_,
        cc.CallFunc:create(function()
          self.mRepeatBtn:show()
          self.mEnsureBtn:show()
        end),
        cc.CallFunc:create(function()
          self:newFellowAction_(index)
        end)
      }))
    else
      iconFrame:runAction(transition.sequence({
        cc.DelayTime:create(0.75 + index * 0.15),
        spawn_,
        cc.CallFunc:create(function()
          self:newFellowAction_(index)
        end)
      }))
    end
    if itemQuality == 4 or itemQuality == 6 then
      local frames = display.newFrames("light%d.png", 1, 18)
      local animation = display.newAnimation(frames, 0.1)
      local emptyPic = display.newSprite():pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.5):addTo(iconFrame, 2)
      emptyPic:playAnimationForever(animation, 0)
    end
    if 5 <= itemQuality then
      local p = display.newSprite("summon_scene/frame" .. itemQuality .. ".png"):pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.5):addTo(iconFrame, -1)
      local seq = transition.sequence({
        cc.FadeOut:create(1),
        cc.FadeIn:create(1)
      })
      p:runAction(cc.RepeatForever:create(seq))
    end
    local num = CloudData.GAME_ITEM_INFO[tostring(itemId)]
    if num == nil then
      local pNew = display.newSprite("common_ui/new.png"):pos(iconFrame:getContentSize().width * 0.8, iconFrame:getContentSize().height * 0.86):addTo(iconFrame, 1)
      local seq = transition.sequence({
        cc.FadeOut:create(0.5),
        cc.FadeIn:create(0.5)
      })
      pNew:runAction(cc.RepeatForever:create(seq))
    end
    DYAnalyze.item.get(itemId, "", itemNum, "SummonScene")
    self.mIndex = self.mIndex + 1
    self.mIsInProgress = false
  end
end

function M:newFellowAction_(idx)
  if self.mSound then
    DYSoundMgr.stopEffect(self.mSound)
    self.mSound = nil
  end
  self.mSound = DYSoundMgr.playEffect(DY_SND.sfx_call_get)
end

function M:closeCallBack_()
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  local popupLayer = transition.sequence({
    cc.ScaleTo:create(0, 1),
    cc.ScaleTo:create(0.1, 1.1),
    cc.ScaleTo:create(0.2, 0),
    cc.CallFunc:create(function()
      if self.mCallback then
        self.mCallback(self.mIsRepeat)
      end
      self:removeSelf()
    end)
  })
  self.mEmptyNode:runAction(popupLayer)
end

function M:dealUserGuide()
  local stageProgress = Const.STAGE_PROGRESS or CloudData.MAIN_STAGE_PROGRESS
  if stageProgress == 5 then
    local ac = DataUtils.getBuddhaModel(1005)
    local guide = ac.buddhaState ~= 0 or ac.currPieceNum ~= 0 or DataUtils.getGuideIsFirstPlayed("GUDIE_STAGE6_SUMMONLAY") or NoviceGuide.new("GUDIE_STAGE6_SUMMONLAY", function()
      if self.mCallback then
        self.mCallback()
      end
      local scene = require("app.scenes.UpgradeScene").new()
      display.replaceScene(scene, "FADETR", 1)
    end):addTo(self, 50)
  end
end

return M
