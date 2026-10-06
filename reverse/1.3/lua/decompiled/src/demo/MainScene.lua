local CLASS_NAME = "MainScene"
local M = {}
M = class(CLASS_NAME, function()
  return display.newScene(CLASS_NAME)
end)

function M:ctor()
  DDLOG(CLASS_NAME .. ": onCreate")
  self.mLabelConsole = nil
  self.mTestIndex = 0
  self.mLayerEns = nil
  DYRes.loadSheet("uikit/dy_sheet_uikit.plist")
  self:layoutUI()
end

function M:onEnter()
  DDLOG(CLASS_NAME .. ": onEnter")
  DYNotification.registerScriptObserver(self, handler(self, self.onNotify), "test_key")
end

function M:onExit()
  DDLOG(CLASS_NAME .. ": onExit")
  DYNotification.removeAllObservers(self)
end

function M:onNotify(tag, param)
  DDLOG("on Notification callback ~")
end

function M:layoutUI()
  local function tFuncAddButtons()
    self:addButtons()
  end
  
  local label = cc.Label:createWithBMFont("gf_default.fnt", "DYGame X")
  label:setPosition(dy.xp(640, 360))
  self:addChild(label)
  label:setOpacity(0)
  label:runAction(cc.Sequence:create(cc.FadeIn:create(2), cc.JumpBy:create(0.5, dy.xp(0, 280), 100, 1), cc.CallFunc:create(tFuncAddButtons)))
  local ds = DYSprite.create("uikit/gi_logo.png", false)
  ds:setPosition(dy.xp(640, 360))
  self:addChild(ds)
  ds:setScale(0)
  ds:runAction(cc.Sequence:create(cc.ScaleTo:create(0.1, 1), cc.ScaleTo:create(0.5, 1.3), cc.DelayTime:create(0.5), cc.ScaleTo:create(0.5, 1.1), cc.ScaleTo:create(0.1, 0)))
  local label = display.newTTFLabel({
    text = DYLang.getString("POWERED_BY", "")
  })
  label:setPosition(dy.xp(1250, 20))
  label:setAnchorPoint(dy.p(1, 0))
  self:addChild(label)
end

