--
--试炼
--
local BuddhaIcon     = import("icons.BuddhaIcon")
local AlertUpdate     = import("customs.AlertUpdate")

local TrialLayer = class("TrialLayer", function ()
	return display.newLayer()
end)

function TrialLayer:ctor(stage)	
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

	--播放音效
	if GameManager.SOUND_SWITCH_ON then
		audio.playSound(string.format("sounds/sfx_touch_ti.%s",GameManager.POSTFIX))
	end
	
	--初始化数据
	self:initData(stage)
end

function TrialLayer:initData(stage)
	local CSVParser = import("utils.CSVParser")
--	local cStageInfo = CSVParser.new("profiles/c_stage.csv")
    local cStageInfo = CSVParser.new(import("profiles.c_stage"),true)
	print(cStageInfo:objectAtIndex(stage)["requireStage"])
	print(cStageInfo:objectAtIndex(stage)["description"])
	
	self.stage_ = stage
	print("** self.stage_= " .. self.stage_)	
	if self.stage_ == 1 then
        self.title_ = "第一章"
    elseif self.stage_ == 2 then
        self.title_ = "第二章"
    elseif self.stage_ == 3 then
        self.title_ = "第三章"
	elseif self.stage_ == 4 then
        self.title_ = "第四章"
	elseif self.stage_ == 5 then
        self.title_ = "第五章"
	elseif self.stage_ == 6 then
        self.title_ = "第六章"
	elseif self.stage_ == 7 then
        self.title_ = "第七章"
	else
        self.title_ = "第八章"	
    end
	print("** self.title_= " .. self.title_)	
	self.buddhaId_ = cStageInfo:objectAtIndex(stage)["award"]
	self.brief_ = cStageInfo:objectAtIndex(stage)["description"]
	self.buddhaBrief_ = cStageInfo:objectAtIndex(stage)["buddha_description"]
	print("** self.buddhaId_= " .. self.buddhaId_)
	print("** self.brief_= " .. self.brief_)
	print("** self.buddhaBrief_= " .. self.buddhaBrief_)

	
	self.BuddhaModel = DataUtils.getBuddhaModel(tonumber(self.buddhaId_))
	self.buddhaQuality_ = tonumber(self.BuddhaModel.quality_) + 1
	print("** self.buddhaQuality_= " .. self.buddhaQuality_)
	if self.buddhaQuality_ == 1 then
        self.buddhaLevel_ = "普通"
    elseif self.buddhaQuality_ == 2 then
        self.buddhaLevel_ = "绿"
    elseif self.buddhaQuality_ == 3 then
        self.buddhaLevel_ = "蓝"
    elseif self.buddhaQuality_ == 4 then
        self.buddhaLevel_ = "紫"
    elseif self.buddhaQuality_ == 5 then
        self.buddhaLevel_ = "金"
    end
	print("** self.buddhaLevel_= " .. self.buddhaLevel_)
--	self.buddhaImg_ = BuddhaModel.icon_
--	print("** self.buddhaImg_= " .. self.buddhaImg_)
	self.buddhaName_ = self.BuddhaModel.name_
	self.buddhaAttack_ = self.BuddhaModel.attackParamB_.."+"..self.BuddhaModel.attackParamK_.."(每升1级)"
	self.buddhaHP_ = self.BuddhaModel.lifeParamB_.."+"..self.BuddhaModel.lifeParamK_.."(每升1级)"
	self.buddhaModel_ = self.BuddhaModel.hurtFrame_--"xiaodou"
	
	self.buddhaTag1_ = tonumber(self.BuddhaModel.tag1_)
	self.buddhaTag2_ = tonumber(self.BuddhaModel.tag2_)
	self.buddhaTag3_ = tonumber(self.BuddhaModel.tag3_)
	print("** self.buddhaName_= " .. self.buddhaName_)
	print("** self.buddhaModel_= " .. self.buddhaModel_)
	print("** tag1= " .. self.BuddhaModel.tag1_)
	print("** tag2= " .. self.BuddhaModel.tag2_)
	print("** tag3= " .. self.BuddhaModel.tag3_)
	
	print("**BuddhaModel.restrainType_ = "..self.BuddhaModel.restrainType_)
	print("**BuddhaModel.npcDesc_ = "..self.BuddhaModel.npcDesc_)
	print("**BuddhaModel.buddhaState_ = "..self.BuddhaModel.buddhaState_)
	self:initUI_()
end

