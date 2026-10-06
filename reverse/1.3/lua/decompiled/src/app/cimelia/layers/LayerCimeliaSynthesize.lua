local PanelSynthesizeCimelia = require("app.cimelia.panels.PanelSynthesizeCimelia")
local LayerCimeliaRecipe = require("app.cimelia.layers.LayerCimeliaRecipe")
local NoviceGuide = require("app.utils.NoviceGuide")
local CLASS_NAME = "LayerCimeliaSynthesize"
local M = {}
M = class(CLASS_NAME, function()
  return display.newLayer()
end)

function M:ctor(handler_)
  self.mTag = CLASS_NAME
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  self.mNode = display.newNode():pos(display.cx, display.cy):addTo(self, 1)
  self:initData()
  self:initUI()
  self.isInGuide = false
  self:dealUserProgress()
end

function M:initData()
  DYRes.loadSheet("cimelia/tx_cimelia_hc.plist")
end

function M:initUI()
  local bg = display.newScale9Sprite("common_ui/common_frame9.png", 0, 0, cc.size(1070, 670), cc.rect(510, 240, 1, 1)):addTo(self.mNode)
  self.mBg = bg
  self.mPanel = PanelSynthesizeCimelia.new(handler(self, self.onEventPanel)):pos(bg:getContentSize().width * 0.5, bg:getContentSize().height * 0.5):addTo(bg)
  cc.ui.UIPushButton.new({
    normal = "common_ui/close_normal.png",
    pressed = "common_ui/close_pressed.png"
  }):align(display.CENTER, bg:getContentSize().width * 0.97, bg:getContentSize().height * 0.97):onButtonClicked(function()
    self:closeCallBack()
  end):addTo(bg, 2)
end

function M:onEventPanel(tag, params)
  if PanelSynthesizeCimelia.TAG_GZ == tag then
    self:synthesizeRule()
  elseif PanelSynthesizeCimelia.TAG_PF == tag then
    self:toRecipeLayer()
  elseif PanelSynthesizeCimelia.TAG_HC == tag then
    self.mType = 1
    self:cimeliaSyntheSize(params, handler_)
  elseif PanelSynthesizeCimelia.TAG_HC10 == tag then
    self.mType = 10
    self:cimeliaSyntheSize(params, handler_)
  end
end

function M:toRecipeLayer()
  local function tFuncListener(params)
    self.mPanel:useRecipe(params)
  end
  
  LayerCimeliaRecipe.new(tFuncListener):addTo(self, 10)
end

