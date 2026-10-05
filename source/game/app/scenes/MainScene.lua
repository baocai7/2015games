
if device.platform == "android" or device.platform == "mac" or device.platform == "ios" then
    require("channelConfig")
end

require("app.customs.PaymentVerification")

import("functions.DataUtils")
import("utils.DataRetainer")
import("utils.CloudData")
import("utils.GameManager")
import("utils.PaymentInfo")
import("utils.DYUtils")

--DataEye数据统计，全部使用自己接的DataEye
if USE_DATAEYE == true then
    import("DataEye.DCAccount")
    import("DataEye.DCAgent")
    import("DataEye.DCCardsGame")
    import("DataEye.DCCoin")
    import("DataEye.DCConfigParams")
    import("DataEye.DCEvent")
    import("DataEye.DCItem")
    import("DataEye.DCLevels")
    import("DataEye.DCTask")
    import("DataEye.DCVirtualCurrency")
    
    -- Task Type enum 
    DC_GuideLine = 1
    DC_MainLine = 2
    DC_BranchLine = 3
    DC_Daily = 4
    DC_Activity = 5
    DC_Other = 6
end

--function print() 
--end

local MainScene = {}
MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)


function MainScene:ctor()

    -- Keep resource changes durable across process termination. The scheduler
    -- is global, so it continues after MainScene is replaced by gameplay UI.
    if DataUtils.startResourcePersistence ~= nil then
        DataUtils.startResourcePersistence()
    end

    -- 统一使用mp3格式
    if(device.platform=="android") then
        GameManager.POSTFIX = "ogg"
    elseif(device.platform=="ios" or device.platform=="mac" or device.platform=="windows") then
        GameManager.POSTFIX = "mp3"
    else 
        GameManager.POSTFIX = "mp3"
    end
    
    -- 获取用户配置 [内存快照内使用]
    GameManager.MUSIC_SWITCH_ON = cc.UserDefault:getInstance():getBoolForKey("user_music_switch",true)  -- 用户音乐开关
    GameManager.SOUND_SWITCH_ON = cc.UserDefault:getInstance():getBoolForKey("user_sound_switch",true)  -- 用户声音开关
    GameManager.SHOW_NOTICE     = cc.UserDefault:getInstance():getBoolForKey("user_notice_switch",true) -- 用户公告开关

    if GameManager.SOUND_SWITCH_ON then
        --audio.playMusic(string.format("sounds/bgm_chatting.%s",GameManager.POSTFIX))
        audio.preloadMusic(string.format("sounds/bgm_chatting.%s",GameManager.POSTFIX))
    end

    -- 随机数种子
    math.newrandomseed()

    -- local bgPath = ""
    -- local time = 0.1
    -- --if device.platform == "android" and CHANNEL == 10086 then
    -- --    bgPath = "splash_mm.jpg"
    -- --    time = 3.0
    -- --else
    -- bgPath = "login_scene/login_bg.jpg"
    -- --end

    local bgPath = ""
    local time = 0.1
    if device.platform == "android" and CHANNEL == 10086 then
        bgPath = "splash_mm.jpg"
        time = 3.0
    elseif device.platform == "android" and CHANNEL == 10000 then
        bgPath = "egame_logo.png"
        time = 3.0
    else
        bgPath = "login_scene/login_bg.jpg"
    end

    --bg
    display.newSprite(bgPath, display.cx, display.cy):addTo(self)

    self:performWithDelay(function()
        display.replaceScene(require("scenes.LoginScene").new())
    end, time)


    -- cc.ui.UILabel.new({
    --         UILabelType = 2, text = "Hello, World", size = 64})
    --     :align(display.CENTER, display.cx, display.cy)
    --     :addTo(self)

    --    cc.ui.UIPushButton.new({normal = "CloseNormal.png",pressed = "CloseSelected.png"})
    --        :align(display.CENTER,display.width * 0.1,display.height * 0.9)
    --        :addTo(self,1)
    --        :onButtonClicked(handler(self,self.callBack1))

    -- local btn
    -- btn = cc.ui.UIPushButton.new()
    --         :setButtonLabel(cc.ui.UILabel.new({text = "call Java - showAlertDialog()", size = 64}))
    --         :onButtonClicked(function()
    --             if device.platform ~= "android" then
    --                 print("please run this on android device")
    --                 btn:setButtonLabel(cc.ui.UILabel.new({text = "please run this on android device", size = 32}))
    --                 return
    --             end

    --             -- call Java method
    --             local javaClassName = "org/cocos2dx/lua/AppActivity"
    --             local javaMethodName = "testLuaJ"
    --             local javaParams = {
    --                 "How are you ?",
    --                 "I'm great !",
    --                 function(event)
    --                     local str = "Java method callback value is [" .. event .. "]"
    --                     btn:setButtonLabel(cc.ui.UILabel.new({text = str, size = 32}))
    --                 end
    --             }
    --             local javaMethodSig = "(Ljava/lang/String;Ljava/lang/String;I)V"
    --             luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
    --         end)
    --         :align(display.CENTER, display.cx, display.cy)
    --         :addTo(self)

    --退出游戏
    -- local btn = cc.ui.UIPushButton.new():addTo(self)
    -- btn:setKeypadEnabled(true)
    -- btn:addNodeEventListener(cc.KEYPAD_EVENT, function (event)
    --     if event.key == "back" then
    --     cc.Director:getInstance():endToLua()
    --     if device.platform == "windows" or device.platform == "mac" then
    --         os.exit()
    --     end
    -- end)

    self:addAndroidReturnButton_()
