--
--成就查看与领取
--

local AlertConnection   = import("customs.AlertConnection")
local StageTaskSubIcon  = import("icons.StageTaskSubIcon")

local StageTaskSubLayer  =  class("StageTaskSubLayer", function()
	return display.newLayer()
end)

function StageTaskSubLayer:ctor(periodicNum)
	--添加遮罩层
	m_pMaskLayer = display.newColorLayer(cc.c4b(0,0,0,180))
	self:addChild(m_pMaskLayer,-1)

	--初始化基础节点
	self.emptyNode_ = display.newNode()
	self.emptyNode_:setPosition(display.cx,display.height * 0.45)
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

    GameManager.IS_ALERT_ACHIEVEMENT_CLOSED = false
    self.periodicNum_ = periodicNum

    --联网加载数据
    local ac = AlertConnection.new(CONNECTION_STAGE_TASK_SUB_INFO,periodicNum)
    self:addChild(ac,100,12345)
 
    self.scheduleS_ = self:schedule(function()
        if not self:getChildByTag(12345) then
            self:stopAction(self.scheduleS_)
            --对任务状态进行分类
            self:initStageTaskSubModel_(periodicNum)
            --init
            self:initUI_()              
       
            --检测是否领奖,刷新列表
            self.schedule_ = self:schedule(function() 
                self:updateListView_()
            end,0.01)              
        end
    end,0.1)  
end

--对任务完成状态就行分类(不可领取,可领取,已完成)
function StageTaskSubLayer:initStageTaskSubModel_(periodicNum)
    self.stageTaskSubModelTable1_ = {}        --可领取
    self.stageTaskSubModelTable2_ = {}        --不可领取
    self.stageTaskSubModelTable3_ = {}        --已完成
    local modelTable = DataUtils.getStageTaskSubModelTable(periodicNum)
    for i=1,#modelTable do
        local stageTaskSubModel = modelTable[i]
        local stageTaskSubId    = tonumber(stageTaskSubModel.subId_)
        local totalData         = tonumber(stageTaskSubModel.totalData_)
        local currentData       = stageTaskSubModel.currData_
        if not DataUtils.getStageTaskSubCompleted(stageTaskSubId) then
            if currentData >= totalData then
                table.insert(self.stageTaskSubModelTable1_,stageTaskSubModel)
            else
                table.insert(self.stageTaskSubModelTable2_,stageTaskSubModel)
            end
        else
            table.insert(self.stageTaskSubModelTable3_,stageTaskSubModel)
        end
    end
end

--初始化界面UI
function StageTaskSubLayer:initUI_()
	--背景
	self.bg_ = display.newSprite("tasks/stage/bg_frame.png")
	self.emptyNode_:addChild(self.bg_,20)

    --创建listView
    self:createListView_()

    --关闭按钮
    cc.ui.UIPushButton.new({normal = "common_ui/close.png",pressed = "common_ui/close_h.png"})
        :scale(0.85)
        :onButtonClicked(function()
        	self:closeCallBack_()
        end)
        :align(display.CENTER,self.bg_:getContentSize().width * 0.93,self.bg_:getContentSize().height * 0.96)
        :scale(0.8)
        :addTo(self.bg_,20)  
end

--检测刷新列表
function StageTaskSubLayer:updateListView_()
    if GameManager.IS_ALERT_ACHIEVEMENT_CLOSED then
        --重置为false
        GameManager.IS_ALERT_ACHIEVEMENT_CLOSED = false
        
        --重新加载数据,刷新列表
        if self.listView ~= nil then
            self.listView:removeSelf()    
            self.listView = nil
        end
        self:initStageTaskSubModel_(self.periodicNum_)
        self:createListView_()	
    end
end

--创建列表
function StageTaskSubLayer:createListView_()
    local table1 = self.stageTaskSubModelTable1_
    local table2 = self.stageTaskSubModelTable2_
    local table3 = self.stageTaskSubModelTable3_
    local count1 = #table1
    local count2 = #table2
    local count3 = #table3

    --加载成就列表
    self.listView = cc.ui.UIListView.new {
        bgColor = cc.c4b(255,255,255,0),
        --bg = "achievement/table_bg.png",
        viewRect = cc.rect(200,25,640,470),
        direction = cc.ui.UIScrollView.DIRECTION_VERTICAL}
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
       
        content = StageTaskSubIcon.new(tempModel)
        item:addContent(content)
        item:setItemSize(640,110)

        self.listView:addItem(item)
    end
    self.listView:reload()
end

--弹窗关闭
function StageTaskSubLayer:closeCallBack_()
    --播放音效(关闭层)
	if GameManager.SOUND_SWITCH_ON then
		audio.playSound(string.format("sounds/sfx_touch_shu.%s",GameManager.POSTFIX))
	end
    
    GameManager.IS_ALERT_ACHIEVEMENT_CLOSED   = true
    local popupLayer = transition.sequence({
        cc.ScaleTo:create(0.1,1.1),
        cc.ScaleTo:create(0.2,0),cc.CallFunc:create(function()
            self:removeSelf()
        end)
        })
    self.emptyNode_:runAction(popupLayer)
end

function StageTaskSubLayer:touchListener(event)
    local lv = event.listView
    if "clicked" == event.name then
        --event.item:setItemSize(666,324)
        print(event.itemPos)
    elseif "moved" == event.name then
       
    elseif "ended" == event.name then
        
    else
        --print("event name:" .. event.name)
    end
end

return StageTaskSubLayer