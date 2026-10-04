--
--图鉴界面（查看已获得的神仙和兵种的详细信息）
--
local DataLabelIcon   = import("icons.DataLabelIcon")
local BuddhaIcon      = import("icons.BuddhaIcon")
local MonsterIcon     = import("icons.MonsterIcon")

local WikiScene = {}
WikiScene = class("WikiScene", function()
    return display.newScene("WikiScene")
end)

function WikiScene:ctor()


    self:initBuddhaInfo_()

    --背景图片
    local bg = display.newSprite("common_ui/uibg.jpg",display.cx,display.cy):addTo(self)

    --"图鉴"标签
    local wikiTitle_ = display.newSprite("wiki/title.png",bg:getContentSize().width * 0.3,bg:getContentSize().height * 0.94):addTo(bg)
    --存储神仙和妖怪图标的表
    self.buddhaIconTable_ = {}
    self.monsterIconTable_ = {}

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
        :align(display.CENTER,bg:getContentSize().width * 0.12 ,bg:getContentSize().height * 0.94)
        :onButtonPressed(function()
            self:performWithDelay(function()
                self:returnCallBack_()
            end,0.1)
        end)
        -- :onButtonClicked(function()
        -- 	self:returnCallBack_()
        -- end)
        :addTo(bg,15)

    self.wikiframe = display.newSprite("wiki/bg.png",bg:getContentSize().width * 0.5 - 20,bg:getContentSize().height * 0.45)
        :addTo(bg,1)
    --分页按钮
    self.buddhaBtn = cc.ui.UIPushButton.new({normal = "wiki/buddha.png",disabled = "wiki/buddha1.png"})
        :pos(self.wikiframe:getContentSize().width * 0.97  ,self.wikiframe:getContentSize().height * 0.845)
        :onButtonClicked(function()
            self:LoadBuddhaToView()
        end)
        :addTo(self.wikiframe,1)
    self.buddhaBtn:setAnchorPoint(0, 0.5)

    self.monsterBtn = cc.ui.UIPushButton.new({normal = "wiki/monster.png",disabled = "wiki/monster1.png"})
        :pos(self.wikiframe:getContentSize().width *0.97 ,self.wikiframe:getContentSize().height * 0.625)
        :onButtonClicked(function()
            self:LoadMonsterToView()
        end)
        :addTo(self.wikiframe,1)
    self.monsterBtn:setAnchorPoint(0, 0.5)

    --创建显示神仙或妖怪的listview
    self.listView = cc.ui.UIListView.new {
        --bgColor = cc.c4b(200, 200, 200, 120),
        viewRect = cc.rect(bg:getContentSize().width * 0.5 +95, 61, 350, 520),
        direction = cc.ui.UIScrollView.DIRECTION_VERTICAL}
        :onTouch(handler(self,self.touchListener))
        :addTo(bg,1)

    self:LoadBuddhaToView()

    self:addAndroidReturnButton_()
end