end

function MainScene:callBack1()
    display.replaceScene(require("scenes.LoginScene").new())
end

function MainScene:addAndroidReturnButton_()
    --退出游戏
    local btn = cc.ui.UIPushButton.new():addTo(self)
    btn:setKeypadEnabled(true)
    btn:addNodeEventListener(cc.KEYPAD_EVENT, function (event)
        if event.key == "back" then
            self:showReturnWarning_()
        end
    end)
end

function MainScene:showReturnWarning_()
    if self.returnMask ~= nil then
        return
    end
    self.returnMask = display.newColorLayer(cc.c4b(0,0,0,150))
    self:addChild(self.returnMask,20000)
    
    local bg = display.newSprite("common_ui/common_bg.png"):pos(display.cx, display.cy):addTo(self.returnMask,1)
    cc.ui.UILabel.new({
        text = "确定退出？" ,size = 32,color = display.COLOR_BLACK,font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,bg:getContentSize().width * 0.5,bg:getContentSize().height * 0.57)
        :addTo(bg)
        
    --确定按钮
    cc.ui.UIPushButton.new({normal = "common_ui/confirm.png",pressed = "common_ui/confirm_h.png"})
        :align(display.CENTER,bg:getContentSize().width * 0.5,bg:getContentSize().height * 0.22)
        :onButtonClicked(function()
            if PaymentInfo.CHANNEL == 3 then
                --酷狗SDK退出 luaJ桥接
                local javaClassName = "org/cocos2dx/lua/AppActivity"
                local javaMethodName = "exitKugou"
                local javaParams = {}
                local javaMethodSig = "()V"
                luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
            elseif PaymentInfo.CHANNEL == 4 then
                --UC SDK退出 luaJ桥接
                local javaClassName = "org/cocos2dx/lua/AppActivity"
                local javaMethodName = "exitUC"
                local javaParams = {}
                local javaMethodSig = "()V"
                luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
            elseif BAIDU_PROMOTION then
                --Baidu SDK退出 luaJ桥接
                local javaClassName = "org/cocos2dx/lua/AppActivity"
                local javaMethodName = "exitBaidu"
                local javaParams = {}
                local javaMethodSig = "()V"
                luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
            else
                cc.Director:getInstance():endToLua()
                if device.platform == "windows" or device.platform == "mac" then
                    os.exit()
                end
            end
        end)
        :addTo(bg,2)

    --关闭按钮
    cc.ui.UIPushButton.new({normal = "common_ui/close.png",pressed = "common_ui/close_h.png"})
        :align(display.CENTER,bg:getContentSize().width * 0.95,bg:getContentSize().height * 0.95)
        :onButtonClicked(function()
            self.returnMask:removeSelf()
            self.returnMask = nil
        end)
        :scale(0.8)
        :addTo(bg,2)
end

function MainScene:onEnter()
end

function MainScene:onExit()
end

return MainScene
