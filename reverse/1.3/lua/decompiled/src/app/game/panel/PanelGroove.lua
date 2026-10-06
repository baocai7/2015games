local PanelCard = require("app.game.panel.PanelCard")
local M = {}
M = class("PanelGroove", function()
  return display.newNode()
end)
M.UPGRADE_SPIRIT = 1001
M.SPIRIT_NUM = 1002
M.BUDDHA_CARD = 1003
M.WAND_SKILL = 1004
M.TOWER_SKILL = 1005

function M:ctor(handler_)
  self:initData(handler_)
  self:initUI()
end

function M:initData(handler_)
  self.mCallback = handler_
  GameData.CARD_TABLE = {}
end

function M:initUI()
  self.mFrame = display.newScale9Sprite("gamescene/team_frame.png", 0, 0, cc.size(display.width, 62), cc.rect(50, 30, 2, 2)):align(display.CENTER_BOTTOM, 0, 0):addTo(self)
  self.mSchedule = self:schedule(function()
    self:cardSpawn()
  end, GameData.INTERVAL_TIME)
end

function M:cardSpawn()
  if #GameData.CARD_TABLE >= 8 then
    return
  end
  local weightNum = {}
  if GameData.SPIRIT_LEVEL <= math.ceil(GameData.SPIRIT_MAX_LEVEL / 2) then
    weightNum = Const.Card1
  elseif GameData.SPIRIT_LEVEL < GameData.SPIRIT_MAX_LEVEL then
    weightNum = Const.Card2
  else
    weightNum = Const.Card3
  end
  if 6 == GameManager.MODE or 9 == GameManager.MODE then
    weightNum = Const.Card4
  end
  local countWeight = 0
  for i = 1, #weightNum do
    countWeight = countWeight + weightNum[i] * 10
  end
  
  local function tFuncAddNum(idx)
    local countNum = 0
    for i = 1, idx do
      countNum = countNum + weightNum[i] * 10
    end
    return countNum
  end
  
  local randomNum = math.random(1, countWeight)
  local cardIcon
  if randomNum <= tFuncAddNum(1) then
    cardIcon = PanelCard.new(PanelCard.UPGRADE_SPIRIT, handler(self, self.onEventCardPressd))
  elseif randomNum <= tFuncAddNum(2) then
    cardIcon = PanelCard.new(PanelCard.SPIRIT_NUM, handler(self, self.onEventCardPressd))
  elseif randomNum <= tFuncAddNum(3) then
    cardIcon = PanelCard.new(PanelCard.BUDDHA_CARD, handler(self, self.onEventCardPressd))
  elseif randomNum <= tFuncAddNum(4) then
    cardIcon = PanelCard.new(PanelCard.WAND_SKILL, handler(self, self.onEventCardPressd))
  elseif randomNum <= tFuncAddNum(5) then
    cardIcon = PanelCard.new(PanelCard.TOWER_SKILL, handler(self, self.onEventCardPressd))
  end
  cardIcon:setPosition(self.mFrame:getContentSize().width + 150, 70)
  self.mFrame:addChild(cardIcon)
  GameData.CARD_TABLE[#GameData.CARD_TABLE + 1] = cardIcon
end

function M:onEventCardPressd(params)
  if self.mCallback then
    self.mCallback(params)
  end
end

function M:pauseEx()
  for k, v in pairs(GameData.CARD_TABLE) do
    v:pause()
  end
  self:pause()
end

function M:resumeEx()
  for k, v in pairs(GameData.CARD_TABLE) do
    v:resume()
  end
  self:resume()
end

return M
