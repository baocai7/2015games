local CLASS_NAME = "SceneWiki"
local M = {}
M = class(CLASS_NAME, function()
  return display.newLayer(CLASS_NAME)
end)
local STATE_ALL = 0
local STATE_BUDDHA = 1
local STATE_MONSTER = 2
local S_COL_NUM = 4

function M:ctor(cb)
  DDLOG(CLASS_NAME .. ": onCreate")
  self.mCallback = cb
  self.mKeypadListener = handler(self, self.onKeypad)
  self.mAllModel = {}
  self.mBuddhaModel = {}
  self.mMonsterModel = {}
  self.mContent = nil
  self.mBuddhaIcon = nil
  self.mMonsterIcon = nil
  self.mBtnAll = nil
  self.mBtnBuddha = nil
  self.mBtnMonster = nil
  self.mListView = nil
  self.mAmature = nil
  self.mState = STATE_ALL
  self.mSelectIdx = nil
  self.mLabelCollect = nil
  self.mFileInfo = {}
  self.mCoreNode = display.newNode():pos(display.cx, display.cy):addTo(self)
  self:layoutUI()
  self:setNodeEventEnabled(true)
end

function M:onKeypad(keyCode, event)
  DDLOG("Key %d was on pressed!", keyCode)
  if keyCode == cc.KeyCode.KEY_ESCAPE then
    self:hide()
  end
  return true
end

function M:onEnter()
  DDLOG(CLASS_NAME .. ": onEnter")
  DYKeypadMgr.regKeyHandler(self.mKeypadListener)
end

function M:onExit()
  DDLOG(CLASS_NAME .. ": onExit")
  DYKeypadMgr.unregKeyHandler(self.mKeypadListener)
  DYRes.unloadFileInfo(self.mFileInfo)
  self.mFileInfo = {}
  display.removeUnusedSpriteFrames()
end

function M:layoutUI()
  self:initData()
  self:addBg()
  self:addContent()
end

function M:initData()
  self.mAllModel = DataUtils.getBuddhaIdsTableWikiScene()
  for i = 1, #self.mAllModel do
    local model = self.mAllModel[i]
    if tonumber(model.isRebel) == 1 and tonumber(model.modelId) ~= 103601 then
      table.insert(self.mBuddhaModel, model)
    else
      table.insert(self.mMonsterModel, model)
    end
  end
  self.mContent = {}
  self.mBuddhaIcon = {}
  self.mMonsterIcon = {}
  DDLOG("Init Buddha Info")
end

function M:addBg()
  local node = self.mCoreNode
end

function M:addContent()
  local node = self.mCoreNode
  local button = cc.ui.UIPushButton.new({
    normal = "common_ui/close_normal.png",
    pressed = "common_ui/close_pressed.png"
  })
  button:setPosition(dy.p(490, 320))
  button:onButtonClicked(handler(self, self.hide))
  node:addChild(button, 15)
  self.mBtnBack = button
  local wikiFrame = display.newSprite("wiki/bg.png", 0, 0):addTo(node, 1)
  local button = cc.ui.UIPushButton.new({
    normal = "wiki/btn_buddha_n.png",
    disabled = "wiki/btn_buddha_s.png"
  }):pos(750, 572):onButtonClicked(function()
    self:loadBuddhaToView()
  end):addTo(wikiFrame, 1)
  button:setAnchorPoint(cc.p(0.5, 0))
  self.mBtnBuddha = button
  local button = cc.ui.UIPushButton.new({
    normal = "wiki/btn_monster_n.png",
    disabled = "wiki/btn_monster_s.png"
  }):pos(900, 572):onButtonClicked(function()
    self:loadMonsterToView()
  end):addTo(wikiFrame, 1)
  button:setAnchorPoint(cc.p(0.5, 0))
  self.mBtnMonster = button
  local button = cc.ui.UIPushButton.new({
    normal = "wiki/btn_all_n.png",
    disabled = "wiki/btn_all_s.png"
  }):pos(600, 572):onButtonClicked(function()
    self:loadAllToView()
  end):addTo(wikiFrame, 1)
  button:setAnchorPoint(cc.p(0.5, 0))
  self.mBtnAll = button
  local label = DYLabelTTF.new({
    text = "",
    dyalign = "CENTER_LEFT",
    size = 30,
    color = cc.c3b(15, 255, 9),
    font = GameManager.FONTNAME_TTF
  }, {lineWidth = 1.5}):pos(658, 650):addTo(wikiFrame, 1)
  self.mLabelCollect = label
  local listView = cc.ui.UIListView.new({
    viewRect = cc.rect(510, 70, 490, 490),
    direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
  }):onTouch(handler(self, self.touchListener)):addTo(wikiFrame, 1)
  self.mListView = listView
  self:loadAllToView()
