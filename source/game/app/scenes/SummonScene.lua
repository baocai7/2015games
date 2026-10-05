--
--召唤界面（召唤兵种）
--

RETURN_TYPE_EXIT   = 1      -- 返回按钮的回调类型：1.退出当前场景 2.返回上一级（即召唤选择界面）
RETURN_TYPE_UPPER  = 2
SUMMON_TYPE_EXP    = 3      -- 召唤按钮的回调：3.经验召唤  4.蟠桃召唤
SUMMON_TYPE_PEACH  = 4
TIME_TYPE_EXP      = 5      -- 倒计时标识: 5.经验召唤倒计时 6.蟠桃召唤倒计时
TIME_TYPE_PEACH    = 6
TAG_GRAY           = 7      -- 蟠桃召唤的遮罩


local DataLabelIcon       = import("icons.DataLabelIcon")
local SummonLayer         = import("layers.SummonLayer")
local NoviceGuide         = import("utils.NoviceGuide")
local AlertConnection     = import("customs.AlertConnection")
local WSToast             = import("utils.WSToast")
local AlertLackEXPLayer   = import("layers.AlertLackEXPLayer")
local AlertLackPeachLayer = import("layers.AlertLackPeachLayer")
local AlertUpdate         = import("customs.AlertUpdate")

local SummonScene = {}
SummonScene = class("SummonScene", function()
    return display.newScene("SummonScene")
end)

function SummonScene:ctor()


    --背景图片
    self.bg_ = display.newSprite("summon_scene/bg.jpg",display.cx,display.cy):addTo(self)
    self.bg_:setTouchEnabled(true)
    self.bg_:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        return self:onTouch(event.name,event.x,event.y)
    end)

    --背景上的文字
    self.bgLabel_ = display.newSprite("summon_scene/lable1.png",self.bg_:getContentSize().width * 0.55,self.bg_:getContentSize().height * 0.75)
        :addTo(self.bg_)

    --精石(由于此界面精石不要求即时刷新,所以不以DataLabelIcon创建)
    self.essenceFrame_ = display.newSprite("common_ui/essence_bg.png",self.bg_:getContentSize().width * 0.28,self.bg_:getContentSize().height * 0.93)
        :scale(0.75)
        :addTo(self.bg_,15)
    self.essenceNumLabel_ = cc.ui.UILabel.new({UILabelType = 1,text = string.format(CloudData.ESSENCE),font = "fonts/whiteNum.fnt"})
        :scale(0.8)
        :align(display.CENTER,self.essenceFrame_:getContentSize().width * 0.52,self.essenceFrame_:getContentSize().height * 0.5)
        :addTo(self.essenceFrame_)
    -- local essenceLabel = DataLabelIcon.new(DataLabelIcon.LABEL_TYPE_ESSENCE,false)
    -- essenceLabel:setScale(0.85)
    -- essenceLabel:setPosition(cc.p(self.bg_:getContentSize().width * 0.28,self.bg_:getContentSize().height * 0.93))
    -- self.bg_:addChild(essenceLabel,15)
    --经验
    local expLabel = DataLabelIcon.new(DataLabelIcon.LABEL_TYPE_EXP,true)
    expLabel:setScale(0.75)
    expLabel:setPosition(cc.p(self.bg_:getContentSize().width * 0.54,self.bg_:getContentSize().height * 0.93))
    self.bg_:addChild(expLabel,15)
    --蟠桃
    local peachLabel = DataLabelIcon.new(DataLabelIcon.LABEL_TYPE_PEACH,true)
    peachLabel:setScale(0.75)
    peachLabel:setPosition(cc.p(self.bg_:getContentSize().width * 0.80,self.bg_:getContentSize().height * 0.93))
    self.bg_:addChild(peachLabel,15)
    --返回按钮
    self.returnBtn_ = cc.ui.UIPushButton.new({normal = "common_ui/back.png",pressed = "common_ui/back_h.png"})
        :scale(0.85)
        :align(display.CENTER,self.bg_:getContentSize().width * 0.12 ,self.bg_:getContentSize().height * 0.93)
        :onButtonPressed(function()
            self:returnCallBack_()
        end)
        -- :onButtonClicked(function()
        --     self:returnCallBack_()
        -- end)
        :addTo(self.bg_,15)

    --初始化数据
    self:initData_()

    self:schedule(function()
        self:updateSummonLayerIsClosed_()
    end,0.1)

    --第一次进入该场景时引导免费抽取
    if CloudData.STAGE_PROGRESS == 3 and not DataUtils.getGuideIsFirstPlayed("GUIDE_STEP_SUMMON1") then
        local guide = NoviceGuide.new(GUIDE_STEP_SUMMON1)
        self:addChild(guide,50)
        DataUtils.setGuideIsFirstPlayed("GUIDE_STEP_SUMMON1",true)
    end

    self:addAndroidReturnButton_()
end

