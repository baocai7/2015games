--
--转盘界面
--

local AlertConnection   = import("customs.AlertConnection")
local CompatTrace       = import("utils.CompatTrace")

local SpinLayer = class("SpinLayer", function ()
    return display.newLayer()
end)

PI         = 3.141592654

function SpinLayer:ctor()
    --添加遮罩层
    display.newColorLayer(cc.c4b(0,0,0,150))
        :addTo(self,-1)

    --初始化基础节点
    self.emptyNode_ = display.newNode()
        :scale(0)
        :pos(display.cx, display.cy)
        :addTo(self,1)

    --弹出效果
    local popupLayer = transition.sequence(
        {cc.ScaleTo:create(0.2, 1.1),
            cc.ScaleTo:create(0.1, 1.0)})
    self.emptyNode_:runAction(popupLayer)

    --播放音效(打开层)
    if GameManager.SOUND_SWITCH_ON then
        audio.playSound(string.format("sounds/sfx_touch_ti.%s",GameManager.POSTFIX))
    end

    --初始化界面
    self:initData_()
    self:initUI_()
end

function SpinLayer:initData_()
    --type 1:EXP  2:精华石  3:扫荡券  5.道具1（1-金刚盾 2-金钟罩 3-万字符）
    --	   6：道具2（1-芭蕉扇 2-老君金丹 3-献宝令） 4:人参果  7:特殊奖励
    self.drawNum_  = CloudData.DRAW_NUM        --抽奖次数(0-3为有效抽奖)
    self.drawCost_ = self.drawNum_ * 5         --花费的蟠桃数
    if self.drawNum_ >= 4 then
        self.drawCost_ = 0
    end

    self.isSpecial_ = CloudData.DRAW_ACTIVITY_STATUS
    CompatTrace.log("lottery-ui", string.format("init drawNum=%s cost=%s peach=%s activity=%s",
        tostring(self.drawNum_), tostring(self.drawCost_), tostring(CloudData.PEACH), tostring(self.isSpecial_)))
end

function SpinLayer:initUI_()
    --加载特效文件
    display.addSpriteFrames("animation/circle_tx.plist","animation/circle_tx.pvr.ccz")
    display.addSpriteFrames("animation/pointer_tx.plist","animation/pointer_tx.png")
    display.addSpriteFrames("animation/baoji.plist","animation/baoji.png")

    --转盘外圈
    self.circle_ = display.newSprite("spin/circle.png", 0 , 20) --,self.bgFrame_:getContentSize().width * 0.05,self.bgFrame_:getContentSize().height * 0.537)
        :addTo(self.emptyNode_)

    --转盘内部圆盘
    local img = "spin/disk.png"
    if self.isSpecial_ == 1 then
        img = "spin/disk1.png"
    end
    self.disk_ = display.newSprite(img, self.circle_:getContentSize().width * 0.5,self.circle_:getContentSize().height * 0.475)
        :addTo(self.circle_)

    --指针
    self.pointer_ =  display.newSprite("spin/pointer.png",self.circle_:getContentSize().width * 0.5,self.circle_:getContentSize().height * 0.81)
        :addTo(self.circle_)

    --转盘按钮
    self.startBtn_ = cc.ui.UIPushButton.new({normal = "spin/start.png",pressed = "spin/start_h.png"})
        :pos(self.disk_:getPositionX(),self.disk_:getPositionY())
        :onButtonClicked(function()
            self:startCallBack_()
        end)
        :addTo(self.circle_,2)

    --信息展示
    display.newSprite("spin/tip.png",self.circle_:getContentSize().width * (-0.12),self.circle_:getContentSize().height * 0.75)
        :addTo(self.circle_, -1)

    local restFrame = display.newSprite("spin/last.png",self.circle_:getContentSize().width * 0.5, 0)
        :addTo(self.circle_)
    restFrame:setAnchorPoint(0.5, 1)

    --剩余次数
    local num = 4 - self.drawNum_
    self.restTimesText = cc.ui.UILabel.new({UILabelType = 1,text = num,font = "fonts/greenNum.fnt"})
        :scale(0.7)
        :align(display.CENTER_LEFT,restFrame:getContentSize().width * 0.41,restFrame:getContentSize().height * 0.5)
        :addTo(restFrame)

    --本次费用
    --local costNum = self.drawCost_
    self.costText = cc.ui.UILabel.new({UILabelType = 2,text = string.format("x%d",self.drawCost_),size = 24,font = GameManager.FONTNAME_TTF})
        :align(display.CENTER_LEFT,restFrame:getContentSize().width * 0.82,restFrame:getContentSize().height * 0.5)
        :addTo(restFrame)

    if CloudData.DRAW_NUM >= 4 or CloudData.PEACH < self.drawCost_ then
        self.startBtn_:setButtonImage("disabled","spin/start_u.png", ignoreEmpty)
        self.startBtn_:setButtonEnabled(false)
    end

    --关闭按钮
    cc.ui.UIPushButton.new({normal = "common_ui/close.png",pressed = "common_ui/close_h.png"})
        :scale(0.75)
        :pos(self.circle_:getContentSize().width * 1.01,self.circle_:getContentSize().height * 0.825)
        :onButtonClicked(function()
            self:closeCallBack_()
        end)
        :addTo(self.circle_,1)