end

function M:loadBuddhaToView()
  self.mBtnBuddha:setButtonEnabled(false)
  self.mBtnMonster:setButtonEnabled(true)
  self.mBtnAll:setButtonEnabled(true)
  self.mState = STATE_BUDDHA
  self.mSelectedIdx = nil
  self:reloadModelData(self.mBuddhaModel)
end

function M:loadMonsterToView()
  self.mBtnBuddha:setButtonEnabled(true)
  self.mBtnMonster:setButtonEnabled(false)
  self.mBtnAll:setButtonEnabled(true)
  self.mState = STATE_MONSTER
  self.mSelectedIdx = nil
  self:reloadModelData(self.mMonsterModel)
end

function M:loadAllToView()
  self.mBtnBuddha:setButtonEnabled(true)
  self.mBtnMonster:setButtonEnabled(true)
  self.mBtnAll:setButtonEnabled(false)
  self.mState = STATE_ALL
  self.mSelectedIdx = nil
  self:reloadModelData(self.mAllModel)
end

function M:reloadModelData(models)
  DDLOG("loadBuddhaToView")
  self.mListView:removeAllItems()
  self.mBuddhaIcon = {}
  local row = math.ceil(#models / S_COL_NUM)
  local column = #models % S_COL_NUM
  local endNum = S_COL_NUM
  if column == 0 then
    row = row + 1
  end
  local nCollect = 0
  local nAll = #models
  local firstBuddha
  for i = 1, row do
    local item = self.mListView:newItem()
    local content = display.newNode()
    if i == row then
      endNum = column
    end
    for count = 1, endNum do
      local idx = (i - 1) * S_COL_NUM + count
      local buddhaModel = models[idx]
      local px = (count - 1) * 120 + 60
      local py = 60
      local resFrame = ""
      local resIcon = ""
      local iconNode = display.newNode()
      if 1 <= buddhaModel.status then
        resFrame = string.format("common_ui/frame%d.png", buddhaModel.quality)
        resIcon = buddhaModel.npcIcon
        nCollect = nCollect + 1
        if not firstBuddha then
          firstBuddha = idx
        end
      else
        resFrame = "common_ui/frame_battle.png"
        resIcon = "wiki/q0.png"
      end
      local iconFrame = display.newSprite(resFrame):addTo(iconNode)
      display.newSprite(resIcon):addTo(iconNode)
      iconNode.sel = display.newSprite("common_ui/frame_selected.png"):addTo(iconNode)
      iconNode.sel:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.ScaleTo:create(0.3, 0.95), cc.ScaleTo:create(0.2, 1))))
      iconNode:setPosition(px, py)
      content:addChild(iconNode)
      iconNode.sel:setVisible(false)
      
      function iconNode:selectedInWiki(flag)
        iconNode.sel:setVisible(flag)
      end
      
      table.insert(self.mBuddhaIcon, iconNode)
    end
    content:setContentSize(480, 120)
    item:addContent(content)
    item:setItemSize(480, 120)
    self.mListView:addItem(item)
  end
  self.mListView:reload()
  self.mLabelCollect:setString(string.format(DYLang.getString("S1423", ""), nCollect, nAll))
end

function M:touchListener(event)
  if "clicked" == event.name then
    DDLOG(string.format("touchListener: clicked, (%d, %d)", event.point.x, event.point.y))
    if self.mSelectedIdx then
      self.mBuddhaIcon[self.mSelectedIdx]:selectedInWiki(false)
    end
    local column = math.ceil(event.point.x / 120)
    local idx = (event.itemPos - 1) * S_COL_NUM + column
    local tFuncChangeState = {
      [STATE_ALL] = function()
        if 0 <= idx and idx <= #self.mAllModel then
          self.mSelectedIdx = idx
          self:changeInfo(self.mAllModel[idx], true)
        end
      end,
      [STATE_BUDDHA] = function()
        if 0 <= idx and idx <= #self.mBuddhaModel then
          self.mSelectedIdx = idx
          self:changeInfo(self.mBuddhaModel[idx], true)
        end
      end,
      [STATE_MONSTER] = function()
        if 0 <= idx and idx <= #self.mMonsterModel then
          self.mSelectedIdx = idx
          self:changeInfo(self.mMonsterModel[idx], true)
        end
      end
    }
    tFuncChangeState[self.mState]()
  end
