local M = {}
local mKeyHandlerStack, mKeyboardListener

local function onKeypadClicked(keyCode, event)
  local stack = mKeyHandlerStack:copy()
  while stack:getn() > 0 do
    local handler = stack:top()
    local flag = handler(keyCode, event)
    if flag == true then
      return
    end
    stack:pop()
  end
end

local S_KEYPAD

local function init()
  if mKeyboardListener == nil then
    if S_KEYPAD == nil then
      S_KEYPAD = display.newNode()
      S_KEYPAD:retain()
    end
    local listener = cc.EventListenerKeyboard:create()
    listener:registerScriptHandler(onKeypadClicked, cc.Handler.EVENT_KEYBOARD_RELEASED)
    local eventDispatcher = S_KEYPAD:getEventDispatcher()
    eventDispatcher:addEventListenerWithFixedPriority(listener, 1)
    DDLOG("DYKeypadMgr, init OK")
    mKeyHandlerStack = DYStack:create()
    mKeyboardListener = listener
  else
    DDLOG("DYKeypadMgr, already inited...")
  end
end

init()

function M.uninit()
  if mKeyboardListener then
    S_KEYPAD:getEventDispatcher():removeEventListener(mKeyboardListener)
    S_KEYPAD:release()
    S_KEYPAD = nil
    mKeyHandlerStack = DYStack:create()
    mKeyboardListener = nil
    DDLOG("DYKeypadMgr, uninit OK")
  else
    DDLOG("DYKeypadMgr, already uninited...")
  end
end

function M.regKeyHandler(handler)
  if handler == nil then
    DDLOG("DYKeypadMgr, handler is nil")
    return false
  end
  local top = mKeyHandlerStack:top()
  if top == handler then
    DDLOG("DYKeypadMgr, handler already in stack")
    return false
  end
  mKeyHandlerStack:push(handler)
  DDLOG("DYKeypadMgr, regKeyHandler ok, stack len: %d", mKeyHandlerStack:getn())
  return true
end

function M.unregKeyHandler(handler)
  if handler == nil then
    DDLOG("DYKeypadMgr, handler is nil")
    return false
  end
  local top = mKeyHandlerStack:top()
  if top ~= handler then
    DDLOG("DYKeypadMgr, handler to be unreg is not top")
    DDLOG("DYKeypadMgr, handle the exception, check the stack and get rid of the very handler, stack len: %d", mKeyHandlerStack:getn())
    local stack = mKeyHandlerStack
    local tmpStack = DYStack:create()
    while stack:getn() > 0 do
      local topHandler = stack:top()
      if topHandler == handler then
        DDLOG("DYKeypadMgr, find the exception, remove it. tmpStack len: %d", tmpStack:getn())
        stack:pop()
        break
      else
        tmpStack:push(topHandler)
        stack:pop()
      end
    end
    while tmpStack:getn() > 0 do
      local topHandler = tmpStack:top()
      stack:push(topHandler)
      tmpStack:pop()
    end
    DDLOG("DYKeypadMgr, after processexception, stack len: %d", mKeyHandlerStack:getn())
    return true
  end
  mKeyHandlerStack:pop()
  DDLOG("DYKeypadMgr, unregKeyHandler ok, stack len: %d", mKeyHandlerStack:getn())
  return true
end

function M.regKeyHandlerOnTarget(parent, target, callback, event)
  local listener = cc.EventListenerKeyboard:create()
  listener:registerScriptHandler(callback, event)
  local eventDispatcher = parent:getEventDispatcher()
  eventDispatcher:addEventListenerWithSceneGraphPriority(listener, target)
end

return M
