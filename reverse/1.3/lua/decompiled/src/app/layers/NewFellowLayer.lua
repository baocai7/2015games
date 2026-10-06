local NoviceGuide = require("app.utils.NoviceGuide")
local GameDialogue = require("app.utils.GameDialogue")
FROM_CHAPTER = 1
FROM_SUMMON = 2
local NewFellowLayer = class("NewFellowLayer", function()
  return display.newLayer()
end)

function NewFellowLayer:ctor(buddhaModel, fromType)
  if fromType ~= nil then
    self.fromType_ = fromType
  else
    self.fromType_ = FROM_CHAPTER
  end
  self.tag1_ = tonumber(buddhaModel.tag1)
  self.tag2__ = tonumber(buddhaModel.tag2)
  self.tag3__ = tonumber(buddhaModel.tag3)
  self.name_ = buddhaModel.npcName
  self.icon_ = buddhaModel.npcIcon
  self.quality_ = tonumber(buddhaModel.quality)
  self.model_ = buddhaModel
  self.mask = display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  self.node = display.newNode():pos(display.cx, display.cy):addTo(self, 1)
  self:init()
  self:setNodeEventEnabled(true)
end

function NewFellowLayer:init()
  display.addSpriteFrames("new_fellow/tx_summon.plist", "new_fellow/tx_summon.png")
  self.bg_ = display.newSprite("new_fellow/bg.jpg")
  self.node:addChild(self.bg_)
  self.cloud = display.newSprite("new_fellow/cloud.png"):align(display.CENTER, self.bg_:getContentSize().width, self.bg_:getContentSize().height * 0.35):addTo(self.bg_)
  self:schedule(function()
    self:cloudPosUpdate_()
  end, 0.016)
  local til = display.newSprite("new_fellow/ground.png"):align(display.CENTER, self.bg_:getContentSize().width * 0.5, self.bg_:getContentSize().height * 0.17):addTo(self.bg_)
  local tem1 = display.newSprite("new_fellow/monkey.png"):pos(self.bg_:getContentSize().width, 0):addTo(self.bg_)
  tem1:setAnchorPoint(1, 0)
  local ani1 = display.newSprite():scale(4):align(display.CENTER_BOTTOM, 612, 85):addTo(self.bg_, 2)
  local frames1 = display.newFrames("rwzhaohuantx%d.png", 1, 27)
  local fellow1 = display.newAnimation(frames1, 0.05555555555555555)
  ani1:playAnimationOnce(fellow1, true)
  self:performWithDelay(function()
    self:newFellow2_()
  end, 0.2)
  local title = display.newSprite("new_fellow/title.png"):align(display.CENTER, self.bg_:getContentSize().width * 0.5, self.bg_:getContentSize().height * 0.88):addTo(self.bg_)
  local name = display.newSprite("new_fellow/bg_name.png"):align(display.CENTER, self.bg_:getContentSize().width * 0.566, self.bg_:getContentSize().height * 0.2):addTo(self.bg_)
  cc.ui.UILabel.new({
    text = self.name_,
    size = 30,
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, name:getContentSize().width * 0.2, name:getContentSize().height * 0.5):addTo(name)
  local card = display.newSprite("new_fellow/intro.png"):align(display.CENTER, self.bg_:getContentSize().width * 0.2, self.bg_:getContentSize().height * 0.55):addTo(self.bg_):scale(0)
  local popupLayer = transition.sequence({
    cc.ScaleTo:create(2.2, 0),
    cc.ScaleTo:create(0.1, 1)
  })
  card:runAction(popupLayer)
  local iconFrame = display.newSprite("common_ui/frame" .. self.quality_ .. ".png"):scale(0.7):align(display.CENTER, card:getContentSize().width * 0.22, card:getContentSize().height * 0.7):addTo(card)
  local icon = display.newSprite(self.icon_):align(display.CENTER, iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.5):addTo(iconFrame)
  cc.ui.UILabel.new({
    text = self.name_,
    size = 22,
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, card:getContentSize().width * 0.42, card:getContentSize().height * 0.74):addTo(card)
  cc.ui.UILabel.new({
    text = "Lv.1",
    size = 22,
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, card:getContentSize().width * 0.42, card:getContentSize().height * 0.65):addTo(card)
  local newfellow = display.newSprite("new_fellow/" .. self.quality_ .. ".png"):align(display.CENTER, card:getContentSize().width * 0.52, card:getContentSize().height * 0.47):addTo(card)
  tags = {
    "",
    DYLang.getString("S1093", ""),
    DYLang.getString("S1094", ""),
    DYLang.getString("S1095", ""),
    DYLang.getString("S1096", ""),
    DYLang.getString("S1097", ""),
    DYLang.getString("S1098", ""),
    DYLang.getString("S1099", ""),
    DYLang.getString("S1100", ""),
    DYLang.getString("S1101", ""),
    DYLang.getString("S1102", "")
  }
  cc.ui.UILabel.new({
    text = tags[self.tag1_ + 1],
    size = 26,
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, card:getContentSize().width * 0.42, card:getContentSize().height * 0.36):addTo(card)
  cc.ui.UILabel.new({
    text = tags[self.tag2__ + 1],
    size = 26,
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, card:getContentSize().width * 0.42, card:getContentSize().height * 0.27):addTo(card)
  cc.ui.UILabel.new({
    text = tags[self.tag3__ + 1],
    size = 26,
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, card:getContentSize().width * 0.42, card:getContentSize().height * 0.18):addTo(card)
end

function NewFellowLayer:cloudPosUpdate_()
  local x = math.floor(self.cloud:getPositionX())
  if x == -math.floor(self.cloud:getContentSize().width * 0.5) then
    x = self.bg_:getContentSize().width + self.cloud:getContentSize().width * 0.5
  end
  self.cloud:setPosition(x - 2, self.cloud:getPositionY())
end

function NewFellowLayer:newFellow1_()
  display.addSpriteFrames("new_fellow/new_fellow2.plist", "new_fellow/new_fellow2.png")
  local ani = display.newSprite():align(display.CENTER, self.bg_:getContentSize().width * 0.5, self.bg_:getContentSize().height * 0.5):addTo(self.bg_)
  local frames = display.newFrames("bingzhonghuod2-%d.png", 1, 10)
  local fellow = display.newAnimation(frames, 0.07)
  ani:setScale(1.5)
  ani:playAnimationOnce(fellow, true, function()
    self:newFellow2_()
  end)
end

function NewFellowLayer:newFellow2_()
  cc.Texture2D:setDefaultAlphaPixelFormat(cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A4444)
  ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(string.format("armature/%s/%s.csb", self.model_.armatureFile, self.model_.armatureFile))
  local xiaodou = ccs.Armature:create(self.model_.armatureFile)
  xiaodou:setPosition(self.bg_:getContentSize().width * 0.5, self.bg_:getContentSize().height * 0.25)
  xiaodou:getAnimation():playWithIndex(0)
  self.bg_:addChild(xiaodou)
  cc.Texture2D:setDefaultAlphaPixelFormat(cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888)
  self:performWithDelay(function()
    DYSoundMgr.playEffect(self.model_.buddhaSound)
  end, 0.5)
  local confirmBtn = cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal.png",
    pressed = "common_ui/btn_pressed.png"
  }):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S38", ""),
    size = 30,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(143, 78, 1),
    lineWidth = 2
  })):align(display.CENTER, self.bg_:getContentSize().width * 0.5, self.bg_:getContentSize().height * 0.1):hide():onButtonClicked(function()
    self:confirmCallBack_()
  end):addTo(self.bg_)
  self.mConfirmBtn = confirmBtn
  confirmBtn:runAction(transition.sequence({
    cc.DelayTime:create(1.5),
    cc.CallFunc:create(function()
      confirmBtn:show()
      self:dealUserGuide()
    end)
  }))
end

function NewFellowLayer:confirmCallBack_()
  if self.fromType_ == FROM_SUMMON then
    GameManager.IS_NEWFELLOW_CLOSED = true
    self:closeCallBack_()
  else
    self:closeCallBack_()
  end
end

function NewFellowLayer:closeCallBack_()
  DYSoundMgr.stopEffect(self.mSoundId)
  DYSoundMgr.resumeMusic()
  self:runAction(cc.RemoveSelf:create())
end

function NewFellowLayer:dealUserGuide()
  local stageProgress = Const.STAGE_PROGRESS or CloudData.MAIN_STAGE_PROGRESS
  if stageProgress == 1 and not DataUtils.getGuideIsFirstPlayed("DIALOGUE_STAGE2_2") then
    DataUtils.setGuideIsFirstPlayed("DIALOGUE_STAGE2_2", true)
    self.mConfirmBtn:hide()
    
    local function tFuncListener(teamInfo)
      if teamInfo.errorCode > 0 then
        local errMsg = teamInfo.errorMsg or "UNKNOWN"
        WSToast.new(errMsg):addTo(self, 20)
        return
      end
    end
    
    local params = {}
    params.attackTeam = json.encode({"1003", "1002"})
    params.helpTeam = json.encode({})
    params.power = DataUtils.getUserCountCE()
    DYHttpMgr.updateCommonTeam(tFuncListener, params)
    local guideLayer = GameDialogue.new("STAGE2_2", function()
      DataUtils.setGuideIsFirstPlayed("STAGE2_2", true)
      DataUtils.setBuddhaTableOnTeam({"1003", "1002"})
      display.replaceScene(require("scenes.ChapterScene").new(), "FADETR", 1)
    end):addTo(self, 999)
  end
  local guide = not (stageProgress == 5 and DataUtils.getGuideIsFirstPlayed("GUDIE_STAGE6_UPGRADELAY")) or DataUtils.getGuideIsFirstPlayed("GUDIE_STAGE6_NEWFELLOLAY") or NoviceGuide.new("GUDIE_STAGE6_NEWFELLOLAY", function()
    display.replaceScene(require("scenes.ChapterScene").new(), "FADETR", 1)
  end):addTo(self, 50)
end

function NewFellowLayer:onEnter()
  DYSoundMgr.pauseMusic()
  DYSoundMgr.playEffect(DY_SND.bgm_new_fellow)
end

function NewFellowLayer:onExit()
  DDLOG(DYLang.getString("S1104", ""))
  DYSoundMgr.stopEffect()
end

return NewFellowLayer
