--
--新兵种出现场景
--

FROM_CHAPTER   = 1
FROM_SUMMON    = 2

local NewFellowLayer = class("NewFellowLayer", function()
	return display.newLayer()
end)

function NewFellowLayer:ctor(buddhaModel,fromType)
	if GameManager.MUSIC_SWITCH_ON then
		audio.stopMusic()
		audio.playMusic(string.format("sounds/bgm_new_fellow.%s",GameManager.POSTFIX),false)
	end   
    
	--1.新伙伴等级：	  self.leval_
	--2.新伙伴属性：	  self.tag1_
	--3.新伙伴属性：	  self.tag2__
	--4.新伙伴属性：	  self.tag3__
	--6.新伙伴名字：	  self.name_	
	--5.新伙伴图标：	  self.icon_
	--7.新伙伴图标背景框：self.quality_
	--8.新伙伴的骨骼动画：self.model_
	if fromType ~= nil then
		self.fromType_ = fromType
	else
		self.fromType_ = FROM_CHAPTER
	end
	self.leval_     = tonumber(buddhaModel.level_)
	self.tag1_      = tonumber(buddhaModel.tag1_)
	self.tag2__     = tonumber(buddhaModel.tag2_)
	self.tag3__     = tonumber(buddhaModel.tag3_)
	self.name_      = buddhaModel.name_
	self.icon_      = buddhaModel.icon_
	self.quality_   = tonumber(buddhaModel.quality_) + 1	 
	self.model_     = buddhaModel 
	
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

	--标记有新兵种解锁(章节界面"new"提示)	
	GameManager.IS_HAVE_NEW_BUDDHA   = true
	
	--初始化界面
	self:init()
end

function NewFellowLayer:init()
	--加载特效配置文件
	display.addSpriteFrames("new_fellow/note.plist", "new_fellow/note.png")
	display.addSpriteFrames("new_fellow/new_fellow1.plist", "new_fellow/new_fellow1.png")
	
	--背景
	self.bg_ = display.newSprite("new_fellow/bg.jpg")
		self.node:addChild(self.bg_)
	
	--云朵
	self.cloud = display.newSprite("new_fellow/cloud.png")
		:align(display.CENTER, self.bg_:getContentSize().width, self.bg_:getContentSize().height * 0.35)
		:addTo(self.bg_)
		
	--每0.016秒云朵左移一像素
    self:schedule(function()
			self:cloudPosUpdate_()
		end , 0.016)
									
	local til = display.newSprite("new_fellow/ground.png")
		:align(display.CENTER, self.bg_:getContentSize().width * 0.5, self.bg_:getContentSize().height * 0.17)
		:addTo(self.bg_)
		
	local tem1 = display.newSprite("new_fellow/monkey.png")
		:pos(self.bg_:getContentSize().width, 0)
		:addTo(self.bg_)
		tem1:setAnchorPoint(1, 0)
	
	--添加空精灵播放音乐符动画
	local ani = display.newSprite()
		:align(display.CENTER, self.bg_:getContentSize().width * 0.95, self.bg_:getContentSize().height * 0.35)
		:addTo(self.bg_)		
	
	local frames = display.newFrames("note%d.png", 1, 12)
    local animation = display.newAnimation(frames, 0.07)  
    ani:playAnimationForever(animation)
	
	--添加空精灵播放新伙伴出现动画1
	local ani1 = display.newSprite()
		:align(display.CENTER, self.bg_:getContentSize().width * 0.6, self.bg_:getContentSize().height * 0.58)
		:addTo(self.bg_)
			
	local frames1 = display.newFrames("bingzhonghuod1-%d.png", 1, 14)
    local fellow1 = display.newAnimation(frames1, 0.07)  
    ani1:playAnimationOnce(fellow1,true,function()
			self:newFellow1_()
		end)
	
	local title = display.newSprite("new_fellow/title.png")
		:align(display.CENTER, self.bg_:getContentSize().width * 0.5, self.bg_:getContentSize().height * 0.88)
		:addTo(self.bg_)
	
	local name = display.newSprite("new_fellow/bg_name.png")
		:align(display.CENTER, self.bg_:getContentSize().width * 0.566, self.bg_:getContentSize().height * 0.2)
		:addTo(self.bg_)
	
	cc.ui.UILabel.new({text = self.name_,size = 30,font = GameManager.FONTNAME_TTF})
		:align(display.CENTER,name:getContentSize().width * 0.2, name:getContentSize().height * 0.5)
		:addTo(name)
	
	--卡片	
	local card = display.newSprite("new_fellow/intro.png")
		:align(display.CENTER, self.bg_:getContentSize().width * 0.2, self.bg_:getContentSize().height * 0.55)
		:addTo(self.bg_)
		:scale(0)
	local popupLayer = transition.sequence({
		cc.ScaleTo:create(2.2, 0),
		cc.ScaleTo:create(0.1, 1.0)})			
        card:runAction(popupLayer)
				
	local iconFrame = display.newSprite("upgrade/q"..self.quality_..".png")
		:scale(0.7)
		:align(display.CENTER, card:getContentSize().width * 0.22, card:getContentSize().height * 0.7)
		:addTo(card)
	
	local icon = display.newSprite(self.icon_)
		:align(display.CENTER, iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.5)
		:addTo(iconFrame)
			
	cc.ui.UILabel.new({text = self.name_,size = 24,font = GameManager.FONTNAME_TTF})
		:align(display.CENTER,card:getContentSize().width * 0.52, card:getContentSize().height * 0.74)
		:addTo(card)
		
	cc.ui.UILabel.new({text = "Lv."..self.leval_,size = 24,font = GameManager.FONTNAME_TTF})
		:align(display.CENTER,card:getContentSize().width * 0.52, card:getContentSize().height * 0.65)
		:addTo(card)
			
	local newfellow = display.newSprite("new_fellow/"..self.quality_..".png")
		:align(display.CENTER, card:getContentSize().width * 0.52, card:getContentSize().height * 0.47)
		:addTo(card)
	
	--新伙伴属性	
	tags = {"","扛得住","揍一群","跑得快","打得远","打的狠","还凑合"}
		
	cc.ui.UILabel.new({text = tags[self.tag1_ + 1],size = 28,font = GameManager.FONTNAME_TTF})
		:align(display.CENTER,card:getContentSize().width * 0.56, card:getContentSize().height * 0.36)
		:addTo(card)
		
	cc.ui.UILabel.new({text = tags[self.tag2__ + 1],size = 28,font = GameManager.FONTNAME_TTF})
		:align(display.CENTER,card:getContentSize().width * 0.56, card:getContentSize().height * 0.27)
		:addTo(card)
		
	cc.ui.UILabel.new({text = tags[self.tag3__ + 1],size = 28,font = GameManager.FONTNAME_TTF})
		:align(display.CENTER,card:getContentSize().width * 0.56, card:getContentSize().height * 0.18)
		:addTo(card)
		
	--确定和分享按钮		
	local con = cc.ui.UIPushButton.new({normal = "common_ui/confirm.png",pressed = "common_ui/confirm_h.png"})
        :align(display.CENTER,self.bg_:getContentSize().width * 0.5,self.bg_:getContentSize().height * 0.1)      
        :addTo(self.bg_)
        :scale(0.75)
		con:onButtonClicked(function()
			self:confirmCallBack_()
		end)
	--[[local share = cc.ui.UIPushButton.new({normal = "new_fellow/share.png",pressed = "new_fellow/share_h.png"})
        :align(display.CENTER,self.bg_:getContentSize().width * 0.58,self.bg_:getContentSize().height * 0.1)
        :addTo(self.bg_)--]]
