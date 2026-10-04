--
--服务器维护提醒,奖励领取(模拟邮箱系统)
--

local AlertConnection   = import("customs.AlertConnection")
local AlertUpdate       = import("customs.AlertUpdate")
local WSToast           = import("utils.WSToast")
local CSVParser         = import("utils.CSVParser")
local NewFellowLayer    = import("layers.NewFellowLayer")
local MailIcon          = import("icons.MailIcon")

local ServerMaintainLayer = {}
ServerMaintainLayer = class("ServerMaintainLayer", function()
    return display.newLayer()
end)

function ServerMaintainLayer:ctor(type_)
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

    --连网读取消息内容
    if type_ == 1 then       --奖励领取,消息提醒
        self:initData_()
    elseif type_ == 2 then   --进入游戏时服务器维护消息提醒
        self:init_()
    end
end

function ServerMaintainLayer:initData_()
    self.info_ = CloudData.SERVER_MSG
    dump(self.info_)
    self.mailIconTable_ = nil
    self.msgNum = #self.info_
    self:initUI1_()
end

--初始化领取维护补偿UI
function ServerMaintainLayer:initUI1_()
    --背景
    self.mailIconTable_ = {}
    dump(CloudData.READ_MSG_TABLE)
    local bg = display.newSprite("server_maintain/bg.png")
        :addTo(self.emptyNode_)

    -- display.newSprite("server_maintain/title.png")
    --     :pos(bg:getContentSize().width * 0.142,bg:getContentSize().height * 0.89)
    --     :addTo(bg)

    if self.listView ~= nil then
        self.listView:removeSelf()
        self.listView = nil
    end

    self.listView = cc.ui.UIListView.new {
        bgColor = cc.c4b(255,255,255,0),
        viewRect = cc.rect(75, 45, 870, 500),
        direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
    }
        :onTouch(handler(self, self.touchListener))
        :addTo(bg)

    -- add items
    for i=1, self.msgNum do
        local item = self.listView:newItem()

        local isRead = false
        local idd = self.info_[i].id
        local sid = string.format("%d",idd)
        if CloudData.READ_MSG_TABLE[sid] ~= nil then
            isRead = true
        end

        local content = MailIcon.new(i,isRead)
        table.insert(self.mailIconTable_, item)
        item:addContent(content)
        item:setItemSize(863,141)
        self.listView:addItem(item)
    end
    self.listView:reload()

    --关闭按钮
    cc.ui.UIPushButton.new({normal = "common_ui/close.png",pressed = "common_ui/close_h.png"})
        :scale(0.7)
        :align(display.CENTER,bg:getContentSize().width * 0.92,bg:getContentSize().height * 0.89)
        :onButtonClicked(function()
            self:closeCallBack_()
        end)
        :addTo(bg)
end

function ServerMaintainLayer:touchListener(event)
    if "clicked" == event.name then
        print(event.itemPos)
        --读取邮件
        if self.mailIconTable_[event.itemPos] ~= nil then
            self:initMsgUI(event.itemPos)
            self:showMsg_(event.itemPos)
        end
    end
end

