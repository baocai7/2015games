--
--“降妖”界面（兵种升级，突破，防御塔、唐僧属性升级）
--

local DataLabelIcon     = import("icons.DataLabelIcon")
local UpgradeBuddhaIcon = import("icons.UpgradeBuddhaIcon")
local NoviceGuide       = import("utils.NoviceGuide")
local AlertConnection   = import("customs.AlertConnection")
local AlertUpdate       = import("customs.AlertUpdate")

local UpgradeMonsterLayer = class("UpgradeMonsterLayer", function()
    return display.newScene("UpgradeMonsterLayer")
end)

function UpgradeMonsterLayer:ctor()
    --播放音效(打开层)
	if GameManager.SOUND_SWITCH_ON then
		audio.playSound(string.format("sounds/sfx_touch_ti.%s",GameManager.POSTFIX))
	end

    --加载妖怪数据
    self:initMonsterInfo_()

    --默认选择第一个兵种信息
    self.currMonsterModel_ = self.monsterModelTable_[1]
    
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
    self.monsterBtn_ = cc.ui.UIPushButton.new({normal = "upgrade/monster.png",disabled = "upgrade/monster_h.png"})
        :align(display.CENTER,bg:getContentSize().width * 0.11 ,bg:getContentSize().height * 0.55)
        :onButtonClicked(function()
            --UPGRADESCENE.toLayer("UpgradeMonsterLayer")
            display.replaceScene(require("layers.UpgradeMonsterLayer").new())
        end)
        :addTo(bg,3)
    self.monsterBtn_:setButtonEnabled(false)
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
    local npcNameFrame = display.newSprite("upgrade/upgradename.png",
        self.armatureFrame_:getContentSize().width * 0.5,self.armatureFrame_:getContentSize().height * 0.95)
        :addTo(self.armatureFrame_)
    -- local npcNameFrame = display.newSprite("upgrade/upgradename.png",frame:getContentSize().width * 0.706,frame:getContentSize().height * 0.93)
    --     :addTo(frame,2)
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
    --妖怪兵种碎片数量
    self.monsterPiecePic_ = display.newSprite("monster_piece_icon/piece1.png",dataShowFrame:getContentSize().width * 0.10,dataShowFrame:getContentSize().height * 0.25)
        :addTo(dataShowFrame)
        self.monsterPiecePic_:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
                return self:showPieceTip_(event.name)         
            end)
        self.monsterPiecePic_:setTouchEnabled(true) 
        
    self.monsterPieceQua_ = display.newSprite("monster_piece_icon/quality0.png",self.monsterPiecePic_:getContentSize().width * 0.50,self.monsterPiecePic_:getContentSize().height * 0.5)
        :addTo(self.monsterPiecePic_,-1)
        self.monsterPieceQua_:setVisible(false)
           
    local pieceNumFrame = display.newSprite("upgrade/textdi.png",dataShowFrame:getContentSize().width * 0.335,dataShowFrame:getContentSize().height * 0.25)
        :addTo(dataShowFrame)
    self.pieceNumLabel_ = cc.ui.UILabel.new({
        UILabelType = 1,text = "",font = "fonts/bulefonts.fnt"})
        :align(display.CENTER,pieceNumFrame:getContentSize().width * 0.5,pieceNumFrame:getContentSize().height * 0.5)
        :scale(0.8)
        :addTo(pieceNumFrame)

    --召唤按钮
    self.summonBtn_ = cc.ui.UIPushButton.new({normal = "upgrade/zhaohuan.png",pressed = "upgrade/zhaohuan_h.png",disabled = "upgrade/zhaohuan1.png"})
        :align(display.CENTER,dataShowFrame:getContentSize().width * 0.77 ,dataShowFrame:getContentSize().height * 0.30)
        :onButtonClicked(function()
            self:summonCallBack_()
        end)
        :addTo(dataShowFrame)
    self.summonBtn_:setButtonEnabled(false)
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
--        viewRect = cc.rect(frame:getContentSize().width * 0.044,frame:getContentSize().height * 0.096,353,530),
        viewRect = cc.rect(frame:getContentSize().width * 0.044,60,353,530),
        direction = cc.ui.UIScrollView.DIRECTION_VERTICAL}
        :onTouch(handler(self,self.touchListener))
        :addTo(frame,1)
    -- add items
    for i=1,#self.monsterModelTable_ do
        local item = self.listView:newItem()
        local buddhaModel = self.monsterModelTable_[i]
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
    
