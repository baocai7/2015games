local LayerItem = require("app.layers.LayerItem")
local LayerSummonReward = require("app.layers.LayerSummonReward")
local LayerRule = require("app.layers.LayerRule")
local RichLabel = require("app.utils.RichLabel")
local M = {}
M = class("LayerRedPacket", function()
  return display.newLayer()
end)
local FONT_COLOR = {
  [1] = cc.c3b(73, 43, 0),
  [2] = cc.c3b(76, 234, 60),
  [3] = cc.c3b(52, 85, 255),
  [4] = cc.c3b(171, 29, 169),
  [5] = cc.c3b(255, 217, 66)
}
local TYPE_LIST = {
  [1] = "ACT_NEW_YEAR",
  [3] = "ACT_DUAN_WU"
}
local ACT_TYPE = TYPE_LIST[CloudData.FESTIVAL_ACT_TYPE]
local TEXT_LIST

function M:ctor(handler_)
  self.mCallback = handler_
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  self.mNode = display.newNode():pos(display.cx, display.cy):addTo(self, 1)
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  self:initActivity()
  self:initData()
  self.mKeypadListener = handler(self, self.onKeypad)
  self:setNodeEventEnabled(true)
end

local function getMsgContent(info)
  local textArr = {}
  local text1 = {
    text = info.nick,
    size = 21,
    color = cc.c3b(0, 60, 255),
    font = GameManager.FONTNAME_TTF
  }
  local text2 = {
    text = TEXT_LIST[info.times],
    size = 21,
    color = cc.c3b(73, 43, 0),
    font = GameManager.FONTNAME_TTF
  }
  table.insert(textArr, text1)
  table.insert(textArr, text2)
  for i = 1, #info.things do
    local itemId = info.things[i]
    local itemNum = info.counts[i]
    local itemModel = DataUtils.getItemModelWithColor(itemId)
    local itemName = itemModel.name
    local nameColor = itemModel.color
    local str1 = itemName
    local str2 = "*" .. itemNum .. ","
    if i == #info.things then
      str2 = "*" .. itemNum .. ";"
    end
    local text1 = {
      text = str1,
      size = 21,
      color = nameColor,
      font = GameManager.FONTNAME_TTF
    }
    local text2 = {
      text = str2,
      size = 21,
      color = cc.c3b(76, 234, 60),
      font = GameManager.FONTNAME_TTF
    }
    table.insert(textArr, text1)
    table.insert(textArr, text2)
  end
  local pNode = RichLabel.new({
    textArr = textArr,
    rowHeight = 28,
    maxWidth = 410
  })
  local width, height = pNode:getContentSize().width, pNode:getContentSize().height + 5
  return pNode, width, height
end

function M:initActivity()
  local tFunc = {
    ACT_NEW_YEAR = function()
      self.mFileName = "new_year/ui_red_packet"
      self.mBtnText = {
        DYLang.getString("S34", ""),
        DYLang.getString("S35", "")
      }
      self.mBgImg = "new_year/bg_newyear.png"
      TEXT_LIST = {
        [1] = DYLang.getString("S29", ""),
        [5] = DYLang.getString("S30", "")
      }
    end,
    ACT_DUAN_WU = function()
      self.mFileName = "new_year/ui_zongzi"
      self.mBtnText = {
        DYLang.getString("S36", ""),
        DYLang.getString("S37", "")
      }
      self.mBgImg = "new_year/bg_duanwu.png"
      TEXT_LIST = {
        [1] = DYLang.getString("S31", ""),
        [5] = DYLang.getString("S32", "")
      }
    end
  }
  tFunc[ACT_TYPE]()
end

function M:initData()
  DYRes.loadSheet(string.format("%s.plist", self.mFileName))
  
  local function tFuncListener(jsonTable)
    self.mPacketNum = jsonTable.data.count
    CloudData.RED_PACKET_POOL = jsonTable.data.rewardList
    self.mMsgList = jsonTable.data.list or {}
    self.mMsgIdx = #self.mMsgList
    self.mMsgHeight = 0
    if self.initUI then
      self:initUI()
    end
  end
  
  DYHttpMgr.initRedPacket(tFuncListener)
