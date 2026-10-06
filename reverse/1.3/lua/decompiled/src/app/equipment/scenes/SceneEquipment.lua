local IconPkBubble = require("app.icons.IconPkBubble")
local DataLabelIcon = require("app.icons.DataLabelIcon")
local PanelBuddha = require("equipment.panels.PanelBuddha")
local PanelPackage = require("equipment.panels.PanelPackage")
local PanelEquipInfo = require("equipment.panels.PanelEquipInfo")
local PanelUpgrade = require("equipment.panels.PanelUpgrade")
local LayerPreview = require("equipment.layers.LayerPreview")
local LayerUpgrade = require("equipment.layers.LayerUpgrade")
local LayerResolve = require("equipment.layers.LayerResolve")
local LayerUpstar = require("equipment.layers.LayerUpstar")
local LayerQuenching = require("equipment.layers.LayerQuenching")
local LayerRule = require("app.layers.LayerRule")
local DYClass = "SceneEquipment"
local M = {}
M = class(DYClass, function()
  return display.newScene(DYClass)
end)

function M:ctor()
  self.mKeypadListener = handler(self, self.onKeypad)
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  EMgr = require("app.equipment.EquipmentManager")
  EMgr.init()
  EMgr.EQUIP_LIST = {}
  self:initUI()
  self:initData()
  self:initPkBubble()
end

local function M_filePath(name)
  return string.format("equipment/%s.png", name)
end

function M:initData()
  self.mBuddhaList = DataUtils.getBuddhaListForEquipment()
  self:initEquipmentData()
  CloudData.IRON = CloudData.GAME_ITEM_INFO["10"] or 0
  self.mIsPackageOn = false
  self:layoutUI()
  self.mIronLabel:setString(CloudData.IRON)
  self.mIsDataLoad = false
  self:performWithDelay(function()
    self:loadHttpData()
  end, 0.5)
end

function M:loadHttpData()
  local function tFuncListener(jsonTable)
    if jsonTable.errorCode > 0 then
      local errMsg = jsonTable.errorMsg or "UNKNOWN"
      
      WSToast.new(errMsg):addTo(self, 20)
      return
    end
    EMgr.ELEMENT_RUNE_COST_NUM = jsonTable.data.wuxingfuCost
    EMgr.QUENCHING_RUNE_COST_NUM = jsonTable.data.yuanlingCost
    EMgr.ELEMENT_COST_NUM = jsonTable.data.elementCost
    EMgr.ELEMENT_RUNE_ID = tostring(jsonTable.data.wuxingfuId)
    EMgr.QUENCHING_RUNE_ID = tostring(jsonTable.data.yuanlingId)
    CloudData.EQUIPMENT_INFO = jsonTable.data.equipmentList
    self:initEquipmentData()
    self.mIsDataLoad = true
  end
  
  self:safeHttpRequest("equipmentInit", tFuncListener)
end

function M:initEquipmentData()
  for k, v in pairs(CloudData.EQUIPMENT_INFO) do
    if GameManager.EQUIP_LIST[k] then
      EMgr.EQUIP_LIST[k] = GameManager.EQUIP_LIST[k]
    else
      local data = GameManager.generateEquipmentData(k, v)
      EMgr.EQUIP_LIST[k] = data
    end
  end
end

function M:initUI()
  self:loadTopUI()
  self.mPanelMain = display.newSprite("equipment/bg.jpg", display.cx, display.cy):addTo(self)
  display.newSprite(M_filePath("bg_01")):align(display.LEFT_BOTTOM, 0, 0):addTo(self.mPanelMain, 2)
  LayerRule.newRuleIcon(LayerRule.EQUIPMENT):pos(270, display.height - 37):addTo(self, 11)
  cc.ui.UIPushButton.new({
    normal = "upgrade/back.png",
    pressed = "upgrade/back.png"
  }):align(display.CENTER, 55, display.height - 30):scale(0.8):onButtonPressed(function(event)
    event.target:setScale(0.75)
  end):onButtonRelease(function(event)
    event.target:setScale(0.8)
  end):onButtonClicked(function()
    self:returnCallBack()
  end):addTo(self, 11)
