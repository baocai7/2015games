require("app.init")
local M = class("MyApp", cc.mvc.AppBase)

function M:ctor()
  M.super.ctor(self)
end

local M_correctDisplay

function M:run()
  DYResolution.init(1280, 720)
  M_correctDisplay()
  DYResolution.resetDisplayParam()
  self:retainForDebug()
  local scene = require("app.layers.LayerBoot").scene()
  display.replaceScene(scene)
  self:lazyInit()
  DYShareMgr.init()
end

function M:retainForDebug()
  if DYUtils.gameMode() ~= "debug" then
    return
  end
  local shine = cc.Director:getInstance():getTextureCache():getTextureForKey("shine")
  if shine ~= nil then
    shine:retain()
  end
  local play_background = cc.Director:getInstance():getTextureCache():getTextureForKey("play_background")
  if play_background ~= nil then
    play_background:retain()
  end
  local play_enable = cc.Director:getInstance():getTextureCache():getTextureForKey("play_enable")
  if play_enable ~= nil then
    play_enable:retain()
  end
  local cc_2x2_white_image = cc.Director:getInstance():getTextureCache():getTextureForKey("cc_2x2_white_image")
  if cc_2x2_white_image ~= nil then
    cc_2x2_white_image:retain()
  end
end

function M:lazyInit()
  local function tFuncInit()
    local t = {}
    
    local tLazyRes = {
      "chapter/wukong/zhuchangjing1.csb",
      "chapter/xiongmao/zhuchangjing2.csb",
      "chapter/pvp/zhuchangjing3.csb",
      "chapter/fangzi/zhuchangjing4.csb",
      "chapter/tang/zhuchangjing5.csb",
      "chapter/bajie/zhuchangjing6.csb",
      "chapter/longma/zhuchangjing7.csb",
      "chapter/package/zhuchangjing8.csb",
      "chapter/leaves1/zhuchangjing9.csb",
      "chapter/leaves2/zhuchangjing10.csb",
      "chapter/leaves3/zhuchangjing11.csb",
      "chapter/ball/zhuchangjing12.csb",
      "loading/tiny/huanchonghouzi.csb"
    }
    for i = 1, #tLazyRes do
      DYRes.loadFileInfo(tLazyRes[i], t)
    end
    DYPushMgr.init()
    DYUtils.hideLoading()
  end
  
  DYUtils.schedule(tFuncInit, 0, 1)
end

function M_correctDisplay()
  PRINT_DEPRECATED("!!!Attention: Use DLResolution.init instead!")
  local sharedDirector = cc.Director:getInstance()
  local glview = sharedDirector:getOpenGLView()
  if nil == glview then
    glview = cc.GLViewImpl:createWithRect("QuickCocos", cc.rect(0, 0, CONFIG_SCREEN_WIDTH or 900, CONFIG_SCREEN_HEIGHT or 640))
    sharedDirector:setOpenGLView(glview)
  end
  local size = glview:getFrameSize()
  display.sizeInPixels = {
    width = size.width,
    height = size.height
  }
  local w = display.sizeInPixels.width
  local h = display.sizeInPixels.height
  if CONFIG_SCREEN_WIDTH == nil or CONFIG_SCREEN_HEIGHT == nil then
    CONFIG_SCREEN_WIDTH = w
    CONFIG_SCREEN_HEIGHT = h
  end
  local ratio = w / h
  if ratio < 1.5 then
    glview:setDesignResolutionSize(1080, 720, cc.ResolutionPolicy.EXACT_FIT)
  else
    glview:setDesignResolutionSize(720 * ratio, 720, cc.ResolutionPolicy.NO_BORDER)
  end
end

return M
