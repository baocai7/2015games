local CimeliaRangeTrips = require("app.sprites.CimeliaRangeTips")
local DYScene = "TestScene"
local M = {}
M = class(DYScene, function()
  return display.newScene(DYScene)
end)

function M:ctor()
  self:loadConfig()
  cc.Director:getInstance():getScheduler():setTimeScale(1.3)
  self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, function(dt)
    self:updateFrame(dt)
  end)
  self:scheduleUpdate()
  DYComponent = DYComponent or require("app.component.ComponetMgr")
  self._LayerGame = self:createLayer()
  self._LayerTouch = self:createLayer()
  self._LayerBg = display.newSprite("buff/night.png"):pos(display.cx, display.cy):addTo(self)
  self:addChild(self._LayerGame, Const.Layer.LAYER_GAME)
  self:addChild(self._LayerTouch, Const.Layer.LAYER_TOUCH)
  BMgr.init()
  local label = cc.LabelTTF:create("loading...", "Courier New", 16)
  label:setColor(cc.c3b(255, 255, 255))
  label:setPosition(display.cx, display.top - 10)
  self:addChild(label)
  self.label = label
  for i = 1, 50 do
    local x = i % 26
    local y = math.modf(i / 26)
    local model = DataUtils.getBuddhaModel(tostring(i + 1000))
    local tmpLoc = model.npcIcon
    local sprite = display.newSprite(tmpLoc)
    sprite:setTouchEnabled(true)
    sprite:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
      return self:onTouch(event, tostring(i + 1000))
    end)
    sprite:setAnchorPoint(cc.p(0, 0))
    sprite:setScale(0.4)
    sprite:setPosition(cc.p(x * 48, y * 48))
    self._LayerTouch:addChild(sprite)
  end
  for i = 1, 50 do
    local x = i % 26
    local y = math.modf(i / 26)
    local model = DataUtils.getBuddhaModel(tostring(i + 1000))
    local tmpLoc = model.npcIcon
    local sprite = display.newSprite(tmpLoc)
    sprite:setTouchEnabled(true)
    sprite:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
      return self:onEnyTouch(event, tostring(i + 1000))
    end)
    sprite:setScale(0.4)
    sprite:setAnchorPoint(cc.p(0, 0))
    sprite:setPosition(cc.p(x * 48, 600 + y * 48))
    self._LayerTouch:addChild(sprite)
  end
  self.mKeypadListener = handler(self, self.onKeypad)
end

function M:updateFrame(dt)
  local str = DYLang.getString("S1427", "")
  self.label:setString(string.format(str, #BMgr.getBuddhaList() + #BMgr.getMonsterList()))
  self.label:setPosition(display.cx, display.top - 10)
end

function M:onTouch(event, i)
  BMgr.createBuddha(self._LayerGame, i, cc.p(900, 120), 1)
end

function M:onEnyTouch(event, i)
  BMgr.createMonster2(self._LayerGame, i, cc.p(cc.p(300, 120)))
end

function M:loadConfig()
  display.addSpriteFrames("animation/dadouyanwu.plist", "animation/dadouyanwu.png")
  display.addSpriteFrames("animation/difangsiwangyan.plist", "animation/difangsiwangyan.png")
  display.addSpriteFrames("animation/wofangsiwangyan.plist", "animation/wofangsiwangyan.png")
  display.addSpriteFrames("animation/siwanglinghun.plist", "animation/siwanglinghun.png")
  display.addSpriteFrames("animation/lingqi.plist", "animation/lingqi.png")
  display.addSpriteFrames("animation/shengli_xingxing.plist", "animation/shengli_xingxing.png")
  display.addSpriteFrames("buff/buffball.plist", "buff/buffball.png")
  display.addSpriteFrames("buff/lianhua.plist", "buff/lianhua.png")
  display.addSpriteFrames("buff/wandPic.plist", "buff/wandPic.png")
  display.addSpriteFrames("buff/specialArea.plist", "buff/specialArea.png")
  display.addSpriteFrames("buff/buff_aberrant.plist", "buff/buff_aberrant.png")
  display.addSpriteFrames("buff/buff_atk_def.plist", "buff/buff_atk_def.png")
  display.addSpriteFrames("buff/buff_gain.plist", "buff/buff_gain.png")
  display.addSpriteFrames("buff/buff_effect.plist", "buff/buff_effect.png")
end

function M:onEnter()
  DYKeypadMgr.regKeyHandler(self.mKeypadListener)
end

function M:onExit()
  DYKeypadMgr.unregKeyHandler(self.mKeypadListener)
  BMgr.killSelf()
end

function M:onKeypad(keyCode, event)
  DDLOG("Key %d was on pressed!", keyCode)
  if keyCode == cc.KeyCode.KEY_ESCAPE then
    display.replaceScene(require("app.scenes.ChapterScene").new())
  end
  local sprite = clone(BMgr.getBuddhaList())
  if keyCode == 77 then
    self:listAddBuff(sprite, 1006, 0, 5, 2)
  end
  if keyCode == 78 then
    self:listAddBuff(sprite, 1007, 0, 10, -1)
  end
  if keyCode == 79 then
    self:listAddBuff(sprite, 1008, 0, 10, 1)
  end
  if keyCode == 80 then
    self:listAddBuff(sprite, 1017, 0, 5, 10)
  end
  if keyCode == 81 then
    self:listAddBuff(sprite, 1018, 0, 5, 10)
  end
  if keyCode == 82 then
    self:listAddBuff(sprite, 1019, 0, 5, 10)
  end
  if keyCode == 83 then
    self:listAddBuff(sprite, 122, 0, 5, 10)
  end
  if keyCode == 84 then
    self:listAddBuff(sprite, 124, 0, 5, 0)
  end
  if keyCode == 85 then
    self:listAddBuff(sprite, 101, 0, 5, 0)
  end
  if keyCode == 76 then
    sprite = clone(BMgr.getMonsterList())
    self:listAddBuff(sprite, 1004, 0, 5, 5)
  end
  return true
end

function M:listAddBuff(sprites, buffid, dt, time, effect)
  for k, v in pairs(sprites) do
    v:addBuff(v, buffid, dt, time, effect)
  end
end

function M:createLayer()
  return display.newLayer()
end

function M:onConnect()
  if self.websocket then
    return
  end
  self.websocket = WebSockets.new("ws://139.129.16.141:8080")
  self.websocket:addEventListener(WebSockets.OPEN_EVENT, handler(self, self.onOpen))
  self.websocket:addEventListener(WebSockets.MESSAGE_EVENT, handler(self, self.onMessage))
  self.websocket:addEventListener(WebSockets.CLOSE_EVENT, handler(self, self.onClose))
  self.websocket:addEventListener(WebSockets.ERROR_EVENT, handler(self, self.onError))
end

function M:onSendText(parm)
  if not self.websocket then
    print("not connected")
    return
  end
  if self.websocket:send(json.encode(parm)) then
  end
end

function M:onMessage(event)
  local abc = json.decode(event.message)
  if WebSockets.BINARY_MESSAGE == event.messageType then
    printf("receive binary msg: len = %s, binary = %s", string.len(event.message), bin2hex(event.message))
  else
  end
  if abc.ev == "attack" then
    print("ready to chubing")
    self:onEnyTouch(nil, abc.actorID)
  end
end

function M:onClose(event)
  self.websocket = nil
end

function M:onError(event)
  printf("error %s", event.error)
  self.websocket = nil
end

return M
