local LayerContriRecord = require("app.union.layers.LayerContriRecord")
local LayerBoxShow = require("app.layers.LayerBoxShow")
local LayerRule = require("app.layers.LayerRule")
local CLASS_NAME = "LayerUnionContribute"
local M = {}
M = class(CLASS_NAME, function()
  return display.newLayer()
end)
local M_CONTRI_DATA = {
  [1] = {
    proNum = 1,
    costType = 1,
    costNum = 100000,
    contriNum = 10,
    unionExp = 5
  },
  [2] = {
    proNum = 3,
    costType = 2,
    costNum = 30,
    contriNum = 30,
    unionExp = 15
  },
  [3] = {
    proNum = 30,
    costType = 2,
    costNum = 300,
    contriNum = 300,
    unionExp = 150
  }
}
local UNION_MAX_LEVEL = 10

function M:ctor(params, callback)
  DDLOG(CLASS_NAME .. ": onCreate")
  self.mFiles = {}
  DYRes.loadFileInfo("animation/zhangjiebaoxiang1/zhangjiebaoxiang1.csb", self.mFiles)
  DYRes.loadFileInfo("animation/zhangjiebaoxiang2/zhangjiebaoxiang2.csb", self.mFiles)
  DYRes.loadFileInfo("animation/zhangjiebaoxiang3/zhangjiebaoxiang3.csb", self.mFiles)
  DYRes.loadFileInfo("animation/zhangjiebaoxiang5/zhangjiebaoxiang5.csb", self.mFiles)
  self.mCallback = callback
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  self:initData(params)
  self:initUI()
  self.mKeypadListener = handler(self, self.onKeypad)
  self:setNodeEventEnabled(true)
end

function M:initData(params)
  self.mBoxArr = {}
  self.mCanBeClicked = true
end

function M:initUI()
  local bg = display.newSprite("union/defence/bg.jpg", display.cx, display.cy):addTo(self)
  self.mBg = bg
  self:loadUnionInfo()
  self:loadContriProReward()
  self:loadContriUI()
  LayerRule.newRuleIcon(LayerRule.CONTRIBUTE):align(display.CENTER_RIGHT, display.width - 130, display.height * 0.91):addTo(self, 2)
  cc.ui.UIPushButton.new({
    normal = "union/btn_back.png",
    pressed = "union/btn_back.png"
  }):align(display.CENTER_RIGHT, display.width - 5, display.height * 0.92):onButtonPressed(function(event)
    event.target:setScale(0.9)
  end):onButtonRelease(function(event)
    event.target:setScale(1)
  end):onButtonClicked(function()
    self:closeCallBack()
  end):addTo(self, 2)
end

