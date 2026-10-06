local MAX_TOWER_DISTANCE = 1000
local StageBG = require("app.profiles.stageBG")
local CLASS_NAME = "PanelBG"
local M = {}
M = class(CLASS_NAME, function()
  return display.newNode()
end)

function M:ctor(towerDistance)
  self:initData(towerDistance)
  self:initUI()
  self:initTouchEvent()
  self:setNodeEventEnabled(true)
end

function M:initData(towerDistance)
  self.mTowerDistance = towerDistance
  self.mMinZoomRatio = 2 - self.mTowerDistance / MAX_TOWER_DISTANCE
  if self.mMinZoomRatio < 1 then
    self.mMinZoomRatio = 1
  end
  self.mZoomRatio = 1.5
  self.mTouchPoint1 = cc.p(0, 0)
  self.mTouchPoint2 = cc.p(0, 0)
  self.mFingerDistance = 0
  self.mBaseInfo = {}
  self.mSkillChangeBgTimer = nil
end

function M:initUI()
  local bgPath = "gamescene/bg1.png"
  local bgMiddlePath = "gamescene/bg_middle1.png"
  local bgSkyPath = "gamescene/bg_sky1.png"
  local baseInfo = DYCommon.getDataByTagEx(StageBG, {"stageMode", "stageNum"}, {
    tostring(GameManager.MODE),
    tostring(GameManager.STAGE_NUM)
  })[1]
  dump(baseInfo, "Info")
  if baseInfo then
    bgPath = baseInfo.bgPath
    bgMiddlePath = baseInfo.bgMiddlePath
    bgSkyPath = baseInfo.bgSkyPath
  end
  self.mBaseInfo = {
    bgPath = bgPath,
    bgMiddlePath = bgMiddlePath,
    bgSkyPath = bgSkyPath
  }
  self.mBg1 = display.newSprite():addTo(self)
  self.mBg2 = display.newSprite():addTo(self, -1)
  self.mBg3 = display.newSprite():addTo(self, -2)
  self.mBg1.sprArr = {}
  self.mBg2.sprArr = {}
  self.mBg3.sprArr = {}
  local bgCount = math.ceil(self.mTowerDistance / MAX_TOWER_DISTANCE)
  self.mPointBg1 = cc.p(self.mBg1:getPosition())
  for i = 1, bgCount do
    local bg1 = display.newSprite(bgPath):addTo(self.mBg1)
    bg1:setAnchorPoint(cc.p(0, 0.2))
    bg1:setPosition(cc.p((i - 1) * display.width, 0))
    self.mBg1:size(self.mBg1:getContentSize().width + bg1:getContentSize().width, self.mBg1:getContentSize().height + bg1:getContentSize().height)
    local bg2 = display.newSprite(bgMiddlePath):addTo(self.mBg2)
    bg2:setAnchorPoint(cc.p(0, 0.2))
    bg2:setPosition(cc.p((i - 1) * display.width, 0))
    self.mBg2:size(self.mBg1:getContentSize())
    local bg3 = display.newSprite(bgSkyPath):addTo(self.mBg3)
    bg3:setPosition(cc.p((i - 1) * display.width, 0))
    bg3:setAnchorPoint(cc.p(0, 0.2))
    self.mBg3:size(self.mBg1:getContentSize())
    self.mBg1.sprArr[i] = bg1
    self.mBg2.sprArr[i] = bg2
    self.mBg3.sprArr[i] = bg3
  end
  self.mBg1:setAnchorPoint(cc.p(0.5, 0))
  self.mBg1:setPositionY(display.height * 0.2)
  self.mBg2:setAnchorPoint(cc.p(0.5, 0))
  self.mBg2:setPositionY(display.height * 0.2)
  self.mBg3:setAnchorPoint(cc.p(0.5, 0))
  self.mBg3:setPositionY(display.height * 0.2)
  GameData.BG = self.mBg1
  self.mBg1:setScale(self.mZoomRatio)
  self.mBg2:setScale(self.mZoomRatio)
  self.mBg3:setScale(self.mZoomRatio)
  self:moveScreen()
end

function M:initTouchEvent()
  self.mBg1:setTouchEnabled(true)
  self.mBg1:setTouchMode(cc.TOUCH_MODE_ALL_AT_ONCE)
  self.mBg1:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    if event.name == "began" or event.name == "added" then
      for id, point in pairs(event.points) do
        if point.id == "0" then
          self.mTouchPoint1 = point
        elseif point.id == "1" then
          self.mTouchPoint2 = point
          self.mFingerDistance = cc.pGetDistance(cc.p(self.mTouchPoint1.x, self.mTouchPoint1.y), cc.p(self.mTouchPoint2.x, self.mTouchPoint2.y))
        end
      end
    elseif event.name == "moved" then
      for id, point in pairs(event.points) do
        if point.id == "0" then
          local px, py = self.mBg1:getPosition()
          self.mBg1:setPosition(cc.pAdd(cc.p(self.mBg1:getPosition()), cc.p(2 * (point.x - self.mTouchPoint1.x), 0)))
          self.mTouchPoint1 = point
          self:moveScreen()
        elseif point.id == "1" then
          self.mTouchPoint2 = point
          local curDistance = cc.pGetDistance(cc.p(self.mTouchPoint1.x, self.mTouchPoint1.y), cc.p(self.mTouchPoint2.x, self.mTouchPoint2.y))
          local curRatio = curDistance / self.mFingerDistance
          self.mZoomRatio = self.mZoomRatio * curRatio
          self.mFingerDistance = curDistance
          if self.mZoomRatio > 2.5 then
            self.mZoomRatio = 2.5
          elseif self.mZoomRatio < self.mMinZoomRatio + 0.2 then
            self.mZoomRatio = self.mMinZoomRatio + 0.2
          end
          self.mBg1:setScale(self.mZoomRatio)
          self.mBg2:setScale(self.mZoomRatio)
          self.mBg3:setScale(self.mZoomRatio)
          self:moveScreen()
        end
      end
    else
      if event.name == "removed" then
      else
      end
    end
    return true
  end)