function M:addButtons()
  local label = display.newTTFLabel({text = "CONSOLE"})
  label:setPosition(dy.xp(640, 240))
  label:setAnchorPoint(dy.p(0.5, 0.6))
  self:addChild(label, 20)
  self.mLabelConsole = label
  label:runAction(DYRollnum:create(5, 1000, 1))
  local cb = handler(self, self.buttonListener)
  local param = {
    nImage = "gi_btn_common.png",
    pImage = "gi_btn_common.png",
    listener = cb,
    tag = "DOWNLOAD",
    cached = true,
    size = cc.size(200, 90),
    color = cc.c3b(255, 255, 255),
    fScale = 0.3,
    scale = 0.98
  }
  param.title = param.tag
  local button = DYButton.createWithBMFont(param)
  button:setPosition(dy.xp(140, 520))
  self:addChild(button, 10)
  local param = {
    nImage = "gi_btn_common.png",
    pImage = "gi_btn_common.png",
    listener = cb,
    tag = "SET",
    cached = true,
    size = cc.size(200, 90),
    color = cc.c3b(255, 255, 255),
    scale = 0.98
  }
  param.title = param.tag
  local button = DYButton.create(param)
  button:setPosition(dy.xp(390, 520))
  self:addChild(button, 10)
  local param = {
    nImage = "gi_btn_common.png",
    pImage = "gi_btn_common.png",
    listener = cb,
    tag = "GET",
    cached = true,
    size = cc.size(200, 90),
    color = cc.c3b(255, 255, 255),
    fScale = 0.3,
    scale = 0.98
  }
  param.title = param.tag
  local button = DYButton.createWithBMFont(param)
  button:setPosition(dy.xp(640, 520))
  self:addChild(button, 10)
  local param = {
    nImage = "gi_btn_common.png",
    pImage = "gi_btn_common.png",
    listener = cb,
    tag = "CLEAR",
    cached = true,
    size = cc.size(200, 90),
    color = cc.c3b(255, 255, 255),
    fScale = 0.3,
    scale = 0.98
  }
  param.title = param.tag
  local button = DYButton.createWithBMFont(param)
  button:setPosition(dy.xp(890, 520))
  self:addChild(button, 10)
  local param = {
    nImage = "gi_btn_common.png",
    pImage = "gi_btn_common.png",
    listener = cb,
    tag = "HOTFIX",
    cached = true,
    size = cc.size(200, 90),
    color = cc.c3b(255, 255, 255),
    fScale = 0.3,
    scale = 0.98
  }
  param.title = param.tag
  local button = DYButton.createWithBMFont(param)
  button:setPosition(dy.xp(1140, 520))
  self:addChild(button, 10)
  local param = {
    nImage = "gi_btn_common.png",
    pImage = "gi_btn_common.png",
    listener = cb,
    tag = "SAC",
    cached = true,
    size = cc.size(200, 90),
    color = cc.c3b(255, 255, 255),
    fScale = 0.3,
    scale = 0.98
  }
  param.title = param.tag
  local button = DYButton.createWithBMFont(param)
  button:setPosition(dy.xp(140, 420))
  self:addChild(button, 10)
  local param = {
    nImage = "gi_btn_common.png",
    pImage = "gi_btn_common.png",
    listener = cb,
    tag = "UID",
    cached = true,
    size = cc.size(200, 90),
    color = cc.c3b(255, 255, 255),
    fScale = 0.3,
    scale = 0.98
  }
  param.title = param.tag
  local button = DYButton.createWithBMFont(param)
  button:setPosition(dy.xp(390, 420))
  self:addChild(button, 10)
  local param = {
    nImage = "gi_btn_common.png",
    pImage = "gi_btn_common.png",
    listener = cb,
    tag = "SCHEDULE",
    cached = true,
    size = cc.size(200, 90),
    color = cc.c3b(255, 255, 255),
    fScale = 0.3,
    scale = 0.98
  }
  param.title = param.tag
  local button = DYButton.createWithBMFont(param)
  button:setPosition(dy.xp(640, 420))
  self:addChild(button, 10)
  local param = {
    nImage = "gi_btn_common.png",
    pImage = "gi_btn_common.png",
    listener = cb,
    tag = "DATA",
    cached = true,
    size = cc.size(200, 90),
    color = cc.c3b(255, 255, 255),
    fScale = 0.3,
    scale = 0.98
  }
  param.title = param.tag
  local button = DYButton.createWithBMFont(param)
  button:setPosition(dy.xp(890, 420))
  self:addChild(button, 10)
  local param = {
    nImage = "gi_btn_common.png",
    pImage = "gi_btn_common.png",
    listener = cb,
    tag = "ensReset",
    cached = true,
    size = cc.size(200, 90),
    color = cc.c3b(255, 255, 255),
    fScale = 0.3,
    scale = 0.98
  }
  param.title = param.tag
  local button = DYButton.createWithBMFont(param)
  button:setPosition(dy.xp(1140, 420))
  self:addChild(button, 10)
  local param = {
    nImage = "gi_btn_common.png",
    pImage = "gi_btn_common.png",
    listener = cb,
    tag = "ensHSL",
    cached = true,
    size = cc.size(200, 90),
    color = cc.c3b(255, 255, 255),
    fScale = 0.3,
    scale = 0.98
  }
  param.title = param.tag
  local button = DYButton.createWithBMFont(param)
  button:setPosition(dy.xp(140, 320))
  self:addChild(button, 10)
  local param = {
    nImage = "gi_btn_common.png",
    pImage = "gi_btn_common.png",
    listener = cb,
    tag = "ensRipple",
    cached = true,
    size = cc.size(200, 90),
    color = cc.c3b(255, 255, 255),
    fScale = 0.3,
    scale = 0.98
  }
  param.title = param.tag
  local button = DYButton.createWithBMFont(param)
  button:setPosition(dy.xp(390, 320))
  self:addChild(button, 10)
  local param = {
    nImage = "gi_btn_common.png",
    pImage = "gi_btn_common.png",
    listener = cb,
    tag = "ensBreak",
    cached = true,
    size = cc.size(200, 90),
    color = cc.c3b(255, 255, 255),
    fScale = 0.3,
    scale = 0.98
  }
  param.title = param.tag
  local button = DYButton.createWithBMFont(param)
  button:setPosition(dy.xp(640, 320))
  self:addChild(button, 10)
  local param = {
    nImage = "gi_btn_common.png",
    pImage = "gi_btn_common.png",
    listener = cb,
    tag = "ensGhost",
    cached = true,
    size = cc.size(200, 90),
    color = cc.c3b(255, 255, 255),
    fScale = 0.3,
    scale = 0.98
  }
  param.title = param.tag
  local button = DYButton.createWithBMFont(param)
  button:setPosition(dy.xp(890, 320))
  self:addChild(button, 10)
  local param = {
    nImage = "gi_btn_common.png",
    pImage = "gi_btn_common.png",
    listener = cb,
    tag = "ensNormalMap",
    cached = true,
    size = cc.size(200, 90),
    color = cc.c3b(255, 255, 255),
    fScale = 0.3,
    scale = 0.98
  }
  param.title = param.tag
  local button = DYButton.createWithBMFont(param)
  button:setPosition(dy.xp(1140, 320))
  self:addChild(button, 10)
  local param = {
    nImage = "gi_btn_common.png",
    pImage = "gi_btn_common.png",
    listener = cb,
    tag = "ensRippleH",
    cached = true,
    size = cc.size(200, 90),
    color = cc.c3b(255, 255, 255),
    fScale = 0.3,
    scale = 0.98
  }
  param.title = param.tag
  local button = DYButton.createWithBMFont(param)
  button:setPosition(dy.xp(140, 220))
  self:addChild(button, 10)
  local param = {
    nImage = "gi_btn_common.png",
    pImage = "gi_btn_common.png",
    listener = cb,
    tag = "ensShatter",
    cached = true,
    size = cc.size(200, 90),
    color = cc.c3b(255, 255, 255),
    fScale = 0.3,
    scale = 0.98
  }
  param.title = param.tag
  local button = DYButton.createWithBMFont(param)
  button:setPosition(dy.xp(390, 220))
  self:addChild(button, 10)
  local param = {
    nImage = "gi_btn_common.png",
    pImage = "gi_btn_common.png",
    listener = cb,
    tag = "ensLightning",
    cached = true,
    size = cc.size(200, 90),
    color = cc.c3b(255, 255, 255),
    fScale = 0.3,
    scale = 0.98
  }
  param.title = param.tag
  local button = DYButton.createWithBMFont(param)
  button:setPosition(dy.xp(640, 220))
  self:addChild(button, 10)
  local param = {
    nImage = "gi_btn_common.png",
    pImage = "gi_btn_common.png",
    listener = cb,
    tag = "ensTail",
    cached = true,
    size = cc.size(200, 90),
    color = cc.c3b(255, 255, 255),
    fScale = 0.3,
    scale = 0.98
  }
  param.title = param.tag
  local button = DYButton.createWithBMFont(param)
  button:setPosition(dy.xp(890, 220))
  self:addChild(button, 10)
  local param = {
    nImage = "gi_btn_common.png",
    pImage = "gi_btn_common.png",
    listener = cb,
    tag = "ens2DShadow",
    cached = true,
    size = cc.size(200, 90),
    color = cc.c3b(255, 255, 255),
    fScale = 0.3,
    scale = 0.98
  }
  param.title = param.tag
  local button = DYButton.createWithBMFont(param)
  button:setPosition(dy.xp(1140, 220))
  self:addChild(button, 10)
  local param = {
    nImage = "gi_btn_common.png",
    pImage = "gi_btn_common.png",
    listener = cb,
    tag = "ensLaser",
    cached = true,
    size = cc.size(200, 90),
    color = cc.c3b(255, 255, 255),
    fScale = 0.3,
    scale = 0.98
  }
  param.title = param.tag
  local button = DYButton.createWithBMFont(param)
  button:setPosition(dy.xp(140, 120))
  self:addChild(button, 10)