function ServerMaintainLayer:initMsgUI(index)
    self.mailLayer = display.newColorLayer(cc.c4b(0,0,0,150)):addTo(self,3)
    self.mailBg_ = display.newSprite("server_maintain/mail_frame.png",display.cx, display.cy)
        :addTo(self.mailLayer)

    self.titleLabel = cc.ui.UILabel.new({
        UILabelType = 2,text = "",size = 25,color = cc.c3b(64,30,6),font = GameManager.FONTNAME_TTF})
        :align(display.CENTER_LEFT,self.mailBg_:getContentSize().width * 0.322,self.mailBg_:getContentSize().height * 0.867)
        :addTo(self.mailBg_)

    self.msgLabel = cc.ui.UILabel.new({
        UILabelType = 2,text = "",size = 26,color = cc.c3b(64,30,6),align = cc.ui.TEXT_ALIGN_LEFT,dimensions = cc.size(495,125),font = GameManager.FONTNAME_TTF})
        :align(display.CENTER_LEFT,self.mailBg_:getContentSize().width * 0.117,self.mailBg_:getContentSize().height * 0.68)
        :addTo(self.mailBg_)

    self.sendTimeLabel = cc.ui.UILabel.new({
        UILabelType = 2,text = "",size = 22,color = cc.c3b(123,81,46),font = GameManager.FONTNAME_TTF})
        :align(display.CENTER_RIGHT,self.mailBg_:getContentSize().width * 0.854,self.mailBg_:getContentSize().height * 0.565)
        :addTo(self.mailBg_)

    self.append = display.newSprite("server_maintain/append.png",self.mailBg_:getContentSize().width * 0.49,self.mailBg_:getContentSize().height * 0.38)
        :addTo(self.mailBg_)

    self.goods = {}
    for i = 1, 4 do
        self.goods[i] = display.newSprite("shop/saodang.png")
            :pos(self.append:getContentSize().width*(0.25 * i - 0.12),self.append:getContentSize().height * 0.314)
            :addTo(self.append)
        self.goods[i]:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
            return self:showAwardTip_(event.name,index,i)
        end)
        self.goods[i]:setTouchEnabled(false)

        print("width = " .. self.goods[i]:getContentSize().width .. "   height = " .. self.goods[i]:getContentSize().height)
        local tex = cc.ui.UILabel.new({
            UILabelType = 2,text = "5",size = 18,font = GameManager.FONTNAME_TTF})
            :align(display.CENTER_RIGHT, self.append:getContentSize().width*(0.25 * i - 0.02),self.append:getContentSize().height * 0.073)
            :addTo(self.append, 1)
        tex:setTag(i)
    end

    self.conButton = cc.ui.UIPushButton.new({normal = "server_maintain/get.png",pressed = "server_maintain/get1.png",disabled = "server_maintain/get2.png"})
        :align(display.CENTER,self.append:getContentSize().width * 0.5,self.append:getContentSize().height * (-0.26))
        :onButtonClicked(function()
            self:confirmCallBack_(index)
        end)
        :addTo(self.append)
    self.conButton:setVisible(false)

    self.append:setVisible(false)

    self.lastBtn_ = cc.ui.UIPushButton.new({normal = "server_maintain/last_msg.png",pressed = "server_maintain/last_msg1.png",disabled = "server_maintain/last_msg2.png"})
        :align(display.CENTER,self.mailBg_:getContentSize().width * 0.213,self.mailBg_:getContentSize().height * 0.16)
        :onButtonClicked(function()
            index = index - 1
            self:showMsg_(index)
        end)
        :addTo(self.mailBg_)
    self.lastBtn_:setButtonEnabled(false)

    self.nextBtn_ = cc.ui.UIPushButton.new({normal = "server_maintain/next_msg.png",pressed = "server_maintain/next_msg1.png",disabled = "server_maintain/next_msg2.png"})
        :align(display.CENTER,self.mailBg_:getContentSize().width * 0.775,self.mailBg_:getContentSize().height * 0.16)
        :onButtonClicked(function()
            index = index + 1
            self:showMsg_(index)
        end)
        :addTo(self.mailBg_)
    self.nextBtn_:setButtonEnabled(false)

    --关闭按钮
    cc.ui.UIPushButton.new({normal = "common_ui/close.png",pressed = "common_ui/close_h.png"})
        :scale(0.7)
        :align(display.CENTER,self.mailBg_:getContentSize().width * 0.928,self.mailBg_:getContentSize().height * 0.94)
        :onButtonClicked(function()
            self.mailLayer:removeSelf()
            self.mailLayer = nil
        end)
        :addTo(self.mailBg_)
end

function ServerMaintainLayer:showAwardTip_(event,msgNo,index)
    if event == "began" then
        local cPropInfo = self.info_[msgNo]
        local goodsid = tonumber(cPropInfo["goods" .. index])
        if goodsid == 0 then
            return
        end

        local cPropExl = DataRetainer.GOODS_INFO
        local name = cPropExl:objectAtIndex(goodsid)["goodsName"]

        self.tip_ = display.newSprite("sign/tips.png")
            :pos(self.append:getContentSize().width*(0.25 * index - 0.12),self.append:getContentSize().height * 0.62)
            :addTo(self.append)

        cc.ui.UILabel.new({text = name,size = 25,color = display.WHITE,
            font = GameManager.FONTNAME_TTF,dimensions = cc.size(175,85)})
            :align(display.CENTER, self.tip_:getContentSize().width*0.52,self.tip_:getContentSize().height*0.45)
            :addTo(self.tip_)
        self.tip_:setAnchorPoint(0.5, 0)
        return true
    end

    if event == "ended" then
        if self.tip_ then
            self.tip_:removeSelf()
            self.tip_ = nil
        end
    end
