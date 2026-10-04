--
--成就查看与领取
--

local NoviceGuide       = import("utils.NoviceGuide")
local AlertConnection   = import("customs.AlertConnection")
local AchievementIcon   = import("icons.AchievementIcon")
local DailyTaskIcon     = import("icons.DailyTaskIcon")
local StageTaskIcon     = import("icons.StageTaskIcon")
local WSToast           = import("utils.WSToast")
local StageTaskSubLayer = import("layers.StageTaskSubLayer")

local AchievementLayer  =  class("AchievementLayer", function()
	return display.newLayer()
end)   

TAG_DAILY_NEW         = 1
TAG_STAGE_NEW         = 2
TAG_ACHIEVEMENT_NEW   = 3      

function AchievementLayer:ctor()
	--添加遮罩层
	m_pMaskLayer = display.newColorLayer(cc.c4b(0,0,0,150))
	self:addChild(m_pMaskLayer,-1)

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

    --初始化false
    GameManager.IS_ALERT_ACHIEVEMENT_CLOSED   = false
    
    --tag值标记当前是哪个页面
    self.tag_ = 0
 
    --init
    self:initUI_()
    
     --第一次打开成就页面引导领取成就
    if CloudData.STAGE_PROGRESS == 5 and not DataUtils.getGuideIsFirstPlayed("GUIDE_STEP_ACHIEVEMENT") then     --引导进入队伍界面
        local guide = NoviceGuide.new(GUIDE_STEP_ACHIEVEMENT)
        self:addChild(guide,50)
        DataUtils.setGuideIsFirstPlayed("GUIDE_STEP_ACHIEVEMENT",true)
    end

    --检测是否领奖,刷新列表
    self.schedule_ = self:schedule(function() 
        self:updateListView_()
    end,0.03)                
end

--对成就状态进行分类(不可领取,可领取,已完成)
function AchievementLayer:initAchievementModel_()
    self.achievementModelTable1_ = {}        --可领取
    self.achievementModelTable2_ = {}        --不可领取
    self.achievementModelTable3_ = {}        --已完成
    for i=1,10 do
        local achievementModel = DataUtils.getAchievementModel(i)
        local achievementId    = tonumber(achievementModel.achievementId_)
        local rewardNum        = tonumber(achievementModel.rewardNum_)
        local achievementLevel = DataUtils.getAchievementLevel(achievementId)
        local achievementData  = tonumber(achievementModel.achievementData_)
        local currData         = achievementModel.currentData_
        if achievementLevel <= rewardNum then
            if currData >= achievementData then
                table.insert(self.achievementModelTable1_,achievementModel)
            else
                table.insert(self.achievementModelTable2_,achievementModel)
            end
        else
            table.insert(self.achievementModelTable3_,achievementModel)
        end
    end
end
--对日常任务完成状态就行分类(不可领取,可领取,已完成)
function AchievementLayer:initDailyTaskModel_()
    self.dailyModelTable1_ = {}        --可领取
    self.dailyModelTable2_ = {}        --不可领取
    self.dailyModelTable3_ = {}        --已完成
    for i=1,13 do
        local dailyTaskModel = DataUtils.getDailyTaskModel(i)
        local dailyTaskId    = tonumber(dailyTaskModel.dailyTaskId_)
        local totalData      = tonumber(dailyTaskModel.totalData_)
        local currentData    = dailyTaskModel.currentData_
        if not DataUtils.getDailyTaskCompleted(dailyTaskId) then
            if currentData >= totalData then 
                if dailyTaskId >= 11 then
                    table.insert(self.dailyModelTable1_,1,dailyTaskModel)
                else
                    table.insert(self.dailyModelTable1_,dailyTaskModel)
                end
            else
                table.insert(self.dailyModelTable2_,dailyTaskModel)
            end
        else
            table.insert(self.dailyModelTable3_,dailyTaskModel)
        end
    end
end
--对阶段任务完成状态就行分类(不可领取,可领取,已完成)
function AchievementLayer:initStageTaskModel_()
    self.stageModelTable1_ = {}        --可领取
    self.stageModelTable2_ = {}        --不可领取
    self.stageModelTable3_ = {}        --已完成
    for i=1,8 do
        local stageTaskModel = DataUtils.getStageTaskModel(i)
        table.insert(self.stageModelTable1_,stageTaskModel)
    end
end