end

local function runTestDownload(self)
  local console = self.mLabelConsole
  local url = "http://down.sandai.net/thunderspeed/ThunderSpeed1.0.29.322.exe"
  local path = DYUtils.cachePath()
  local title = string.format("%s => %s", url, path)
  console:setString(title)
  
  local function tFuncListener(event, total, now)
    local msg = title
    if event == dy.download.EVENT_PROGRESS then
      msg = msg .. "\n" .. string.format("[%d/%d   %.2f%%]", now, total, now * 100 / total)
    elseif event == dy.download.EVENT_SUCCESS then
      msg = msg .. "\n" .. "[SUCCESS]"
    elseif event == dy.download.EVENT_ERROR then
      msg = msg .. "\n" .. "[ERROR]"
    end
    console:setString(msg)
  end
  
  DYUtils.download(url, path, false, nil, tFuncListener)
end

local function runTestStatSet(self)
  local console = self.mLabelConsole
  local title = string.format("TEST STAT SET", url, path)
  console:setString(title)
  
  local function tFuncListener()
    local msg = title
    local key = "k_test_string"
    local val = "hello world"
    DYStat.setValueStr(key, val)
    msg = msg .. "\n" .. string.format("Will set [%s] to be [%s]", tostring(key), tostring(val))
    local key = "k_test_bool"
    local val = true
    DYStat.setValueBool(key, val)
    msg = msg .. "\n" .. string.format("Will set [%s] to be [%s]", tostring(key), tostring(val))
    local key = "k_test_int"
    local val = 99
    DYStat.setValueInt(key, val)
    msg = msg .. "\n" .. string.format("Will set [%s] to be [%s]", tostring(key), tostring(val))
    local key = "k_test_float"
    local val = 0.38
    DYStat.setValueFloat(key, val)
    msg = msg .. "\n" .. string.format("Will set [%s] to be [%s]", tostring(key), tostring(val))
    console:setString(msg)
  end
  
  tFuncListener()