--    local total = #self.monsterModelTable_
--    local currIdx = 6
--
--    -- 延迟添加item
--    local function addItem()
--        local item = self.listView:newItem()
--        local buddhaModel = self.monsterModelTable_[currIdx]
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
    self:showChangeInfo_(self.currMonsterModel_)

    --第六关的时候引导召唤悍匪挫山雕
    if CloudData.STAGE_PROGRESS == 6 and DataUtils.getGuideIsFirstPlayed("GUIDE_STEP_UNLOCK_MONSTER2") and 
    not DataUtils.getGuideIsFirstPlayed("GUIDE_STEP_UNLOCK_MONSTER3") then     
        local guide = NoviceGuide.new(GUIDE_STEP_UNLOCK_MONSTER3)
        self:addChild(guide,50)
        DataUtils.setGuideIsFirstPlayed("GUIDE_STEP_UNLOCK_MONSTER3",true)
    end
end

function UpgradeMonsterLayer:showBuddhaProTip()
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

function UpgradeMonsterLayer:initMonsterInfo_()
    --存储兵种Table
    --self.monsterModelTable_ = DataUtils.getBuddhaModelsTableUpgradeScene("MONSTER")
    self.monsterModelTable_ = GameManager.MONSTER_MODEL_TABLE

    --存储ListView的content
    self.contentTable_ = {}
end

--数据信息更改显示  
function UpgradeMonsterLayer:showChangeInfo_(buddhaModel)
    --兵种信息解析
    local monsteraName  = buddhaModel.name_
    local monsterBlood   = tonumber(buddhaModel.lifeParamK_ * buddhaModel.level_ + buddhaModel.lifeParamB_ 
        + buddhaModel.addLevel_ * buddhaModel.lifeParamKAdd_  + buddhaModel.lifeParamBAdd_)
    local monsterAttack = tonumber(buddhaModel.attackParamK_ * buddhaModel.level_ + buddhaModel.attackParamB_ 
        + buddhaModel.addLevel_ * buddhaModel.attackParamKAdd_ + buddhaModel.attackParamBAdd_)
    --妖怪兵种的碎片
    local summonPieceId = tonumber(buddhaModel.summonPieceId_)
    local monsterPiecemodel = DataUtils.getMonsterPieceModel(summonPieceId)
        --碎片数量
    local currMonsterPieceNum   = tonumber(monsterPiecemodel.currentNum_)  --现有数量
    local summonMonsterPieceNum = tonumber(buddhaModel.summonNum_)         --召唤需要的数量

    --数据显示
    self.npcNameLabel_:setString(monsteraName)
    self.npcBloodLabel_:setString(monsterBlood)
    self.npcAttackLabel_:setString(monsterAttack)
    self.npcBloodAddLabel_:setString(string.format("+"..buddhaModel.lifeParamKAdd_))
    self.npcBloodAddLabel_:setPositionX(self.npcBloodLabel_:getPositionX() + self.npcBloodLabel_:getContentSize().width * 0.52)
    self.npcAttackAddLabel_:setString(string.format("+"..buddhaModel.attackParamKAdd_))
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
        --重新加载新的骨骼动画资源
        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(string.format("armature/%s/%s.csb",
            buddhaModel.hurtFrame_,buddhaModel.hurtFrame_))
        self.armature_ = ccs.Armature:create(buddhaModel.hurtFrame_)
        self.armature_:setPosition(self.armatureFrame_:getContentSize().width * 0.5,self.armatureFrame_:getContentSize().height * 0.2 + buddhaModel.upMove_)
        self.armature_:setScale(buddhaModel.adaptScale_)
        --self.armature_:getAnimation():playWithIndex(0)
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
        self.addtionalBtn_:hide()
        if currMonsterPieceNum >= summonMonsterPieceNum then
            self.summonBtn_:setButtonEnabled(true)
        else
            self.summonBtn_:setButtonEnabled(false)
        end
        --碎片图标与数量
        local quality = monsterPiecemodel.quality_
        self.monsterPieceQua_:setTexture("monster_piece_icon/quality" .. quality .. ".png")
        self.monsterPieceQua_:setVisible(true)
        self.monsterPiecePic_:setTexture(string.format(monsterPiecemodel.pieceIconPath_))
        self.pieceNumLabel_:setString(string.format(currMonsterPieceNum.."/"..summonMonsterPieceNum))
    else                                         --此时显示为召唤按钮
        self.summonBtn_:hide()
        self.addtionalBtn_:show()
        self.monsterPieceQua_:setVisible(false)
        local costEssence = buddhaModel.essenceCost_
        if CloudData.ESSENCE < costEssence then
            self.addtionalBtn_:setButtonEnabled(false)
        else
            self.addtionalBtn_:setButtonEnabled(true)
        end
        --精华图标与消耗所需精华数量
        self.monsterPiecePic_:setTexture("upgrade/essence.png")
        self.pieceNumLabel_:setString(costEssence)
    end

    --记录当前选中的兵种model
    self.currBuddhaModel_ = buddhaModel
