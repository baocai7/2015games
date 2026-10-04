--
--队伍界面（查看战力，编辑队伍）
--

local DataLabelIcon   = import("icons.DataLabelIcon")
local BuddhaIcon      = import("icons.BuddhaIcon")
local TeamIcon        = import("icons.TeamIcon")
local TeamSceneLayer  = import("layers.TeamSceneLayer")
local NoviceGuide     = import("utils.NoviceGuide")
local AlertConnection = import("customs.AlertConnection")
local WSToast         = import("utils.WSToast")
local AlertUpdate     = import("customs.AlertUpdate")

local TeamScene = class("TeamScene", function()
    return display.newScene("TeamScene")
end)

function TeamScene:ctor()
	
	print("path "..device.writablePath)
	
    --阵形格子table
    self.teamIconTable_ = {}
    --仓库兵种table
    self.buddhaIconTable_ = {}
	self.allBuddhaInfoTable_ = {}
	self.headBuddhaInfoTable_ = {}
	self.midBuddhaMidInfoTable_ = {}
	self.backBuddhaBackInfoTable_ = {}
    self.mPreTeam = {}
	
    --背景图片
    local bg = display.newSprite("common_ui/uibg.jpg",display.cx,display.cy):addTo(self)
    --"队伍"标签
    local teamTitle_ = display.newSprite("team/team.png",bg:getContentSize().width * 0.3,bg:getContentSize().height * 0.94):addTo(bg)
    teamTitle_:setScale(0.9)

    --经验
    local expLabel = DataLabelIcon.new(DataLabelIcon.LABEL_TYPE_EXP,true)
    expLabel:setScale(0.8)
    expLabel:setPosition(cc.p(bg:getContentSize().width * 0.55,bg:getContentSize().height * 0.95))
    bg:addChild(expLabel,15)
    --蟠桃
    local peachLabel = DataLabelIcon.new(DataLabelIcon.LABEL_TYPE_PEACH,true)
    peachLabel:setScale(0.8)
    peachLabel:setPosition(cc.p(bg:getContentSize().width * 0.82,bg:getContentSize().height * 0.95))
    bg:addChild(peachLabel,15)
     --返回按钮
    cc.ui.UIPushButton.new({normal = "common_ui/back.png",pressed = "common_ui/back_h.png"})
        :scale(0.8)
        :align(display.CENTER,bg:getContentSize().width * 0.12 ,bg:getContentSize().height * 0.95)
        :onButtonPressed(function()
            self:performWithDelay(function()
                --self:returnCallBack_()
                self:returnCallBack_No1_()
            end,0.1)
        end)
        -- :onButtonClicked(function()
        --     self:returnCallBack_()
        -- end)
        :addTo(bg,15)

    --上方出兵兵种阵形背景
    local teamFrame = display.newSprite("team/fightbg.png",bg:getContentSize().width * 0.5,bg:getContentSize().height * 0.118)
		:addTo(bg,1)
    --加载阵形格子
    for i=1,6 do
        local isUnlocked = true
        if i > CloudData.TEAM_UNLOCKGRID_NUM then
            isUnlocked = false
        end
        local teamIcon = TeamIcon.new(isUnlocked)
		teamIcon:setScale(0.85)
        teamIcon:setPosition(teamIcon:getContentSize().width * 0.9462 * (i - 0.5) + 50, teamFrame:getContentSize().height * 0.5)
        teamIcon:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
                    return self:onTouchTeamIcon_(event.name,event.x,event.y)
                end)
        teamFrame:addChild(teamIcon)
        table.insert(self.teamIconTable_,teamIcon) 
    end    
	
	--仓库兵背景(列表部分)
    self.listFrame = display.newSprite("team/teambg.png",bg:getContentSize().width * 0.472,bg:getContentSize().height * 0.555)
        :addTo(bg,1)
		
	--------------
	local buddhaTableIsHave = DataUtils.getBuddhaIdsTableTeamScene()
    local buddhaTotalNum    = #buddhaTableIsHave

	for i = 1, buddhaTotalNum do		
		local buddhaId = buddhaTableIsHave[i]
		local buddhaModel = DataUtils.getBuddhaModel(buddhaId)
        
		local tag1 = tonumber(buddhaModel.tag1_)
		local buddhaIcon = {}
		buddhaIcon.buddhaId = buddhaId
		buddhaIcon.buddhaQuality_ = buddhaModel.quality_
		if tag1 == 1 then
			self:insertToTable(self.headBuddhaInfoTable_, buddhaIcon)
		elseif tag1 == 4 then
			self:insertToTable(self.backBuddhaBackInfoTable_, buddhaIcon)
		else
			self:insertToTable(self.midBuddhaMidInfoTable_, buddhaIcon)
		end
		self:insertToTable(self.allBuddhaInfoTable_, buddhaIcon)
	end
	
	self:showBuddhaIcon_(self.allBuddhaInfoTable_)
	self:initTeamInfo_()

	--战斗力显示
    local assessmentNum = self:getBuddhaAssessment()
    self.assessmentLabel_ = cc.ui.UILabel.new({
        UILabelType = 2,text = string.format(assessmentNum),size = 30,color = display.COLOR_WHITE,font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,teamFrame:getContentSize().width * 0.88,teamFrame:getContentSize().height * 0.31)
        :addTo(teamFrame)
    --self.assessmentLabel_:setAnchorPoint(cc.p(0,0.5))

    --第一次进入此界面时引导天将上阵
    if CloudData.STAGE_PROGRESS == 1 and not DataUtils.getGuideIsFirstPlayed("GUIDE_STEP_TIANJIANG_ON_TEAM") then     --引导进入队伍界面
        local guide = NoviceGuide.new(GUIDE_STEP_TIANJIANG_ON_TEAM)
        self:addChild(guide,50)
        DataUtils.setGuideIsFirstPlayed("GUIDE_STEP_TIANJIANG_ON_TEAM",true)
    end

    --第一次召唤出沙僧后引导上阵(好孩子小胖)
    if CloudData.STAGE_PROGRESS == 3 and DataUtils.getGuideIsFirstPlayed("GUIDE_STEP_ENTER_SUMMONSCENE") and 
    not DataUtils.getGuideIsFirstPlayed("GUIDE_STEP_SHASENG_ON_TEAM") then     --引导进入队伍界面
        local guide = NoviceGuide.new(GUIDE_STEP_SHASENG_ON_TEAM)
        self:addChild(guide,50)
        DataUtils.setGuideIsFirstPlayed("GUIDE_STEP_SHASENG_ON_TEAM",true)
    end
	
	self.allIcons = cc.ui.UIPushButton.new({normal = "team/all.png",disabled = "team/all_h.png"})
        :align(display.CENTER,bg:getContentSize().width * 0.8655 ,bg:getContentSize().height * 0.75)
        :onButtonClicked(function()
            self:showAll_()
        end)
        :addTo(bg,15)
	self.allIcons:setButtonEnabled(false)
	
	self.headIcons = cc.ui.UIPushButton.new({normal = "team/head.png",disabled = "team/head_h.png"})
        :align(display.CENTER,bg:getContentSize().width * 0.8655 ,bg:getContentSize().height * 0.615)
        :onButtonClicked(function()
            self:showHead_()
        end)
        :addTo(bg,15)
	
	self.midIcons = cc.ui.UIPushButton.new({normal = "team/mid.png",disabled = "team/mid_h.png"})
        :align(display.CENTER,bg:getContentSize().width * 0.8655 ,bg:getContentSize().height * 0.475)
        :onButtonClicked(function()
            self:showMiddle_()
        end)
        :addTo(bg,15)
		
	self.backIcons = cc.ui.UIPushButton.new({normal = "team/back.png",disabled = "team/back_h.png"})
        :align(display.CENTER,bg:getContentSize().width * 0.8655 ,bg:getContentSize().height * 0.34)
        :onButtonClicked(function()
            self:showBack_()
        end)
        :addTo(bg,15)
	
	self:addAndroidReturnButton_()
end

function TeamScene:showBuddhaIcon_(table_)
	self.buddhaIconTable_ = {}
	self.listView = cc.ui.UIListView.new {
        viewRect = cc.rect(50,35,870,385),
        direction = cc.ui.UIScrollView.DIRECTION_VERTICAL}
        :onTouch(handler(self,self.touchListener))
        :addTo(self.listFrame)

    --获取已有兵种table
    local buddhaTotalNum    = #table_
    local row               = math.ceil(buddhaTotalNum / 6)    --行数
    local column            = buddhaTotalNum % 6               --末行剩几个
    local endNum = 6
    for i=1,row do
        local item = self.listView:newItem()
        local content = display.newNode()
        content:setAnchorPoint(0.5,0.5)
        if i == row and column > 0 then
            endNum = column
        end
        for count = 1, endNum do
			local buddhaId = table_[(i - 1) * 6 + count].buddhaId
            local buddhaModel = DataUtils.getBuddhaModel(buddhaId)
            local buddhaIcon = BuddhaIcon.new(buddhaModel)
            buddhaIcon:setPosition(146 * count - 75,100) -- h = 60
            buddhaIcon:setTouchSwallowEnabled(false)
            content:addChild(buddhaIcon)
			
			local fair = display.newSprite("team/fairframe.png",146 * count - 75, 20) -- h = -20
			:addTo(content)
			
			cc.ui.UILabel.new({text = buddhaModel.costValue_,size = 18,font = GameManager.FONTNAME_TTF})
			:align(display.CENTER,fair:getContentSize().width * 0.55, fair:getContentSize().height * 0.5)
			:addTo(fair)
		
            table.insert(self.buddhaIconTable_,buddhaIcon) 
        end
        content:setContentSize(146 * 6, 180)
        item:addContent(content)
        item:setItemSize(146 * 6, 180)
        self.listView:addItem(item)
    end
    self.listView:reload()
	
	self:flushBuddhaOnTeamInfo_()
end

function TeamScene:showAll_()
	self.listView:removeAllItems()
	self.listView = nil
	self.buddhaIconTable_ = nil
	self:showBuddhaIcon_(self.allBuddhaInfoTable_)
	self.allIcons:setButtonEnabled(false)
	self.headIcons:setButtonEnabled(true)
	self.midIcons:setButtonEnabled(true)
	self.backIcons:setButtonEnabled(true)
end

function TeamScene:showHead_()
	self.listView:removeAllItems()
	self.listView = nil
	self.buddhaIconTable_ = nil
	self:showBuddhaIcon_(self.headBuddhaInfoTable_)
	self.allIcons:setButtonEnabled(true)
	self.headIcons:setButtonEnabled(false)
	self.midIcons:setButtonEnabled(true)
	self.backIcons:setButtonEnabled(true)
end

function TeamScene:showMiddle_()
	self.listView:removeAllItems()
	self.listView = nil
	self.buddhaIconTable_ = nil
	self:showBuddhaIcon_(self.midBuddhaMidInfoTable_)
	self.allIcons:setButtonEnabled(true)
	self.headIcons:setButtonEnabled(true)
	self.midIcons:setButtonEnabled(false)
	self.backIcons:setButtonEnabled(true)
end

function TeamScene:showBack_()
	self.listView:removeAllItems()
	self.listView = nil
	self.buddhaIconTable_ = nil
	self:showBuddhaIcon_(self.backBuddhaBackInfoTable_)
	self.allIcons:setButtonEnabled(true)
	self.headIcons:setButtonEnabled(true)
	self.midIcons:setButtonEnabled(true)
	self.backIcons:setButtonEnabled(false)
end

--初始化队伍上阵情况
function TeamScene:initTeamInfo_()
    local currBuddhaTableOnTeam = DataUtils.getBuddhaTableOnTeam()
    for i,v in ipairs(currBuddhaTableOnTeam) do
        if v ~= "" then
            local buddhaId = tonumber(v)

            --保存初始阵容
            self.mPreTeam[buddhaId] = true

            --阵形
            local teamIcon = self.teamIconTable_[i]
            --添加兵种图标
            teamIcon:addBuddhaPic(buddhaId)
            --将兵种上阵信息置为true
            teamIcon:setBuddhaOn(true)    
            
            --兵种
            for j=1,#self.buddhaIconTable_ do
                local buddhaIcon = self.buddhaIconTable_[j]
                if buddhaIcon.buddhaId_ == buddhaId then
                    buddhaIcon:setOnTeam(true)
                end
            end 
        end   
    end
    dump(self.mPreTeam, "pre .. ")
end

function TeamScene:flushBuddhaOnTeamInfo_()
	for i = 1, 6 do
		local id = self.teamIconTable_[i].buddhaId_
		for j = 1, #self.buddhaIconTable_ do
			if id == self.buddhaIconTable_[j].buddhaId_ then
				self.buddhaIconTable_[j]:setOnTeam(true)
			end
		end
	end
end

--listView的touch监听
function TeamScene:touchListener(event)
    if "clicked" == event.name then
        local column = math.ceil(event.point.x / 146)
        local idx = (event.itemPos - 1) * 6 + column
        if idx >= 0 and idx <= #self.buddhaIconTable_ then
            local buddhaIcon = self.buddhaIconTable_[idx]
            if not buddhaIcon:getOnTeam() then
                self:putBuddhaOnTeam(buddhaIcon)  
            end
        end   
    elseif "moved" == event.name then
        
    elseif "ended" == event.name then
        
    end
end

--点击teamIcon
function TeamScene:onTouchTeamIcon_(event,x,y)
    if event == "began" then
        self.touchBeginPoint_ = {x = x,y = y}
        return true
    end

    if event == "moved" then
       
    end

    if event == "ended" then
        local point_ended = cc.p(x,y)
        --点击teamIcon
        for i=1,6 do
            local teamIcon = self.teamIconTable_[i]
            if math.abs(self.touchBeginPoint_.x - point_ended.x) < 10 and math.abs(self.touchBeginPoint_.y - point_ended.y) < 10 
                and cc.rectContainsPoint(teamIcon:getMyBoundingBox(),point_ended) then
                if i <= CloudData.TEAM_UNLOCKGRID_NUM then
                    self:putBuddhaDownTeam(teamIcon)
                else
                    self:unlockGrid_()  
                end
            end
        end
    end
end

--兵种上阵
function TeamScene:putBuddhaOnTeam(buddhaIcon)
	print("CloudData.TEAM_UNLOCKGRID_NUM" .. CloudData.TEAM_UNLOCKGRID_NUM)
    for i=1,CloudData.TEAM_UNLOCKGRID_NUM do
        local teamIcon = self.teamIconTable_[i]
        if not teamIcon:getBuddhaOn() then
            buddhaIcon:onClicked()
            --添加兵种图标
            teamIcon:addBuddhaPic(buddhaIcon.buddhaId_)
            --将兵种上阵信息置为true
            teamIcon:setBuddhaOn(true)
            buddhaIcon:setOnTeam(true)
            --战斗力更新
            self.assessmentLabel_:setString(string.format(self:getBuddhaAssessment()))
            return
        end
    end
end
--兵种下阵
function TeamScene:putBuddhaDownTeam(teamIcon)
	print("CloudData.TEAM_UNLOCKGRID_NUM" .. CloudData.TEAM_UNLOCKGRID_NUM)
    if teamIcon:getBuddhaOn() then
        teamIcon:onClicked()
        for i=1,#self.buddhaIconTable_ do
            local buddhaIcon = self.buddhaIconTable_[i]
            if buddhaIcon.buddhaId_ == teamIcon.buddhaId_ then
                buddhaIcon:setOnTeam(false)
            end
        end
		--移除兵种图标
        teamIcon:removeBuddhaPic()
        --将兵种上阵信息置为false
        teamIcon:setBuddhaOn(false)
        --战斗力更新
        self.assessmentLabel_:setString(string.format(self:getBuddhaAssessment()))
    end 
end

--解锁格子
function TeamScene:unlockGrid_()
    local teamIcon = self.teamIconTable_[CloudData.TEAM_UNLOCKGRID_NUM + 1]
    local layer_ = TeamSceneLayer.new(teamIcon)
    self:addChild(layer_,20)
end

--兵种战斗力评估
function TeamScene:getBuddhaAssessment()
    local sum = 0
    for i=1,CloudData.TEAM_UNLOCKGRID_NUM do
        local teamIcon = self.teamIconTable_[i]
        if teamIcon:getBuddhaOn() then
            local buddhaId = teamIcon.buddhaId_
            local buddhaModel = DataUtils.getBuddhaModel(buddhaId)

            --读取各项数值
            local fAttack          = tonumber(buddhaModel.level_) * buddhaModel.attackParamK_     + buddhaModel.attackParamB_
            local fBlood           = tonumber(buddhaModel.level_) * buddhaModel.lifeParamK_       + buddhaModel.lifeParamB_
            local fAttackFrequency = tonumber(buddhaModel.level_) * buddhaModel.attackFrequencyK_ + buddhaModel.attackFrequencyB_
            local fSpeed           = tonumber(buddhaModel.runSpeed_)
            local fAttackDistance  = tonumber(buddhaModel.attackDistance_)
            local fbalance         = tonumber(buddhaModel.balance_)
            local bIsAreaDamage    = buddhaModel.isAreaDamage_
            --兵种突破所加攻击和血量
            local fAttackAddtional = tonumber(buddhaModel.addLevel_) * buddhaModel.attackParamKAdd_ + buddhaModel.attackParamBAdd_
            local fBloodAddtional  = tonumber(buddhaModel.addLevel_) * buddhaModel.lifeParamKAdd_   + buddhaModel.lifeParamBAdd_
            fAttack = fAttack + fAttackAddtional
            fBlood  = fBlood  + fBloodAddtional
            --计算公式：1.M1 = [（兵种攻击/10*兵种血量/10）/攻击频率*（1+速度/200+（攻击距离-100）/200）]*（1+2*是否群攻）
            --          2.M2=M1^1/2，M2保留一位小数
            --          3.单兵战斗力=M2*10
            local m1 = ((fAttack * fBlood) / fAttackFrequency * (1 + fSpeed/200 + (fAttackDistance - 100) / 200))
            if (bIsAreaDamage) then
                m1 = m1 * 3
            end
            local m2 = math.pow(m1,0.5)
            local m3 = m2 * 10 * fbalance 
            sum = math.ceil(sum + m3)
        end
    end
    return sum
end

--返回章节界面(此处存储已上阵的兵种)
function TeamScene:returnCallBack_()
    if GameManager.SOUND_SWITCH_ON then
        audio.playSound(string.format("sounds/sfx_touch_shu.%s",GameManager.POSTFIX))
    end
    
    --获取上阵兵种的id
    local saveBuddhaTable = {}
    local resDownLoaded = cc.UserDefault:getInstance():getBoolForKey("missed_armature_res_downloaded",false)
    
    --print(resDownLoaded)
    for i=1,6 do
        local teamIcon = self.teamIconTable_[i]
        if teamIcon:getBuddhaOn() then
            local buddhaId = teamIcon.buddhaId_       
            --print("-------buddhaId_: ------"..buddhaId)
            --若本地没有队伍成员的骨骼动画,则强制下载
            local buddhaModel = DataUtils.getBuddhaModel(buddhaId)           
            if not resDownLoaded and table.indexof(GameManager.RES_MISSED_ARMATURE, buddhaModel.hurtFrame_) then               
                local al = AlertUpdate.new(GameManager.URL_MISSED_ARMATURE,5.8,"FORCE",true)
                self:addChild(al,100)
                return
            else
                table.insert(saveBuddhaTable,buddhaId)
            end                                            
        end
    end

    --判断是否阵形上有兵种
    if (#saveBuddhaTable) == 0 then
        local toast = WSToast.new("请选择至少一个兵种上阵",1.5)
        self:addChild(toast,50)
    else
        DataUtils.setBuddhaTableOnTeam(saveBuddhaTable)
        display.replaceScene(require("scenes.ChapterScene").new())
    end
end

--修改--返回章节界面(此处存储已上阵的兵种,添加资源更新判断)
function TeamScene:returnCallBack_No1_()
    if cc.UserDefault:getInstance():getBoolForKey("user_sound_switch",true) then
        audio.playSound(string.format("sounds/sfx_touch_shu.%s",GameManager.POSTFIX))
    end

    --获取上阵兵种的id
    local saveBuddhaTable = {}
    local resDownLoaded = cc.UserDefault:getInstance():getBoolForKey("missed_armature_res_downloaded",false)

    --判断阵容是否有改变
    local change = false
    --print(resDownLoaded)
    for i=1,6 do
        local teamIcon = self.teamIconTable_[i]
        if teamIcon:getBuddhaOn() then
            local buddhaId = teamIcon.buddhaId_
         
            --换了阵容
            if self.mPreTeam[buddhaId] == nil then 
                change = true
            end

            --print("-------buddhaId_: ------"..buddhaId)
            --若本地没有队伍成员的骨骼动画,则强制下载
            local buddhaModel = DataUtils.getBuddhaModel(buddhaId)           
            if not resDownLoaded and table.indexof(GameManager.RES_MISSED_ARMATURE, buddhaModel.hurtFrame_) then               
                local al = AlertUpdate.new(GameManager.URL_MISSED_ARMATURE,5.8,"FORCE",true)
                self:addChild(al,100)
                return
            else
                table.insert(saveBuddhaTable,buddhaId)
            end                                            
        end
    end

    --判断是否阵形上有兵种
    if (#saveBuddhaTable) == 0 then
        local toast = WSToast.new("请选择至少一个兵种上阵",1.5)
        self:addChild(toast,50)
    else
        dump(saveBuddhaTable, "post .. ")
        if change or #self.mPreTeam ~= #saveBuddhaTable then 
            self:updateTeam(saveBuddhaTable)
        else 
            DataUtils.setBuddhaTableOnTeam(saveBuddhaTable)
            display.replaceScene(require("scenes.ChapterScene").new())
        end       
    end
end

function TeamScene:updateTeam(teamTable)
    print("通知服务器")
    local teamInfoTable = json.encode(teamTable)
    local ac = AlertConnection.new(CONNECTION_UPDATE_TEAM, teamInfoTable)
    self:addChild(ac,100,12345)
    self.mSchedule = self:schedule(function()
        if not self:getChildByTag(12345) then
            self:stopAction(self.mSchedule)
            
            DataUtils.setBuddhaTableOnTeam(teamTable)
            display.replaceScene(require("scenes.ChapterScene").new())
            
            print("阵容通知成功")
        end
    end, 0.1)
end

function TeamScene:insertToTable(table_, buddhaIcon)
	if #table_ == 0 then
		table.insert(table_, buddhaIcon)
	else 
		local tag = true
		for i = 1, #table_ do
			if table_[i].buddhaQuality_ < buddhaIcon.buddhaQuality_ then
				table.insert(table_, i, buddhaIcon)
				tag = false
				break
				
			end
		end
		if tag then			
			table.insert(table_, buddhaIcon)
			
		end
	end   
end

function TeamScene:addAndroidReturnButton_()
	--退出游戏
    local btn = cc.ui.UIPushButton.new():addTo(self)
		btn:setKeypadEnabled(true)
        btn:addNodeEventListener(cc.KEYPAD_EVENT, function (event)
            if event.key == "back" then
				self:showReturnWarning_()
			end
		end)
end

function TeamScene:showReturnWarning_()
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

function TeamScene:onEnter()
end

function TeamScene:onExit()
    self:removeAllChildren()
    display.removeUnusedSpriteFrames()
    --打印纹理缓存
    --local info1 = cc.Director:getInstance():getTextureCache():getCachedTextureInfo()
    --print(info1)
end

return TeamScene