end

local function runTestStatGet(self)
  local console = self.mLabelConsole
  local title = string.format("TEST STAT GET")
  console:setString(title)
  
  local function tFuncListener()
    local msg = title
    local key = "k_test_string"
    local val = DYStat.getValueStr(key, "")
    msg = msg .. "\n" .. string.format("Will get [%s] => [%s]", tostring(key), tostring(val))
    local key = "k_test_bool"
    local val = DYStat.getValueBool(key, false)
    msg = msg .. "\n" .. string.format("Will get [%s] => [%s]", tostring(key), tostring(val))
    local key = "k_test_int"
    local val = DYStat.getValueInt(key, 0)
    msg = msg .. "\n" .. string.format("Will get [%s] => [%s]", tostring(key), tostring(val))
    local key = "k_test_float"
    local val = DYStat.getValueFloat(key, 0)
    msg = msg .. "\n" .. string.format("Will get [%s] => [%s]", tostring(key), tostring(val))
    console:setString(msg)
  end
  
  tFuncListener()
end

local function runTestStatClear(self)
  local console = self.mLabelConsole
  local title = string.format("TEST STAT CLEAR")
  console:setString(title)
  
  local function tFuncListener()
    local msg = title
    local key = "k_test_string"
    DYStat.clear(key)
    msg = msg .. "\n" .. string.format("Will clear [%s]", tostring(key))
    local key = "k_test_bool"
    DYStat.clear(key)
    msg = msg .. "\n" .. string.format("Will clear [%s]", tostring(key))
    local key = "k_test_int"
    DYStat.clear(key)
    msg = msg .. "\n" .. string.format("Will clear [%s]", tostring(key))
    local key = "k_test_float"
    DYStat.clear(key)
    msg = msg .. "\n" .. string.format("Will clear [%s]", tostring(key))
    console:setString(msg)
  end
  
  tFuncListener()