end

function M:layoutUI()
  self:initTabBtn()
  local panelBuddha = PanelBuddha.new({
    buddhaList = self.mBuddhaList
  })
  panelBuddha:pos(90, 0)
  panelBuddha:addTo(self.mPanelMain)
  panelBuddha:addEventListener(EMgr.EVENT_EQUIP_INFO, handler(self, self.onEventEquipmentInfo))
  panelBuddha:addEventListener(EMgr.EVENT_EQUIP_CHANGE, handler(self, self.onEventEquipmentChange))
  self.mPanelBuddha = panelBuddha
  local panelEquipInfo = PanelEquipInfo.new({
    ueid = EMgr.INIT_EQUIPMENT
  }, handler(self, self.onEventInfoPreview))
  panelEquipInfo:pos(685, 0)
  panelEquipInfo:addTo(self.mPanelMain)
  self.mPanelEquipInfo = panelEquipInfo
  local panelPackage = PanelPackage.new()
  panelPackage:pos(-620, 0)
  panelPackage:addTo(self.mPanelMain)
  panelPackage:addEventListener(EMgr.EVENT_EQUIP_INFO, handler(self, self.onEventEquipmentInfo))
  self.mPanelPackage = panelPackage
  cc.ui.UIPushButton.new({
    normal = M_filePath("btn_bag"),
    pressed = M_filePath("btn_bag"),
    disabled = M_filePath("btn_bag")
  }):align(display.CENTER, 155, 50):onButtonPressed(function(event)
    event.target:setScale(0.9)
  end):onButtonRelease(function(event)
    event.target:setScale(1)
  end):onButtonClicked(function(event)
    self:switchCallback(event.target)
  end):addTo(self.mPanelMain, 2)
end

function M:loadTopUI()
  display.newSprite(M_filePath("bg_00"), display.cx, display.height - 45):addTo(self, 10)
  self.mTitle = display.newSprite(M_filePath("title_equipment"), 175, display.height - 35):addTo(self, 11)
  DataLabelIcon.new(DataLabelIcon.LABEL_TYPE_ESSENCE, true):pos(display.width - 545, display.height - 35):addTo(self, 11)
  local labelFrame = display.newSprite("common_ui/iron_bg.png", display.width - 220, display.height - 35):addTo(self, 11)
  self.mIronLabel = DYLabelTTF.new({
    text = CloudData.IRON,
    size = 27,
    color = display.COLOR_WHITE,
    font = GameManager.FONTNAME_TTF
  }, {}):pos(labelFrame:getContentSize().width * 0.51, labelFrame:getContentSize().height * 0.5 - 2):addTo(labelFrame)
end

function M:initTabBtn()
  local M_TAB_BTN = {
    {
      normal = M_filePath("btn_strengthen_n"),
      pressed = M_filePath("btn_strengthen_p")
    },
    {
      normal = M_filePath("btn_risingstar_n"),
      pressed = M_filePath("btn_risingstar_p")
    },
    {
      normal = M_filePath("btn_cuilian_n"),
      pressed = M_filePath("btn_cuilian_p")
    },
    {
      normal = M_filePath("btn_decompose_n"),
      pressed = M_filePath("btn_decompose_p")
    }
  }
  for i = 1, #M_TAB_BTN do
    local btn = cc.ui.UIPushButton.new(M_TAB_BTN[i]):onButtonClicked(function(event)
      self:funcChange(event.target, i)
    end):align(display.CENTER_RIGHT, 1175, 650 - 136 * i):addTo(self.mPanelMain, 3)
  end
end

function M:initPkBubble()
  self.mPkBubble = IconPkBubble.new()
  self:add(self.mPkBubble, 900)
end

