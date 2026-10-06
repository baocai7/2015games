local CLASS_NAME = "LayerCommon"
local M = {}
M = class(CLASS_NAME, function()
  return display.newLayer()
end)
M.PROP_PREVIEW = 1
M.PROP_REPLACE = 2
M.GRADE_UP_ALERT = 3

local function M_filePath(name)
  return string.format("cimelia/%s.png", name)
end

function M:ctor(pType, params, callbcak)
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  self.mCallback = callbcak
  self.mType = pType or 1
  self.mParams = params
  self.mNode = display.newNode():pos(display.cx, display.cy):addTo(self, 1)
  self:initUI()
  self.mKeypadListener = handler(self, self.onKeypad)
  self:setNodeEventEnabled(true)
end

function M:initUI()
  local tFunc = {
    [1] = function()
      self:loadPropPreviewUI()
    end,
    [2] = function()
      self:loadPropReplaceUI()
    end,
    [3] = function()
      self:loadGradeUpAlertUI()
    end
  }
  tFunc[self.mType]()
end

local function getListContent(data)
  local node = display.newNode()
  node:setContentSize(460, 60)
  node:setAnchorPoint(0.5, 0.5)
  display.newSprite(M_filePath(string.format("img_slot_%d", data.quality))):scale(0.6):align(display.CENTER_LEFT, 25, 30):addTo(node)
  local textStr = CMgr.PROPERTIES[data.propId] .. "\229\162\158\229\138\160" .. data.propStr
  DYLabelTTF.new({
    text = textStr,
    size = 24,
    color = cc.c3b(80, 30, 0),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }):pos(100, 30):addTo(node)
  return node
end

function M:loadPropPreviewUI()
  local propData1 = DataUtils.getCimeliaRecastPropPool(1, self.mParams.tag, self.mParams.attackType)
  local propData2 = DataUtils.getCimeliaRecastPropPool(2, self.mParams.tag, self.mParams.attackType)
  local propData3 = DataUtils.getCimeliaRecastPropPool(3, self.mParams.tag, self.mParams.attackType)
  table.insertto(propData1, propData2)
  table.insertto(propData1, propData3)
  local bg = display.newSprite(M_filePath("img_property_bottom")):addTo(self.mNode)
  local frame = display.newScale9Sprite(M_filePath("img_bottom_01"), 286, 345, cc.size(470, 540), cc.rect(40, 40, 1, 1)):addTo(bg)
  if 0 == #propData1 then
    return
  end
  local listView = DYListView.new({
    viewRect = cc.rect(5, 5, 460, 530),
    direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
  }):addTo(frame)
  for i = 1, #propData1 do
    local item = listView:newItem()
    local content = getListContent(propData1[i])
    content:setPosition(230, 30)
    item:addContent(content)
    item:setItemSize(460, 60)
    listView:addItem(item)
  end
  listView:reload()
  cc.ui.UIPushButton.new({
    normal = "common_ui/close_normal.png",
    pressed = "common_ui/close_pressed.png"
  }):align(display.CENTER, bg:getContentSize().width * 0.96, bg:getContentSize().height * 0.94):onButtonClicked(function()
    self:closeCallback()
  end):addTo(bg)
end

function M:loadPropReplaceUI()
  local bg = display.newSprite("common_ui/common_dialog.png"):addTo(self.mNode)
  local curData = self.mParams.curData
  local newData = self.mParams.newData
  local frame1 = display.newSprite(M_filePath("img_pop"), 160, 240):addTo(bg)
  local frame2 = display.newSprite(M_filePath("img_pop"), 440, 240):addTo(bg)
  display.newSprite(M_filePath("img_arrow"), 300, 240):addTo(bg)
  DYLabelTTF.new({
    text = "\229\189\147\229\137\141\229\177\158\230\128\167",
    size = 24,
    color = cc.c3b(151, 105, 87),
    font = GameManager.FONTNAME_TTF
  }):pos(98, 150):addTo(frame1)
  if not curData or not curData.type then
    DYLabelTTF.new({
      text = "\230\151\160\229\177\158\230\128\167",
      size = 24,
      color = cc.c3b(80, 30, 0),
      font = GameManager.FONTNAME_TTF
    }):pos(98, 75):addTo(frame1)
  else
    local id, num = tonumber(curData.type), tonumber(curData.value)
    if 11 < id then
      num = string.format("%d%%", num)
    end
    local textStr = CMgr.PROPERTIES[id] .. "+" .. num
    DYLabelTTF.new({
      text = textStr,
      size = 24,
      color = cc.c3b(80, 30, 0),
      font = GameManager.FONTNAME_TTF
    }):pos(98, 75):addTo(frame1)
  end
  DYLabelTTF.new({
    text = "\229\188\128\229\133\137\229\177\158\230\128\167",
    size = 24,
    color = cc.c3b(151, 105, 87),
    font = GameManager.FONTNAME_TTF
  }):pos(98, 150):addTo(frame2)
  local id, num = tonumber(newData.type), tonumber(newData.value)
  if 11 < id then
    num = string.format("%d%%", num)
  end
  local textStr = CMgr.PROPERTIES[id] .. "+" .. num
  DYLabelTTF.new({
    text = textStr,
    size = 24,
    color = cc.c3b(80, 30, 0),
    font = GameManager.FONTNAME_TTF
  }):pos(98, 75):addTo(frame2)
  
  local function createButton(params)
    local btn = cc.ui.UIPushButton.new({
      normal = M_filePath("btn_big_01"),
      pressed = M_filePath("btn_big_02")
    }):setButtonLabel("normal", DYLabelTTF.new({
      text = params.text,
      size = 30,
      color = cc.c3b(255, 255, 255),
      font = GameManager.FONTNAME_TTF
    }, {
      lineColor = cc.c3b(70, 100, 0)
    })):setButtonLabel("pressed", DYLabelTTF.new({
      text = params.text,
      size = 28,
      color = cc.c3b(255, 255, 255),
      font = GameManager.FONTNAME_TTF
    }, {
      lineColor = cc.c3b(70, 100, 0)
    })):onButtonClicked(function(event)
      params.callback()
    end):align(display.CENTER, params.x, params.y):addTo(bg)
  end
  
  createButton({
    text = "\230\148\190    \229\188\131",
    x = 200,
    y = 80,
    callback = handler(self, self.onEventReplaceCancel)
  })
  createButton({
    text = "\229\143\150    \228\187\163",
    x = 400,
    y = 80,
    callback = handler(self, self.onEventReplaceEnsure)
  })