end

function NewFellowLayer:cloudPosUpdate_()
	local x = math.floor(self.cloud:getPositionX())
	if x == -(math.floor(self.cloud:getContentSize().width * 0.5)) then
		x = self.bg_:getContentSize().width + self.cloud:getContentSize().width * 0.5
	end
	self.cloud:setPosition(x - 2, self.cloud:getPositionY())
end

function NewFellowLayer:newFellow1_()
	-- 加载特效配置文件
	display.addSpriteFrames("new_fellow/new_fellow2.plist", "new_fellow/new_fellow2.png")

	--添加空精灵播放新伙伴出现动画2
	local ani = display.newSprite()
		:align(display.CENTER, self.bg_:getContentSize().width * 0.5, self.bg_:getContentSize().height * 0.5)
		:addTo(self.bg_)
				
	local frames = display.newFrames("bingzhonghuod2-%d.png", 1, 10)
    local fellow = display.newAnimation(frames, 0.07)
	ani:setScale(1.5)   
    ani:playAnimationOnce(fellow,true,function()
			self:newFellow2_()
		end)
end

function NewFellowLayer:newFellow2_()
	-- 加载特效配置文件
	display.addSpriteFrames("new_fellow/new_fellow3.plist", "new_fellow/new_fellow3.png")	

	--添加骨骼动画
	cc.Texture2D:setDefaultAlphaPixelFormat( cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A4444 )
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(string.format("armature/%s/%s.csb",
        self.model_.hurtFrame_,self.model_.hurtFrame_))
    local xiaodou = ccs.Armature:create(self.model_.hurtFrame_)
    xiaodou:setPosition(self.bg_:getContentSize().width * 0.5, self.bg_:getContentSize().height * 0.25)
    xiaodou:getAnimation():playWithIndex(0)
    self.bg_:addChild(xiaodou)
    cc.Texture2D:setDefaultAlphaPixelFormat( cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888 )
	
	--添加空精灵播放新伙伴出现动画3
	local ani = display.newSprite()
		:align(display.CENTER, self.bg_:getContentSize().width * 0.5, self.bg_:getContentSize().height * 0.35)
		:addTo(self.bg_)
			
	local frames = display.newFrames("bingzhonghuode3-%d.png", 1, 23)
    local fellow = display.newAnimation(frames, 0.05) 
	ani:setScale(2)
    ani:playAnimationOnce(fellow,true,nil)
end

--确定回调
function NewFellowLayer:confirmCallBack_()
	if self.fromType_ == FROM_SUMMON then
		GameManager.IS_NEWFELLOW_CLOSED = true
		self:closeCallBack_()
	else
		self:closeCallBack_()
	end
end

--弹窗关闭
function NewFellowLayer:closeCallBack_()
	
    local popupLayer = transition.sequence({cc.ScaleTo:create(0,1.0),
        cc.ScaleTo:create(0.1,1.1),
        cc.ScaleTo:create(0.2,0),cc.CallFunc:create(function()
            self:removeSelf()
        end)
        })
    self.node:runAction(popupLayer)
end

return NewFellowLayer