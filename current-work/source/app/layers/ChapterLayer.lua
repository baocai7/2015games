local StageIcon       = import("icons.StageIcon")
local AlertConnection = import("customs.AlertConnection")
local NoviceGuide     = import("utils.NoviceGuide")
local WSToast         = import("utils.WSToast")
local BuyEnergyLayer  = import("layers.BuyEnergyLayer")
local WarResultLayer  = import("layers.WarResultLayer")
local AlertUpdate     = import("customs.AlertUpdate")

local ChapterLayer  =  {} 
ChapterLayer = class("ChapterLayer", function()
	return display.newLayer()
end)

function ChapterLayer:ctor(chapterNum,stageNum)
    --chapterNum:章节序号
    --stageNum:当前章节的关卡序号(1-10)     用于宝物界面跳转过来直接选中所需关卡

    if GameManager.SOUND_SWITCH_ON then
        audio.playSound(string.format("sounds/sfx_touch_ti.%s",GameManager.POSTFIX))
    end

    if stageNum ~= nil then
        self.selectedStageId_ = stageNum
    else
        self.selectedStageId_ = 0
    end

	--添加遮罩层
	display.newColorLayer(cc.c4b(0,0,0,150))
        :addTo(self,-1)

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

    GameManager.INFINITE_MODE = false

	--init
	self:init(chapterNum)
end

