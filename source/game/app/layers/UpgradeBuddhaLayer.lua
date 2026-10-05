--
--兵种升级界面（兵种升级，突破，防御塔、唐僧属性升级）
--
local Buddha = import("sprites.Buddha")
local DataLabelIcon     = import("icons.DataLabelIcon")
local UpgradeBuddhaIcon = import("icons.UpgradeBuddhaIcon")
local NoviceGuide       = import("utils.NoviceGuide")
local AlertConnection   = import("customs.AlertConnection")
local BuddhaEvolution   = import("layers.BuddhaEvolution")
local AlertUpdate       = import("customs.AlertUpdate")

local UpgradeBuddhaLayer = {}
UpgradeBuddhaLayer = class("UpgradeBuddhaLayer", function()
    return display.newScene("UpgradeBuddhaLayer")
end)

function UpgradeBuddhaLayer:ctor()
    --此时已查看新兵种信息,置为false
    GameManager.IS_HAVE_NEW_BUDDHA   = false

    --播放音效(打开层)
    if GameManager.SOUND_SWITCH_ON then
        audio.playSound(string.format("sounds/sfx_touch_ti.%s",GameManager.POSTFIX))
    end

    --加载神仙数据
    self:initBuddhaInfo_()

    --默认选择第一个兵种信息
    self.currBuddhaModel_ = self.buddhaModelTable_[1]

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
        --     self:performWithDelay(function()
        --         self:returnCallBack_()
        --     end,0.1)
        -- end)
        :addTo(bg,15)

    self:addAndroidReturnButton_()

    --分页按钮：神仙，降妖，宝塔，唐僧
    self.buddhaBtn_ = cc.ui.UIPushButton.new({normal = "upgrade/buddha.png",disabled = "upgrade/buddha_h.png"})
        :align(display.CENTER,bg:getContentSize().width * 0.11 ,bg:getContentSize().height * 0.74)
        :onButtonClicked(function()
            --UPGRADESCENE.toLayer("UpgradeBuddhaLayer")
            display.replaceScene(require("layers.UpgradeBuddhaLayer").new())
        end)
        :addTo(bg,3)
    self.buddhaBtn_:setButtonEnabled(false)
    self.monsterBtn_ = cc.ui.UIPushButton.new({normal = "upgrade/monster.png",pressed = "upgrade/monster.png"})
        :align(display.CENTER,bg:getContentSize().width * 0.11 ,bg:getContentSize().height * 0.55)
        :onButtonClicked(function()
            --UPGRADESCENE.toLayer("UpgradeMonsterLayer")
            display.replaceScene(require("layers.UpgradeMonsterLayer").new())
        end)
        :addTo(bg,3)
    self.towerBtn_ = cc.ui.UIPushButton.new({normal = "upgrade/tower.png",pressed = "upgrade/tower.png"})
        :align(display.CENTER,bg:getContentSize().width * 0.11 ,bg:getContentSize().height * 0.36)
        :onButtonClicked(function()
            --UPGRADESCENE.toLayer("UpgradeTowerLayer")
            display.replaceScene(require("layers.UpgradeTowerLayer").new())
        end)
        :addTo(bg,3)
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

    --更新提示
    self.updateFrame_ = display.newSprite("upgrade/update_bg.png",frame:getContentSize().width * 0.706,frame:getContentSize().height * 0.655)
        :hide()
        :addTo(frame,1)
    --更新按钮
    cc.ui.UIPushButton.new({normal = "update/right_now.png",pressed = "update/right_now1.png"})
        :align(display.CENTER,self.updateFrame_:getContentSize().width * 0.5 ,self.updateFrame_:getContentSize().height * 0.45)
        :onButtonClicked(function()
            local al = AlertUpdate.new(GameManager.URL_MISSED_ARMATURE,5.8,false,true)
            self:addChild(al,100)
        end)
        :addTo(self.updateFrame_,1)


    --右上展示骨骼动画区域
    self.armatureFrame_ = display.newSprite("upgrade/upgradebg1.png",frame:getContentSize().width * 0.706,frame:getContentSize().height * 0.655)
        :hide()
        :addTo(frame,2)

    --右上Npc名字显示区域
    -- local npcNameFrame = display.newSprite("upgrade/upgradename.png",frame:getContentSize().width * 0.706,frame:getContentSize().height * 0.93)
    --     :addTo(frame,2)
    local npcNameFrame = display.newSprite("upgrade/upgradename.png",
        self.armatureFrame_:getContentSize().width * 0.5,self.armatureFrame_:getContentSize().height * 0.95)
        :addTo(self.armatureFrame_)
    self.npcNameLabel_ = cc.ui.UILabel.new({
        UILabelType = 2,text = "",size = 30,color = display.COLOR_WHITE,font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,npcNameFrame:getContentSize().width * 0.5,npcNameFrame:getContentSize().height * 0.5)
        :addTo(npcNameFrame)

    --兵种属性标签(扛得住,打得远,跑得快...)
    self.tag1_ = display.newSprite("buddha_tag/1.png",self.armatureFrame_:getContentSize().width * 0.85,self.armatureFrame_:getContentSize().height * 0.8)
        :addTo(self.armatureFrame_)
    self.tag2_ = display.newSprite("buddha_tag/2.png",self.armatureFrame_:getContentSize().width * 0.85,self.armatureFrame_:getContentSize().height * 0.65)
        :addTo(self.armatureFrame_)
    self.tag3_ = display.newSprite("buddha_tag/3.png",self.armatureFrame_:getContentSize().width * 0.85,self.armatureFrame_:getContentSize().height * 0.5)
        :addTo(self.armatureFrame_)

    --兵种属性按钮
    cc.ui.UIPushButton.new({normal = "upgrade/details.png",pressed = "upgrade/details1.png"})
        :onButtonPressed(function(event)
            self:showBuddhaProTip()
        end)
        :onButtonRelease(function(event)
            self.mProTip:removeSelf()
            self.mProTip = nil
        end)  
        :scale(1.5)      
        :align(display.CENTER,self.armatureFrame_:getContentSize().width * 0.82,self.armatureFrame_:getContentSize().height * 0.13)
        :addTo(self.armatureFrame_, 3)

    --右下Npc升级数据信息显示区域
    local dataShowFrame = display.newSprite("upgrade/upgradedescbg.png",frame:getContentSize().width * 0.706,frame:getContentSize().height * 0.20)
        :addTo(frame,2)
    --血量标签
    local bloodFrame = display.newSprite("upgrade/blooddi.png",dataShowFrame:getContentSize().width * 0.25,dataShowFrame:getContentSize().height * 0.75)
        :addTo(dataShowFrame)
    self.npcBloodLabel_ = cc.ui.UILabel.new({
        UILabelType = 2,text = "",size = 25,color = display.COLOR_WHITE,font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,bloodFrame:getContentSize().width * 0.55,bloodFrame:getContentSize().height * 0.5)
        :addTo(bloodFrame)
    self.npcBloodAddLabel_ = cc.ui.UILabel.new({
        UILabelType = 2,text = "+0",size = 25,color = display.COLOR_GREEN,font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,bloodFrame:getContentSize().width * 0.55,bloodFrame:getContentSize().height * 0.5)
        :addTo(bloodFrame)
    self.npcBloodAddLabel_:setAnchorPoint(cc.p(0,0.5))
    --攻击力标签
    local attackFrame = display.newSprite("upgrade/attackdi.png",dataShowFrame:getContentSize().width * 0.75,dataShowFrame:getContentSize().height * 0.75)
        :addTo(dataShowFrame)
    self.npcAttackLabel_ = cc.ui.UILabel.new({
        UILabelType = 2,text = "",size = 25,color = display.COLOR_WHITE,font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,attackFrame:getContentSize().width * 0.55,attackFrame:getContentSize().height * 0.5)
        :addTo(attackFrame)
    self.npcAttackAddLabel_ = cc.ui.UILabel.new({
        UILabelType = 2,text = "+0",size = 25,color = display.COLOR_GREEN,font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,attackFrame:getContentSize().width * 0.55,attackFrame:getContentSize().height * 0.5)
        :addTo(attackFrame)
    self.npcAttackAddLabel_:setAnchorPoint(cc.p(0,0.5))
    --升级所需经验标签
    self.costPic_ = display.newSprite("upgrade/exp.png",dataShowFrame:getContentSize().width * 0.10,dataShowFrame:getContentSize().height * 0.25)
        :scale(0.6)
        :addTo(dataShowFrame)
    local expCostFrame = display.newSprite("upgrade/textdi.png",dataShowFrame:getContentSize().width * 0.335,dataShowFrame:getContentSize().height * 0.25)
        :addTo(dataShowFrame)
    self.costLabel_ = cc.ui.UILabel.new({
        UILabelType = 1,text = "",font = "fonts/bulefonts.fnt"})
        :align(display.CENTER,expCostFrame:getContentSize().width * 0.5,expCostFrame:getContentSize().height * 0.5)
        :scale(0.8)
        :addTo(expCostFrame)

    --升级按钮
    self.upgradeBtn_ = cc.ui.UIPushButton.new({normal = "upgrade/gradebt.png",pressed = "upgrade/gradebt_h.png",disabled = "upgrade/gradedbt.png"})
        :align(display.CENTER,dataShowFrame:getContentSize().width * 0.77 ,dataShowFrame:getContentSize().height * 0.30)
        :onButtonClicked(function()
            self:upgradeCallBack_()
        end)
        :addTo(dataShowFrame)
    --召唤按钮
    self.summonBtn_ = cc.ui.UIPushButton.new({normal = "upgrade/zhaohuan.png",pressed = "upgrade/zhaohuan_h.png"})
        :align(display.CENTER,dataShowFrame:getContentSize().width * 0.77 ,dataShowFrame:getContentSize().height * 0.30)
        :onButtonClicked(function()
            self:summonCallBack_()
        end)
        :hide()
        :addTo(dataShowFrame)
    --突破按钮
    self.addtionalBtn_ = cc.ui.UIPushButton.new({normal = "upgrade/tupo.png",pressed = "upgrade/tupo_h.png",disabled = "upgrade/tupo1.png"})
        :align(display.CENTER,dataShowFrame:getContentSize().width * 0.77 ,dataShowFrame:getContentSize().height * 0.30)
        :onButtonClicked(function()
            self:addtionalLevelCallBack_()
        end)
        :hide()
        :addTo(dataShowFrame)

    --左边Npc滑动列表
    self.listView = cc.ui.UIListView.new {
        bgColor = cc.c4b(255,255,255,0),
        --viewRect = cc.rect(frame:getContentSize().width * 0.044,frame:getContentSize().height * 0.096,353,530),
        viewRect = cc.rect(frame:getContentSize().width * 0.044,60,353,530),
        direction = cc.ui.UIScrollView.DIRECTION_VERTICAL}
        :onTouch(handler(self,self.touchListener))
        :addTo(frame,1)
    -- add items
    for i=1,#self.buddhaModelTable_ do
        local item = self.listView:newItem()
        local buddhaModel = self.buddhaModelTable_[i]
        local content = UpgradeBuddhaIcon.new(buddhaModel)
        item:addContent(content)
        item:setItemSize(333,129)
        self.listView:addItem(item)
        table.insert(self.contentTable_,content)
        if i == 1 then
            content:setSelected()
        end
    end
    self.listView:reload()
    
--    local total = #self.buddhaModelTable_
--    local currIdx = 6
--    
--    -- 延迟添加item
--    local function addItem()
--        local item = self.listView:newItem()
--        local buddhaModel = self.buddhaModelTable_[currIdx]
--        local content = UpgradeBuddhaIcon.new(buddhaModel)
--        item:addContent(content)
--        item:setItemSize(333,129)
--        self.listView:addItem(item)
--        table.insert(self.contentTable_,content)
--        currIdx = currIdx +1
--        
--        if(currIdx<=total) then
--            self:runAction(cc.Sequence:create(cc.DelayTime:create(0.01), cc.CallFunc:create(addItem)))
--        else
--            self.listView:reload()
--        end
--    end
--    
--    -- 开始延迟加载
--    addItem()
    
    

    --记录右边选中的兵种框
    self.currContent_ = self.contentTable_[1]
    --数据信息更改显示
    self:showChangeInfo_(self.currBuddhaModel_)

    --第二关的时候引导升级
    if CloudData.STAGE_PROGRESS == 2 and not DataUtils.getGuideIsFirstPlayed("GUIDE_STEP_UPGRADE_BUDDHA") then
        local guide = NoviceGuide.new(GUIDE_STEP_UPGRADE_BUDDHA)
        self:addChild(guide,50)
        DataUtils.setGuideIsFirstPlayed("GUIDE_STEP_UPGRADE_BUDDHA",true)
    end

    --第六关的时候引导召唤悍匪挫山雕
    if CloudData.STAGE_PROGRESS == 6 and DataUtils.getGuideIsFirstPlayed("GUIDE_STEP_UNLOCK_MONSTER1") and
        not DataUtils.getGuideIsFirstPlayed("GUIDE_STEP_UNLOCK_MONSTER2") then
        local guide = NoviceGuide.new(GUIDE_STEP_UNLOCK_MONSTER2)
        self:addChild(guide,50)
        DataUtils.setGuideIsFirstPlayed("GUIDE_STEP_UNLOCK_MONSTER2",true)
    end

    --第七关的时候引导升级防御塔
    if CloudData.STAGE_PROGRESS == 7 and DataUtils.getGuideIsFirstPlayed("to_upgrade_tower") and
        not DataUtils.getGuideIsFirstPlayed("GUIDE_STEP_UPGRADE_TOWER1") then
        local guide = NoviceGuide.new(GUIDE_STEP_UPGRADE_TOWER1)
        self:addChild(guide,50)
        DataUtils.setGuideIsFirstPlayed("GUIDE_STEP_UPGRADE_TOWER1",true)
    end

    --第九关的时候引导升级唐僧属性
    if CloudData.STAGE_PROGRESS == 9 and DataUtils.getGuideIsFirstPlayed("to_upgrade_tang") and
        not DataUtils.getGuideIsFirstPlayed("GUIDE_STEP_UPGRADE_TANG1") then
        local guide = NoviceGuide.new(GUIDE_STEP_UPGRADE_TANG1)
        self:addChild(guide,50)
        DataUtils.setGuideIsFirstPlayed("GUIDE_STEP_UPGRADE_TANG1",true)
    end
end

function UpgradeBuddhaLayer:showBuddhaProTip()
    if self.mProTip then 
        self.mProTip:removeSelf()
        self.mProTip = nil
    end

    --显示兵种攻击速度等属性
    self.mProTip = display.newSprite("upgrade/property_tip.png")
        :align(display.CENTER,self.armatureFrame_:getContentSize().width * 0.5,self.armatureFrame_:getContentSize().height * 0.33)
        :addTo(self.armatureFrame_, 2)

    local ackFrequencyB = self.currBuddhaModel_.attackFrequencyB_
    local ackDistance   = self.currBuddhaModel_.attackDistance_
    local cdTime      = self.currBuddhaModel_.basicCdTime_
    local ackSpeedB     = self.currBuddhaModel_.runSpeed_
    
    cc.ui.UILabel.new({text = ackFrequencyB .. "s",size = 22,color = display.COLOR_WHITE,font = GameManager.FONTNAME_TTF})
        :align(display.CENTER_LEFT,self.mProTip:getContentSize().width * 0.31,self.mProTip:getContentSize().height * 0.75)
        :addTo(self.mProTip)

    cc.ui.UILabel.new({text = ackDistance,size = 22,color = display.COLOR_WHITE,font = GameManager.FONTNAME_TTF})
        :align(display.CENTER_LEFT,self.mProTip:getContentSize().width * 0.7,self.mProTip:getContentSize().height * 0.75)
        :addTo(self.mProTip)

    cc.ui.UILabel.new({text = cdTime .. "s",size = 22,color = display.COLOR_WHITE,font = GameManager.FONTNAME_TTF})
        :align(display.CENTER_LEFT,self.mProTip:getContentSize().width * 0.31,self.mProTip:getContentSize().height * 0.39)
        :addTo(self.mProTip)

    cc.ui.UILabel.new({text = ackSpeedB,size = 22,color = display.COLOR_WHITE,font = GameManager.FONTNAME_TTF})
        :align(display.CENTER_LEFT,self.mProTip:getContentSize().width * 0.7,self.mProTip:getContentSize().height * 0.39)
        :addTo(self.mProTip)
end

--初始化兵种信息
function UpgradeBuddhaLayer:initBuddhaInfo_()

    --存储兵种Table
    --self.buddhaModelTable_ = DataUtils.getBuddhaModelsTableUpgradeScene("BUDDHA")
    self.buddhaModelTable_ = GameManager.BUDDHA_MODEL_TABLE

    --存储ListView的content
    self.contentTable_ = {}
end

--数据信息更改显示
function UpgradeBuddhaLayer:showChangeInfo_(buddhaModel)
    --兵种信息解析
    local buddhaName   = buddhaModel.name_
    local buddhaLevel  = buddhaModel.level_
    local buddhaBlood   = tonumber(buddhaModel.lifeParamK_ * buddhaModel.level_ + buddhaModel.lifeParamB_
        + buddhaModel.addLevel_ * buddhaModel.lifeParamKAdd_  + buddhaModel.lifeParamBAdd_)
    local buddhaAttack = tonumber(buddhaModel.attackParamK_ * buddhaModel.level_ + buddhaModel.attackParamB_
        + buddhaModel.addLevel_ * buddhaModel.attackParamKAdd_ + buddhaModel.attackParamBAdd_)

    --数据显示
    self.npcNameLabel_:setString(buddhaName)
    self.npcBloodLabel_:setString(buddhaBlood)
    self.npcAttackLabel_:setString(buddhaAttack)
    if buddhaLevel < 20 then
        self.npcBloodAddLabel_:setString(string.format("+"..buddhaModel.lifeParamK_))
        self.npcAttackAddLabel_:setString(string.format("+"..buddhaModel.attackParamK_))
    else
        self.npcBloodAddLabel_:setString(string.format("+"..buddhaModel.lifeParamKAdd_))
        self.npcAttackAddLabel_:setString(string.format("+"..buddhaModel.attackParamKAdd_))
    end
    self.npcBloodAddLabel_:setPositionX(self.npcBloodLabel_:getPositionX() + self.npcBloodLabel_:getContentSize().width * 0.52)
    self.npcAttackAddLabel_:setPositionX(self.npcAttackLabel_:getPositionX() + self.npcAttackLabel_:getContentSize().width * 0.52)


    --属性标签更新
    self.tag1_:setTexture(string.format("buddha_tag/"..buddhaModel.tag1_..".png"))
    self.tag2_:setTexture(string.format("buddha_tag/"..buddhaModel.tag2_..".png"))
    self.tag3_:setTexture(string.format("buddha_tag/"..buddhaModel.tag3_..".png"))

    --兵种等级更新
    self.currContent_:showLevel(buddhaModel)

    --若本地没有骨骼动画,则提示去下载
    local resDownLoaded = cc.UserDefault:getInstance():getBoolForKey("missed_armature_res_downloaded",false)
    if not resDownLoaded and table.indexof(GameManager.RES_MISSED_ARMATURE, buddhaModel.hurtFrame_) then
        self.armatureFrame_:hide()
        self.updateFrame_:show()
    else
        self.armatureFrame_:show()
        self.updateFrame_:hide()

        --骨骼更新
        if self.armature_ ~= nil then
            self.armature_:removeSelf()
            --释放上一个骨骼的资源
            for k,v in pairs(ccs.ArmatureDataManager:getInstance():getArmatureDatas()) do
                ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(string.format("armature/%s/%s.csb",k,k))
            end
            display.removeUnusedSpriteFrames()
        end

        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(string.format("armature/%s/%s.csb",
            buddhaModel.hurtFrame_,buddhaModel.hurtFrame_))
        self.armature_ = ccs.Armature:create(buddhaModel.hurtFrame_)
        self.armature_:setPosition(self.armatureFrame_:getContentSize().width * 0.5,self.armatureFrame_:getContentSize().height * 0.2 + buddhaModel.upMove_)
        self.armature_:setScale(buddhaModel.adaptScale_)
        self.armatureFrame_:addChild(self.armature_,1)
        local popuplayer = transition.sequence(
            {	cc.CallFunc:create(function()
                self.armature_:getAnimation():playWithIndex(1)
            end),
            cc.DelayTime:create(1.3),
            cc.CallFunc:create(function()
                self.armature_:getAnimation():playWithIndex(2)
            end),
            cc.DelayTime:create(buddhaModel.attackTime_ * 1.3)
            })
        self.armature_:runAction(cc.RepeatForever:create(popuplayer))
    end

    --按钮变换
    if buddhaModel.buddhaState_ ~= 1 then         --此时显示为召唤按钮
        self.summonBtn_:show()
        self.upgradeBtn_:hide()
        self.addtionalBtn_:hide()
    else
        if buddhaModel.level_ < 20 then           --此时显示为升级按钮
            self.summonBtn_:hide()
            self.upgradeBtn_:show()
            self.addtionalBtn_:hide()
            local expCostNum = tonumber(buddhaModel.expCost_)
            if CloudData.EXP < expCostNum then
                self.upgradeBtn_:setButtonEnabled(false)
            else
                self.upgradeBtn_:setButtonEnabled(true)
            end

            --升级消耗的经验图标
            self.costPic_:setTexture("upgrade/exp.png")
            self.costPic_:setScale(0.6)
            self.costLabel_:setString(expCostNum)
        else                                       --此时显示为突破按钮
            self.summonBtn_:hide()
            self.upgradeBtn_:hide()
            self.addtionalBtn_:show()
            local costEssence = buddhaModel.essenceCost_
            if CloudData.ESSENCE < costEssence then
                self.addtionalBtn_:setButtonEnabled(false)
            else
                self.addtionalBtn_:setButtonEnabled(true)
            end

            --突破消耗的精华图标
            self.costPic_:setTexture("upgrade/essence.png")
            self.costPic_:setScale(1.0)
            self.costLabel_:setString(costEssence)
        end

    end

    --记录当前选中的兵种model
    self.currBuddhaModel_ = buddhaModel
end

--升级兵种
function UpgradeBuddhaLayer:upgradeCallBack_()
    local currlevel = tonumber(self.currBuddhaModel_.level_)
    local npcId     = tonumber(self.currBuddhaModel_.npcId_)
    if currlevel < 20 then
        self.upgradeBtn_:setButtonEnabled(false)
        local currExp = CloudData.EXP
        local costExp = self.currBuddhaModel_.expCost_
        if currlevel == 9 then
            local advancedBuddhaId = tonumber(self.currBuddhaModel_.advancedGuardID_)
            local ac = AlertConnection.new(CONNECTION_NPC_EVOLUTION,npcId)
            self:addChild(ac,100,12345)

            --网络监测0.1s
            self.scheduleUpgrade_ = self:schedule(function()
                if not self:getChildByTag(12345) then
                    self:stopAction(self.scheduleUpgrade_)
                    --数据更新
                    CloudData.EXP = CloudData.EXP - costExp
                    CloudData.NPC_INFO[npcId].level    = CloudData.NPC_INFO[npcId].level + 1
                    CloudData.NPC_INFO[npcId].isActive = 0
                    if DataUtils.markResourceMutation ~= nil then
                        DataUtils.markResourceMutation("buddha-evolution")
                    end
                    --CloudData create advanced buddha & active
                    --兵种状态更新(变为高级形态)
                    DataUtils.setNewAdvancedBuddhaCloudData( advancedBuddhaId )

                    --判断队伍界面低级兵种是否上阵,更换形态
                    local team = DataUtils.getBuddhaTableOnTeam()
                    --dump(team)
                    local index = table.indexof(team,""..npcId)
                    if index then
                        team[index] = ""..advancedBuddhaId
                        DataUtils.setBuddhaTableOnTeam(team)
                    end
                    --dump(team)

                    -- --重新获取model
                    -- local buddhaModel_ = DataUtils.getBuddhaModel(npcId)
                    -- --更新table
                    -- local index = table.indexof(self.buddhaModelTable_,self.currBuddhaModel_)
                    -- if index then
                    --     self.buddhaModelTable_[index] = buddhaModel_
                    -- end
                    -- --界面显示更新
                    -- self:showChangeInfo_(buddhaModel_)
                    -- --变身特效
                    -- self:evolutionAnimation_(buddhaModel_)

                    --播放音效
                    if GameManager.SOUND_SWITCH_ON then
                        audio.playSound(string.format("sounds/sfx_advanced.%s",GameManager.POSTFIX))
                    end

                    --重新获取model
                    local buddhaModel_ = DataUtils.getBuddhaModel(advancedBuddhaId)
                    --更新table
                    local index = table.indexof(self.buddhaModelTable_,self.currBuddhaModel_)
                    if index then
                        self.buddhaModelTable_[index] = buddhaModel_
                    end
                    --界面显示更新
                    self:showChangeInfo_(buddhaModel_)
                    --变身特效
                    self:evolutionAnimation_(buddhaModel_)
                end
            end,0.1)
        else
            --普通升级
            local ac = AlertConnection.new(CONNECTION_NPC_UPGRADE,npcId)
            self:addChild(ac,100,12345)

            --网络监测0.1s
            self.scheduleUpgrade_ = self:schedule(function()
                if not self:getChildByTag(12345) then
                    self:stopAction(self.scheduleUpgrade_)
                    --升级特效
                    self:upgradeAnimation_()
                    --飘数字
                    self:numberAction_()
                    --数据更新
                    CloudData.EXP = CloudData.EXP - costExp
                    CloudData.NPC_INFO[npcId].level = CloudData.NPC_INFO[npcId].level + 1
                    if DataUtils.markResourceMutation ~= nil then
                        DataUtils.markResourceMutation("buddha-upgrade")
                    end
                    --重新获取model
                    local buddhaModel_ = DataUtils.getBuddhaModel(npcId)
                    --更新table
                    local index = table.indexof(self.buddhaModelTable_,self.currBuddhaModel_)
                    if index then
                        self.buddhaModelTable_[index] = buddhaModel_
                    end
                    --界面显示更新
                    self:showChangeInfo_(buddhaModel_)
                end
            end,0.1)
        end
    end
end
--突破兵种
function UpgradeBuddhaLayer:addtionalLevelCallBack_()
    local npcId     = tonumber(self.currBuddhaModel_.npcId_)
    local ac = AlertConnection.new(CONNECTION_NPC_BREAKTOP,npcId)
    self:addChild(ac,100,12345)

    --网络监测0.1s
    self.scheduleUpgrade_ = self:schedule(function()
        if not self:getChildByTag(12345) then
            self:stopAction(self.scheduleUpgrade_)
            --飘数字
            self:numberAction_()
            --数据更新
            local costEssence = self.currBuddhaModel_.essenceCost_
            CloudData.ESSENCE = CloudData.ESSENCE - costEssence
            CloudData.NPC_INFO[npcId].addlevel = CloudData.NPC_INFO[npcId].addlevel + 1
            if DataUtils.markResourceMutation ~= nil then
                DataUtils.markResourceMutation("buddha-breach")
            end
            --重新获取model
            local buddhaModel_ = DataUtils.getBuddhaModel(npcId)
            --更新table
            local index = table.indexof(self.buddhaModelTable_,self.currBuddhaModel_)
            if index then
                self.buddhaModelTable_[index] = buddhaModel_
            end
            --界面显示更新
            self:showChangeInfo_(buddhaModel_)
        end
    end,0.1)
end
--召唤兵种
function UpgradeBuddhaLayer:summonCallBack_()
    display.replaceScene(require("scenes.SummonScene").new())
end

--升级特效
function UpgradeBuddhaLayer:upgradeAnimation_()
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
        :addTo(self.armatureFrame_,2,100)
    emptyPic:playAnimationOnce(animation,true)
end
--升级时血量值,攻击值数字向上飘的动作
function UpgradeBuddhaLayer:numberAction_()
    --血量值
    local bloodNum  = tonumber(self.currBuddhaModel_.lifeParamK_)
    if tonumber(self.currBuddhaModel_.level_) >= 20 then
        bloodNum = tonumber(self.currBuddhaModel_.lifeParamKAdd_)
    end
    local tempBlood = cc.ui.UILabel.new({
        UILabelType = 1,text = string.format("+"..bloodNum),font = "fonts/greenNum.fnt"})
        :align(display.CENTER,self.npcBloodAddLabel_:getPositionX() + 20,self.npcBloodAddLabel_:getPositionY())
        :scale(0.8)
        :addTo(self.npcBloodAddLabel_:getParent(),1)
    local moveTo1  = cc.MoveTo:create(0.5,cc.p(tempBlood:getPositionX(),tempBlood:getPositionY() + 50))
    local fadeOut1 = cc.FadeOut:create(0.5)
    tempBlood:runAction(transition.sequence({moveTo1,fadeOut1,cc.CallFunc:create(function()
        tempBlood:removeSelf()
    end)}))

    --攻击值
    local attackNum  = tonumber(self.currBuddhaModel_.attackParamK_)
    if tonumber(self.currBuddhaModel_.level_) >= 20 then
        attackNum  = tonumber(self.currBuddhaModel_.attackParamKAdd_)
    end
    local tempAttack = cc.ui.UILabel.new({
        UILabelType = 1,text = string.format("+"..attackNum),font = "fonts/greenNum.fnt"})
        :align(display.CENTER,self.npcAttackAddLabel_:getPositionX() + 20,self.npcAttackAddLabel_:getPositionY())
        :scale(0.8)
        :addTo(self.npcAttackAddLabel_:getParent(),1)
    local moveTo2  = cc.MoveTo:create(0.5,cc.p(tempAttack:getPositionX(),tempAttack:getPositionY() + 50))
    local fadeOut2 = cc.FadeOut:create(0.5)
    tempAttack:runAction(transition.sequence({moveTo2,fadeOut2,cc.CallFunc:create(function()
        tempAttack:removeSelf()
    end)}))
end
--十级变身特效
function UpgradeBuddhaLayer:evolutionAnimation_(buddhaModel)
    --移除当前骨骼,释放上一个骨骼的资源
    if self.armature_ ~= nil then
        self.armature_:removeSelf()
        self.armature_ = nil
        for k,v in pairs(ccs.ArmatureDataManager:getInstance():getArmatureDatas()) do
            ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(string.format("armature/%s/%s.csb",k,k))
        end
        display.removeUnusedSpriteFrames()
    end

    --转到特效场景
    local al = BuddhaEvolution.new(buddhaModel)
    self:addChild(al,20)
    --2.6s后移除特效场景,重新加载骨骼(时间更具特效场景而定)
    self:runAction(transition.sequence({cc.DelayTime:create(2.6),cc.CallFunc:create(function()
        self:updateAmature_(buddhaModel)
    end)}))
end
function UpgradeBuddhaLayer:updateAmature_(buddhaModel)
    local resDownLoaded = cc.UserDefault:getInstance():getBoolForKey("missed_armature_res_downloaded",false)
    if not resDownLoaded and table.indexof(GameManager.RES_MISSED_ARMATURE, buddhaModel.hurtFrame_) then
        --提示去更新
        self.updateFrame_:show()
    else
        --重新加载新的骨骼动画资源
        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(string.format("armature/%s/%s.csb",
            buddhaModel.hurtFrame_,buddhaModel.hurtFrame_))
        self.armature_ = ccs.Armature:create(buddhaModel.hurtFrame_)
        self.armature_:setPosition(self.armatureFrame_:getContentSize().width * 0.5,self.armatureFrame_:getContentSize().height * 0.2 + buddhaModel.upMove_)
        self.armature_:setScale(buddhaModel.adaptScale_)
        self.armature_:getAnimation():playWithIndex(0)
        self.armatureFrame_:addChild(self.armature_,1)
    end

    --右边选择框内兵种头像更新
    self.currContent_:updateIcon(buddhaModel)
end


--点击右侧列表里的兵种
function UpgradeBuddhaLayer:touchListener(event)
    local lv = event.listView
    if "clicked" == event.name then
        -- local content = event.item:getContent()
        -- content:setSelected()
        for i=1,#self.contentTable_ do
            local buddhaModel = self.buddhaModelTable_[i]
            local content = self.contentTable_[i]
            if i == event.itemPos then
                self.currContent_ = content
                content:setSelected()
                self:showChangeInfo_(buddhaModel)
                --若有升级特效,则移除
                if self.armatureFrame_:getChildByTag(100) then
                    self.armatureFrame_:removeChildByTag(100,true)
                end
            else
                if buddhaModel.buddhaState_ == 1 then
                    content:setNormal()
                else
                    content:setLocked()
                end

            end
        end
    elseif "moved" == event.name then

    elseif "ended" == event.name then

    else
    --print("event name:" .. event.name)
    end
end

function UpgradeBuddhaLayer:returnCallBack_()
    if GameManager.SOUND_SWITCH_ON then
        audio.playSound(string.format("sounds/sfx_touch_shu.%s",GameManager.POSTFIX))
    end
    display.replaceScene(require("scenes.ChapterScene").new())
end

function UpgradeBuddhaLayer:addAndroidReturnButton_()
    --退出游戏
    local btn = cc.ui.UIPushButton.new():addTo(self)
    btn:setKeypadEnabled(true)
    btn:addNodeEventListener(cc.KEYPAD_EVENT, function (event)
        if event.key == "back" then
            self:showReturnWarning_()
        end
    end)
end

function UpgradeBuddhaLayer:showReturnWarning_()
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

function UpgradeBuddhaLayer:onEnter()
end

function UpgradeBuddhaLayer:onExit()
    self:removeAllChildren()
    display.removeUnusedSpriteFrames()
end

return UpgradeBuddhaLayer