end

function M:setBgScale(time, scale)
  if 2.5 < scale then
    scale = 2.5
  elseif scale < self.mMinZoomRatio then
    scale = self.mMinZoomRatio
  end
  if self.mZoomRatio == scale then
    return
  end
  self.mBg1:runAction(cc.ScaleTo:create(time, scale))
  self.mBg2:runAction(cc.ScaleTo:create(time, scale))
  self.mBg3:runAction(cc.ScaleTo:create(time, scale))
  self.mZoomRatio = scale
  self:moveScreen()
end

function M:setBgMove(time, pos)
  self.mBg1:runAction(cc.MoveTo:create(time, pos))
  self.mBg2:runAction(cc.MoveTo:create(time, pos))
  self.mBg3:runAction(cc.MoveTo:create(time, pos))
  self:moveScreen()
end

function M:moveScreen()
  local bg1LeftSize = (self.mBg1:getContentSize().width / 2 - 0.5 * math.abs(MAX_TOWER_DISTANCE - self.mTowerDistance)) * self.mZoomRatio - 2
  if bg1LeftSize <= self.mBg1:getPositionX() then
    self.mBg1:setPositionX(bg1LeftSize)
  end
  local bg1RightSize = display.width / 2 - ((self.mBg1:getContentSize().width / 2 - 0.5 * math.abs(MAX_TOWER_DISTANCE - self.mTowerDistance)) * self.mZoomRatio - display.width / 2) + 2
  if bg1RightSize >= self.mBg1:getPositionX() then
    self.mBg1:setPositionX(bg1RightSize)
  end
  local distanceBgMoved = self.mBg1:getPositionX() - self.mPointBg1.x
  self.mBg2:setPosition(cc.pAdd(cc.p(self.mBg2:getPosition()), cc.p(distanceBgMoved * 0.75, 0)))
  self.mBg3:setPosition(cc.pAdd(cc.p(self.mBg3:getPosition()), cc.p(distanceBgMoved * 0.5, 0)))
  self.mPointBg1 = cc.p(self.mBg1:getPosition())
  if bg1LeftSize <= self.mBg2:getPositionX() then
    self.mBg2:setPositionX(bg1LeftSize)
  end
  if bg1RightSize >= self.mBg2:getPositionX() then
    self.mBg2:setPositionX(bg1RightSize)
  end
  if bg1LeftSize <= self.mBg3:getPositionX() then
    self.mBg3:setPositionX(bg1LeftSize)
  end
  if bg1RightSize >= self.mBg3:getPositionX() then
    self.mBg3:setPositionX(bg1RightSize)
  end
end

function M:bgAction1()
  local bg1LeftSize = (self.mBg1:getContentSize().width / 2 - 0.5 * math.abs(MAX_TOWER_DISTANCE - self.mTowerDistance)) * self.mZoomRatio - 2
  self.mBg1:runAction(cc.MoveTo:create(1, cc.p(bg1LeftSize, display.height * 0.2)))
  self.mBg2:runAction(cc.MoveTo:create(1, cc.p(bg1LeftSize, display.height * 0.2)))
  self.mBg3:runAction(cc.MoveTo:create(1, cc.p(bg1LeftSize, display.height * 0.2)))
end

function M:bgAction2()
  local bg1RightSize = display.width / 2 - ((self.mBg1:getContentSize().width / 2 - 0.5 * math.abs(MAX_TOWER_DISTANCE - self.mTowerDistance)) * self.mZoomRatio - display.width / 2) + 100
  self.mBg1:runAction(cc.MoveTo:create(8, cc.p(bg1RightSize, display.height * 0.2)))
  self.mBg2:runAction(cc.MoveTo:create(8, cc.p(bg1RightSize, display.height * 0.2)))
  self.mBg3:runAction(cc.MoveTo:create(8, cc.p(bg1RightSize, display.height * 0.2)))
end

function M:onNotify(name, param)
  DDLOG("%s:onNotify, name=%s, param=%s", CLASS_NAME, name, json.encode(param))
  if name == DY_KEY.kChangeBG then
    self:onChangeBG(param)
  elseif name == DY_KEY.kResetBG then
    self:onResetBG()
  end
end

function M:onResetBG()
  local info = self.mBaseInfo
  for i = 1, #self.mBg1.sprArr do
    self.mBg1.sprArr[i]:setTexture(info.bgPath)
    self.mBg2.sprArr[i]:setTexture(info.bgMiddlePath)
    self.mBg3.sprArr[i]:setTexture(info.bgSkyPath)
  end
end

function M:onChangeBG(param)
  local info = param
  for i = 1, #self.mBg1.sprArr do
    self.mBg1.sprArr[i]:setTexture(info.bgPath)
    self.mBg2.sprArr[i]:setTexture(info.bgMiddlePath)
    self.mBg3.sprArr[i]:setTexture(info.bgSkyPath)
  end
end

function M:onEnter()
  DDLOG(CLASS_NAME .. ": onEnter")
  DYNotification.regObserver(self, handler(self, self.onNotify), DY_KEY.kChangeBG)
  DYNotification.regObserver(self, handler(self, self.onNotify), DY_KEY.kResetBG)
end

function M:onExit()
  DDLOG(CLASS_NAME .. ": onExit")
  DYNotification.removeAllObservers(self)
end

return M
