local CLASS_NAME = "ListItemMail"
local M = {}
M = class(CLASS_NAME, function()
  return display.newNode(CLASS_NAME)
end)

function M:ctor(data)
  DDLOG(CLASS_NAME .. ": onCreate")
  self.mData = clone(data)
  self.mCoreNode = display.newNode():addTo(self)
  self.mCoreNode:setPosition(dy.xp(0, 0))
  self.mLabelMailSender = nil
  self.mLabelMailRemain = nil
  self.mBtnReadFlag = nil
  self.mFrameSelected = nil
  self:layoutUI()
  self:setNodeEventEnabled(true)
end

function M:onEnter()
  DDLOG(CLASS_NAME .. ": onEnter")
end

function M:onExit()
  DDLOG(CLASS_NAME .. ": onExit")
end

function M:layoutUI()
  local node = self.mCoreNode
  local proxy = cc.CCBProxy:create()
  local layer = CCBReaderLoad("ui/ListItemMail.ccbi", proxy, M)
  node:addChild(layer)
  self.mLabelMailSender = M.LabelMailSender
  self.mLabelMailRemain = M.LabelMailRemain
  self.mBtnReadFlag = M.ButtonReadFlag
  self.mFrameSelected = M.FrameSelected
  local flag = self:getReadFlag()
  self.mBtnReadFlag:setEnabled(flag)
  self.mFrameSelected:setVisible(false)
  local sendTime = os.date("%Y.%m.%d", checknumber(self.mData.sendTime / 1000))
  DYLabelTTF.new({
    text = sendTime,
    size = 20,
    dyalign = "LEFT_CENTER",
    color = cc.c3b(0, 153, 29),
    font = GameManager.FONTNAME_TTF
  }):pos(-20, -30):addTo(node):setAnchorPoint(cc.p(0, 0.5))
  self.mLabelMailSender:setVisible(false)
  self.mLabelMailRemain:setVisible(false)
  self.mLabelMailSender = DYLabelTTF.new({
    text = self.mData.title,
    size = 20,
    dyalign = "LEFT_CENTER",
    font = GameManager.FONTNAME_TTF
  }):pos(-100, 25):addTo(node)
  self.mLabelMailSender:setAnchorPoint(cc.p(0, 0.5))
  DYLabelTTF.new({
    text = string.format(DYLang.getString("S1091", ""), math.floor(self.mData.remainSecond / 3600)),
    size = 20,
    dyalign = "RIGHT_CENTER",
    color = cc.c3b(100, 50, 10),
    font = GameManager.FONTNAME_TTF
  }):pos(190, -30):addTo(node):setAnchorPoint(cc.p(1, 0.5))
  self:updateLabelColor()
end

function M:getData()
  return self.mData
end

function M:setReadFlag(flag)
  flag = flag or false
  local kReadFlag = string.format(DY_KEY.kMailReadFlag, checkstring(self.mData.id))
  DYStat.setValueBool(kReadFlag, flag)
  self.mBtnReadFlag:setEnabled(flag)
  self:updateLabelColor()
end

function M:getReadFlag()
  local kReadFlag = string.format(DY_KEY.kMailReadFlag, checkstring(self.mData.id))
  local flag = DYStat.getValueBool(kReadFlag, false)
  return flag
end

function M:setSelectFlag(flag)
  flag = flag or flase
  self.mFrameSelected:setVisible(flag)
end

function M:updateLabelColor()
  local flag = self:getReadFlag()
  if not flag then
    self.mLabelMailSender:setColor(cc.c3b(217, 26, 0))
  else
    self.mLabelMailSender:setColor(cc.c3b(75, 41, 5))
  end
end

return M