--当选择其他的NPC的时候，切换名称、描述、动画
function WikiScene:ChangeInfo(buddhaModel,flag)
    print("ChangeInfo")
    if self.armature_ ~=nil then
        self.armature_:removeSelf()
        self.armature_ =nil
    end

    if self.buddhalName ~=nil then
        self.buddhalName:removeSelf()
        self.buddhalName =nil
    end

    if self.buddhaDesc ~=nil then
        self.buddhaDesc:removeSelf()
        self.buddhaDesc =nil
    end

    if ((flag and buddhaModel.buddhaState_ ~=nil and buddhaModel.buddhaState_==1) or (flag == false and tonumber(buddhaModel.firstTurnUp_) ~=nil and tonumber(buddhaModel.firstTurnUp_) < CloudData.STAGE_PROGRESS))then
        if self.selectedIdx ~= nil then
            self.buddhaIconTable_[self.selectedIdx]:selectedInWiki(true)
        end
        
        -- 先检查是否存在
        if(cc.FileUtils:getInstance():isFileExist(string.format("armature/%s/%s.csb",buddhaModel.hurtFrame_,buddhaModel.hurtFrame_))) then
            ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(string.format("armature/%s/%s.csb",
                buddhaModel.hurtFrame_,buddhaModel.hurtFrame_))
            self.armature_ = ccs.Armature:create(buddhaModel.hurtFrame_)
            self.armature_:setPosition(self.wikiframe:getContentSize().width * 0.3,self.wikiframe:getContentSize().height * 0.42)
            self.armature_:setScale(buddhaModel.adaptScale_)
            self.armature_:getAnimation():playWithIndex(0)
            self.wikiframe:addChild(self.armature_,1)
        end

        --显示兵种描述，初始化为第一个
        self.buddhaDesc = cc.ui.UILabel.new({
            UILabelType = 2,text = string.format(buddhaModel.npcDesc_),align = cc.ui.TEXT_ALIGN_LEFT,size = 20,color = cc.c3b(100,47,5),dimensions = cc.size(470, 200),font = GameManager.FONTNAME_TTF})
            :align(display.LEFT_CENTER,self.wikiframe:getContentSize().width *0.07,self.wikiframe:getContentSize().height * 0.14)
            :addTo(self.wikiframe)

    else
        --print("改变选中状态1")
        self.selectedIdx = nil
        self.buddhaDesc = cc.ui.UILabel.new({
            UILabelType = 2,text = string.format('该兵种还未获得或未出现'),align=cc.ui.TEXT_ALIGN_CENTER,size = 20,color = cc.c3b(100,47,5),dimensions = cc.size(470, 200),font = GameManager.FONTNAME_TTF})
            :align(display.LEFT_CENTER,self.wikiframe:getContentSize().width *0.07,self.wikiframe:getContentSize().height * 0.14)
            :addTo(self.wikiframe)
    end


    --显示兵种名称的label，始化为第一个
    self.buddhalName = cc.ui.UILabel.new({
        UILabelType = 2,align=cc.ui.TEXT_ALIGN_CENTER,text = string.format(buddhaModel.name_),size = 30,color = cc.c3b(255,255,255),dimensions = cc.size(210, 36),font = GameManager.FONTNAME_TTF})
        :align(display.LEFT_CENTER,self.wikiframe:getContentSize().width *0.19,self.wikiframe:getContentSize().height * 0.92)
        :addTo(self.wikiframe)
end


