local CURRENT_MODULE_NAME = (...)

function DDLOG(fmt, ...)
  printLog("DEBUG", fmt, ...)
end

function DDINFO(fmt, ...)
  printInfo(fmt, ...)
end

function DDERROR(fmt, ...)
  printError(fmt, ...)
end

print("===========================================================")
print("              LOAD DYGAME FRAMEWORK")
print("===========================================================")
dy = dy or {}
dy.PACKAGE_NAME = string.sub(CURRENT_MODULE_NAME, 1, -6)
require("framework.cc.utils.bit")
require(dy.PACKAGE_NAME .. ".utils.DYConst")
require(dy.PACKAGE_NAME .. ".utils.DYExtends")
DYStack = require(dy.PACKAGE_NAME .. ".utils.DYStack")
DYStat = require(dy.PACKAGE_NAME .. ".utils.DYStat")
DYMem = require(dy.PACKAGE_NAME .. ".utils.DYMem")
DYRes = require(dy.PACKAGE_NAME .. ".utils.DYRes")
DYNotification = require(dy.PACKAGE_NAME .. ".utils.DYNotification")
DYUtils = require(dy.PACKAGE_NAME .. ".utils.DYUtils")
DYSprite = require(dy.PACKAGE_NAME .. ".utils.DYSprite")
DYResolution = require(dy.PACKAGE_NAME .. ".utils.DYResolution")
DYLang = require(dy.PACKAGE_NAME .. ".utils.DYLang")
DYProfile = require(dy.PACKAGE_NAME .. ".utils.DYProfile")
DYRandomSeq = require(dy.PACKAGE_NAME .. ".utils.DYRandomSeq")
DYUnitBase = require(dy.PACKAGE_NAME .. ".units.DYUnitBase")
DYBoxLayout = require(dy.PACKAGE_NAME .. ".ui.DYBoxLayout")
DYButton = require(dy.PACKAGE_NAME .. ".ui.DYButton")
DYCheckBoxButton = require(dy.PACKAGE_NAME .. ".ui.DYCheckBoxButton")
DYCheckBoxButtonGroup = require(dy.PACKAGE_NAME .. ".ui.DYCheckBoxButtonGroup")
DYGroup = require(dy.PACKAGE_NAME .. ".ui.DYGroup")
DYImage = require(dy.PACKAGE_NAME .. ".ui.DYImage")
DYInput = require(dy.PACKAGE_NAME .. ".ui.DYInput")
DYLabel = require(dy.PACKAGE_NAME .. ".ui.DYLabel")
DYLabelTTF = require(dy.PACKAGE_NAME .. ".ui.DYLabelTTF")
DYLayout = require(dy.PACKAGE_NAME .. ".ui.DYLayout")
DYListView = require(dy.PACKAGE_NAME .. ".ui.DYListView")
DYListViewItem = require(dy.PACKAGE_NAME .. ".ui.DYListViewItem")
DYLoadingBar = require(dy.PACKAGE_NAME .. ".ui.DYLoadingBar")
DYPageView = require(dy.PACKAGE_NAME .. ".ui.DYPageView")
DYPageViewItem = require(dy.PACKAGE_NAME .. ".ui.DYPageViewItem")
DYPushButton = require(dy.PACKAGE_NAME .. ".ui.DYPushButton")
DYRichTextUI = require(dy.PACKAGE_NAME .. ".ui.DYRichTextUI")
DYScrollView = require(dy.PACKAGE_NAME .. ".ui.DYScrollView")
DYShake = require(dy.PACKAGE_NAME .. ".ui.DYShake")
DYRollnum = require(dy.PACKAGE_NAME .. ".ui.DYRollnum")
DYSlider = require(dy.PACKAGE_NAME .. ".ui.DYSlider")
DYStretch = require(dy.PACKAGE_NAME .. ".ui.DYStretch")
DYProgress = require(dy.PACKAGE_NAME .. ".ui.DYProgress")
DYTouchMaskLayer = require(dy.PACKAGE_NAME .. ".ui.DYTouchMaskLayer")
DYToast = require(dy.PACKAGE_NAME .. ".ui.DYToast")
DY_KEY = require(dy.PACKAGE_NAME .. ".common.DY_KEY")
DY_SND = require(dy.PACKAGE_NAME .. ".common.DY_SND")
DYCommon = require(dy.PACKAGE_NAME .. ".common.DYCommon")
DYAnalyze = require(dy.PACKAGE_NAME .. ".common.DYAnalyze")
DYPushMgr = require(dy.PACKAGE_NAME .. ".common.DYPushMgr")
DYHttpMgr = require(dy.PACKAGE_NAME .. ".common.DYHttpMgr")
DYSoundMgr = require(dy.PACKAGE_NAME .. ".common.DYSoundMgr")
DYKeypadMgr = require(dy.PACKAGE_NAME .. ".common.DYKeypadMgr")
DYIAPMgr = require(dy.PACKAGE_NAME .. ".common.DYIAPMgr")
DYLoginMgr = require(dy.PACKAGE_NAME .. ".common.DYLoginMgr")
DYFavMgr = require(dy.PACKAGE_NAME .. ".common.DYFavMgr")
DYShareMgr = require(dy.PACKAGE_NAME .. ".common.DYShareMgr")
require(dy.PACKAGE_NAME .. ".demo.DYDemoScene")

