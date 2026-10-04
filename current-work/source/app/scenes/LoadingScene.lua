
local LoadingScene = {} 
LoadingScene = class("LoadingScene", function()
    return display.newScene("LoadingScene")
end)

-- ios、Android的logo不同
if device.platform == "ios" or device.platform == "mac" then   
    LOGO_PATH = "common/logo_ios.png"
else
    LOGO_PATH = "common/logo.png"
end

function LoadingScene:ctor()
    self:initUI_()
	
	self:addAndroidReturnButton_()
end

function LoadingScene:initUI_()

    --两张背景
    display.newSprite("loading/bg.jpg",display.cx,display.cy):addTo(self)
    display.newSprite("loading/bg1.png",display.cx,display.cy):addTo(self,1)

    --师徒四人从四个方向出现
        --悟空
    self.wuKong_ = display.newSprite("loading/wukong.png",display.cx,-132):addTo(self,5)
    self.wuKong_:runAction(cc.MoveBy:create(0.3,cc.p(0,440)))
        --八戒
    self.baJie_ = display.newSprite("loading/bajie.png",-85,display.height * 0.52):addTo(self,4)
    self.baJie_:runAction(cc.MoveBy:create(0.3,cc.p(display.width * 0.46,0)))
        --沙僧
    self.shaSeng_ = display.newSprite("loading/shaseng.png",display.width + 107 ,display.height * 0.52):addTo(self,3)
    self.shaSeng_:runAction(cc.MoveBy:create(0.3,cc.p(-display.width * 0.46,0)))
        --唐僧
    self.tang_ = display.newSprite("loading/tangseng.png",display.cx,display.height + 161):addTo(self,2)
    self.tang_:runAction(transition.sequence({cc.MoveBy:create(0.3,cc.p(0,-350)),cc.CallFunc:create(function()
        self:action1_()
    end)}))
end
function LoadingScene:action1_()
    --播放音效
	if GameManager.SOUND_SWITCH_ON then
		audio.playSound(string.format("sounds/sfx_go_1.%s",GameManager.POSTFIX))
	end	   

    --人物后方出现光圈
    local halo = display.newSprite("loading/halo.png",display.cx ,display.cy)
        :scale(0)
        :addTo(self,1)
    halo:runAction(transition.sequence({cc.ScaleTo:create(0.3,1.2),cc.ScaleTo:create(0.3,1.0),cc.CallFunc:create(function()
        self:action2_()
    end)}))
end
function LoadingScene:action2_()
    --logo
    local logo = display.newSprite(LOGO_PATH,display.cx ,display.height * 0.23)
        :scale(3.0)
        :addTo(self,5)
    logo:runAction(transition.sequence({cc.ScaleTo:create(0.5,1.0),cc.CallFunc:create(function()
        self:action3_()
    end)}))
end
function LoadingScene:action3_()
    --狐狸骨骼动画
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(string.format("armature/jiuwei/jiuwei.csb"))
    local armature = ccs.Armature:create("jiuwei")
    armature:setPosition(display.width * 0.06,display.height * 0.07)
    armature:setScale(0.8)
    armature:getAnimation():playWithIndex(1)
    self:addChild(armature,10)

    armature:runAction(transition.sequence({cc.MoveBy:create(1.5,cc.p(display.width * 0.85,0)),cc.CallFunc:create(function()
        audio.stopMusic()
        display.replaceScene(require("scenes.ChapterScene").new(),'FADETR',1)
    end)}))
    

    --圆球滚动
    local ball = display.newSprite("common/ball.png",display.width * 0.11,display.height * 0.1)
        :scale(0.8)
        :addTo(self,10)
    local spawn = cc.Spawn:create(cc.RotateBy:create(1.5,900),cc.MoveBy:create(1.5,cc.p(display.width * 0.85,0)))
    ball:runAction(spawn)
end

function LoadingScene:addAndroidReturnButton_()
	--退出游戏
    local btn = cc.ui.UIPushButton.new():addTo(self)
		btn:setKeypadEnabled(true)
        btn:addNodeEventListener(cc.KEYPAD_EVENT, function (event)
            if event.key == "back" then
				self:showReturnWarning_()
			end
		end)
end

function LoadingScene:showReturnWarning_()
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

function LoadingScene:onEnter()
end
function LoadingScene:onExit()
end

return LoadingScene