--初始化数据
function SummonScene:initData_()

    local ac = AlertConnection.new(CONNECTION_SUMMON_INIT)
    self:addChild(ac,100,12345)

    self.scheduleResult_ = self:schedule(function()
        if not self:getChildByTag(12345) then
            self:stopAction(self.scheduleResult_)

            self.nextFreeTimeExp_   = CloudData.NEXT_FREESUMMON_TIME_EXP
            self.nextFreeTimePeach_ = CloudData.NEXT_FREESUMMON_TIME_PEACH
            self.freeNumExp_        = CloudData.FREE_SUMMON_NUM_EXP
            self.expSingleCost_     = CloudData.EXP_SINGLE_COST
            self.expContinueCost_   = CloudData.EXP_CONTINUE_COST
            self.peachSingleCost_   = CloudData.PEACH_SINGLE_COST
            self.peachContinueCost_ = CloudData.PEACH_CONTINUE_COST

            --加载两种召唤类型的图标
            self:addSummonTypeUI_()

            --加载召唤时的UI
            self:initUI_()

            -- 开始倒计时
                -- 经验
            self:startCountDown_(TIME_TYPE_EXP,self.nextFreeTimeExp_)
                -- 蟠桃（先判断本地是否缺失兵种骨骼资源）
            local resDownLoaded = cc.UserDefault:getInstance():getBoolForKey("missed_armature_res_downloaded",false)
            if resDownLoaded then
                self:startCountDown_(TIME_TYPE_PEACH,self.nextFreeTimePeach_)
            end

            -- if CloudData.STAGE_PROGRESS >= 25 then
            --     self:startCountDown_(TIME_TYPE_PEACH,self.nextFreeTimePeach_)
            -- end

            -- print("nextFreeTimeExp_   "..self.nextFreeTimeExp_)
            -- print("nextFreeTimePeach_   "..self.nextFreeTimePeach_)
            -- print("freeNumExp_   "..self.freeNumExp_)
            -- print("expSingleCost_   "..self.expSingleCost_)
            -- print("expContinueCost_   "..self.expContinueCost_)
            -- print("peachSingleCost_   "..self.peachSingleCost_)
            -- print("peachContinueCost_   "..self.peachContinueCost_)
        end
    end,0.1)

    --是否免费
    self.isFreeExp_   = false
    self.isFreePeach_ = false

    --按钮类型
    self.returnType_ = RETURN_TYPE_EXIT
    self.summonType_ = SUMMON_TYPE_EXP

    --检测弹窗是否关闭
    GameManager.IS_SUMMONLAYER_CLOSED = false

    --记录精石数量(用于弹窗关闭时判断此时是否有兵种转化为精石)
    self.essenceNumTable_  = {}

    --上层是否可点击
    self.canBeClicked = true
end

