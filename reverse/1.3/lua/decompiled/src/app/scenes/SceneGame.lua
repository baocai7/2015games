local CLASS_NAME = "SceneGame"
local M = {}
M = class(CLASS_NAME, function()
  return display.newScene(CLASS_NAME)
end)
M.MODE_TEST1 = 1
M.MODE_TEST2 = 2

function M:ctor(mode)
  DDLOG(CLASS_NAME .. ": onCreate")
  self.mGameMode = mode
  self:layoutUI()
end

function M:onEnter()
  DDLOG(CLASS_NAME .. ": onEnter")
end

function M:onExit()
  DDLOG(CLASS_NAME .. ": onExit")
end

function M:layoutUI()
  local tFuncGentGame = {
    [M.MODE_TEST1] = function()
      DDLOG("create game layer1")
      return require("app.layers.LayerTest1Game").new()
    end,
    [M.MODE_TEST2] = function()
      DDLOG("create game layer2")
    end
  }
  local layer = tFuncGentGame[self.mGameMode]()
  layer:addTo(self)
end

return M