end

--显示碎片出处
function UpgradeMonsterLayer:showPieceTip_(event)   
    if event == "began" then
        local summonPieceId = tonumber(self.currBuddhaModel_.summonPieceId_)
        local monsterPiecemodel = DataUtils.getMonsterPieceModel(summonPieceId)
                
        if monsterPiecemodel.buddhaState_ == 1 then
            return
        end
               
        self.tip_ = display.newSprite("upgrade/light.png")
            :pos(self.monsterPiecePic_:getContentSize().width*0.5,self.monsterPiecePic_:getContentSize().height * 0.5)
            :addTo(self.monsterPiecePic_, -2)
            
        local tipFrame = display.newSprite("upgrade/tip.png")
            :pos(self.tip_:getContentSize().width * 1.43,self.tip_:getContentSize().height)
            :addTo(self.tip_)
            tipFrame:setAnchorPoint(0.5, 0)

        local quality = tonumber(monsterPiecemodel.quality_)
        local color_
        if quality == 1 then
            color_ = cc.c3b(0,231,33)
        elseif quality == 2 then
            color_ = cc.c3b(0,223,231)
        elseif quality == 3 then
            color_ = cc.c3b(224,16,255)
        elseif quality == 4 then
            color_ = cc.c3b(248,128,0)
        else
            color_ = cc.c3b(255,255,255)
        end
        
        cc.ui.UILabel.new({
            text = monsterPiecemodel.monsterPieceDesc_,size = 26,color = color_,font = GameManager.FONTNAME_TTF})
            :align(display.CENTER_LEFT,tipFrame:getContentSize().width * 0.22,tipFrame:getContentSize().height * 0.74)
            :addTo(tipFrame)       
        
        local str = ""
        for i = 1, 5 do           
            local stage = monsterPiecemodel["pieceLootStage" .. i .. "_"]
            if stage > 0 then
            	str = str .. "第" .. stage .. "关."  
            end
        end

        cc.ui.UILabel.new({text = str,size = 25,
            font = GameManager.FONTNAME_TTF,dimensions = cc.size(255,55)})       
            :align(display.CENTER_LEFT, tipFrame:getContentSize().width*0.22,tipFrame:getContentSize().height*0.4)
            :addTo(tipFrame)
            
        return true                    
    end

    if event == "ended" then
        if self.tip_ then
            self.tip_:removeSelf()
            self.tip_ = nil       
        end               
    end 
