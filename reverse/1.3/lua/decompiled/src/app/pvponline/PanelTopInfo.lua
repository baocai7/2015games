local DataLabelIcon = require("app.icons.DataLabelIcon")
local LayerPVPOlShop = require("app.pvponline.LayerPVPOlShop")
local M = {}
M = class("PanelTopInfo", function()
  return display.newNode()
end)
M.TYPE_RANK = 1
M.TYPE_COMPETE = 2
local COUNT_TIME = 480
local TITLE = {
  [1] = DYLang.getString("S1195", ""),
  [2] = DYLang.getString("S1196", "")
}

function M:ctor(params)
  self.mType = params.type
  self.mCallback = params.callback
  self:initData()
  self:initUI()
end

function M:initData()
  if CloudData.ENERGY_REFRESH_TIME == nil then
    DDTRACE("PanelTopInfo:initData", string.format("platform : %s", device.platform))
    return
  end
  self.mPVPCoinNum = CloudData.GAME_ITEM_INFO["7"] or 0
  local currTime = os.time()
  local deltaTime = CloudData.ENERGY_REFRESH_TIME - (currTime - checknumber(GameManager.LAST_ENERGY_TIME))
  self.mLeftTime = 0
  if deltaTime < 0 then
    deltaTime = deltaTime * -1
    if CloudData.ENERGY >= CloudData.MAX_ENERGY then
      self.mLeftTime = 0
    else
      CloudData.ENERGY = CloudData.ENERGY + math.ceil(deltaTime / COUNT_TIME)
      self.mLeftTime = COUNT_TIME - deltaTime
    end
  else
    self.mLeftTime = deltaTime
  end
end

function M:initUI()
  local bg = display.newSprite("common_ui/common_bg.png"):addTo(self)
  self.mBg = bg
  DYLabelTTF.new({
    text = TITLE[self.mType],
    size = 36,
    color = cc.c3b(255, 210, 73),
    font = GameManager.FONTNAME_TTF
  }):pos(bg:getContentSize().width * 0.27, bg:getContentSize().height * 0.94):addTo(bg)
  local energyLabel = DataLabelIcon.new(DataLabelIcon.LABEL_TYPE_ENERGY, false)
  energyLabel:setPosition(cc.p(bg:getContentSize().width * 0.47, bg:getContentSize().height * 0.94))
  bg:addChild(energyLabel)
  local pvpCoin = display.newSprite("#bg_coin.png"):pos(bg:getContentSize().width * 0.69, bg:getContentSize().height * 0.94):addTo(bg)
  self.mCoinLabel = DYLabelTTF.new({
    text = self.mPVPCoinNum,
    size = 27,
    color = display.COLOR_WHITE,
    font = GameManager.FONTNAME_TTF
  }):pos(pvpCoin:getContentSize().width * 0.51, pvpCoin:getContentSize().height * 0.5 - 2):addTo(pvpCoin)
  cc.ui.UIPushButton.new({
    normal = "#icon_shop.png",
    pressed = "#icon_shop.png"
  }):onButtonPressed(function(event)
    event.target:setScale(0.88)
  end):onButtonRelease(function(event)
    event.target:setScale(1)
  end):onButtonClicked(function()
    self:shopCallBack()
  end):align(display.CENTER, bg:getContentSize().width * 0.86, bg:getContentSize().height * 0.92):addTo(bg, 1)
  cc.ui.UIPushButton.new({
    normal = "common_ui/backBtn_normal.png",
    pressed = "common_ui/backBtn_pressed.png"
  }):onButtonClicked(function()
    if self.mCallback then
      self.mCallback()
    else
      self:returnCallBack()
    end
  end):align(display.CENTER, bg:getContentSize().width * 0.14, bg:getContentSize().height * 0.94):addTo(bg)
  self.mSchedule = self:schedule(function()
    self:updateEnergy()
  end, 1)
end

function M:updateEnergy()
  if self.mLeftTime == nil then
    return
  end
  if self.mLeftTime <= 0 then
    if CloudData.ENERGY >= CloudData.MAX_ENERGY then
      self:stopAction(self.mSchedule)
    else
      CloudData.ENERGY = CloudData.ENERGY + 1
      self.mLeftTime = COUNT_TIME
    end
  end
  self.mLeftTime = self.mLeftTime - 1
end

function M:updatePVPCoin()
  local coinNum = CloudData.GAME_ITEM_INFO["7"] or 0
  self.mCoinLabel:setString(coinNum)
end

function M:shopCallBack()
  LayerPVPOlShop.new(handler(self, self.updatePVPCoin)):addTo(display.getRunningScene(), 20)
end

function M:returnCallBack()
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  GameManager.MODE = 0
  CloudData.PVP_INFO = {}
  local nextScene = require("scenes.ChapterScene").new(3)
  display.replaceScene(nextScene, "fade", 0.2)
end

return M