end

function M:initUI()
  local bg = display.newSprite(self.mBgImg):addTo(self.mNode)
  self.mBg = bg
  display.newSprite("#title1.png"):pos(bg:getContentSize().width * 0.5, bg:getContentSize().height * 0.94):addTo(bg)
  display.newSprite("#tip.png"):pos(bg:getContentSize().width * 0.3, bg:getContentSize().height * 0.8):addTo(bg)
  self:loadMessageList()
  self:loadPacketInfo()
  display.newSprite("#tang.png"):pos(bg:getContentSize().width * 0.94, bg:getContentSize().height * 0.3):addTo(bg)
  LayerRule.newRuleIcon(LayerRule.REDPACKET):align(display.CENTER, self.mBg:getContentSize().width * 0.07, self.mBg:getContentSize().height * 0.87):addTo(self.mBg, 2)
  cc.ui.UIPushButton.new({
    normal = "common_ui/close_normal.png",
    pressed = "common_ui/close_pressed.png"
  }):onButtonClicked(function()
    self:closeCallBack()
  end):align(display.CENTER, self.mBg:getContentSize().width * 0.96, self.mBg:getContentSize().height * 0.92):addTo(self.mBg, 2)
end

function M:loadMessageList()
  local frame = display.newScale9Sprite("#frame.png", 0, 0, cc.size(426, 426), cc.rect(40, 40, 1, 1)):pos(self.mBg:getContentSize().width * 0.3, self.mBg:getContentSize().height * 0.45):addTo(self.mBg)
  local listView = cc.ui.UIListView.new({
    viewRect = cc.rect(8, 8, 410, 410),
    direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
  }):addTo(frame)
  self.mListView = listView
  for i = #self.mMsgList, 1, -1 do
    local msgInfo = self.mMsgList[i]
    local item = listView:newItem()
    local content, width, height = getMsgContent(msgInfo)
    item:addContent(content)
    item:setItemSize(width, height)
    listView:addItem(item)
    self.mMsgHeight = self.mMsgHeight + height
  end
  listView:reload()
  if 410 < self.mMsgHeight then
    local moveByParams = {
      x = 0,
      y = self.mMsgHeight - 410,
      time = 0.2
    }
    for k, v in pairs(listView.items_) do
      transition.moveBy(v, moveByParams)
    end
  end
end

function M:loadPacketInfo()
  local numFrame = display.newSprite("#lb_packet.png"):pos(self.mBg:getContentSize().width * 0.58, self:getContentSize().height * 0.71):addTo(self.mBg)
  self.mNumLabel = DYLabelTTF.new({
    text = self.mPacketNum,
    size = 22,
    color = display.COLOR_WHITE,
    font = GameManager.FONTNAME_TTF
  }, {}):pos(numFrame:getContentSize().width * 0.62, numFrame:getContentSize().height * 0.52):addTo(numFrame)
  display.newSprite("new_year/light_packet.png"):pos(self.mBg:getContentSize().width * 0.72, self:getContentSize().height * 0.5):addTo(self.mBg)
  self.mPacketPic = display.newSprite("#packet2.png"):pos(self.mBg:getContentSize().width * 0.72, self:getContentSize().height * 0.5):addTo(self.mBg, 1)
  if self.mPacketNum > 0 then
    self.mPacketPic:setSpriteFrame("packet1.png")
  end
  cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png"
  }):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S33", ""),
    size = 26,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(25, 30, 3)
  })):onButtonClicked(function()
    self:buttonListener(2)
  end):align(display.CENTER, self.mBg:getContentSize().width * 0.82, self.mBg:getContentSize().height * 0.74):addTo(self.mBg)
  cc.ui.UIPushButton.new({normal = "#btn1.png", pressed = "#btn2.png"}):setButtonLabel("normal", DYLabelTTF.new({
    text = self.mBtnText[1],
    size = 30,
    color = cc.c3b(247, 221, 156),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(67, 33, 2)
  })):onButtonClicked(function()
    self:buttonListener(3)
  end):align(display.CENTER, self.mBg:getContentSize().width * 0.62, self.mBg:getContentSize().height * 0.24):addTo(self.mBg)
  cc.ui.UIPushButton.new({normal = "#btn1.png", pressed = "#btn2.png"}):setButtonLabel("normal", DYLabelTTF.new({
    text = self.mBtnText[2],
    size = 30,
    color = cc.c3b(247, 221, 156),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(67, 33, 2)
  })):onButtonClicked(function()
    self:buttonListener(4)
  end):align(display.CENTER, self.mBg:getContentSize().width * 0.81, self.mBg:getContentSize().height * 0.24):addTo(self.mBg)
