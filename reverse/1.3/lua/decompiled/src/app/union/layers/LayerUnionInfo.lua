local LayerMemberApply = require("app.union.layers.LayerMemberApply")
local LayerCommon = require("app.union.layers.LayerCommon")
local CLASS_NAME = "LayerUnionInfo"
local M = {}
M = class(CLASS_NAME, function()
  return display.newLayer()
end)
local MIN_MEMBER_NUM = 3
local UNION_MAX_LEVEL = 10

function M:ctor(params, callback)
  DDLOG(CLASS_NAME .. ": onCreate")
  self.mCallback = callback
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  self.mEmptyNode = display.newNode()
  self.mEmptyNode:setPosition(display.cx, display.cy)
  self:addChild(self.mEmptyNode)
  self:initUI()
  self:initData(params)
  self.mKeypadListener = handler(self, self.onKeypad)
  self:setNodeEventEnabled(true)
end

function M:initUI()
  local bg = display.newSprite("pvp_ol/bg_rankInfo.png", 0, -20):addTo(self.mEmptyNode)
  self.mBg = bg
  local titleFrame = display.newSprite("common_ui/title_frame.png"):pos(bg:getContentSize().width * 0.5, bg:getContentSize().height - 30):addTo(bg)
  display.newSprite("union/title.png"):pos(titleFrame:getContentSize().width * 0.5, titleFrame:getContentSize().height * 0.55):addTo(titleFrame)
  cc.ui.UIPushButton.new({
    normal = "common_ui/close_normal.png",
    pressed = "common_ui/close_pressed.png"
  }):scale(0.9):onButtonClicked(function()
    self:closeCallBack()
  end):align(display.CENTER, bg:getContentSize().width * 0.95, bg:getContentSize().height * 0.94):addTo(bg, 2)
end

function M:initData(params)
  self:loadUnionBaseInfo()
end

