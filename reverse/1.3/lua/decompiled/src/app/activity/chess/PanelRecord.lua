local RichLabel = require("app.utils.RichLabel")
local PanelBase = import(".PanelBase")
local DYClass = "PanelRecord"
local M = {}
M = class(DYClass, PanelBase)
M.EVENT_COUNT = 20
M.TEXT = {
  event_dicing1 = "\230\130\168\230\142\183\229\135\186\228\186\134%d\231\130\185",
  event_dicing5 = "\230\130\168\233\128\137\230\139\169\228\186\134\229\134\146\233\153\169\228\186\148\230\172\161",
  event_startpoint = "\229\155\158\229\136\176\228\186\134\232\181\183\231\130\185",
  event_endpoint = "\230\138\181\232\190\190\228\186\134\231\187\136\231\130\185",
  event_use_fatecard = "\233\128\137\230\139\169\228\189\191\231\148\168%s",
  event_nothing = "\230\178\161\230\156\137\232\142\183\229\190\151\228\187\187\228\189\149\228\184\156\232\165\191",
  event_item_award = "\232\142\183\229\190\151\228\186\134\228\184\128\228\184\170%s",
  event_fate_award = "\232\142\183\229\190\151\228\186\134%s",
  event_bajiaoshan = "\232\167\166\229\143\145\228\186\134\232\138\173\232\149\137\230\137\135\230\149\136\230\158\156",
  event_jindouyun = "\232\167\166\229\143\145\228\186\134\231\173\139\230\150\151\228\186\145\230\149\136\230\158\156",
  event_heifengguai = "\232\167\166\229\143\145\228\186\134\233\187\145\233\163\142\230\128\170\230\149\136\230\158\156",
  event_huoyanshan = "\232\167\166\229\143\145\228\186\134\231\129\171\231\132\176\229\177\177\230\149\136\230\158\156",
  event_wanniangui = "\232\167\166\229\143\145\228\186\134\228\184\135\229\185\180\233\190\159\230\149\136\230\158\156",
  event_forward = "\232\167\166\229\143\145\228\186\134\229\137\141\232\191\155\230\149\136\230\158\156",
  event_backward = "\232\167\166\229\143\145\228\186\134\229\144\142\233\128\128\230\149\136\230\158\156"
}

function M:ctor(params, cb)
  M.super.ctor(self, params, cb)
  local listStr = DYStat.getValueStr(DY_KEY.kChessEvent, "")
  self.mEventList = json.decode(listStr) or {}
  self.mListHeight = 0
  self:layoutUI()
end

local function getEventContent(info)
  local textStr = ""
  for i = 1, #info do
    local event = info[i]
    if not event.param then
      textStr = textStr .. M.TEXT[event.name]
    elseif type(event.param) == "table" then
      textStr = textStr .. string.format(M.TEXT[event.name], unpack(event.param))
    else
      textStr = textStr .. string.format(M.TEXT[event.name], event.param)
    end
    if i < #info then
      textStr = textStr .. "\239\188\140"
    end
  end
  local w, h = 350, math.ceil(string.len(textStr) / 46) * 27
  local pNode = display.newNode()
  pNode:setContentSize(w, h)
  local label = DYLabelTTF.new({
    text = textStr,
    size = 22,
    color = cc.c3b(140, 40, 0),
    font = GameManager.FONTNAME_TTF,
    dimensions = cc.size(w, h),
    align = cc.ui.TEXT_ALIGN_LEFT
  }):pos(w * 0.5, h * 0.5):addTo(pNode)
  local width, height = pNode:getContentSize().width, pNode:getContentSize().height + 7
  return pNode, width, height
end

function M:layoutUI()
  local frame = display.newSprite(M_filePath("img_bottom_02"), 184, 164):addTo(self)
  self.mFrame = frame
  self:loadListView()
end

function M:loadListView()
  local listView = cc.ui.UIListView.new({
    viewRect = cc.rect(9, 9, 350, 310),
    direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
  }):addTo(self.mFrame)
  self.mListView = listView
  for i = 1, #self.mEventList do
    local msgInfo = self.mEventList[i]
    local item = listView:newItem()
    local content, width, height = getEventContent(msgInfo)
    item:addContent(content)
    item:setItemSize(width, height)
    listView:addItem(item)
    self.mListHeight = self.mListHeight + height
  end
  listView:reload()
  if 310 < self.mListHeight then
    local moveByParams = {
      x = 0,
      y = self.mListHeight - 310,
      time = 0.2
    }
    transition.moveBy(listView.container, moveByParams)
    self.mListHeight = 310
  end
end

function M:addEventItem(info)
  if not info then
    return
  end
  table.insert(self.mEventList, info)
  self:saveEventList()
  local idx = #self.mEventList
  local listView = self.mListView
  local item = listView:newItem()
  local content, width, height = getEventContent(info)
  item:addContent(content)
  item:setItemSize(width, height)
  listView:addItem(item)
  self.mListHeight = self.mListHeight + height
  if 1 < idx then
    local posY = listView.items_[idx - 1]:getPositionY()
    item:setPosition(9, posY - height)
  else
    listView:reload()
  end
  if self.mListHeight > 310 then
    local moveByParams = {
      x = 0,
      y = self.mListHeight - 310,
      time = 0.2
    }
    transition.moveBy(listView.container, moveByParams)
    self.mListHeight = 310
  end
end

function M:saveEventList()
  DYStat.setValueStr(DY_KEY.kChessEvent, json.encode(self.mEventList))
end

function M:cleanEventLog()
  self.mListView:removeAllItems()
  self.mListHeight = 0
  self.mEventList = {}
  self:saveEventList()
end

return M