function M:cimeliaSyntheSize(params)
  local cimeliaCount = 0
  for k, v in pairs(CloudData.CIMELIA_LIST) do
    if k then
      cimeliaCount = cimeliaCount + 1
    end
  end
  if cimeliaCount >= Const.CIMELIA_LIMIT_NUM then
    WSToast.new(DYLang.getString("S593", ""), 2):addTo(self, 20)
    return
  end
  local tb_nums = {}
  local count = 0
  if 0 < params.gold then
    count = count + 1
    tb_nums["2008"] = params.gold
  end
  if 0 < params.water then
    count = count + 1
    tb_nums["2010"] = params.water
  end
  if 0 < params.wood then
    count = count + 1
    tb_nums["2009"] = params.wood
  end
  if 0 < params.fire then
    count = count + 1
    tb_nums["2011"] = params.fire
  end
  if 0 < params.earth then
    count = count + 1
    tb_nums["2012"] = params.earth
  end
  if count < 3 then
    WSToast.new(DYLang.getString("S594", "")):addTo(self, 20)
    return
  end
  
  local function tFuncListener(jsonTable)
    if not (self and self.mTag) or self.mTag ~= CLASS_NAME then
      return
    end
    if jsonTable.errorCode > 0 then
      local errMsg = jsonTable.errorMsg or "UNKNOWN"
      WSToast.new(errMsg):addTo(self, 20)
      return
    end
    if 1 == self.mType then
      CloudData.CIMELIA_LIST[jsonTable.data.cimelia.id] = jsonTable.data.cimelia
    elseif 10 == self.mType then
      for k, v in pairs(jsonTable.data.cimelia) do
        CloudData.CIMELIA_LIST[v.id] = v
      end
    end
    CloudData.GAME_ITEM_INFO["2008"] = jsonTable.data.gold
    CloudData.GAME_ITEM_INFO["2010"] = jsonTable.data.water
    CloudData.GAME_ITEM_INFO["2009"] = jsonTable.data.wood
    CloudData.GAME_ITEM_INFO["2011"] = jsonTable.data.fire
    CloudData.GAME_ITEM_INFO["2012"] = jsonTable.data.earth
    CloudData.GAME_ITEM_INFO["2007"] = jsonTable.data.stone
    self.mPanel:updateLabel()
    self:synthesizeSuccess(jsonTable.data.cimelia)
  end
  
  for k, v in pairs(tb_nums) do
    if v * self.mType > CloudData.GAME_ITEM_INFO[k] then
      WSToast.new(DYLang.getString("S595", "")):addTo(self, 20)
      return
    end
  end
  if params.useStone * self.mType > CloudData.GAME_ITEM_INFO["2007"] then
    WSToast.new(DYLang.getString("S596", "")):addTo(self, 20)
    return
  end
  DYAnalyze.item.consume("2007", "", params.useStone * self.mType, "Cimelia_compose")
  DYAnalyze.item.consume("2008", "", params.gold * self.mType, "Cimelia_compose")
  DYAnalyze.item.consume("2009", "", params.wood * self.mType, "Cimelia_compose")
  DYAnalyze.item.consume("2010", "", params.water * self.mType, "Cimelia_compose")
  DYAnalyze.item.consume("2011", "", params.fire * self.mType, "Cimelia_compose")
  DYAnalyze.item.consume("2012", "", params.earth * self.mType, "Cimelia_compose")
  if 1 == self.mType then
    DYHttpMgr.cimeliaSynthesize(tFuncListener, params)
  elseif 10 == self.mType then
    DYHttpMgr.cimeliaSynthesize10(tFuncListener, params)
  end
end

function M:synthesizeSuccess(cimelia)
  local pLayer = display.newColorLayer(cc.c4b(0, 0, 0, 120)):addTo(self, 15)
  local bg = display.newSprite("summon_scene/alert_frame.png"):scale(0):pos(display.cx, display.cy):addTo(self, 16)
  bg:runAction(transition.sequence({
    cc.ScaleTo:create(0.2, 1.1),
    cc.ScaleTo:create(0.1, 1)
  }))
  self.mSyntheSizeBg = bg
  display.newSprite("cimelia/syn_ok.png"):pos(bg:getContentSize().width * 0.5, bg:getContentSize().height):addTo(bg)
  local btn = cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png",
    disabled = "common_ui/btn_disabled1.png"
  }):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S597", ""),
    size = 30,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(25, 30, 3)
  })):align(display.CENTER, bg:getContentSize().width * 0.5, -bg:getContentSize().height * 0.15):onButtonClicked(function()
    local popupLayer = transition.sequence({
      cc.ScaleTo:create(0, 1),
      cc.ScaleTo:create(0.1, 1.1),
      cc.ScaleTo:create(0.2, 0),
      cc.CallFunc:create(function()
        bg:removeSelf()
        pLayer:removeSelf()
      end)
    })
    bg:runAction(popupLayer)
  end):addTo(bg)
  if 1 == self.mType then
    self:singleUI(cimelia)
  elseif 10 == self.mType then
    btn:hide()
    self:multipleUI(cimelia)
    self:performWithDelay(function()
      btn:show()
    end, 2)
  end
  self:dealUserProgress()
end

