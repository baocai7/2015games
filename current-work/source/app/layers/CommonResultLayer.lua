--
--日常结果显示界面（胜利，失败）
--
local NewFellowLayer   = import("layers.NewFellowLayer")

RESULT_TYPE_DIARY_WIN      = 1
RESULT_TYPE_TRIAL_WIN      = 2
RESULT_TYPE_ACTIVITY_WIN   = 3
RESULT_TYPE_COMMON_LOSE    = 0

--奖励类型
--REWARD_TYPE_EXP		 = 1	--经验+道具（几率）
--REWARD_TYPE_PIECE	 = 2	--碎片+扫荡券（几率）
--REWARD_TYPE_PEACH	 = 3	--蟠桃

local CommonResultLayer = class("CommonResultLayer", function()
	return display.newLayer()
end)

function CommonResultLayer:ctor(resultType)
	self.type_ = resultType
	
	--添加遮罩层
	display.newColorLayer(cc.c4b(0,0,0,150)):addTo(self,-1)

	--初始化基础节点
	self.emptyNode_ = display.newNode()
	self.emptyNode_:setPosition(display.cx,display.cy)
	self:addChild(self.emptyNode_)
	--添加触摸事件
	self.emptyNode_:setTouchEnabled(false)	   --当UI界面展示结束后再开启点击事件
	self.emptyNode_:addNodeEventListener(cc.NODE_TOUCH_EVENT, function()
				return 	self:returnCallBack_()
			end)
	--添加空白图扩充点击区域
    local emptyLayer = display.newColorLayer(cc.c4b(255,255,255,0))
    emptyLayer:setAnchorPoint(0.5,0.5)
    emptyLayer:setContentSize(cc.size(display.width,display.height))
    self.emptyNode_:addChild(emptyLayer,-1)
		
	--结果类型(胜利，失败)
	if resultType == RESULT_TYPE_COMMON_LOSE then 
		self:showFailure_()
	else
		self:initSuccessUI_()
	end
end

function CommonResultLayer:initDiarySuccessData_()
    self.expNum_ = CloudData.DIARY_SUCCESS_AWARD_EXP    --1000		--self.content_.data.exp
    self.itemId_ = CloudData.DIARY_SUCCESS_AWARD_ITEM_ID    --6		--self.content_.data.item.id
    self.itemNum_ = CloudData.DIARY_SUCCESS_AWARD_ITEM_NUM  --1		--self.content_.data.item.num
    self.peach_ = CloudData.DIARY_SUCCESS_AWARD_PEACH   --0			--self.content_.data.peach
    self.pieceId_ = CloudData.DIARY_SUCCESS_AWARD_PIECE_ID  --8		--self.content_.data.piece.id
    self.pieceNum_ = CloudData.DIARY_SUCCESS_AWARD_PIECE_NUM    --0		--self.content_.data.piece.num
    self.sweep_ = CloudData.DIARY_SUCCESS_AWARD_SWEEP   --0			--self.content_.data.sweep
	
	self:showDiarySuccess_()
end

function CommonResultLayer:initTrialSuccessData_()
    self.buddhaId_ = CloudData.CHALLENGE_SUCCESS_AWARD_NPCID    --87		--self.content_.data.npcId
	
	self.BuddhaModel = DataUtils.getBuddhaModel(tonumber(self.buddhaId_))
	self.buddhaQuality_ = tonumber(self.BuddhaModel.quality_) + 1
	if self.buddhaQuality_ == 1 then
        self.lebelColor_ = cc.c4b(150,86,40,255)
    elseif self.buddhaQuality_ == 2 then
        self.lebelColor_ = cc.c4b(77,212,14,255)
    elseif self.buddhaQuality_ == 3 then
        self.lebelColor_ = cc.c4b(38,185,230,255)
    elseif self.buddhaQuality_ == 4 then
        self.lebelColor_ = cc.c4b(205,42,245,255)
    elseif self.buddhaQuality_ == 5 then
        self.lebelColor_ = cc.c4b(255,230,100,255)
    end
	self.buddhaName_ = self.BuddhaModel.name_
	print("self.buddhaName_ **"..self.buddhaName_)
	self.buddhaImg_ = self.BuddhaModel.icon_
	self:showTrialSuccess_()