function M:funcChange(tab, index)
  DYSoundMgr.playEffect(DY_SND.sfx_touch)
  if not self.mIsDataLoad then
    WSToast.new("\230\149\176\230\141\174\229\136\157\229\167\139\229\140\150\228\184\173\227\128\130\227\128\130\227\128\130"):addTo(self, 20)
    return
  end
  if EMgr.CURR_EQUIPMENT == nil then
    WSToast.new("\229\189\147\229\137\141\230\178\161\230\156\137\233\128\137\230\139\169\228\187\187\228\189\149\232\163\133\229\164\135\239\188\129"):addTo(self, 20)
    return
  end
  local tFunc = {
    [1] = function()
      self:onEventUpgrade()
    end,
    [2] = function()
      self:onEventUpstar()
    end,
    [3] = function()
      self:onEventQuenching()
    end,
    [4] = function()
      self:onEventResolve()
    end
  }
  tFunc[index]()
end

function M:onEventEquipmentInfo(params)
  local data = params.data and EMgr.EQUIP_LIST[params.data] or nil
  self.mPanelEquipInfo:loadEquipmentInfo(data)
end

function M:onEventEquipmentChange(params)
  self.mPanelPackage:updateListView()
end

function M:onEventInfoPreview(params)
  local preview = LayerPreview.new(params):addTo(self, 5)
  preview:layerShow()
end

function M:onEventUpgrade()
  DDLOG("======== onEventUpgrade")
  self.mTitle:setTexture(M_filePath("title_strengthen"))
  self.mCurrLayer = LayerUpgrade.new({
    ueid = EMgr.CURR_EQUIPMENT
  }, handler(self, self.onUpdateUpgrade)):addTo(self, 5)
end

function M:onEventUpstar()
  DDLOG("======== onEventUpStar")
  self.mTitle:setTexture(M_filePath("title_risingstar"))
  self.mCurrLayer = LayerUpstar.new({
    ueid = EMgr.CURR_EQUIPMENT
  }, handler(self, self.onUpdateUpstar)):addTo(self, 5)
end

function M:onEventQuenching()
  DDLOG("======== onEventQuenching")
  if 0 == EMgr.EQUIP_LIST[EMgr.CURR_EQUIPMENT].canQuenching then
    WSToast.new("\232\175\165\232\163\133\229\164\135\230\151\160\230\179\149\230\183\172\231\129\181\239\188\129"):addTo(self, 50)
    return
  end
  if EMgr.EQUIP_LIST[EMgr.CURR_EQUIPMENT].isQuenching then
    WSToast.new("\232\175\165\232\163\133\229\164\135\229\183\178\230\183\172\231\129\181\239\188\129"):addTo(self, 50)
    return
  end
  self.mTitle:setTexture(M_filePath("title_cuilian"))
  self.mCurrLayer = LayerQuenching.new({
    ueid = EMgr.CURR_EQUIPMENT
  }, handler(self, self.onUpdateQuenching)):addTo(self, 5)
end

function M:onEventResolve()
  DDLOG("======== onEventResolve")
  if 0 == EMgr.EQUIP_LIST[EMgr.CURR_EQUIPMENT].level then
    WSToast.new("\231\173\137\231\186\167\228\184\1860\231\154\132\232\163\133\229\164\135\230\151\160\230\179\149\229\136\134\232\167\163\239\188\129"):addTo(self, 50)
    return
  end
  self.mTitle:setTexture(M_filePath("title_decompose"))
  self.mCurrLayer = LayerResolve.new({
    ueid = EMgr.CURR_EQUIPMENT
  }, handler(self, self.onUpdateResolve)):addTo(self, 5)
end

function M:onUpdateUpgrade()
  local ueid = EMgr.CURR_EQUIPMENT
  local newData = EMgr.EQUIP_LIST[ueid]
  self.mPanelPackage:onUpdateDataUpgrade(newData)
  self.mPanelEquipInfo:loadEquipmentInfo(newData)
  if not self.mIsPackageOn then
    self.mPanelBuddha:onUpdateDataUpgrade(newData)
  end
end

function M:onUpdateResolve()
  local ueid = EMgr.CURR_EQUIPMENT
  local newData = EMgr.EQUIP_LIST[ueid]
  self.mPanelEquipInfo:loadEquipmentInfo(newData)
  if self.mIsPackageOn then
    self.mPanelPackage:onUpdateDataResolve(newData)
  else
    self.mPanelBuddha:onUpdateDataResolve(newData)
  end
  self.mCurrLayer = nil
  self.mTitle:setTexture(M_filePath("title_equipment"))
