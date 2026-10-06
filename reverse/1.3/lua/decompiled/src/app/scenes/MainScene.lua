local DYClass = "MainScene"
local M = {}
M = class(DYClass, function()
  return display.newScene(DYClass)
end)
local LayerUpdate = require("app.layers.LayerUpdate")

function M:ctor()
  DDLOG(DYClass .. ": onCreate")
  DataUtils = require("app.functions.DataUtils")
  DataUtils.init()
  DataRetainer = require("app.utils.DataRetainer")
  CloudData = require("app.utils.CloudData")
  GameManager = require("app.utils.GameManager")
  WSToast = require("app.utils.WSToast")
  PaymentInfo = require("app.utils.PaymentInfo")
  WordsTool = require("app.utils.WordsTool")
  require("app.communication.Const")
  BMgr = require("app.component.BattleManager")
  EffectMgr = require("app.utils.EffectMgr")
  EnvMgr = require("app.utils.EnvMgr")
  require("framework.cc.utils.bit")
  self:resetSocket()
  Game = {}
  if device.platform == "ios" or device.platform == "mac" then
    Game.LOGO_PATH = "common/logo_ios.png"
  else
    Game.LOGO_PATH = "common/logo.png"
  end
  if DYUtils.gameMode() ~= "debug" then
    Const.SKIP_GUIDE = false
  end
  app.TAG_EVENT_BACKGROUND = "TAG_EVENT_BACKGROUND"
  app.TAG_EVENT_FOREGROUND = "TAG_EVENT_FOREGROUND"
  self.mKeypadListener = handler(self, self.onKeypad)
  self:layoutUI()
end

function M:onEnter()
  DDLOG(DYClass .. ": onEnter")
  DYKeypadMgr.regKeyHandler(self.mKeypadListener)
end

function M:onExit()
  DDLOG(DYClass .. ": onExit")
  DYKeypadMgr.unregKeyHandler(self.mKeypadListener)
end

function M:onKeypad(keyCode, event)
  DDLOG("Key %d was on pressed!", keyCode)
  if keyCode == cc.KeyCode.KEY_ESCAPE then
    DYCommon.tryQuit(false, function(et)
      if et.event == dy.quit.EVENT_IGNORE then
        local layer = require("app.layers.LayerQuit").new()
        layer:show()
      end
    end)
  end
  return true
end

function M:resetSocket()
  if SocketMgr then
    SocketMgr:logout()
    SocketMgr = nil
  end
end

function M:checkNetWork()
  local isNetWork = network.isInternetConnectionAvailable()
  if not isNetWork then
    local bg = display.newSprite("connection/timeout_bg.png", display.cx, display.cy):addTo(self, 5)
    bg:setVisible(false)
    cc.ui.UIPushButton.new({
      normal = "common_ui/btn_normal1.png",
      pressed = "common_ui/btn_pressed1.png"
    }):setButtonLabel("normal", DYLabelTTF.new({
      text = "\233\128\128  \229\135\186",
      size = 30,
      color = cc.c3b(254, 239, 0),
      font = GameManager.FONTNAME_TTF
    }, {})):onButtonClicked(function()
      DYCommon.tryQuit(true)
    end):align(display.CENTER, bg:getContentSize().width * 0.5, bg:getContentSize().height * 0.21):addTo(bg)
    bg:runAction(transition.sequence({
      cc.DelayTime:create(1),
      cc.CallFunc:create(function()
        bg:setVisible(true)
      end)
    }))
  end
  return isNetWork
end

function M:layoutUI()
  if not self:checkNetWork() then
    return
  end
  DYSoundMgr.preloadMusic(DY_SND.bgm_chatting)
  local logo = display.newSprite("app/common/logo_boot.png", display.cx, display.cy):addTo(self)
  DYUtils.randomSeed()
  
  local function tFuncDelay()
    logo:runAction(cc.Sequence:create(cc.FadeOut:create(1), cc.CallFunc:create(function()
      display.replaceScene(require("app.scenes.SceneLogin").new())
    end)))
  end
  
  local function tryRestartGame(delay)
    delay = delay or 0.2
    DYUtils.schedule(function()
      self:resetSocket()
      DYSoundMgr.stopMusic()
      DYUtils.restartGame()
    end, delay)
  end
  
  local function tryCheckUpdate()
    local function tFuncListener(param)
      if param and param.errorCode == 0 and param.data then
        local newVer = checkstring(param.data.ver)
        
        if param.data.event == dy.update.EVENT_NO_UPDATE or newVer == "" then
          DYHttpMgr.checkLoginPoint("3_no_update")
          tFuncDelay()
        else
          local function onEventLayerUpdate(tag, param1, param2)
            DYHttpMgr.checkLoginPoint("3_update_finished")
            
            if tag == LayerUpdate.TAG_UPDATE_CANCEL then
              tFuncDelay()
            else
              tryRestartGame()
            end
            return
          end
          
          param.data.list = param.data.list or {count = 0}
          if type(param.data.list) ~= "table" then
            param.data.list = {count = 0}
          end
          local savePath = DYUtils.hotfixPath()
          local params = {
            type = param.data.event,
            url = param.data.url,
            savePath = savePath,
            fileSize = param.data.size,
            list = param.data.list,
            cb = onEventLayerUpdate
          }
          local layer = LayerUpdate.new(params)
          self:addChild(layer, 100)
        end
      else
        DYHttpMgr.checkLoginPoint("3_update_failed")
        local toast = WSToast.new(DYLang.getString("S1257", ""), 3600):addTo(self, 10)
        toast:setPosition(display.cx, display.height * 0.9)
      end
    end
    
    DYHttpMgr.checkUpdateInfo(tFuncListener)
    DYHttpMgr.checkLoginPoint("2_entrance_inited")
  end
  
  local function tryInitEntrance()
    DYHttpMgr.initEntrance(tryCheckUpdate)
  end
  
  local function tryInitIAP()
    DYIAPMgr.init(nil, function(et)
      if et.event == dy.iap.EVENT_INIT_SUCC then
        tryInitEntrance()
      else
        DYHttpMgr.checkLoginPoint("1_init_iap_failed")
        DDERROR("DYIAPMgr init failed")
        DYCommon.tryQuit()
      end
    end)
  end
  
  local function tryInitLogin()
    DYLoginMgr.init(nil, function(et)
      if et.event == dy.login.EVENT_INIT_SUCC then
        tryInitIAP()
      else
        DYHttpMgr.checkLoginPoint("1_init_login_failed")
        DDERROR("DYLoginMgr init failed")
        DYCommon.tryQuit()
      end
    end)
  end
  
  DYHttpMgr.checkLoginPoint("1_before_entrance")
  tryInitLogin()
end

return M
