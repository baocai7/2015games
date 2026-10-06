local CLASS_NAME = "LayerPVPEntrance"
local M = {}
M = class(CLASS_NAME, function()
  return display.newLayer()
end)
M.TAG_PVP_NORMAL = 1
M.TAG_PVPOL_RANK = 2
M.TAG_PVPOL_COMPETE = 3
M.TAG_PVP_TEAMFIGHT = 4

function M:ctor()
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  self.mFileInfo = {}
  DYRes.loadFileInfo("animation/suo/suo.csb", self.mFileInfo)
  self.mNode = display.newNode():pos(display.cx, display.cy):addTo(self)
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  self.mIsCompeteOpen = false
  self.mIsCompeteUnlock = false
  self.mButtonList = {}
  self.mTouchEnabled = false
  self:layoutUI()
  self.mKeypadListener = handler(self, self.onKeypad)
  self:setNodeEventEnabled(true)
end

function M:layoutUI()
  self:initData()
end

function M:addWidget()
  local node = self.mNode
  local bg = display.newScale9Sprite("purgatory/bg.png", 0, 0, cc.size(1062, 665), cc.rect(1062, 330, 0, 45)):addTo(self.mNode)
  self.mBg = bg
  local titleBg = display.newSprite("common_ui/title_frame.png"):pos(531, 612):addTo(bg)
  display.newSprite("pvp_entrance/title.png"):pos(214, 49):addTo(titleBg)
  local btnClose = cc.ui.UIPushButton.new({
    normal = "common_ui/close_normal.png",
    pressed = "common_ui/close_pressed.png"
  }):onButtonClicked(function()
    self:buttonListener("ButtonClose")
  end):pos(1017, 610):addTo(bg)
  local list = cc.ui.UIListView.new({
    viewRect = cc.rect(70, 102, 935, 460),
    direction = cc.ui.UIScrollView.DIRECTION_HORIZONTAL
  }):addTo(bg)
  for i = 1, #self.mInfo do
    local item = list:newItem()
    local img = "pvp_entrance/" .. checkstring(self.mInfo[i].icon) .. ".png"
    if i == M.TAG_PVPOL_COMPETE then
      img = "pvp_entrance/" .. checkstring(self.mInfo[i].icon) .. "1.png"
    end
    local btn = cc.ui.UIPushButton.new({normal = img, pressed = img}):onButtonPressed(function(event)
      event.target:setScale(0.95)
    end):onButtonRelease(function(event)
      event.target:setScale(1)
    end):onButtonClicked(function()
      self:buttonListener(i)
    end)
    btn:setTouchSwallowEnabled(false)
    self.mButtonList[i] = btn
    item:addContent(btn)
    item:setItemSize(310, 470)
    list:addItem(item)
  end
  list:reload()
  self:addLock()
end

function M:initData()
  local function tFuncEvent(param)
    DDLOG(" ================ GET_COMPETE_STATUS !!!!!!!")
    
    self.mIsCompeteOpen = param.is_open
    CloudData.COMPETE_MODE = param.fight_mode
    local resPath = {"ol_rank", "ol_card"}
    local uid = CloudData.UID
    local serverId = tonumber(CloudData.USER_SERVER_ID)
    self.mInfo = {
      [M.TAG_PVP_NORMAL] = {
        name = "ButtonPVP",
        icon = "pvp",
        unlockLevel = Const.FUNC_UNLOCK.pvp,
        key = string.format(DY_KEY.kIsPVPNormalUnlock, serverId, uid),
        func = function()
          self:showPVP()
        end
      },
      [M.TAG_PVPOL_RANK] = {
        name = "ButtonOLCompete",
        icon = resPath[CloudData.COMPETE_MODE],
        unlockLevel = Const.FUNC_UNLOCK.pvpOL,
        key = string.format(DY_KEY.kIsPVPOnlineUnlock, serverId, uid),
        func = function()
          self:showPVPOLRank()
        end
      },
      [M.TAG_PVPOL_COMPETE] = {
        name = "ButtonOLRank",
        icon = "ol_compete",
        unlockLevel = Const.FUNC_UNLOCK.pvpOL,
        key = string.format(DY_KEY.kIsPVPOnlineUnlock, serverId, uid),
        func = function()
          self:showPVPOLCompete()
        end
      },
      [M.TAG_PVP_TEAMFIGHT] = {
        name = "ButtonTeamFight",
        icon = "lock",
        unlockLevel = 0,
        key = string.format(DY_KEY.kIsPVPTeamFightUnlock, serverId, uid),
        func = function()
          self:showTeamCompete()
        end
      }
    }
    self.mTouchEnabled = true
    self:addWidget()
    self:refreshBtnStatus()
  end
  
  self:safeSocketRequest("CMD_COMPETE_STATUS", nil, tFuncEvent)
end

function M:refreshBtnStatus()
  local img = "pvp_entrance/" .. checkstring(self.mInfo[M.TAG_PVPOL_COMPETE].icon) .. ".png"
  if not self.mIsCompeteOpen or not self.mIsCompeteUnlock then
    img = "pvp_entrance/" .. checkstring(self.mInfo[M.TAG_PVPOL_COMPETE].icon) .. "1.png"
  end
  self.mButtonList[M.TAG_PVPOL_COMPETE]:setButtonImage("normal", img)
  self.mButtonList[M.TAG_PVPOL_COMPETE]:setButtonImage("pressed", img)
