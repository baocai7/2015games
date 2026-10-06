local LayerEquipDetail = require("app.layers.LayerEquipDetail")
local M = {}
M = class("RoundListIcon", function()
  return display.newNode()
end)

function M:ctor(rankInfo, type)
  self:initData(rankInfo, type)
  self:initUI()
end

function M:initData(rankInfo, type)
  self.mType = type
  self.mRalatedTable = {
    DYLang.getString("S409", ""),
    DYLang.getString("S410", ""),
    DYLang.getString("S409", ""),
    DYLang.getString("S412", ""),
    DYLang.getString("STR_POTENTIAL", "")
  }
  local textStr = ""
  local tFunc = {
    [1] = rankInfo.power,
    [2] = rankInfo.level,
    [3] = rankInfo.power,
    [4] = rankInfo.star,
    [5] = rankInfo.potential
  }
  textStr = tFunc[self.mType]
  self.mRankingNum = rankInfo.rank
  self.mPlayerRalatedData = textStr
  self.mQuality = 4
  if self.mType == 5 then
    self.mPlayerName = checkstring(rankInfo.ename)
    self.mPlayerLevel = checkstring(rankInfo.nick)
    self.mPlayerVipLevel = 0
    self.mPlayerIcon = checkstring(rankInfo.eicon)
    self.mEid = checknumber(rankInfo.eid)
    self.mUid = checknumber(rankInfo.uid)
    self.mQuality = checknumber(rankInfo.quality)
  else
    self.mPlayerName = rankInfo.nick
    self.mPlayerLevel = rankInfo.level
    self.mPlayerVipLevel = rankInfo.vip
    self.mPlayerTemaInfo = rankInfo.team
    self.mPlayerIcon = rankInfo.eicon or GameManager.USER_ICON_PATH .. rankInfo.icon .. ".png"
  end
end

function M:initUI()
  local bg = display.newScale9Sprite("common_ui/common_frame10.png", 0, 0, cc.size(767, 108), cc.rect(40, 40, 2, 2)):addTo(self)
  if self.mRankingNum < 4 then
    display.newSprite(string.format("ranking/rank%d.png", self.mRankingNum)):pos(bg:getContentSize().width * 0.07, bg:getContentSize().height * 0.5):addTo(bg)
  else
    local lb = cc.ui.UILabel.new({
      text = self.mRankingNum,
      size = 36,
      color = cc.c3b(101, 58, 8),
      font = GameManager.FONTNAME_TTF
    }):align(display.CENTER, bg:getContentSize().width * 0.06, bg:getContentSize().height * 0.5):addTo(bg)
    if 4 == self.mRankingNum then
      lb:setString(self.mRankingNum .. "th")
    end
  end
  local iconFrame = display.newSprite("common_ui/frame" .. self.mQuality .. ".png"):scale(0.7):pos(bg:getContentSize().width * 0.19, bg:getContentSize().height * 0.5):addTo(bg)
  local playerIocn = display.newSprite(self.mPlayerIcon):pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.5):addTo(iconFrame)
  if 0 < self.mPlayerVipLevel then
    local vipFrame = display.newSprite("ranking/bg_vip.png"):align(display.CENTER_RIGHT, iconFrame:getContentSize().width, iconFrame:getContentSize().height):addTo(iconFrame)
    DYLabelTTF.new({
      text = string.format("%d", self.mPlayerVipLevel),
      size = 20,
      color = display.COLOR_WHITE,
      font = GameManager.FONTNAME_TTF
    }, {
      lineColor = cc.c3b(111, 47, 2)
    }):pos(vipFrame:getContentSize().width * 0.72, vipFrame:getContentSize().height * 0.32):addTo(vipFrame)
  end
  local playerNameLabel = cc.ui.UILabel.new({
    text = self.mPlayerName,
    size = 22,
    color = cc.c3b(101, 58, 8),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, bg:getContentSize().width * 0.25, bg:getContentSize().height * 0.72):addTo(bg)
  local colorTb = {
    cc.c3b(255, 44, 233),
    cc.c3b(241, 21, 21),
    cc.c3b(36, 19, 255)
  }
  if self.mRankingNum < 4 then
    playerNameLabel:setColor(colorTb[self.mRankingNum])
  end
  if 2 ~= self.mType then
    local str
    if self.mType == 5 then
      str = DYLang.getString("STR_OWNER", "") .. self.mPlayerLevel
    else
      str = string.format("LV.%d", self.mPlayerLevel)
    end
    cc.ui.UILabel.new({
      text = str,
      size = 22,
      color = cc.c3b(101, 58, 8),
      font = GameManager.FONTNAME_TTF
    }):align(display.CENTER_LEFT, bg:getContentSize().width * 0.25, bg:getContentSize().height * 0.28):addTo(bg)
  end
  local lb = DYLabelTTF.new({
    text = self.mRalatedTable[self.mType],
    size = 24,
    color = cc.c3b(17, 236, 255),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {}):pos(bg:getContentSize().width * 0.48, bg:getContentSize().height * 0.5):addTo(bg)
  DYLabelTTF.new({
    text = self.mPlayerRalatedData,
    size = 24,
    color = cc.c3b(17, 236, 255),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {}):pos(lb:getPositionX() + lb:getContentSize().width, bg:getContentSize().height * 0.5):addTo(bg)
  cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png"
  }):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S415", ""),
    size = 30,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(25, 30, 3)
  })):onButtonClicked(function()
    self:showTeamInfo()
  end):align(display.CENTER, bg:getContentSize().width * 0.88, bg:getContentSize().height * 0.5):addTo(bg)