--初始化界面UI
function AchievementLayer:initUI_()
	--背景
	self.bg_ = display.newSprite("tasks/table_bg.png")
	self.emptyNode_:addChild(self.bg_,20)

    --分页按钮
        --日常任务
    self.dailyBtn_ = cc.ui.UIPushButton.new({normal = "tasks/daily_btn.png",pressed = "tasks/daily_btn.png",disabled = "tasks/daily_btn1.png"})
        :onButtonClicked(function()
            self:toDailyTask_()
        end)
        :align(display.CENTER,self.bg_:getContentSize().width * 0.015,self.bg_:getContentSize().height * 0.73)
        :addTo(self.bg_,1)
        --阶段性任务
    self.stageBtn_ = cc.ui.UIPushButton.new({normal = "tasks/stage_btn.png",pressed = "tasks/stage_btn.png",disabled = "tasks/stage_btn1.png"})
        :onButtonClicked(function()
            self:toStageTask_()
        end)
        :align(display.CENTER,self.bg_:getContentSize().width * 0.015,self.bg_:getContentSize().height * 0.54)
        :addTo(self.bg_,1)
        --成就
    self.achievementBtn_ = cc.ui.UIPushButton.new({normal = "tasks/achievement_btn.png",pressed = "tasks/achievement_btn.png",disabled = "tasks/achievement_btn1.png"})
        :onButtonClicked(function()
            self:toAchievement_()
        end)
        :align(display.CENTER,self.bg_:getContentSize().width * 0.015,self.bg_:getContentSize().height * 0.35)     --0.35
        :addTo(self.bg_,1)

    --判断是否有小红点提示
        --日常
    if GameManager.IS_DAILY_TASK_NEW then
        local redPoint = display.newSprite("common_ui/red_point.png",-40,50)
            :addTo(self.dailyBtn_,1,TAG_DAILY_NEW)
    end
        --阶段
    if GameManager.IS_STAGE_TASK_NEW then
        local redPoint = display.newSprite("common_ui/red_point.png",-40,50)
            :addTo(self.stageBtn_,1,TAG_STAGE_NEW)
    end
        --成就
    if GameManager.IS_ACHIEVEMENT_NEW then
        local redPoint = display.newSprite("common_ui/red_point.png",-40,50)
            :addTo(self.achievementBtn_,1,TAG_ACHIEVEMENT_NEW)
    end

    --关闭按钮
    cc.ui.UIPushButton.new({normal = "common_ui/close.png",pressed = "common_ui/close_h.png"})
        :scale(0.85)
        :onButtonPressed(function()
            self:closeCallBack_()
        end)
        -- :onButtonClicked(function()
        -- 	self:closeCallBack_()
        -- end)
        :align(display.CENTER,self.bg_:getContentSize().width * 0.90,self.bg_:getContentSize().height * 0.88)
        :addTo(self.bg_,20)

    --默认进入此界面显示日常任务页面(十关以前不开启日常任务)
    if CloudData.STAGE_PROGRESS == 5 then
        self:toAchievement_()
    else
        self:toDailyTask_()
    end  
end

--检测刷新列表
function AchievementLayer:updateListView_()
    if GameManager.IS_ALERT_ACHIEVEMENT_CLOSED then
        --重置为false
        GameManager.IS_ALERT_ACHIEVEMENT_CLOSED = false
        
        --重新加载数据,刷新列表
        if self.listView ~= nil then
            self.listView:removeSelf()    
            self.listView = nil
        end
        
        if self.tag_ == 1 then
        	self:initDailyTaskModel_()
            self:createListView_("daily",self.dailyModelTable1_,self.dailyModelTable2_,self.dailyModelTable3_)
        elseif self.tag_ == 2 then
            self:initStageTaskModel_()
            self:createListView_("stage",self.stageModelTable1_,self.stageModelTable2_,self.stageModelTable3_)
    	elseif self.tag_ == 3 then
            self:initAchievementModel_()
            self:createListView_("achievement",self.achievementModelTable1_,self.achievementModelTable2_,self.achievementModelTable3_)
        end     
    end
end

--日常任务页面
function AchievementLayer:toDailyTask_()
    --去掉小红点
    if self.dailyBtn_:getChildByTag(TAG_DAILY_NEW) ~= nil then
        self.dailyBtn_:removeChildByTag(TAG_DAILY_NEW,true)
        GameManager.IS_DAILY_TASK_NEW = false
    end

    --重新加载数据 
    self:initDailyTaskModel_()
    
    --按钮状态调整
    self.achievementBtn_:setButtonEnabled(true)
    self.dailyBtn_:setButtonEnabled(false)
    self.stageBtn_:setButtonEnabled(true)

    self.tag_ = 1

    --重置列表
    if self.listView ~= nil then
        --self.listView:removeSelf() 
        self.listView:removeAllItems()
        self.listView = nil   
    end
    self:createListView_("daily",self.dailyModelTable1_,self.dailyModelTable2_,self.dailyModelTable3_)
