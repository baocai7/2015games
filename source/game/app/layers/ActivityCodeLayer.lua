--
--活动码,兑换码等数据处理
--
local AlertConnection = import("customs.AlertConnection")
local WSToast = import("utils.WSToast")

local ActivityCodeLayer = class("ActivityCodeLayer", function()
	return display.newLayer()
end)

function ActivityCodeLayer:ctor()
	--添加遮罩层
	display.newColorLayer(cc.c4b(0,0,0,150)):addTo(self,-1)

	--初始化基础节点
	self.emptyNode_ = display.newNode()
	self.emptyNode_:setPosition(display.cx,display.height * 0.78)
	self:addChild(self.emptyNode_)

	--弹出效果
	self.emptyNode_:setScale(0)
	local popupLayer = transition.sequence(
		{cc.ScaleTo:create(0.2, 1.1),
		cc.ScaleTo:create(0.1, 1.0)})
	self.emptyNode_:runAction(popupLayer)

   --初始化界面
   self:initUI_()
end

--初始化UI
function ActivityCodeLayer:initUI_()
    --背景
    local bg = display.newSprite("activity/activityBg.png")
        :addTo(self.emptyNode_)

    --输入框
    local editBox = cc.ui.UIInput.new({
        image = "activity/inputk.png",
        size = cc.size(486, 57),
        x = bg:getContentSize().width * 0.5,
        y = bg:getContentSize().height * 0.57,
        listener = function(event, editbox)
            if event == "began" then
                self:onEditBoxBegan(editbox)
            elseif event == "ended" then
                self:onEditBoxEnded(editbox)
            elseif event == "return" then
                self:onEditBoxReturn(editbox)
            elseif event == "changed" then
                self:onEditBoxChanged(editbox)
            else
                printf("EditBox event %s", tostring(event))
            end
        end
    }) 
    editBox:setReturnType(cc.KEYBOARD_RETURNTYPE_SEND)
    bg:addChild(editBox)

    --确定按钮
    cc.ui.UIPushButton.new({normal = "activity/get.png",pressed = "activity/get_h.png"})
        :align(display.CENTER,bg:getContentSize().width * 0.73,bg:getContentSize().height * 0.25)
        :onButtonClicked(function()
            self:confirmCallBack_()
        end)
        :addTo(bg)

    --关闭按钮
    cc.ui.UIPushButton.new({normal = "activity/close.png",pressed = "activity/close_h.png"})
        :align(display.CENTER,bg:getContentSize().width * 0.27,bg:getContentSize().height * 0.25)
        :onButtonClicked(function()
            self:closeCallBack_()
        end)
        :addTo(bg)
end

function ActivityCodeLayer:confirmCallBack_()
    -- 兑换码逻辑
    local ac = AlertConnection.new(CONNECTION_GIFT_CODE_EXCHANGE,self.codeInput_)
    self:addChild(ac,100,12345)
    
    self.schedule_ = self:schedule(function()
        if not self:getChildByTag(12345) then
            self:stopAction(self.schedule_)
            
            if 0 == GameManager.ERROR_CODE then
                local msg = "兑换成功!获得"
                local msg1 = ""
                local msg2 = ""
                local msg3 = ""
                local msg4 = ""
                if CloudData.TAMP_DATA.expNum > 0  then
                    CloudData.EXP = CloudData.EXP + CloudData.TAMP_DATA.expNum
                    msg1 = string.format("%d经验",CloudData.TAMP_DATA.expNum)
                end
                if CloudData.TAMP_DATA.ginsengNum > 0  then
                    CloudData.GINSENG_FRUIT = CloudData.GINSENG_FRUIT + CloudData.TAMP_DATA.ginsengNum
                    msg2 = string.format("%d个人参果",CloudData.TAMP_DATA.ginsengNum)
                end
                if CloudData.TAMP_DATA.peachNum > 0  then
                    CloudData.PEACH = CloudData.PEACH + CloudData.TAMP_DATA.peachNum
                    --DataEye统计蟠桃产出
                    if USE_DATAEYE then  
                        DCCoin.gain("activitycode", "peach", CloudData.TAMP_DATA.peachNum, CloudData.PEACH)              
                    end

                    msg3 = string.format("%d个蟠桃",CloudData.TAMP_DATA.peachNum)
                end
                if CloudData.TAMP_DATA.sweepNum > 0  then
                    CloudData.SWEEP = CloudData.SWEEP + CloudData.TAMP_DATA.sweepNum
                    msg4 = string.format("%d个扫荡券",CloudData.TAMP_DATA.sweepNum)
                end
                WSToast.new(string.format("%s %s %s %s %s",msg,msg1,msg2,msg3,msg4),3.0):addTo(display.getRunningScene(),200)
            elseif 2 == GameManager.ERROR_CODE then
                WSToast.new(GameManager.ERROR_MSG):addTo(display.getRunningScene(),200)
            elseif 3 == GameManager.ERROR_CODE then
                WSToast.new(GameManager.ERROR_MSG):addTo(display.getRunningScene(),200)
            elseif 4 == GameManager.ERROR_CODE then
                WSToast.new(GameManager.ERROR_MSG):addTo(display.getRunningScene(),200)
            end
        end
    end,0.1)
end

function ActivityCodeLayer:onEditBoxBegan(editbox)
    printf("editBox1 event began : text = %s", editbox:getText())
    self.codeInput_ = editbox:getText()
end

function ActivityCodeLayer:onEditBoxEnded(editbox)
    printf("editBox1 event ended : %s", editbox:getText())
    self.codeInput_ = editbox:getText()
end

function ActivityCodeLayer:onEditBoxReturn(editbox)
    printf("editBox1 event return : %s", editbox:getText())
    self.codeInput_ = editbox:getText()
end

function ActivityCodeLayer:onEditBoxChanged(editbox)
    printf("editBox1 event changed : %s", editbox:getText())
    self.codeInput_ = editbox:getText()
end

function ActivityCodeLayer:closeCallBack_()
    local popupLayer = transition.sequence({cc.ScaleTo:create(0,1.0),
        cc.ScaleTo:create(0.1,1.1),
        cc.ScaleTo:create(0.2,0),cc.CallFunc:create(function()
            self:removeSelf()
        end)
        })
    self.emptyNode_:runAction(popupLayer)
end


return ActivityCodeLayer