function M:loadUnionBaseInfo()
  local height = self.mBg:getContentSize().height * 0.92
  local pName = display.newSprite("union/label_name.png"):align(display.CENTER_LEFT, 96, height - 80):addTo(self.mBg)
  local nameLabel = DYLabelTTF.new({
    text = CloudData.UNION_INFO.name,
    size = 32,
    color = cc.c3b(255, 205, 51),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {}):pos(pName:getPositionX() + pName:getContentSize().width + 5, pName:getPositionY()):addTo(self.mBg)
  local lb = DYLabelTTF.new({
    text = DYLang.getString("S1702", ""),
    size = 20,
    color = cc.c3b(73, 43, 0),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):pos(nameLabel:getPositionX() + nameLabel:getContentSize().width + 55, nameLabel:getPositionY()):addTo(self.mBg)
  lb:setTouchEnabled(true)
  lb:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    local name, x, y = event.name, event.x, event.y
    if name == "began" then
      lb.pointBegan = {x = x, y = y}
      return true
    elseif name == "ended" then
      local pointEnd = {x = x, y = y}
      if math.abs(lb.pointBegan.x - pointEnd.x) < 50 and math.abs(lb.pointBegan.y - pointEnd.y) < 50 then
        local params = {
          title = "union/title_disband.png",
          text = DYLang.getString("S1703", "")
        }
        LayerCommon.new(params, handler(self, self.disbandUnion)):addTo(self, 20)
      end
    end
  end)
  if CloudData.UNION_POS < 3 then
    lb:hide()
  end
  self:loadUnionLevel()
  self:loadMemberNum()
  local pLeader = display.newSprite("union/title_leader.png"):align(display.CENTER_LEFT, 96, height - 320):addTo(self.mBg)
  DYLabelTTF.new({
    text = CloudData.UNION_INFO.leader,
    size = 24,
    color = cc.c3b(73, 43, 0),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):pos(pLeader:getPositionX() + pLeader:getContentSize().width, pLeader:getPositionY() - 1):addTo(self.mBg)
  local pID = display.newSprite("union/label_id.png"):align(display.CENTER_LEFT, 96, height - 400):addTo(self.mBg)
  DYLabelTTF.new({
    text = CloudData.UNION_INFO.id,
    size = 24,
    color = display.COLOR_WHITE,
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {}):pos(pID:getPositionX() + pID:getContentSize().width + 5, pID:getPositionY() - 3):addTo(self.mBg)
  self:loadUnionNotice()
  self:loadFuncBtn()
end

function M:loadUnionLevel()
  local height = self.mBg:getContentSize().height * 0.92
  local pLevel = display.newSprite("union/label_level.png"):align(display.CENTER_LEFT, 96, height - 160):addTo(self.mBg)
  local lb = DYLabelTTF.new({
    text = "LV." .. CloudData.UNION_INFO.level,
    size = 22,
    color = cc.c3b(7, 255, 13),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {}):pos(pLevel:getPositionX() + pLevel:getContentSize().width + 3, pLevel:getPositionY()):addTo(self.mBg)
  local barBg = display.newSprite("union/bar_bg.png"):align(display.CENTER_LEFT, lb:getPositionX() + lb:getContentSize().width + 7, lb:getPositionY()):addTo(self.mBg)
  local currExp = CloudData.UNION_INFO.exp
  local needExp = CloudData.UNION_INFO.upgrade_exp
  local expLabel = DYLabelTTF.new({
    text = currExp .. "/" .. needExp,
    size = 20,
    color = display.COLOR_WHITE,
    font = GameManager.FONTNAME_TTF
  }, {}):pos(barBg:getContentSize().width * 0.5, barBg:getContentSize().height * 0.5):addTo(barBg, 1)
  local proTimer = cc.ProgressTimer:create(display.newSprite("union/bar_pro.png")):addTo(barBg)
  proTimer:setType(cc.PROGRESS_TIMER_TYPE_BAR)
  proTimer:setPosition(barBg:getContentSize().width * 0.5, barBg:getContentSize().height * 0.5)
  proTimer:setMidpoint(cc.p(0, 0))
  proTimer:setBarChangeRate(cc.p(1, 0))
  proTimer:setPercentage(currExp / needExp * 100)
  if CloudData.UNION_INFO.level >= UNION_MAX_LEVEL then
    expLabel:setString("max")
    proTimer:setPercentage(100)
  end
end

function M:loadMemberNum()
  local height = self.mBg:getContentSize().height * 0.92
  local pNum = display.newSprite("union/label_num.png"):align(display.CENTER_LEFT, 96, height - 240):addTo(self.mBg)
  local lb = DYLabelTTF.new({
    text = CloudData.UNION_INFO.cur_count .. "/" .. CloudData.UNION_INFO.max_count,
    size = 24,
    color = cc.c3b(7, 255, 13),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {}):pos(pNum:getPositionX() + pNum:getContentSize().width + 5, pNum:getPositionY()):addTo(self.mBg)
  self.mMemberLabel = lb
  if CloudData.UNION_INFO.cur_count < MIN_MEMBER_NUM then
    local sp = display.newSprite("common_ui/alert.png"):align(display.CENTER_LEFT, lb:getPositionX() + lb:getContentSize().width + 20, pNum:getPositionY()):addTo(self.mBg)
    DYLabelTTF.new({
      text = DYLang.getString("S1704", ""),
      size = 18,
      color = cc.c3b(73, 43, 0),
      font = GameManager.FONTNAME_TTF,
      dyalign = "CENTER_LEFT"
    }):pos(sp:getPositionX() + sp:getContentSize().width, pNum:getPositionY()):addTo(self.mBg)
  end
end

function M:loadUnionNotice()
  local frame = display.newScale9Sprite("union/common_frame.png", 800, 248, cc.size(370, 158), cc.rect(40, 40, 1, 1)):addTo(self.mBg)
  display.newSprite("union/title6.png", 185, 185):addTo(frame)
  local params = {
    text = CloudData.UNION_INFO.bulletin,
    size = 20,
    font = GameManager.FONTNAME_TTF,
    lineWidth = 342
  }
  local newStr = DataUtils.getNewStrWithAlign(params)
  self.mNoticeLabel = DYLabelTTF.new({
    text = newStr,
    size = 20,
    color = display.COLOR_WHITE,
    font = GameManager.FONTNAME_TTF,
    dyalign = "TOP_LEFT"
  }, {}):pos(10, 150):addTo(frame)
end

function M:loadFuncBtn()
  local btn1 = cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal.png",
    pressed = "common_ui/btn_pressed.png",
    disabled = "common_ui/btn_disabled.png"
  }):scale(0.9):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S1705", ""),
    size = 27,
    color = cc.c3b(247, 221, 156),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(67, 33, 2)
  })):setButtonLabel("disabled", DYLabelTTF.new({
    text = DYLang.getString("S1705", ""),
    size = 27,
    color = cc.c3b(201, 201, 201),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(47, 47, 47)
  })):onButtonClicked(function()
    DDLOG("======== \229\174\161\230\160\184\231\148\179\232\175\183")
    
    local function tFuncListener()
      self:checkNewMark()
      self.mMemberLabel:setString(CloudData.UNION_INFO.cur_count .. "/" .. CloudData.UNION_INFO.max_count)
    end
    
    LayerMemberApply.new({
      list = CloudData.UNION_APPLY_LIST
    }, tFuncListener):addTo(self, 20)
  end):align(display.CENTER, self.mBg:getContentSize().width * 0.25, self.mBg:getContentSize().height * 0.18):addTo(self.mBg)
  self.mApplyBtn = btn1
  local btn2 = cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal.png",
    pressed = "common_ui/btn_pressed.png",
    disabled = "common_ui/btn_disabled.png"
  }):scale(0.9):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S1707", ""),
    size = 27,
    color = cc.c3b(247, 221, 156),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(67, 33, 2)
  })):setButtonLabel("disabled", DYLabelTTF.new({
    text = DYLang.getString("S1707", ""),
    size = 27,
    color = cc.c3b(201, 201, 201),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(47, 47, 47)
  })):onButtonClicked(function()
    DDLOG("======== \228\191\174\230\148\185\229\174\151\230\151\168")
    
    local function onEventModifyNotice(params)
      CloudData.UNION_INFO.bulletin = params.content
      local params = {
        text = CloudData.UNION_INFO.bulletin,
        size = 20,
        font = GameManager.FONTNAME_TTF,
        lineWidth = 342
      }
      local newStr = DataUtils.getNewStrWithAlign(params)
      self.mNoticeLabel:setString(newStr)
    end
    
    LayerCommon.new({
      type = 3,
      title = "union/title_notice.png"
    }, onEventModifyNotice):addTo(self, 20)
  end):align(display.CENTER, self.mBg:getContentSize().width * 0.75, self.mBg:getContentSize().height * 0.18):addTo(self.mBg)
  if 1 < CloudData.UNION_POS then
    btn1:setButtonEnabled(true)
    btn2:setButtonEnabled(true)
    self.mApplyBtn.redPoint = display.newSprite("common_ui/red_point.png", 70, 15):hide():addTo(self.mApplyBtn)
    self:checkNewMark()
  else
    btn1:setButtonEnabled(false)
    btn2:setButtonEnabled(false)
  end
end

function M:disbandUnion()
  local function tFuncEvent(param)
    if 0 == param.ret_code then
      CloudData.UNION_ID = -1
      
      CloudData.UNION_BOSS_LEVEL = {}
      display.replaceScene(require("app.scenes.ChapterScene").new(), "fade", 0.2)
    else
      local errMsg = param.err_msg or "UNKNOWN"
      WSToast.new(errMsg):addTo(self, 20)
    end
  end
  
  self:safeSocketRequest("CMD_DISBAND_UNION", nil, tFuncEvent)
end

function M:checkNewMark()
  if #CloudData.UNION_APPLY_LIST > 0 then
    self.mApplyBtn.redPoint:show()
  else
    self.mApplyBtn.redPoint:hide()
  end
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
  DYKeypadMgr.unregKeyHandler(self.mKeypadListener)
end

return M