end
--阶段任务页面
function AchievementLayer:toStageTask_()
    --去掉小红点
    if self.stageBtn_:getChildByTag(TAG_STAGE_NEW) ~= nil then
        self.stageBtn_:removeChildByTag(TAG_STAGE_NEW,true)
        GameManager.IS_STAGE_TASK_NEW = false
    end

    --重新加载数据 
    self:initStageTaskModel_()

    --按钮状态调整
    self.achievementBtn_:setButtonEnabled(true)
    self.dailyBtn_:setButtonEnabled(true)
    self.stageBtn_:setButtonEnabled(false)
    
    self.tag_ = 2

    --重置列表
    if self.listView ~= nil then
        --self.listView:removeSelf()    
        self.listView:removeAllItems()
        self.listView = nil
    end
    self:createListView_("stage",self.stageModelTable1_,self.stageModelTable2_,self.stageModelTable3_)
        
end
--成就页面
function AchievementLayer:toAchievement_()
    --去掉小红点
    if self.achievementBtn_:getChildByTag(TAG_ACHIEVEMENT_NEW) ~= nil then
        self.achievementBtn_:removeChildByTag(TAG_ACHIEVEMENT_NEW,true)
        GameManager.IS_ACHIEVEMENT_NEW = false
    end

    --重新加载数据 
    self:initAchievementModel_()

    --按钮状态调整
    self.achievementBtn_:setButtonEnabled(false)
    self.dailyBtn_:setButtonEnabled(true)
    self.stageBtn_:setButtonEnabled(true)
    
    self.tag_ = 3

    --重置列表
    if self.listView ~= nil then
        --self.listView:removeSelf()
        self.listView:removeAllItems()
        self.listView = nil    
    end
    self:createListView_("achievement",self.achievementModelTable1_,self.achievementModelTable2_,self.achievementModelTable3_)
    
end

--创建列表
function AchievementLayer:createListView_(type_,table1,table2,table3)
    local count1 = #table1
    local count2 = #table2
    local count3 = #table3

    --加载成就列表
    self.listView = cc.ui.UIListView.new {
        bgColor = cc.c4b(255,255,255,0),
        --bg = "achievement/table_bg.png",
        viewRect = cc.rect(75,42,680,518),
        direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
        scrollbarImgV = "tasks/bar.png"}
        :onTouch(handler(self, self.touchListener))
        :addTo(self.bg_)
    -- add items
    for i=1,(count1 + count2 + count3) do
        local item = self.listView:newItem()
        local content = nil
        local tempModel = nil
        if i <= count1 then                   --可领取
            tempModel = table1[i]
        elseif i <= (count1 + count2) then
            tempModel = table2[i - count1]
        else
            tempModel = table3[i - count1 - count2]
        end
        if type_ == "achievement" then
            content = AchievementIcon.new(tempModel)
        elseif type_ == "daily" then
            content = DailyTaskIcon.new(tempModel)
        else
            content = StageTaskIcon.new(tempModel)
        end
        item:addContent(content)
        item:setItemSize(666,162)
        self.listView:addItem(item)
    end
    self.listView:reload()
end

--弹窗关闭
function AchievementLayer:closeCallBack_()
    --播放音效(关闭层)
	if GameManager.SOUND_SWITCH_ON then
		audio.playSound(string.format("sounds/sfx_touch_shu.%s",GameManager.POSTFIX))
	end
    
    GameManager.IS_ACHIEVEMENT_LAYER_CLOSED   = true
    local popupLayer = transition.sequence({
        cc.ScaleTo:create(0.1,1.1),
        cc.ScaleTo:create(0.2,0),cc.CallFunc:create(function()
            self:removeSelf()
        end)
        })
    self.emptyNode_:runAction(popupLayer)
end

function AchievementLayer:touchListener(event)
    local lv = event.listView
    if "clicked" == event.name then
        print(event.itemPos)
        if self.tag_ == 2 then
            local currLayer = display.getRunningScene()
            if event.itemPos == 1 then
                local layer = StageTaskSubLayer.new(event.itemPos)
                currLayer:addChild(layer,200)
            else
                if CloudData.CHAPTER_TASK_INFO[event.itemPos - 1] == -1 then 
                    local layer = StageTaskSubLayer.new(event.itemPos)
                    currLayer:addChild(layer,200)
                else
                    local toast = WSToast.new("请先完成上一章节全部任务")
                    currLayer:addChild(toast,200)
                end    
            end
        end
    elseif "moved" == event.name then
       
    elseif "ended" == event.name then
        
    else
        --print("event name:" .. event.name)
    end
end

return AchievementLayer