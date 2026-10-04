--
--各场景通用提示弹窗
--格式：背景图，关闭按钮，回调按钮
--

local AlertConnection = import("customs.AlertConnection")
local WSToast         = import("utils.WSToast")
local AlertLackEXPLayer = import("layers.AlertLackEXPLayer")

local TeamSceneLayer = class("TeamSceneLayer", function()
	return display.newLayer()
end)

function TeamSceneLayer:ctor(teamIcon)

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

    --初始化界面
    self:initUI_(teamIcon)
end

----初始化界面
function TeamSceneLayer:initUI_(teamIcon)
    local textStr       = ""
    local costExpNum    = 0
    local unlockGridNum = CloudData.TEAM_UNLOCKGRID_NUM     --获取当前已解锁格子数
    local currExpNum    = CloudData.EXP                     --获取当前的经验数

    if unlockGridNum == 3 then
        textStr = "花费5000exp解锁!"
        costExpNum = 5000
    elseif unlockGridNum == 4 then
        textStr = "花费10000exp解锁!"
        costExpNum = 10000
    elseif unlockGridNum == 5 then
        textStr = "花费30000exp解锁!"
        costExpNum = 30000
    end
    
    --背景图
    local bg = display.newSprite("common_ui/common_bg.png"):addTo(self.emptyNode_,1)

    --文本
    cc.ui.UILabel.new({
        UILabelType = 2,text = textStr ,size = 32,color = display.COLOR_BLACK,font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,bg:getContentSize().width * 0.5,bg:getContentSize().height * 0.57)
        :addTo(bg)

    --确定按钮
    cc.ui.UIPushButton.new({normal = "common_ui/confirm.png",pressed = "common_ui/confirm_h.png"})
        :align(display.CENTER,bg:getContentSize().width * 0.5,bg:getContentSize().height * 0.22)
        :onButtonClicked(function() 
            if currExpNum >= costExpNum then
            
                local ac = AlertConnection.new(CONNECTION_UNLOCK_TEAM_NUM)
                self:addChild(ac,100,12345)
                
                self.scheduleResult_ = self:schedule(function()
                    if not self:getChildByTag(12345) then
                        self:stopAction(self.scheduleResult_)
                        --解锁成功
                        CloudData.EXP = currExpNum - costExpNum
                        CloudData.TEAM_UNLOCKGRID_NUM = unlockGridNum + 1
                        teamIcon:iconUnlock()
                        self:closeCallBack_()
                    end
                end,0.1)
            else
				local alert = AlertLackEXPLayer.new()
					self:addChild(alert, 20)
                --[[local toast = WSToast.new("经验不足")
                self:addChild(toast,50)--]]
            end
        end)
        :addTo(bg,2)

    --关闭按钮
    cc.ui.UIPushButton.new({normal = "common_ui/close.png",pressed = "common_ui/close_h.png"})
        :align(display.CENTER,bg:getContentSize().width * 0.95,bg:getContentSize().height * 0.95)
        :onButtonClicked(function()
            self:closeCallBack_()
        end)
        :scale(0.8)
        :addTo(bg,2)
end

function TeamSceneLayer:closeCallBack_()
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

return TeamSceneLayer