end

local function runTestHotfix(self)
  local console = self.mLabelConsole
  local url = "http://xxxy.dayukeji.com/resource/package/1.3.1.160111-1.3.1.160111.1.zip"
  local path = DYUtils.cachePath()
  local title = string.format("%s => %s", url, path)
  console:setString(title)
  
  local function tFuncListener(event, total, now)
    local msg = title
    if event == dy.download.EVENT_PROGRESS then
      msg = msg .. "\n" .. string.format("[%d/%d   %.2f%%]", now, total, now * 100 / total)
    elseif event == dy.download.EVENT_SUCCESS then
      msg = msg .. "\n" .. "[SUCCESS]"
      self:performWithDelay(DYUtils.restartGame, 0)
    elseif event == dy.download.EVENT_ERROR then
      msg = msg .. "\n" .. "[ERROR]"
      self:performWithDelay(DYUtils.restartGame, 0)
    end
    console:setString(msg)
  end
  
  DYUtils.download(url, path, true, nil, tFuncListener)
end

local function runTestSuperAnim(self)
  local console = self.mLabelConsole
  console:setString([[
Super Animation Node 



]])
  local animNode = dy.AnimNode:create("demo_fish.sam")
  if animNode then
    self:addChild(animNode, 10)
    animNode:setPosition(dy.xp(640, 200))
    local ai = 1
    animNode:playSection("idle", true)
    
    local function tFunc(anData)
      DDLOG("onAnimEnd: " .. anData:getEvent() .. ", " .. anData:getName())
      ai = ai + 1
      if 5 < ai then
        animNode:runAction(cc.RemoveSelf:create())
        console:setString("CONSOLE")
      else
        animNode:playSection("idle", true)
      end
    end
    
    ScriptHandlerMgr:getInstance():registerScriptHandler(tolua.cast(animNode, "cc.Ref"), tFunc, cc.Handler.CALLFUNC)
  end
end

local function runTestUID(self)
  local console = self.mLabelConsole
  console:setString([[
UID of the DEVICE:

]] .. DYUtils.uniqueID())
end

local function runTestSchedule(self, sender)
  local console = self.mLabelConsole
  sender.index = 0
  sender.param.tag = "UNSCHEDULE"
  sender:getTitleLabel():setString(sender.param.tag)
  
  local function tFuncListener()
    sender.index = sender.index + 1
    console:setString("Schedule: " .. sender.index)
  end
  
  sender.schedule = DYUtils.schedule(tFuncListener, 0, -1)
end

local function runTestUnschedule(self, sender)
  local console = self.mLabelConsole
  sender.index = 0
  sender.param.tag = "SCHEDULE"
  sender:getTitleLabel():setString(sender.param.tag)
  DYUtils.unschedule(sender.schedule)
  sender.schedule = nil
end

local function runTestData(self, sender)
  local console = self.mLabelConsole
  sender.index = 0
  local msg = ""
  local td = DYCommon.getDataByTag(DYCommon.DB, "ID", "100101")
  msg = msg .. string.format("SIZE: %d\n", #td)
  msg = msg .. string.format("CONTENT: %s ...\n", string.sub(json.encode(td), 1, 10))
  console:setString(msg)
end

local function runTestSpriteHSL(self, sender)
  local layer = self.mLayerEns
  if layer == nil then
    layer = display.newLayer()
    self:addChild(layer, -10)
    self.mLayerEns = layer
  end
  local ptOrig = dy.xp(640, 360)
  local es = dy.SpriteHSL:create("demo_bg.jpg", false)
  es:setScale(2 * DYResolution.SCALE_MAX)
  es:setPosition(ptOrig)
  layer:addChild(es)
  
  local function onTouch(event, x, y)
    local dh = (x - ptOrig.x) * 100 / dy.dpx(640)
    es:setDH(dh)
    if event == "began" then
      return true
    elseif event == "moved" then
    elseif event == "ended" then
    end
  end
  
  layer:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    return onTouch(event.name, event.x, event.y)
  end)
