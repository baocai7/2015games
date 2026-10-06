local CLASS_NAME = "DYToast"
local M = {}
M = class(CLASS_NAME, function(cb)
  return display.newNode(cb)
end)
M.TAG_CLICK = 1000

function M:ctor(msg)
  DDLOG(CLASS_NAME .. ": onCreate")
  self.mTitle = msg
  self.mBg = nil
  self.mLabelMsg = nil
  self.mAutoRemove = true
  self:layoutUI()
end

function M:onEnter()
  DDLOG(CLASS_NAME .. ": onEnter")
end

function M:onExit()
  DDLOG(CLASS_NAME .. ": onExit")
end

function M:layoutUI()
  local title = self.mTitle or ""
  local label = cc.Label:createWithSystemFont(title, display.DEFAULT_TTF_FONT, dy.sp(display.DEFAULT_TTF_FONT_SIZE))
  local tSize = label:getContentSize()
  if tSize.width > 270 then
    label = cc.Label:createWithSystemFont(title, display.DEFAULT_TTF_FONT, dy.sp(display.DEFAULT_TTF_FONT_SIZE), cc.size(270, 0), kCCTextAlignmentCenter, cc.VERTICAL_TEXT_ALIGNMENT_TOP)
  end
  self.mLabelMsg = label
  self:addChild(label)
  tSize = label:getContentSize()
  local bkSize = cc.size(tSize.width + 10, tSize.height + 10)
  self.mBg = display.newScale9Sprite("#gi_toast_bk.png")
  self.mBg:setPreferredSize(bkSize)
  self:addChild(self.mBg, -1)
  local tPos = dy.p(CONFIG_SCREEN_WIDTH * 0.5, CONFIG_SCREEN_HEIGHT * 0.5)
  self:setPosition(tPos)
end

function M:setBkImg(img)
  if self.mBg then
    self.mBg:runAction(cc.RemoveSelf:create())
  end
  local tSize = cc.size(160, 50)
  if self.mLabelMsg then
    tSize = self.mLabelMsg:getContentSize()
  end
  self.mBg = display.newScale9Sprite(img)
  self:addChild(self.mBg, -1)
end

function M:setTextColor(color)
  if self.mLabelMsg then
    self.mLabelMsg:setColor(color)
  end
end

function M:show(anim)
  local node = display.getRunningScene()
  node:addChild(self, 100)
  if anim then
  end
  if self.mAutoRemove then
    local seq = cc.Sequence:create(cc.DelayTime:create(2), cc.FadeOut:create(1), cc.RemoveSelf:create())
    self:runAction(seq)
  end
end

return M
