local M = {}
local SCALE_X, SCALE_Y, REF_WIDTH, REF_HEIGHT, DES_WIDTH, DES_HEIGHT
M.SCALE_MIN = 1
M.SCALE_MAX = 1
dy = dy or {}

function dy.p(x, y)
  return cc.p(x, y)
end

function dy.xp(x, y)
  local tx = x * SCALE_X
  local ty = y * SCALE_Y
  return cc.p(tx, ty)
end

function dy.dpx(x)
  local tx = x * SCALE_X
  return tx
end

function dy.dpy(y)
  local ty = y * SCALE_Y
  return ty
end

function dy.dp(x, y)
  local tx = x / SCALE_X
  local ty = y / SCALE_Y
  return cc.p(tx, ty)
end

function dy.sp(fontSize)
  return fontSize / cc.Director:getInstance():getContentScaleFactor()
end

function M.init(wd, hi)
  REF_WIDTH = wd
  REF_HEIGHT = hi
  M.SCALE_MIN = 1
  M.SCALE_MAX = 1
  DES_WIDTH = REF_WIDTH
  DES_HEIGHT = REF_HEIGHT
  local glView = cc.Director:getInstance():getOpenGLView()
  local frameSize = glView:getFrameSize()
  local scaleX = frameSize.width / REF_WIDTH
  local scaleY = frameSize.height / REF_HEIGHT
  M.SCALE_MAX = math.max(scaleX, scaleY)
  M.SCALE_MIN = math.min(scaleX, scaleY)
  DES_HEIGHT = frameSize.height / M.SCALE_MIN
  DES_WIDTH = frameSize.width / M.SCALE_MIN
  SCALE_X = DES_WIDTH / REF_WIDTH
  SCALE_Y = DES_HEIGHT / REF_HEIGHT
  M.SCALE_MAX = math.max(SCALE_X, SCALE_Y)
  M.SCALE_MIN = math.min(SCALE_X, SCALE_Y)
  DDLOG("DES_WIDTH_HEIGHT = (%f, %f)", DES_WIDTH, DES_HEIGHT)
  glView:setDesignResolutionSize(DES_WIDTH, DES_HEIGHT, cc.ResolutionPolicy.SHOW_ALL)
end

function M.resetDisplayParam()
  local winSize = cc.Director:getInstance():getWinSize()
  display.size = {
    width = winSize.width,
    height = winSize.height
  }
  display.width = display.size.width
  display.height = display.size.height
  display.cx = display.width / 2
  display.cy = display.height / 2
  display.c_left = -display.width / 2
  display.c_right = display.width / 2
  display.c_top = display.height / 2
  display.c_bottom = -display.height / 2
  display.left = 0
  display.right = display.width
  display.top = display.height
  display.bottom = 0
  printInfo(string.format("# CONFIG_SCREEN_AUTOSCALE      = %s", CONFIG_SCREEN_AUTOSCALE))
  printInfo(string.format("# CONFIG_SCREEN_WIDTH          = %0.2f", CONFIG_SCREEN_WIDTH))
  printInfo(string.format("# CONFIG_SCREEN_HEIGHT         = %0.2f", CONFIG_SCREEN_HEIGHT))
  printInfo(string.format("# display.widthInPixels        = %0.2f", display.widthInPixels))
  printInfo(string.format("# display.heightInPixels       = %0.2f", display.heightInPixels))
  printInfo(string.format("# display.contentScaleFactor   = %0.2f", display.contentScaleFactor))
  printInfo(string.format("# display.width                = %0.2f", display.width))
  printInfo(string.format("# display.height               = %0.2f", display.height))
  printInfo(string.format("# display.cx                   = %0.2f", display.cx))
  printInfo(string.format("# display.cy                   = %0.2f", display.cy))
  printInfo(string.format("# display.left                 = %0.2f", display.left))
  printInfo(string.format("# display.right                = %0.2f", display.right))
  printInfo(string.format("# display.top                  = %0.2f", display.top))
  printInfo(string.format("# display.bottom               = %0.2f", display.bottom))
  printInfo(string.format("# display.c_left               = %0.2f", display.c_left))
  printInfo(string.format("# display.c_right              = %0.2f", display.c_right))
  printInfo(string.format("# display.c_top                = %0.2f", display.c_top))
  printInfo(string.format("# display.c_bottom             = %0.2f", display.c_bottom))
  printInfo("#")
end

return M
