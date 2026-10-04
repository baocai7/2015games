--
--点击召唤的弹出层
--

local NewFellowLayer   = import("layers.NewFellowLayer")

local SummonLayer = class("SummonLayer", function()
	return display.newLayer()
end)

function SummonLayer:ctor( type_,npcIdTable,essenceNumTable)

	--添加遮罩层
	display.newColorLayer(cc.c4b(0,0,0,150)):addTo(self,-1)

	--初始化基础节点
	self.emptyNode_ = display.newNode()
	self.emptyNode_:setPosition(display.cx,display.cy)
	self:addChild(self.emptyNode_)

	--弹出效果
	self.emptyNode_:setScale(0)
	local popupLayer = transition.sequence(
		{cc.ScaleTo:create(0.2, 1.1),
		cc.ScaleTo:create(0.1, 1.0)})
	self.emptyNode_:runAction(popupLayer)

    --播放音效(打开层)
	if GameManager.SOUND_SWITCH_ON then
		audio.playSound(string.format("sounds/sfx_touch_ti.%s",GameManager.POSTFIX))
	end

    --npcId
    if npcIdTable~= nil then
        self.npcIdTable_ = npcIdTable
    end
    
    --精华数
    if essenceNumTable ~= nil then
        self.essenceNumTable_ = essenceNumTable
    end

    --创建存储兵种model的Table
    self.buddhaModelTable_ = {}

    --创建存储兵种边框,头像,名称的table,以便转化精华的时候取对象
    self.iconFrameTable_ = {}
    self.iconTable_ = {}
    self.buddhaNameTable_ = {}

    --是否为新兵种
    self.isNewBuddha_ = false
    
    if type_ == 1 then
        --获取单抽的兵种信息
        self:generateSingleNpc_()     
    else
        --获取十连抽的兵种信息
        self:generateSummonTenNpcs_()
    end  
end

--获取单抽的兵种信息
function SummonLayer:generateSingleNpc_()
    local npcId = self.npcIdTable_[1]
    local buddhaModel = DataUtils.getBuddhaModel(npcId)
    table.insert(self.buddhaModelTable_,buddhaModel)
    self:initSingleSummonUI_(buddhaModel)
end
--获取十连的兵种信息
function SummonLayer:generateSummonTenNpcs_()
    
    for i=1,10 do
        local npcId = self.npcIdTable_[i]
        local buddhaModel = DataUtils.getBuddhaModel(npcId)
        table.insert(self.buddhaModelTable_,buddhaModel)
    end

    --背景
    self.bg_ = display.newSprite("summon_scene/alert_frame.png"):addTo(self.emptyNode_)

    --上方标签
    display.newSprite("summon_scene/summon_label.png",self.bg_:getContentSize().width * 0.5,self.bg_:getContentSize().height * 1.1)
        :addTo(self.bg_)

    --确定按钮
    self.ensureBtn_ = cc.ui.UIPushButton.new({normal = "common_ui/confirm.png",pressed = "common_ui/confirm_h.png"})
        :align(display.CENTER,self.bg_:getContentSize().width * 0.5,-self.bg_:getContentSize().height * 0.2)
        :onButtonClicked(function()
            self:closeCallBack_()
        end)
        :hide()
        :addTo(self.bg_)

    --开始十连抽
        --计数
    self.index_ = 1   
        --当前是否在召唤进程中
    self.isInProgress_ = false    
        --新兵种出现界面的检测
    GameManager.IS_NEWFELLOW_CLOSED   = true           
        --计时器
    self.schedule_ = self:schedule(function()
        self:initMultipleSummonUI_()
    end, 0.1)
end

