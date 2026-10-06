local DYClass = "LayerRankingAward"
local M = {}
M = class(DYClass, function()
  return display.newLayer()
end)
M.RANK_DUNGEON = 1
M.RANK_PVP = 2
M.RANK_LEVEL = 3
M.RANK_CE = 4
local RULE_TEXT = {
  [M.RANK_DUNGEON] = "\230\178\191\233\128\148\231\153\190\229\167\147\228\184\186\231\173\148\232\176\162\233\153\141\229\166\150\233\153\164\233\173\148\231\154\132\228\188\151\228\187\153\229\174\182\239\188\140\229\135\134\229\164\135\228\186\134\229\164\167\233\135\143\228\190\155\229\165\137\227\128\130\230\150\176\230\156\141\231\172\172\228\184\131\229\164\169\239\188\140\230\160\185\230\141\174\232\142\183\229\190\151\231\154\132\230\152\159\231\186\167\230\149\176\233\135\143\239\188\140\229\137\14110\229\144\141\228\187\153\229\174\182\229\176\134\232\142\183\229\190\151\228\184\176\229\142\154\229\165\150\229\138\177\227\128\130",
  [M.RANK_PVP] = "\228\187\150\229\177\177\228\185\139\231\159\179\239\188\140\229\143\175\228\187\165\230\148\187\231\142\137\239\188\140\229\164\170\229\174\151\229\175\187\230\137\190\230\156\128\230\156\137\230\189\156\229\138\155\231\154\132\229\143\150\231\187\143\229\176\143\229\136\134\233\152\159\227\128\130\231\172\172\228\184\131\230\151\165\230\147\130\229\143\176\230\142\146\232\161\140\230\166\156\229\137\14110\229\144\141\229\176\134\232\142\183\229\190\151\230\157\165\232\135\170\228\184\156\229\156\159\229\164\167\229\148\144\229\164\170\230\185\150\232\138\177\230\158\156\229\177\177\231\154\132\228\184\128\233\146\181\229\156\159\231\137\185\228\186\167\227\128\130",
  [M.RANK_LEVEL] = "\229\144\131\230\158\156\229\173\144\229\141\135\231\186\167\233\153\141\229\166\150\239\188\140\230\138\189\228\187\153\233\173\148\231\153\190\229\143\152\233\154\143\229\191\131\239\188\140\230\156\137\233\129\147\230\152\175\228\184\128\229\138\155\233\153\141\229\141\129\228\188\154\239\188\140\228\184\128\231\186\167\230\181\174\229\177\160\233\153\141\229\141\129\229\138\155\227\128\130\229\143\136\230\152\175\228\184\128\229\164\167\230\179\162\232\138\177\230\158\156\229\177\177\229\156\159\228\186\167\230\157\165\232\162\173\239\188\140\231\173\137\231\186\167\233\171\152\231\154\132\229\133\136\230\139\191\227\128\130",
  [M.RANK_CE] = "\229\157\154\229\174\154\230\128\157\230\131\179\239\188\140\229\184\166\229\165\189\233\152\159\228\188\141\239\188\140\231\148\173\231\174\161\231\137\155\233\169\172\232\155\135\231\190\138\239\188\140\230\136\152\229\138\155\233\171\152\231\154\132\229\133\136\228\184\138\239\188\140\229\164\169\229\186\173\231\137\185\228\189\191\229\143\170\231\156\139\232\191\153\228\184\170\239\188\140\229\148\148\228\189\160\232\175\180\229\165\150\232\181\143\239\188\140\229\176\177\232\191\153\228\186\155\239\188\140\229\176\143\231\154\132\228\191\157\232\175\129\230\178\161\229\133\139\230\137\163500\230\161\131\229\173\144\227\128\130"
}

function M:ctor()
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  self.mNode = display.newNode():pos(display.cx, display.cy):addTo(self, 1)
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  self.mRankIdx = M.RANK_DUNGEON
  self.mCurrTabBtn = {}
  self.mTabBtnTable = {}
  self.mCountNode = {}
  self:initUI()
  self:initData()
  self.mKeypadListener = handler(self, self.onKeypad)
  self:setNodeEventEnabled(true)
end

