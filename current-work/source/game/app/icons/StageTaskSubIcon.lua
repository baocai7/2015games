--
--阶段性任务子任务相关数据
--

local AlertAchievement  = import("layers.AlertAchievement")
local AlertConnection   = import("customs.AlertConnection")

local StageTaskSubIcon  =  class("StageTaskSubIcon", function()
    return display.newNode()
end)

function StageTaskSubIcon:ctor(stageTaskSubModel)

    --初始化任务数据
    self:initData(stageTaskSubModel)

    --初始化icon内容
    self:initContent()
end

function StageTaskSubIcon:initData( stageTaskSubModel )
    self.subId_                = tonumber(stageTaskSubModel.subId_)
    self.periodicNum_          = tonumber(stageTaskSubModel.periodicNum_)
    self.taskDesc_             = stageTaskSubModel.taskDesc_              
    self.totalData_            = tonumber(stageTaskSubModel.totalData_)           
    self.currData_             = tonumber(stageTaskSubModel.currData_)             
    self.rewardType_           = stageTaskSubModel.rewardType_          
    self.rewardNum_            = tonumber(stageTaskSubModel.rewardNum_)    

    if self.currData_ == -1 then
        self.currData_ = self.totalData_
    elseif self.currData_ > self.totalData_ then
        self.currData_ = self.totalData_
    end

    -- 领奖按钮是否可点击，防止多次点击
    self.canBeClicked_ = true

    -- print("-----------------subId_:"..self.subId_)
    -- print("-----------------taskDesc_:"..self.taskDesc_)
    -- print("-----------------totalData_:"..self.totalData_)
    -- print("-----------------currData_:"..self.currData_)
    -- print("-----------------rewardType_:"..self.rewardType_)
    -- print("-----------------rewardNum_:"..self.rewardNum_)
end

function StageTaskSubIcon:initContent()
    --cell背景
    local cellFrame = display.newSprite("tasks/stage/content0.png")
        :addTo(self)
    cellFrame:setAnchorPoint(cc.p(0,0))
    self:setContentSize(cellFrame:getContentSize())

    --完成任务的奖励 (tasks/award_frame.png)
    local awardFrame = display.newSprite("sign/signk.png",cellFrame:getContentSize().width * 0.15,cellFrame:getContentSize().height * 0.5)
        :scale(0.7)
        :addTo(cellFrame)
        --奖励图标
    local awardPic = display.newSprite("sign/exp.png",awardFrame:getContentSize().width * 0.5,awardFrame:getContentSize().height * 0.5)
        :addTo(awardFrame)

    --任务描述
    local taskDescPic = display.newSprite("tasks/description.png",cellFrame:getContentSize().width * 0.3,cellFrame:getContentSize().height * 0.7)
        :addTo(cellFrame)
    local taskDescLabel = cc.ui.UILabel.new({UILabelType = 2, text = self.taskDesc_,font = GameManager.FONTNAME_TTF,size = 20})
        :align(display.CENTER,taskDescPic:getPositionX() + taskDescPic:getContentSize().width * 0.55,cellFrame:getContentSize().height * 0.7)
        :addTo(cellFrame)
    taskDescLabel:setAnchorPoint(0,0.5)
    
    --任务奖励
    local taskRewardPic = display.newSprite("tasks/reward.png",cellFrame:getContentSize().width * 0.3,cellFrame:getContentSize().height * 0.3)
        :addTo(cellFrame)
    local taskRewardLabel = cc.ui.UILabel.new({UILabelType = 2, text = string.format("经验x%d",self.rewardNum_),font = GameManager.FONTNAME_TTF,size = 20})
        :align(display.CENTER,taskRewardPic:getPositionX() + taskRewardPic:getContentSize().width * 0.55,cellFrame:getContentSize().height * 0.3)
        :addTo(cellFrame)
    taskRewardLabel:setAnchorPoint(0,0.5)

    --领取奖励按钮
    self.getAwardBtn_ = cc.ui.UIPushButton.new({normal = "tasks/get_normal.png",pressed = "tasks/get_selected.png",disabled = "tasks/get_enabled.png"})
        :align(display.CENTER,cellFrame:getContentSize().width * 0.88,cellFrame:getContentSize().height * 0.35)
        :scale(0.6)
        :onButtonClicked(function()
            self:getAwardCallBack_()
        end)
        :addTo(cellFrame,1)
        --进度
    local taskProgressPic = display.newSprite("tasks/progress.png",cellFrame:getContentSize().width * 0.83,cellFrame:getContentSize().height * 0.72)
        :addTo(cellFrame)
    local taskProgressLabel = cc.ui.UILabel.new({UILabelType = 1,text = string.format("%d/%d",self.currData_,self.totalData_),font = "fonts/greenNum.fnt"})
        :scale(0.5)
        :align(display.CENTER,taskProgressPic:getPositionX() + taskProgressPic:getContentSize().width * 0.55,cellFrame:getContentSize().height * 0.72)
        :addTo(cellFrame)
    taskProgressLabel:setAnchorPoint(0,0.5)

    --任务进度
    if DataUtils.getStageTaskSubCompleted(self.subId_) then
        self.getAwardBtn_:setButtonImage("disabled","tasks/completed1.png")
        self.getAwardBtn_:setButtonEnabled(false)
    else
        if self.currData_ < self.totalData_ then
            self.getAwardBtn_:setButtonEnabled(false)
        else
            self.getAwardBtn_:setButtonEnabled(true)
        end     
    end
end

function StageTaskSubIcon:getAwardCallBack_()
    local currScene = display.getRunningScene()
    local ac = AlertConnection.new(CONNECTION_STAGE_TASK_SUB_FINISH,self.periodicNum_,self.subId_)
    currScene:addChild(ac,100,12346)

    self.scheduleS_ = self:schedule(function() 
        if not currScene:getChildByTag(12346) and self.canBeClicked_ then
            self:stopAction(self.scheduleS_)
            self.canBeClicked_ = false
            
            self.getAwardBtn_:setButtonImage("disabled","tasks/completed1.png")
            self.getAwardBtn_:setButtonEnabled(false)
            
            DataUtils.setStageTaskSubCompleted(self.subId_)
            
            local layer = AlertAchievement.new(REWARD_TYPE_EXP,self.rewardNum_)
            currScene:addChild(layer,300)
            
            --数据更新
            CloudData.EXP = CloudData.EXP + self.rewardNum_   

            --DataEye统计任务
            if USE_DATAEYE then
                DCTask.complete(string.format("stagetask%d_subtask%d", self.periodicNum_, self.subId_))    
            end           
        end
    end,0.1)
end

return StageTaskSubIcon