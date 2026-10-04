
--[[=============================================================================
#     FileName: InfiniteModeResultLayer.lua
#         Desc: 无尽模式战斗结束结算界面
#       Author: Hoo
#   LastChange: 2015-03-24 
#      History:
=============================================================================]]	

RESULT_TYPE_WIN   = 1
RESULT_TYPE_LOSE  = 2

local InfiniteModeResultLayer = class("InfiniteModeResultLayer", function()
	return display.newLayer()
end)

function InfiniteModeResultLayer:ctor(resultType)
	-- 1.精华石奖励        self.rewardEssenceNum_
	-- 2.神秘奖励类型      self.unknownType_ 
	-- 2.神秘奖励数量      self.rewardUnknownNum_
	-- 3.妖怪碎片奖励      self.monsterPieceId_
	
    self.rewardEssenceNum_ = 100   
    self.unknownType_      = "sweep"     
    self.rewardUnknownNum_ = 50               --5
    self.monsterPieceId_   = 20
	
	--添加遮罩层
	display.newColorLayer(cc.c4b(0,0,0,150)):addTo(self,-1)

	--初始化基础节点
	self.emptyNode_ = display.newNode()
	self.emptyNode_:setPosition(display.cx,display.cy)
	self:addChild(self.emptyNode_)
	-- --添加触摸事件
	-- self.emptyNode_:setTouchEnabled(false)	   --当UI界面展示结束后再开启点击事件
	-- self.emptyNode_:addNodeEventListener(cc.NODE_TOUCH_EVENT, function()
	-- 	return 	self:returnCallBack_()
	-- end)
	-- --添加空白图扩充点击区域
 --    local emptyLayer = display.newColorLayer(cc.c4b(255,255,255,0))
 --    emptyLayer:setAnchorPoint(0.5,0.5)
 --    emptyLayer:setContentSize(cc.size(display.width,display.height))
 --    self.emptyNode_:addChild(emptyLayer,-1)	

	--结果类型(胜利，失败，扫荡)
	self.resultTpye_ = resultType
	if RESULT_TYPE_WIN == resultType then 
		self:showSuccess_()
	elseif RESULT_TYPE_LOSE == resultType then
		self:showFailure_()
	end
end

--★★胜利弹窗★★
function InfiniteModeResultLayer:showSuccess_()
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

    --添加左侧唐僧头像
	display.newSprite("dialogue/tangseng/tangseng2.png",self.bg_:getContentSize().width * 0.2, self.bg_:getContentSize().height * 0.5)
		:scale(0.85)
		:addTo(self.bg_,3)

    --背景弹出效果
    local popupLayer = transition.sequence({cc.DelayTime:create(0.3),cc.ScaleTo:create(0.25, 1.2),cc.ScaleTo:create(0.15, 0.85),
		cc.ScaleTo:create(0.15, 1.0),cc.DelayTime:create(1.3),cc.CallFunc:create(function()
			--加载物品掉落的UI
	    	self:addItemDropUI_()
		end)})
	self.bg_:runAction(popupLayer)

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

    --加载“胜利”上的走光动画
	self:runAction(transition.sequence({cc.DelayTime:create(1.6),cc.CallFunc:create(function()
		self.schedule_ = self:schedule(function()
		    local frames1 = display.newFrames("shengli-zouguang%d.png",1,28)
		    local animation1 = display.newAnimation(frames1,0.08)
		    local emptySp1 = display.newSprite("win_or_lose/first_blink.png",0,display.height * 0.22)
		    	:addTo(self.emptyNode_,2)
		    emptySp1:playAnimationOnce(animation1,true)	
	    end,3.2)
	end)}))	
end

--★★失败弹窗★★
function InfiniteModeResultLayer:showFailure_( ... )
    audio.stopMusic()
	if GameManager.SOUND_SWITCH_ON then
		audio.playSound(string.format("sounds/sfx_failed.%s",GameManager.POSTFIX))
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

	losePic:runAction(transition.sequence({delay1,cc.Spawn:create(fadeIn1,scaleTo1),scaleTo2,scaleTo3,cc.CallFunc:create(function()
		self:loseTipShow_()
	end)}))
end

