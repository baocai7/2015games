require("demo.init")
local M = class("MyApp", cc.mvc.AppBase)

function M:ctor()
  M.super.ctor(self)
end

function M:run()
  DYResolution.init(1280, 720)
  DYResolution.resetDisplayParam()
  local scene = require("MainScene").new()
  display.replaceScene(scene)
  DYUtils.hideLoading()
end

function M:test()
end

return M