function DDTRACE(errorLabel, errorMsg)
  local errorStack = ""
  errorStack = errorStack .. errorLabel .. tostring(errorMsg) .. "\n"
  errorStack = errorStack .. debug.traceback("", 2)
  if dy.ERROR_LIST then
    local error = {label = errorLabel, log = errorStack}
    table.insert(dy.ERROR_LIST, error)
  end
end

function display.newAnimation(frames, time)
  if not frames then
    frames = {}
    frames[#frames + 1] = display.newSprite("gi_trans.png"):getSpriteFrame()
  end
  local count = #frames
  time = time or 1 / count
  return cc.Animation:createWithSpriteFrames(frames, time)
end

if DEBUG_PROFILE then
  local function showProfileInfo()
    DYProfile.dump()
  end
  
  DYProfile.init()
  DYUtils.schedule(showProfileInfo, DEBUG_PROFILE_INTERVAL or 10, -1)
  local node = DYUtils.getTopNode()
  node:removeAllChildren()
  local label = cc.Label:create()
  label:setSystemFontSize(20)
  label:setAnchorPoint(cc.p(0, 0.5))
  label:setPosition(cc.p(0, 90))
  node:addChild(label)
  
  local function showMemoryUsage()
    local msg = ""
    local mem = collectgarbage("count")
    if dy.Common.getCachedTextureSize then
      msg = string.format("Memory[LV]: %0.2f MB\n", mem / 1024)
      mem = (dy.Common:getCachedTextureSize() / 1024 + mem) / 1024
      msg = msg .. string.format("Memory: %0.2f MB", mem)
    else
      mem = (0 + mem) / 1024
      msg = string.format("Memory[LV]: %0.2f MB", mem)
    end
    label:setString(msg)
    label:performWithDelay(showMemoryUsage, 1)
  end
  
  label:performWithDelay(showMemoryUsage, 1)
end
dy = dy or {}
dy.ERROR_LIST = dy.ERROR_LIST or {}
do
  local node = DYUtils.getTopNode()
  if node.mReportErrorWatcher then
    node:removeChild(node.mReportErrorWatcher, true)
    node.mReportErrorWatcher = nil
  end
  local watcher = display.newNode()
  if watcher then
    node.mReportErrorWatcher = watcher
    watcher:addTo(node)
    
    local function tFuncReportError()
      if #dy.ERROR_LIST > 0 then
        local error = dy.ERROR_LIST[1]
        table.remove(dy.ERROR_LIST, 1)
        DYCommon.reportError(error.label, error.log)
        if DYAnalyze and DYAnalyze.agent and DYAnalyze.agent.reportError then
          DYAnalyze.agent.reportError(error.label, error.log)
        end
      end
      watcher:performWithDelay(tFuncReportError, 0.1)
    end
    
    watcher:performWithDelay(tFuncReportError, 0.1)
  end
end
print("#")