--两种召唤类型的图标
function SummonScene:addSummonTypeUI_()
    --左边经验召唤
    self.expSummonPic_ = display.newSprite("summon_scene/summon_exp.png",
        self.bg_:getContentSize().width * 0.32 ,self.bg_:getContentSize().height * 0.4)
        :addTo(self.bg_,15)
    --倒计时标识
    local hourExp    = math.floor(self.nextFreeTimeExp_ / 3600)
    local minutesExp = math.floor((self.nextFreeTimeExp_ - hourExp * 3600) / 60)
    local secondsExp = math.floor(self.nextFreeTimeExp_ - hourExp * 3600 - minutesExp * 60)
    self.expFreeTimeLabel_ =  cc.ui.UILabel.new({UILabelType = 2,text = string.format("%02d:%02d:%02d后免费",hourExp,minutesExp,secondsExp),
        size = 24,font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,self.expSummonPic_:getContentSize().width * 0.5, self.expSummonPic_:getContentSize().height * 0.39)
        :addTo(self.expSummonPic_,1)
    --免费次数
    self.expFreeNumLabel_ = cc.ui.UILabel.new({UILabelType = 2,text = string.format("今日剩余免费次数:%d",self.freeNumExp_),size = 24,font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,self.expSummonPic_:getContentSize().width * 0.5, self.expSummonPic_:getContentSize().height * 0.34)
        :addTo(self.expSummonPic_,1)
    --召唤一次所消耗经验
    self.expCostFrame_ = display.newSprite("summon_scene/cost_lb1.png",
        self.expSummonPic_:getContentSize().width * 0.5, self.expSummonPic_:getContentSize().height * 0.19)
        :addTo(self.expSummonPic_)
    cc.ui.UILabel.new({UILabelType = 2,text = string.format(self.expSingleCost_),size = 30,font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,self.expCostFrame_:getContentSize().width * 0.57, self.expCostFrame_:getContentSize().height * 0.5)
        :addTo(self.expCostFrame_)
    --免费标签
    self.expFreeTip_ = display.newSprite("summon_scene/free_tip.png",
        self.expSummonPic_:getContentSize().width * 0.5, self.expSummonPic_:getContentSize().height * 0.19)
        :hide()
        :addTo(self.expSummonPic_,2)
    if self.freeNumExp_ == 0 then
        self.expFreeTimeLabel_:hide()
        self.expFreeNumLabel_:setPosition(self.expSummonPic_:getContentSize().width * 0.5, self.expSummonPic_:getContentSize().height * 0.365)
        self.expFreeTip_ :hide()
        self.isFreeExp_ = false
    end

    --右边蟠桃召唤
    self.peachSummonPic_ = display.newSprite("summon_scene/summon_peach.png",
        self.bg_:getContentSize().width * 0.68 ,self.bg_:getContentSize().height * 0.4)
        :addTo(self.bg_,15)
    --倒计时标识
    local hourPeach    = math.floor(self.nextFreeTimePeach_ / 3600)
    local minutesPeach = math.floor((self.nextFreeTimePeach_ - hourPeach * 3600) / 60)
    local secondsPeach = math.floor(self.nextFreeTimePeach_ - hourPeach * 3600 - minutesPeach * 60)
    self.peachFreeTimeLabel_ =  cc.ui.UILabel.new({UILabelType = 2,text = string.format("%02d:%02d:%02d后免费",hourPeach,minutesPeach,secondsPeach),
        size = 24,font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,self.peachSummonPic_:getContentSize().width * 0.56, self.peachSummonPic_:getContentSize().height * 0.37)
        :addTo(self.peachSummonPic_,1)
    --召唤一次所消耗蟠桃
    self.peachCostFrame_ = display.newSprite("summon_scene/cost_lb2.png",
        self.peachSummonPic_:getContentSize().width * 0.5, self.peachSummonPic_:getContentSize().height * 0.19)
        :addTo(self.peachSummonPic_)
    cc.ui.UILabel.new({UILabelType = 2,text = string.format(self.peachSingleCost_),size = 30,font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,self.peachCostFrame_:getContentSize().width * 0.5, self.peachCostFrame_:getContentSize().height * 0.5)
        :addTo(self.peachCostFrame_)
    --免费标签
    self.peachFreeTip_ = display.newSprite("summon_scene/free_tip.png",
        self.peachSummonPic_:getContentSize().width * 0.5, self.peachSummonPic_:getContentSize().height * 0.19)
        :hide()
        :addTo(self.peachSummonPic_,2)

    -- 若缺失骨骼资源，则加上灰色遮罩，提示更新
    local resDownLoaded = cc.UserDefault:getInstance():getBoolForKey("missed_armature_res_downloaded",false)
    if not resDownLoaded then
        self.peachFreeTimeLabel_:hide()

        local gray = display.newSprite("summon_scene/gray.png",
            self.peachSummonPic_:getContentSize().width * 0.5,self.peachSummonPic_:getContentSize().height * 0.5)
            :addTo(self.peachSummonPic_,3,TAG_GRAY)
        local lock = display.newSprite("summon_scene/lock.png",
            gray:getContentSize().width * 0.5,gray:getContentSize().height * 0.65)
            :addTo(gray)
        local label = cc.ui.UILabel.new({UILabelType = 2,text = "请先更新资源包，下载完成\n即可免费召唤一次",size = 25,color = cc.c3b(255,30,30),font = GameManager.FONTNAME_TTF})
            :align(display.CENTER,gray:getContentSize().width * 0.5,gray:getContentSize().height * 0.40)
            :addTo(gray)

        -- 更新按钮
        cc.ui.UIPushButton.new({normal = "update/right_now.png",pressed = "update/right_now1.png"})
            :scale(0.85)
            :align(display.CENTER,gray:getContentSize().width * 0.5 ,gray:getContentSize().height * 0.15)
            :onButtonClicked(function()
                local al = AlertUpdate.new(GameManager.URL_MISSED_ARMATURE,5.8,false,true)
                self:addChild(al,100)    
            end)
            :addTo(gray)
    end

    -- -- 25关之前蟠桃召唤加上灰色遮罩
    -- if CloudData.STAGE_PROGRESS < 25 then
    --     self.peachFreeTimeLabel_:hide()

    --     local gray = display.newSprite("summon_scene/gray.png",
    --         self.peachSummonPic_:getContentSize().width * 0.5,self.peachSummonPic_:getContentSize().height * 0.5)
    --         :addTo(self.peachSummonPic_,3)
    --     local lock = display.newSprite("summon_scene/lock.png",
    --         gray:getContentSize().width * 0.5,gray:getContentSize().height * 0.65)
    --         :addTo(gray)
    --     local label = cc.ui.UILabel.new({UILabelType = 2,text = "25关后解锁",size = 30,color = cc.c3b(255,30,30),font = GameManager.FONTNAME_TTF})
    --         :align(display.CENTER,gray:getContentSize().width * 0.5,gray:getContentSize().height * 0.25)
    --         :addTo(gray)
    -- end

end

--加载召唤时的UI
function SummonScene:initUI_()
    --单次按钮
    self.singleBtn_ = cc.ui.UIPushButton.new({normal = "summon_scene/btn_single.png",pressed = "summon_scene/btn_single1.png"})
        :align(display.CENTER,self.bg_:getContentSize().width * 0.27 ,self.bg_:getContentSize().height * 0.11)
        :onButtonClicked(function()
            self:singleCallBack_()
        end)
        :hide()
        :addTo(self.bg_,1)

    --十连按钮
    self.multipleBtn_ = cc.ui.UIPushButton.new({normal = "summon_scene/btn_multiple.png",pressed = "summon_scene/btn_multiple1.png"})
        :align(display.CENTER,self.bg_:getContentSize().width * 0.73 ,self.bg_:getContentSize().height * 0.11)
        :onButtonClicked(function()
            self:multipleCallBack_()
        end)
        :hide()
        :addTo(self.bg_,1)

    --左右两扇门
    local leftDoor = display.newSprite("summon_scene/huang_pic.png",self.bg_:getContentSize().width * 0.21 ,self.bg_:getContentSize().height * 0.5)
        :addTo(self.bg_,1)
    local rightDoor = display.newSprite("summon_scene/hong_pic.png",self.bg_:getContentSize().width * 0.79 ,self.bg_:getContentSize().height * 0.5)
        :addTo(self.bg_,1)
    if not GameManager.IS_LITE_VERSION then
        --创建动画
        display.addSpriteFrames("summon_scene/huang_tx.plist","summon_scene/huang_tx.png")
        display.addSpriteFrames("summon_scene/hong_tx.plist","summon_scene/hong_tx.png")
        local frames1 = display.newFrames("huang%d.png",1,12)
        local frames2 = display.newFrames("hong%d.png",1,12)
        local animation1 = display.newAnimation(frames1,0.1)
        local animation2 = display.newAnimation(frames2,0.1)
        leftDoor:playAnimationForever(animation1)
        rightDoor:playAnimationForever(animation2)
    end

    --中间圆球
    self.ball_ = display.newSprite("summon_scene/ball.png",self.bg_:getContentSize().width * 0.5 ,self.bg_:getContentSize().height * 0.5)
        :addTo(self.bg_,1)
    local seq = transition.sequence({cc.MoveTo:create(1.0,cc.p(self.bg_:getContentSize().width * 0.5,self.bg_:getContentSize().height * 0.51)),
        cc.MoveTo:create(1.0,cc.p(self.bg_:getContentSize().width * 0.5,self.bg_:getContentSize().height * 0.49))})
    self.ball_:runAction(cc.RepeatForever:create(seq))

    --召唤所消耗的经验或蟠桃数量
    --单抽
    self.singleCostFrame_ = display.newSprite("summon_scene/cost_lb1.png",self.bg_:getContentSize().width * 0.43,
        self.bg_:getContentSize().height * 0.05)
        :hide()
        :addTo(self.bg_,2)
    self.singleCostLabel_ = cc.ui.UILabel.new({UILabelType = 2,text = string.format(self.expSingleCost_),size = 24,font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,self.singleCostFrame_:getContentSize().width * 0.57,self.singleCostFrame_:getContentSize().height * 0.5)
        :addTo(self.singleCostFrame_)
    --十连
    self.multipleCostFrame_ = display.newSprite("summon_scene/cost_lb1.png",self.bg_:getContentSize().width * 0.88,
        self.bg_:getContentSize().height * 0.05)
        :hide()
        :addTo(self.bg_,2)
    self.multipleCostLabel_ = cc.ui.UILabel.new({UILabelType = 2,text = string.format(self.expContinueCost_),size = 24,font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,self.multipleCostFrame_:getContentSize().width * 0.50,self.multipleCostFrame_:getContentSize().height * 0.5)
        :addTo(self.multipleCostFrame_)
    --免费标签
    self.freeTip_ = display.newSprite("summon_scene/free_tip.png",
        self.bg_:getContentSize().width * 0.395,self.bg_:getContentSize().height * 0.05)
        :hide()
        :addTo(self.bg_,2)
end

--经验召唤界面
function SummonScene:toExpSummonLayer_()
    --更改按钮回调事件
    self.returnType_ = RETURN_TYPE_UPPER
    self.summonType_ = SUMMON_TYPE_EXP

    --上层界面隐藏
    self.expSummonPic_:setVisible(false)
    self.peachSummonPic_:setVisible(false)
    self.canBeClicked = false
    --下层界面出现
    self.singleBtn_:setVisible(true)
    self.multipleBtn_:setVisible(true)
    self.singleCostFrame_:setVisible(true)
    self.multipleCostFrame_:setVisible(true)
    self.bgLabel_:setTexture("summon_scene/lable1.png")

    --消耗标签的更改
    if self.isFreeExp_ then
        self.singleCostFrame_:hide()
        self.freeTip_:show()
    else
        self.freeTip_:hide()
        self.singleCostFrame_:setTexture("summon_scene/cost_lb1.png")
        self.singleCostLabel_:setString(string.format(self.expSingleCost_))
        self.singleCostLabel_:setPosition(self.singleCostFrame_:getContentSize().width * 0.57,self.singleCostFrame_:getContentSize().height * 0.5)
    end
    self.multipleCostFrame_:setTexture("summon_scene/cost_lb1.png")
    self.multipleCostLabel_:setString(string.format(self.expContinueCost_))
    self.multipleCostLabel_:setPosition(self.multipleCostFrame_:getContentSize().width * 0.55,self.multipleCostFrame_:getContentSize().height * 0.5)

    --DataEye统计
    if USE_DATAEYE  then
        DCEvent.onEvent("to_exp_summon")
    end
end

--蟠桃召唤界面
function SummonScene:toPeachSummonLayer_()
    --更改按钮回调事件
    self.returnType_ = RETURN_TYPE_UPPER
    self.summonType_ = SUMMON_TYPE_PEACH

    --上层界面隐藏
    self.expSummonPic_:setVisible(false)
    self.peachSummonPic_:setVisible(false)
    self.canBeClicked = false
    --下层界面出现
    self.singleBtn_:setVisible(true)
    self.multipleBtn_:setVisible(true)
    self.singleCostFrame_:setVisible(true)
    self.multipleCostFrame_:setVisible(true)
    self.bgLabel_:setTexture("summon_scene/lable2.png")

    --消耗标签的更改
    if self.isFreePeach_ then
        self.singleCostFrame_:hide()
        self.freeTip_:show()
    else
        self.freeTip_:hide()
        self.singleCostFrame_:setTexture("summon_scene/cost_lb2.png")
        self.singleCostLabel_:setString(string.format(self.peachSingleCost_))
        self.singleCostLabel_:setPosition(self.singleCostFrame_:getContentSize().width * 0.50,self.singleCostFrame_:getContentSize().height * 0.5)
    end
    self.multipleCostFrame_:setTexture("summon_scene/cost_lb2.png")
    self.multipleCostLabel_:setString(string.format(self.peachContinueCost_))
    self.multipleCostLabel_:setPosition(self.multipleCostFrame_:getContentSize().width * 0.50,self.multipleCostFrame_:getContentSize().height * 0.5)

    --DataEye统计
    if USE_DATAEYE then
        DCEvent.onEvent("to_peach_summon")
    end
end

--单抽回调
function SummonScene:singleCallBack_()
    -- 屏蔽按钮点击
    self.singleBtn_:setButtonEnabled(false)
    self.multipleBtn_:setButtonEnabled(false)

    --类型判断(exp or peach)
    if self.summonType_ == SUMMON_TYPE_EXP then
        --消耗经验判断
        local expCost = 0
        if not self.isFreeExp_ then
            expCost = self.expSingleCost_
        else
            expCost = 0
        end

        if CloudData.EXP >= expCost then
            local ac = AlertConnection.new(CONNECTION_SUMMON_EXP_1)
            self:addChild(ac,100,12345)

            --网络监测0.1s
            self.scheduleUpgrade_ = self:schedule(function()
                if not self:getChildByTag(12345) then
                    self:stopAction(self.scheduleUpgrade_)

                    self.essenceNumTable_  = CloudData.SUMMON_RESULT_ESSENCE_TABLE

                    --播放召唤特效,然后兵种出现页面
                    self:summonAnimation_(1,CloudData.SUMMON_RESULT_NPCID_TABLE,CloudData.SUMMON_RESULT_ESSENCE_TABLE)

                    --local layer = SummonLayer.new(1,CloudData.SUMMON_RESULT_NPCID_TABLE,CloudData.SUMMON_RESULT_ESSENCE_TABLE)
                    --self:addChild(layer,20)

                    --经验扣除
                    CloudData.EXP = CloudData.EXP - expCost
                    if DataUtils.markResourceMutation ~= nil then
                        DataUtils.markResourceMutation("summon-exp-single")
                    end
                    if expCost == 0 then
                        self:updateUIAfterExpFree_()
                    end

                    --DataEye统计
                    if USE_DATAEYE then
                        DCEvent.onEvent("exp_summon_success")
                    end
                end
            end,0.1)
        else
            local alert = AlertLackEXPLayer.new()
            self:addChild(alert, 20)
            
            -- 打开点击
            self.singleBtn_:setButtonEnabled(true)
            self.multipleBtn_:setButtonEnabled(true)

            --DataEye统计
            if USE_DATAEYE then
                DCEvent.onEvent("summon_exp_not_enough")
            end
            --todo toast 经验不足
            --[[local toast = WSToast.new("经验不足")
            self:addChild(toast,50)--]]
        end
    else
        --消耗蟠桃判断
        local peachCost = 0
        if not self.isFreePeach_ then
            peachCost = self.peachSingleCost_
        else
            peachCost = 0
        end

        if CloudData.PEACH >= peachCost then
            local ac = AlertConnection.new(CONNECTION_SUMMON_PEACH_1)
            self:addChild(ac,100,12345)

            --网络监测0.1s
            self.scheduleUpgrade_ = self:schedule(function()
                if not self:getChildByTag(12345) then
                    self:stopAction(self.scheduleUpgrade_)

                    self.essenceNumTable_  = CloudData.SUMMON_RESULT_ESSENCE_TABLE

                    --播放召唤特效,然后兵种出现页面
                    self:summonAnimation_(1,CloudData.SUMMON_RESULT_NPCID_TABLE,CloudData.SUMMON_RESULT_ESSENCE_TABLE)

                    --蟠桃扣除
                    CloudData.PEACH = CloudData.PEACH - peachCost
                    if DataUtils.markResourceMutation ~= nil then
                        DataUtils.markResourceMutation("summon-peach-single")
                    end
                    if peachCost == 0 then
                        --倒计时刷新
                        print("NEXT_FREESUMMON_TIME_PEACH = "..CloudData.NEXT_FREESUMMON_TIME_PEACH)
                        self:startCountDown_(TIME_TYPE_PEACH,CloudData.NEXT_FREESUMMON_TIME_PEACH)

                        --上层标签更改
                        self.peachFreeTimeLabel_:show()
                        self.peachFreeTip_:hide()
                        self.peachCostFrame_:show()

                        --下层标签更改
                        self.singleCostFrame_:show()
                        self.singleCostFrame_:setTexture("summon_scene/cost_lb2.png")
                        self.singleCostLabel_:setString(string.format(self.peachSingleCost_))
                        self.singleCostLabel_:setPosition(self.singleCostFrame_:getContentSize().width * 0.50,self.singleCostFrame_:getContentSize().height * 0.5)
                        self.freeTip_:hide()
                    end
                    --DataEye统计
                    if USE_DATAEYE then
                        DCEvent.onEvent("peach_summon_success")
                    end
                end
            end,0.1)
        else
            local alert = AlertLackPeachLayer.new()
            self:addChild(alert, 20)
            
            -- 打开点击
            self.singleBtn_:setButtonEnabled(true)
            self.multipleBtn_:setButtonEnabled(true)

            --DataEye统计
            if USE_DATAEYE then
                DCEvent.onEvent("summon_peach_not_enough")
            end

            --todo toast 经验不足
            --local toast = WSToast.new("蟠桃不足")
            --self:addChild(toast,50)
        end
    end
end

--十连回调
function SummonScene:multipleCallBack_()
    -- 屏蔽按钮点击
    self.singleBtn_:setButtonEnabled(false)
    self.multipleBtn_:setButtonEnabled(false)

    --类型判断(exp or peach)
    if self.summonType_ == SUMMON_TYPE_EXP then
        local expCost = self.expContinueCost_
        if CloudData.EXP >= expCost then
            local ac = AlertConnection.new(CONNECTION_SUMMON_EXP_10)
            self:addChild(ac,100,12345)

            --网络监测0.1s
            self.scheduleUpgrade_ = self:schedule(function()
                if not self:getChildByTag(12345) then
                    self:stopAction(self.scheduleUpgrade_)

                    self.essenceNumTable_  = CloudData.SUMMON_RESULT_ESSENCE_TABLE

                    --播放召唤特效,然后兵种出现页面
                    self:summonAnimation_(2,CloudData.SUMMON_RESULT_NPCID_TABLE,CloudData.SUMMON_RESULT_ESSENCE_TABLE)

                    --经验扣除
                    CloudData.EXP = CloudData.EXP - expCost
                    if DataUtils.markResourceMutation ~= nil then
                        DataUtils.markResourceMutation("summon-exp-ten")
                    end

                    --DataEye统计
                    if USE_DATAEYE then
                        DCEvent.onEvent("exp_summon_success")
                    end
                end
            end,0.1)
        else
            local alert = AlertLackEXPLayer.new()
            self:addChild(alert, 20)
            
            -- 打开点击
            self.singleBtn_:setButtonEnabled(true)
            self.multipleBtn_:setButtonEnabled(true)

            --DataEye统计
            if USE_DATAEYE then
                DCEvent.onEvent("summon_exp_not_enough")
            end
            --todo toast 经验不足
            --local toast = WSToast.new("经验不足")
            --self:addChild(toast,50)
        end
    else
        --消耗蟠桃判断
        local peachCost = self.peachContinueCost_
        if CloudData.PEACH >= peachCost then
            local ac = AlertConnection.new(CONNECTION_SUMMON_PEACH_10)
            self:addChild(ac,100,12345)

            --网络监测0.1s
            self.scheduleUpgrade_ = self:schedule(function()
                if not self:getChildByTag(12345) then
                    self:stopAction(self.scheduleUpgrade_)

                    self.essenceNumTable_  = CloudData.SUMMON_RESULT_ESSENCE_TABLE

                    --播放召唤特效,然后兵种出现页面
                    self:summonAnimation_(2,CloudData.SUMMON_RESULT_NPCID_TABLE,CloudData.SUMMON_RESULT_ESSENCE_TABLE)

                    --蟠桃扣除
                    CloudData.PEACH = CloudData.PEACH - peachCost
                    if DataUtils.markResourceMutation ~= nil then
                        DataUtils.markResourceMutation("summon-peach-ten")
                    end

                    --DataEye统计
                    if USE_DATAEYE then
                        DCEvent.onEvent("peach_summon_success")
                    end
                end
            end,0.1)
        else
            local alert = AlertLackPeachLayer.new()
            self:addChild(alert, 20)
            
            -- 打开点击
            self.singleBtn_:setButtonEnabled(true)
            self.multipleBtn_:setButtonEnabled(true)

            --DataEye统计
            if USE_DATAEYE  then
                DCEvent.onEvent("summon_peach_not_enough")
            end
            --todo toast 经验不足
            --local toast = WSToast.new("蟠桃不足")
            --self:addChild(toast,50)
        end
    end
end

--经验免费抽取后界面更新
function SummonScene:updateUIAfterExpFree_()
    --免费次数刷新
    self.freeNumExp_ = self.freeNumExp_ - 1
    if self.freeNumExp_ > 0 then      --还有免费次数
        --倒计时刷新
        self:startCountDown_(TIME_TYPE_EXP,CloudData.NEXT_FREESUMMON_TIME_EXP)

        --上层标签更改
        self.expFreeTimeLabel_:show()
        self.expFreeTip_:hide()
        self.expCostFrame_:show()
        self.expFreeNumLabel_:setPosition(self.expSummonPic_:getContentSize().width * 0.5, self.expSummonPic_:getContentSize().height * 0.34)

        --下层标签更改
        self.singleCostFrame_:show()
        self.singleCostFrame_:setTexture("summon_scene/cost_lb1.png")
        self.singleCostLabel_:setString(string.format(self.expSingleCost_))
        self.singleCostLabel_:setPosition(self.singleCostFrame_:getContentSize().width * 0.57,self.singleCostFrame_:getContentSize().height * 0.5)
        self.freeTip_:hide()

    elseif self.freeNumExp_ == 0 then        --没有免费次数
        --不再免费
        self.isFreeExp_   = false

        --上层标签更改
        self.expFreeTimeLabel_:hide()
        self.expFreeTip_:hide()
        self.expCostFrame_:show()
        self.expFreeNumLabel_:setPosition(self.expSummonPic_:getContentSize().width * 0.5, self.expSummonPic_:getContentSize().height * 0.365)

        --下层标签更改
        self.singleCostFrame_:show()
        self.singleCostFrame_:setTexture("summon_scene/cost_lb1.png")
        self.singleCostLabel_:setString(string.format(self.expSingleCost_))
        self.singleCostLabel_:setPosition(self.singleCostFrame_:getContentSize().width * 0.57,self.singleCostFrame_:getContentSize().height * 0.5)
        self.freeTip_:hide()
    end
    self.expFreeNumLabel_:setString(string.format("今日剩余免费次数:%d",self.freeNumExp_))
end

--开始倒计时
function SummonScene:startCountDown_(timeType,time)
    --经验召唤倒计时
    if timeType == TIME_TYPE_EXP then
        if time == 0 then
            self:countdownOver_(TIME_TYPE_EXP)
        else
            self.isFreeExp_ = false

            --转换时分秒
            self.hourExp_    = math.floor(time / 3600)
            self.minutesExp_ = math.floor((time - self.hourExp_ * 3600) / 60)
            self.secondsExp_ = math.floor(time - self.hourExp_ * 3600 - self.minutesExp_ * 60)

            --倒计时
            self.scheduleExp_ = self:schedule(function()
                self:updateTime_(TIME_TYPE_EXP)
            end, 1.0)
        end
    end

    --蟠桃召唤倒计时
    if timeType == TIME_TYPE_PEACH then
        if time ==  0 then
            self:countdownOver_(TIME_TYPE_PEACH)
        else
            self.isFreePeach_ = false

            --转换时分秒
            self.hourPeach_    = math.floor(time / 3600)
            self.minutesPeach_ = math.floor((time - self.hourPeach_ * 3600) / 60)
            self.secondsPeach_ = math.floor(time - self.hourPeach_ * 3600 - self.minutesPeach_ * 60)

            --倒计时
            self.schedulePeach_ = self:schedule(function()
                self:updateTime_(TIME_TYPE_PEACH)
            end, 1.0)
        end
    end
end
--时间更新
function SummonScene:updateTime_(timeType)
    --经验召唤倒计时
    if timeType == TIME_TYPE_EXP then
        if self.secondsExp_ > 0 then
            self.secondsExp_ = self.secondsExp_ - 1
        else
            if self.minutesExp_ > 0 then
                self.secondsExp_ = 59
                self.minutesExp_ = self.minutesExp_ - 1
            else
                if self.hourExp_ > 0 then
                    self.secondsExp_ = 59
                    self.minutesExp_ = 59
                    self.hourExp_    = self.hourExp_ - 1
                else
                    self:countdownOver_(TIME_TYPE_EXP)
                end
            end
        end
        --倒计时标签刷新
        self.expFreeTimeLabel_:setString(string.format("%02d:%02d:%02d后免费",self.hourExp_,self.minutesExp_,self.secondsExp_))
    end

    --蟠桃召唤倒计时
    if timeType == TIME_TYPE_PEACH then
        if self.secondsPeach_ > 0 then
            self.secondsPeach_ = self.secondsPeach_ - 1
        else
            if self.minutesPeach_ > 0 then
                self.secondsPeach_ = 59
                self.minutesPeach_ = self.minutesPeach_ - 1
            else
                if self.hourPeach_ > 0 then
                    self.secondsPeach_ = 59
                    self.minutesPeach_ = 59
                    self.hourPeach_    = self.hourPeach_ - 1
                else
                    self:countdownOver_(TIME_TYPE_PEACH)
                end
            end
        end
        --倒计时标签刷新
        self.peachFreeTimeLabel_:setString(string.format("%02d:%02d:%02d后免费",self.hourPeach_,self.minutesPeach_,self.secondsPeach_))
    end
end
--倒计时结束
function SummonScene:countdownOver_(timeType)
    --经验召唤倒计时
    if timeType == TIME_TYPE_EXP then
        if self.freeNumExp_ > 0 then
            --停止计时器
            self:stopAction(self.scheduleExp_)

            --标记此时可免费经验召唤
            self.isFreeExp_ = true

            --上层标签更改
            self.expFreeTimeLabel_:hide()
            self.expCostFrame_:hide()
            self.expFreeTip_:show()
            self.expFreeNumLabel_:setPosition(self.expSummonPic_:getContentSize().width * 0.5, self.expSummonPic_:getContentSize().height * 0.365)

            --下层标签更改
            self.singleCostFrame_:hide()
            self.freeTip_:hide()
        end
    end

    --蟠桃召唤倒计时
    if timeType == TIME_TYPE_PEACH then
        --停止计时器
        self:stopAction(self.schedulePeach_)

        --标记此时可免费蟠桃召唤
        self.isFreePeach_ = true

        --上层标签更改
        self.peachFreeTimeLabel_:hide()
        self.peachCostFrame_:hide()
        self.peachFreeTip_:show()

        --下层标签更改
        self.singleCostFrame_:hide()
        self.freeTip_:hide()
    end
end

--召唤时的动画
function SummonScene:summonAnimation_(summonType,npcIdTable,essenceNumTable)
    --播放音效
    if GameManager.SOUND_SWITCH_ON then
        audio.playSound(string.format("sounds/sfx_niudan.%s",GameManager.POSTFIX))
    end

    if not GameManager.IS_LITE_VERSION then
        --创建两扇门的动画
        display.addSpriteFrames("summon_scene/huanghe_tx.plist","summon_scene/huanghe_tx.png")
        display.addSpriteFrames("summon_scene/honghe_tx.plist","summon_scene/honghe_tx.png")

        local frames1 = display.newFrames("huanghe%d.png",1,13)
        local animation1 = display.newAnimation(frames1, 0.1)
        local emptySp1 = display.newSprite()
            :pos(self.bg_:getContentSize().width * 0.45,self.bg_:getContentSize().height * 0.5)
            :addTo(self.bg_,2)
        emptySp1:playAnimationOnce(animation1,true)

        local frames2 = display.newFrames("honghe%d.png",1,13)
        local animation2 = display.newAnimation(frames2, 0.1)
        local emptySp2 = display.newSprite()
            :pos(self.bg_:getContentSize().width * 0.55,self.bg_:getContentSize().height * 0.5)
            :addTo(self.bg_,2)
        emptySp2:playAnimationOnce(animation2,true)
    end

    --播放球的动画
    self:runAction(transition.sequence({cc.DelayTime:create(1.0),cc.CallFunc:create(function()
        self:summonAnimation1_(summonType,npcIdTable,essenceNumTable)
    end)}))
end
function SummonScene:summonAnimation1_(summonType,npcIdTable,essenceNumTable)

    if not GameManager.IS_LITE_VERSION then
        --创建中间球的动画
        display.addSpriteFrames("summon_scene/ball_tx.plist","summon_scene/ball_tx.png")
        local frames = display.newFrames("ball_pic%d.png",1,20)
        local animation = display.newAnimation(frames, 0.07)
        local emptySp = display.newSprite()
            :pos(self.bg_:getContentSize().width * 0.5,self.bg_:getContentSize().height * 0.5)
            :addTo(self.bg_,2)
        emptySp:playAnimationOnce(animation,true)
    end

    self.ball_:runAction(transition.sequence({cc.DelayTime:create(0.5),cc.FadeOut:create(0.8),cc.CallFunc:create(function()
        --进入到召唤兵种出现的页面
        local layer = SummonLayer.new(summonType,npcIdTable,essenceNumTable)
        self:addChild(layer,20,106)

        --按钮恢复点击
        self.singleBtn_:setButtonEnabled(true)
        self.multipleBtn_:setButtonEnabled(true)
    end)}))
end

--检测summonLayer是否关闭
function SummonScene:updateSummonLayerIsClosed_()
    if GameManager.IS_SUMMONLAYER_CLOSED then
        GameManager.IS_SUMMONLAYER_CLOSED = false
        --中间圆球恢复
        self.ball_:runAction(cc.FadeIn:create(0.8))

        --若有召唤重复兵种,则创建精华飘上去的动作
        local essenceNum = 0
        for i=1,#self.essenceNumTable_ do
            local num = self.essenceNumTable_[i]
            essenceNum = essenceNum + num
        end
        if essenceNum ~= 0 then
            --边框
            local frame = display.newSprite("upgrade/q1.png",
                self.bg_:getContentSize().width * 0.5,self.bg_:getContentSize().height * 0.5)
                :addTo(self.bg_,16)
            --精华图片
            local icon = display.newSprite("summon_scene/essence_pic.png",
                frame:getContentSize().width * 0.5,frame:getContentSize().height * 0.5)
                :addTo(frame)
            --获取精华数量
            local lb1 = cc.ui.UILabel.new({UILabelType = 2,text = "精石",size = 24,color = cc.c3b(5,208,249),font = GameManager.FONTNAME_TTF})
                :align(display.CENTER,frame:getContentSize().width * 0.2,-frame:getContentSize().height * 0.3)
                :addTo(frame)
            local lb2 = cc.ui.UILabel.new({UILabelType = 2,text = string.format("+"..essenceNum),size = 24,color = cc.c3b(7,253,65),font = GameManager.FONTNAME_TTF})
                :align(display.CENTER,lb1:getPositionX() + lb1:getContentSize().width * 0.55,-frame:getContentSize().height * 0.3)
                :addTo(frame)
            lb2:setAnchorPoint(0,0.5)

            --创建动作
            local moveTo_  = cc.MoveTo:create(0.3,cc.p(self.bg_:getContentSize().width * 0.28,self.bg_:getContentSize().height * 0.93))
            local scaleTo_ = cc.ScaleTo:create(0.3,0.75)
            frame:runAction(transition.sequence({cc.DelayTime:create(1.0),
                cc.Spawn:create(moveTo_,scaleTo_),
                cc.CallFunc:create(function()
                    frame:removeSelf()
                end)}))

            --数字"+"
            local label = cc.ui.UILabel.new({UILabelType = 1,text = string.format("+"..essenceNum),font = "fonts/greenNum.fnt"})
                :align(display.CENTER,self.bg_:getContentSize().width * 0.28,self.bg_:getContentSize().height * 0.93)
                :scale(0.75)
                :opacity(0)
                :addTo(self.bg_,16)
            label:runAction(transition.sequence({cc.DelayTime:create(1.1),
                cc.FadeIn:create(0.1),cc.Spawn:create(
                    cc.MoveTo:create(1.0,cc.p(self.bg_:getContentSize().width * 0.28,self.bg_:getContentSize().height * 1.0)),
                    cc.FadeOut:create(1.0)),
                cc.CallFunc:create(function()
                    label:removeSelf()
                    self.essenceNumLabel_:setString(string.format(CloudData.ESSENCE))
                end)}))
        end

        --第一次关闭召唤弹窗时的引导
        if CloudData.STAGE_PROGRESS == 3 and DataUtils.getGuideIsFirstPlayed("GUIDE_STEP_SUMMON1") and
            not DataUtils.getGuideIsFirstPlayed("GUIDE_STEP_SUMMON2") then
            local guide = NoviceGuide.new(GUIDE_STEP_SUMMON2)
            self:addChild(guide,50)
            DataUtils.setGuideIsFirstPlayed("GUIDE_STEP_SUMMON2",true)
        end
    end

    -- 当缺失骨骼下载完成后
    if GameManager.IS_ARMATURE_DOWNLOADED then
        GameManager.IS_ARMATURE_DOWNLOADED = false

        -- 蟠桃倒计时
        self:startCountDown_(TIME_TYPE_PEACH,self.nextFreeTimePeach_)
        -- 时间显示
        self.peachFreeTimeLabel_:hide()
        -- 移除灰色遮罩
        if self.peachSummonPic_:getChildByTag(TAG_GRAY) then
            self.peachSummonPic_:removeChildByTag(TAG_GRAY,true)
        end   
    end
end

--返回回调
function SummonScene:returnCallBack_()
    if self.returnType_ == RETURN_TYPE_UPPER then
        --更改按钮回调事件
        self.returnType_ = RETURN_TYPE_EXIT

        --上层界面出现
        self.expSummonPic_:setVisible(true)
        self.peachSummonPic_:setVisible(true)
        self.canBeClicked = true
        --下层界面隐藏
        self.singleBtn_:setVisible(false)
        self.multipleBtn_:setVisible(false)
        self.singleCostFrame_:setVisible(false)
        self.multipleCostFrame_:setVisible(false)
    else
        if GameManager.SOUND_SWITCH_ON then
            audio.playSound(string.format("sounds/sfx_touch_shu.%s",GameManager.POSTFIX))
        end
        display.replaceScene(require("scenes.ChapterScene").new())
    end
end

function SummonScene:onTouch(event,x,y)
    if event == "began" then
        self.touchBeginPoint_ = {x = x,y = y}
        return true
    end

    if event == "moved" then

    end

    if event == "ended" then
        local touchEndedPoint = {x = x,y = y}
        if self.canBeClicked and math.abs(self.touchBeginPoint_.x - touchEndedPoint.x) < 20 and math.abs(self.touchBeginPoint_.y - touchEndedPoint.y) < 20 then
            local touchInSprite1 = cc.rectContainsPoint(self.expSummonPic_:getCascadeBoundingBox(), cc.p(x, y))
            local touchInSprite2 = cc.rectContainsPoint(self.peachSummonPic_:getCascadeBoundingBox(), cc.p(x, y))
            -- 经验
            if touchInSprite1 then
                self:toExpSummonLayer_()
            end
            -- 蟠桃
            local resDownLoaded = cc.UserDefault:getInstance():getBoolForKey("missed_armature_res_downloaded",false)
            if resDownLoaded and touchInSprite2 then
                self:toPeachSummonLayer_()
            end
            -- if CloudData.STAGE_PROGRESS >= 25 and touchInSprite2 then
            --     self:toPeachSummonLayer_()
            -- end
        end

        if math.abs(self.touchBeginPoint_.x - touchEndedPoint.x) < 20 and math.abs(self.touchBeginPoint_.y - touchEndedPoint.y) < 20 then
            local touchInSprite = cc.rectContainsPoint(self.essenceFrame_:getCascadeBoundingBox(), cc.p(x, y))
            if touchInSprite then
                print("to shopScene")
                if CloudData.STAGE_PROGRESS < 6 then
                    local t = WSToast.new("商店第6关以后开启！")
                    currScene:addChild(t, 100)
                else
                    display.replaceScene(require("scenes.ShopScene1").new(SHOP_TYPE_MYSTERY_BUSINESSMAN))
                end
            end
        end
    end
end

function SummonScene:addAndroidReturnButton_()
    --退出游戏
    local btn = cc.ui.UIPushButton.new():addTo(self)
    btn:setKeypadEnabled(true)
    btn:addNodeEventListener(cc.KEYPAD_EVENT, function (event)
        if event.key == "back" then
            self:showReturnWarning_()
        end
    end)
end

function SummonScene:showReturnWarning_()
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

function SummonScene:onEnter()
    print("onEnter")
end

function SummonScene:onExit()
    self:removeAllChildren()
    display.removeUnusedSpriteFrames()
end

return SummonScene
