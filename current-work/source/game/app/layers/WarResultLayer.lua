--
--战斗结果显示界面（胜利，失败，扫荡）
--

RESULT_TYPE_WIN      = 1
RESULT_TYPE_LOSE     = 2
RESULT_TYPE_SWEEP    = 3
	
local BuyEnergyLayer  = import("layers.BuyEnergyLayer")
local AlertConnection = import("customs.AlertConnection")

local WarResultLayer = class("WarResultLayer", function()
	return display.newLayer()
end)

function WarResultLayer:ctor(resultType)
	--1.经验奖励：        self.rewardExpNum_
	--2.蟠桃奖励：        self.rewardPeachNum_
	--3.宝物碎片品质：    self.treasurePieceQuality_
	--4.妖怪碎片id数组：  self.monsterPieceIdTable_
	--5.妖怪碎片数量数组：self.monsterPieceNumTable_
    self.rewardExpNum_         = Game.EXP_ADD                       --5000
    self.rewardPeachNum_       = Game.PEACH_ADD                     --5
    self.treasurePieceQuality_ = Game.TREASURE_PIECE_QUALITY        --3
    self.monsterPieceIdTable_  = Game.MONSTER_PIECE_ID_TABLE        --{4,7}
    self.monsterPieceNumTable_ = Game.MONSTER_PIECE_NUM_TABLE       --{8,5}
	
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
		
    --读取当前关卡编号
    self.currStageNum_ = GameManager.STAGE_NUM

	--结果类型(胜利，失败，扫荡)
	self.resultTpye_ = resultType
	if self.resultTpye_ == RESULT_TYPE_WIN then 
		--DataEye统计关卡
        if USE_DATAEYE then  
            DCLevels.complete(CloudData.STAGE_PROGRESS .. "")                       
        end
		self:showSuccess_()
	elseif self.resultTpye_ == RESULT_TYPE_LOSE then
		--DataEye统计关卡
        if USE_DATAEYE then  
            DCLevels.fail(CloudData.STAGE_PROGRESS .. "", "level failed")               
        end
		self:showFailure_()
	else
		self:showSweep_()
	end
end

--★★胜利弹窗★★
function WarResultLayer:showSuccess_()
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
		:addTo(self.bg_,3)

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

--★★失败弹窗★★
function WarResultLayer:showFailure_( ... )
    audio.stopMusic()
	if GameManager.SOUND_SWITCH_ON then
		audio.playSound(string.format("sounds/sfx_failed.%s",GameManager.POSTFIX))
	end
	
	--DataEye统计
    if USE_DATAEYE then 
        DCEvent.onEvent("stage_progress_" .. CloudData.STAGE_PROGRESS .."_failed") 
    end

	--添加背景图
	self.bg_ = display.newSprite("win_or_lose/bg_frame.png",0,0)
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
	-- losePic:runAction(transition.sequence({delay1,cc.Spawn:create(fadeIn1,scaleTo1),scaleTo2,scaleTo3,cc.CallFunc:create(function()
	-- 	self:expShow_()
	-- end)}))
	losePic:runAction(transition.sequence({delay1,cc.Spawn:create(fadeIn1,scaleTo1),scaleTo2,scaleTo3,cc.CallFunc:create(function()
		self:loseTipShow_()
	end)}))
end

--★★扫荡弹窗★★
function WarResultLayer:showSweep_( ... )
    if GameManager.SOUND_SWITCH_ON then
		audio.playSound(string.format("sounds/sfx_win.%s",GameManager.POSTFIX))
	end
    
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

	--创建扫荡动画
	display.addSpriteFrames("animation/sweep_tx.plist","animation/sweep_tx.png")
	local frames = display.newFrames("saodang%d.png",1,10)
    local animation = display.newAnimation(frames,0.05)
    local emptySp = display.newSprite("win_or_lose/first_sweep.png",0,display.height * 0.2)
    	:addTo(self.emptyNode_,2)
    emptySp:playAnimationOnce(animation,false,nil,0.1)
end

function WarResultLayer:addItemDropUI_()
	--"通过奖励"和"物品掉落"字样
	local pic1 = display.newSprite("win_or_lose/exp_reward.png")
		:align(display.CENTER, self.bg_:getContentSize().width * 0.40, self.bg_:getContentSize().height * 0.62)
		:addTo(self.bg_)	
	local pic2 =  display.newSprite("win_or_lose/piece_reward.png")
		:align(display.CENTER, self.bg_:getContentSize().width * 0.40, self.bg_:getContentSize().height * 0.26)
		:addTo(self.bg_)

	--经验出现
	self:expShow_()

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
	else
	   pic1:setPositionX(self.bg_:getContentSize().width * 0.35)
	   pic2:setPositionX(self.bg_:getContentSize().width * 0.35)
	end