end

function M:showTeamInfo()
  if self.mType == 5 then
    self:getDetail()
    return
  end
  DYSoundMgr.playEffect(DY_SND.sfx_touch)
  local pMaskLayer = display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(display.getRunningScene(), 20)
  local bg = display.newSprite("ranking/bg_team.png", display.cx, display.cy):scale(0):addTo(display.getRunningScene(), 21)
  local popupLayer = transition.sequence({
    cc.ScaleTo:create(0.2, 1.1),
    cc.ScaleTo:create(0.1, 1)
  })
  bg:runAction(popupLayer)
  cc.ui.UIPushButton.new({
    normal = "common_ui/close_normal.png",
    pressed = "common_ui/close_pressed.png"
  }):onButtonClicked(function()
    local popupLayer = transition.sequence({
      cc.ScaleTo:create(0, 1),
      cc.ScaleTo:create(0.1, 1.1),
      cc.ScaleTo:create(0.2, 0),
      cc.CallFunc:create(function()
        pMaskLayer:removeSelf()
        bg:removeSelf()
      end)
    })
    bg:runAction(popupLayer)
  end):align(display.CENTER, bg:getContentSize().width * 0.96, bg:getContentSize().height * 0.95):addTo(bg)
  if self.mPlayerTemaInfo == nil or #self.mPlayerTemaInfo == 0 then
    return
  end
  for i = 1, #self.mPlayerTemaInfo do
    local buddhaInfo = self.mPlayerTemaInfo[i]
    local buddhaModel = DataUtils.getOtherPlayerTeamInfo(buddhaInfo)
    local iconFrame = display.newSprite(string.format("common_ui/frame%d.png", buddhaModel.quality)):scale(0.95):pos(bg:getContentSize().width * (0.15 * i - 0.1) + 55, bg:getContentSize().height * 0.55):addTo(bg)
    local icon = display.newSprite(buddhaModel.icon):pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.5):addTo(iconFrame)
    if 0 == buddhaModel.isRebel then
      icon:setScaleX(-1)
    end
    DYLabelTTF.new({
      text = "LV." .. buddhaModel.level,
      size = 24,
      color = cc.c3b(101, 58, 8),
      font = GameManager.FONTNAME_TTF
    }):pos(iconFrame:getPositionX(), iconFrame:getPositionY() - 70):addTo(bg)
    display.newSprite(string.format("upgrade/star%d.png", buddhaModel.starLevel)):pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height):addTo(iconFrame)
    if 3 == self.mType then
      DYLabelTTF.new({
        text = "x" .. buddhaInfo.num,
        size = 22,
        color = display.COLOR_WHITE,
        font = GameManager.FONTNAME_TTF,
        dyalign = "CENTER_RIGHT"
      }, {}):pos(iconFrame:getContentSize().width - 10, 15):addTo(iconFrame, 1)
    end
  end
end

function M:getDetail()
  local function tFuncListener(jsonTable)
    if jsonTable.errorCode ~= 0 then
      local msg = jsonTable.errorMsg or "UNKNOWN"
      
      WSToast.new(msg, 2):addTo(display.getRunningScene(), 20)
    else
      local info = jsonTable.data and jsonTable.data.equipment
      if not info or "table" ~= type(info) then
        return
      end
      info.ueid = self.mEid
      LayerEquipDetail.new(info):addTo(display.getRunningScene(), 20)
    end
  end
  
  local params = {
    ownerUid = self.mUid,
    eid = self.mEid
  }
  self:safeHttpRequest("getEquipmentInfo", tFuncListener, params)
end

return M
