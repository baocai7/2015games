local PanelMemberApply = require("app.union.panel.PanelMemberApply")
local CLASS_NAME = "LayerMemberApply"
local M = {}
M = class(CLASS_NAME, function()
  return display.newLayer()
end)

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
  local bg = display.newScale9Sprite("common_ui/common_dialog.png", 0, -30, cc.size(650, 662), cc.rect(200, 200, 2, 2)):addTo(self.mEmptyNode)
  self.mBg = bg
  local titleFrame = display.newSprite("common_ui/title_frame.png"):pos(bg:getContentSize().width * 0.5, bg:getContentSize().height - 5):addTo(bg)
  display.newSprite("union/title_apply.png"):pos(titleFrame:getContentSize().width * 0.5, titleFrame:getContentSize().height * 0.55):addTo(titleFrame)
  cc.ui.UIPushButton.new({
    normal = "common_ui/close_normal.png",
    pressed = "common_ui/close_pressed.png"
  }):scale(0.9):onButtonClicked(function()
    self:closeCallBack()
  end):align(display.CENTER, bg:getContentSize().width * 0.95, bg:getContentSize().height * 0.95):addTo(bg, 2)
end

function M:initData(params)
  self.mApplyList = params.list
  self.mItemArr = {}
  self:loadApplyList()
end

function M:loadApplyList()
  local listFrame = display.newScale9Sprite("union/common_frame.png", 0, 0, cc.size(580, 565), cc.rect(40, 40, 1, 1)):pos(self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.5):addTo(self.mBg)
  local listView = cc.ui.UIListView.new({
    viewRect = cc.rect(5, 5, 570, 555),
    direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
  }):addTo(listFrame)
  self.mListView = listView
  self:reloadList()
end

function M:reloadList()
  self.mItemArr = {}
  self.mListView:removeAllItems()
  for i = 1, #self.mApplyList do
    local item = self.mListView:newItem()
    local info = self.mApplyList[i]
    local params = {index = i, info = info}
    local content = PanelMemberApply.new(params, handler(self, self.onEventDealApply))
    item:addContent(content)
    item:setItemSize(555, 140)
    self.mListView:addItem(item)
    table.insert(self.mItemArr, item)
  end
  self.mListView:reload()
end

function M:onEventDealApply(params)
  local function tFuncEvent(param)
    DDLOG(" ================ GET_DEAL_APPLY !!!!!!!")
    
    dump(param, "event \239\188\154", 5)
    if 0 == param.ret_code then
      if params.is_passed then
        DDLOG("===== PASS")
        params.info.rank = 1
        table.insert(CloudData.UNION_MEMBERS, params.info)
        CloudData.UNION_INFO.cur_count = CloudData.UNION_INFO.cur_count + 1
      else
        DDLOG("===== NOT PASS")
      end
      local info = self.mApplyList[params.index]
      table.removebyvalue(self.mApplyList, info)
      self:reloadList()
    else
      DDLOG(" ================ \229\164\132\231\144\134\229\164\177\232\180\165 !!!!!!!")
      local errMsg = param.err_msg or "UNKNOWN"
      WSToast.new(errMsg):addTo(self, 20)
    end
  end
  
  self:safeSocketRequest("CMD_DEAL_APPLY", {
    is_passed = params.is_passed,
    target_id = params.info.uid
  }, tFuncEvent)
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