end

function M:addMsgItem(info)
  if not info or info.nick == nil then
    return
  end
  self.mMsgIdx = self.mMsgIdx + 1
  local idx = self.mMsgIdx
  local listView = self.mListView
  local item = listView:newItem()
  local content, width, height = getMsgContent(info)
  item:addContent(content)
  item:setItemSize(width, height)
  listView:addItem(item)
  if 1 < idx then
    local posY = listView.items_[idx - 1]:getPositionY()
    item:setPosition(9, posY - height)
  else
    listView:reload()
  end
  if 7 < idx then
    local moveByParams = {
      x = 0,
      y = height,
      time = 0.2
    }
    for k, v in pairs(listView.items_) do
      transition.moveBy(v, moveByParams)
    end
  end
end

function M:updatePacketNum()
  self.mNumLabel:setString(self.mPacketNum)
  if self.mPacketNum <= 0 then
    self.mPacketPic:setSpriteFrame("packet2.png")
  end
end

function M:openPacket(pType)
  local function tFuncListener(jsonTable)
    local errorCode = jsonTable.errorCode
    
    if 0 < errorCode then
      local errorMsg = jsonTable.errorMsg or "UNKNOWN"
      WSToast.new(errorMsg):addTo(self, 20)
      return
    end
    local packetData = jsonTable.data
    local rewardList = {}
    self.mPacketNum = packetData.count
    if 1 == pType then
      for k, v in pairs(packetData.dropGain) do
        local t = {
          id = tonumber(k),
          num = tonumber(v)
        }
        table.insert(rewardList, t)
      end
    elseif 2 == pType then
      for k, v in pairs(packetData.dropGain) do
        table.insert(rewardList, v)
      end
    end
    local msgList = packetData.showList
    
    local function tCallback()
      for k, v in pairs(packetData.drop) do
        DataUtils.updateItemNum(tonumber(k), v)
      end
    end
    
    local params = {rewardList = rewardList, msgList = msgList}
    self:loadOpenUI(params, tCallback)
  end
  
  if 1 == pType then
    DYHttpMgr.openSingle(tFuncListener)
  else
    DYHttpMgr.openMutiple(tFuncListener)
  end
end

