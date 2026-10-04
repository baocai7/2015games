
--[[=============================================================================
#     FileName: ActivityStageIcon.lua
#         Desc: 活动关卡的不同等级的展示界面
#       Author: Hoo
#   LastChange: 2015-04-27 
#      History:
=============================================================================]]

local ActivityStageIcon  =  class("ActivityStageIcon", function()
	return display.newNode()
end)

function ActivityStageIcon:ctor(activityID)
	local costType     =  DataRetainer.ACTIVITY_STAGE_INFO:objectAtIndex(activityID)["costType"]
	local rewardType   =  tonumber(DataRetainer.ACTIVITY_STAGE_INFO:objectAtIndex(activityID)["rewardType"])
	local costNum      =  tonumber(DataRetainer.ACTIVITY_STAGE_INFO:objectAtIndex(activityID)["costNum"])
    local rewardNumMin =  tonumber(DataRetainer.ACTIVITY_STAGE_INFO:objectAtIndex(activityID)["rewardNumMin"])
    local rewardNumMax =  tonumber(DataRetainer.ACTIVITY_STAGE_INFO:objectAtIndex(activityID)["rewardNumMax"])
    local stageLimit   =  tonumber(DataRetainer.ACTIVITY_STAGE_INFO:objectAtIndex(activityID)["stageLimit"])
    -- local towerId      =  tonumber(DataRetainer.ACTIVITY_STAGE_INFO:objectAtIndex(activityID)["towerId"])
    -- local distance     =  tonumber(DataRetainer.ACTIVITY_STAGE_INFO:objectAtIndex(activityID)["distance"])
    -- print("====================================================")
    -- print("costType : "..costType)
    -- print("rewardType : "..rewardType)
    -- print("costNum : "..costNum)
    -- print("rewardNumMin : "..rewardNumMin)
    -- print("rewardNumMax : "..rewardNumMax)
    -- print("stageLimit : "..stageLimit)
    -- print("towerId : "..towerId)
    -- print("distance : "..distance)
    -- print("====================================================")

    -- 颜色Table
    self.colorTable_ = {cc.c3b(255,255,255),cc.c3b(254,236,16),cc.c3b(254,14,252)}

    -- 背景
    local bg = display.newSprite(string.format("activity_stage/frame%d.png",activityID)):addTo(self)

    -- title
    local titleLabel = cc.ui.UILabel.new({
        UILabelType = 2,text = string.format("建议通关%d关以后挑战",stageLimit),size = 20,color = self.colorTable_[activityID],font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,bg:getContentSize().width * 0.5,bg:getContentSize().height * 0.90)
        :addTo(bg)    

    -- 图标
    local icon = display.newSprite(string.format("activity_stage/icon%d.png",activityID),
    	bg:getContentSize().width * 0.5,bg:getContentSize().height * 0.55):addTo(bg)

    -- 进入关卡需要消耗的资源
    local costPic = nil
    if costType == "energy" then
    	costPic = display.newSprite("activity_stage/energy_cost.png",bg:getContentSize().width * 0.5,bg:getContentSize().height * 0.2)
    		:addTo(bg)

		-- 消耗的数量
		cc.ui.UILabel.new({
		    UILabelType = 1,text = costNum,font = "fonts/whiteNum.fnt"})
			:scale(0.65)
		    :align(display.CENTER,costPic:getContentSize().width * 0.52,costPic:getContentSize().height * 0.50)
		    :addTo(costPic)    
    end

    -- 关卡奖励物品
    	-- “奖励:”
    cc.ui.UILabel.new({
        UILabelType = 2,text = "奖励：",size = 22,color = cc.c3b(255,255,255),font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,bg:getContentSize().width * 0.3,bg:getContentSize().height * 0.07)
        :addTo(bg)  
        -- 图标
    local rewardPic = display.newSprite(string.format("activity_stage/currency_pic%d.png",rewardType),
    	bg:getContentSize().width * 0.48,bg:getContentSize().height * 0.07)
    	:scale(0.9)
    	:addTo(bg)
    	-- 数量
    cc.ui.UILabel.new({
        UILabelType = 1,text = string.format("%d-%d",rewardNumMin,rewardNumMax),font = "fonts/whiteNum.fnt"})
    	:scale(0.5)
        :align(display.CENTER_LEFT,bg:getContentSize().width * 0.48 + rewardPic:getContentSize().width * 0.5,bg:getContentSize().height * 0.07)
        :addTo(bg)  

    -- 选中框
    self.selectedFrame_ = display.newSprite("activity_stage/selected.png",bg:getContentSize().width * 0.5,bg:getContentSize().height * 0.5)
    	:hide()
    	:addTo(bg)

    self:setContentSize(bg:getContentSize())
    self:setTouchEnabled(true)
end

-- 选中状态
function ActivityStageIcon:isSelected( isSelected )
	if isSelected then
		self.selectedFrame_:show()
	else
		self.selectedFrame_:hide()
	end
end

-- 返回icon的BoundingBox
function ActivityStageIcon:getMyBoundingBox()
	-- 转换世界坐标系
	local point = cc.p(self:getPositionX(),self:getPositionY())
	local worldpoint = self:getParent():convertToWorldSpace(point)
	local rect = cc.rect(worldpoint.x - self:getContentSize().width * 0.5,
		worldpoint.y - self:getContentSize().height * 0.5,
		self:getContentSize().width,
		self:getContentSize().height)
	return rect
end

return ActivityStageIcon