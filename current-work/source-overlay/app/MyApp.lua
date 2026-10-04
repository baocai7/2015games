
require("config")
require("cocos.init")
require("framework.init")

local CompatTrace = import("utils.CompatTrace")

local MyApp = class("MyApp", cc.mvc.AppBase)

function MyApp:ctor()
    MyApp.super.ctor(self)
    math.newrandomseed()
end


function MyApp:run()

    CompatTrace.install()

    -- 防止调试时出现引擎资源被释放的问题
    local shine = cc.Director:getInstance():getTextureCache():getTextureForKey("play_background")
    if(shine~=nil) then
        shine:retain()
    end
    
    local play_background = cc.Director:getInstance():getTextureCache():getTextureForKey("play_background")
    if(play_background~=nil) then
        play_background:retain()
    end
    
    local play_enable = cc.Director:getInstance():getTextureCache():getTextureForKey("play_enable")
    if(play_enable~=nil) then
        play_enable:retain()
    end
    
    local cc_2x2_white_image = cc.Director:getInstance():getTextureCache():getTextureForKey("cc_2x2_white_image")
    if(cc_2x2_white_image~=nil) then
        cc_2x2_white_image:retain()
    end
    
    -- release dlc[debug so 不起作用]
    cc.FileUtils:getInstance():addSearchPath(device.writablePath.."dlc/".."resources/")
    cc.FileUtils:getInstance():addSearchPath(device.writablePath.."dlc/".."scripts/")
    cc.FileUtils:getInstance():addSearchPath(device.writablePath.."dlc/".."scripts/app/")
    
    -- debug dlc[不确定relese so有没有用?]
    cc.FileUtils:getInstance():addSearchPath("../dlc/".."resources/")
    cc.FileUtils:getInstance():addSearchPath("../dlc/".."scripts/")
    cc.FileUtils:getInstance():addSearchPath("../dlc/".."scripts/app/")
    
    -- [debug时，路径为com.bftx.journeywestlua/debugruntime/res]
    -- [relese时，路径为res]
    cc.FileUtils:getInstance():addSearchPath("res/")
    cc.FileUtils:getInstance():addSearchPath("src/")
    cc.FileUtils:getInstance():addSearchPath("src/app/")
    --self:enterScene("MainScene")
    display.replaceScene(require("scenes.MainScene").new())
  
end

return MyApp