--当切换到budda模型之后重新加载listview的数据
function WikiScene:LoadBuddhaToView()
    print("LoadBuddhaToView")
    self.buddhaBtn:setButtonEnabled(false)
    self.monsterBtn:setButtonEnabled(true)

    self.listView:removeAllItems()
    self.buddhaIconTable_ = nil
    self.buddhaIconTable_ = {}
    --行数
    local row               = math.ceil(#self.buddhaModelTable_ / 3)
    local column            = #self.buddhaModelTable_ % 3
    local endNum = 3
    --已经具备的神仙ID


    local firstBuddha = nil
    for i = 1,row do
        local item = self.listView:newItem()
        local content = display.newNode()

        if i == row then
            endNum = column
        end
        for count = 1,endNum do
            local buddhaModel = self.buddhaModelTable_[(i - 1) * 3 + count]

            if buddhaModel.buddhaState_ == 1 then
                local buddhaIcon = BuddhaIcon.new(buddhaModel)
                buddhaIcon:setScale(0.95)
                --x坐标根据中心的位置，往右按照列数偏移
                buddhaIcon:setPosition((count-1)*115+60,60)
                buddhaIcon:setTouchSwallowEnabled(false)
                content:addChild(buddhaIcon)
                table.insert(self.buddhaIconTable_,buddhaIcon)
                if not firstBuddha then
                    firstBuddha = (i - 1) * 3 + count
                end
            else
                local iconFrame = display.newSprite("wiki/frame_tp.png")
                local icon_ = display.newSprite("wiki/q0.png",iconFrame:getContentSize().width * 0.5,iconFrame:getContentSize().height * 0.5):addTo(iconFrame)
                iconFrame:setPosition((count-1)*115+60,60)
                content:addChild(iconFrame)
                table.insert(self.buddhaIconTable_,iconFrame)

            end
        end

        content:setContentSize(350, 120)
        item:addContent(content)
        item:setItemSize(350, 120)
        self.listView:addItem(item)
    end
    self.listView:reload()

    --1代表buddla
    self.state=1
    if firstBuddha then
        --	print("改变选中状态2")
        --	print("第一个神仙 ".. self.buddhaModelTable_[1].buddhaState_)
        self.selectedIdx = firstBuddha
        self.buddhaIconTable_[firstBuddha]:selectedInWiki(true)
    else
        --	print("改变选中状态3")
        self.selectedIdx = nil
    end

    --将初始化的NPC信息为第一个
    local buddhaModel= self.buddhaModelTable_[1]
    self:ChangeInfo(buddhaModel, true)
end

--当切换到monster模型之后重新加载listview的数据
function WikiScene:LoadMonsterToView()
    print("LoadMonsterToView")
    self.buddhaBtn:setButtonEnabled(true)
    self.monsterBtn:setButtonEnabled(false)
    self.listView:removeAllItems()
    --行数
    local row               = math.ceil(#self.monsterModelTable_ / 3)
    local column            = #self.monsterModelTable_ % 3
    local endNum = 3
    --已经具备的神仙ID
    local buddhaTableIsHave = DataUtils.getBuddhaIdsTableTeamScene()

    self.buddhaIconTable_ = nil
    self.buddhaIconTable_ = {}
    local firstBuddha = nil
    for i = 1,row do
        local item = self.listView:newItem()
        local content = display.newNode()

        if i == row then
            endNum = column
        end
        for count = 1,endNum do
            local monsterModel = self.monsterModelTable_[(i - 1) * 3 + count]
            if tonumber(monsterModel.firstTurnUp_) < CloudData.STAGE_PROGRESS then
                local monsterIcon = MonsterIcon.new(monsterModel)
                monsterIcon:setScale(0.95)
                --x坐标根据中心的位置，往右按照列数偏移
                monsterIcon:setPosition((count-1)*115+60,60)
                monsterIcon:setTouchSwallowEnabled(false)
                content:addChild(monsterIcon)
                table.insert(self.buddhaIconTable_,monsterIcon)
                if not firstBuddha then
                    firstBuddha = (i - 1) * 3 + count
                end
            else
                local iconFrame = display.newSprite("wiki/frame_tp.png")
                local icon_ = display.newSprite("wiki/q0.png",iconFrame:getContentSize().width * 0.5,iconFrame:getContentSize().height * 0.5):addTo(iconFrame)
                iconFrame:setPosition((count-1)*115+60,60)
                content:addChild(iconFrame)
                table.insert(self.buddhaIconTable_,iconFrame)
            end
        end

        content:setContentSize(350, 120)
        item:addContent(content)
        item:setItemSize(350, 120)
        self.listView:addItem(item)
    end
    self.listView:reload()

    --2代表buddla
    self.state=2
    if firstBuddha then
        --	print("改变选中状态4")
        self.selectedIdx = firstBuddha
        self.buddhaIconTable_[firstBuddha]:selectedInWiki(true)
    else
        --	print("改变选中状态5")
        self.selectedIdx = nil
    end

    --将初始化的NPC信息为第一个
    local buddhaModel= self.monsterModelTable_[1]
    self:ChangeInfo(buddhaModel, false)
end

function WikiScene:initBuddhaInfo_()
    --存储兵种Table
    self.buddhaModelTable_ = DataUtils.getBuddhaModelsTableUpgradeScene("BUDDHA")
    self.monsterModelTable_ =  DataUtils.getMonsterModelTable()
    print('!!!!!!!!!!!!!!'..#self.monsterModelTable_)
    --存储ListView的content
    self.contentTable_ = {}
    print("initBuddhaInfo_")
end



function WikiScene:returnCallBack_()
    if GameManager.SOUND_SWITCH_ON then
        audio.playSound(string.format("sounds/sfx_touch_shu.%s",GameManager.POSTFIX))
    end

    display.replaceScene(require("scenes.ChapterScene").new())
end

function WikiScene:onEnter()
end

function WikiScene:onExit()
end

function WikiScene:touchListener(event)
    if "clicked" == event.name then
        --	print(self.selectedIdx)
        if self.selectedIdx then
            --	print("去掉选中".. self.selectedIdx)
            self.buddhaIconTable_[self.selectedIdx]:selectedInWiki(false)
        end
        local column = math.ceil(event.point.x / 120)
        local idx = (event.itemPos - 1) * 3 + column
        if self.state == 1 then
            if idx >= 0 and idx <= #self.buddhaModelTable_ then
                --	print("buddha--idx = " .. idx)
                --	print("改变选中状态6")
                self.selectedIdx = idx
                self:ChangeInfo(self.buddhaModelTable_[idx],true)
            end
        else
            if idx >= 0 and idx <= #self.monsterModelTable_ then
                --	print("monster--idx = " .. idx)
                --	print("改变选中状态7")
                self.selectedIdx = idx
                self:ChangeInfo(self.monsterModelTable_[idx],false)
            end
        end
    end
end

function WikiScene:addAndroidReturnButton_()
    --退出游戏
    local btn = cc.ui.UIPushButton.new():addTo(self)
    btn:setKeypadEnabled(true)
    btn:addNodeEventListener(cc.KEYPAD_EVENT, function (event)
        if event.key == "back" then
            self:showReturnWarning_()
        end
    end)
end

function WikiScene:showReturnWarning_()
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

return WikiScene