-- 物品掉落
function InfiniteModeResultLayer:addItemDropUI_()
	-- 过关奖励
	local pic1 = display.newSprite("win_or_lose/exp_reward.png")
		:align(display.CENTER, self.bg_:getContentSize().width * 0.40, self.bg_:getContentSize().height * 0.62)
		:addTo(self.bg_)	

	-- 精华石
	local essenceFrame = display.newSprite("upgrade/q1.png",
        self.bg_:getContentSize().width * 0.35,self.bg_:getContentSize().height * 0.35)
		:scale(0.60)
        :addTo(self.bg_,5)
        -- 精华图片
    display.newSprite("summon_scene/essence_pic.png",
        essenceFrame:getContentSize().width * 0.5,essenceFrame:getContentSize().height * 0.5)
        :addTo(essenceFrame)
        -- 精华数量
    -- cc.ui.UILabel.new({UILabelType = 2,text = string.format("X%d",CloudData.INFINITE_ESSENCE_NUM),
    --     size = 30,color = display.COLOR_WHITE,font = GameManager.FONTNAME_TTF})
    --     :align(display.CENTER_LEFT,essenceFrame:getPositionX() + essenceFrame:getContentSize().width * 0.55,self.bg_:getContentSize().height * 0.72)
    --     :addTo(self.bg_,5)
    cc.ui.UILabel.new({UILabelType = 1,text = string.format("*%d",CloudData.INFINITE_ESSENCE_NUM),font = "fonts/whiteNum.fnt"})
    	:scale(0.6)
        :align(display.CENTER_LEFT,essenceFrame:getPositionX() + essenceFrame:getContentSize().width * 0.32,self.bg_:getContentSize().height * 0.30)
        :addTo(self.bg_,5)
   	-- 数据更新
   	CloudData.ESSENCE = CloudData.ESSENCE + CloudData.INFINITE_ESSENCE_NUM

	-- 神秘奖励
	local itemFrame = display.newSprite("sign/signk.png",
        self.bg_:getContentSize().width * 0.50,self.bg_:getContentSize().height * 0.35)
		:scale(0.5)
        :addTo(self.bg_,5)
    local itemPic = display.newSprite("sign/exp.png",
        itemFrame:getContentSize().width * 0.5,itemFrame:getContentSize().height * 0.5)
        :addTo(itemFrame)
    local itemNumLabel = cc.ui.UILabel.new({UILabelType = 1,text = string.format("*%d",CloudData.INFINITE_GOODS_NUM),font = "fonts/whiteNum.fnt"})
    	:scale(0.6)
        :align(display.CENTER_LEFT,itemFrame:getPositionX() + itemFrame:getContentSize().width * 0.32,self.bg_:getContentSize().height * 0.30)
        :addTo(self.bg_,5)
	if CloudData.INFINITE_GOODS_TYPE == "sweep" then
		-- 扫荡券
		itemPic:setTexture("sign/saodang.png")
		-- 数据更新
   		CloudData.SWEEP = CloudData.SWEEP + CloudData.INFINITE_GOODS_NUM

	elseif CloudData.INFINITE_GOODS_TYPE == "exp" then
		-- 经验
		itemPic:setTexture("sign/exp.png")
		-- 数据更新
   		CloudData.EXP = CloudData.EXP + CloudData.INFINITE_GOODS_NUM

	elseif CloudData.INFINITE_GOODS_TYPE == "item" then
		-- 道具
		itemPic:setScale(105/95)
		if CloudData.INFINITE_GOODS_ITEM_ID == 1 then        -- 老君金丹
			itemPic:setTexture("item/item3_big.png")
		elseif CloudData.INFINITE_GOODS_ITEM_ID == 2 then    -- 金刚盾
			itemPic:setTexture("item/item1_big.png")
		elseif CloudData.INFINITE_GOODS_ITEM_ID == 3 then    -- 芭蕉扇
			itemPic:setTexture("item/item2_big.png")
		else
			itemPic:setTexture(string.format("item/item%d_big.png",CloudData.INFINITE_GOODS_ITEM_ID))
		end
		-- 数据更新
		CloudData.SKILL_ITEM_INFO[CloudData.INFINITE_GOODS_ITEM_ID] = CloudData.SKILL_ITEM_INFO[CloudData.INFINITE_GOODS_ITEM_ID] + CloudData.INFINITE_GOODS_NUM

	elseif CloudData.INFINITE_GOODS_TYPE == "renshen" then
		-- 人参果
		itemPic:setTexture("sign/renshen.png")
		-- 数据更新
   		CloudData.GINSENG_FRUIT = CloudData.GINSENG_FRUIT + CloudData.INFINITE_GOODS_NUM
	end

	-- 妖怪碎片
	if CloudData.INFINITE_MONSTER_PIECE_ID > 0 then
		local monsterPieceModel   = DataUtils.getMonsterPieceModel(CloudData.INFINITE_MONSTER_PIECE_ID)
		local monsterPieceQuality = tonumber(monsterPieceModel.quality_)
		local monsterPieceIcon    = monsterPieceModel.pieceIconPath_
	    local monsterPieceName    = monsterPieceModel.monsterPieceDesc_

		--碎片边框
		local pieceFrame = display.newSprite(string.format("monster_piece_icon/quality"..monsterPieceQuality..".png"))
			:scale(0.8)
			:pos(self.bg_:getContentSize().width * 0.65,self.bg_:getContentSize().height * 0.35)
			:addTo(self.bg_,5)
		-- 碎片图片	
		display.newSprite(monsterPieceIcon,pieceFrame:getContentSize().width * 0.5,pieceFrame:getContentSize().height * 0.5)
			:addTo(pieceFrame)
		--碎片数量
	    cc.ui.UILabel.new({
	        UILabelType = 1,text = string.format("*"..CloudData.INFINITE_MONSTER_PIECE_NUM),font = "fonts/whiteNum.fnt"})
	    	:scale(0.75)
	        :align(display.CENTER,pieceFrame:getContentSize().width * 1.3, pieceFrame:getContentSize().height * 0.15)
	        :addTo(pieceFrame,1)    
	    --碎片名字
	    cc.ui.UILabel.new({
	        UILabelType = 2,text = monsterPieceName,size = 28,color = display.COLOR_WHITE,font = GameManager.FONTNAME_TTF})
	        :align(display.CENTER_LEFT,pieceFrame:getContentSize().width * 1.7,pieceFrame:getContentSize().height * 0.20)
	        :addTo(pieceFrame)
	    -- 数据更新
        CloudData.MONSTER_PIECE_INFO[CloudData.INFINITE_MONSTER_PIECE_ID] = CloudData.MONSTER_PIECE_INFO[CloudData.INFINITE_MONSTER_PIECE_ID] + CloudData.INFINITE_MONSTER_PIECE_NUM
	end

	self:performWithDelay(function()
		self:actionEnd_()
	end,1.0)
