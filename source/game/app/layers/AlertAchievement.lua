--
--领取成就奖励时弹出的确定弹窗
--

REWARD_TYPE_PEACH         = 1
REWARD_TYPE_BUDDHA        = 2
REWARD_TYPE_EXP           = 3
REWARD_TYPE_GINSENGFRUIT  = 4
REWARD_TYPE_SWEEP         = 5
REWARD_TYPE_ESSENCE       = 6
REWARD_TYPE_ENERGY        = 7

local AlertAchievement = class("AlertAchievement", function()
	return display.newLayer()
end)

function AlertAchievement:ctor(rewardType,rewardNum)
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

   --初始化界面
   self:initUI_(rewardType,rewardNum)
end

--首充UI
function AlertAchievement:initUI_(rewardType,rewardNum)
    --背景
    local bg = display.newSprite("sign/frame.png")
        :addTo(self.emptyNode_)

    --tip描述("恭喜你获得了......")
    local tipLabel = cc.ui.UILabel.new({UILabelType = 2,text = "",size = 26,color = cc.c3b(63,31,4),
        align = cc.ui.TEXT_ALIGN_LEFT,dimensions = cc.size(240,120),font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,bg:getContentSize().width * 0.65,bg:getContentSize().height * 0.52)
        :addTo(bg)

    --奖励图标
    local frame = display.newSprite("sign/signk.png",bg:getContentSize().width * 0.2,bg:getContentSize().height * 0.5)  
        :addTo(bg)
    local icon = display.newSprite()
        :pos(frame:getContentSize().width * 0.5,frame:getContentSize().height * 0.5)  
        :addTo(frame)
        --根据奖励类型区分
    if rewardType == REWARD_TYPE_PEACH then
        tipLabel:setString(string.format("恭喜你！获得了%d个蟠桃！",rewardNum))
        icon:setTexture("sign/pantao.png")

    elseif rewardType == REWARD_TYPE_BUDDHA then
        local buddhaModel = DataUtils.getBuddhaModel(rewardNum)
        tipLabel:setString(string.format("恭喜你！获得了神仙%s！",buddhaModel.name_))
        icon:setTexture(string.format("buddha_icon/buddha%d.png",rewardNum))
        icon:setScale(1.1)

    elseif rewardType == REWARD_TYPE_EXP then
        tipLabel:setString(string.format("恭喜你！获得了%d经验！",rewardNum))
        icon:setTexture("sign/exp.png")

    elseif rewardType == REWARD_TYPE_GINSENGFRUIT then
        tipLabel:setString(string.format("恭喜你！获得了%d个人参果！",rewardNum))
        icon:setTexture("sign/renshen.png")

    elseif rewardType == REWARD_TYPE_SWEEP then
        tipLabel:setString(string.format("恭喜你！获得了%d个扫荡券！",rewardNum))
        icon:setTexture("sign/saodang.png")

    elseif rewardType == REWARD_TYPE_ESSENCE then
        tipLabel:setString(string.format("恭喜你！获得了%d个精华石！",rewardNum))
        icon:setTexture("summon_scene/essence_pic.png")
        icon:setScale(105/95)

    elseif rewardType == REWARD_TYPE_ENERGY then
        tipLabel:setString(string.format("恭喜你！获得了%d点精力！",rewardNum))
        icon:setTexture("sign/energy.png")
    end

    --奖励数量显示(兵种没有数量显示)
    -- if rewardType ~= REWARD_TYPE_BUDDHA then
    --     local numLabel = cc.ui.UILabel.new({UILabelType = 2,text = string.format("x"..rewardNum),
    --         size = 20,color = display.COLOR_BLACK})
    --         :align(display.CENTER,frame:getPositionX() + frame:getContentSize().width * 0.52, bg:getContentSize().height * 0.4)
    --         :addTo(bg)
    --     numLabel:setAnchorPoint(0,0.5)
    -- end
    
    --关闭按钮
    cc.ui.UIPushButton.new({normal = "sign/known.png",pressed = "sign/known_h.png"})
        :align(display.CENTER,bg:getContentSize().width * 0.65,bg:getContentSize().height * 0.25)
        :onButtonClicked(function()
            self:closeCallBack_()
        end)
        :addTo(bg)
end

function AlertAchievement:closeCallBack_()
    --弹出关闭,置为true
    GameManager.IS_ALERT_ACHIEVEMENT_CLOSED   = true

    local popupLayer = transition.sequence({cc.ScaleTo:create(0,1.0),
        cc.ScaleTo:create(0.1,1.1),
        cc.ScaleTo:create(0.2,0),cc.CallFunc:create(function()
            self:removeSelf()
        end)
        })
    self.emptyNode_:runAction(popupLayer)
end

return AlertAchievement