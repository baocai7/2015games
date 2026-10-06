local PanelContriRecord = require("app.union.panel.PanelContriRecord")
local CLASS_NAME = "LayerContriRecord"
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
  self.mKeypadListener = handler(self, self.onKeypad)
  self:setNodeEventEnabled(true)
end

function M:initUI()
  local bg = display.newScale9Sprite("ranking/bg_team.png", 0, -20, cc.size(1020, 640), cc.rect(150, 105, 1, 1)):addTo(self.mEmptyNode)
  self.mBg = bg
  cc.ui.UIPushButton.new({
    normal = "common_ui/close_normal.png",
    pressed = "common_ui/close_pressed.png"
  }):onButtonClicked(function()
    self:closeCallBack()
  end):align(display.CENTER, bg:getContentSize().width * 0.97, bg:getContentSize().height * 0.97):addTo(bg, 2)
  local memberList = CloudData.UNION_INFO.construct_record
  local listView = cc.ui.UIListView.new({
    async = true,
    viewRect = cc.rect(70, 56, 880, 528),
    direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
  }):addTo(bg)
  
  local function tFuncDelegate(listView, tag, idx)
    if cc.ui.UIListView.COUNT_TAG == tag then
      return #memberList
    else
      if cc.ui.UIListView.CELL_TAG == tag then
        local item = listView:dequeueItem()
        local content
        if not item then
          item = listView:newItem()
        else
          content = item:getContent()
          content:removeFromParent()
        end
        content = PanelContriRecord.new(memberList[idx])
        item:addContent(content)
        item:setItemSize(875, 175)
        return item
      else
      end
    end
  end
  
  listView:setDelegate(tFuncDelegate)
  listView:reload()
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
  DDLOG(CLASS_NAME .. ": onEnter")
  DYKeypadMgr.regKeyHandler(self.mKeypadListener)
end

function M:onExit()
  DDLOG(CLASS_NAME .. ": onExit")
  DYKeypadMgr.unregKeyHandler(self.mKeypadListener)
end

return M