local function M_filePath(name)
  return string.format("ranking_award/%s.png", name)
end

function M:initData()
  local dateTime = split(os.date("%x"), "/")
  local y, m, d = tonumber(dateTime[3]), tonumber(dateTime[1]), tonumber(dateTime[2])
  local sceneDate = {
    year = y,
    month = m,
    day = d
  }
  local isNeedRefresh = false
  if GameManager.SCENE_DATE then
    if sceneDate.year > GameManager.SCENE_DATE.year then
      isNeedRefresh = true
    elseif sceneDate.month > GameManager.SCENE_DATE.month then
      isNeedRefresh = true
    elseif sceneDate.day > GameManager.SCENE_DATE.day then
      isNeedRefresh = true
    end
  end
  if not isNeedRefresh and CloudData.RANKING_AWARD_LIST then
    self.mRankList = CloudData.RANKING_AWARD_LIST
    self.mEndTime = CloudData.ACT_END_TIME
    self.mRuleLabel:setString(RULE_TEXT[self.mRankIdx] .. "      \230\136\170\230\173\162\230\151\182\233\151\180\239\188\154" .. self.mEndTime)
    self.mCurrRank = self.mRankList[self.mRankIdx]
    self:initRankList(self.mRankIdx)
    return
  end
  
  local function tFuncListener(jsonTable)
    local pData = jsonTable.data
    local userCEData = pData.config[tostring(M.RANK_CE)]
    local pvpData = pData.config[tostring(M.RANK_PVP)]
    local levelData = pData.config[tostring(M.RANK_LEVEL)]
    local stageData = pData.config[tostring(M.RANK_DUNGEON)]
    if pData.award then
      for i = 1, #userCEData do
        userCEData[i].nick = pData.award[tostring(M.RANK_CE)][i].nick
      end
      for i = 1, #pvpData do
        pvpData[i].nick = pData.award[tostring(M.RANK_PVP)][i].nick
      end
      for i = 1, #levelData do
        levelData[i].nick = pData.award[tostring(M.RANK_LEVEL)][i].nick
      end
      for i = 1, #stageData do
        stageData[i].nick = pData.award[tostring(M.RANK_DUNGEON)][i].nick
      end
    end
    table.sort(userCEData, function(v1, v2)
      return v1.rank < v2.rank
    end)
    table.sort(pvpData, function(v1, v2)
      return v1.rank < v2.rank
    end)
    table.sort(levelData, function(v1, v2)
      return v1.rank < v2.rank
    end)
    table.sort(stageData, function(v1, v2)
      return v1.rank < v2.rank
    end)
    self.mRankList = {
      stageData,
      pvpData,
      levelData,
      userCEData
    }
    CloudData.RANKING_AWARD_LIST = self.mRankList
    self.mEndTime = pData.endTime
    self.mRuleLabel:setString(RULE_TEXT[self.mRankIdx] .. "      \230\136\170\230\173\162\230\151\182\233\151\180\239\188\154" .. self.mEndTime)
    CloudData.ACT_END_TIME = self.mEndTime
    self.mCurrRank = self.mRankList[self.mRankIdx]
    self:initRankList(self.mRankIdx)
    GameManager.SCENE_DATE = sceneDate
  end
  
  DYHttpMgr.getSevenRankingAward(tFuncListener, {})
end

function M:initUI()
  local bg = display.newSprite(M_filePath("img_bg_01")):addTo(self.mNode)
  self.mBg = bg
  self.mRolePic = display.newSprite(M_filePath("img_bg_00"), 635, 150):addTo(bg, 1)
  self.mRuleLabel = DYLabelTTF.new({
    text = RULE_TEXT[self.mRankIdx],
    size = 20,
    color = cc.c3b(99, 63, 2),
    font = GameManager.FONTNAME_TTF,
    align = cc.ui.TEXT_ALIGN_LEFT,
    dimensions = cc.size(508, 75)
  }):pos(465, 570):addTo(bg)
  self:initTabBtn()
  cc.ui.UIPushButton.new({
    normal = "common_ui/close_normal.png",
    pressed = "common_ui/close_pressed.png"
  }):align(display.CENTER, bg:getContentSize().width * 0.94, bg:getContentSize().height * 0.92):onButtonClicked(function()
    self:closeCallBack()
  end):addTo(bg, 15)
