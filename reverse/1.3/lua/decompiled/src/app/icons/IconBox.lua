local IconItem = require("app.icons.IconItem")
local LayerBoxShow = require("app.layers.LayerBoxShow")
local DYClass = "IconBox"
local M = {}
M = class(DYClass, function()
  return display.newNode()
end)

function M:ctor(index, state, img, cb)
  self:setNodeEventEnabled(true)
  self.mBg = nil
  self.mType = index or 4
  self.mState = checknumber(state)
  self.mOriImg = img
  self.mCallback = cb
  self.mArmature = nil
  self.mFileInfo = {}
  DYRes.loadFileInfo(string.format("animation/zhangjiebaoxiang%d/zhangjiebaoxiang%d.csb", self.mType, self.mType), self.mFileInfo)
  self:addArmature()
end

function M:addArmature()
  if self.mState == 0 and self.mOriImg then
    display.newSprite(self.mOriImg, 0, 0):addTo(self)
    return
  end
  local armature = ccs.Armature:create("zhangjiebaoxiang" .. self.mType)
  self:addChild(armature)
  self.mArmature = armature
  if self.mState == 0 then
    self.mArmature:getAnimation():playWithIndex(2)
  elseif self.mState == 1 then
    DYSoundMgr.playEffect(DY_SND.sfx_box_ready)
    self.mArmature:getAnimation():playWithIndex(0)
  else
    self.mArmature:getAnimation():playWithIndex(3)
  end
end

function M:showAni(index)
  if not self.mArmature then
    self.mArmature = ccs.Armature:create("zhangjiebaoxiang" .. self.mType)
    self:addChild(self.mArmature)
  end
  self.mArmature:getAnimation():playWithIndex(index)
end

function M:openBox(info, x, y)
  if not self.mArmature then
    self.mArmature = ccs.Armature:create("zhangjiebaoxiang" .. self.mType)
    self:addChild(self.mArmature)
  end
  DYSoundMgr.playEffect(DY_SND.sfx_box_open)
  self.mArmature:getAnimation():playWithIndex(1)
  if x and y then
    self.mArmature:setPosition(x, y)
  end
  local showed = false
  
  local function animationEvent(armatureBack, movementType, movementID)
    if movementType == ccs.MovementEventType.complete and not showed then
      showed = true
      self:showBox(info, LayerBoxShow.AWARD_GET)
      self.mArmature:getAnimation():playWithIndex(3)
      if self.mCallback then
        self.mCallback()
      end
    end
  end
  
  self.mArmature:getAnimation():setMovementEventCallFunc(animationEvent)
end

function M:showBox(info, tag)
  LayerBoxShow.new(info, tag or LayerBoxShow.BOX_SHOW):addTo(display.getRunningScene(), 20)
end

function M:onEnter()
  DDLOG(DYClass .. ": onEnter")
end

function M:onExit()
  DDLOG(DYClass .. ": onExit")
  DYRes.unloadFileInfo(self.mFileInfo)
end

return M
