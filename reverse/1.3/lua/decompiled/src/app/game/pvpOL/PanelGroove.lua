local PanelCard = require("app.game.pvpOL.PanelCard")
local M = {}
M = class("PanelGroove", function()
  return display.newNode()
end)
M.SPIRIT_NUM = 1001
M.BUDDHA_CARD = 1002
M.WAND_SKILL = 1003
M.TOWER_SKILL = 1004
M.MAX_CARD_NUM = 7

function M:ctor(callback)
  self:initData(callback)
  self:initUI()
end

function M:initData(callback)
  self.mCount = 0
  self.mIntervalTime = GameData.INTERVAL_TIME * 2 * 24
  self.mCallback = callback
  local tempTable = {}
  self.mCardArray = {}
  local teamInfo = CloudData.BUDDHA_ATTACK_TEAM
  for k, v in pairs(teamInfo) do
    local buddhaModel = DataUtils.getModelForPVPOnline("buddha", v)
    buddhaModel.cardType = M.BUDDHA_CARD
    table.insert(tempTable, buddhaModel)
    table.insert(tempTable, buddhaModel)
  end
  local cimeliaModel1 = DataUtils.getAtkCimeliaInfo()
  cimeliaModel1.cardType = M.WAND_SKILL
  cimeliaModel1.value = Const.CardMode.CimeliaAtkCost
  table.insert(tempTable, cimeliaModel1)
  local cimeliaModel2 = DataUtils.getDefCimeliaInfo()
  cimeliaModel2.cardType = M.TOWER_SKILL
  cimeliaModel2.value = Const.CardMode.CimeliaDefCost
  table.insert(tempTable, cimeliaModel2)
  local spiritModel = {
    value = Const.CardMode.SpiritRecover,
    cardType = M.SPIRIT_NUM,
    quality = 4
  }
  table.insert(tempTable, spiritModel)
  table.insert(tempTable, spiritModel)
  for i = 1, #tempTable do
    local endNum = #tempTable + 1 - i
    local randomNum = math.random(1, endNum)
    self.mCardArray[i] = tempTable[randomNum]
    tempTable[randomNum] = tempTable[endNum]
  end
  GameData.NEW_CARD_ARRAY = {}
  self.mIndex = 5
  GameData.CARD_TABLE = {}
end

function M:initUI()
  self.mFrame = display.newScale9Sprite("gamescene/team_frame.png", 0, 0, cc.size(display.width, 62), cc.rect(50, 30, 2, 2)):align(display.CENTER_BOTTOM, 0, 0):addTo(self)
  for i = 1, 4 do
    local cardInfo = self.mCardArray[i]
    local cardIcon = PanelCard.new(cardInfo, handler(self, self.onEventCardPressd))
    cardIcon:setPosition(cardIcon.mLeftPoint + 130 * (i - 1), 70)
    self.mFrame:addChild(cardIcon)
    GameData.CARD_TABLE[#GameData.CARD_TABLE + 1] = cardIcon
  end
end

function M:update()
  self.mCount = self.mCount + 1
  for k, v in pairs(GameData.CARD_TABLE) do
    v:updateLogic()
  end
  if self.mCount >= self.mIntervalTime then
    self.mCount = 0
    self:cardSpawn()
  end
end

function M:cardSpawn()
  DDLOG(#GameData.CARD_TABLE .. " / " .. M.MAX_CARD_NUM)
  if #GameData.CARD_TABLE >= M.MAX_CARD_NUM then
    return
  end
  if self.mIndex > #self.mCardArray then
    self.mIndex = 1
    self.mCardArray = clone(GameData.NEW_CARD_ARRAY)
    GameData.NEW_CARD_ARRAY = {}
  end
  DDLOG(DYLang.getString("S273", ""))
  local cardInfo = self.mCardArray[self.mIndex]
  local cardIcon = PanelCard.new(cardInfo, handler(self, self.onEventCardPressd))
  cardIcon:setPosition(self.mFrame:getContentSize().width + 150, 70)
  self.mFrame:addChild(cardIcon)
  GameData.CARD_TABLE[#GameData.CARD_TABLE + 1] = cardIcon
  self.mIndex = self.mIndex + 1
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
