local M = {}
M = class("SceneIcon", function()
  return display.newNode()
end)

function M:ctor(index, point)
  self.mNamePic = nil
  self.mNewMark = nil
  self.mIsUnlock = true
  self.mUnlockLevel = 0
  if 1 == index then
    self.mNamePath = "chapter/name_boss.png"
    self:setPosition(point.x - 95, point.y + 50)
    self.mUnlockLevel = Const.FUNC_UNLOCK.aggress
    if not DataUtils.getSceneIsUnlock("AGGRESS_SCENE", false) then
      self.mIsUnlock = false
    end
  elseif 2 == index then
    self.mNamePath = "chapter/name_summon.png"
    self:setPosition(point.x + 160, point.y + 150)
    self.mUnlockLevel = Const.FUNC_UNLOCK.summon
    if not DataUtils.getSceneIsUnlock("SUMMON_SCENE", false) then
      self.mIsUnlock = false
    end
  elseif 3 == index then
    self.mNamePath = "chapter/name_pvp.png"
    self:setPosition(point.x + 165, point.y + 100)
  elseif 4 == index then
    self.mNamePath = "chapter/name_stage.png"
    self:setPosition(point.x + 200, point.y + 120)
  elseif 5 == index then
    self.mNamePath = "chapter/name_upgrade.png"
    self:setPosition(point.x + 120, point.y + 190)
    self.mUnlockLevel = Const.FUNC_UNLOCK.cimelia
    if not DataUtils.getSceneIsUnlock("CIMELIA_SCENE", false) then
      self.mIsUnlock = false
    end
  elseif 6 == index then
    self.mNamePath = "chapter/name_train.png"
    self:setPosition(point.x + 105, point.y + 130)
    self.mUnlockLevel = Const.FUNC_UNLOCK.buddha
    if not DataUtils.getSceneIsUnlock("UPGRADE_SCENE", false) then
      self.mIsUnlock = false
    end
  elseif 7 == index then
    self.mNamePath = "chapter/name_travel.png"
    self:setPosition(point.x - 140, point.y + 70)
  elseif 8 == index then
    self.mNamePath = "chapter/name_rank.png"
    self:setPosition(point.x + 95, point.y + 120)
  elseif 9 == index then
    self.mNamePath = "chapter/name_equipment.png"
    self:setPosition(point.x + 65, point.y + 150)
    self.mUnlockLevel = Const.FUNC_UNLOCK.equipment
    if not DataUtils.getSceneIsUnlock("EQUIPMENT_SCENE", false) then
      self.mIsUnlock = false
    end
  end
  if CloudData.USER_LEVEL <= self.mUnlockLevel and not self.mIsUnlock then
    self.mIconName = display.newGraySprite(self.mNamePath, {
      0.2,
      0.3,
      0.5,
      0.1
    }):addTo(self)
  elseif CloudData.USER_LEVEL > self.mUnlockLevel then
    self.mIconName = display.newSprite(self.mNamePath):addTo(self)
    self.mIsUnlock = true
  else
    self.mIconName = display.newSprite(self.mNamePath):addTo(self)
  end
  self.mNewMark = display.newSprite("common_ui/red_point.png"):pos(self.mIconName:getContentSize().width * 0.8, self.mIconName:getContentSize().height * 0.9):hide():addTo(self.mIconName)
end

function M:setMarkVisible(flag)
  if flag then
    self.mNewMark:setVisible(true)
  else
    self.mNewMark:setVisible(false)
  end
end

function M:getMyBoundingBox()
  local point = cc.p(self:getPositionX(), self:getPositionY())
  local worldpoint = self:getParent():convertToWorldSpace(point)
  local rect = cc.rect(worldpoint.x - self.mIconName:getContentSize().width * 0.5, worldpoint.y, self.mIconName:getContentSize().width, self.mIconName:getContentSize().height)
  return rect
end

return M