--单抽
function SummonLayer:initSingleSummonUI_(buddhaModel)
    --背景
    local bg = display.newSprite("summon_scene/alert_frame.png"):addTo(self.emptyNode_)

    --确定按钮
    local ensureBtn = cc.ui.UIPushButton.new({normal = "common_ui/confirm.png",pressed = "common_ui/confirm_h.png"})
        :align(display.CENTER,bg:getContentSize().width * 0.5,-bg:getContentSize().height * 0.2)
        :onButtonClicked(function()
            self:closeCallBack_()
        end)
        :hide()
        :addTo(bg)

    --读取model数据
    local buddhaId      = tonumber(buddhaModel.npcId_)
    local buddhaName    = buddhaModel.name_
    local buddhaIcon    = buddhaModel.icon_
    local buddhaQuality = tonumber(buddhaModel.quality_) + 1
    local buddhaValue   = tonumber(buddhaModel.essenceValue_)
    --根据兵种品质给定名称显示颜色
    local labelColor = nil
    if buddhaQuality == 1 then
        labelColor = display.COLOR_WHITE
    elseif buddhaQuality == 2 then
        labelColor = display.COLOR_GREEN
    elseif buddhaQuality == 3 then
        labelColor = cc.c3b(38,189,254)
    elseif buddhaQuality == 4 then
        labelColor = cc.c3b(132,23,192)
    elseif buddhaQuality == 5 then
        labelColor = cc.c3b(254,145,38)
    end
    
    --上方标签
    display.newSprite("summon_scene/summon_label.png",bg:getContentSize().width * 0.5,bg:getContentSize().height * 1.1)
        :addTo(bg)

    --结果显示
        --图像边框
    local iconFrame = display.newSprite(string.format("upgrade/q"..buddhaQuality..".png"),
        bg:getContentSize().width * 0.5,bg:getContentSize().height * 1.3)
        :scale(0)
        :addTo(bg)
    table.insert(self.iconFrameTable_,iconFrame)
        --兵种图像
    local icon = display.newSprite(buddhaIcon,iconFrame:getContentSize().width * 0.5,iconFrame:getContentSize().height * 0.5)
        :addTo(iconFrame)
    if tonumber(buddhaModel.isRebel_) == 1 then
        icon:setScaleX(-1)
    end
    table.insert(self.iconTable_,icon)
        --兵种名称
    local name = cc.ui.UILabel.new({UILabelType = 2,text = buddhaName,size = 24,color = labelColor,font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,iconFrame:getContentSize().width * 0.5,-iconFrame:getContentSize().height * 0.3)
        :addTo(iconFrame)
    table.insert(self.buddhaNameTable_,name)

    --判断是否为新兵种
    local essenceNum = self.essenceNumTable_[1]
    CloudData.ESSENCE = CloudData.ESSENCE + essenceNum
    if essenceNum ~= 0 then       --重复兵种,转换为精华                          
        --创建转化的动画
        display.addSpriteFrames("summon_scene/zhuanhua.plist","summon_scene/zhuanhua.png")
        local frames = display.newFrames("zhuanhua%d.png",1,15)
        local animation = display.newAnimation(frames, 0.05)
        local animate = cc.Animate:create(animation)
        local emptySp = display.newSprite()
            :pos(iconFrame:getContentSize().width * 0.5,iconFrame:getContentSize().height * 0.5)
            :addTo(iconFrame,2)
        emptySp:runAction(transition.sequence({cc.DelayTime:create(0.95),
            animate,cc.CallFunc:create(function()
            self:changeToEssence_(1)
        end)}))
    end   

    --创建动作
    local spawn_ = cc.Spawn:create(cc.ScaleTo:create(0.1,1.0),
        cc.MoveTo:create(0.1,cc.p(bg:getContentSize().width * 0.5,bg:getContentSize().height * 0.5)))
    iconFrame:runAction(transition.sequence({cc.DelayTime:create(0.85),spawn_,cc.CallFunc:create(function()
        ensureBtn:show()
    end),cc.CallFunc:create(function()
        self:newFellowAction_(1)
    end)}))
end
--十连
function SummonLayer:initMultipleSummonUI_()
    if self.index_ == 11  then
        self:stopAction(self.schedule_)
    elseif (not self.isInProgress_) and GameManager.IS_NEWFELLOW_CLOSED then
        self.isInProgress_ = true
        GameManager.IS_NEWFELLOW_CLOSED = false
        local index = self.index_

        --读取model数据
        local buddhaModel = self.buddhaModelTable_[index]
        local buddhaId      = tonumber(buddhaModel.npcId_)
        local buddhaName    = buddhaModel.name_
        local buddhaIcon    = buddhaModel.icon_
        local buddhaQuality = tonumber(buddhaModel.quality_) + 1
        local buddhaValue   = tonumber(buddhaModel.essenceValue_)
        --根据兵种品质给定名称显示颜色
        local labelColor = nil
        if buddhaQuality == 1 then
            labelColor = display.COLOR_WHITE
        elseif buddhaQuality == 2 then
            labelColor = display.COLOR_GREEN
        elseif buddhaQuality == 3 then
            labelColor = cc.c3b(38,189,254)
        elseif buddhaQuality == 4 then
            labelColor = cc.c3b(132,23,192)
        elseif buddhaQuality == 5 then
            labelColor = cc.c3b(254,145,38)
        end

        --结果显示
            --图像边框
        local iconFrame = display.newSprite(string.format("upgrade/q"..buddhaQuality..".png"),
            self.bg_:getContentSize().width * 0.5,self.bg_:getContentSize().height * 1.3)
            :scale(0)
            :addTo(self.bg_)
        table.insert(self.iconFrameTable_,iconFrame)
            --兵种图像
        local icon = display.newSprite(buddhaIcon,iconFrame:getContentSize().width * 0.5,iconFrame:getContentSize().height * 0.5)
            :addTo(iconFrame)
        if tonumber(buddhaModel.isRebel_) == 1 then
            icon:setScaleX(-1)
        end
        table.insert(self.iconTable_,icon)
            --兵种名称
        local name = cc.ui.UILabel.new({UILabelType = 2,text = buddhaName,size = 24,color = labelColor,font = GameManager.FONTNAME_TTF})
            :align(display.CENTER,iconFrame:getContentSize().width * 0.5,-iconFrame:getContentSize().height * 0.3)
            :addTo(iconFrame)
        table.insert(self.buddhaNameTable_,name)

        --判断是否为新兵种
        local isNewBuddha = false
        local essenceNum = self.essenceNumTable_[index]
        print("index : "..index)
        print("essenceNum : "..essenceNum)
        CloudData.ESSENCE = CloudData.ESSENCE + essenceNum
        if essenceNum ~= 0 then       --重复兵种,转换为精华  
            isNewBuddha = false                        
            --创建转化的动画
            display.addSpriteFrames("summon_scene/zhuanhua.plist","summon_scene/zhuanhua.png")
            local frames = display.newFrames("zhuanhua%d.png",1,15)
            local animation = display.newAnimation(frames, 0.05)
            local animate = cc.Animate:create(animation)
            local emptySp = display.newSprite()
                :pos(iconFrame:getContentSize().width * 0.5,iconFrame:getContentSize().height * 0.5)
                :addTo(iconFrame,2)
            emptySp:runAction(transition.sequence({cc.DelayTime:create(0.85 + index * 0.15),
                animate,cc.CallFunc:create(function()
                self:changeToEssence_(index)
            end)}))
        else
            isNewBuddha = true
        end   

        --兵种出现动作    
        local movetoPoint = nil
        if index < 6 then
            movetoPoint = cc.p(self.bg_:getContentSize().width *  0.1 * (index * 1.5 + 0.5),self.bg_:getContentSize().height * 0.78)
        else
            movetoPoint = cc.p(self.bg_:getContentSize().width *  0.1 * ((index - 5) * 1.5 + 0.5),self.bg_:getContentSize().height * 0.30)
        end
        local spawn_ = cc.Spawn:create(cc.ScaleTo:create(0.1,1.0),
            cc.MoveTo:create(0.1,movetoPoint))
            --最后一个需出现确定按钮
        if index == 10 then
            iconFrame:runAction(transition.sequence({cc.DelayTime:create(0.75 + index * 0.15),spawn_,cc.CallFunc:create(function()
                self.ensureBtn_:show()
            end),cc.CallFunc:create(function()
                self:newFellowAction_(index)
            end)}))
        else
            iconFrame:runAction(transition.sequence({cc.DelayTime:create(0.75 + index * 0.15),spawn_,
                cc.CallFunc:create(function()
                    self:newFellowAction_(index)
                end)}))
        end 

        self.index_ = self.index_ + 1
        self.isInProgress_ = false
        if isNewBuddha then
            GameManager.IS_NEWFELLOW_CLOSED = false
        else
            GameManager.IS_NEWFELLOW_CLOSED = true
        end
    end
end

--兵种转化为精华
function SummonLayer:changeToEssence_(idx)
    --获取兵种边框
    local iconFrame = self.iconFrameTable_[idx]
    iconFrame:setTexture("upgrade/q1.png")

    --获取兵种头像
    local buddhaModel = self.buddhaModelTable_[idx]
    local icon = self.iconTable_[idx]
    icon:setTexture("summon_scene/essence_pic.png")
    if tonumber(buddhaModel.isRebel_) == 1 then
        icon:setScaleX(1)
    end

    --获取兵种名称
    local name = self.buddhaNameTable_[idx]
    name:removeSelf()

    --获取精华数量
    local essenceNum = self.essenceNumTable_[idx]
    local lb1 = cc.ui.UILabel.new({UILabelType = 2,text = "精石",size = 24,color = cc.c3b(5,208,249),font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,iconFrame:getContentSize().width * 0.2,-iconFrame:getContentSize().height * 0.3)
        :addTo(iconFrame)
    local lb2 = cc.ui.UILabel.new({UILabelType = 2,text = string.format("+"..essenceNum),size = 24,color = cc.c3b(7,253,65),font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,lb1:getPositionX() + lb1:getContentSize().width * 0.55,-iconFrame:getContentSize().height * 0.3)
        :addTo(iconFrame)
    lb2:setAnchorPoint(0,0.5)
end

--转到新兵种出现页面
function SummonLayer:newFellowAction_(idx)
    local essenceNum = self.essenceNumTable_[idx]
    if essenceNum == 0 then
        local buddhaModel = self.buddhaModelTable_[idx]
        local layer = NewFellowLayer.new(buddhaModel,FROM_SUMMON)
        self:addChild(layer,20)

        DataUtils.setNewBuddhaCloudData( tonumber(buddhaModel.npcId_) )
    end
end

--返回
function SummonLayer:closeCallBack_()
    --标记弹窗此时关闭
    GameManager.IS_SUMMONLAYER_CLOSED = true

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
    self.emptyNode_:runAction(popupLayer)
end


return SummonLayer