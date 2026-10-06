local IconVipGift = require("app.icons.IconVipGift")
local M = {}
M = class("FramePrivilege", function()
  return display.newNode()
end)

function M:ctor(cb)
  self.mInfo = {}
  self.mListview = nil
  self.mLeftArrow = nil
  self.mRightArrow = nil
  self.mCallBack = cb
  self.mCurPage = tonumber(CloudData.VIP_LEVEL) + 1
  self.mPageSum = #DataRetainer.VIP_PRIVILEGE_INFO - 1
  if 1 > self.mPageSum then
    DDERROR("error:vipPrivilegeInfo has no data")
    return
  end
  self.mNode = display.newSprite():addTo(self, 1)
  self.mNode:setContentSize(976, 482)
  self:initBg()
end

function M:initBg()
  self:showPrivilegeList()
  self.mLeftArrow = cc.ui.UIPushButton.new("common_ui/left.png"):align(display.CENTER, self.mNode:getContentSize().width * 0, self.mNode:getContentSize().height * 0.55):addTo(self.mNode, 5):onButtonPressed(function(event)
    event.target:setScale(0.95)
  end):onButtonClicked(function()
    self:showPrePage()
  end):onButtonRelease(function(event)
    event.target:setScale(1)
  end)
  if self.mCurPage <= 1 then
    self.mLeftArrow:setVisible(false)
  else
    self.mLeftArrow:setVisible(true)
  end
  self.mRightArrow = cc.ui.UIPushButton.new("common_ui/left.png"):align(display.CENTER, self.mNode:getContentSize().width, self.mNode:getContentSize().height * 0.55):addTo(self.mNode, 5):onButtonPressed(function(event)
    event.target:setScale(0.95)
    event.target:setScaleX(-0.95)
  end):onButtonRelease(function(event)
    event.target:setScale(1)
    event.target:setScaleX(-1)
  end):onButtonClicked(function()
    self:showNextPage()
  end)
  self.mRightArrow:setScaleX(-1)
  if self.mCurPage >= self.mPageSum then
    self.mRightArrow:setVisible(false)
  else
    self.mRightArrow:setVisible(true)
  end
end

function M:showPrivilegeList()
  if self.mCallBack then
    self.mCallBack(self.mCurPage - 1)
  end
  if self.mListview then
    self.mListview:runAction(cc.RemoveSelf:create())
    self.mListview = nil
  end
  self.mListview = cc.ui.UIListView.new({
    viewRect = cc.rect(8, 86, 970, 390),
    direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
  }):addTo(self.mNode)
  self.mListview:setAnchorPoint(0.5, 0.5)
  self:showOnePrivilege()
  self:showGifts()
  self:showAllPrivilege()
  self.mListview:reload()
end

function M:showOnePrivilege()
  local strTable = {
    {
      head = DYLang.getString("S302", ""),
      tail = DYLang.getString("S303", "")
    },
    {
      head = DYLang.getString("S304", ""),
      tail = DYLang.getString("S305", "")
    },
    {
      head = DYLang.getString("S306", ""),
      tail = DYLang.getString("S307", "")
    },
    {
      head = DYLang.getString("S308", ""),
      tail = DYLang.getString("S307", "")
    },
    {
      head = DYLang.getString("S310", ""),
      tail = DYLang.getString("S311", "")
    },
    {
      head = DYLang.getString("S312", ""),
      tail = DYLang.getString("S307", "")
    },
    {
      head = DYLang.getString("S314", ""),
      tail = "%"
    }
  }
  local info = DataUtils.getVipPrivilege(self.mCurPage - 1)
  strTable[1].data = info.purchaseEnergyCount
  strTable[2].data = info.sweepCount
  strTable[3].data = info.miningCount
  strTable[4].data = info.dungeonResetCount
  strTable[5].data = info.pvpResetCount
  strTable[6].data = info.arousalCount
  strTable[7].data = checknumber(info.arousalRate) * 100
  local h = 70
  if strTable[7].data > 0 then
    h = 100
  end
  local item = self.mListview:newItem()
  local content = display.newNode()
  content:setAnchorPoint(0.5, 0.5)
  content:setContentSize(930, h)
  for i = 1, 7 do
    if strTable[i].data > 0 then
      local x = ((i - 1) % 3 + 1) * 0.3 - 0.25
      local y = h - 30 * math.ceil(i / 3) + 15
      display.newSprite("recharge/star.png", content:getContentSize().width * x, y):addTo(content)
      local str = strTable[i].head .. strTable[i].data .. strTable[i].tail
      cc.ui.UILabel.new({
        text = str,
        size = 20,
        color = cc.c3b(79, 34, 7),
        font = GameManager.FONTNAME_TTF
      }):align(display.CENTER_LEFT, content:getContentSize().width * x + 15, y):addTo(content)
    end
  end
  item:addContent(content)
  item:setItemSize(970, h + 20)
  self.mListview:addItem(item)