function ChapterLayer:init(chapterNum)
	--背景
	self.bg_ = display.newSprite("stage/stage_bg.png")
	self.emptyNode_:addChild(self.bg_)

	--读取关卡进度
    self.chapterIconTag_             = chapterNum                                     --章节编号:(1-8)
    self.stageProgress_              = CloudData.STAGE_PROGRESS                       --关卡进度:(0-80)
    self.stageNumThisPage_           = self.stageProgress_ % 10                       --当前章节的第几个关卡:(0-9)
    self.stageNumThisPageUpperLimit_ = (self.chapterIconTag_ - 1) * 10 + 9            --当前章节关卡最大值
    local defaultStageNum_           = 0                                              
    self.stageIcon_arr = {}
    self.treasurePiece_arr = {}

    --章节名称
    display.newSprite(string.format("stage/name"..self.chapterIconTag_..".png"),self.bg_:getContentSize().width * 0.26,self.bg_:getContentSize().height * 0.97)
        :addTo(self.bg_)

    --扫荡券数量
    local sweepPic_ = display.newSprite("stage/sweep_pic.png",
        self.bg_:getContentSize().width * 0.20,self.bg_:getContentSize().height * 0.26)
        :scale(0.72)
        :addTo(self.bg_,1)
    self.sweepNumLabel_ = cc.ui.UILabel.new({
        UILabelType = 2,text = CloudData.SWEEP,size = 30,color = display.COLOR_BLACK,font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,sweepPic_:getContentSize().width * 0.8,sweepPic_:getContentSize().height * 0.5)
        :addTo(sweepPic_)    
    --扫荡按钮(1次)
    self.gameSweepButton_ = cc.ui.UIPushButton.new({normal = "stage/sweep1.png",pressed = "stage/sweep1_h.png",disabled = "stage/sweep1_u.png"})
        :align(display.CENTER,self.bg_:getContentSize().width * 0.20,self.bg_:getContentSize().height * 0.18)
        :onButtonClicked(function()
            self:gameSweepCallBack_()
        end)
        :addTo(self.bg_,1)
    --扫荡按钮(5次)
    self.gameSweep5Button_ = cc.ui.UIPushButton.new({normal = "stage/sweep5.png",pressed = "stage/sweep5_h.png",disabled = "stage/sweep5_u.png"})
        :align(display.CENTER,self.bg_:getContentSize().width * 0.20,self.bg_:getContentSize().height * 0.09)
        :onButtonClicked(function()
            self:gameSweep5CallBack_()
        end)
        :addTo(self.bg_,1)
    
    --奖励经验、宝物掉落、妖怪碎片图标
    local frame1 = display.newSprite("stage/exp_reward.png",self.bg_:getContentSize().width * 0.41,self.bg_:getContentSize().height * 0.27)
        :addTo(self.bg_)
    local frame2 = display.newSprite("stage/treasure_reward.png",self.bg_:getContentSize().width * 0.41,self.bg_:getContentSize().height * 0.18)
        :addTo(self.bg_)
    local frame3 = display.newSprite("stage/monster_reward.png",self.bg_:getContentSize().width * 0.41,self.bg_:getContentSize().height * 0.09)
        :addTo(self.bg_)

    --经验数值    
    self.expRewardLabel_ = cc.ui.UILabel.new({
        UILabelType = 2,text = 0,size = 27,color = display.COLOR_BLACK,font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,frame1:getPositionX() + frame1:getContentSize().width * 0.55,self.bg_:getContentSize().height * 0.27)
        :addTo(self.bg_,1)
    self.expRewardLabel_:setAnchorPoint(0,0.5)
    --经验数值（加成）
    self.expAddtionalLabel_ = cc.ui.UILabel.new({
        UILabelType = 1,text = string.format("+0"),font = "fonts/greenNum.fnt"})
        :addTo(self.bg_,1)
    --self.expAddtionalLabel_:setAnchorPoint(cc.p(0,0.5))
    self.expAddtionalLabel_:setScale(0.6)

    --掉落宝物的名称
    self.treasurePieceNameLabel_ = cc.ui.UILabel.new({
        UILabelType = 2,text = "大唐宝物",size = 27,color = display.COLOR_BLACK,font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,frame2:getPositionX() + frame2:getContentSize().width * 0.52,self.bg_:getContentSize().height * 0.18)
        :addTo(self.bg_,1)
    self.treasurePieceNameLabel_:setAnchorPoint(cc.p(0,0.5))

    --掉落的妖怪碎片图标
        --碎片1
    self.monsterPieceFrame1_ = display.newSprite("monster_piece_icon/quality0.png",self.bg_:getContentSize().width * 0.50,self.bg_:getContentSize().height * 0.09)
        :scale(0.75)
        :addTo(self.bg_,1)
    self.monsterPiecePic1_ = display.newSprite("monster_piece_icon/piece1.png",
        self.monsterPieceFrame1_:getContentSize().width * 0.5,self.monsterPieceFrame1_:getContentSize().height * 0.5)
        :addTo(self.monsterPieceFrame1_)    
        --碎片2
    self.monsterPieceFrame2_ = display.newSprite("monster_piece_icon/quality0.png",self.bg_:getContentSize().width * 0.56,self.bg_:getContentSize().height * 0.09)
        :scale(0.75)
        :addTo(self.bg_,1)
    self.monsterPiecePic2_ = display.newSprite("monster_piece_icon/piece1.png",
        self.monsterPieceFrame2_:getContentSize().width * 0.5,self.monsterPieceFrame2_:getContentSize().height * 0.5)
        :addTo(self.monsterPieceFrame2_)    

    --出战按钮
    self.gameStartButton_ = cc.ui.UIPushButton.new({normal = "stage/start_normal.png",pressed = "stage/start_selected.png"})
        :align(display.CENTER,self.bg_:getContentSize().width * 0.80,self.bg_:getContentSize().height * 0.18)
        :onButtonClicked(function()
            self:gameStartCallBack_()
        end)
        :addTo(self.bg_,1)
    --能量消耗图标
    -- display.newSprite("stage/energy_cost.png",
    --     self.bg_:getContentSize().width * 0.72,self.bg_:getContentSize().height * 0.10)
    --     :addTo(self.bg_,2)
    --能量消耗数值
    self.energyCostLabel_ = cc.ui.UILabel.new({
        UILabelType = 1,text = string.format("10"),font = "fonts/bulefonts.fnt"})
        :align(display.CENTER,self.bg_:getContentSize().width * 0.78,self.bg_:getContentSize().height * 0.125)
        :addTo(self.bg_,2)
    self.energyCostLabel_:setScale(0.75)

    

    --添加小关卡
    self:addStageIcon_()

    -- Select the first stage automatically for a fresh compatibility account.
    -- This bypasses the legacy nested StageIcon hit test, which can swallow
    -- the touch before the detail panel is updated on newer Cocos builds.
    if PaymentInfo.CHANNEL == 0 and self.stageProgress_ == 0 then
        self:performWithDelay(function()
            self:touchStageIcon_(1)
        end,0.05)
    end

    --关闭按钮
    self.closeButton_ = cc.ui.UIPushButton.new({normal = "common_ui/close.png",pressed = "common_ui/close_h.png"})
        :onButtonPressed(function()
            self:closeCallBack_()
        end)
        -- :onButtonClicked(function()
    	   -- self:closeCallBack_()
        --  end)
        :align(display.CENTER,self.bg_:getContentSize().width * 0.93,self.bg_:getContentSize().height * 0.90)
        :addTo(self.bg_,2)
    self.closeButton_:setScale(0.8)

    -- Do not put the legacy first-stage guide above the start button here.
    -- On the compatibility client that overlay can consume the tap while the
    -- stage detail layer is still being initialized.
end

--添加小关卡按钮
function ChapterLayer:addStageIcon_()
    for i=1,2 do          --行
        for j=1,5 do      --列
            --当前关卡
            self.currentStage_ = (self.chapterIconTag_ - 1) * 10 + j + (i - 1) * 5
            local stageIcon_ = StageIcon.new(1)
            stageIcon_:setPosition(self.bg_:getContentSize().width * (0.17 + 0.165 * (j - 1)),self.bg_:getContentSize().height * (1.03 - 0.26 * i))
            self.bg_:addChild(stageIcon_)
            local stageIndex_ = #self.stageIcon_arr + 1
            stageIcon_:addTouchListener(function(event)
                -- Select from the actual visible sprite; do not rely on the
                -- old parent-coordinate bounding-box calculation.
                if event.name == "began" then
                    local currentStage_ = (self.chapterIconTag_ - 1) * 10 + stageIndex_
                    if currentStage_ <= self.stageProgress_ + 1 then
                        print(string.format("[compat] select stage %d",currentStage_))
                        self:touchStageIcon_(stageIndex_)
                    end
                end
                return true
            end)
            table.insert(self.stageIcon_arr,stageIcon_) 

            -- Use a transparent UI hit target for the first stage in local
            -- compatibility mode.  The original nested sprite listener is
            -- retained for normal channels and visual state updates.
            if PaymentInfo.CHANNEL == 0 and self.chapterIconTag_ == 1 and stageIndex_ == 1 then
                local compatStageButton = cc.ui.UIPushButton.new("common_ui/confirm.png")
                    :align(display.CENTER,stageIcon_:getPositionX(),stageIcon_:getPositionY())
                    :onButtonClicked(function()
                        print("[compat] select stage 1 via button")
                        self:touchStageIcon_(1)
                    end)
                    :scale(1.35)
                    :addTo(self.bg_,5)
                compatStageButton:setOpacity(0)
            end

            --获取关卡model
            local stageModel = DataUtils.getStageModel(self.currentStage_)

            --关卡编号显示
            if self.currentStage_ % 10 == 5 then        --精英关卡
                display.newSprite("stage/elite.png",0,stageIcon_:getContentSize().height * 0.29)
                    :addTo(stageIcon_)
            elseif self.currentStage_ % 10 == 0 then    --Boss关卡
                display.newSprite("stage/boss.png",0,stageIcon_:getContentSize().height * 0.29)
                    :addTo(stageIcon_)
            elseif tonumber(stageModel.isGrooveMode_) == 1 then    --卡槽关卡
                display.newSprite("stage/groove.png",0,stageIcon_:getContentSize().height * 0.29)
                    :addTo(stageIcon_)
            elseif tonumber(stageModel.isGrooveMode_) == 2 then    --剪刀石头布关卡
                display.newSprite("stage/cycles.png",0,stageIcon_:getContentSize().height * 0.29)
                    :addTo(stageIcon_)
            else                                        --其它关卡
                cc.ui.UILabel.new({
                    UILabelType = 2,text = string.format("第"..self.currentStage_.."关"),size = 25,color = cc.c3b(63,31,4),font = GameManager.FONTNAME_TTF})
                    :align(display.CENTER,0,stageIcon_:getContentSize().height * 0.29)
                    :addTo(stageIcon_)
            end

            --状态判断
            if self.currentStage_ > self.stageProgress_ + 1 then
                stageIcon_:setLocked()
            else
                stageIcon_:setNormal()

                --读取宝物碎片
                local treasurePieceId_      = stageModel.treasurePieceId_
                local treasurePieceModel    = DataUtils.getTreasurePieceModel(treasurePieceId_)
                local treasurePieceQuality_ = treasurePieceModel.treasurePieceQuality_

                --宝物碎片品质
                local pieceFrame_ = display.newSprite("stage/quality0.png",0,-20):addTo(stageIcon_)
                local pieceIcon_ = display.newSprite("stage/quality0.png",
                        pieceFrame_:getContentSize().width * 0.5,pieceFrame_:getContentSize().height * 0.5)
                        :addTo(pieceFrame_)
                if treasurePieceQuality_ ~= 0 then
                    pieceIcon_:setTexture("treasure/q"..treasurePieceQuality_..".png")
                end

                table.insert(self.treasurePiece_arr,pieceIcon_)
            end

            --初始化默认选中的关卡
            if self.selectedStageId_ == 0 then     --self.selectedStageId_:宝物界面传过来的当前章节关卡编号
                if self.stageProgress_ > self.stageNumThisPageUpperLimit_ then
                    defaultStageNum_ = self.stageNumThisPageUpperLimit_
                else
                    defaultStageNum_ = self.stageProgress_
                end
                self:touchStageIcon_(defaultStageNum_%10 + 1)
            else
                self:touchStageIcon_(self.selectedStageId_)
            end
            
        end
    end
end

function ChapterLayer:touchStageIcon_(stageNum)
    --获取小关卡状态
    for i=1,#self.stageIcon_arr do
        local icon_ = self.stageIcon_arr[i]
        local num_ = (self.chapterIconTag_ - 1) * 10 + i
        if i == stageNum then
            icon_:setSelected()
        else
            if num_ <= (self.stageProgress_ + 1) then
                icon_:setNormal()
            else
                icon_:setLocked()
            end
        end
    end

    --记录当前页面的第几个关卡
    self.stageNumThisPage_ = stageNum

    --当前所选择关卡的编号
    local currSelectedStageNum_ = (self.chapterIconTag_ - 1) * 10 + stageNum
    --记录当前所选择的关卡编号
    GameManager.STAGE_NUM = currSelectedStageNum_

    --获取关卡model
    local stageModel = DataUtils.getStageModel(currSelectedStageNum_)
    --经验奖励
    local expRewardNum_ = stageModel.expAward_
    --精力消耗
    self.energyCostNum_ = stageModel.energyCost_

    --经验加成(防御塔,宝物)
    local addtionalExp  = math.floor(stageModel.addtionalExp_)

    --当前所选择关卡宝物信息
    local treasurePieceId_   = tonumber(stageModel.treasurePieceId_) 
    local treasurePieceModel = DataUtils.getTreasurePieceModel(treasurePieceId_)
    local treasurePieceName_ = treasurePieceModel.treasurePieceName_

    --高级妖怪碎片相关信息
    local advancedPieceId      = tonumber(stageModel.advancedPieceId_)
    local advancedPiecemodel   = DataUtils.getMonsterPieceModel(advancedPieceId)
    local advancedPieceQuality = tonumber(advancedPiecemodel.quality_)
    local advancedPieceIcon    = advancedPiecemodel.pieceIconPath_

    --普通妖怪碎片相关信息
    local generalPieceId      = tonumber(stageModel.monsterPieceId_)
    local generalPiecemodel   = DataUtils.getMonsterPieceModel(generalPieceId)
    local generalPieceQuality = tonumber(generalPiecemodel.quality_)
    local generalPieceIcon    = generalPiecemodel.pieceIconPath_
    
    --本关卡奖励经验数值
    self.expRewardLabel_:setString(string.format(expRewardNum_))
    --经验加成数值
    self.expAddtionalLabel_:setString(string.format("+"..addtionalExp))
    self.expAddtionalLabel_:setPosition(cc.p(self.expRewardLabel_:getPositionX() + self.expRewardLabel_:getContentSize().width,
        self.bg_:getContentSize().height * 0.27))
    --精力消耗数值
    self.energyCostLabel_:setString(string.format(self.energyCostNum_))
    --宝物碎片名称
    self.treasurePieceNameLabel_:setString(string.format(treasurePieceName_))
    --妖怪碎片
    self.monsterPieceFrame1_:setTexture(string.format("monster_piece_icon/quality"..advancedPieceQuality..".png"))
    self.monsterPiecePic1_:setTexture(advancedPieceIcon)
    self.monsterPieceFrame2_:setTexture(string.format("monster_piece_icon/quality"..generalPieceQuality..".png"))
    self.monsterPiecePic2_:setTexture(generalPieceIcon)

    --扫荡条件判断
    local sweepNum_ = CloudData.SWEEP
    if sweepNum_ > 0 and currSelectedStageNum_ <= self.stageProgress_ then
        self.gameSweepButton_:setButtonEnabled(true)
        --视觉聚集在按钮
        -- self.gameSweepButton_:runAction(transition.sequence({cc.DelayTime:create(0.1),
        --     cc.ScaleTo:create(0.2,1.1),cc.ScaleTo:create(0.2,0.9)}))
        if sweepNum_ >= 5 then
            self.gameSweep5Button_:setButtonEnabled(true)
        else
            self.gameSweep5Button_:setButtonEnabled(false)
        end
    else
        self.gameSweepButton_:setButtonEnabled(false)
        self.gameSweep5Button_:setButtonEnabled(false)
        --视觉聚集在按钮
        self.gameStartButton_:runAction(transition.sequence({cc.DelayTime:create(0.1),
            cc.ScaleTo:create(0.2,1.1),cc.ScaleTo:create(0.2,1.0)}))
    end
end


--出战回调
function ChapterLayer:gameStartCallBack_()
    -- A freshly created account has progress 0, while the original client
    -- uses stage 0 as a sentinel for "no stage selected".  The old code then
    -- deducted energy and TinyLoadingScene intentionally did nothing.  Make
    -- the first playable stage explicit before any network request.
    local selectedStage = tonumber(GameManager.STAGE_NUM) or 0
    if selectedStage <= 0 then
        local progress = tonumber(self.stageProgress_) or 0
        selectedStage = math.max(1, (self.chapterIconTag_ - 1) * 10 + progress + 1)
        GameManager.STAGE_NUM = selectedStage
        self:touchStageIcon_(selectedStage - (self.chapterIconTag_ - 1) * 10)
    end
    self.energyCostNum_ = tonumber(self.energyCostNum_) or 5
    print(string.format("[compat] start stage %d energy %d", selectedStage, self.energyCostNum_))
    --若本地没有骨骼动画,则提示去下载
    local resDownLoaded = cc.UserDefault:getInstance():getBoolForKey("missed_armature_res_downloaded",false)
    if not resDownLoaded and GameManager.STAGE_NUM >= 25 then
        local al = AlertUpdate.new(GameManager.URL_MISSED_ARMATURE,5.8,"FORCE",true)
        self:addChild(al,100)
        return  
    end
    
    -- 若没有上阵兵种，则跳转到队伍界面去上阵
    if "" == cc.UserDefault:getInstance():getStringForKey("buddha_on_team") then
        cc.UserDefault:getInstance():setStringForKey("buddha_on_team","1,")
        --display.replaceScene(require("scenes.TeamScene").new())
    end


    if CloudData.ENERGY >= tonumber(self.energyCostNum_) then
        local ac = AlertConnection.new(CONNECTION_COST_ENERGY, GameManager.STAGE_NUM)
        self:addChild(ac,100,12345)

        self.scheduleResult_ = self:schedule(function() 
            if not self:getChildByTag(12345) then
                self:stopAction(self.scheduleResult_)
				audio.stopMusic()
				if GameManager.SOUND_SWITCH_ON then
					audio.playSound(string.format("sounds/sfx_go.%s",GameManager.POSTFIX))
				end        
                if CloudData.HAS_ENERGY then
                    CloudData.ENERGY = CloudData.ENERGY - self.energyCostNum_
                    display.replaceScene(require("scenes.TinyLoadingScene").new("GAME_SCENE","NORMAL"))         
                else
                    local bnl = BuyEnergyLayer.new()
                    self:addChild(bnl,50)
                end                    
            end
        end,0.1)
    else
        --local t = WSToast.new("体力不足",1.0)
        --self:addChild(t)
        local bnl = BuyEnergyLayer.new()
        self:addChild(bnl,50)
    end
    

end

--扫荡(1次)
function ChapterLayer:gameSweepCallBack_()
    print("扫荡")
    if CloudData.ENERGY >= tonumber(self.energyCostNum_) then
        if CloudData.SWEEP > 0 then
            -- 按钮禁用，防止逗比玩家多次点击
            self.gameSweepButton_:setButtonEnabled(false)
            self:performWithDelay(function()
                self.gameSweepButton_:setButtonEnabled(true)
            end, 0.5)

            -- 获取数据
            local ac = AlertConnection.new(CONNECTION_SWEEP, GameManager.STAGE_NUM)
            self:addChild(ac,100,12345)

            self.scheduleResult_ = self:schedule(function() 
                if not self:getChildByTag(12345) then
                    self:stopAction(self.scheduleResult_)
                    
                    -- CloudData.SWEEP = CloudData.SWEEP - 1
                    CloudData.ENERGY = CloudData.ENERGY - self.energyCostNum_
                    self.sweepNumLabel_:setString(CloudData.SWEEP)
                    
                    local wrl = WarResultLayer.new(RESULT_TYPE_SWEEP)
                    self:addChild(wrl,10)

                    --检测是否掉落宝物碎片
                    self.schedulTreasurePiece_ = self:schedule(function()
                        self:updateTreasurePiece_()
                    end,0.2)
                end
            end,0.1)
        else
            self.gameSweepButton_:setButtonEnabled(false)
        end
        
    else
        --local t = WSToast.new("体力不足",1.0)
        --self:addChild(t)
        local bnl = BuyEnergyLayer.new()
        self:addChild(bnl,50)
    end
end
--扫荡(5次)
function ChapterLayer:gameSweep5CallBack_()
    if CloudData.ENERGY >= tonumber(self.energyCostNum_ * 5) then
        if CloudData.SWEEP >= 5 then
            -- 按钮禁用，防止逗比玩家多次点击
            self.gameSweep5Button_:setButtonEnabled(false)
            self:performWithDelay(function()
                self.gameSweep5Button_:setButtonEnabled(true)
            end, 0.5)

            -- 获取数据
            local ac = AlertConnection.new(CONNECTION_SWEEP_5, GameManager.STAGE_NUM)
            self:addChild(ac,100,12345)

            self.scheduleResult_ = self:schedule(function() 
                if not self:getChildByTag(12345) then
                    self:stopAction(self.scheduleResult_)
                    
                    -- CloudData.SWEEP = CloudData.SWEEP - 5
                    CloudData.ENERGY = CloudData.ENERGY - self.energyCostNum_ * 5
                    self.sweepNumLabel_:setString(CloudData.SWEEP)
                    
                    local wrl = WarResultLayer.new(RESULT_TYPE_SWEEP)
                    self:addChild(wrl,10)

                    --检测是否掉落宝物碎片
                    self.schedulTreasurePiece_ = self:schedule(function()
                        self:updateTreasurePiece_()
                    end,0.2)
                end
            end,0.1)
        else
            self.gameSweep5Button_:setButtonEnabled(false)
        end
        
    else
        --local t = WSToast.new("体力不足",1.0)
        --self:addChild(t)
        local bnl = BuyEnergyLayer.new()
        self:addChild(bnl,50)
    end
end

--检测是否掉落宝物碎片
function ChapterLayer:updateTreasurePiece_()
    --获取关卡model
    local stageModel = DataUtils.getStageModel(GameManager.STAGE_NUM)

    --当前所选择关卡宝物信息
    local treasurePieceId_      = tonumber(stageModel.treasurePieceId_) 
    local treasurePieceModel    = DataUtils.getTreasurePieceModel(treasurePieceId_)
    local treasurePieceQuality_ = treasurePieceModel.treasurePieceQuality_

    if treasurePieceQuality_ ~= 0 then
        local pieceIcon = self.treasurePiece_arr[self.stageNumThisPage_]
        self:performWithDelay(function()
            pieceIcon:setTexture("treasure/q"..treasurePieceQuality_..".png")
        end,3.0) 
    end
end

function ChapterLayer:onTouch(event,x,y)
    if event == "began" then
        --点击小关卡的判断
        local beganPoint_ = cc.p(x,y)
        for i=1, #self.stageIcon_arr do
            local stageIcon_ = self.stageIcon_arr[i]
            local currStageNum_ = (self.chapterIconTag_ - 1) * 10 + i;
            if cc.rectContainsPoint(stageIcon_:getMyBoundingBox(),beganPoint_) and (currStageNum_ <= self.stageProgress_ + 1) then
                print(string.format("[compat] select stage %d",currStageNum_))
                self:touchStageIcon_(i)
            end
        end
        return true
    end

    if event == "moved" then
       
    end

    if event == "ended" then
        
    end
end

--弹窗关闭
function ChapterLayer:closeCallBack_()
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


return ChapterLayer