function TrialLayer:initUI_()
	--背景
	self.bg_ = display.newSprite("trial/bg.png")
		--:scale(0.85)
		:addTo(self.node)
		
	--战斗按钮		
	local fight = cc.ui.UIPushButton.new({normal = "trial/fight.png",pressed = "trial/fight_h.png"})
		:scale(0.9)
        :align(display.CENTER,self.bg_:getContentSize().width * 0.94, self.bg_:getContentSize().height * 0.1)      
        :addTo(self.bg_)
		:onButtonClicked(function()
			self:fightCallBack_()
        end)
	
	--关闭按钮	
	local close = cc.ui.UIPushButton.new({normal = "common_ui/close.png",pressed = "common_ui/close_h.png"})
        :align(display.CENTER,self.bg_:getContentSize().width * 0.89,self.bg_:getContentSize().height * 0.85)
        :addTo(self.bg_)
		:onButtonClicked(function()
			self:closeCallBack_()
        end)
	
	self:initLeft()	
	self:initCenter()	
	self:initRight()
	
	--下方提示条
	display.newSprite("trial/tip.png")
		:pos(self.bg_:getContentSize().width * 0.5, -self.bg_:getContentSize().height * 0.04)
		:addTo(self.bg_)
end

function TrialLayer:initLeft()	
	--试炼说明
	cc.ui.UILabel.new({
        UILabelType = 2,text = self.title_ ,size = 36,color = cc.c3b(34,255,247),align = cc.ui.TEXT_ALIGN_CENTER,font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,self.bg_:getContentSize().width * 0.2,self.bg_:getContentSize().height * 0.63)
        :addTo(self.bg_)	
			
	cc.ui.UILabel.new({
        UILabelType = 2,text = self.brief_ ,size = 26,color = cc.c3b(255,255,255),
			align = cc.ui.TEXT_ALIGN_LEFT,dimensions = cc.size(190,160),font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,self.bg_:getContentSize().width * 0.2, self.bg_:getContentSize().height * 0.41)
        :addTo(self.bg_)	
	
end

function TrialLayer:initCenter()
	 local buddhaIcon = BuddhaIcon.new(self.BuddhaModel)
		buddhaIcon:setScale(0.7)
        buddhaIcon:setPosition(self.bg_:getContentSize().width * 0.385, self.bg_:getContentSize().height * 0.59)
        buddhaIcon:setTouchSwallowEnabled(false)
        self.bg_:addChild(buddhaIcon)
	--奖励图标	
	--[[local iconframe = display.newSprite("upgrade/q"..self.buddhaQuality_..".png")
		:scale(0.7)
		:align(display.CENTER,self.bg_:getContentSize().width * 0.385, self.bg_:getContentSize().height * 0.59)
		:addTo(self.bg_)
		
	display.newSprite(self.buddhaImg_)
		:align(display.CENTER,iconframe:getContentSize().width * 0.5,iconframe:getContentSize().height * 0.5)
		:addTo(iconframe)--]]
	
	self:newLabel_("神仙:", 24, cc.c3b(255,250,207), 
		self.bg_:getContentSize().width * 0.455, self.bg_:getContentSize().height * 0.615)
	self:newLabel_(self.buddhaName_, 20, cc.c3b(34,255,247), 
		self.bg_:getContentSize().width * 0.54, self.bg_:getContentSize().height * 0.615)
	self:newLabel_("品级:", 24, cc.c3b(255,250,207), 
		self.bg_:getContentSize().width * 0.455, self.bg_:getContentSize().height * 0.563)
	self:newLabel_(self.buddhaLevel_, 20, cc.c3b(34,255,247), 
		self.bg_:getContentSize().width * 0.5, self.bg_:getContentSize().height * 0.563)
	self:newLabel_("攻击:", 24, cc.c3b(255,250,207), 
		self.bg_:getContentSize().width * 0.395, self.bg_:getContentSize().height * 0.413)
--	self:newLabel_(self.buddhaAttack_, 18, cc.c3b(255,255,255), 
--		self.bg_:getContentSize().width * 0.456, self.bg_:getContentSize().height * 0.44)
	
	cc.ui.UILabel.new({
        text = self.buddhaAttack_,size = 18,color = cc.c3b(255,255,255),align = cc.ui.TEXT_ALIGN_LEFT,dimensions = cc.size(160,28),font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,self.bg_:getContentSize().width * 0.5, self.bg_:getContentSize().height * 0.408)
        :addTo(self.bg_)
		
	cc.ui.UILabel.new({
        text = self.buddhaHP_,size = 18,color = cc.c3b(255,255,255),align = cc.ui.TEXT_ALIGN_LEFT,dimensions = cc.size(160,28),font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,self.bg_:getContentSize().width * 0.5, self.bg_:getContentSize().height * 0.335)
        :addTo(self.bg_)
		
		
	self:newLabel_("血量:", 24, cc.c3b(255,250,207), 
		self.bg_:getContentSize().width * 0.395, self.bg_:getContentSize().height * 0.34)
--	self:newLabel_(self.buddhaHP_, 18, cc.c3b(255,255,255), 
--		self.bg_:getContentSize().width * 0.456, self.bg_:getContentSize().height * 0.355)				
		
	cc.ui.UILabel.new({
        text = self.buddhaBrief_ ,size = 20,color = cc.c3b(255,255,255), dimensions = cc.size(180,75),font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,self.bg_:getContentSize().width * 0.507, self.bg_:getContentSize().height * 0.195)
        :addTo(self.bg_)
end

function TrialLayer:initRight()
	--若本地没有骨骼动画,则提示去下载
    local resDownLoaded = cc.UserDefault:getInstance():getBoolForKey("missed_armature_res_downloaded",false)
    if not resDownLoaded and CloudData.STAGE_PROGRESS >= 25 then
        local al = AlertUpdate.new(GameManager.URL_MISSED_ARMATURE,5.8,"FORCE",true)
        self:addChild(al,100)
        return  
    end

	--添加骨骼动画
	cc.Texture2D:setDefaultAlphaPixelFormat( cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A4444 )
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("armature/"..self.buddhaModel_.."/"..self.buddhaModel_..".csb")
    local buddha = ccs.Armature:create(self.buddhaModel_)
    buddha:setPosition(self.bg_:getContentSize().width * 0.8, self.bg_:getContentSize().height * 0.2)
    buddha:getAnimation():playWithIndex(0)
    self.bg_:addChild(buddha)
    cc.Texture2D:setDefaultAlphaPixelFormat( cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888 )
	
--	self.buddhaTag1_ = BuddhaModel.tag1_
--	self.buddhaTag2_ = BuddhaModel.tag2_
--	self.buddhaTag3_ = BuddhaModel.tag3_
	
	tags = {"扛得住","揍一群","跑得快","打得远","打的狠","还凑合"}
	
	if self.buddhaTag1_ + self.buddhaTag2_ + self.buddhaTag3_  == 0 then
		self.buddhaTag1_ = tags[6]
		self.buddhaTag2_ = 0
		self.buddhaTag3_ = 0
	end	
	
	display.newSprite("buddha_tag/" .. self.buddhaTag1_ .. ".png")
		:scale(0.6)
		:pos(self.bg_:getContentSize().width * 0.885, self.bg_:getContentSize().height * 0.65)
		:addTo(self.bg_)
		
	display.newSprite("buddha_tag/" .. self.buddhaTag2_ .. ".png")
		:scale(0.6)
		:pos(self.bg_:getContentSize().width * 0.885, self.bg_:getContentSize().height * 0.57)
		:addTo(self.bg_)
		
	display.newSprite("buddha_tag/" .. self.buddhaTag3_ .. ".png")
		:scale(0.6)
		:pos(self.bg_:getContentSize().width * 0.885, self.bg_:getContentSize().height * 0.49)
		:addTo(self.bg_)
end

function TrialLayer:fightCallBack_()
	GameManager.STAGE_NUM = 0
	
	--点击战斗按钮进入战斗场景
	print("Fight!--"..self.stage_)
	GameManager.STAGE_NUM_CHALLENGE = self.stage_
	GameManager.TOWER_DISTANCE      = 900
	--DataEye统计任务
    if USE_DATAEYE then	        	
        DCTask.begin("Trial" .. (self.stage_), DC_Other)	                  
    end
	display.replaceScene(require("scenes.TinyLoadingScene").new("GAME_SCENE","CHALLENGE"))
end

--新建标签对象
function TrialLayer:newLabel_(textStr, textSize, textColor, x, y)
	cc.ui.UILabel.new({
        text = textStr,size = textSize,color = textColor,align = cc.ui.TEXT_ALIGN_CENTER,font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,x,y)
        :addTo(self.bg_)
end

--弹窗关闭
function TrialLayer:closeCallBack_()
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

return TrialLayer