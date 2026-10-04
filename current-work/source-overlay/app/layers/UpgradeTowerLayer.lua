--
--"宝塔"属性升级界面
--

local DataLabelIcon       = import("icons.DataLabelIcon")
local UpgradePropertyIcon = import("icons.UpgradePropertyIcon")
local AlertConnection     = import("customs.AlertConnection") 
local NoviceGuide         = import("utils.NoviceGuide")

local UpgradeTowerLayer = class("UpgradeTowerLayer", function()
    return display.newScene("UpgradeTowerLayer")
end)

function UpgradeTowerLayer:ctor()
    --播放音效(打开层)
	if GameManager.SOUND_SWITCH_ON then
		audio.playSound(string.format("sounds/sfx_touch_ti.%s",GameManager.POSTFIX))
	end

    --加载宝塔属性数据
    self:initTowerPropertyInfo_()

    --默认选择第一条属性信息
    self.currPropertyModel_ = self.towerPropertyModelTable_[1]
    
    --背景图片
    local bg = display.newSprite("common_ui/uibg.jpg",display.cx,display.cy):addTo(self)

    --精石
    local essenceLabel = DataLabelIcon.new(DataLabelIcon.LABEL_TYPE_ESSENCE,true)
    essenceLabel:setScale(0.75)
    essenceLabel:setPosition(cc.p(bg:getContentSize().width * 0.28,bg:getContentSize().height * 0.95))
    bg:addChild(essenceLabel,15)
    --经验
    local expLabel = DataLabelIcon.new(DataLabelIcon.LABEL_TYPE_EXP,true)
    expLabel:setScale(0.75)
    expLabel:setPosition(cc.p(bg:getContentSize().width * 0.55,bg:getContentSize().height * 0.95))
    bg:addChild(expLabel,15)
    --蟠桃
    local peachLabel = DataLabelIcon.new(DataLabelIcon.LABEL_TYPE_PEACH,true)
    peachLabel:setScale(0.75)
    peachLabel:setPosition(cc.p(bg:getContentSize().width * 0.82,bg:getContentSize().height * 0.95))
    bg:addChild(peachLabel,15)
     --返回按钮
    cc.ui.UIPushButton.new({normal = "common_ui/back.png",pressed = "common_ui/back_h.png"})
        :scale(0.85)
        :align(display.CENTER,bg:getContentSize().width * 0.12 ,bg:getContentSize().height * 0.95)
        :onButtonPressed(function()
            self:performWithDelay(function()
                self:returnCallBack_()
            end,0.1)
        end)
        -- :onButtonClicked(function()
        --     self:returnCallBack_()
        -- end)
        :addTo(bg,15)
	
	self:addAndroidReturnButton_()
	
    --分页按钮：神仙，降妖，宝塔，唐僧
    self.buddhaBtn_ = cc.ui.UIPushButton.new({normal = "upgrade/buddha.png",pressed = "upgrade/buddha.png"})
        :align(display.CENTER,bg:getContentSize().width * 0.11 ,bg:getContentSize().height * 0.74)
        :onButtonClicked(function()
            --UPGRADESCENE.toLayer("UpgradeBuddhaLayer")
            display.replaceScene(require("layers.UpgradeBuddhaLayer").new())
        end)
        :addTo(bg,3)
    self.monsterBtn_ = cc.ui.UIPushButton.new({normal = "upgrade/monster.png",pressed = "upgrade/monster.png"})
        :align(display.CENTER,bg:getContentSize().width * 0.11 ,bg:getContentSize().height * 0.55)
        :onButtonClicked(function()
            --UPGRADESCENE.toLayer("UpgradeMonsterLayer")
            display.replaceScene(require("layers.UpgradeMonsterLayer").new())
        end)
        :addTo(bg,3)
    self.towerBtn_ = cc.ui.UIPushButton.new({normal = "upgrade/tower.png",disabled = "upgrade/tower_h.png"})
        :align(display.CENTER,bg:getContentSize().width * 0.11 ,bg:getContentSize().height * 0.36)
        :onButtonClicked(function()
            --UPGRADESCENE.toLayer("UpgradeTowerLayer")
            display.replaceScene(require("layers.UpgradeTowerLayer").new())
        end)
        :addTo(bg,3)
    self.towerBtn_:setButtonEnabled(false)
    self.tangBtn_ = cc.ui.UIPushButton.new({normal = "upgrade/tang.png",pressed = "upgrade/tang.png"})
        :align(display.CENTER,bg:getContentSize().width * 0.11 ,bg:getContentSize().height * 0.17)
        :onButtonClicked(function()
            --UPGRADESCENE.toLayer("UpgradeTangLayer")
            display.replaceScene(require("layers.UpgradeTangLayer").new())
        end)
        :addTo(bg,3)

    --框架图    
    local frame = display.newSprite("upgrade/upgradebg.png")
    --frame:setAnchorPoint(cc.p(0,0))
    frame:setPosition(cc.p(bg:getContentSize().width * 0.52,bg:getContentSize().height * 0.45))
    bg:addChild(frame,2)

    --右上宝塔图片显示区域
    self.armatureFrame_ = display.newSprite("upgrade/upgradebg1.png",frame:getContentSize().width * 0.706,frame:getContentSize().height * 0.655)
        :addTo(frame,1)

    --右上属性名字显示区域
    local proNameFrame = display.newSprite("upgrade/upgradename.png",frame:getContentSize().width * 0.706,frame:getContentSize().height * 0.93)
        :addTo(frame,2)
    self.proNameLabel_ = cc.ui.UILabel.new({
        UILabelType = 2,text = "",size = 30,color = display.COLOR_WHITE,font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,proNameFrame:getContentSize().width * 0.5,proNameFrame:getContentSize().height * 0.5)
        :addTo(proNameFrame)

    -- 降妖杖或防御塔背景
    self.towerPic_ = display.newSprite("upgrade/tower/tower1.png",self.armatureFrame_:getContentSize().width * 0.5,self.armatureFrame_:getContentSize().height * 0.6)
        :scale(0.8)
        :addTo(self.armatureFrame_)
    -- 升级进度条
    local proBg = display.newSprite("upgrade/pro_bg.png",self.armatureFrame_:getContentSize().width * 0.5,self.armatureFrame_:getContentSize().height * 0.26)
        :addTo(self.armatureFrame_)
    self.proTimer_ = cc.ProgressTimer:create(display.newSprite("upgrade/pro_timer.png")):addTo(proBg)
    self.proTimer_:setType(cc.PROGRESS_TIMER_TYPE_BAR)
    self.proTimer_:setPosition(proBg:getContentSize().width * 0.5,proBg:getContentSize().height * 0.5)
    self.proTimer_:setMidpoint(cc.p(0,0))
    self.proTimer_:setBarChangeRate(cc.p(1,0))
    self.proTimer_:setPercentage(0)
    -- 进度条上的唐僧头像
    self.smallTowerPic1_ = display.newSprite("upgrade/tower/small_tower1.png",0,proBg:getContentSize().height * 0.5):addTo(proBg,1)
    self.smallTowerPic2_ = display.newSprite("upgrade/tower/small_tower2.png",proBg:getContentSize().width * 0.5,proBg:getContentSize().height * 0.5):addTo(proBg,1)
    self.smallTowerPic3_ = display.newSprite("upgrade/tower/small_tower3.png",proBg:getContentSize().width,proBg:getContentSize().height * 0.5):addTo(proBg,1)

    --当前属性
    local currLabel = cc.ui.UILabel.new({
        UILabelType = 2,text = "当前等级:",size = 20,color = cc.c3b(100,47,5),font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,self.armatureFrame_:getContentSize().width * 0.22,self.armatureFrame_:getContentSize().height * 0.1)
        :addTo(self.armatureFrame_)
    self.currPropertyNumLabel_ = cc.ui.UILabel.new({
        UILabelType = 2,text = "0",size = 20,color = display.COLOR_RED,font = GameManager.FONTNAME_TTF})
        :align(display.CENTER_LEFT,currLabel:getPositionX() + currLabel:getContentSize().width * 0.5,self.armatureFrame_:getContentSize().height * 0.1)
        :addTo(self.armatureFrame_)
    --下级属性
    local nextLabel = cc.ui.UILabel.new({
        UILabelType = 2,text = "下一等级:",size = 20,color = cc.c3b(100,47,5),font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,self.armatureFrame_:getContentSize().width * 0.70,self.armatureFrame_:getContentSize().height * 0.1)
        :addTo(self.armatureFrame_)
    self.nextPropertyNumLabel_ = cc.ui.UILabel.new({
        UILabelType = 2,text = "0",size = 20,color = display.COLOR_RED,font = GameManager.FONTNAME_TTF})
        :align(display.CENTER_LEFT,nextLabel:getPositionX() + nextLabel:getContentSize().width * 0.5,self.armatureFrame_:getContentSize().height * 0.1)
        :addTo(self.armatureFrame_)    

    --右下属性信息显示区域
    local dataShowFrame = display.newSprite("upgrade/upgradedescbg.png",frame:getContentSize().width * 0.706,frame:getContentSize().height * 0.20)
        :addTo(frame,2)
    self.proDescLabel_ = cc.ui.UILabel.new({
        UILabelType = 2,text = "",size = 25,color = cc.c3b(100,47,5),align = cc.ui.TEXT_ALIGN_LEFT,dimensions = cc.size(430, 100),font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,dataShowFrame:getContentSize().width * 0.5,dataShowFrame:getContentSize().height * 0.63)
        :addTo(dataShowFrame)
    --self.proDescLabel_:setLayoutSize(430,80)
   
    --升级所需经验标签
    local expPic = display.newSprite("upgrade/exp.png",dataShowFrame:getContentSize().width * 0.10,dataShowFrame:getContentSize().height * 0.25)
        :scale(0.6)
        :addTo(dataShowFrame)
    local expCostFrame = display.newSprite("upgrade/textdi.png",dataShowFrame:getContentSize().width * 0.335,dataShowFrame:getContentSize().height * 0.25)
        :addTo(dataShowFrame)
    self.expCostLabel_ = cc.ui.UILabel.new({
        UILabelType = 1,text = "",font = "fonts/bulefonts.fnt"})
        :align(display.CENTER,expCostFrame:getContentSize().width * 0.5,expCostFrame:getContentSize().height * 0.5)
        :scale(0.8)
        :addTo(expCostFrame)

    --升级按钮
    self.upgradeBtn_ = cc.ui.UIPushButton.new({normal = "upgrade/gradebt.png",pressed = "upgrade/gradebt_h.png",disabled = "upgrade/gradedbt.png"})
        :align(display.CENTER,dataShowFrame:getContentSize().width * 0.77 ,dataShowFrame:getContentSize().height * 0.25)
        :onButtonClicked(function()
            self:upgradeCallBack_()
        end)
        :addTo(dataShowFrame)

    --左边Npc滑动列表
    self.listView = cc.ui.UIListView.new {
        bgColor = cc.c4b(255,255,255,0),
--        viewRect = cc.rect(frame:getContentSize().width * 0.044,frame:getContentSize().height * 0.09,353,530),
        viewRect = cc.rect(display.cx - 438,60,353,530),
        direction = cc.ui.UIScrollView.DIRECTION_VERTICAL}
        :onTouch(handler(self,self.touchListener))
        :addTo(self,1)
    -- add items
    for i=1,#self.towerPropertyModelTable_ do
        local item = self.listView:newItem()
        local propertyModel = self.towerPropertyModelTable_[i]

        --此处记录宝塔属性总等级(防御塔等级不算在内)
        local level = tonumber(propertyModel.level_) 
        if tonumber(propertyModel.id_) ~= 7 then self.countLevel_ = self.countLevel_ + level end
        
        --设置content
        local content = UpgradePropertyIcon.new(propertyModel)
        item:addContent(content)
        item:setItemSize(333,129)
        self.listView:addItem(item)
        table.insert(self.contentTable_,content)
        if i == 1 then
            content:setSelected()
        end
    end
    self.listView:reload()

    --记录右边选中的属性框
    self.currContent_ = self.contentTable_[1]
    --数据信息更改显示
    self:showChangeInfo_(self.currPropertyModel_)

    --第七关的时候引导升级防御塔血量
    if CloudData.STAGE_PROGRESS == 7 and DataUtils.getGuideIsFirstPlayed("GUIDE_STEP_UPGRADE_TOWER1") and 
    not DataUtils.getGuideIsFirstPlayed("GUIDE_STEP_UPGRADE_TOWER2") then     
        local guide = NoviceGuide.new(GUIDE_STEP_UPGRADE_TOWER2)
        self:addChild(guide,50)
        DataUtils.setGuideIsFirstPlayed("GUIDE_STEP_UPGRADE_TOWER2",true)
    end
end

function UpgradeTowerLayer:initTowerPropertyInfo_()
    --存储宝塔属性Table
    --self.towerPropertyModelTable_ = DataUtils.getTableUpgradePropertyModel("TOWER")
    self.towerPropertyModelTable_ = GameManager.TOWER_MODEL_TABLE 
    
    --存储ListView的content
    self.contentTable_ = {}

    --宝塔属性总等级
    self.countLevel_ = 0
    -- for i=1,4 do
    --     local towerPropertyModel = self.towerPropertyModelTable_[i]
    --     local towerLevel = tonumber(towerPropertyModel.level_)
    --     self.countLevel_ = self.countLevel_ + towerLevel
    --     print("countLevel_ = "..self.countLevel_)
    -- end
end

--数据信息更改显示  
function UpgradeTowerLayer:showChangeInfo_(propertyModel)
    --兵种信息解析
    local propertyName  = propertyModel.cnName_
    local propertyLevel = tonumber(propertyModel.level_)
    local propertyDesc  = propertyModel.desc_
    local expCostNum    = tonumber(propertyModel.expCost_)
    local paramCurr     = tonumber(propertyModel.paramCurr_)
    local paramNext     = tonumber(propertyModel.paramNext_)

    --数据显示
    self.proNameLabel_:setString(propertyName)
    self.expCostLabel_:setString(expCostNum)
    self.proDescLabel_:setString(propertyDesc)
   
    --属性数值
    self.currPropertyNumLabel_:setString(paramCurr)
    self.nextPropertyNumLabel_:setString(paramNext)

    --按钮显示
    if propertyLevel < 20 then
        if CloudData.EXP < expCostNum then          --不可升级
            self.upgradeBtn_:setButtonEnabled(false)
        else
            self.upgradeBtn_:setButtonEnabled(true)
        end
    else                                            --显示已满级,不再升级
        self.upgradeBtn_:setButtonEnabled(false)
    end
    
    --根据属性总等级更换降妖杖或宝塔图片
    if tonumber(propertyModel.id_) == 7 then            -- 宝塔
        local progressValue = propertyLevel / 20 * 100
        self.proTimer_:setPercentage(progressValue)
        if propertyLevel > 0 and propertyLevel < 10 then
            self.towerPic_:setTexture("upgrade/tower/tower1.png")
            self.smallTowerPic1_:setTexture("upgrade/tower/small_tower1_h.png")
            self.smallTowerPic2_:setTexture("upgrade/tower/small_tower2.png")
            self.smallTowerPic3_:setTexture("upgrade/tower/small_tower3.png")
        elseif propertyLevel >= 10 and propertyLevel < 20 then
            self.towerPic_:setTexture("upgrade/tower/tower2.png")
            self.smallTowerPic1_:setTexture("upgrade/tower/small_tower1_h.png")
            self.smallTowerPic2_:setTexture("upgrade/tower/small_tower2_h.png")
            self.smallTowerPic3_:setTexture("upgrade/tower/small_tower3.png")
        else
            self.towerPic_:setTexture("upgrade/tower/tower3.png")
            self.smallTowerPic1_:setTexture("upgrade/tower/small_tower1_h.png")
            self.smallTowerPic2_:setTexture("upgrade/tower/small_tower2_h.png")
            self.smallTowerPic3_:setTexture("upgrade/tower/small_tower3_h.png")
        end
    else                                               -- 降妖杖
        local progressValue = self.countLevel_ / 55 * 100
        self.proTimer_:setPercentage(progressValue)
        if self.countLevel_ > 0 and self.countLevel_ < 30 then
            self.towerPic_:setTexture("upgrade/wand/wand1.png")
            self.smallTowerPic1_:setTexture("upgrade/wand/small_wand1_h.png")
            self.smallTowerPic2_:setTexture("upgrade/wand/small_wand2.png")
            self.smallTowerPic3_:setTexture("upgrade/wand/small_wand3.png")
        elseif self.countLevel_ >= 30 and self.countLevel_ < 55 then
            self.towerPic_:setTexture("upgrade/wand/wand2.png")
            self.smallTowerPic1_:setTexture("upgrade/wand/small_wand1_h.png")
            self.smallTowerPic2_:setTexture("upgrade/wand/small_wand2_h.png")
            self.smallTowerPic3_:setTexture("upgrade/wand/small_wand3.png")
        else
            self.towerPic_:setTexture("upgrade/wand/wand3.png")
            self.smallTowerPic1_:setTexture("upgrade/wand/small_wand1_h.png")
            self.smallTowerPic2_:setTexture("upgrade/wand/small_wand2_h.png")
            self.smallTowerPic3_:setTexture("upgrade/wand/small_wand3_h.png")
        end
    end
    
    --当前属性等级更新
    self.currContent_:showLevel(propertyModel)

    --记录当前选中的兵种model
    self.currPropertyModel_ = propertyModel
end

--升级宝塔属性属性
function UpgradeTowerLayer:upgradeCallBack_()
    local propertyId     = tonumber(self.currPropertyModel_.id_)
    local ac = AlertConnection.new(CONNECTION_UPGRADE_PROPERTY,propertyId)
    self:addChild(ac,100,12345)

    --网络监测0.1s
    self.scheduleUpgrade_ = self:schedule(function() 
        if not self:getChildByTag(12345) then
            self:stopAction(self.scheduleUpgrade_)
            --升级特效
            self:upgradeAnimation_()

            --数据更新
            local costExp = self.currPropertyModel_.expCost_
            CloudData.EXP = CloudData.EXP - costExp
            -- 降妖杖的总等级 (7为防御塔)
            if tonumber(self.currPropertyModel_.id_) ~= 7 then self.countLevel_ = self.countLevel_ + 1 end   
            -- 当前属性等级
            self.currPropertyModel_.level_ = self.currPropertyModel_.level_ + 1
            DataUtils.setPropertyLevel(propertyId,self.currPropertyModel_.level_)

            --重新获取model
            local propertyModel_ = DataUtils.getUpgradePropertyModel(propertyId)
            --更新table
            local index = table.indexof(self.towerPropertyModelTable_,self.currPropertyModel_)
            if index then
                self.towerPropertyModelTable_[index] = propertyModel_
            end
            --界面显示更新
            self:showChangeInfo_(propertyModel_)
        end
    end,0.1) 
end

--升级特效
function UpgradeTowerLayer:upgradeAnimation_()
	if GameManager.SOUND_SWITCH_ON then
		audio.playSound(string.format("sounds/sfx_upgrade.%s",GameManager.POSTFIX))
	end
    
    --加载升级特效
    display.addSpriteFrames("animation/upgrade_tx.plist","animation/upgrade_tx.png")

    if self.armatureFrame_:getChildByTag(100) then
        self.armatureFrame_:removeChildByTag(100,true)
    end
    local frames = display.newFrames("upgrade_tx%d.png",1,22)
    local animation = display.newAnimation(frames, 0.1)
    local emptyPic = display.newSprite()
        :pos(self.armatureFrame_:getContentSize().width * 0.5,self.armatureFrame_:getContentSize().height * 0.45)
        :scale(1.5)
        :addTo(self.armatureFrame_,3,100)
    emptyPic:playAnimationOnce(animation,true)
end

function UpgradeTowerLayer:touchListener(event)
    local lv = event.listView
    if "clicked" == event.name then
        -- local content = event.item:getContent()
        -- content:setSelected()
        for i=1,#self.contentTable_ do
            local propertyModel = self.towerPropertyModelTable_[i]
            local content = self.contentTable_[i]
            if i == event.itemPos then
                self.currContent_ = content
                content:setSelected()
                self:showChangeInfo_(propertyModel)
                --若有升级特效,则移除
                if self.armatureFrame_:getChildByTag(100) then
                   self.armatureFrame_:removeChildByTag(100,true)
                end
            else
                content:setNormal() 
            end
        end
    elseif "moved" == event.name then
       
    elseif "ended" == event.name then
        
    else
        --print("event name:" .. event.name)
    end
end

function UpgradeTowerLayer:returnCallBack_()
	if GameManager.SOUND_SWITCH_ON then
		audio.playSound(string.format("sounds/sfx_touch_shu.%s",GameManager.POSTFIX))
	end
    
    display.replaceScene(require("scenes.ChapterScene").new())
end

function UpgradeTowerLayer:addAndroidReturnButton_()
	--退出游戏
    local btn = cc.ui.UIPushButton.new():addTo(self)
		btn:setKeypadEnabled(true)
        btn:addNodeEventListener(cc.KEYPAD_EVENT, function (event)
            if event.key == "back" then
				self:showReturnWarning_()
			end
		end)
end

function UpgradeTowerLayer:showReturnWarning_()
	if self.returnMask ~= nil then
        return
    end
    self.returnMask = display.newColorLayer(cc.c4b(0,0,0,150))
    self:addChild(self.returnMask,20000)
    
    local bg = display.newSprite("common_ui/common_bg.png"):pos(display.cx, display.cy):addTo(self.returnMask,1)
    cc.ui.UILabel.new({
        text = "确定退出？" ,size = 32,color = display.COLOR_BLACK,font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,bg:getContentSize().width * 0.5,bg:getContentSize().height * 0.57)
        :addTo(bg)
        
    --确定按钮
    cc.ui.UIPushButton.new({normal = "common_ui/confirm.png",pressed = "common_ui/confirm_h.png"})
        :align(display.CENTER,bg:getContentSize().width * 0.5,bg:getContentSize().height * 0.22)
        :onButtonClicked(function()
            if PaymentInfo.CHANNEL == 3 then
                --酷狗SDK退出 luaJ桥接
                local javaClassName = "org/cocos2dx/lua/AppActivity"
                local javaMethodName = "exitKugou"
                local javaParams = {}
                local javaMethodSig = "()V"
                luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
            elseif PaymentInfo.CHANNEL == 4 then
                --UC SDK退出 luaJ桥接
                local javaClassName = "org/cocos2dx/lua/AppActivity"
                local javaMethodName = "exitUC"
                local javaParams = {}
                local javaMethodSig = "()V"
                luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
            elseif BAIDU_PROMOTION then
                --Baidu SDK退出 luaJ桥接
                local javaClassName = "org/cocos2dx/lua/AppActivity"
                local javaMethodName = "exitBaidu"
                local javaParams = {}
                local javaMethodSig = "()V"
                luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
            else
                cc.Director:getInstance():endToLua()
                if device.platform == "windows" or device.platform == "mac" then
                    os.exit()
                end
            end
        end)
        :addTo(bg,2)

    --关闭按钮
    cc.ui.UIPushButton.new({normal = "common_ui/close.png",pressed = "common_ui/close_h.png"})
        :align(display.CENTER,bg:getContentSize().width * 0.95,bg:getContentSize().height * 0.95)
        :onButtonClicked(function()
            self.returnMask:removeSelf()
            self.returnMask = nil
        end)
        :scale(0.8)
        :addTo(bg,2)
end

function UpgradeTowerLayer:onEnter()
end

function UpgradeTowerLayer:onExit()
    self:removeAllChildren()
    display.removeUnusedSpriteFrames()
end

return UpgradeTowerLayer
