local M = {}
M = class("ScrollCaption", function()
  return display.newNode()
end)
M.TYPE_AWAKE_SKILL = 3010
M.TYPE_SUMMON_AWARD = 3011
M.TYPE_GIFT_OPEN = 3012
M.TYPE_PVP_EVENT = 3013
M.TYPE_RANK_EVENT = 3014
M.TYPE_COMPETE_EVENT = 3015
M.TYPE_COMPETE_WINNER = 3016
M.TYPE_UNION_CREATE = 3017
M.TYPE_UNION_UPGRADE = 3018
M.TYPE_UNION_BOSS_UP = 3019
M.TYPE_UNION_BOSS_DEAD = 3020
M.TYPE_UNION_BATTLE_END = 3021
M.TYPE_UNION_BATTLE_START = 3022
M.TYPE_SYSTEM_PUSH = 3023
M.TYPE_SPIN_NOTICE = 3024
local TEXT_COLOR = {
  [1] = cc.c3b(255, 255, 255),
  [2] = cc.c3b(35, 255, 51),
  [3] = cc.c3b(25, 231, 255),
  [4] = cc.c3b(233, 45, 255),
  [5] = cc.c3b(255, 152, 6),
  [6] = cc.c3b(255, 48, 48),
  [7] = cc.c3b(255, 252, 13),
  [8] = cc.c3b(0, 255, 186)
}
local SCROLL_TIME = 12

function M:ctor(params)
  self.mType = params.event
  self.mParams = split(params.params, ";")
  self.mCallback = params.callback
  local clipWidth = params.width or 1028
  local clipHeight = params.height or 54
  local clipNode = cc.ClippingRectangleNode:create()
  clipNode:setClippingRegion(cc.rect(0, 0, clipWidth, clipHeight))
  self:addChild(clipNode)
  local bg = display.newSprite("common_ui/scroll_bg.png", clipWidth * 0.5, clipHeight * 0.5):addTo(clipNode)
  self.mNode = display.newNode()
  self.mNode:setPosition(bg:getContentSize().width + 5, bg:getContentSize().height * 0.5)
  self.mNode:addTo(bg)
  self.mRepeatTimes = 1
  self:loadText()
end

function M:loadText()
  local tFunc = {
    [M.TYPE_AWAKE_SKILL] = function()
      self:textWithAwakeSkill()
    end,
    [M.TYPE_SUMMON_AWARD] = function()
      self:textWithSummonAward()
    end,
    [M.TYPE_GIFT_OPEN] = function()
      self:textWithGiftOpen()
    end,
    [M.TYPE_PVP_EVENT] = function()
      self:textWithPVPEvent()
    end,
    [M.TYPE_RANK_EVENT] = function()
      self:textWithRankEvent()
    end,
    [M.TYPE_COMPETE_EVENT] = function()
      self:textWithCompeteEvent()
    end,
    [M.TYPE_COMPETE_WINNER] = function()
      self:textWithCompeteWinner()
    end,
    [M.TYPE_UNION_CREATE] = function()
      self:textWithUnionCreate()
    end,
    [M.TYPE_UNION_UPGRADE] = function()
      self:textWithUnionUpgrade()
    end,
    [M.TYPE_UNION_BOSS_UP] = function()
      self:textWithUnionBossUp()
    end,
    [M.TYPE_UNION_BOSS_DEAD] = function()
      self:textWithUnionBossDead()
    end,
    [M.TYPE_UNION_BATTLE_END] = function()
      self:textWithUnionBattleEnd()
    end,
    [M.TYPE_UNION_BATTLE_START] = function()
      self:textWithUnionBattleStart()
    end,
    [M.TYPE_SYSTEM_PUSH] = function()
      self:textWithSystemPush()
    end,
    [M.TYPE_SPIN_NOTICE] = function()
      self:textWithSpinNotice()
    end
  }
  tFunc[self.mType]()
end