end

function ServerMaintainLayer:showMsg_(index)
    --判断上下按钮是否显示
    if index <= 1 then
        self.lastBtn_:setButtonEnabled(false)
    else
        self.lastBtn_:setButtonEnabled(true)
    end

    if index >= self.msgNum then
        self.nextBtn_:setButtonEnabled(false)
    else
        self.nextBtn_:setButtonEnabled(true)
    end

    --若无邮件信息则返回（正常情况下不会出现）
    local cPropInfo = self.info_[index]
    if cPropInfo == nil then
        return
    end

    --加载goodsInfo配置表
    local cPropExl = DataRetainer.GOODS_INFO

    self.titleLabel:setString(cPropInfo.title)
    self.msgLabel:setString(cPropInfo.msg)
    self.sendTimeLabel:setString(cPropInfo.sendTime)

    self.mailIconTable_[index]:getContent():readMail()
    --判断是否删除主界面小红点
    local tag = true
    for i= 1, self.msgNum do
        tag = tag and self.mailIconTable_[i]:getContent():getMailState()
        if not tag then
            break
        end
    end
    if tag then
        local redPoint =  display.getRunningScene():getChildByTag(TAG_MAIL_NEW)
        if redPoint == nil then
            return
        end
        redPoint:setVisible(false)
    end

    DataUtils.setReadMsgId(cPropInfo.id)
    CloudData.READ_MSG_TABLE[tostring(cPropInfo.id)] = true

    --当前附件格子序号
    local goodsNo = 1

    --判断是否有goodsInfo里的物品
    for i = 1, 4 do
        local goodsid_ = tonumber(cPropInfo["goods" .. i])
        if goodsid_ > 0 then
            local pic = cPropExl:objectAtIndex(goodsid_)["pic"]
            local num = tonumber(cPropExl:objectAtIndex(goodsid_)["num"])
            local type = cPropExl:objectAtIndex(goodsid_)["goodsType"]
            self.goods[goodsNo]:setTexture(pic)
            self.goods[goodsNo]:setVisible(true)
            self.goods[goodsNo]:setTouchEnabled(true)
            self.append:getChildByTag(goodsNo):setString("x" .. num)
            self.append:getChildByTag(goodsNo):setVisible(true)

            if type == "renshen" then
                self.goods[goodsNo]:setScale(0.9)
            elseif type == "piece" then
                self.goods[goodsNo]:setScale(1.4)
            else
                self.goods[goodsNo]:setScale(1)
            end
            goodsNo = goodsNo + 1
        -- else
        --     self.goods[i]:setVisible(false)
        --     self.append:getChildByTag(i):setVisible(false)
        end
    end

    --判断是否有不定数量的蟠桃
    if cPropInfo.peach ~= nil and tonumber(cPropInfo.peach) > 0 then
        --物品已满
        if goodsNo > 4 then
            return
        end

        local pic = "shop/peach_pic.png"
        local num = tonumber(cPropInfo.peach)        
        self.goods[goodsNo]:setTexture(pic)
        self.goods[goodsNo]:setVisible(true)
        self.goods[goodsNo]:setTouchEnabled(true)
        self.append:getChildByTag(goodsNo):setString("x" .. num)
        self.append:getChildByTag(goodsNo):setVisible(true)
        self.goods[goodsNo]:setScale(0.8)
      
        goodsNo = goodsNo + 1
    end

    --判断是否有不定数量的经验
    if cPropInfo.exp ~= nil and tonumber(cPropInfo.exp) > 0 then
        --物品已满
        if goodsNo > 4 then
            return
        end

        local pic = "win_or_lose/exp.png"
        local num = tonumber(cPropInfo.exp)        
        self.goods[goodsNo]:setTexture(pic)
        self.goods[goodsNo]:setVisible(true)
        self.goods[goodsNo]:setTouchEnabled(true)
        self.append:getChildByTag(goodsNo):setString("x" .. num)
        self.append:getChildByTag(goodsNo):setVisible(true)
        self.goods[goodsNo]:setScale(0.9)
      
        goodsNo = goodsNo + 1
    end

    --判断是否有不定数量的精华石
    if cPropInfo.essence ~= nil and tonumber(cPropInfo.essence) > 0 then
        --物品已满
        if goodsNo > 4 then
            return
        end

        local pic = "upgrade/essence.png"
        local num = tonumber(cPropInfo.essence)        
        self.goods[goodsNo]:setTexture(pic)
        self.goods[goodsNo]:setVisible(true)
        self.goods[goodsNo]:setTouchEnabled(true)
        self.append:getChildByTag(goodsNo):setString("x" .. num)
        self.append:getChildByTag(goodsNo):setVisible(true)
        self.goods[goodsNo]:setScale(1.9)
      
        goodsNo = goodsNo + 1
    end

    if goodsNo == 1 then
        self.append:setVisible(false)
    else
        self.append:setVisible(true)
        self.conButton:setVisible(true)
        for i = goodsNo, 4 do
            self.goods[i]:setVisible(false)
            self.append:getChildByTag(i):setVisible(false)
            self.goods[goodsNo]:setTouchEnabled(false)
        end
    end

    -- if tonumber(cPropInfo.goods1) > 0 then
    --     self.append:setVisible(true)

    --     for i = 1, 4 do
    --         local goodsid_ = tonumber(cPropInfo["goods" .. i])
    --         if goodsid_ > 0 then
    --             local pic = cPropExl:objectAtIndex(goodsid_)["pic"]
    --             local num = tonumber(cPropExl:objectAtIndex(goodsid_)["num"])
    --             local type = cPropExl:objectAtIndex(goodsid_)["goodsType"]
    --             self.goods[i]:setTexture(pic)
    --             self.goods[i]:setVisible(true)
    --             self.append:getChildByTag(i):setString("x" .. num)
    --             self.append:getChildByTag(i):setVisible(true)

    --             if type == "renshen" then
    --                 self.goods[i]:setScale(0.9)
    --             elseif type == "piece" then
    --                 self.goods[i]:setScale(1.4)
    --             else
    --                 self.goods[i]:setScale(1)
    --             end
    --         else
    --             self.goods[i]:setVisible(false)
    --             self.append:getChildByTag(i):setVisible(false)
    --         end
    --     end

    -- else
    --     self.append:setVisible(false)
    -- end