end

function CommonResultLayer:initSuccessUI_()
	audio.stopMusic()
	if GameManager.SOUND_SWITCH_ON then
		audio.playSound(string.format("sounds/sfx_win.%s",GameManager.POSTFIX))
	end
	--加载特效配置文件
	display.addSpriteFrames("animation/jiangli.plist","animation/jiangli.png")
    display.addSpriteFrames("animation/shengli_guangdian.plist","animation/shengli_guangdian.png")
    display.addSpriteFrames("animation/shengli_xingxing.plist","animation/shengli_xingxing.png")
    display.addSpriteFrames("animation/shengli_zouguang.plist","animation/shengli_zouguang.png")

	--“胜利”字样骨骼动画	
	cc.Texture2D:setDefaultAlphaPixelFormat(cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A4444 )
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("animation/game_win/shenglidonghau0.csb")
    local game_win = ccs.Armature:create("shenglidonghau")
    game_win:setPosition(0,display.height * 0.25)
    game_win:getAnimation():playWithIndex(0)
    self.emptyNode_:addChild(game_win,1)
    cc.Texture2D:setDefaultAlphaPixelFormat(cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888 )
	
	--添加背景图
	self.bg_ = display.newSprite("win_or_lose/bg_frame.png",0,-display.height * 0.07)
		:scale(0)
		:addTo(self.emptyNode_)
		--背景弹出效果
	local popupLayer = transition.sequence({cc.DelayTime:create(0.3),cc.ScaleTo:create(0.25, 1.2),cc.ScaleTo:create(0.15, 0.85),
		cc.ScaleTo:create(0.15, 1.0),cc.CallFunc:create(function()
			--加载物品掉落的UI
	    	self:addItemDropUI_()
		end)})
	self.bg_:runAction(popupLayer)

	--添加左侧唐僧头像
	display.newSprite("dialogue/tangseng/tangseng2.png",self.bg_:getContentSize().width * 0.2, self.bg_:getContentSize().height * 0.5)
		:scale(0.85)
		:addTo(self.bg_)

    --胜利动画出现到2/3时创建系列动画
    self:runAction(transition.sequence({cc.DelayTime:create(0.6),cc.CallFunc:create(function()
    	--"胜利"字样上的光点
    	local frames1 = display.newFrames("shengli-guangdian%d.png",1,32)
	    local animation1 = display.newAnimation(frames1,0.06)
	    local emptySp1 = display.newSprite("win_or_lose/first_guangdian.png",0,display.height * 0.25)
	    	:scale(2.0)
	    	:addTo(self.emptyNode_,2)
	    emptySp1:playAnimationForever(animation1)	

	    --"胜利"字样上层的星星闪烁
	    local frames2 = display.newFrames("shengli-xingxing%d.png",1,19)
	    local animation2 = display.newAnimation(frames2,0.15)
	    local emptySp2 = display.newSprite("win_or_lose/first_xx.png",0,display.height * 0.25)
	    	:scale(2.0)
	    	:addTo(self.emptyNode_,2)
	    emptySp2:playAnimationForever(animation2)
    end)}))
end

function CommonResultLayer:addItemDropUI_()
	--"通过奖励"和"物品掉落"字样
	display.newSprite("win_or_lose/exp_reward.png")
		:align(display.CENTER, self.bg_:getContentSize().width * 0.375, self.bg_:getContentSize().height * 0.46)
		:addTo(self.bg_)	

	--经验出现
	self:initSuccessType_()

	if self.resultTpye_ == RESULT_TYPE_WIN then
		--加载“胜利”上的走光动画
		self:runAction(transition.sequence({cc.DelayTime:create(0.7),cc.CallFunc:create(function()
			self.schedule_ = self:schedule(function()
			    local frames1 = display.newFrames("shengli-zouguang%d.png",1,28)
			    local animation1 = display.newAnimation(frames1,0.08)
			    local emptySp1 = display.newSprite("win_or_lose/first_blink.png",0,display.height * 0.22)
			    	:addTo(self.emptyNode_,2)
			    emptySp1:playAnimationOnce(animation1,true)	
		    end,3.2)
		end)}))	
	end