end

local function runTestSpriteRipple(self, sender)
  local layer = self.mLayerEns
  if layer == nil then
    layer = display.newLayer()
    self:addChild(layer, -10)
    self.mLayerEns = layer
  end
  local ptOrig = dy.xp(640, 360)
  local es = dy.SpriteRipple:create("demo_bg.jpg", 8 / DYResolution.SCALE_MAX, false)
  es:setScale(2 * DYResolution.SCALE_MAX)
  es:setPosition(ptOrig)
  layer:addChild(es)
  
  local function onTouch(event, x, y)
    if event == "began" then
      local pt = dy.p(x, y)
      es:doTouch(pt, 512, 12)
      return true
    elseif event == "moved" then
      local pt = dy.p(x, y)
      es:doTouch(pt, 512, 12)
    elseif event == "ended" then
    end
  end
  
  layer:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    return onTouch(event.name, event.x, event.y)
  end)
end

local function runTestSpriteRippleH(self, sender)
  local layer = self.mLayerEns
  if layer == nil then
    layer = display.newLayer()
    self:addChild(layer, -10)
    self.mLayerEns = layer
  end
  local ptOrig = dy.xp(640, 360)
  local es = dy.SpriteRippleH:create("demo_bg.jpg", false)
  es:setScale(2 * DYResolution.SCALE_MAX)
  es:setPosition(ptOrig)
  layer:addChild(es)
  
  local function onTouch(event, x, y)
    if event == "began" then
      es:pressAtX(x, 15, 180)
      return true
    elseif event == "moved" then
      es:pressAtX(x, 0.8)
    elseif event == "ended" then
    end
  end
  
  layer:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    return onTouch(event.name, event.x, event.y)
  end)
end

local function runTestSpriteBreak(self, sender)
  local layer = self.mLayerEns
  if layer == nil then
    layer = display.newLayer()
    self:addChild(layer, -10)
    self.mLayerEns = layer
  end
  local ptOrig = dy.xp(640, 360)
  local es = dy.SpriteBreak:create("demo_bg.jpg", false)
  es:setScale(2 * DYResolution.SCALE_MAX)
  es:setPosition(ptOrig)
  layer:addChild(es)
  
  local function onTouch(event, x, y)
    if event == "began" then
      local eState = es:getState()
      if eState == dy.ens.BREAK_STATE_WELL then
        local pt = dy.p(x, y)
        es:doCrack(pt)
      elseif eState == dy.ens.BREAK_STATE_CRACK then
        es:generateDelayTimes(15)
        local act = dy.SpriteBreakFallOffAction:create(30)
        es:runAction(act)
      elseif eState == dy.ens.BREAK_STATE_FALL_OFF then
        es:reset()
      end
      return true
    elseif event == "moved" then
    elseif event == "ended" then
    end
  end
  
  layer:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    return onTouch(event.name, event.x, event.y)
  end)
end

local function runTestSpriteGhost(self, sender)
  local layer = self.mLayerEns
  if layer == nil then
    layer = display.newLayer()
    self:addChild(layer, -10)
    self.mLayerEns = layer
  end
  local ptOrig = dy.xp(640, 180)
  local ds = display.newSprite("demo_fish2.png")
  ds:setPosition(dy.p(ptOrig.x - 150, ptOrig.y))
  layer:addChild(ds, 10)
  ds:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.MoveBy:create(3, dy.p(0, 10)), cc.MoveBy:create(6, dy.p(0, -20)), cc.MoveBy:create(3, dy.p(0, 10)))))
  local es = dy.SpriteGhost:create("demo_fish2.png", 16, 0.5, false)
  es:setPosition(dy.p(ptOrig.x + 150, ptOrig.y))
  layer:addChild(es, 10)
  es:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.MoveBy:create(3, dy.p(0, 20)), cc.MoveBy:create(6, dy.p(0, -40)), cc.MoveBy:create(3, dy.p(0, 20)))))