end

--经验出现
function WarResultLayer:expShow_()
	--经验图标
	local expPic = display.newSprite("win_or_lose/exp.png",self.bg_:getContentSize().width * 0.53, self.bg_:getContentSize().height * 0.62)
		:scale(0.7)
		:addTo(self.bg_)

	--经验数量
	local expRewardNum = self.rewardExpNum_
	local expNumLabel = cc.ui.UILabel.new({
        UILabelType = 2,text = string.format("+"..expRewardNum),size = 36,color = display.COLOR_WHITE,font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,self.bg_:getContentSize().width * 0.63, self.bg_:getContentSize().height * 0.62)
        :scale(1.5)
        :opacity(0)
        :addTo(self.bg_,2)
    	--创建动作
	local delay_   = cc.DelayTime:create(0.2)
	local fadeIn_  = cc.FadeIn:create(0.05)
	local scaleTo1 = cc.ScaleTo:create(0.1,1.0)
	local scaleTo2 = cc.ScaleTo:create(0.2,1.2)
	local scaleTo3 = cc.ScaleTo:create(0.2,1.0)
					
    if self.resultTpye_ == RESULT_TYPE_WIN then      --胜利
		--创建特效
		local frames = display.newFrames("jiangli%d.png",1,15)
	    local animation = display.newAnimation(frames,0.03)
	    local emptySp = display.newSprite("win_or_lose/first_reward.png",expPic:getPositionX() + 20,expPic:getPositionY())
	    	:scale(2.0)
	    	:addTo(self.bg_,1)
	    emptySp:playAnimationOnce(animation,true)

	    expNumLabel:runAction(transition.sequence({delay_,fadeIn_,scaleTo1,scaleTo2,scaleTo3,cc.CallFunc:create(function()
			self:peachShow_()
		end)}))
 
	elseif self.resultTpye_ == RESULT_TYPE_LOSE then  --失败
		expPic:setPosition(self.bg_:getContentSize().width * 0.45, self.bg_:getContentSize().height * 0.27)
		expNumLabel:setPosition(self.bg_:getContentSize().width * 0.45 + expPic:getContentSize().width * 0.5,self.bg_:getContentSize().height * 0.27)
		expNumLabel:setAnchorPoint(0,0.5)
	    expNumLabel:runAction(transition.sequence({delay_,fadeIn_,scaleTo1,scaleTo2,scaleTo3,cc.CallFunc:create(function()
			self:actionEnd_()
		end)}))

	else                                             --扫荡
	    expNumLabel:runAction(transition.sequence({delay_,fadeIn_,scaleTo1,scaleTo2,scaleTo3,cc.CallFunc:create(function()
			self:peachShow_()
		end)}))
	end
end

--蟠桃出现
function WarResultLayer:peachShow_()
	--蟠桃图标
	-- display.newSprite("shop/peach_pic.png",self.bg_:getContentSize().width * 0.75, self.bg_:getContentSize().height * 0.62)
	-- 	:scale(0.4)
	-- 	:addTo(self.bg_)

	-- --蟠桃数量
	-- local peachRewardNum = self.rewardPeachNum_
	-- local peachNumLabel = cc.ui.UILabel.new({
 --        UILabelType = 2,text = string.format("x"..peachRewardNum),size = 36,color = display.COLOR_WHITE,font = GameManager.FONTNAME_TTF})
 --        :align(display.CENTER,self.bg_:getContentSize().width * 0.79, self.bg_:getContentSize().height * 0.62)
 --        :scale(1.5)
 --        :opacity(0)
 --        :addTo(self.bg_,2)
 --    	--创建动作
	-- local delay_   = cc.DelayTime:create(0.2)
	-- local fadeIn_  = cc.FadeIn:create(0.05)
	-- local scaleTo1 = cc.ScaleTo:create(0.1,1.0)
	-- local scaleTo2 = cc.ScaleTo:create(0.2,1.2)
	-- local scaleTo3 = cc.ScaleTo:create(0.2,1.0)
	-- peachNumLabel:runAction(transition.sequence({delay_,fadeIn_,scaleTo1,scaleTo2,scaleTo3,cc.CallFunc:create(function()
	-- 	self:treasurePieceShow_()
	-- end)}))

	-- if self.resultTpye_ == RESULT_TYPE_WIN then
	-- 	--创建特效
	-- 	local frames = display.newFrames("jiangli%d.png",1,15)
	--     local animation = display.newAnimation(frames,0.03)
	--     local emptySp = display.newSprite("win_or_lose/first_reward.png",
	--     	self.bg_:getContentSize().width * 0.75 + 10,self.bg_:getContentSize().height * 0.62)
	--     	:scale(2.0)
	--     	:addTo(self.bg_,1)
	--     emptySp:playAnimationOnce(animation,true)
	-- end	

	self:treasurePieceShow_()		
end

--宝物碎片出现
function WarResultLayer:treasurePieceShow_()
	--若没掉宝物碎片，则直接出现妖怪碎片
	if self.treasurePieceQuality_ == 0 then
		self:monsterPieceJudge_()
	else
		--宝物碎片图片
		local treasurePiecePic = display.newSprite(string.format("treasure/alert/piece"..self.treasurePieceQuality_..".png"),
			self.bg_:getContentSize().width * 0.51,self.bg_:getContentSize().height * 0.26)
			:scale(1.2)
			:addTo(self.bg_)
		treasurePiecePic:runAction(cc.ScaleTo:create(0.1,0.7))

		if self.resultTpye_ == RESULT_TYPE_WIN then
			--创建特效
			local frames = display.newFrames("jiangli%d.png",1,15)
		    local animation = display.newAnimation(frames,0.03)
		    local emptySp = display.newSprite("win_or_lose/first_reward.png",
		    	treasurePiecePic:getPositionX() + 10,treasurePiecePic:getPositionY())
		    	:scale(2.0)
		    	:addTo(self.bg_,1)
		    emptySp:playAnimationOnce(animation,true)
	    end

	    --碎片名称
	    local currStage = GameManager.STAGE_NUM
	    local treasurePieceModel = DataUtils.getTreasurePieceModel(currStage)
	    local treasurePieceName  = treasurePieceModel.treasurePieceName_
	    local nameLabel = cc.ui.UILabel.new({
	        UILabelType = 2,text = treasurePieceName,size = 20,color = display.COLOR_WHITE,font = GameManager.FONTNAME_TTF})
	        :align(display.CENTER_LEFT,self.bg_:getContentSize().width * 0.51 + treasurePiecePic:getContentSize().width * 0.36,self.bg_:getContentSize().height * 0.22)
	        :opacity(0)
	        :addTo(self.bg_)
        --nameLabel:setAnchorPoint(0,0.5)
        nameLabel:runAction(transition.sequence({cc.DelayTime:create(0.12),cc.FadeIn:create(0.05),cc.CallFunc:create(function()
        	self:monsterPieceJudge_()
        end)}))
	end
end

--妖怪碎片判断
function WarResultLayer:monsterPieceJudge_()
	local monsterPieceCountNum = #self.monsterPieceIdTable_
	if monsterPieceCountNum == 0 then
		self:actionEnd_()
	else
        self:monsterPieceShow_(monsterPieceCountNum, 1)
	end
end	

--妖怪碎片出现
function WarResultLayer:monsterPieceShow_( num ,count)
    if 0 == num then 
    	self:actionEnd_()
    	return 
    end
    
    local monsterPieceNum     = self.monsterPieceNumTable_[num]         --CloudData.MONSTER_PIECE_INFO[monsterPieceId]
    if monsterPieceNum == 0 then      
        self:monsterPieceShow_(num - 1, count)
        return  
    end
	--读取monsterPieceModel
	local monsterPieceId      = self.monsterPieceIdTable_[num]
	local monsterPieceModel   = DataUtils.getMonsterPieceModel(monsterPieceId)
	local monsterPieceQuality = tonumber(monsterPieceModel.quality_)
	local monsterPieceIcon    = monsterPieceModel.pieceIconPath_
	
    local monsterPieceName    = monsterPieceModel.monsterPieceDesc_

	--碎片边框
	local pieceFrame = display.newSprite(string.format("monster_piece_icon/quality"..monsterPieceQuality..".png"))
		:scale(1.5)
		:pos(self.bg_:getContentSize().width * (0.51 + 0.16 * count),self.bg_:getContentSize().height * 0.26)
		:addTo(self.bg_)
		--若没有掉宝，则位置左移
	if self.treasurePieceQuality_ == 0 then
		pieceFrame:setPosition(self.bg_:getContentSize().width * (0.315 + 0.2 * count),self.bg_:getContentSize().height * 0.26)
	end
--	num = num - 1    --num-1做循环

	--碎片图标
	display.newSprite(monsterPieceIcon,pieceFrame:getContentSize().width * 0.5,pieceFrame:getContentSize().height * 0.5)
		:addTo(pieceFrame)
	pieceFrame:runAction(cc.ScaleTo:create(0.1,0.75))

	if self.resultTpye_ == RESULT_TYPE_WIN then
		--创建特效
		local frames = display.newFrames("jiangli%d.png",1,15)
	    local animation = display.newAnimation(frames,0.03)
	    local emptySp = display.newSprite("win_or_lose/first_reward.png",
	    	pieceFrame:getPositionX() + 10,pieceFrame:getPositionY())
	    	:scale(2.0)
	    	:addTo(self.bg_,1)
	    emptySp:playAnimationOnce(animation,true)
    end

    --碎片数量
    local pieceNumLabel = cc.ui.UILabel.new({
        UILabelType = 2,text = string.format("x"..monsterPieceNum),size = 20,color = display.COLOR_WHITE,font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,pieceFrame:getContentSize().width * 0.93, pieceFrame:getContentSize().height * 0.05)
        --:opacity(0)
        :addTo(pieceFrame,1)
        
    --碎片名字
    local pieceNumLabel = cc.ui.UILabel.new({
        UILabelType = 2,text = monsterPieceName,size = 23,color = display.COLOR_WHITE,font = GameManager.FONTNAME_TTF})
        :align(display.CENTER_LEFT,pieceFrame:getContentSize().width,pieceFrame:getContentSize().height * 0.35)
        :opacity(0)
        :addTo(pieceFrame)
    
    pieceNumLabel:runAction(transition.sequence({cc.DelayTime:create(0.12),cc.FadeIn:create(0.05),cc.CallFunc:create(function()
        if num == 1 then
    		self:actionEnd_()
		else
			self:monsterPieceShow_(num - 1, count + 1)
    	end
    end)}))
end	

--失败时的温馨提示
function WarResultLayer:loseTipShow_()
	--红色感叹号
	local alertPic = display.newSprite("win_or_lose/alert.png",self.bg_:getContentSize().width * 0.25,self.bg_:getContentSize().height * 0.55)
		:addTo(self.bg_)

	--生成随机数
	local randomNum = 0 
	--获取关卡model
	local stageModel = DataUtils.getStageModel(self.currStageNum_)

	--根据关卡选择不同的tip
	if self.currStageNum_ % 10 == 0 then    --boss关
		randomNum = math.random(11,12)
	elseif tonumber(stageModel.isGrooveMode_) == 1 then    --卡槽关卡
		randomNum = math.random(13,14)
	elseif tonumber(stageModel.isGrooveMode_) == 2 then    --剪刀石头布关卡
		randomNum = math.random(15,17)
	else
		randomNum = math.random(1,10)
	end	
	
	--读取csv文件
    local loseTipInfo = DataRetainer.LOSE_TIP_INFO
    --读第1行，获得各属性所在的列index
    local _idColumn    = loseTipInfo:findIndexOfValueFromRow(1,"id")          --id
    local _tipColumn   = loseTipInfo:findIndexOfValueFromRow(1,"tips")        --tips
    --查找 id 所在的行
    local _idRow = loseTipInfo:findIndexOfValueFromColumn(_idColumn,randomNum.."")
    --解析tip
    local tip = loseTipInfo:getData(_idRow,_tipColumn)

    --加载小猴子背景
    -- local tipFrame = display.newSprite("win_or_lose/lose_tip.png",
    -- 	self.bg_:getContentSize().width * 0.5,self.bg_:getContentSize().height * 0.23)
    -- 	:addTo(self.bg_)

    --加载小提示
    local tipLabel = cc.ui.UILabel.new({
        UILabelType = 2,text = tip ,size = 24,color = display.COLOR_WHITE,align = cc.ui.TEXT_ALIGN_LEFT,dimensions = cc.size(480,105),font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,self.bg_:getContentSize().width * 0.5,self.bg_:getContentSize().height * 0.445)
        :opacity(0)
        :addTo(self.bg_)
    tipLabel:runAction(transition.sequence({cc.FadeIn:create(1.0),cc.CallFunc:create(function()
    	self:expShow_()
    end)}))
end

--所有动作结束，点击任意地方继续
function WarResultLayer:actionEnd_()
	--若失败则出现"去升级"和"重新挑战"
	if self.resultTpye_ == RESULT_TYPE_LOSE then
		--pTip:setPositionY(-self.bg_:getContentSize().height * 0.35)

		cc.ui.UIPushButton.new({normal = "win_or_lose/to_upgrade1.png",pressed = "win_or_lose/to_upgrade2.png"})
			:onButtonClicked(function()
				GameManager.BUDDHA_MODEL_TABLE  = DataUtils.getBuddhaModelsTableUpgradeScene("BUDDHA")
		        print("1 done")
		        GameManager.MONSTER_MODEL_TABLE = DataUtils.getBuddhaModelsTableUpgradeScene("MONSTER")
		        print("2 done")
		        GameManager.TOWER_MODEL_TABLE   = DataUtils.getTableUpgradePropertyModel("TOWER")
		        print("3 done")
		        GameManager.TANG_MODEL_TABLE    = DataUtils.getTableUpgradePropertyModel("TANG")
		        print("4 done")
			    display.replaceScene(require("layers.UpgradeBuddhaLayer").new())
			end)
			:align(display.CENTER,self.bg_:getContentSize().width * 0.5, self.bg_:getContentSize().height * 0.135)
			:zorder(2)
			:addTo(self.bg_)

		cc.ui.UIPushButton.new({normal = "win_or_lose/restart1.png",pressed = "win_or_lose/restart2.png"})
			:onButtonClicked(function()
				local stageModel = DataUtils.getStageModel(self.currStageNum_)
			    --精力消耗
			    local energyCostNum = stageModel.energyCost_
			    if CloudData.ENERGY >= tonumber(energyCostNum) then
			        local ac = AlertConnection.new(CONNECTION_COST_ENERGY,self.currStageNum_)
			        self:addChild(ac,100,12345)

			        self.scheduleResult_ = self:schedule(function() 
			            if not self:getChildByTag(12345) then
			                self:stopAction(self.scheduleResult_)
							audio.stopMusic()
							if GameManager.SOUND_SWITCH_ON then
								audio.playSound(string.format("sounds/sfx_go.%s",GameManager.POSTFIX))
							end                            
			                CloudData.ENERGY = CloudData.ENERGY - energyCostNum
			                display.replaceScene(require("scenes.TinyLoadingScene").new("GAME_SCENE","NORMAL"))
			            end
			        end,0.1)
			    else
			        local bnl = BuyEnergyLayer.new()
			        self:addChild(bnl,50)
	    		end
			end)
			:align(display.CENTER,self.bg_:getContentSize().width * 0.35, -self.bg_:getContentSize().height * 0.12)
			:zorder(2)
			:addTo(self.bg_)

		cc.ui.UIPushButton.new({normal = "win_or_lose/exit.png",pressed = "win_or_lose/exit1.png"})
			:onButtonClicked(function()
				self:returnCallBack_()			    
			end)
			:align(display.CENTER,self.bg_:getContentSize().width * 0.65, -self.bg_:getContentSize().height * 0.12)
			:zorder(2)
			:addTo(self.bg_)
	else
		local pTip = display.newSprite("win_or_lose/continue.png")
		:align(display.CENTER, self.bg_:getContentSize().width * 0.5, self.bg_:getContentSize().height * (-0.15))
		:addTo(self.bg_)
		self.emptyNode_:setTouchEnabled(true)
	end	
end

function WarResultLayer:returnCallBack_()
	print("***return!***")

	if self.resultTpye_ == RESULT_TYPE_SWEEP then
		local popupLayer = transition.sequence({cc.ScaleTo:create(0,1.0),
	        cc.ScaleTo:create(0.1,1.1),
	        cc.ScaleTo:create(0.2,0),cc.CallFunc:create(function()
	            self:removeSelf()
	        end)
	        })
	    self.emptyNode_:runAction(popupLayer)
	else
        display.replaceScene(require("scenes.TinyLoadingScene").new("CHAPTER_SCENE"))
		--display.replaceScene(require("ChapterScene").new())
    end
end

return WarResultLayer