end

function CommonResultLayer:initSuccessType_()
	if self.type_ == RESULT_TYPE_DIARY_WIN then 
		-- print("initDiarySuccessData_")
		self:initDiarySuccessData_()
	elseif self.type_ == RESULT_TYPE_TRIAL_WIN then 
		-- print("initTrialSuccessData_")
		self:initTrialSuccessData_()
	elseif self.type_ == RESULT_TYPE_ACTIVITY_WIN then
		self:showActivitySuccess_()
	end
end

function CommonResultLayer:showDiarySuccess_()
	local pos1 = cc.p(self.bg_:getContentSize().width * 0.525, self.bg_:getContentSize().height * 0.46)
	local pos2 = cc.p(self.bg_:getContentSize().width * 0.74, self.bg_:getContentSize().height * 0.46)
	
	local pic1, pic2, num1, num2
	local sum = 0
	if self.expNum_ > 0 then
		pic1 = "win_or_lose/exp.png"
		num1 = self.expNum_
		sum = sum + 1
	end
	if self.itemNum_ > 0 then				
		pic2 = "item/item6.png"
		num2 = self.itemNum_
		sum = sum + 1
	end
	if self.peach_ > 0 then
		pic1 = "shop/peach_pic.png"
		num1 = self.peach_
		sum = sum + 1
	end
	if self.pieceNum_ > 0 then
		local monsterPieceModel   = DataUtils.getMonsterPieceModel(self.pieceId_)	
		pic1 = monsterPieceModel.pieceIconPath_
		num1 = self.pieceNum_
		sum = sum + 1
	end
	if self.sweep_ > 0 then
		pic2 = "shop/saodang.png"
		num2 = self.sweep_
		sum = sum + 1
	end
	
	local frame = display.newSprite(pic1)
		--:scale(0.45)
		:pos(pos1.x, pos1.y)
		:addTo(self.bg_)
		
	local label = cc.ui.UILabel.new({
        text = "x" .. num1,size = 26,align = cc.ui.TEXT_ALIGN_LEFT,dimensions = cc.size(150,30),font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,frame:getContentSize().width + 80, frame:getContentSize().height * 0.5)
        :addTo(frame)
	
	--创建特效
	local frames = display.newFrames("jiangli%d.png",1,15)
	local animation = display.newAnimation(frames,0.03)
	local emptySp = display.newSprite("win_or_lose/first_reward.png",pos1.x + 20,pos1.y)
		:scale(2.0)
		:addTo(self.bg_,1)
		emptySp:playAnimationOnce(animation,true)
			
	--创建动作
	local delay_   = cc.DelayTime:create(0.2)
	local fadeIn_  = cc.FadeIn:create(0.05)
	local scaleTo1 = cc.ScaleTo:create(0.1,1.0)
	local scaleTo2 = cc.ScaleTo:create(0.2,1.2)
	local scaleTo3 = cc.ScaleTo:create(0.2,1.0)					
	
	local callFun = nil
				
	if sum > 1 then
		callFun = cc.CallFunc:create(function()
				self:secondAwardShow_(pic2, num2, pos2)
			end)	
	else
		callFun = cc.CallFunc:create(function()
				self:actionEnd_()
			end)
	end
	label:runAction(transition.sequence({delay_,fadeIn_,scaleTo1,scaleTo2,scaleTo3,callFun}))
end

function CommonResultLayer:showTrialSuccess_()
	local frame = display.newSprite("upgrade/q"..self.buddhaQuality_..".png")
		--:scale(0.45)
		:pos(self.bg_:getContentSize().width * 0.525, self.bg_:getContentSize().height * 0.46)
		:addTo(self.bg_)
	
	display.newSprite(self.buddhaImg_)
		:pos(frame:getContentSize().width * 0.5,frame:getContentSize().height * 0.5)
		:addTo(frame)
		
	local label = cc.ui.UILabel.new({
        text = self.buddhaName_,size = 26,align = cc.ui.TEXT_ALIGN_LEFT,color = self.lebelColor_, dimensions = cc.size(150,30),font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,frame:getContentSize().width + 100, frame:getContentSize().height * 0.5)
        :addTo(frame)
		
	--创建特效
	local frames = display.newFrames("jiangli%d.png",1,15)
	local animation = display.newAnimation(frames,0.03)
	local emptySp = display.newSprite("win_or_lose/first_reward.png",frame:getPositionX() + 20,frame:getPositionY())
	    :scale(2.0)
	    :addTo(self.bg_,1)
		emptySp:playAnimationOnce(animation,true)
		
	--创建动作
	local delay_   = cc.DelayTime:create(0.2)
	local fadeIn_  = cc.FadeIn:create(0.05)
	local scaleTo1 = cc.ScaleTo:create(0.1,1.0)
	local scaleTo2 = cc.ScaleTo:create(0.2,1.2)
	local scaleTo3 = cc.ScaleTo:create(0.2,1.0)
	local fun = cc.CallFunc:create(function()
			print("Trail buddha state = " .. (self.BuddhaModel.buddhaState_))
			if self.BuddhaModel.buddhaState_ == 1 then
				print("Trail buddha p;;;;;;;pp; ")
				CloudData.ESSENCE = CloudData.ESSENCE + self.BuddhaModel.essenceValue_
			else
				print("Trail new new new faighf ")
				local layer = NewFellowLayer.new(self.BuddhaModel)
					self:addChild(layer,50)
					DataUtils.setNewBuddhaCloudData(self.buddhaId_)
			end
		end)					
	label:runAction(transition.sequence({delay_,fadeIn_,scaleTo1,scaleTo2,scaleTo3,fun,cc.CallFunc:create(function()
			self:actionEnd_()
		end)}))
end

function CommonResultLayer:showActivitySuccess_()
	-- 边框
	local frame = display.newSprite("sign/signk.png")
		:scale(0.8)
		:pos(self.bg_:getContentSize().width * 0.525, self.bg_:getContentSize().height * 0.46)
		:addTo(self.bg_)
	-- 代币图标
	display.newSprite("activity_stage/activity_coin.png")
		:scale(105/95)
		:pos(frame:getContentSize().width * 0.5,frame:getContentSize().height * 0.5)
		:addTo(frame)
	-- 代币数量
	cc.ui.UILabel.new({
        UILabelType = 1,text = string.format("*%d",CloudData.ACTIVITY_COINS_ADD_NUM) ,font = "fonts/whiteNum.fnt"})
    	:scale(1.0)
        :align(display.CENTER_LEFT,self.bg_:getContentSize().width * 0.525 + frame:getContentSize().width * 0.5,self.bg_:getContentSize().height * 0.36)
        :addTo(self.bg_,3)   

    -- 
    self:performWithDelay(function()
    	self:actionEnd_()
    end,1.0) 
end

--★★失败弹窗★★
function CommonResultLayer:showFailure_()
	print("richang 失败")
	audio.stopMusic()
	if GameManager.SOUND_SWITCH_ON then
		audio.playSound(string.format("sounds/sfx_failed.%s",GameManager.POSTFIX))
	end
	print("richang 失败1")
	--添加背景图
	self.bg_ = display.newSprite("win_or_lose/bg_frame.png",0,-display.height * 0.07)
		:scale(0)
		:addTo(self.emptyNode_)
		--背景弹出效果
	local popupLayer = transition.sequence({cc.DelayTime:create(0.25),cc.ScaleTo:create(0.15, 1.2),cc.ScaleTo:create(0.15, 0.85),
		cc.ScaleTo:create(0.1, 1.0)})
	self.bg_:runAction(popupLayer)

	--跳出失败字样
	local losePic = display.newSprite("win_or_lose/lose_pic.png",self.bg_:getContentSize().width * 0.5,self.bg_:getContentSize().height)
		:scale(2.0)
		:opacity(0)
		:addTo(self.bg_)
		--创建动作
	local delay1   = cc.DelayTime:create(0.5)
	local fadeIn1  = cc.FadeIn:create(0.1)
	local scaleTo1 = cc.ScaleTo:create(0.1,0.75)
	local scaleTo2 = cc.ScaleTo:create(0.2,1.2)
	local scaleTo3 = cc.ScaleTo:create(0.2,1.0)
	losePic:runAction(transition.sequence({delay1,cc.Spawn:create(fadeIn1,scaleTo1),scaleTo2,scaleTo3,cc.CallFunc:create(function()
		self:loseTipShow_()
	end)}))
end

--奖励2出现
function CommonResultLayer:secondAwardShow_(img, num, pos)
	--奖励2图标
	print("secondAwardShow_")
	local pic = display.newSprite(img,pos.x, pos.y)
		:addTo(self.bg_)

	local label = cc.ui.UILabel.new({
        text = "x" .. num,size = 36,color = display.COLOR_WHITE,font = GameManager.FONTNAME_TTF})
        :align(display.LEFT,pic:getPositionX() + pic:getContentSize().width/2 + 5, pic:getPositionY())
        :scale(1.5)
       -- :opacity(0)
        :addTo(self.bg_,2)
	
	--创建动作
	local delay_   = cc.DelayTime:create(0.2)
	local fadeIn_  = cc.FadeIn:create(0.05)
	local scaleTo1 = cc.ScaleTo:create(0.1,1.0)
	local scaleTo2 = cc.ScaleTo:create(0.2,1.2)
	local scaleTo3 = cc.ScaleTo:create(0.2,1.0)
	label:runAction(transition.sequence({delay_,fadeIn_,scaleTo1,scaleTo2,scaleTo3,cc.CallFunc:create(function()
		self:actionEnd_()
	end)}))
		
	--创建特效
		local frames = display.newFrames("jiangli%d.png",1,15)
	    local animation = display.newAnimation(frames,0.03)
	    local emptySp = display.newSprite("win_or_lose/first_reward.png",pic:getPositionX() + 10,pic:getPositionY())
	    	:scale(2.0)
	    	:addTo(self.bg_,1)
	    emptySp:playAnimationOnce(animation,true)		
end

--失败时的温馨提示
function CommonResultLayer:loseTipShow_()
	--生成随机数
	local randomNum = math.random(1,10)
	--读取csv文件
    local loseTipInfo = DataRetainer.LOSE_TIP_INFO
    --读第1行，获得各属性所在的列index
    local _idColumn    = loseTipInfo:findIndexOfValueFromRow(1,"id")          --id
    local _tipColumn   = loseTipInfo:findIndexOfValueFromRow(1,"tips")        --tips
    --查找 id 所在的行
    local _idRow = loseTipInfo:findIndexOfValueFromColumn(_idColumn,randomNum.."")
    --解析tip
    local tip = loseTipInfo:getData(_idRow,_tipColumn)

    --红色感叹号
    local tipFrame = display.newSprite("win_or_lose/alert.png",
    	self.bg_:getContentSize().width * 0.25,self.bg_:getContentSize().height * 0.55)
    	:addTo(self.bg_)

    --加载小提示
    local tipLabel = cc.ui.UILabel.new({
        UILabelType = 2,text = tip ,size = 24,color = display.COLOR_WHITE,align = cc.ui.TEXT_ALIGN_LEFT,dimensions = cc.size(480,105),font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,self.bg_:getContentSize().width * 0.5,self.bg_:getContentSize().height * 0.42)
        :opacity(0)
        :addTo(self.bg_)
    tipLabel:runAction(transition.sequence({cc.FadeIn:create(1.5),cc.CallFunc:create(function()
    	self:actionEnd_()
    end)}))   
end

--所有动作结束，点击任意地方继续
function CommonResultLayer:actionEnd_()
	display.newSprite("win_or_lose/continue.png")
		:align(display.CENTER, self.bg_:getContentSize().width * 0.5, self.bg_:getContentSize().height * (-0.15))
		:addTo(self.bg_)

	self.emptyNode_:setTouchEnabled(true)
end

function CommonResultLayer:returnCallBack_()
	print("***return!***")
    display.replaceScene(require("scenes.TinyLoadingScene").new("CHAPTER_SCENE"))
end

return CommonResultLayer