end

local function runTestSpriteNM(self, sender)
  local layer = self.mLayerEns
  if layer == nil then
    layer = display.newLayer()
    self:addChild(layer, -10)
    self.mLayerEns = layer
  end
  local ptOrig = dy.xp(640, 200)
  local light = dy.SpriteLight:create("demo_light.png", false)
  light:setPosition(ptOrig)
  layer:addChild(light, 11)
  light:setZ(50)
  local es = dy.SpriteNM:create("demo_fish2.png", "demo_fish2_nm.png", false)
  es:setPosition(ptOrig)
  layer:addChild(es, 10)
  es:setLightSprite(light)
  es:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.MoveBy:create(1, dy.p(0, 20)), cc.MoveBy:create(2, dy.p(0, -40)), cc.MoveBy:create(1, dy.p(0, 20)))))
  
  local function onTouch(event, x, y)
    if event == "began" then
      return true
    elseif event == "moved" then
      light:setPosition(dy.p(x, y))
    elseif event == "ended" then
    end
  end
  
  layer:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    return onTouch(event.name, event.x, event.y)
  end)
end

local function runTestSpriteShatter(self, sender)
  local layer = self.mLayerEns
  if layer == nil then
    layer = display.newLayer()
    self:addChild(layer, -10)
    self.mLayerEns = layer
  end
  local ptOrig = dy.xp(640, 200)
  local es = dy.SpriteShatter:create("demo_fish2.png", 8, false)
  es:setPosition(ptOrig)
  es:setBlowAnchor(cc.p(0.1, 0.5))
  es:setBlowRadius(300)
  layer:addChild(es, 10)
  
  local function onTouch(event, x, y)
    if event == "began" then
      es:setOpacity(0)
      es:stopAllActions()
      es:runAction(dy.SpriteShatterAction:create(4))
      return true
    elseif event == "moved" then
    elseif event == "ended" then
    end
  end
  
  layer:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    return onTouch(event.name, event.x, event.y)
  end)
end

local function runTestSpriteLightning(self, sender)
  local layer = self.mLayerEns
  if layer == nil then
    layer = display.newLayer()
    self:addChild(layer, -10)
    self.mLayerEns = layer
  end
  local ptOrig = dy.xp(640, 100)
  local es = dy.SpriteLightning:create(dy.xp(0, 0), ptOrig)
  layer:addChild(es, 10)
  
  local function tFunc()
    es:runAction(cc.RemoveSelf:create())
    es = nil
  end
  
  es:runFlashAction(1000000, cc.CallFunc:create(tFunc))
  
  local function onTouch(event, x, y)
    if es then
      es:setStart(dy.p(x, y))
    end
    if event == "began" then
      return true
    elseif event == "moved" then
    elseif event == "ended" then
    end
  end
  
  layer:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    return onTouch(event.name, event.x, event.y)
  end)
end

local function runTestSpriteTail(self, sender)
  local layer = self.mLayerEns
  if layer == nil then
    layer = display.newLayer()
    self:addChild(layer, -10)
    self.mLayerEns = layer
  end
  local ptOrig = dy.xp(640, 100)
  local tailList = {}
  
  local function onTouch(event, x, y)
    if event == "began" then
      local es = dy.SpriteTail:create("demo_bg.jpg", false)
      es:setPosition(dy.p(x, y))
      layer:addChild(es, 10)
      es:setMinDis(14)
      table.insert(tailList, es)
      return true
    elseif event == "moved" then
      local tailCnt = #tailList
      if 0 < tailCnt then
        tailList[tailCnt]:setPosition(dy.p(x, y))
      end
    elseif event == "ended" then
    end
  end
  
  layer:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    return onTouch(event.name, event.x, event.y)
  end)