function M:loadUnionInfo()
  local unionIcon = display.newSprite("union/icon_union.png", 0, 0):align(display.CENTER_LEFT, 20, display.height * 0.92):addTo(self, 2)
  self.mLevelLabel = DYLabelTTF.new({
    text = string.format("LV.%d", CloudData.UNION_INFO.level),
    size = 24,
    color = cc.c3b(255, 194, 9),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {}):pos(100, unionIcon:getPositionY() + 15):addTo(self, 2)
  DYLabelTTF.new({
    text = CloudData.UNION_INFO.name,
    size = 26,
    color = display.COLOR_WHITE,
    font = GameManager.FONTNAME_TTF
  }, {}):pos(255, unionIcon:getPositionY() + 15):addTo(self, 2)
  local barBg = display.newSprite("user_center/bar_bg.png"):align(display.CENTER_LEFT, 95, unionIcon:getPositionY() - 20):addTo(self, 2)
  local currExp = CloudData.UNION_INFO.exp
  local needExp = CloudData.UNION_INFO.upgrade_exp
  self.mExpLabel = DYLabelTTF.new({
    text = currExp .. "/" .. needExp,
    size = 20,
    color = display.COLOR_WHITE,
    font = GameManager.FONTNAME_TTF
  }, {}):pos(barBg:getContentSize().width * 0.5, barBg:getContentSize().height * 0.5):addTo(barBg, 1)
  self.mExpPro = cc.ProgressTimer:create(display.newSprite("user_center/bar_pro.png")):addTo(barBg)
  self.mExpPro:setType(cc.PROGRESS_TIMER_TYPE_BAR)
  self.mExpPro:setPosition(barBg:getContentSize().width * 0.5, barBg:getContentSize().height * 0.5)
  self.mExpPro:setMidpoint(cc.p(0, 0))
  self.mExpPro:setBarChangeRate(cc.p(1, 0))
  self.mExpPro:setPercentage(currExp / needExp * 100)
  if CloudData.UNION_INFO.level >= UNION_MAX_LEVEL then
    self.mExpLabel:setString("max")
    self.mExpPro:setPercentage(100)
  end
  local sp = display.newSprite("union/contributions.png", 0, 0):align(display.CENTER_LEFT, 150 + barBg:getContentSize().width, barBg:getPositionY()):addTo(self, 2)
  local lbFrame = display.newSprite("union/lb_contri.png", 0, 0):align(display.CENTER_LEFT, sp:getPositionX() + sp:getContentSize().width, sp:getPositionY()):addTo(self, 2)
  self.mContriLabel = DYLabelTTF.new({
    text = CloudData.UNION_CONTRI_NUM,
    size = 22,
    color = display.COLOR_WHITE,
    font = GameManager.FONTNAME_TTF
  }):pos(lbFrame:getContentSize().width * 0.6, lbFrame:getContentSize().height * 0.5):addTo(lbFrame, 1)
end

function M:loadContriProReward()
  local barBg = display.newSprite("union/bar_bg.png"):pos(self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.77):addTo(self.mBg)
  local currExp = CloudData.UNION_INFO.construct_progress
  local maxNum = GameManager.UNION_BOX_REWARD_INFO[#GameManager.UNION_BOX_REWARD_INFO].progressNum
  self.mContriPro = cc.ProgressTimer:create(display.newSprite("union/bar_pro.png")):addTo(barBg)
  self.mContriPro:setType(cc.PROGRESS_TIMER_TYPE_BAR)
  self.mContriPro:setPosition(barBg:getContentSize().width * 0.5, barBg:getContentSize().height * 0.5)
  self.mContriPro:setMidpoint(cc.p(0, 0))
  self.mContriPro:setBarChangeRate(cc.p(1, 0))
  self.mContriPro:setPercentage(currExp / maxNum * 100)
  local armatureArr = {
    "zhangjiebaoxiang1",
    "zhangjiebaoxiang2",
    "zhangjiebaoxiang3",
    "zhangjiebaoxiang5"
  }
  for i = 1, #GameManager.UNION_BOX_REWARD_INFO do
    local info = GameManager.UNION_BOX_REWARD_INFO[i]
    local state = CloudData.CONTRI_REWARD_STATE[i]
    local num = info.progressNum
    local rate = num / maxNum
    local box = ccs.Armature:create(armatureArr[i])
    box:setPosition(barBg:getContentSize().width * rate, barBg:getContentSize().height * 0.5)
    box:addTo(barBg)
    if currExp >= num then
      if 0 == state or 2 == state then
        box:getAnimation():playWithIndex(0)
        CloudData.CONTRI_REWARD_STATE[i] = 2
      elseif 1 == state then
        box:getAnimation():playWithIndex(3)
      end
    else
      box:getAnimation():playWithIndex(2)
    end
    local lb = DYLabelTTF.new({
      text = num,
      size = 22,
      color = cc.c3b(255, 187, 63),
      font = GameManager.FONTNAME_TTF
    }):pos(box:getPositionX(), box:getPositionY() - 50):addTo(barBg)
    table.insert(self.mBoxArr, box)
    local boxInfo = {}
    for j = 1, #info.rewardItems do
      local id = info.rewardItems[j]
      local num = info.rewardNums[j]
      local t = {id = id, num = num}
      table.insert(boxInfo, t)
    end
    local pNode = display.newNode():pos(box:getPositionX(), box:getPositionY()):addTo(barBg, 1)
    pNode:setAnchorPoint(0.5, 0.5)
    pNode:setContentSize(85, 85)
    pNode:setTouchEnabled(true)
    pNode:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
      if event.name == "began" then
        return true
      elseif event.name == "ended" then
        self:getBoxReward({index = i, boxInfo = boxInfo})
      end
    end)
  end
  local lb1 = DYLabelTTF.new({
    text = DYLang.getString("S1690", ""),
    size = 20,
    color = display.COLOR_WHITE,
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):pos(self.mBg:getContentSize().width * 0.22, self.mBg:getContentSize().height * 0.65):addTo(self.mBg)
  self.mCurrProLabel = DYLabelTTF.new({
    text = CloudData.UNION_INFO.construct_progress,
    size = 20,
    color = cc.c3b(0, 255, 18),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):pos(lb1:getPositionX() + lb1:getContentSize().width, lb1:getPositionY()):addTo(self.mBg)
  local lb2 = DYLabelTTF.new({
    text = DYLang.getString("S1691", ""),
    size = 20,
    color = display.COLOR_WHITE,
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):pos(self.mBg:getContentSize().width * 0.65, self.mBg:getContentSize().height * 0.65):addTo(self.mBg)
  local textStr = CloudData.UNION_INFO.construct_count .. "/" .. CloudData.UNION_INFO.max_count
  self.mContriCountLabel = DYLabelTTF.new({
    text = textStr,
    size = 20,
    color = cc.c3b(0, 255, 18),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):pos(lb2:getPositionX() + lb2:getContentSize().width, lb2:getPositionY()):addTo(self.mBg)
end

function M:loadContriUI()
  local path = {
    "item_icon/pic_essence.png",
    "item_icon/pic_peach.png"
  }
  for i = 1, #M_CONTRI_DATA do
    local pData = M_CONTRI_DATA[i]
    local frame = display.newSprite("union/contribute/frame" .. i .. ".png"):pos(self.mBg:getContentSize().width * 0.25 * i, self.mBg:getContentSize().height * 0.37):addTo(self.mBg)
    local lb1 = DYLabelTTF.new({
      text = DYLang.getString("S1692", ""),
      size = 20,
      color = display.COLOR_WHITE,
      font = GameManager.FONTNAME_TTF,
      dyalign = "CENTER_LEFT"
    }, {}):pos(63, frame:getContentSize().height * 0.74):addTo(frame)
    DYLabelTTF.new({
      text = "+" .. pData.contriNum,
      size = 20,
      color = cc.c3b(0, 255, 18),
      font = GameManager.FONTNAME_TTF,
      dyalign = "CENTER_LEFT"
    }, {}):pos(lb1:getPositionX() + lb1:getContentSize().width, lb1:getPositionY()):addTo(frame)
    local lb2 = DYLabelTTF.new({
      text = DYLang.getString("S1693", ""),
      size = 20,
      color = display.COLOR_WHITE,
      font = GameManager.FONTNAME_TTF,
      dyalign = "CENTER_LEFT"
    }, {}):pos(63, frame:getContentSize().height * 0.6):addTo(frame)
    DYLabelTTF.new({
      text = "+" .. pData.unionExp,
      size = 20,
      color = cc.c3b(0, 255, 18),
      font = GameManager.FONTNAME_TTF,
      dyalign = "CENTER_LEFT"
    }, {}):pos(lb2:getPositionX() + lb2:getContentSize().width, lb2:getPositionY()):addTo(frame)
    local posX = 95
    if 2 == pData.costType then
      posX = 110
    end
    local sp = display.newSprite(path[pData.costType]):scale(0.85):pos(posX, frame:getContentSize().height * 0.43):addTo(frame)
    DYLabelTTF.new({
      text = pData.costNum,
      size = 24,
      color = cc.c3b(0, 255, 18),
      font = GameManager.FONTNAME_TTF,
      dyalign = "CENTER_LEFT"
    }, {}):pos(sp:getPositionX() + sp:getContentSize().width * 0.55, sp:getPositionY()):addTo(frame)
    local btn = cc.ui.UIPushButton.new({
      normal = "common_ui/btn_normal.png",
      pressed = "common_ui/btn_pressed.png",
      disabled = "common_ui/btn_disabled.png"
    }):scale(0.85):setButtonLabel("normal", DYLabelTTF.new({
      text = DYLang.getString("S1694", ""),
      size = 27,
      color = cc.c3b(247, 221, 156),
      font = GameManager.FONTNAME_TTF
    }, {
      lineColor = cc.c3b(67, 33, 2)
    })):setButtonLabel("disabled", DYLabelTTF.new({
      text = DYLang.getString("S1695", ""),
      size = 27,
      color = cc.c3b(201, 201, 201),
      font = GameManager.FONTNAME_TTF
    }, {
      lineColor = cc.c3b(47, 47, 47)
    })):onButtonClicked(function(event)
      self:contriCallback(i, event.target)
    end):align(display.CENTER, frame:getContentSize().width * 0.51, frame:getContentSize().height * 0.18):addTo(frame)
    if CloudData.CONTRI_TYPE == i then
      btn:setButtonEnabled(false)
    end
  end
  local lb = DYLabelTTF.new({
    text = DYLang.getString("S1696", ""),
    size = 22,
    color = display.COLOR_WHITE,
    font = GameManager.FONTNAME_TTF
  }):pos(self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.1):addTo(self.mBg)
  self.mLeftContri = DYLabelTTF.new({
    text = CloudData.CONTRI_LEFT_TIMES,
    size = 22,
    color = cc.c3b(0, 255, 18),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {}):pos(lb:getPositionX() + lb:getContentSize().width * 0.5, lb:getPositionY()):addTo(self.mBg)
  cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal.png",
    pressed = "common_ui/btn_pressed.png"
  }):scale(0.9):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S1697", ""),
    size = 27,
    color = cc.c3b(247, 221, 156),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(67, 33, 2)
  })):onButtonClicked(function()
    DDLOG("=========== \231\165\173\231\165\128\230\159\165\232\175\162")
    LayerContriRecord.new():addTo(self, 20)
  end):align(display.CENTER, self.mBg:getContentSize().width * 0.78, self.mBg:getContentSize().height * 0.06):addTo(self.mBg)
end

function M:contriCallback(pType, tar)
  if not self.mCanBeClicked then
    return
  end
  self.mCanBeClicked = false
  if CloudData.CONTRI_LEFT_TIMES <= 0 then
    WSToast.new(DYLang.getString("S1698", "")):addTo(self, 20)
    self.mCanBeClicked = true
    return
  end
  local costType = M_CONTRI_DATA[pType].costType
  local costNum = M_CONTRI_DATA[pType].costNum
  if 1 == costType then
    if costNum > CloudData.ESSENCE then
      WSToast.new(DYLang.getString("S1699", "")):addTo(self, 20)
      self.mCanBeClicked = true
      return
    end
  elseif costNum > CloudData.PEACH then
    WSToast.new(DYLang.getString("S1700", "")):addTo(self, 20)
    self.mCanBeClicked = true
    return
  end
  
  local function tFuncEvent(param)
    DDLOG(" ================ GET_CONSTRUCT !!!!!!!")
    dump(param, "event \239\188\154", 5)
    local pData = param
    if 0 < param.ret_code then
      local errMsg = param.err_msg or "UNKNOWN"
      WSToast.new(errMsg):addTo(self, 20)
      self.mCanBeClicked = true
      return
    end
    DYSoundMgr.playEffect(DY_SND.sfx_buddha_tu)
    CloudData.CONTRI_LEFT_TIMES = 0
    CloudData.CONTRI_TYPE = pType
    CloudData.UNION_INFO.construct_progress = pData.construct_progress
    CloudData.UNION_CONTRI_NUM = CloudData.UNION_CONTRI_NUM + M_CONTRI_DATA[pType].contriNum
    CloudData.GAME_ITEM_INFO["9"] = CloudData.UNION_CONTRI_NUM
    CloudData.UNION_SELF_INFO.clan_contribution = CloudData.UNION_SELF_INFO.clan_contribution + M_CONTRI_DATA[pType].contriNum
    CloudData.UNION_INFO.exp = pData.exp
    CloudData.UNION_INFO.level = pData.level
    CloudData.UNION_INFO.upgrade_exp = pData.upgrade_exp
    CloudData.UNION_INFO.construct_count = pData.construct_count
    local record = {
      icon = CloudData.UNION_SELF_INFO.icon,
      level = CloudData.UNION_SELF_INFO.level,
      nick = CloudData.UNION_SELF_INFO.nick,
      rank = CloudData.UNION_SELF_INFO.rank,
      vip = CloudData.UNION_SELF_INFO.vip,
      type = pType
    }
    table.insert(CloudData.UNION_INFO.construct_record, record)
    if 1 == pType then
      CloudData.ESSENCE = CloudData.ESSENCE - M_CONTRI_DATA[pType].costNum
    else
      CloudData.PEACH = CloudData.PEACH - M_CONTRI_DATA[pType].costNum
    end
    local str = string.format(DYLang.getString("S1701", ""), M_CONTRI_DATA[pType].contriNum, M_CONTRI_DATA[pType].unionExp)
    WSToast.new(str, 2):addTo(self, 20)
    self.mCanBeClicked = true
    self:updateUI(tar)
  end
  
  self:safeSocketRequest("CMD_CONSTRUCT", {type = pType}, tFuncEvent)
end

function M:getBoxReward(params)
  if not self.mCanBeClicked then
    return
  end
  self.mCanBeClicked = false
  if 1 == CloudData.CONTRI_REWARD_STATE[params.index] then
    self.mCanBeClicked = true
    return
  end
  if 0 == CloudData.CONTRI_REWARD_STATE[params.index] then
    DYSoundMgr.playEffect(DY_SND.sfx_touch)
    LayerBoxShow.new(params, LayerBoxShow.BOX_SHOW):addTo(self, 20)
    self.mCanBeClicked = true
    return
  end
  
  local function tFuncEvent(param)
    DDLOG(" ================ GET_CONSTRUCT_REWARD !!!!!!!")
    if 0 < param.ret_code then
      local errMsg = param.err_msg or "UNKNOWN"
      WSToast.new(errMsg):addTo(self, 20)
      self.mCanBeClicked = true
      return
    end
    DYSoundMgr.playEffect(DY_SND.sfx_box_open)
    local box = self.mBoxArr[params.index]
    CloudData.CONTRI_REWARD_STATE[params.index] = 1
    box:getAnimation():playWithIndex(1)
    self:performWithDelay(function()
      box:getAnimation():playWithIndex(3)
      LayerBoxShow.new(params, LayerBoxShow.AWARD_GET):addTo(self, 20)
      local rewardInfo = GameManager.UNION_BOX_REWARD_INFO[params.index]
      for i = 1, #params.boxInfo do
        local info = params.boxInfo[i]
        local currNum = CloudData.GAME_ITEM_INFO[tostring(info.id)] or 0
        local sum = currNum + info.num
        DataUtils.updateItemNum(info.id, sum)
        if 9 == tonumber(info.id) then
          CloudData.UNION_SELF_INFO.clan_contribution = CloudData.UNION_SELF_INFO.clan_contribution + info.num
        end
      end
      self.mContriLabel:setString(CloudData.UNION_CONTRI_NUM)
      self.mCanBeClicked = true
    end, 1.2)
  end
  
  self:safeSocketRequest("CMD_CONSTRUCT_REWARD", {
    level = params.index
  }, tFuncEvent)
end

function M:updateUI(tar)
  local currExp = CloudData.UNION_INFO.exp
  local needExp = CloudData.UNION_INFO.upgrade_exp
  self.mLevelLabel:setString(string.format("LV.%d", CloudData.UNION_INFO.level))
  self.mExpLabel:setString(currExp .. "/" .. needExp)
  self.mExpPro:setPercentage(currExp / needExp * 100)
  if CloudData.UNION_INFO.level >= UNION_MAX_LEVEL then
    self.mExpLabel:setString("max")
    self.mExpPro:setPercentage(100)
  end
  self.mContriLabel:setString(CloudData.UNION_CONTRI_NUM)
  local curNum = CloudData.UNION_INFO.construct_progress
  local maxNum = GameManager.UNION_BOX_REWARD_INFO[#GameManager.UNION_BOX_REWARD_INFO].progressNum
  self.mContriPro:setPercentage(curNum / maxNum * 100)
  for i = 1, #self.mBoxArr do
    local box = self.mBoxArr[i]
    local info = GameManager.UNION_BOX_REWARD_INFO[i]
    local state = CloudData.CONTRI_REWARD_STATE[i]
    local num = info.progressNum
    if curNum >= num then
      if 0 == state or 2 == state then
        box:getAnimation():playWithIndex(0)
        CloudData.CONTRI_REWARD_STATE[i] = 2
      elseif 1 == state then
        box:getAnimation():playWithIndex(3)
      end
    else
      box:getAnimation():playWithIndex(2)
    end
  end
  self.mCurrProLabel:setString(CloudData.UNION_INFO.construct_progress)
  self.mContriCountLabel:setString(CloudData.UNION_INFO.construct_count .. "/" .. CloudData.UNION_INFO.max_count)
  self.mLeftContri:setString(CloudData.CONTRI_LEFT_TIMES)
  tar:setButtonEnabled(false)
end

function M:closeCallBack()
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  if self.mCallback then
    self.mCallback()
  end
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
  DDLOG(CLASS_NAME .. ": onEnter")
  DYKeypadMgr.regKeyHandler(self.mKeypadListener)
end

function M:onExit()
  DDLOG(CLASS_NAME .. ": onExit")
  DYRes.unloadFileInfo(self.mFiles)
  self.mFiles = {}
  DYKeypadMgr.unregKeyHandler(self.mKeypadListener)
end

return M