end

function ServerMaintainLayer:confirmCallBack_(index)
    local ac = AlertConnection.new(CONNECTION_GET_SERVER_MAINTAIN_COMPENSATION, self.info_[index].id)
    self:addChild(ac,100,12345)

    self.schedule_ = self:schedule(function()
        if not self:getChildByTag(12345) then
            self:stopAction(self.schedule_)

            self:getCompensation_(index)
        end
    end,0.1)
end

function ServerMaintainLayer:getCompensation_(index)
    print(CloudData.COMPENSATION_GET_STATION)
    if CloudData.COMPENSATION_GET_STATION == nil then
        --配置表
        local cPropExl = DataRetainer.GOODS_INFO

        local cPropInfo = self.info_[index]
        --领取物品序号
        local goodsNo = 1

        --常规物品
        for i = 1, 4 do
            local goodsid_ = tonumber(self.info_[index]["goods" .. i])
            if goodsid_ > 0 then 
                local type = cPropExl:objectAtIndex(goodsid_)["goodsType"]
                local num = tonumber(cPropExl:objectAtIndex(goodsid_)["num"])

                if type == "exp" then
                    CloudData.EXP = CloudData.EXP + num
                elseif type == "buddha" then
                    local id = tonumber(cPropExl:objectAtIndex(goodsid_)["Id"])
                    local buddhaModel = DataUtils.getBuddhaModel(id)
                    if buddhaModel.buddhaState_ == 1 then
                        CloudData.ESSENCE = CloudData.ESSENCE + buddhaModel.essenceValue_
                    else
                        -- 如果新兵种骨骼资源没有，则提示去更新
                        local resDownLoaded = cc.UserDefault:getInstance():getBoolForKey("missed_armature_res_downloaded",false)
                        if not resDownLoaded and table.indexof(GameManager.RES_MISSED_ARMATURE, buddhaModel.hurtFrame_) then
                            local al = AlertUpdate.new(GameManager.URL_MISSED_ARMATURE,5.8,"FORCE",true)
                            self:addChild(al,100)
                            return  
                        end

                        -- 新兵种出现界面
                        local layer = NewFellowLayer.new(buddhaModel)
                        display.getRunningScene():addChild(layer,150)
                        DataUtils.setNewBuddhaCloudData(id)
                    end
                elseif type == "piece" then
                    local id = tonumber(cPropExl:objectAtIndex(goodsid_)["Id"])
                    CloudData.MONSTER_PIECE_INFO[id] = CloudData.MONSTER_PIECE_INFO[id] + num
                elseif type == "item" then
                    local id = tonumber(cPropExl:objectAtIndex(goodsid_)["Id"])
                    CloudData.SKILL_ITEM_INFO[id] = CloudData.SKILL_ITEM_INFO[id] + num

                    --DataEye统计道具使用
                    if USE_DATAEYE then 
                        local name
                        if id == 1 then
                            name = "LJJD"               
                        elseif id == 2 then 
                            name = "JGD"             
                        elseif id == 3 then
                            name = "BJS"             
                        elseif id == 4 then
                            name = "JZZ"              
                        elseif id == 5 then
                            name = "WZF"             
                        else
                            name = "XBL"               
                        end
                        DCItem.get(name, "mail", num, "compensation for server maintain")                                       
                    end

                elseif type == "renshen" then
                    CloudData.GINSENG_FRUIT = CloudData.GINSENG_FRUIT + num
                elseif type == "sweep" then
                    CloudData.SWEEP = CloudData.SWEEP + num
                elseif type == "essence" then
                    CloudData.ESSENCE = CloudData.ESSENCE + num
                end 

                goodsNo = goodsNo + 1
            end      
        end

        --判断是否有不定数量的蟠桃
        if cPropInfo.peach ~= nil and tonumber(cPropInfo.peach) > 0 and goodsNo < 5 then
            local num = tonumber(cPropInfo.peach)
            CloudData.PEACH = CloudData.PEACH + num

            --DataEye统计蟠桃产出
            if USE_DATAEYE then  
                DCCoin.gain("mail", "peach", num, CloudData.PEACH)              
            end
          
            goodsNo = goodsNo + 1
        end

        --判断是否有不定数量的经验
        if cPropInfo.exp ~= nil and tonumber(cPropInfo.exp) > 0 and goodsNo < 5 then
            local num = tonumber(cPropInfo.exp)        
            CloudData.EXP = CloudData.EXP + num
          
            goodsNo = goodsNo + 1
        end

        --判断是否有不定数量的精华石
        if cPropInfo.essence ~= nil and tonumber(cPropInfo.essence) > 0 and goodsNo < 5 then
            local num = tonumber(cPropInfo.essence)        
            CloudData.ESSENCE = CloudData.ESSENCE + num                          
        end
    else
        local tip = WSToast.new(CloudData.COMPENSATION_GET_STATION, 1.0)
        display.getRunningScene():addChild(tip, 20)
    end

    table.remove(self.info_, index)
    self.msgNum = #self.info_
    self.mailLayer:removeSelf()
    self.mailLayer = nil

    self.listView:removeItem(self.mailIconTable_[index], true)
    table.remove(self.mailIconTable_, index)