end

--奖品信息展示(数量,名称,简介...)
function SpinLayer:awardInfoShow_(id)
    --灰色遮罩
    self.awardLayer = display.newColorLayer(cc.c4b(0,0,0,180))
    self.awardLayer:setVisible(false)
    self:addChild(self.awardLayer,3)

    --响应事件
    self.awardLayer:addNodeEventListener(cc.NODE_TOUCH_EVENT, function()
        self:getReward_()
    end)
    self.awardLayer:setTouchEnabled(false)

    self.awardLayer:runAction(transition.sequence({cc.DelayTime:create(1.0),cc.CallFunc:create(function()
        self.awardLayer:setVisible(true)
        self.awardLayer:setTouchEnabled(true)
    end)}))

    --添加一张透明图,以便于切换信息时移除所有子节点
    self.clearBg_ = display.newSprite("spin/frame.png",display.cx, display.cy)
        :addTo(self.awardLayer,1)

    --读取配置文件信息
    self.fortuneWheelInfo_ = DataRetainer.FORTUNE_WHEEL_INFO
    local awardId   = tonumber(self.fortuneWheelInfo_:objectAtIndex(id)["id"])
    local picPath   = self.fortuneWheelInfo_:objectAtIndex(id)["path"]
    local awardName = self.fortuneWheelInfo_:objectAtIndex(id)["name"]
    local awardDesc = self.fortuneWheelInfo_:objectAtIndex(id)["desc"]
    -- print("awardId = "..tonumber(awardId))
    -- print("awardName = "..awardName)
    -- print("awardDesc = "..awardDesc)

    --奖品图片
    local frame = display.newSprite("sign/signk.png",self.clearBg_:getContentSize().width * 0.4,self.clearBg_:getContentSize().height * 0.78)
        :scale(0.75)
        --:pos(self.clearBg_:getContentSize().width * 0.55,self.clearBg_:getContentSize().height * 0.72)
        :addTo(self.clearBg_)
    local awardPic = display.newSprite(picPath,frame:getContentSize().width * 0.5,frame:getContentSize().height * 0.5)
        --:pos(frame:getContentSize().width * 0.5,frame:getContentSize().height * 0.5)
        :addTo(frame)
    if awardId == 2 or awardId > 4 then
        awardPic:setScale(105/96)
    end

    if id == 11 then
        frame:setPosition(self.clearBg_:getContentSize().width * 0.5,self.clearBg_:getContentSize().height * 0.78)
        
        --联网加载数据(主要用于任务等界面的"new"提示)
        local ac = AlertConnection.new(CONNECTION_CHAPTER_NEW_INFO)
        self:addChild(ac,100,12346)

        self.scheduleCH_ = self:schedule(function()
            if not self:getChildByTag(12346) then
                self:stopAction(self.scheduleCH_)

                local redPoint =  display.getRunningScene():getChildByTag(TAG_MAIL_NEW)
                if redPoint == nil then
                    return
                end
                redPoint:setVisible(true)                  
            end
        end,0.1)
    else
        --标签:获得道具
        local tipLabel = display.newSprite("spin/label.png",self.clearBg_:getContentSize().width * 0.25,self.clearBg_:getContentSize().height * 0.878)
            :addTo(self.clearBg_)

        --奖品名称
        local nameLabel = cc.ui.UILabel.new({UILabelType = 2,text = awardName,size = 24,color = display.WHITE,font = GameManager.FONTNAME_TTF})
            :align(display.CENTER_LEFT,frame:getPositionX() + frame:getContentSize().width * 0.6,self.clearBg_:getContentSize().height * 0.856)
            :addTo(self.clearBg_)
        --数量
        local numLabel = cc.ui.UILabel.new({UILabelType = 2,text = "数量:", size = 24,color = cc.c3b(252,255,4),font = GameManager.FONTNAME_TTF})
            :align(display.CENTER_LEFT,frame:getPositionX() + frame:getContentSize().width * 0.6,self.clearBg_:getContentSize().height * 0.719)
            :addTo(self.clearBg_)

        self.awardNumText_ = cc.ui.UILabel.new({UILabelType = 1,text = self.awardNum_,font = "fonts/greenNum.fnt"})
            :scale(0.7)
            :align(display.CENTER,numLabel:getPositionX() + 110,self.clearBg_:getContentSize().height * 0.719)
            :addTo(self.clearBg_)
    end   

    --奖品介绍
    local awardLabel = cc.ui.UILabel.new({UILabelType = 2,text = awardDesc,size = 23,align = cc.ui.TEXT_ALIGN_LEFT,dimensions = cc.size(410,100),font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,self.clearBg_:getContentSize().width * 0.5,self.clearBg_:getContentSize().height * 0.433)
        :addTo(self.clearBg_)

    --领取奖励按钮
    cc.ui.UIPushButton.new({normal = "spin/gain.png",pressed = "spin/gain_h.png", disabled = "spin/gain_gray.png"})
        :align(display.CENTER,self.clearBg_:getContentSize().width * 0.5,self.clearBg_:getContentSize().height * 0.14)
        :onButtonClicked(function()
            self:getReward_()
        end)
        :addTo(self.clearBg_)

    --self.awardNum_奖励数
    --self.critNum_暴击数
    if self.critNum_ > 1 then
        --特效
        self.clearBg_:runAction(transition.sequence({cc.DelayTime:create(1.0),cc.CallFunc:create(function()
            self:showCrit_()
        end)}))
    end
end

function SpinLayer:showCrit_()
    self.awardNumText_:setString(string.format("%d",self.awardNum_ * self.critNum_))
    self.clearBg_:setPosition(display.cx, display.cy - 145)

    local eff = display.newSprite()
        :pos(self.clearBg_:getContentSize().width * 0.41,self.clearBg_:getContentSize().height * 1.25)
        :addTo(self.clearBg_)

    local frames = display.newFrames("baoji%d.png",1,10)
    local animation = display.newAnimation(frames, 0.06)
    eff:playAnimationOnce(animation, false)

    self.clearBg_:runAction(transition.sequence({cc.DelayTime:create(0.45),cc.CallFunc:create(function()
        self:showCritNum_()
    end)}))
end

function SpinLayer:showCritNum_()
    local eff = display.newSprite("spin/x.png",self.clearBg_:getContentSize().width * 1.1,self.clearBg_:getContentSize().height * 1.25)
        :addTo(self.clearBg_)

    local img= "spin/" .. self.critNum_ .. ".png"
    display.newSprite(img,eff:getContentSize().width * 1.5,eff:getContentSize().height * 0.5)
        :addTo(eff)

    local pos = cc.p(self.clearBg_:getContentSize().width * 0.6,self.clearBg_:getContentSize().height * 1.25)
    local popupLayer = transition.sequence({
        cc.MoveTo:create(0.1, pos),
        cc.RotateBy:create(0.02,15),
        cc.RotateBy:create(0.05,-25),
        cc.CallFunc:create(function()
            self:changeAwardNum_()
        end),
        cc.RotateBy:create(0.02,10)
    })
    eff:runAction(popupLayer)
end

function SpinLayer:changeAwardNum_()
    local num = self.awardNum_ * self.critNum_
    self.awardNumText_:setString(string.format("%d",self.awardNum_ * self.critNum_))

    local popupLayer = transition.sequence({
        cc.ScaleTo:create(0.1,3.2),
        cc.ScaleTo:create(0.05,2.0),
        cc.ScaleTo:create(0.02,0.7),
        cc.ScaleTo:create(0.03,1.0),
    })
    self.awardNumText_:runAction(popupLayer)
end

--点击开始
function SpinLayer:startCallBack_()
    --屏蔽按钮点击
    self.startBtn_:setButtonEnabled(false)
    CompatTrace.log("lottery-ui", string.format("start drawNum=%s cost=%s peach=%s",
        tostring(CloudData.DRAW_NUM), tostring(self.drawCost_), tostring(CloudData.PEACH)))

    if CloudData.DRAW_NUM < 4 then
        if CloudData.PEACH >= self.drawCost_ then
            --联网加载数据
            local ac = AlertConnection.new(CONNECTION_DRAW_LOTTERY)
            self:addChild(ac,100,12346)

            local actionId = nil
            self.scheduleDL_ = self:schedule(function()
                if not self:getChildByTag(12346) then
                    self:stopAction(self.scheduleDL_)

                    self.awardId_  = CloudData.AWARD_ID + 1    --奖品id
                    self.critNum_  = CloudData.CRIT_NUM         --暴击倍数
                    self.itemId_   = CloudData.AWARD_ITEM_ID    --道具id
                    self.awardNum_ = CloudData.AWARD_NUM        --奖品数量

                    print("awardId = ···"..self.awardId_)
                    print("critNum_ = ···"..self.critNum_)
                    print("itemId_ = ···"..self.itemId_)
                    print("awardNum_ = ···"..self.awardNum_)
                    CompatTrace.log("lottery-ui", string.format("apply reward id=%s crit=%s item=%s num=%s",
                        tostring(self.awardId_), tostring(self.critNum_), tostring(self.itemId_), tostring(self.awardNum_)))

                    if self.drawCost_ > 0 then
                        --DataEye统计
                        if USE_DATAEYE then
                            DCEvent.onEvent("pay_".. self.drawCost_ .."_peach_for_wheel")
                        end
                    end

                    --数据更新
                    CloudData.PEACH    = CloudData.PEACH - self.drawCost_
                    CloudData.DRAW_NUM = CloudData.DRAW_NUM + 1
                    if self.awardId_ == 1 then
                        CloudData.EXP = CloudData.EXP + self.awardNum_ * self.critNum_
                    elseif self.awardId_ == 2 then
                        CloudData.ESSENCE = CloudData.ESSENCE + self.awardNum_ * self.critNum_
                    elseif self.awardId_ == 3 then
                        CloudData.SWEEP = CloudData.SWEEP + self.awardNum_ * self.critNum_
                    elseif self.awardId_ == 4 then
                        CloudData.GINSENG_FRUIT = CloudData.GINSENG_FRUIT + self.awardNum_ * self.critNum_
                    elseif self.awardId_ == 7 then
                        
                    elseif self.awardId_ > 4 then
                        CloudData.SKILL_ITEM_INFO[self.itemId_] = CloudData.SKILL_ITEM_INFO[self.itemId_] + self.awardNum_ * self.critNum_
                        
                        --DataEye统计道具使用
                        if USE_DATAEYE then 
                            local sum = self.awardNum_ * self.critNum_
                            local name
                            if self.itemId_ == 1 then
                                name = "LJJD"               
                            elseif self.itemId_ == 2 then 
                                name = "JGD"             
                            elseif self.itemId_ == 3 then
                                name = "BJS"             
                            elseif self.itemId_ == 4 then
                                name = "JZZ"              
                            elseif self.itemId_ == 5 then
                                name = "WZF"             
                            else
                                name = "XBL"               
                            end 
                            DCItem.get(name, "spin", sum, "reward for spin")                                                                  
                        end
                    end

                    --圆盘动画
                    if DataUtils.markResourceMutation ~= nil then
                        DataUtils.markResourceMutation("lottery-reward")
                    end

                    self.disk_:stopAction(actionId)
                    self.disk_:setRotation(0)

                    local tempId = self.awardId_
                    if self.isSpecial_ == 1 and self.awardId_ > 5 then
                        tempId = self.awardId_ - 1
                    end
                    local popupLayer = transition.sequence({
                        cc.RotateBy:create(0.5 + 1/12 * (1 - (tempId - 1) / 6),360 * 6 + (360 - (tempId - 1) * 60)),
                        cc.RotateBy:create(0.5,360 * 5),
                        cc.RotateBy:create(0.5,360 * 4),
                        cc.RotateBy:create(0.5,360 * 3),
                        cc.RotateBy:create(0.5,360 * 2),
                        cc.RotateBy:create(0.5,360 * 1),
                        cc.RotateBy:create(1,360),
                        cc.RotateBy:create(1,180),
                        cc.RotateBy:create(1,90),
                        cc.RotateBy:create(0.75,45),
                        cc.RotateBy:create(1,45),
                        cc.CallFunc:create(function()
                            self:setReward_(self.awardId_)
                        end)
                    })
                    self.disk_:runAction(popupLayer)

                    --外圈动画
                    local frames = display.newFrames("circle%d.png",1,4)
                    local animation = display.newAnimation(frames, 0.03)
                    self.circle_:playAnimationForever(animation)
                else

                    actionId = self.disk_:runAction(cc.RotateBy:create(0.1,360))
                end
            end,0.1)
        else
            self.startBtn_:setButtonImage("disabled","spin/start_u.png", ignoreEmpty)
            self.startBtn_:setButtonEnabled(false)
        end
    else
        self.startBtn_:setButtonImage("disabled","spin/start_u.png", ignoreEmpty)
        self.startBtn_:setButtonEnabled(false)
    end
end

function SpinLayer:setReward_(id)
    --由于后两种奖品为道具,此处做id转换
    if id == 5 then
        if self.itemId_ == 2 then
            id = 5
        elseif self.itemId_ == 4 then
            id = 6
        elseif self.itemId_ == 5 then
            id = 7
        end
    elseif id == 6 then
        if self.itemId_ == 3 then
            id = 8
        elseif self.itemId_ == 1 then
            id = 9
        elseif self.itemId_ == 6 then
            id = 10
        end
    elseif id == 7 then
        id = 11
    end

    --转盘外圈动画停止
    self.circle_:stopAllActions()
    --指针闪烁
    local frames = display.newFrames("pointer%d.png",1,2)
    local animation = display.newAnimation(frames, 0.05)
    local animate = cc.Animate:create(animation)
    self.pointer_:runAction(cc.Repeat:create(animate,10))

    self:awardInfoShow_(id)
end

function SpinLayer:getReward_()

    --开启按钮点击
    self.startBtn_:setButtonEnabled(true)

    if self.awardLayer ~= nil then
        self.awardLayer:removeSelf()
    end

    self:initData_()

    local num = 4 - self.drawNum_
    self.restTimesText:setString(num)

    self.costText:setString(self.drawCost_)

    if CloudData.DRAW_NUM >= 4 or CloudData.PEACH < self.drawCost_ then
        self.startBtn_:setButtonImage("disabled","spin/start_u.png", ignoreEmpty)
        self.startBtn_:setButtonEnabled(false)
    end
    --还原道具位置
    self.disk_:setRotation(0)
end





--弹窗关闭
function SpinLayer:closeCallBack_()
    --播放音效(关闭层)
    if GameManager.SOUND_SWITCH_ON then
        audio.playSound(string.format("sounds/sfx_touch_shu.%s",GameManager.POSTFIX))
    end

    display.removeUnusedSpriteFrames()
    local popupLayer = transition.sequence({cc.ScaleTo:create(0,1.0),
        cc.ScaleTo:create(0.1,1.1),
        cc.ScaleTo:create(0.2,0),cc.CallFunc:create(function()
            self:removeSelf()
        end)
    })
    self.emptyNode_:runAction(popupLayer)
end

return SpinLayer
