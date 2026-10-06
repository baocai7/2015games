local M = {}
M = class("PanelCounter", function()
  return display.newNode()
end)

function M:ctor()
  self.mCoreNode = display.newNode():pos(display.width - 64, 550):addTo(self)
  self.mTipFrame = nil
  self:initData()
  self:initUI()
end

function M:initData()
  self.mMaxNum = tonumber(DYCommon.getDataByTag(DataRetainer.CONST, "constername", "TroopLimit")[1].num)
  self.mCurrNum = #BMgr.getBuddhaList()
  self.mBarAction = nil
end

function M:initUI()
  local node = self.mCoreNode
  display.newSprite("gamescene/counter_frame.png"):addTo(node)
  self.mTipFrame = display.newSprite("gamescene/counter_frame_01.png"):addTo(node)
  self.mTipFrame:setVisible(false)
  self.mNumLabel = cc.ui.UILabel.new({
    text = string.format("%d/%d", self.mCurrNum, self.mMaxNum),
    size = 20,
    color = display.COLOR_WHITE,
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, 15, 0):addTo(node, 1)
  self.mSchedule = self:schedule(function()
    self:updateNum()
  end, 0.1)
end

function M:updateNum()
  self.mCurrNum = BMgr.getBuddhaListCount()
  self.mNumLabel:setString(string.format("%d/%d", self.mCurrNum, self.mMaxNum))
  if self.mCurrNum >= self.mMaxNum then
    GameData.IS_BUDDHA_LIMIT = true
    self.mNumLabel:setString(string.format("%d/%d", self.mMaxNum, self.mMaxNum))
    if not self.mTipFrame:isVisible() then
      self.mTipFrame:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.FadeIn:create(0.2), cc.FadeOut:create(0.5))))
      self.mTipFrame:setVisible(true)
    end
    return
  end
  self.mTipFrame:stopAllActions()
  self.mTipFrame:setVisible(false)
  GameData.IS_BUDDHA_LIMIT = false
end

function M:pause()
end

function M:resume()
end

return M