end

function M:showAllPrivilege()
  local strTable = {
    {
      vip = 2,
      str = DYLang.getString("S315", "")
    },
    {
      vip = 5,
      str = DYLang.getString("S316", "")
    },
    {
      vip = 7,
      str = DYLang.getString("S317", "")
    },
    {
      vip = 10,
      str = DYLang.getString("S318", "")
    },
    {
      vip = 11,
      str = DYLang.getString("PRIVILEGE_VIP_11", "")
    },
    {
      vip = 12,
      str = DYLang.getString("PRIVILEGE_VIP_12", "")
    }
  }
  local item = self.mListview:newItem()
  local content = display.newNode()
  content:setAnchorPoint(0.5, 0.5)
  content:setContentSize(920, 150)
  for i = 1, #strTable do
    local x = ((i - 1) % 3 + 1) * 0.325 - 0.152
    local y = 1.16 - math.ceil(i / 3) * 0.43
    local frame = display.newSprite("recharge/pri_tip.png", content:getContentSize().width * x, content:getContentSize().height * y):addTo(content)
    local textColor
    if tonumber(CloudData.VIP_LEVEL) >= strTable[i].vip then
      display.newSprite("recharge/tick.png", frame:getContentSize().width * 0.12, frame:getContentSize().height * 0.45):addTo(frame)
      textColor = cc.c3b(255, 251, 195)
    else
      textColor = cc.c3b(232, 187, 115)
    end
    cc.ui.UILabel.new({
      text = strTable[i].str,
      size = 20,
      color = textColor,
      font = GameManager.FONTNAME_TTF
    }):align(display.CENTER_LEFT, frame:getContentSize().width * 0.2, frame:getContentSize().height * 0.5):addTo(frame)
    cc.ui.UILabel.new({
      text = "VIP" .. strTable[i].vip,
      size = 22,
      color = cc.c3b(255, 235, 9),
      font = GameManager.FONTNAME_TTF
    }):align(display.CENTER_RIGHT, frame:getContentSize().width * 0.96, frame:getContentSize().height * 0.5):addTo(frame)
  end
  item:addContent(content)
  item:setItemSize(970, 160)
  self.mListview:addItem(item)
end

function M:showGifts()
  local item = self.mListview:newItem()
  local content = display.newNode()
  content:setAnchorPoint(0.5, 0.5)
  content:setContentSize(830, 220)
  local gift = IconVipGift.new(self.mCurPage - 1)
  gift:setPosition(content:getContentSize().width * 0.495, content:getContentSize().height * 0.5)
  content:addChild(gift)
  item:addContent(content)
  item:setItemSize(970, 182)
  self.mListview:addItem(item)
end

function M:showPrePage()
  self.mCurPage = self.mCurPage - 1
  self.mLeftArrow:setVisible(true)
  self.mRightArrow:setVisible(true)
  if self.mCurPage <= 1 then
    self.mCurPage = 1
    self.mLeftArrow:setVisible(false)
  elseif self.mCurPage >= self.mPageSum then
    self.mCurPage = self.mPageSum
    self.mRightArrow:setVisible(false)
  end
  self:showPrivilegeList()
end

function M:showNextPage()
  self.mCurPage = self.mCurPage + 1
  self.mLeftArrow:setVisible(true)
  self.mRightArrow:setVisible(true)
  if self.mCurPage >= self.mPageSum then
    self.mCurPage = self.mPageSum
    self.mRightArrow:setVisible(false)
  elseif self.mCurPage <= 1 then
    self.mCurPage = 1
    self.mLeftArrow:setVisible(false)
  end
  self:showPrivilegeList()
end

return M
