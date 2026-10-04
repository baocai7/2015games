--
--设置音乐和音效
--

TAG_SETTING = 1
TAG_ABOUT = 2

local ActivityCodeLayer  = import("layers.ActivityCodeLayer")

local SetLayer = {} 
SetLayer = class("SetLayer", function ()
	return display.newLayer()
end)

function SetLayer:ctor()
	--1.是否已打开音乐:		self.musicTag_
	--2.是否已打开音效:		self.soundTag_
	
	self.musicTag_ = GameManager.MUSIC_SWITCH_ON
	self.soundTag_ = GameManager.SOUND_SWITCH_ON
			
	--添加遮罩层
	self.mask = display.newColorLayer(cc.c4b(0,0,0,150))
		:addTo(self,-1)
	
	--初始化基础节点	
	self.node = display.newNode()
		:scale(0)
		:pos(display.cx, display.cy)
		:addTo(self,1)
	
	--弹出效果	
	local popupLayer = transition.sequence(
			{cc.ScaleTo:create(0.2, 1.1),
			cc.ScaleTo:create(0.1, 1.0)})
		self.node:runAction(popupLayer)

	--播放音效(打开层)
	if GameManager.SOUND_SWITCH_ON then
		audio.playSound(string.format("sounds/sfx_touch_ti.%s",GameManager.POSTFIX))
	end
	
	--初始化界面
	self:init()
end

function SetLayer:init()
	--背景
	self.bg_ = display.newSprite("settings/bg.png")
		:addTo(self.node)
	
	self.setting = cc.ui.UIPushButton.new({normal = "settings/setting.png",disabled = "settings/setting1.png"})
        :align(display.CENTER, 0,self.bg_:getContentSize().height * 0.765)
        :addTo(self.bg_)
		:onButtonClicked(function(event)
			self:showSetting_()
        end)
		
	self.about = cc.ui.UIPushButton.new({normal = "settings/about.png",disabled = "settings/about1.png"})
        :align(display.CENTER, 0,self.bg_:getContentSize().height * 0.5)
        :addTo(self.bg_)
		:onButtonClicked(function(event)
			self:showAbout_()
        end)
	
	--关闭按钮		
	cc.ui.UIPushButton.new({normal = "common_ui/close.png",pressed = "common_ui/close_h.png"})
		:scale(0.8)
        :align(display.CENTER,self.bg_:getContentSize().width * 0.95,self.bg_:getContentSize().height * 0.93)
        :addTo(self.bg_)
        :onButtonPressed(function()
            self:closeCallBack_()
        end)
		-- :onButtonClicked(function()
		-- 	self:closeCallBack_()
  --       end)
	
	--初始化设置界面	
	self:showSetting_()
end

