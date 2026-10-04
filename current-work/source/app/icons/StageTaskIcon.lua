--
--阶段性任务相关数据
--

local AlertAchievement  = import("layers.AlertAchievement")
local AlertConnection   = import("customs.AlertConnection")
local WSToast           = import("utils.WSToast")

local StageTaskIcon  =  class("StageTaskIcon", function()
    return display.newNode()
end)

function StageTaskIcon:ctor(stageTaskModel)

    --初始化任务数据
    self:initData(stageTaskModel)

    --初始化icon内容
    self:initContent()

    --self:setContentSize(self.cellFrame_:getContentSize())
end

function StageTaskIcon:initData( stageTaskModel )
    self.stageTaskId_    = tonumber(stageTaskModel.stageTaskId_)
    self.totalData_      = tonumber(stageTaskModel.totalData_)
    self.currentData_    = tonumber(stageTaskModel.currentData_)
    self.rewardQuantity_ = tonumber(stageTaskModel.rewardQuantity_)

    if self.currentData_ == -1 then
        self.currentData_ = self.totalData_ 
    end

    -- print("-----------------stageTaskId_:"..self.stageTaskId_)
    -- print("-----------------totalData_:"..self.totalData_)
    -- print("-----------------currentData_:"..self.currentData_)
    -- print("-----------------rewardQuantity_:"..self.rewardQuantity_)
end

function StageTaskIcon:initContent()
    --cell背景
    local cellFrame = display.newSprite(string.format("tasks/stage/content%d.png",self.stageTaskId_))
        :addTo(self)
    cellFrame:setAnchorPoint(cc.p(0,0))
    self:setContentSize(cellFrame:getContentSize())

    --描述
    cc.ui.UILabel.new({UILabelType = 2,text = "点击查看任务详情",size = 20,color = cc.c3b(38,2,3),font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,cellFrame:getContentSize().width * 0.52,cellFrame:getContentSize().height * 0.43)
        :addTo(cellFrame)

    --奖励数量
        --蟠桃图标
    display.newSprite("shop/peach_pic.png",cellFrame:getContentSize().width * 0.43,cellFrame:getContentSize().height * 0.23)
        :scale(0.3)
        :addTo(cellFrame)
        --蟠桃数量
    cc.ui.UILabel.new({UILabelType = 2,text = string.format("x%d",self.rewardQuantity_),size = 20,color = cc.c3b(38,2,3),font = GameManager.FONTNAME_TTF})
        :align(display.CENTER_LEFT,cellFrame:getContentSize().width * 0.46,cellFrame:getContentSize().height * 0.21)
        :addTo(cellFrame)

    --已完成图标
    self.completedTip_ = display.newSprite("tasks/completed.png",cellFrame:getContentSize().width * 0.88,cellFrame:getContentSize().height * 0.5)
        :hide()
        :addTo(cellFrame)
    --领取奖励按钮
    self.getAwardBtn_ = cc.ui.UIPushButton.new({normal = "tasks/stage/get_award.png",pressed = "tasks/stage/get_award1.png"})
        :hide()
        :align(display.CENTER,cellFrame:getContentSize().width * 0.88,cellFrame:getContentSize().height * 0.46)
        :onButtonClicked(function()
            self:getAwardCallBack_()
        end)
        :addTo(cellFrame,1)
    cc.ui.UILabel.new({UILabelType = 1, text = string.format("%d/%d",self.totalData_,self.totalData_),font = "fonts/greenNum.fnt"})
        :scale(0.5)
        :align(display.CENTER,self.getAwardBtn_:getContentSize().width * 0.5,-30)
        :addTo(self.getAwardBtn_)

    --任务进度
    if DataUtils.getStageTaskCompleted(self.stageTaskId_) then
        self.completedTip_:show()
    else
        if self.currentData_ < self.totalData_ then
            local taskProgressPic = display.newSprite("tasks/progress.png",cellFrame:getContentSize().width * 0.82,cellFrame:getContentSize().height * 0.45)
                :addTo(cellFrame)
            local taskProgressLabel = cc.ui.UILabel.new({UILabelType = 1, text = string.format("%d/%d",self.currentData_,self.totalData_),font = "fonts/greenNum.fnt"})
                :scale(0.5)
                :align(display.CENTER,taskProgressPic:getPositionX() + taskProgressPic:getContentSize().width * 0.55,cellFrame:getContentSize().height * 0.45)
                :addTo(cellFrame)
            taskProgressLabel:setAnchorPoint(0,0.5)
            --进度条显示
            display.newSprite("tasks/progress_bar11.png",cellFrame:getContentSize().width * 0.85,cellFrame:getContentSize().height * 0.25)
                :addTo(cellFrame)
            local progressTimer = display.newProgressTimer("tasks/progress_bar12.png", display.PROGRESS_TIMER_BAR)
                :pos(cellFrame:getContentSize().width * 0.85,cellFrame:getContentSize().height * 0.25)
                :addTo(cellFrame,1)
            progressTimer:setMidpoint(cc.p(0,0))
            progressTimer:setBarChangeRate(cc.p(1,0))
            --计算进度值
            local progressValue = self.currentData_ / self.totalData_ * 100
            progressTimer:setPercentage(progressValue)
        else
            self.completedTip_:hide()
            self.getAwardBtn_:show()
        end    
    end
end

function StageTaskIcon:getAwardCallBack_()
    if self.stageTaskId_ > 1 and (not DataUtils.getStageTaskCompleted(self.stageTaskId_ - 1)) then
        local currLayer = display.getRunningScene()
        local toast = WSToast.new("请先完成上一章节全部任务")
        currLayer:addChild(toast,200)
        return
    end
    --todo
    local currScene = display.getRunningScene()
    local ac = AlertConnection.new(CONNECTION_CHAPTER_TASK_FINISH,self.stageTaskId_)
    currScene:addChild(ac,200,123)
       --网络监测0.1s
    self.scheduleA_ = self:schedule(function()
       	if not currScene:getChildByTag(123) then
            self:stopAction(self.scheduleA_)

            self.getAwardBtn_:hide()
            self.completedTip_:show()

            CloudData.PEACH = CloudData.PEACH + self.rewardQuantity_
            --DataEye统计蟠桃产出
            if USE_DATAEYE then  
                DCCoin.gain("stagetask", "peach", self.rewardQuantity_, CloudData.PEACH)

                --DataEye统计任务
                DCTask.complete("stagetask" .. (self.stageTaskId_))
                if self.stageTaskId_ < 8 then
                    local num = self.stageTaskId_ + 1
                    DCTask.begin("stagetask" .. num, DC_MainLine)
                    for i = 1, self.totalData_ do
                        DCTask.begin(string.format("stagetask%d_subtask%d", num, i), DC_BranchLine)
                    end
                end                                            
            end
            DataUtils.setStageTaskCompleted(self.stageTaskId_)
       end
    end,0.1)
end

return StageTaskIcon