end

function M:onUpdateUpstar()
  local ueid = EMgr.CURR_EQUIPMENT
  local newData = EMgr.EQUIP_LIST[ueid]
  self.mPanelEquipInfo:loadEquipmentInfo(newData)
  if not self.mIsPackageOn then
    self.mPanelBuddha:onUpdateDataUpstar(newData)
  end
end

function M:onUpdateQuenching(params)
  if not params.isOk then
    return
  end
  local ueid = EMgr.CURR_EQUIPMENT
  local newData = EMgr.EQUIP_LIST[ueid]
  self.mPanelPackage:onUpdateDataQuenching(newData)
  self.mPanelEquipInfo:loadEquipmentInfo(newData)
  if not self.mIsPackageOn then
    self.mPanelBuddha:onUpdateDataQuenching(newData)
  end
end

function M:switchCallback(button)
  if self.mIsPackageOn then
    self.mPanelPackage:panelHide(true)
    self.mPanelBuddha:panelShow(true)
    button:setButtonImage("normal", M_filePath("btn_bag"))
    button:setButtonImage("pressed", M_filePath("btn_bag"))
    button:setButtonImage("disabled", M_filePath("btn_bag"))
  else
    self.mPanelBuddha:panelHide(true)
    self.mPanelPackage:panelShow(true)
    button:setButtonImage("normal", M_filePath("btn_role"))
    button:setButtonImage("pressed", M_filePath("btn_role"))
    button:setButtonImage("disabled", M_filePath("btn_role"))
  end
  self.mIsPackageOn = not self.mIsPackageOn
  button:setButtonEnabled(false)
  self:performWithDelay(function()
    button:setButtonEnabled(true)
  end, 0.5)
end

function M:returnCallBack()
  if self.mCurrLayer then
    self.mCurrLayer:closeCallback()
    self.mCurrLayer = nil
    self.mTitle:setTexture(M_filePath("title_equipment"))
    return
  end
  GameManager.EQUIP_LIST = EMgr.EQUIP_LIST
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  local nextScene = require("scenes.ChapterScene").new()
  display.replaceScene(nextScene, "fade", 0.2)
end

function M:onKeypad(keyCode, event)
  DDLOG("Key %d was on pressed!", keyCode)
  if keyCode == cc.KeyCode.KEY_ESCAPE then
    local nextScene = require("scenes.ChapterScene").new()
    display.replaceScene(nextScene, "fade", 0.2)
    return true
  end
  return false
end

function M:onEnter()
  DDLOG(DYClass .. ": onEnter")
  self.mFileInfo = {}
  DYRes.loadFileInfo("equipment/armature/quenching/tongyong_tx.csb", self.mFileInfo)
  DYRes.loadFileInfo("equipment/armature/upgrade/qianghuachenggong.csb", self.mFileInfo)
  DYRes.loadSheet("equipment/animation/tx_equip_up.plist")
  DYRes.loadSheet("equipment/animation/tx_max_star.plist")
  DYRes.loadSheet("equipment/animation/tx_quenching.plist")
  DYRes.loadSheet("equipment/animation/tx_star.plist")
  DYRes.loadSheet("equipment/animation/tx_star_unlock.plist")
  DYKeypadMgr.regKeyHandler(self.mKeypadListener)
end

function M:onExit()
  DDLOG(DYClass .. ": onExit")
  EMgr = nil
  DYRes.unloadFileInfo(self.mFileInfo)
  self.mFileInfo = {}
  DYRes.unloadSheet("equipment/animation/tx_equip_up.plist")
  DYRes.unloadSheet("equipment/animation/tx_max_star.plist")
  DYRes.unloadSheet("equipment/animation/tx_quenching.plist")
  DYRes.unloadSheet("equipment/animation/tx_star.plist")
  DYRes.unloadSheet("equipment/animation/tx_star_unlock.plist")
  DYKeypadMgr.unregKeyHandler(self.mKeypadListener)
end

return M