end

function ServerMaintainLayer:init_()
    self.info_ = CloudData.SERVER_MSG
    dump(self.info_)
    self.msgContext = self.info_.data.msg
    self:initUI2_()
end

--初始化服务器正在维护UI
function ServerMaintainLayer:initUI2_()
    --加载特效文件
    display.addSpriteFrames("animation/maintain_ani.plist","animation/maintain_ani.png")

    --背景
    local bg = display.newSprite("server_maintain/frame1.png")
        :addTo(self.emptyNode_)

    --动画
    local ani = display.newSprite():pos(bg:getContentSize().width * 0.49,bg:getContentSize().height * 0.59):addTo(bg)
    local frames = display.newFrames("maintain_ani%d.png",1,3)
    local animation = display.newAnimation(frames, 0.07)
    ani:playAnimationForever(animation)

    --消息文本
    self.msgText_ = cc.ui.UILabel.new({
        UILabelType = 2,text = self.msgContext,size = 30,color = cc.c3b(100,47,5),align = cc.ui.TEXT_ALIGN_LEFT,dimensions = cc.size(400,80),font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,bg:getContentSize().width * 0.5,bg:getContentSize().height * 0.25)
        :addTo(bg,2)

    --关闭按钮
    cc.ui.UIPushButton.new({normal = "common_ui/close.png",pressed = "common_ui/close_h.png"})
        :scale(0.65)
        :align(display.CENTER,bg:getContentSize().width * 0.94,bg:getContentSize().height * 0.92)
        :onButtonClicked(function()
            self:closeCallBack_()
        end)
        :addTo(bg)
end

function ServerMaintainLayer:closeCallBack_()
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


return ServerMaintainLayer