function M:singleUI(cimelia)
  DYSoundMgr.playEffect(DY_SND.sfx_cimelia_get)
  local bg = self.mSyntheSizeBg
  local cimeliaModel = DataUtils.getCimeliaBaseInfo(cimelia.id)
  local iconFrame = display.newSprite(string.format("common_ui/frame%d.png", cimeliaModel.quality)):align(display.CENTER, bg:getContentSize().width * 0.4, bg:getContentSize().height * 0.7):addTo(bg)
  local icon = display.newSprite(cimeliaModel.icon):pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.5):addTo(iconFrame)
  local textColor = DataUtils.getCimeliaNameColor(cimeliaModel.quality)
  local lb = DYLabelTTF.new({
    text = cimeliaModel.name,
    size = 24,
    color = textColor,
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(83, 54, 20)
  }):align(display.CENTER, iconFrame:getContentSize().width * 0.5, -iconFrame:getContentSize().height * 0.18):addTo(iconFrame)
  if cimeliaModel.stage > 0 then
    local topFrame = display.newSprite("cimelia/top_frame.png"):align(display.CENTER_TOP, iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height):addTo(iconFrame)
    local pNode = display.newNode():align(display.CENTER, topFrame:getContentSize().width * 0.5, topFrame:getContentSize().height * 0.5):addTo(topFrame)
    pNode:setContentSize(18 * (cimeliaModel.stage - 1), 24)
    for i = 1, cimeliaModel.stage do
      display.newSprite("cimelia/magatama.png", 18 * (i - 1), 12):addTo(pNode)
    end
  end
  for i = 1, #cimeliaModel.proType do
    local proType = tonumber(cimeliaModel.proType[i])
    if 0 == proType then
      iconFrame:setPosition(bg:getContentSize().width * 0.5, bg:getContentSize().height * 0.48)
      return
    end
    local typeLabel = display.newSprite(string.format("cimelia/type%d.png", proType)):align(display.CENTER_LEFT, bg:getContentSize().width * 0.5, bg:getContentSize().height * (0.9 - 0.08 * i)):addTo(bg)
    local numLabel = DYLabelTTF.new({
      text = "",
      size = 24,
      color = cc.c3b(48, 255, 66),
      font = GameManager.FONTNAME_TTF,
      dyalign = "CENTER_LEFT"
    }, {}):pos(bg:getContentSize().width * 0.64, typeLabel:getPositionY()):addTo(bg)
    if 5 == proType then
      numLabel:setString(cimeliaModel.proNum[i])
    elseif 6 == proType and -1 == tonumber(cimeliaModel.proBaseNum[i]) then
      numLabel:setString(DYLang.getString("S598", ""))
    elseif 7 == proType then
      numLabel:setString(cimeliaModel.proNum[i] .. "%")
    elseif 8 == proType then
      numLabel:setString(cimeliaModel.proNum[i] .. "%")
    else
      numLabel:setString(cimeliaModel.proNum[i])
    end
  end
  local skillName = DYLabelTTF.new({
    text = cimeliaModel.skillName .. "\239\188\154",
    size = 30,
    color = cc.c3b(255, 231, 95),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {}):pos(iconFrame:getPositionX() - iconFrame:getContentSize().width * 0.5, bg:getContentSize().height * 0.35):addTo(bg)
  local skillDesc = DYLabelTTF.new({
    text = cimeliaModel.skillDesc,
    size = 24,
    color = display.COLOR_WHITE,
    font = GameManager.FONTNAME_TTF,
    align = cc.ui.TEXT_ALIGN_LEFT,
    dimensions = cc.size(335, 65),
    dyalign = "TOP_LEFT"
  }):pos(skillName:getPositionX() + skillName:getContentSize().width, skillName:getPositionY() + 10):addTo(bg)
end

function M:multipleUI(cimelia)
  local bg = self.mSyntheSizeBg
  for i = 1, 10 do
    local cimeliaModel = DataUtils.getCimeliaBaseInfo(cimelia[i].id)
    local iconFrame = display.newSprite(string.format("common_ui/frame%d.png", cimeliaModel.quality)):align(display.CENTER, bg:getContentSize().width * 0.5, bg:getContentSize().height * 1.3):scale(0):addTo(bg)
    local pLayer
    iconFrame:setTouchEnabled(true)
    iconFrame:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
      local name, x, y = event.name, event.x, event.y
      local touchInSprite = cc.rectContainsPoint(iconFrame:getCascadeBoundingBox(), cc.p(x, y))
      if name == "began" then
        if not pLayer then
          pLayer = self:getCimeliaTip(cimeliaModel)
          pLayer:setPosition(iconFrame:getPositionX(), iconFrame:getPositionY())
          pLayer:addTo(bg, 20)
        end
        return true
      elseif name == "moved" then
        pLayer:show()
      elseif name == "ended" then
        pLayer:removeSelf()
        pLayer = nil
      end
    end)
    local icon = display.newSprite(cimeliaModel.icon):pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.5):addTo(iconFrame)
    local textColor = DataUtils.getCimeliaNameColor(cimeliaModel.quality)
    local lb = DYLabelTTF.new({
      text = cimeliaModel.name,
      size = 24,
      color = textColor,
      font = GameManager.FONTNAME_TTF
    }, {
      lineColor = cc.c3b(83, 54, 20)
    }):align(display.CENTER, iconFrame:getContentSize().width * 0.5, -iconFrame:getContentSize().height * 0.18):addTo(iconFrame)
    if 0 < cimeliaModel.stage then
      local topFrame = display.newSprite("cimelia/top_frame.png"):align(display.CENTER_TOP, iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height):addTo(iconFrame)
      local pNode = display.newNode():align(display.CENTER, topFrame:getContentSize().width * 0.5, topFrame:getContentSize().height * 0.5):addTo(topFrame)
      pNode:setContentSize(18 * (cimeliaModel.stage - 1), 24)
      for i = 1, cimeliaModel.stage do
        display.newSprite("cimelia/magatama.png", 18 * (i - 1), 12):addTo(pNode)
      end
    end
    local movetoPoint
    if i < 6 then
      movetoPoint = cc.p(bg:getContentSize().width * 0.1 * (i * 1.5 + 0.5), bg:getContentSize().height * 0.78)
    else
      movetoPoint = cc.p(bg:getContentSize().width * 0.1 * ((i - 5) * 1.5 + 0.5), bg:getContentSize().height * 0.32)
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