end

function M:initTabBtn()
  local M_TAB_BTN = {
    {
      normal = M_filePath("tab_btn1"),
      pressed = M_filePath("tab_btn1"),
      disabled = M_filePath("tab_btn1_h")
    },
    {
      normal = M_filePath("tab_btn2"),
      pressed = M_filePath("tab_btn2"),
      disabled = M_filePath("tab_btn2_h")
    },
    {
      normal = M_filePath("tab_btn3"),
      pressed = M_filePath("tab_btn3"),
      disabled = M_filePath("tab_btn3_h")
    },
    {
      normal = M_filePath("tab_btn4"),
      pressed = M_filePath("tab_btn4"),
      disabled = M_filePath("tab_btn4_h")
    }
  }
  for i = 1, #M_TAB_BTN do
    local btn = cc.ui.UIPushButton.new(M_TAB_BTN[i]):onButtonClicked(function()
      self:funcChange(i)
    end):align(display.CENTER_RIGHT, 74, self.mBg:getContentSize().height * (0.9 - i * 0.12)):addTo(self.mBg)
    if self.mRankIdx == i then
      btn:setButtonEnabled(false)
      self.mCurrTabBtn = btn
    end
    table.insert(self.mTabBtnTable, btn)
  end
end

function M:initRankList(tag)
  if self.mCurrNode then
    self.mCurrNode:hide()
  end
  if self.mCountNode[tag] then
    self.mCountNode[tag]:show()
    self.mCurrNode = self.mCountNode[tag]
    return
  end
  local node = display.newScale9Sprite("pvp_ol/gi_rank_frame.png", 98, 88, cc.size(625, 445), cc.rect(200, 50, 1, 1)):addTo(self.mBg)
  node:setOpacity(0)
  node:setAnchorPoint(0, 0)
  node:setContentSize(625, 445)
  for i = 1, #self.mCurrRank do
    local rankData = self.mCurrRank[i]
    local posX, posY = 92, 465 - 44.5 * i
    if i < 4 then
      display.newSprite(M_filePath("rank" .. i), posX, posY):addTo(node)
    else
      DYLabelTTF.new({
        text = i,
        size = 24,
        color = cc.c3b(74, 49, 6),
        font = GameManager.FONTNAME_TTF
      }):pos(posX, posY):addTo(node)
    end
    posX = posX + 168
    if rankData.nick then
      DYLabelTTF.new({
        text = rankData.nick,
        size = 18,
        color = cc.c3b(75, 49, 6),
        font = GameManager.FONTNAME_TTF
      }):pos(posX, posY):addTo(node)
      posX = posX + 168
      self.mRolePic:hide()
    end
    local img = display.newSprite("common_ui/icon_peach.png", posX, posY):addTo(node)
    DYLabelTTF.new({
      text = "x" .. rankData.counts,
      size = 18,
      color = cc.c3b(75, 49, 6),
      font = GameManager.FONTNAME_TTF
    }):pos(img:getPositionX() + 40, posY):addTo(node)
  end
  self.mCurrNode = node
  self.mCountNode[tag] = node
end

function M:funcChange(index)
  DYSoundMgr.playEffect(DY_SND.sfx_touch)
  self.mRankIdx = index
  self.mCurrTabBtn:setButtonEnabled(true)
  self.mCurrTabBtn = self.mTabBtnTable[index]
  self.mCurrTabBtn:setButtonEnabled(false)
  self.mCurrRank = self.mRankList[index]
  self.mRuleLabel:setString(RULE_TEXT[index] .. "      \230\136\170\230\173\162\230\151\182\233\151\180\239\188\154" .. self.mEndTime)
  self:initRankList(index)
end

function M:closeCallBack()
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  self:removeSelf()
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
  DDLOG(DYClass .. ": onEnter")
  DYKeypadMgr.regKeyHandler(self.mKeypadListener)
end

function M:onExit()
  DDLOG(DYClass .. ": onExit")
  DYKeypadMgr.unregKeyHandler(self.mKeypadListener)
end

return M