end


--失败时的温馨提示
function InfiniteModeResultLayer:loseTipShow_()
	--红色感叹号
	local alertPic = display.newSprite("win_or_lose/alert.png",self.bg_:getContentSize().width * 0.25,self.bg_:getContentSize().height * 0.55)
		:addTo(self.bg_)

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

    --加载小提示
    local tipLabel = cc.ui.UILabel.new({
        UILabelType = 2,text = tip ,size = 24,color = display.COLOR_WHITE,align = cc.ui.TEXT_ALIGN_LEFT,dimensions = cc.size(480,105),font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,self.bg_:getContentSize().width * 0.5,self.bg_:getContentSize().height * 0.445)
        :opacity(0)
        :addTo(self.bg_)
    tipLabel:runAction(transition.sequence({cc.FadeIn:create(1.0),cc.CallFunc:create(function()
    	self:actionEnd_()
    end)}))
end

--所有动作结束，点击任意地方继续
function InfiniteModeResultLayer:actionEnd_()
	-- 退出战斗按钮
    cc.ui.UIPushButton.new({normal = "win_or_lose/exit.png",pressed = "win_or_lose/exit1.png"})
        :onButtonClicked(function()
            self:returnCallBack_()
        end)
        :align(display.CENTER,self.bg_:getContentSize().width * 0.65,-self.bg_:getContentSize().height * 0.15)
        :addTo(self.bg_,5)

    -- 排行榜按钮
    cc.ui.UIPushButton.new({normal = "win_or_lose/rankings.png",pressed = "win_or_lose/rankings1.png"})
	    :onButtonClicked(function()
	        self:rankingsCallBack_()
	    end)
	    :align(display.CENTER,self.bg_:getContentSize().width * 0.35,-self.bg_:getContentSize().height * 0.15)
	    :addTo(self.bg_,5)

	-- -- 点击任意区域返回
	-- local pTip = display.newSprite("win_or_lose/continue.png")
	-- :align(display.CENTER, self.bg_:getContentSize().width * 0.5, self.bg_:getContentSize().height * (-0.15))
	-- :addTo(self.bg_)
	-- self.emptyNode_:setTouchEnabled(true)
end

function InfiniteModeResultLayer:returnCallBack_()
    display.replaceScene(require("scenes.TinyLoadingScene").new("INFINITE_MODE_ENTRANCE"))
end
function InfiniteModeResultLayer:rankingsCallBack_()
    display.replaceScene(require("layers.ChartLayer").new())
end

return InfiniteModeResultLayer