end

function M:changeInfo(buddhaModel, flag)
  if self.mSoundId then
    DYSoundMgr.stopEffect(self.mSoundId)
    self.mSoundId = nil
  end
  if buddhaModel.status > 0 then
    self.mSoundId = DYSoundMgr.playEffect(buddhaModel.buddhaSound)
  end
  DDLOG("changeInfo")
  local node = self.mCoreNode
  if self.mArmature then
    self.mArmature:runAction(cc.RemoveSelf:create())
    self.mArmature = nil
  end
  if self.mLabelName == nil then
    self.mLabelName = cc.ui.UILabel.new({
      UILabelType = 2,
      align = cc.ui.TEXT_ALIGN_CENTER,
      text = "",
      size = 30,
      color = cc.c3b(80, 50, 7),
      dimensions = cc.size(210, 36),
      font = GameManager.FONTNAME_TTF
    }):align(display.CENTER, -264, 270):addTo(node, 1)
  end
  if self.mLabelDesc == nil then
    self.mLabelDesc = cc.ui.UILabel.new({
      UILabelType = 2,
      text = "",
      align = cc.ui.TEXT_ALIGN_LEFT,
      size = 20,
      color = cc.c3b(100, 47, 5),
      dimensions = cc.size(360, 300),
      font = GameManager.FONTNAME_TTF
    }):align(display.LEFT_TOP, -435, -200):addTo(node, 1)
  end
  if self.mElementTip == nil then
    self.mElementTip = display.newSprite():align(display.LEFT_TOP, -460, 240):addTo(node, 1)
  end
  DYRes.unloadFileInfo(self.mFileInfo)
  self.mFileInfo = {}
  local fi = string.format("armature/%s/%s.csb", buddhaModel.armatureFile, buddhaModel.armatureFile)
  if cc.FileUtils:getInstance():isFileExist(fi) then
    DYRes.loadFileInfo(fi, self.mFileInfo)
    local armature = ccs.Armature:create(buddhaModel.armatureFile)
    armature:setPosition(-250, -120)
    armature:runAction(cc.MoveBy:create(0, cc.p(0, buddhaModel.upMove)))
    armature:setScale(buddhaModel.zoomMultiple)
    local seq = transition.sequence({
      cc.CallFunc:create(function()
        armature:getAnimation():playWithIndex(1)
      end),
      cc.DelayTime:create(3),
      cc.CallFunc:create(function()
        armature:getAnimation():playWithIndex(2)
      end),
      cc.DelayTime:create(buddhaModel.attackTime * 1.3)
    })
    armature:runAction(cc.RepeatForever:create(seq))
    node:addChild(armature, 1)
    self.mArmature = armature
  end
  if flag and buddhaModel.status ~= nil and buddhaModel.status >= 1 then
    self.mLabelDesc:setString(buddhaModel.npcDesc)
    self.mElementTip:show()
  else
    self.mLabelDesc:setString(DYLang.getString("S1426", ""))
    self.mArmature:setColor(cc.c3b(0, 0, 0))
    self.mElementTip:hide()
  end
  self.mLabelName:setString(buddhaModel.npcName)
  self.mElementTip:setTexture(string.format("equipment/element%d.png", buddhaModel.element))
  if self.mSelectedIdx ~= nil then
    self.mBuddhaIcon[self.mSelectedIdx]:selectedInWiki(true)
  end
end

function M:show()
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  local scene = cc.Director:getInstance():getRunningScene()
  scene:addChild(self, 20)
end

function M:hide()
  DYSoundMgr.stopEffect(self.mSoundId)
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  if self.mCallback then
    self.mCallback()
  end
  self:runAction(cc.RemoveSelf:create())
end

return M