function M:getCimeliaTip(cimeliaModel)
  local bg = display.newSprite("cimelia/tip.png")
  local iconFrame = display.newSprite(string.format("common_ui/frame%d.png", cimeliaModel.quality)):align(display.CENTER, 90, bg:getContentSize().height * 0.72):addTo(bg)
  local icon = display.newSprite(cimeliaModel.icon):pos(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.5):addTo(iconFrame)
  if cimeliaModel.stage > 0 then
    local topFrame = display.newSprite("cimelia/top_frame.png"):align(display.CENTER_TOP, iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height):addTo(iconFrame)
    local pNode = display.newNode():align(display.CENTER, topFrame:getContentSize().width * 0.5, topFrame:getContentSize().height * 0.5):addTo(topFrame)
    pNode:setContentSize(18 * (cimeliaModel.stage - 1), 24)
    for i = 1, cimeliaModel.stage do
      display.newSprite("cimelia/magatama.png", 18 * (i - 1), 12):addTo(pNode)
    end
  end
  local textColor = DataUtils.getCimeliaNameColor(cimeliaModel.quality)
  local lb = cc.ui.UILabel.new({
    text = cimeliaModel.name,
    size = 30,
    color = textColor,
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, iconFrame:getPositionX(), iconFrame:getPositionY() - 85):addTo(bg)
  lb:enableOutline(cc.c4b(83, 54, 20, 255), 2)
  DYLabelTTF.new({
    text = "LV.1",
    size = 26,
    color = display.COLOR_WHITE,
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_RIGHT"
  }):pos(iconFrame:getContentSize().width - 10, 20):addTo(iconFrame)
  for i = 1, #cimeliaModel.proType do
    local proType = tonumber(cimeliaModel.proType[i])
    if 0 == proType then
      iconFrame:setPosition(bg:getContentSize().width * 0.5, bg:getContentSize().height * 0.48)
      lb:setPosition(iconFrame:getPositionX(), iconFrame:getPositionY() - 85)
      return bg
    end
    local typeLabel = display.newSprite(string.format("cimelia/type%d.png", proType)):align(display.CENTER_LEFT, bg:getContentSize().width * 0.45, bg:getContentSize().height * (1 - 0.12 * i)):addTo(bg)
    local numLabel = DYLabelTTF.new({
      text = "",
      size = 24,
      color = display.COLOR_WHITE,
      font = GameManager.FONTNAME_TTF,
      dyalign = "CENTER_LEFT"
    }, {}):pos(bg:getContentSize().width * 0.78, typeLabel:getPositionY()):addTo(bg)
    if 5 == proType then
      numLabel:setString(cimeliaModel.proNum[i])
    elseif 6 == proType and -1 == tonumber(cimeliaModel.proBaseNum[i]) then
      numLabel:setString(DYLang.getString("S598", ""))
    elseif 7 == proType then
      numLabel:setString(cimeliaModel.proNum[i] .. "%")
    elseif 8 == proType then
      numLabel:setString(cimeliaModel.proNum[i] .. "%")
    else
      numLabel:setString(cimeliaModel.proNum[i])
    end
  end
  local skillName = DYLabelTTF.new({
    text = cimeliaModel.skillName .. "\239\188\154",
    size = 30,
    color = cc.c3b(235, 255, 12),
    font = GameManager.FONTNAME_TTF,
    dyalign = "CENTER_LEFT"
  }, {}):pos(30, bg:getContentSize().height * 0.25):addTo(bg)
  local skillDesc = DYLabelTTF.new({
    text = cimeliaModel.skillDesc,
    size = 20,
    color = display.COLOR_WHITE,
    font = GameManager.FONTNAME_TTF,
    align = cc.ui.TEXT_ALIGN_LEFT,
    dimensions = cc.size(390, 70),
    dyalign = "TOP_LEFT"
  }):pos(30, bg:getContentSize().height * 0.2):addTo(bg)
  return bg
end

function M:synthesizeRule()
end

function M:closeCallBack()
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  DYRes.unloadSheet("cimelia/tx_cimelia_hc.plist")
  self:runAction(cc.RemoveSelf:create())
end

function M:dealUserProgress()
  local stageProgress = Const.STAGE_PROGRESS or CloudData.MAIN_STAGE_PROGRESS
  local userLevel = CloudData.USER_LEVEL
  if userLevel == Const.FUNC_UNLOCK.cemeliamake then
    if DataUtils.getGuideIsFirstPlayed("GUIDE_CEMLESCN_COMPOSITE") and not DataUtils.getGuideIsFirstPlayed("GUIDE_CEMLELAY_COMPOSITE") then
      local guide1
      
      local function tFunc()
        DDLOG(DYLang.getString("S600", ""))
        local params = {
          {index = 1, cost = 10},
          {index = 2, cost = 0},
          {index = 3, cost = 10},
          {index = 4, cost = 10},
          {index = 5, cost = 0}
        }
        self.mPanel:onTouchIcon(1, params)
        local guide = NoviceGuide.new("GUIDE_CEMLELAY_COMPOSITE_1"):addTo(self, 999)
      end
      
      self.isInGuide = true
      self.mPanel.mTouchEnabled = false
      guide1 = NoviceGuide.new("GUIDE_CEMLELAY_COMPOSITE", tFunc):addTo(self, 999)
      return
    end
    if DataUtils.getGuideIsFirstPlayed("GUIDE_CEMLELAY_COMPOSITE") and not DataUtils.getGuideIsFirstPlayed("GUIDE_CEMLELAY_COMPOSITE_RESULT") then
      local guide = NoviceGuide.new("GUIDE_CEMLELAY_COMPOSITE_RESULT", function()
        self:closeCallBack()
        display.getRunningScene():dealUserProgress()
      end):addTo(self, 999)
      return
    end
  end
end

return M