end

function M:addLock()
  local userLevel = CloudData.USER_LEVEL
  for i = 1, #self.mInfo do
    if userLevel < self.mInfo[i].unlockLevel or userLevel == self.mInfo[i].unlockLevel and not DYStat.getValueBool(self.mInfo[i].key, false) then
      local img = "pvp_entrance/" .. checkstring(self.mInfo[i].icon) .. "1.png"
      self.mButtonList[i]:setButtonImage("normal", img)
      self.mButtonList[i]:setButtonImage("pressed", img)
      local armature = ccs.Armature:create("suo")
      armature:setPosition(0, 0)
      self.mButtonList[i]:addChild(armature)
      armature:getAnimation():playWithIndex(0)
      if i == M.TAG_PVPOL_COMPETE then
        self.mIsCompeteUnlock = false
      end
      if userLevel == self.mInfo[i].unlockLevel then
        self.mButtonList[i]:setTouchEnabled(false)
        self:showUnlockAni(armature, i)
      end
    elseif i == M.TAG_PVPOL_COMPETE then
      self.mIsCompeteUnlock = true
    end
  end
end

function M:buttonListener(tag)
  if tag == "ButtonClose" then
    self:closeCallBack()
  elseif self.mInfo[checknumber(tag)] then
    self:clickIcon(tag)
  end
end

function M:clickIcon(tag)
  if not self.mInfo[checknumber(tag)] then
    return
  end
  local userLevel = CloudData.USER_LEVEL
  local requireLv = self.mInfo[checknumber(tag)].unlockLevel or 100
  if userLevel < requireLv then
    WSToast.new(DYLang.getString("S790", "") .. requireLv .. DYLang.getString("S791", "")):addTo(self, 20)
  elseif self.mInfo[checknumber(tag)].func then
    self.mInfo[checknumber(tag)].func()
  end
end

function M:showPVP()
  display.replaceScene(require("scenes.ScenePVP").new())
end

function M:showPVPOLRank()
  if not self.mTouchEnabled then
    WSToast.new(DYLang.getString("S793", "")):addTo(self, 20)
  else
    self:enterPVPOLRank()
  end
end

function M:showPVPOLCompete()
  if not self.mTouchEnabled then
    WSToast.new(DYLang.getString("S793", "")):addTo(self, 20)
  elseif self.mIsCompeteOpen then
    self:enterPVPOLCompete()
  else
    WSToast.new(DYLang.getString("S797", "")):addTo(self, 20)
  end
end

function M:showTeamCompete()
  WSToast.new(DYLang.getString("S798", "")):addTo(self, 20)
end

function M:enterPVPOLRank()
  local function tFuncEvent(param)
    DDLOG(" ================ LOGIN_OK !!!!!!!")
    
    CloudData.GRADE_INFO = param.pvp_data
    CloudData.COMPETE_LIST = param.compete_top_list
    CloudData.CURR_RANK_LIST = param.cur_top_list
    CloudData.SEASON_DURATION = param.duration
    display.replaceScene(require("app.pvponline.LayerRankInfo").new())
  end
  
  self:safeSocketRequest("CMD_PVP_INIT_DATA", nil, tFuncEvent)
end

function M:enterPVPOLCompete()
  self:safeSocketRequest("CMD_PVP_INIT_DATA")
  display.replaceScene(require("app.pvponline.LayerCompeteInfo").new())
end

function M:showUnlockAni(lock, tag)
  self.mButtonList[tag]:setTouchEnabled(false)
  lock:getAnimation():playWithIndex(1)
  
  local function animationEvent(armatureBack, movementType, movementID)
    if movementType == ccs.MovementEventType.complete then
      local popuplayer = transition.sequence({
        cc.CallFunc:create(function()
          self.mButtonList[tag]:setTouchEnabled(true)
          self.mIsCompeteUnlock = true
          if tag == M.TAG_PVPOL_COMPETE then
            self:refreshBtnStatus()
          else
            local img = "pvp_entrance/" .. checkstring(self.mInfo[tag].icon) .. ".png"
            self.mButtonList[tag]:setButtonImage("normal", img)
            self.mButtonList[tag]:setButtonImage("pressed", img)
          end
          DYStat.setValueBool(self.mInfo[tag].key, true)
          lock:runAction(cc.RemoveSelf:create())
        end)
      })
      if self.mButtonList[tag] then
        self.mButtonList[tag]:runAction(popuplayer)
      end
    end
  end
  
  lock:getAnimation():setMovementEventCallFunc(animationEvent)
end

function M:closeCallBack()
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  self:runAction(cc.RemoveSelf:create())
end

function M:onKeypad(keyCode, event)
  DDLOG("Key %d was on pressed!", keyCode)
  if keyCode == cc.KeyCode.KEY_ESCAPE then
    self:closeCallBack()
    return true
  end
  return false
end

function M:onEnter()
  DYKeypadMgr.regKeyHandler(self.mKeypadListener)
end

function M:onExit()
  DYKeypadMgr.unregKeyHandler(self.mKeypadListener)
  DYRes.unloadFileInfo(self.mFileInfo)
end

return M