function M:loadOpenUI(params, callback)
  local rewardList = params.rewardList
  local pLayer = display.newColorLayer(cc.c4b(0, 0, 0, 120)):addTo(display.getRunningScene(), 50)
  local bg = display.newSprite("summon_scene/alert_frame.png"):scale(0):pos(display.cx, display.cy):addTo(display.getRunningScene(), 51)
  bg:runAction(transition.sequence({
    cc.ScaleTo:create(0.2, 1.1),
    cc.ScaleTo:create(0.1, 1)
  }))
  local btn = cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png"
  }):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S38", ""),
    size = 30,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(25, 30, 3)
  })):align(display.CENTER, bg:getContentSize().width * 0.5, -bg:getContentSize().height * 0.2):onButtonClicked(function()
    local popupLayer = transition.sequence({
      cc.ScaleTo:create(0, 1),
      cc.ScaleTo:create(0.1, 1.1),
      cc.ScaleTo:create(0.2, 0),
      cc.CallFunc:create(function()
        bg:removeSelf()
        pLayer:removeSelf()
        if callback then
          callback()
        end
        self:addMsgItem(params.msgList)
        self:updatePacketNum()
      end)
    })
    bg:runAction(popupLayer)
  end):hide():addTo(bg)
  local count = #rewardList
  local posX, posY = 0, 0
  if 5 < count then
    posX, posY = bg:getContentSize().width * 0.2, bg:getContentSize().height * 0.78
  else
    posX, posY = bg:getContentSize().width * (0.5 - (count - 1) * 0.075), bg:getContentSize().height * 0.55
  end
  self:performWithDelay(function()
    btn:show()
  end, 0.3 + 0.2 * count)
  for i = 1, count do
    local itemId = rewardList[i].id
    local itemNum = rewardList[i].num
    local itemModel = DataUtils.getItemModelWithColor(itemId)
    local itemName = itemModel.name
    local itemIcon = itemModel.icon
    local nameColor = itemModel.color
    local itemQuality = itemModel.quality
    local iconFrame = display.newSprite(string.format("common_ui/frame%d.png", itemQuality)):align(display.CENTER, bg:getContentSize().width * 0.5, bg:getContentSize().height * 1.3):scale(0):addTo(bg)
    local pLayer
    iconFrame:setTouchEnabled(true)
    iconFrame:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
      local name, x, y = event.name, event.x, event.y
      if name == "began" then
        if not pLayer then
          pLayer = LayerItem.new(LayerItem.TYPE_TIP, itemId):pos(iconFrame:getPositionX(), iconFrame:getPositionY()):addTo(bg, 20)
        end
        return true
      elseif name == "moved" then
        pLayer:show()
      elseif name == "ended" then
        pLayer:removeSelf()
        pLayer = nil
      end
    end)
    local icon = display.newSprite(itemIcon, iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.5):addTo(iconFrame)
    local name = cc.ui.UILabel.new({
      UILabelType = 2,
      text = itemName,
      size = 24,
      color = nameColor,
      font = GameManager.FONTNAME_TTF
    }):align(display.CENTER, iconFrame:getContentSize().width * 0.5, -iconFrame:getContentSize().height * 0.25):addTo(iconFrame)
    cc.ui.UILabel.new({
      UILabelType = 1,
      text = string.format("*%d", itemNum),
      font = "fonts/whiteNum.fnt"
    }):align(display.CENTER_RIGHT, iconFrame:getContentSize().width * 0.95, iconFrame:getContentSize().height * 0.15):scale(0.5):addTo(iconFrame, 2)
    local movetoPoint
    if i < 6 then
      movetoPoint = cc.p(posX + bg:getContentSize().width * 0.15 * (i - 1), posY)
    else
      movetoPoint = cc.p(posX + bg:getContentSize().width * 0.15 * (i - 6), bg:getContentSize().height * 0.32)
    end
    local spawn = cc.Spawn:create(cc.ScaleTo:create(0.1, 1), cc.MoveTo:create(0.1, movetoPoint))
    iconFrame:runAction(transition.sequence({
      cc.DelayTime:create(0.3 + 0.15 * i),
      cc.CallFunc:create(function()
        DYSoundMgr.playEffect(DY_SND.sfx_cimelia_get)
      end),
      spawn
    }))
  end
end

function M:buttonListener(tag)
  DDLOG("tag : %d", tag)
  local tFunc = {
    [1] = function()
      DDLOG("======= \232\175\166\230\131\133")
    end,
    [2] = function()
      DDLOG("======= \229\165\150\229\138\177\233\162\132\232\167\136")
      LayerSummonReward.new(LayerSummonReward.RED_PACKET):addTo(self, 10)
    end,
    [3] = function()
      DDLOG("======= \229\141\149\229\188\128")
      self:openPacket(1)
    end,
    [4] = function()
      DDLOG("======= \228\186\148\232\191\158\229\188\128")
      self:openPacket(2)
    end
  }
  tFunc[tag]()
end

function M:closeCallBack()
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  CloudData.RED_PACKET_INFO = self.mPacketNum
  if self.mCallback then
    self.mCallback()
  end
  self:removeSelf()
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
  DYRes.unloadSheet(string.format("%s.plist", self.mFileName))
  DYKeypadMgr.unregKeyHandler(self.mKeypadListener)
end

return M