end

local function runTest2DShadow(self, sender)
  local layer = self.mLayerEns
  if layer == nil then
    layer = display.newLayer()
    self:addChild(layer, 10)
    self.mLayerEns = layer
  end
  local ptOrig = dy.xp(640, 100)
  local ds = display.newSprite("demo_fish2.png")
  ds:setPosition(dy.xp(640, 360))
  layer:addChild(ds)
  local root = dy.NodeShadowRoot:create()
  root:setShadowDarkness(0.4)
  layer:addChild(root)
  local nl = dy.NodeLight:create(48)
  root:setLight(nl)
  local ns1 = dy.NodeShadow:createRegular(84, 36)
  ns1:setLight(nl)
  root:addObj(ns1)
  ns1:setPosition(dy.xp(640, 360))
  
  local function onTouch(event, x, y)
    nl:setPosition(dy.p(x, y))
    if event == "began" then
      return true
    elseif event == "moved" then
    elseif event == "ended" then
    end
  end
  
  layer:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    return onTouch(event.name, event.x, event.y)
  end)
end

local function runTestLaser(self, sender)
  local layer = self.mLayerEns
  if layer == nil then
    layer = display.newLayer()
    self:addChild(layer, -1)
    self.mLayerEns = layer
  end
  local ptOrig = dy.xp(640, 100)
  local es = dy.NodeLaser:create()
  es:setStart(dy.xp(640, 0))
  es:setEnd(dy.xp(640, 720))
  layer:addChild(es)
  
  local function onTouch(event, x, y)
    es:setStart(dy.p(x, y))
    if event == "began" then
      return true
    elseif event == "moved" then
    elseif event == "ended" then
    end
  end
  
  layer:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    return onTouch(event.name, event.x, event.y)
  end)
  sender:runAction(DYShake:create(5, 5))
  local scene = display.newScene()
  local panel = import("LayerTestCCB").new()
  scene:addChild(panel)
  display.replaceScene(scene)
end

function M:buttonListener(tag, sender)
  DDLOG("buttonListener: " .. tag)
  self.mTestIndex = self.mTestIndex + 1
  if tag == "DOWNLOAD" then
    runTestDownload(self)
  elseif tag == "SET" then
    runTestStatSet(self)
  elseif tag == "GET" then
    runTestStatGet(self)
  elseif tag == "CLEAR" then
    runTestStatClear(self)
  elseif tag == "HOTFIX" then
    runTestHotfix(self)
  elseif tag == "SAC" then
    runTestSuperAnim(self)
  elseif tag == "UID" then
    runTestUID(self)
  elseif tag == "SCHEDULE" then
    runTestSchedule(self, sender)
  elseif tag == "UNSCHEDULE" then
    runTestUnschedule(self, sender)
  elseif tag == "DATA" then
    runTestData(self, sender)
  elseif tag == "ensHSL" then
    runTestSpriteHSL(self, sender)
  elseif tag == "ensRipple" then
    runTestSpriteRipple(self, sender)
  elseif tag == "ensBreak" then
    runTestSpriteBreak(self, sender)
  elseif tag == "ensGhost" then
    runTestSpriteGhost(self, sender)
  elseif tag == "ensNormalMap" then
    runTestSpriteNM(self, sender)
  elseif tag == "ensRippleH" then
    runTestSpriteRippleH(self, sender)
  elseif tag == "ensShatter" then
    runTestSpriteShatter(self, sender)
  elseif tag == "ensLightning" then
    runTestSpriteLightning(self, sender)
  elseif tag == "ensTail" then
    runTestSpriteTail(self, sender)
  elseif tag == "ens2DShadow" then
    runTest2DShadow(self, sender)
  elseif tag == "ensLaser" then
    runTestLaser(self, sender)
  elseif tag == "ensReset" and self.mLayerEns then
    self.mLayerEns:runAction(cc.RemoveSelf:create())
    self.mLayerEns = nil
  end
end

return M
