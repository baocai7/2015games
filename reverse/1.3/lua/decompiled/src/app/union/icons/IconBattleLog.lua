local RichLabel = require("app.utils.RichLabel")
local M = {}
M = class("IconBattleLog", function()
  return display.newNode()
end)
M.ATTACK = 1
M.GUARD = 2
M.BOSS = 3
M.WAIT = 4
M.KILLBOSS = 5

function M:ctor(params)
  self.mInfo = params
  if not self.mInfo then
    return
  end
  self:getMsgContent()
end

function M:getMsgContent()
  local textArr = {}
  local info = self.mInfo
  local strTable = {
    [1] = {
      str = "\227\128\144" .. checkstring(info.winner_server_name) .. "\227\128\145",
      color = cc.c3b(10, 10, 209)
    },
    [2] = {
      str = checkstring(info.winner_clan_name),
      color = cc.c3b(255, 221, 26)
    },
    [3] = {
      str = DYLang.getString("S1590", ""),
      color = cc.c3b(89, 62, 10)
    },
    [4] = {
      str = checkstring(info.winner_nick),
      color = cc.c3b(189, 13, 210)
    }
  }
  if checknumber(info.event_type) == M.ATTACK then
    strTable[5] = {
      str = DYLang.getString("S1591", ""),
      color = cc.c3b(89, 62, 10)
    }
    strTable[6] = {
      str = "\227\128\144" .. checkstring(info.loser_server_name) .. "\227\128\145",
      color = cc.c3b(10, 10, 209)
    }
    strTable[7] = {
      str = checkstring(info.loser_clan_name),
      color = cc.c3b(255, 221, 26)
    }
    strTable[8] = {
      str = DYLang.getString("S1590", ""),
      color = cc.c3b(89, 62, 10)
    }
    strTable[9] = {
      str = checkstring(info.loser_nick),
      color = cc.c3b(189, 13, 210)
    }
    strTable[10] = {
      str = "\239\188\140\229\141\179\229\176\134\229\175\185\229\174\136\230\138\164\229\133\189\233\128\160\230\136\144\228\188\164\229\174\179\239\188\129",
      color = cc.c3b(89, 62, 10)
    }
  elseif checknumber(info.event_type) == M.GUARD then
    strTable[5] = {
      str = DYLang.getString("S1591", ""),
      color = cc.c3b(89, 62, 10)
    }
    strTable[6] = {
      str = "\227\128\144" .. checkstring(info.loser_server_name) .. "\227\128\145",
      color = cc.c3b(10, 10, 209)
    }
    strTable[7] = {
      str = checkstring(info.loser_clan_name),
      color = cc.c3b(255, 221, 26)
    }
    strTable[8] = {
      str = DYLang.getString("S1590", ""),
      color = cc.c3b(89, 62, 10)
    }
    strTable[9] = {
      str = checkstring(info.loser_nick),
      color = cc.c3b(189, 13, 210)
    }
    strTable[10] = {
      str = "\239\188\140\228\191\157\229\141\171\228\186\134\233\129\147\229\156\186\239\188\129",
      color = cc.c3b(89, 62, 10)
    }
  elseif checknumber(info.event_type) == M.BOSS then
    strTable[5] = {
      str = DYLang.getString("S1595", ""),
      color = cc.c3b(89, 62, 10)
    }
    strTable[6] = {
      str = checkstring(info.boss_damage),
      color = cc.c3b(32, 254, 32)
    }
    strTable[7] = {
      str = DYLang.getString("S1596", ""),
      color = cc.c3b(89, 62, 10)
    }
  elseif checknumber(info.event_type) == M.WAIT then
    strTable[5] = {
      str = DYLang.getString("S1597", ""),
      color = cc.c3b(89, 62, 10)
    }
  elseif checknumber(info.event_type) == M.KILLBOSS then
    local bossInfo = DataUtils.getUnionBossData(checknumber(info.boss_id))
    local bossName = checkstring(bossInfo.bossName)
    strTable[5] = {
      str = DYLang.getString("S1598", ""),
      color = cc.c3b(89, 62, 10)
    }
    strTable[6] = {
      str = bossName,
      color = cc.c3b(189, 13, 210)
    }
  end
  for i = 1, #strTable do
    local txt = {
      text = strTable[i].str,
      size = 25,
      color = strTable[i].color,
      font = GameManager.FONTNAME_TTF
    }
    table.insert(textArr, txt)
  end
  local pNode = RichLabel.new({
    textArr = textArr,
    rowHeight = 28,
    maxWidth = 800
  })
  local width, height = pNode:getContentSize().width, pNode:getContentSize().height + 5
  self:addChild(pNode)
  self:setContentSize(width, height + 15)
end

return M