function M:textWithAwakeSkill()
  local buddhaModel = DataUtils.getBuddhaModelBaseInfo(self.mParams[2])
  local skillModel = DataUtils.getAwakeSkillBaseData(self.mParams[3])
  local buddhaName = buddhaModel.name
  local buddhaQuality = buddhaModel.quality
  local skillName = skillModel.skillName
  local skillQuality = skillModel.quality
  local skillType = skillModel.skillType
  local text1 = DYLabelTTF.new({
    text = DYLang.getString("S1804", ""),
    size = 25,
    color = TEXT_COLOR[1],
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):addTo(self.mNode)
  local text2 = DYLabelTTF.new({
    text = self.mParams[1],
    size = 25,
    color = TEXT_COLOR[5],
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):addTo(self.mNode)
  local text3 = DYLabelTTF.new({
    text = DYLang.getString("S1805", ""),
    size = 25,
    color = TEXT_COLOR[1],
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):addTo(self.mNode)
  local text4 = DYLabelTTF.new({
    text = buddhaName,
    size = 25,
    color = TEXT_COLOR[buddhaQuality],
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):addTo(self.mNode)
  local text5 = DYLabelTTF.new({
    text = DYLang.getString("S1806", ""),
    size = 25,
    color = TEXT_COLOR[1],
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):addTo(self.mNode)
  local text6 = DYLabelTTF.new({
    text = skillName,
    size = 25,
    color = TEXT_COLOR[skillQuality],
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):addTo(self.mNode)
  if 0 == skillType then
    text1:setString(DYLang.getString("S1807", ""))
    text5:setString(DYLang.getString("S1808", ""))
    self.mRepeatTimes = 3
  end
  local textArr = {
    text1,
    text2,
    text3,
    text4,
    text5,
    text6
  }
  self:textAdjust(textArr)
end

function M:textWithSummonAward()
  local models = {
    DYLang.getString("S1809", ""),
    DYLang.getString("S1810", ""),
    DYLang.getString("S1811", "")
  }
  local itemModel = DataUtils.getItemModel(self.mParams[3])
  local itemName = itemModel.itemName
  local itemQuality = itemModel.quality
  local text1 = DYLabelTTF.new({
    text = self.mParams[1],
    size = 25,
    color = TEXT_COLOR[5],
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):addTo(self.mNode)
  local text2 = DYLabelTTF.new({
    text = DYLang.getString("S1812", ""),
    size = 25,
    color = TEXT_COLOR[1],
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):addTo(self.mNode)
  local text3 = DYLabelTTF.new({
    text = models[tonumber(self.mParams[2])],
    size = 25,
    color = TEXT_COLOR[self.mParams[2] + 2],
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):addTo(self.mNode)
  local text4 = DYLabelTTF.new({
    text = DYLang.getString("S1813", ""),
    size = 25,
    color = TEXT_COLOR[1],
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):addTo(self.mNode)
  local text5 = DYLabelTTF.new({
    text = itemName .. "*" .. self.mParams[4],
    size = 25,
    color = TEXT_COLOR[itemQuality],
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):addTo(self.mNode)
  local textArr = {
    text1,
    text2,
    text3,
    text4,
    text5
  }
  self:textAdjust(textArr)
end

function M:textWithGiftOpen()
  local itemModel = DataUtils.getItemModel(self.mParams[2])
  local itemName = itemModel.itemName
  local itemQuality = itemModel.quality
  local text1 = DYLabelTTF.new({
    text = DYLang.getString("S1814", ""),
    size = 25,
    color = TEXT_COLOR[1],
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):addTo(self.mNode)
  local text2 = DYLabelTTF.new({
    text = self.mParams[1],
    size = 25,
    color = TEXT_COLOR[5],
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):addTo(self.mNode)
  local text3 = DYLabelTTF.new({
    text = DYLang.getString("S1815", ""),
    size = 25,
    color = TEXT_COLOR[1],
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):addTo(self.mNode)
  local text4 = DYLabelTTF.new({
    text = itemName,
    size = 25,
    color = TEXT_COLOR[itemQuality],
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):addTo(self.mNode)
  local text5 = DYLabelTTF.new({
    text = "\239\188\140\229\144\132\228\189\141\228\187\153\229\174\182\230\179\168\230\132\143\233\162\134\229\143\150",
    size = 25,
    color = TEXT_COLOR[1],
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):addTo(self.mNode)
  local textArr = {
    text1,
    text2,
    text3,
    text4,
    text5
  }
  self:textAdjust(textArr)
end

function M:textWithPVPEvent()
  local text1 = DYLabelTTF.new({
    text = DYLang.getString("S1816", ""),
    size = 25,
    color = TEXT_COLOR[1],
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):addTo(self.mNode)
  local text2 = DYLabelTTF.new({
    text = self.mParams[1],
    size = 25,
    color = TEXT_COLOR[5],
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):addTo(self.mNode)
  local text3 = DYLabelTTF.new({
    text = DYLang.getString("S1817", ""),
    size = 25,
    color = TEXT_COLOR[1],
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):addTo(self.mNode)
  local text4 = DYLabelTTF.new({
    text = self.mParams[2],
    size = 25,
    color = TEXT_COLOR[4],
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):addTo(self.mNode)
  local text5 = DYLabelTTF.new({
    text = "\239\188\140\230\153\139\229\141\135\229\136\176\231\172\172",
    size = 25,
    color = TEXT_COLOR[1],
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):addTo(self.mNode)
  local text6 = DYLabelTTF.new({
    text = self.mParams[3],
    size = 25,
    color = TEXT_COLOR[7],
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):addTo(self.mNode)
  local text7 = DYLabelTTF.new({
    text = DYLang.getString("S1818", ""),
    size = 25,
    color = TEXT_COLOR[1],
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):addTo(self.mNode)
  local textArr = {
    text1,
    text2,
    text3,
    text4,
    text5,
    text6,
    text7
  }
  self:textAdjust(textArr)
end

function M:textWithRankEvent()
  local text1 = DYLabelTTF.new({
    text = DYLang.getString("S1819", ""),
    size = 25,
    color = TEXT_COLOR[1],
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):addTo(self.mNode)
  local text2 = DYLabelTTF.new({
    text = self.mParams[1],
    size = 25,
    color = TEXT_COLOR[5],
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):addTo(self.mNode)
  local text3 = DYLabelTTF.new({
    text = DYLang.getString("S1820", ""),
    size = 25,
    color = TEXT_COLOR[1],
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):addTo(self.mNode)
  local text4 = DYLabelTTF.new({
    text = self.mParams[2],
    size = 25,
    color = TEXT_COLOR[7],
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):addTo(self.mNode)
  local textArr = {
    text1,
    text2,
    text3,
    text4
  }
  self:textAdjust(textArr)
end

function M:textWithCompeteEvent()
  local text1 = DYLabelTTF.new({
    text = self.mParams[1],
    size = 25,
    color = TEXT_COLOR[5],
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):addTo(self.mNode)
  local text2 = DYLabelTTF.new({
    text = DYLang.getString("S1821", ""),
    size = 25,
    color = TEXT_COLOR[1],
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):addTo(self.mNode)
  local text3 = DYLabelTTF.new({
    text = self.mParams[2],
    size = 25,
    color = TEXT_COLOR[7],
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):addTo(self.mNode)
  local textArr = {
    text1,
    text2,
    text3
  }
  self:textAdjust(textArr)
end

function M:textWithCompeteWinner()
  local text1 = DYLabelTTF.new({
    text = self.mParams[1],
    size = 25,
    color = TEXT_COLOR[5],
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):addTo(self.mNode)
  local text2 = DYLabelTTF.new({
    text = DYLang.getString("S1822", ""),
    size = 25,
    color = TEXT_COLOR[1],
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):addTo(self.mNode)
  self.mRepeatTimes = 3
  local textArr = {text1, text2}
  self:textAdjust(textArr)
end

function M:textWithUnionCreate()
  local text1 = DYLabelTTF.new({
    text = DYLang.getString("S1823", ""),
    size = 25,
    color = TEXT_COLOR[1],
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):addTo(self.mNode)
  local text2 = DYLabelTTF.new({
    text = self.mParams[1],
    size = 25,
    color = TEXT_COLOR[5],
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):addTo(self.mNode)
  local text3 = DYLabelTTF.new({
    text = DYLang.getString("S1824", ""),
    size = 25,
    color = TEXT_COLOR[1],
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):addTo(self.mNode)
  local text4 = DYLabelTTF.new({
    text = self.mParams[2],
    size = 25,
    color = TEXT_COLOR[8],
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):addTo(self.mNode)
  local text5 = DYLabelTTF.new({
    text = "\239\188\140\229\185\191\233\130\128\229\144\132\232\183\175\228\187\153\229\174\182",
    size = 25,
    color = TEXT_COLOR[1],
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):addTo(self.mNode)
  local textArr = {
    text1,
    text2,
    text3,
    text4,
    text5
  }
  self:textAdjust(textArr)
end

function M:textWithUnionUpgrade()
  local text1 = DYLabelTTF.new({
    text = DYLang.getString("S1825", ""),
    size = 25,
    color = TEXT_COLOR[1],
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):addTo(self.mNode)
  local text2 = DYLabelTTF.new({
    text = self.mParams[1],
    size = 25,
    color = TEXT_COLOR[8],
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):addTo(self.mNode)
  local text3 = DYLabelTTF.new({
    text = DYLang.getString("S1826", ""),
    size = 25,
    color = TEXT_COLOR[1],
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):addTo(self.mNode)
  local text4 = DYLabelTTF.new({
    text = self.mParams[2] .. DYLang.getString("S1827", ""),
    size = 25,
    color = TEXT_COLOR[7],
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):addTo(self.mNode)
  local textArr = {
    text1,
    text2,
    text3,
    text4
  }
  self:textAdjust(textArr)
end

function M:textWithUnionBossUp()
  local bossNames = {
    DYLang.getString("S1828", ""),
    DYLang.getString("S1829", ""),
    DYLang.getString("S1830", ""),
    DYLang.getString("S1831", ""),
    DYLang.getString("S1832", "")
  }
  local text1 = DYLabelTTF.new({
    text = DYLang.getString("S1833", ""),
    size = 25,
    color = TEXT_COLOR[1],
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):addTo(self.mNode)
  local text2 = DYLabelTTF.new({
    text = self.mParams[1],
    size = 25,
    color = TEXT_COLOR[8],
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):addTo(self.mNode)
  local text3 = DYLabelTTF.new({
    text = DYLang.getString("S1834", ""),
    size = 25,
    color = TEXT_COLOR[1],
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):addTo(self.mNode)
  local text4 = DYLabelTTF.new({
    text = bossNames[tonumber(self.mParams[2])],
    size = 25,
    color = TEXT_COLOR[6],
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):addTo(self.mNode)
  local text5 = DYLabelTTF.new({
    text = DYLang.getString("S1826", ""),
    size = 25,
    color = TEXT_COLOR[1],
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):addTo(self.mNode)
  local text6 = DYLabelTTF.new({
    text = self.mParams[3] .. DYLang.getString("S1827", ""),
    size = 25,
    color = TEXT_COLOR[6],
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):addTo(self.mNode)
  local text7 = DYLabelTTF.new({
    text = "\239\188\140\229\143\152\229\190\151\230\155\180\229\138\160\229\188\186\229\164\167\228\186\134",
    size = 25,
    color = TEXT_COLOR[1],
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):addTo(self.mNode)
  local textArr = {
    text1,
    text2,
    text3,
    text4,
    text5,
    text6,
    text7
  }
  self:textAdjust(textArr)
end

function M:textWithUnionBossDead()
  local bossNames = {
    DYLang.getString("S1828", ""),
    DYLang.getString("S1829", ""),
    DYLang.getString("S1830", ""),
    DYLang.getString("S1831", ""),
    DYLang.getString("S1832", "")
  }
  local text1 = DYLabelTTF.new({
    text = DYLang.getString("S1842", ""),
    size = 25,
    color = TEXT_COLOR[1],
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):addTo(self.mNode)
  local text2 = DYLabelTTF.new({
    text = bossNames[tonumber(self.mParams[1])],
    size = 25,
    color = TEXT_COLOR[6],
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):addTo(self.mNode)
  local text3 = DYLabelTTF.new({
    text = DYLang.getString("S1843", ""),
    size = 25,
    color = TEXT_COLOR[1],
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):addTo(self.mNode)
  local text4 = DYLabelTTF.new({
    text = self.mParams[2],
    size = 25,
    color = TEXT_COLOR[5],
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):addTo(self.mNode)
  local text5 = DYLabelTTF.new({
    text = DYLang.getString("S1844", ""),
    size = 25,
    color = TEXT_COLOR[1],
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):addTo(self.mNode)
  local textArr = {
    text1,
    text2,
    text3,
    text4,
    text5
  }
  self:textAdjust(textArr)
end

function M:textWithUnionBattleEnd()
  local text1 = DYLabelTTF.new({
    text = DYLang.getString("S1845", ""),
    size = 25,
    color = TEXT_COLOR[1],
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):addTo(self.mNode)
  local text2 = DYLabelTTF.new({
    text = self.mParams[1],
    size = 25,
    color = TEXT_COLOR[8],
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):addTo(self.mNode)
  local text3 = DYLabelTTF.new({
    text = DYLang.getString("S1846", ""),
    size = 25,
    color = TEXT_COLOR[1],
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):addTo(self.mNode)
  local text4 = DYLabelTTF.new({
    text = self.mParams[2],
    size = 25,
    color = TEXT_COLOR[1],
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):addTo(self.mNode)
  local text5 = DYLabelTTF.new({
    text = DYLang.getString("S1847", ""),
    size = 25,
    color = TEXT_COLOR[1],
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):addTo(self.mNode)
  self.mRepeatTimes = 3
  local textArr = {
    text1,
    text2,
    text3,
    text4,
    text5
  }
  self:textAdjust(textArr)
end

function M:textWithUnionBattleStart()
  local str = DYLang.getString("S1848", "")
  local text1 = DYLabelTTF.new({
    text = str,
    size = 25,
    color = TEXT_COLOR[1],
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):addTo(self.mNode)
  self.mRepeatTimes = 3
  local textArr = {text1}
  self:textAdjust(textArr)
end

function M:textWithSystemPush()
  local text1 = DYLabelTTF.new({
    text = self.mParams[1],
    size = 25,
    color = TEXT_COLOR[7],
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):addTo(self.mNode)
  self.mRepeatTimes = 3
  local textArr = {text1}
  self:textAdjust(textArr)
end

function M:textWithSpinNotice()
  local models = {
    [1] = "\229\165\150\230\177\160\229\164\167\229\165\150",
    [2] = ""
  }
  local itemModel = DataUtils.getItemModel(self.mParams[3])
  local itemName = itemModel.itemName
  local itemQuality = itemModel.quality
  local text1 = DYLabelTTF.new({
    text = self.mParams[1],
    size = 25,
    color = TEXT_COLOR[5],
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):addTo(self.mNode)
  local text2 = DYLabelTTF.new({
    text = "\229\156\168\232\189\172\231\155\152\230\180\187\229\138\168\228\184\173\232\142\183\229\190\151\228\186\134",
    size = 25,
    color = TEXT_COLOR[1],
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):addTo(self.mNode)
  local text3 = DYLabelTTF.new({
    text = models[tonumber(self.mParams[2])],
    size = 25,
    color = TEXT_COLOR[6],
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):addTo(self.mNode)
  local text4 = DYLabelTTF.new({
    text = itemName .. "*" .. self.mParams[4],
    size = 25,
    color = TEXT_COLOR[itemQuality],
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):addTo(self.mNode)
  local textArr = {
    text1,
    text2,
    text3,
    text4
  }
  self:textAdjust(textArr)
end

function M:textAdjust(texts)
  local offsetX = 0
  for i = 1, #texts do
    local text = texts[i]
    text:setPosition(offsetX, 0)
    offsetX = offsetX + text:getContentSize().width
  end
  self.mNode:setContentSize(offsetX, texts[1]:getContentSize().height)
  self:textAction(self.mNode, self.mRepeatTimes)
end

function M:textAction(node, repeatTimes)
  local index = 0
  local seq = transition.sequence({
    cc.MoveBy:create(SCROLL_TIME, cc.p(-1033 - node:getContentSize().width, 0)),
    cc.CallFunc:create(function()
      index = index + 1
      node:setPositionX(1033)
      if repeatTimes == index then
        if self.mCallback then
          self.mCallback()
        end
        self:removeSelf()
      end
    end)
  })
  node:runAction(cc.Repeat:create(seq, repeatTimes))
end

return M
