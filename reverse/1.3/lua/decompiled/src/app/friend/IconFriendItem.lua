local M = {}
M = class("IconFriendItem", function()
  return display.newNode()
end)
M.ITEM = 1
M.BTN = 2

function M:ctor(param, index, cb)
  self.mCallback = cb
  self.mData = param
  self.mIndex = checknumber(index)
  self.mUid = checkstring(param.uid)
  self.mTime = checknumber(param.time)
  self.mIcon = GameManager.USER_ICON_PATH .. checkstring(param.icon) .. ".png"
  self.mLevel = checknumber(param.level)
  self.mVip = checknumber(param.vip)
  self.mNick = checkstring(param.nick)
  self.mNew = checknumber(param.new)
  self.mBtnImg = param.btnImg
  self.mBtn = nil
  self.mSelectRing = nil
  self.mNewMark = nil
  self:layoutUI()
end

function M:layoutUI(info)
  local icon = display.newSprite("friends/img_friend_bar.png"):addTo(self)
  icon:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    return self:clickIcon(event)
  end)
  icon:setTouchEnabled(true)
  icon:setTouchSwallowEnabled(false)
  local head, vipFrame
  if self.mTime == 0 then
    head = display.newSprite("friends/img_friend_box.png", 58, 61):scale(0.86):addTo(icon, 2)
    display.newSprite(self.mIcon, 59, 59):addTo(head)
    vipFrame = display.newSprite("ranking/bg_vip.png"):scale(0.8):align(display.CENTER_RIGHT, head:getContentSize().width - 6, head:getContentSize().height - 10):addTo(head)
    cc.ui.UILabel.new({
      text = DYLang.getString("S386", ""),
      size = 20,
      color = cc.c3b(77, 155, 0),
      font = GameManager.FONTNAME_TTF
    }):align(display.CENTER_LEFT, 113, 61):addTo(icon)
  else
    head = display.newGraySprite("friends/img_friend_box.png", {
      0.2,
      0.3,
      0.5,
      0.1
    }):pos(58, 61):scale(0.86):addTo(icon, 2)
    display.newGraySprite(self.mIcon, {
      0.2,
      0.3,
      0.5,
      0.1
    }):pos(59, 59):addTo(head)
    vipFrame = display.newGraySprite("ranking/bg_vip.png", {
      0.2,
      0.3,
      0.5,
      0.1
    }):scale(0.8):align(display.CENTER_RIGHT, head:getContentSize().width - 6, head:getContentSize().height - 10):addTo(head)
    local str
    if self.mTime >= Const.FRIEND_OFFLINE_TIME_MAX * 3600 * 24 then
      str = "7" .. DYLang.getString("TIME_DAY", "") .. DYLang.getString("STR_BEYOND", "")
    else
      str = DataUtils.timeStrLeast(self.mTime) .. DYLang.getString("STR_BEFORE", "")
    end
    cc.ui.UILabel.new({
      text = str,
      size = 20,
      color = cc.c3b(151, 105, 87),
      font = GameManager.FONTNAME_TTF
    }):align(display.CENTER_LEFT, 113, 61):addTo(icon)
  end
  DYLabelTTF.new({
    text = DYLang.getString("STR_LV", "") .. self.mLevel,
    size = 20,
    color = display.COLOR_WHITE,
    font = GameManager.FONTNAME_TTF,
    dyalign = "BOTTOM_RIGHT"
  }, {
    lineColor = cc.c3b(0, 0, 0),
    lineWidth = 2
  }):align(display.BOTTOM_RIGHT, 108, 7):addTo(head)
  DYLabelTTF.new({
    text = checknumber(self.mVip),
    size = 20,
    color = display.COLOR_WHITE,
    font = GameManager.FONTNAME_TTF
  }):pos(vipFrame:getContentSize().width * 0.72, vipFrame:getContentSize().height * 0.32):addTo(vipFrame)
  self.mNewMark = display.newSprite("common_ui/red_point.png", 20, 98):hide():addTo(head, 2)
  if self.mNew == 1 then
    self.mNewMark:show()
  end
  cc.ui.UILabel.new({
    text = self.mNick,
    size = 20,
    color = cc.c3b(63, 30, 0),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER_LEFT, 113, 93):addTo(icon)
  if self.mBtnImg then
    local btn = cc.ui.UIPushButton.new(self.mBtnImg):align(display.CENTER, 300, 62):onButtonClicked(function(target)
      self:clickBtn(M.BTN, target)
    end):addTo(icon)
    btn:setTouchSwallowEnabled(false)
    self.mBtn = btn
  end
  self.mSelectRing = display.newSprite("friends/img_chosen.png", 167, 62):addTo(icon, 1):hide()
end

function M:clickIcon(event, index)
  if "began" == event.name then
    self.mBeginPos = cc.p(event.x, event.y)
    return true
  elseif "ended" == event.name then
    local pos = cc.p(event.x, event.y)
    if math.abs(pos.x - self.mBeginPos.x) < 50 and math.abs(pos.y - self.mBeginPos.y) < 50 then
      self:clickBtn(M.ITEM)
    end
  end
end

function M:clickBtn(tag, sender)
  if self.mCallback then
    self.mCallback(tag, self.mIndex, sender)
  end
end

function M:setBtnImg(img)
  if self.mBtn then
    self.mBtn:setButtonImage("normal", img, true)
    self.mBtn:setButtonImage("pressed", img, true)
  end
end

function M:select()
  self.mSelectRing:show()
end

function M:unselect()
  self.mSelectRing:hide()
end

function M:removeNew()
  self.mNewMark:hide()
  self.mNew = 0
end

function M:markNew()
  self.mNewMark:show()
  self.mNew = 1
end

return M