--★★设置界面★★
function SetLayer:showSetting_()
	self.setting:setButtonEnabled(false)
	self.about:setButtonEnabled(true)
	
	if self.pageBg_ ~= nil then
		self.pageBg_:removeSelf()
		self.pageBg_ = nil
	end
	
	self.pageBg_ = display.newSprite("settings/bg_setting.png")
		:align(display.CENTER,self.bg_:getContentSize().width * 0.5,self.bg_:getContentSize().height * 0.5)
		:addTo(self.bg_)
	
	local iconframe = display.newSprite("settings/label_bgm.png")
		:align(display.CENTER,self.pageBg_:getContentSize().width * 0.13, self.pageBg_:getContentSize().height * 0.9)
		:addTo(self.pageBg_)
	
	--设置音乐按钮		
	cc.ui.UICheckBoxButton.new({on = "settings/bgm1.png",off = "settings/bgm0.png",})
        :align(display.CENTER, self.pageBg_:getContentSize().width * 0.20,self.pageBg_:getContentSize().height * 0.67)
        :addTo(self.pageBg_)
		:onButtonClicked(function()
			self:setMusic_()
        end)
		:setButtonSelected(self.musicTag_)
	
	local iconframe1 = display.newSprite("settings/label_sfx.png")
		:align(display.CENTER,self.pageBg_:getContentSize().width * 0.67, self.pageBg_:getContentSize().height * 0.9)
		:addTo(self.pageBg_)
	
	--设置音效按钮		
	cc.ui.UICheckBoxButton.new({on = "settings/sfx1.png",off = "settings/sfx0.png",})
        :align(display.CENTER, self.pageBg_:getContentSize().width * 0.74,self.pageBg_:getContentSize().height * 0.67)
        :addTo(self.pageBg_)
		:onButtonClicked(function()
			self:setSound_()
        end)
		:setButtonSelected(self.soundTag_)

	-- 兑换按钮
	local exchangeBtn = cc.ui.UIPushButton.new({normal = "settings/code.png",pressed = "settings/code1.png"})
		:onButtonClicked(function()
		    self:codeCallBack_()
		end)
		:align(display.CENTER,self.pageBg_:getContentSize().width * 0.20,self.pageBg_:getContentSize().height * 0.18)
		:addTo(self.pageBg_)
	-- ios平台隐藏兑换按钮
	if device.platform == "ios" or device.platform == "mac"  then
		exchangeBtn:hide()
	end

	-- 图鉴按钮
	cc.ui.UIPushButton.new({normal = "settings/wiki1.png",pressed = "settings/wiki2.png"})
		:onButtonClicked(function()
		    display.replaceScene(require("scenes.WikiScene").new())
		end)
		:align(display.CENTER,self.pageBg_:getContentSize().width * 0.50,self.pageBg_:getContentSize().height * 0.18)
		:addTo(self.pageBg_)
		
    -- 返回登录按钮
    cc.ui.UIPushButton.new({normal = "settings/back1.png",pressed = "settings/back2.png"})
        :onButtonClicked(function()
            -- 标记返回登录
            GameManager.IS_BACK_FROM_SETLAYER = true
            display.replaceScene(require("scenes.MainScene").new())
        end)
        :align(display.CENTER,self.pageBg_:getContentSize().width * 0.80,self.pageBg_:getContentSize().height * 0.18)
        :addTo(self.pageBg_)
	
	cc.ui.UILabel.new({
        text = "uid: " .. CloudData.UID,size = 36,color = display.COLOR_BLACK, font = GameManager.FONTNAME_TTF})
        :align(display.CENTER_LEFT,self.pageBg_:getContentSize().width * 0.06,self.pageBg_:getContentSize().height * 0.48)
        :addTo(self.pageBg_)
end

--兑换码回调
function SetLayer:codeCallBack_()
	local activityCode = ActivityCodeLayer.new()
	self:addChild(activityCode,20)
end

--★★关于界面★★
function SetLayer:showAbout_()
	self.setting:setButtonEnabled(true)
	self.about:setButtonEnabled(false)
	
	if self.pageBg_ ~= nil then
		self.pageBg_:removeSelf()
		self.pageBg_ = nil
	end
	self.pageBg_ = display.newSprite("settings/bg_about.png")
		:align(display.CENTER,self.bg_:getContentSize().width * 0.5,self.bg_:getContentSize().height * 0.5)
		:addTo(self.bg_)
end

function SetLayer:setSound_()
	--改变音效设置	
	self.soundTag_ = not self.soundTag_
    -- 添加内存快照
    GameManager.SOUND_SWITCH_ON = self.soundTag_
    
    -- 数据保存到设备
	cc.UserDefault:getInstance():setBoolForKey("user_sound_switch",self.soundTag_)
end

function SetLayer:setMusic_()
	--改变音乐设置
	self.musicTag_ = not self.musicTag_
	-- 添加内存快照
    GameManager.MUSIC_SWITCH_ON = self.musicTag_
    
    -- 数据保存到设备
	cc.UserDefault:getInstance():setBoolForKey("user_music_switch",self.musicTag_)
	
	if self.musicTag_ then
		audio.playMusic(string.format("sounds/bgm_theme.%s",GameManager.POSTFIX))
	else
		audio.stopMusic()
	end	
end

--[[function SetLayer:userCenter_()
	print("User Center!")
end--]]

--弹窗关闭
function SetLayer:closeCallBack_()
	--播放音效(关闭层)
	if GameManager.SOUND_SWITCH_ON then
		audio.playSound(string.format("sounds/sfx_touch_shu.%s",GameManager.POSTFIX))
	end

    local popupLayer = transition.sequence({cc.ScaleTo:create(0,1.0),
        cc.ScaleTo:create(0.1,1.1),
        cc.ScaleTo:create(0.2,0),cc.CallFunc:create(function()
            self:removeSelf()
        end)
        })
    self.node:runAction(popupLayer)
end

return SetLayer