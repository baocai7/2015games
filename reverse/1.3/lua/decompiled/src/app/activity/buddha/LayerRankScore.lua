local DYClass = "LayerRankScore"
local M = {}
M = class(DYClass, function()
  return display.newLayer()
end)

function M:ctor(params)
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  self.mNode = display.newNode():pos(display.cx, display.cy):addTo(self, 1)
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  self:initData(params)
  self:initUI()
  self.mKeypadListener = handler(self, self.onKeypad)
  self:setNodeEventEnabled(true)
end

function M:initData(params)
  self.mRankData = params.list
  self.mPieceIcon = params.pieceData.itemIcon
end

function M:initUI()
  local bg = display.newScale9Sprite("gamescene/bg_pause.png", 0, 0, cc.size(687, 527), cc.rect(200, 100, 2, 2)):addTo(self.mNode)
  self.mBg = bg
  local titleFrame = display.newSprite("common_ui/title_frame.png"):pos(bg:getContentSize().width * 0.5, bg:getContentSize().height + 10):addTo(bg, 2)
  display.newSprite("ranking/title.png"):pos(titleFrame:getContentSize().width * 0.5, titleFrame:getContentSize().height * 0.52):addTo(titleFrame)
  display.newSprite("activity_buddha/rank.png"):pos(bg:getContentSize().width * 0.5, bg:getContentSize().height * 0.87):addTo(bg, 1)
  self:loadListView()
  cc.ui.UIPushButton.new({
    normal = "common_ui/close_normal.png",
    pressed = "common_ui/close_pressed.png"
  }):scale(0.8):onButtonClicked(function()
    self:closeCallBack()
  end):align(display.CENTER, bg:getContentSize().width * 0.96, bg:getContentSize().height * 0.97):addTo(bg, 2)
end

local function getRankPanel(rank, pieceIcon, data)
  local pNode = display.newNode()
  pNode:setAnchorPoint(0.5, 0.5)
  pNode:setContentSize(593, 50)
  if rank < 4 then
    display.newSprite("ranking/rank" .. rank .. ".png", 57, 28):scale(0.6):addTo(pNode)
  else
    DYLabelTTF.new({
      text = rank,
      size = 30,
      color = cc.c3b(87, 54, 11),
      font = GameManager.FONTNAME_TTF
    }):pos(57, 25):addTo(pNode)
  end
  DYLabelTTF.new({
    text = data.nick,
    size = 22,
    color = cc.c3b(87, 54, 11),
    font = GameManager.FONTNAME_TTF
  }):pos(208, 25):addTo(pNode)
  DYLabelTTF.new({
    text = data.score,
    size = 22,
    color = cc.c3b(87, 54, 11),
    font = GameManager.FONTNAME_TTF
  }):pos(375, 25):addTo(pNode)
  local frame = display.newSprite("common_ui/frame_battle.png", 515, 28):scale(0.4):addTo(pNode)
  display.newSprite(pieceIcon, frame:getContentSize().width * 0.5, frame:getContentSize().height * 0.5):addTo(frame)
  DYLabelTTF.new({
    text = "X" .. data.award,
    size = 36,
    color = cc.c3b(87, 54, 11),
    font = GameManager.FONTNAME_TTF,
    dyalign = "LEFT_BOTTOM"
  }):pos(frame:getContentSize().width, 0):addTo(frame)
  display.newSprite("activity_buddha/line_horizontal.png", 296, 1):addTo(pNode)
  return pNode
end

function M:loadListView()
  if 0 == #self.mRankData then
    return
  end
  self.mListView = cc.ui.UIListView.new({
    viewRect = cc.rect(47, 40, 593, 385),
    direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
  }):addTo(self.mBg)
  for i = 1, #self.mRankData do
    local item = self.mListView:newItem()
    local content = getRankPanel(i, self.mPieceIcon, self.mRankData[i])
    item:addContent(content)
    item:setItemSize(593, 60)
    self.mListView:addItem(item)
  end
  self.mListView:reload()
end

function M:touchListener(event)
  local lv = event.listView
  if "clicked" == event.name then
    print(event.itemPos)
  elseif "moved" == event.name then
  else
    if "ended" == event.name then
    else
    end
  end
end

function M:onKeypad(keyCode, event)
  DDLOG("Key %d was on pressed!", keyCode)
  if keyCode == cc.KeyCode.KEY_ESCAPE then
    self:closeCallBack()
    return true
  end
  return false
end

function M:closeCallBack()
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  self:removeSelf()
end

function M:onEnter()
  DDLOG(DYClass .. ": onEnter")
  DYKeypadMgr.regKeyHandler(self.mKeypadListener)
end

function M:onExit()
  DDLOG(DYClass .. ": onExit")
  DYKeypadMgr.unregKeyHandler(self.mKeypadListener)
end

return M