end

--突破兵种
function UpgradeMonsterLayer:addtionalLevelCallBack_()

    
    
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
            --重新获取model
            local buddhaModel_ = DataUtils.getBuddhaModel(npcId)
            --更新table
            local index = table.indexof(self.monsterModelTable_,self.currBuddhaModel_)
            if index then
                self.monsterModelTable_[index] = buddhaModel_
            end
            --界面显示更新
            self:showChangeInfo_(buddhaModel_)
        end
    end,0.1)    
end
--召唤兵种
function UpgradeMonsterLayer:summonCallBack_()
    local npcId     = tonumber(self.currBuddhaModel_.npcId_)
    local ac = AlertConnection.new(CONNECTION_NPC_COMPOSE,npcId)
    self:addChild(ac,100,12345)

    --网络监测0.1s
    self.scheduleUpgrade_ = self:schedule(function() 
        if not self:getChildByTag(12345) then
            self:stopAction(self.scheduleUpgrade_)

            CloudData.NPC_INFO[npcId].level    = 1
            CloudData.NPC_INFO[npcId].addlevel = 0
            CloudData.NPC_INFO[npcId].status   = 1
            CloudData.NPC_INFO[npcId].isActive = 1
            CloudData.NPC_INFO[npcId].npcId    = npcId

            --播放音效
			if GameManager.SOUND_SWITCH_ON then
				audio.playSound(string.format("sounds/sfx_advanced.%s",GameManager.POSTFIX))
			end

            --重新获取model
            local buddhaModel_ = DataUtils.getBuddhaModel(npcId)
            --更新table
            local index = table.indexof(self.monsterModelTable_,self.currBuddhaModel_)
            print(index)
            if index then
                self.monsterModelTable_[index] = buddhaModel_
            end
            --界面显示更新
            self:showChangeInfo_(buddhaModel_)
            --左边区域界面更新
            self.currContent_:updateUI(buddhaModel_)
        end
    end,0.1)    
end

--升级时血量值,攻击值数字向上飘的动作
function UpgradeMonsterLayer:numberAction_()
	if GameManager.SOUND_SWITCH_ON then
		audio.playSound(string.format("sounds/sfx_upgrade.%s",GameManager.POSTFIX))
	end
    
    --血量值
    local bloodNum  = tonumber(self.currBuddhaModel_.lifeParamK_)
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

function UpgradeMonsterLayer:touchListener(event)
    local lv = event.listView
    if "clicked" == event.name then
        -- local content = event.item:getContent()
        -- content:setSelected()
        for i=1,#self.contentTable_ do
            local buddhaModel = self.monsterModelTable_[i]
            local content = self.contentTable_[i]
            if i == event.itemPos then
                self.currContent_ = content
                content:setSelected()
                self:showChangeInfo_(buddhaModel)
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

function UpgradeMonsterLayer:returnCallBack_()
	if GameManager.SOUND_SWITCH_ON then
		audio.playSound(string.format("sounds/sfx_touch_shu.%s",GameManager.POSTFIX))
	end
    
    display.replaceScene(require("scenes.ChapterScene").new())
end

function UpgradeMonsterLayer:addAndroidReturnButton_()
	--退出游戏
    local btn = cc.ui.UIPushButton.new():addTo(self)
		btn:setKeypadEnabled(true)
        btn:addNodeEventListener(cc.KEYPAD_EVENT, function (event)
            if event.key == "back" then
				self:showReturnWarning_()
			end
		end)
end

function UpgradeMonsterLayer:showReturnWarning_()
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

function UpgradeMonsterLayer:onEnter()
end

function UpgradeMonsterLayer:onExit()
    self:removeAllChildren()
    display.removeUnusedSpriteFrames()
end

return UpgradeMonsterLayer