end

function M:onEventReplaceEnsure()
  local function tFuncListener(jsonTable)
    if jsonTable.errorCode > 0 then
      local errMsg = jsonTable.errorMsg or "UNKNOWN"
      
      WSToast.new(errMsg):addTo(display.getRunningScene(), 20)
      return
    end
    self.mCallback()
    self:closeCallback()
  end
  
  DYHttpMgr.cimeliaRecastReplace(tFuncListener, {
    ucid = tonumber(self.mParams.ucid),
    index = tonumber(self.mParams.index)
  })
end

function M:onEventReplaceCancel()
  self:closeCallback()
end

function M:loadGradeUpAlertUI()
  local bg = display.newSprite("common_ui/common_dialog.png"):addTo(self.mNode)
  local textStr = "\230\152\175\229\144\166\231\161\174\229\174\154\232\191\155\232\161\140\232\181\132\232\180\168\233\154\143\230\156\186\233\135\141\231\189\174\239\188\159\233\154\143\230\156\186\233\135\141\231\189\174\229\144\142\230\179\149\229\153\168\232\181\132\232\180\168\229\176\134\228\188\154\233\135\141\231\189\174\239\188\140\229\189\147\229\137\141\229\188\128\229\133\137\229\177\158\230\128\167\229\176\134\232\162\171\230\184\133\231\169\186\227\128\130"
  cc.ui.UILabel.new({
    text = textStr,
    size = 30,
    color = cc.c3b(80, 30, 0),
    font = GameManager.FONTNAME_TTF,
    align = cc.ui.TEXT_ALIGN_LEFT,
    dimensions = cc.size(470, 120)
  }):align(display.CENTER, 300, 240):addTo(bg)
  
  local function createButton(params)
    local btn = cc.ui.UIPushButton.new({
      normal = M_filePath("btn_big_01"),
      pressed = M_filePath("btn_big_02")
    }):setButtonLabel("normal", DYLabelTTF.new({
      text = params.text,
      size = 30,
      color = cc.c3b(255, 255, 255),
      font = GameManager.FONTNAME_TTF
    }, {
      lineColor = cc.c3b(70, 100, 0)
    })):setButtonLabel("pressed", DYLabelTTF.new({
      text = params.text,
      size = 28,
      color = cc.c3b(255, 255, 255),
      font = GameManager.FONTNAME_TTF
    }, {
      lineColor = cc.c3b(70, 100, 0)
    })):onButtonClicked(function(event)
      params.callback()
    end):align(display.CENTER, params.x, params.y):addTo(bg)
  end
  
  createButton({
    text = "\229\143\150    \230\182\136",
    x = 180,
    y = 100,
    callback = handler(self, self.onEventGradeUpCancel)
  })
  createButton({
    text = "\231\161\174    \229\174\154",
    x = 420,
    y = 100,
    callback = handler(self, self.onEventGradeUpEnsure)
  })
end

function M:onEventGradeUpCancel()
  self:closeCallback()
end

function M:onEventGradeUpEnsure()
  self.mCallback()
  self:closeCallback()
end

function M:closeCallback()
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  self:removeSelf()
end

function M:onKeypad(keyCode, event)
  DDLOG("Key %d was on pressed!", keyCode)
  if keyCode == cc.KeyCode.KEY_ESCAPE then
    return true
  end
  return false
end

function M:onEnter()
  DYKeypadMgr.regKeyHandler(self.mKeypadListener)
end

function M:onExit()
  DYKeypadMgr.unregKeyHandler(self.mKeypadListener)
end

return M
