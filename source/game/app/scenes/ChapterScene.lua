
local SceneIcon          = import("icons.SceneIcon")
local ChapterIcon        = import("icons.ChapterIcon")
local AchievementLayer   = import("layers.AchievementLayer")
local ChapterLayer       = import("layers.ChapterLayer")
local DiaryLayer         = import("layers.DiaryLayer")
local SignLayer          = import("layers.SignLayer")
local SetLayer           = import("layers.SetLayer")
local TrialLayer         = import("layers.TrialLayer")
local PaymentLayer       = import("layers.PaymentLayer")
local DataLabelIcon      = import("icons.DataLabelIcon")
local NoviceGuide        = import("utils.NoviceGuide")
local GameDialogue       = import("utils.GameDialogue")
local AlertConnection    = import("customs.AlertConnection")
local FirstRechargeLayer = import("layers.FirstRechargeLayer")
local ActivityCodeLayer  = import("layers.ActivityCodeLayer")
local TreasureShowLayer  = import("layers.TreasureShowLayer")
local SpinLayer          = import("layers.SpinLayer")
local ActivityStageLayer = import("layers.ActivityStageLayer")
--local DiaryResultLayer = import("..layers.DiaryResultLayer")
local AlertSceneIconAniLayer = import("layers.AlertSceneIconAniLayer")
local AlertItemCastAniLayer  = import("layers.AlertItemCastAniLayer")
local NoticeLayer            = import("layers.NoticeLayer")
local WSToast                = import("utils.WSToast")
local ServerMaintainLayer    = import("layers.ServerMaintainLayer")
local SurveyLayer            = import("layers.SurveyLayer")
local CumulateRechargeLayer  = import("layers.CumulateRechargeLayer")

local ChapterScene = {}
ChapterScene = class("ChapterScene",function()
    return display.newScene("ChapterScene")
end)

TAG_SIGN_NEW              = 1         --签到上的"new"提示
TAG_RECHARGE_NEW          = 2         --充值上的"new"提示
TAG_LOTTERY_NEW           = 3         --抽奖上的"new"提示
TAG_LIMITED_TIME_RECHARGE = 4         --限时充值未完成
TAG_MAIL_NEW              = 5         --新邮件提示

function ChapterScene:ctor()

    --打印纹理缓存
    --local info = cc.Director:getInstance():getTextureCache():getCachedTextureInfo()
    --print(info)

    if not audio.isMusicPlaying() and GameManager.MUSIC_SWITCH_ON then
        if(cc.FileUtils:getInstance():isFileExist(string.format("sounds/bgm_theme.%s",GameManager.POSTFIX))) then
            audio.playMusic(string.format("sounds/bgm_theme.%s",GameManager.POSTFIX))
        else
            audio.playMusic(string.format("sounds/bgm_theme_night.%s",GameManager.POSTFIX))
        end
    end

    -- 弹出公告
    --self:showNotice_()

    -- 初始化部分参数
    self:initParamData_()        

    -- 背景图
    self.bg_ = display.newSprite("chapter/bg_frame.png",display.cx,display.cy):addTo(self,1)

    -- 加载上方游戏数据标签
    self:initTopInfoUI()

    -- 加载中央滚动视图
    self:initCenterScrollMap()

    -- 加载底部各场景入口
    self:initBottomSceneEntrance()

    -- 加载通天塔(无尽模式)入口
    self:initInfiniteModeEntrance()

    -- 加载左侧按钮
    self:initLeftButton()

    -- 处理新手引导，用户功能解锁
    self:dealUserProgress()

    -- 计时器
    self.schedule_ = self:schedule(function()
        self:updateChapterScene_()
    end, 0.1)

    self:addAndroidReturnButton_()
end

--初始化部分数据
function ChapterScene:initParamData_()
    -- --联网同步体力K
    -- local ac = AlertConnection.new(CONNECTION_CHAPTER)
    --    self:addChild(ac,100)

    --联网加载数据(主要用于任务等界面的"new"提示)
    local ac = AlertConnection.new(CONNECTION_CHAPTER_NEW_INFO)
    self:addChild(ac,100,12346)

    self.scheduleCH_ = self:schedule(function()
        if not self:getChildByTag(12346) then
            self:stopAction(self.scheduleCH_)

            -- 加载右侧按钮
            self:initRightButton()

            -- 活动关卡按钮
            self:initActivityStageButton()

            self:getIsSummonFree_()
            self:getIsTreasureCompleted_()
            self:getIsAchievementCompleted_()

            --精力下方倒计时(提示还有多长时间恢复一点精力)
            if CloudData.ENERGY < CloudData.MAX_ENERGY then
                local t1 = CloudData.TIME_SERVER % 3600
                local t2 = t1 % 60
                local seconds = 60 - t2
                local energyTimeLabel = cc.ui.UILabel.new({UILabelType = 2,text = string.format("00:%02d",seconds),size = 30,font = GameManager.FONTNAME_TTF})
                    :align(display.CENTER,display.width * 0.5 - display.height * 0.5,display.height * 0.84)
                    :addTo(self,15)

                self.energyTimeSchedule_ = self:schedule(function()
                    if seconds > 0 and seconds <= 60 then
                        seconds = seconds - 1
                        energyTimeLabel:setString(string.format("00:%02d",seconds))
                    else
                        seconds = 59
                        CloudData.ENERGY = CloudData.ENERGY + 1
                        energyTimeLabel:setString(string.format("00:%02d",seconds))
                        if CloudData.ENERGY >= CloudData.MAX_ENERGY then
                            energyTimeLabel:setVisible(false)
                            self:stopAction(self.energyTimeSchedule_)
                        end
                    end
                end,1.0)
            end

            -- print("a = ···"..CloudData.BUDDHA_NUM)
            -- print("b = ···"..CloudData.DAILY_TASK_INFO[4])
            -- print("c = ···"..CloudData.CHAPTER_TASK_INFO[4])
            -- print("d = ···"..CloudData.ENERGY)
            -- print("e = ···"..CloudData.MAX_ENERGY)
            -- print("f = ···"..CloudData.NEXT_FREESUMMON_TIME_EXP)
            -- print("g = ···"..CloudData.NEXT_FREESUMMON_TIME_PEACH)
            -- print("h = ···"..CloudData.FREE_SUMMON_NUM_EXP)
            -- print("i = ···"..CloudData.PAYMENT_ITEM_STATE[3])
        end
    end,0.1)

    --用户关卡进度
    self.stageProgress_ = CloudData.STAGE_PROGRESS

    -- 返回章节界面此处置0
    GameManager.STAGE_NUM = 0
end

--弹出公告面板
-- function ChapterScene:showNotice_()
--     --local tag = GameManager.SHOW_NOTICE
--     --local date = nil

--     if CloudData.STAGE_PROGRESS < 1 then
--         CloudData.NOTICE_SHOWED = true
--     end

--     if not CloudData.NOTICE_SHOWED then
--         local notice = NoticeLayer.new()
--         self:addChild(notice,20)                       
--     end       
-- end

--处理新手引导，用户功能解锁
function ChapterScene:dealUserProgress()
    if self.stageProgress_ == 0 then
        --引导点击第一章的章节按钮
        if not DataUtils.getGuideIsFirstPlayed("GUIDE_STEP_SELECT_CHAPTER") then
            local guide = NoviceGuide.new(GUIDE_STEP_SELECT_CHAPTER)
            self:addChild(guide,50)
            DataUtils.setGuideIsFirstPlayed("GUIDE_STEP_SELECT_CHAPTER",true)
        end
    end

    if self.stageProgress_ == 1 then
        if not DataUtils.getDialogueIsFirstPlayed("DIALOGUE_TIANJIANG_UNLOCK") then  --播放小天将出场的剧情
            local dialogue = GameDialogue.new(DIALOGUE_TIANJIANG_UNLOCK)
            self:addChild(dialogue,50)
            DataUtils.setDialogueIsFirstPlayed("DIALOGUE_TIANJIANG_UNLOCK",true)

        elseif not DataUtils.getSceneIsUnlock("TEAM_SCENE") then                     --开启队伍界面
            local asi = AlertSceneIconAniLayer.new(1)
            self:addChild(asi,50)
            DataUtils.setSceneIsUnlock("TEAM_SCENE",true)

        elseif not DataUtils.getGuideIsFirstPlayed("GUIDE_STEP_ENTER_TEAMSCENE") then     --引导进入队伍界面
            local guide = NoviceGuide.new(GUIDE_STEP_ENTER_TEAMSCENE)
            self:addChild(guide,50)
            DataUtils.setGuideIsFirstPlayed("GUIDE_STEP_ENTER_TEAMSCENE",true)
        end
    end

    if self.stageProgress_ == 2 then
        if not DataUtils.getDialogueIsFirstPlayed("DIALOGUE_UPGRADE") then  --播放剧情(升级功能开放)
            local dialogue = GameDialogue.new(DIALOGUE_UPGRADE)
            self:addChild(dialogue,50)
            DataUtils.setDialogueIsFirstPlayed("DIALOGUE_UPGRADE",true)

        elseif not DataUtils.getSceneIsUnlock("UPGRADE_SCENE") then         --开启升级界面
            local asi = AlertSceneIconAniLayer.new(2)
            self:addChild(asi,50)
            DataUtils.setSceneIsUnlock("UPGRADE_SCENE",true)

        elseif not DataUtils.getGuideIsFirstPlayed("GUIDE_STEP_ENTER_UPGRADESCENE") then     --引导进入升级界面
            local guide = NoviceGuide.new(GUIDE_STEP_ENTER_UPGRADESCENE)
            self:addChild(guide,50)
            DataUtils.setGuideIsFirstPlayed("GUIDE_STEP_ENTER_UPGRADESCENE",true)
        end
    end

    if self.stageProgress_ == 3 then
        if not DataUtils.getSceneIsUnlock("SUMMON_SCENE") then            --开启召唤界面
            local asi = AlertSceneIconAniLayer.new(3)
            self:addChild(asi,50)
            DataUtils.setSceneIsUnlock("SUMMON_SCENE",true)

        elseif not DataUtils.getGuideIsFirstPlayed("GUIDE_STEP_ENTER_SUMMONSCENE") then     --引导进入召唤界面
            local guide = NoviceGuide.new(GUIDE_STEP_ENTER_SUMMONSCENE)
            self:addChild(guide,50)
            DataUtils.setGuideIsFirstPlayed("GUIDE_STEP_ENTER_SUMMONSCENE",true)

        elseif DataUtils.getGuideIsFirstPlayed("GUIDE_STEP_ENTER_SUMMONSCENE") and          --引导进入队伍界面上阵好孩子小胖
            not DataUtils.getGuideIsFirstPlayed("GUIDE_STEP_SHASENG_ON_TEAM") then
            local guide = NoviceGuide.new(GUIDE_STEP_ENTER_TEAMSCENE)
            self:addChild(guide,50)
        end
    end

    if self.stageProgress_ == 4 then
        if not DataUtils.getDialogueIsFirstPlayed("DIALOGUE_TREASURE") then  --播放剧情(宝物功能开放)
            local dialogue = GameDialogue.new(DIALOGUE_TREASURE)
            self:addChild(dialogue,50)
            DataUtils.setDialogueIsFirstPlayed("DIALOGUE_TREASURE",true)

        elseif not DataUtils.getSceneIsUnlock("TREASURE_SCENE") then         --开启宝物界面
            local asi = AlertSceneIconAniLayer.new(4)
            self:addChild(asi,50)
            DataUtils.setSceneIsUnlock("TREASURE_SCENE",true)

        elseif not DataUtils.getGuideIsFirstPlayed("GUIDE_STEP_ENTER_TREASURESCENE") then     --引导进入宝物界面
            local guide = NoviceGuide.new(GUIDE_STEP_ENTER_TREASURESCENE)
            self:addChild(guide,50)
            DataUtils.setGuideIsFirstPlayed("GUIDE_STEP_ENTER_TREASURESCENE",true)
        end
    end

    if self.stageProgress_ == 5 then
        if not DataUtils.getSceneIsUnlock("ACHIEVEMENT_LAYER") then        --开启成就页面
            local asi = AlertSceneIconAniLayer.new(5)
            self:addChild(asi,50)
            DataUtils.setSceneIsUnlock("ACHIEVEMENT_LAYER",true)

        elseif not DataUtils.getGuideIsFirstPlayed("GUIDE_STEP_OPEN_ACHIEVEMENT") then
            local guide = NoviceGuide.new(GUIDE_STEP_OPEN_ACHIEVEMENT)
            self:addChild(guide,50)
            DataUtils.setGuideIsFirstPlayed("GUIDE_STEP_OPEN_ACHIEVEMENT",true)
        end
    end

    if self.stageProgress_ == 6 then
        if not DataUtils.getSceneIsUnlock("SHOP_SCENE") then        --开启商店界面
            local asi = AlertSceneIconAniLayer.new(6)
            self:addChild(asi,50)
            DataUtils.setSceneIsUnlock("SHOP_SCENE",true)

        elseif not DataUtils.getGuideIsFirstPlayed("GUIDE_STEP_UNLOCK_MONSTER1") then     --引导召唤妖怪
            local guide = NoviceGuide.new(GUIDE_STEP_UNLOCK_MONSTER1)
            self:addChild(guide,50)
            DataUtils.setGuideIsFirstPlayed("GUIDE_STEP_UNLOCK_MONSTER1",true)
        end
    end

    if self.stageProgress_ == 7 then
        if not DataUtils.getGuideIsFirstPlayed("to_upgrade_tower") then     --引导升级防御塔
            local guide = NoviceGuide.new(GUIDE_STEP_ENTER_UPGRADESCENE)
            self:addChild(guide,50)
            DataUtils.setGuideIsFirstPlayed("to_upgrade_tower",true)
        end
    end

    if self.stageProgress_ == 9 then
        if not DataUtils.getGuideIsFirstPlayed("to_upgrade_tang") then     --引导升级防御塔
            local guide = NoviceGuide.new(GUIDE_STEP_ENTER_UPGRADESCENE)
            self:addChild(guide,50)
            DataUtils.setGuideIsFirstPlayed("to_upgrade_tang",true)
        end
    end

    if self.stageProgress_ == 10 and not DataUtils.getChapterIsUnlock(2) then
        DataUtils.setChapterIsUnlock(2,true)
        --播放解锁动画
        self:chapterUnlockAnimation_(2)
    end
    if self.stageProgress_ == 20 and not DataUtils.getChapterIsUnlock(3) then
        DataUtils.setChapterIsUnlock(3,true)
        --播放解锁动画
        self:chapterUnlockAnimation_(3)
    end
    if self.stageProgress_ == 30 and not DataUtils.getChapterIsUnlock(4) then
        DataUtils.setChapterIsUnlock(4,true)
        --播放解锁动画
        self:chapterUnlockAnimation_(4)
    end
    if self.stageProgress_ == 40 and not DataUtils.getChapterIsUnlock(5) then
        DataUtils.setChapterIsUnlock(5,true)
        --播放解锁动画
        self:chapterUnlockAnimation_(5)
    end
    if self.stageProgress_ == 50 and not DataUtils.getChapterIsUnlock(6) then
        DataUtils.setChapterIsUnlock(6,true)
        --播放解锁动画
        self:chapterUnlockAnimation_(6)
    end
    if self.stageProgress_ == 60 and not DataUtils.getChapterIsUnlock(7) then
        DataUtils.setChapterIsUnlock(7,true)
        --播放解锁动画
        self:chapterUnlockAnimation_(7)
    end
    if self.stageProgress_ == 70 and not DataUtils.getChapterIsUnlock(8) then
        DataUtils.setChapterIsUnlock(8,true)
        --播放解锁动画
        self:chapterUnlockAnimation_(8)
    end
end

--上方标签的UI布局
function ChapterScene:initTopInfoUI()
    --精力
    local energyLabel = DataLabelIcon.new(DataLabelIcon.LABEL_TYPE_ENERGY,true)
    energyLabel:setPosition(cc.p(display.width * 0.5 - display.height * 0.5,display.height * 0.94))
    self:addChild(energyLabel,15)
    --经验
    local expLabel = DataLabelIcon.new(DataLabelIcon.LABEL_TYPE_EXP,true)
    expLabel:setPosition(cc.p(display.width * 0.5,display.height * 0.94))
    self:addChild(expLabel,15)
    --蟠桃
    local peachLabel = DataLabelIcon.new(DataLabelIcon.LABEL_TYPE_PEACH,true)
    peachLabel:setPosition(cc.p(display.width * 0.5 + display.height * 0.5,display.height * 0.94))
    self:addChild(peachLabel,15)
end

--滚动地图
function ChapterScene:initCenterScrollMap()

    self.mapNode_ = display.newNode()

    --存储章节图标
    self.chapterIconsTable_ = {}

    --当前解锁到的章节序号
    local chapterUnlockNum =  math.floor(CloudData.STAGE_PROGRESS / 10) + 1       --(floor:向下取整；ceil:向上取整)
    --计数(自加，方便区别各章节序号)
    local chapterCount = 0
    --从csv配置文件读取章节的位置
    local chapterLocationTable = DataUtils.getChapterLocationTable()

    for i = 1, 2 do
        local mapSprite = display.newSprite("chapter/map0"..i..".jpg")
        self.mapSize_ = mapSprite:getContentSize()
        mapSprite:setAnchorPoint(0,0)
        mapSprite:setPosition((i - 1) * self.mapSize_.width, 0)
        self.mapNode_:addChild(mapSprite)
        local endNum = 0
        if i == 1 then
            endNum = 3
        else
            endNum = 5
        end
        for j = 1, endNum do
            --开始计数，自加
            chapterCount = chapterCount + 1
            --读取位置
            local chapterPoint = chapterLocationTable[j + (i - 1) * 3]
            --创建章节精灵
            local chapterIcon = ChapterIcon.new(1, chapterCount)
            if chapterCount <= chapterUnlockNum then      --已解锁章节
                if (CloudData.STAGE_PROGRESS % 10 == 0) and (chapterCount == chapterUnlockNum) and (not DataUtils.getChapterIsUnlock(chapterCount)) then
                    chapterIcon = ChapterIcon.new(2,chapterCount)
                    --刚解锁该章节时播放解锁动画
                    self.lockPic_ = display.newSprite("chapter/lock_pic.png",chapterPoint.x + 10,chapterPoint.y):addTo(mapSprite,3)
                    self.lockPic_:setScale(1.5)
            else
                chapterIcon = ChapterIcon.new(1,chapterCount)

                --指向当前解锁的最大章节的箭头动画
                if chapterCount == chapterUnlockNum then
                    local point1 = cc.p(chapterPoint.x + 15,chapterPoint.y + 50)
                    local point2 = cc.p(chapterPoint.x + 15,chapterPoint.y + 100)

                    local mark = display.newSprite("chapter/mark.png",point2.x,point2.y):addTo(mapSprite,3)
                    mark:runAction(cc.RepeatForever:create(transition.sequence({cc.MoveTo:create(0.5,point1),
                        cc.MoveTo:create(0.5,point2)})))
                end
            end
            else
                chapterIcon = ChapterIcon.new(2,chapterCount)

                --上锁
                local lockPic = display.newSprite("chapter/lock_pic.png",chapterPoint.x + 10,chapterPoint.y):addTo(mapSprite,3)
                lockPic:setScale(1.5)
            end

            chapterIcon:setPosition(chapterPoint.x,chapterPoint.y)
            mapSprite:addChild(chapterIcon,2)
            chapterIcon:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
                return self:onTouch(event.name,event.x,event.y)
            end)
            table.insert(self.chapterIconsTable_,chapterIcon)
        end
    end

    if CloudData.STAGE_PROGRESS < 30 then
        self.mapNode_:setPosition(display.cx - self.mapSize_.width * 0.5 - 50,display.cy - self.mapSize_.height * 0.5 - 10)
    else
        self.mapNode_:setPosition(display.cx - self.mapSize_.width * 1.5 + 150,display.cy - self.mapSize_.height * 0.5 - 10)
    end
    self:addChild(self.mapNode_,0)
    self.mapNode_:setTouchEnabled(true)

    self.mapNode_:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        return self:onTouch(event.name,event.x,event.y)
    end)

    self:initTrialIcon()
end

-- 试炼入口
function ChapterScene:initTrialIcon()
    self.challengeStage = CloudData.CHALLENGE_PROGRESS + 1
    if self.challengeStage > 8 then
        return
    end
    local CSVParser = import("utils.CSVParser")
--    local cStageInfo = CSVParser.new("profiles/c_stage.csv")
    local cStageInfo = CSVParser.new(import("profiles.c_stage"),true)
    self.trialRequireStage = tonumber(cStageInfo:objectAtIndex(self.challengeStage)["requireStage"])
    local pos = cc.p(769,120)

    if self.stageProgress_ < self.trialRequireStage then
        local floatIcon = display.newSprite("trial/gray.png")
            :pos(pos.x, pos.y)
            :addTo(self.mapNode_, 3)
        floatIcon:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
            return self:clickTrial_(event.name,event.x,event.y)
        end)
        floatIcon:setTouchEnabled(true)

        display.newSprite("trial/gray_icon.png")
            :pos(pos.x, pos.y + 65)
            :addTo(self.mapNode_, 3)

    else
        display.addSpriteFrames("trial/trail_icon.plist","trial/trail_icon.png")

        local frames = display.newFrames("trail_icon%d.png",1,4)
        local animation = display.newAnimation(frames,0.07)
        local sp = display.newSprite()
            :pos(pos.x,pos.y)
            :addTo(self.mapNode_,3)
        sp:playAnimationForever(animation)
        sp:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
            return self:clickTrial_(event.name,event.x,event.y)
        end)
        sp:setTouchEnabled(true)

        local floatIcon = display.newSprite("trial/icon.png")
            :pos(pos.x, pos.y + 40)
            :addTo(self.mapNode_, 3)

        local mov1 = cc.MoveTo:create(1.0, cc.p(pos.x, pos.y + 55))
        local mov2 = cc.MoveTo:create(1.0, cc.p(pos.x, pos.y + 40))
        floatIcon:runAction(cc.RepeatForever:create(transition.sequence({mov1,mov2})))

        --引导挑战关卡
        if self.stageProgress_ == 15 and not DataUtils.getGuideIsFirstPlayed("GUIDE_STEP_CHALLENGE") then
            local guide = NoviceGuide.new(GUIDE_STEP_CHALLENGE)
            self:addChild(guide,50)
            DataUtils.setGuideIsFirstPlayed("GUIDE_STEP_CHALLENGE",true)
        end
    end
end

-- 通天塔(无尽模式)入口
function ChapterScene:initInfiniteModeEntrance()
    if self.stageProgress_ < 26 then
        local infiniteBtn = cc.ui.UIPushButton.new("chapter/tower_pic_u.png")
        :pos(756,340)
        :onButtonClicked(function(event)
            local t = WSToast.new("通天塔26关开启",1.0)
            self:addChild(t,100)
        end)
        :addTo(self.mapNode_,1)

        return
    else
        local infiniteBtn = cc.ui.UIPushButton.new("chapter/tower_pic.png")
        :pos(756,340)
        :onButtonClicked(function(event)
            display.replaceScene(require("scenes.InfiniteModeEntrance").new())
        end)
        :addTo(self.mapNode_,1)

        local floatIcon = display.newSprite("game_infinite/float.png")
            :scale(0.83)
            :pos(760, 420)
            :addTo(self.mapNode_, 3)

        local mov1 = cc.MoveTo:create(1.12, cc.p(760, 420))
        local mov2 = cc.MoveTo:create(1.05, cc.p(760, 405))
        floatIcon:runAction(cc.RepeatForever:create(transition.sequence({mov2,mov1})))

        --引导通天塔
        if self.stageProgress_ == 26 and not DataUtils.getGuideIsFirstPlayed("GUIDE_STEP_INFINITEMODE") then
            local guide = NoviceGuide.new(GUIDE_STEP_INFINITEMODE)
            self:addChild(guide,50)
            DataUtils.setGuideIsFirstPlayed("GUIDE_STEP_INFINITEMODE",true)
        end
    end   
end

--下方场景入口的UI布局
function ChapterScene:initBottomSceneEntrance()
    self.sceneIconsTable_ = {}

    local icon1 = SceneIcon.new(1)
    icon1:setVisible(false)
    icon1:setPosition(display.cx - display.height * 0.625,display.height * 0.1)
    self:addChild(icon1,2)
    icon1:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        return self:onTouch(event.name,event.x,event.y)
    end)
    table.insert(self.sceneIconsTable_,icon1)
    if CloudData.STAGE_PROGRESS > 1 or DataUtils.getSceneIsUnlock("TEAM_SCENE") then
        icon1:setVisible(true)
    end

    local icon2 = SceneIcon.new(2)
    icon2:setVisible(false)
    icon2:setPosition(display.cx - display.height * 0.375,display.height * 0.1)
    self:addChild(icon2,2)
    icon2:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        return self:onTouch(event.name,event.x,event.y)
    end)
    table.insert(self.sceneIconsTable_,icon2)
    if CloudData.STAGE_PROGRESS > 2 or DataUtils.getSceneIsUnlock("UPGRADE_SCENE") then
        icon2:setVisible(true)
        if GameManager.IS_HAVE_NEW_BUDDHA then
            icon2:setMarkVisible(true)
        else
            icon2:setMarkVisible(false)
        end
    end

    local icon3 = SceneIcon.new(3)
    icon3:setVisible(false)
    icon3:setPosition(display.cx - display.height * 0.125,display.height * 0.1)
    self:addChild(icon3,2)
    icon3:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        return self:onTouch(event.name,event.x,event.y)
    end)
    table.insert(self.sceneIconsTable_,icon3)
    if CloudData.STAGE_PROGRESS > 3 or DataUtils.getSceneIsUnlock("SUMMON_SCENE") then
        icon3:setVisible(true)
        icon3:setMarkVisible(false)
        --self:getIsSummonFree_()
    end

    local icon4 = SceneIcon.new(4)
    icon4:setVisible(false)
    icon4:setPosition(display.cx + display.height * 0.125,display.height * 0.1)
    self:addChild(icon4,2)
    icon4:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        return self:onTouch(event.name,event.x,event.y)
    end)
    table.insert(self.sceneIconsTable_,icon4)
    if CloudData.STAGE_PROGRESS > 4 or DataUtils.getSceneIsUnlock("TREASURE_SCENE") then
        icon4:setVisible(true)
        --self:getIsTreasureCompleted_()
    end

    local icon5 = SceneIcon.new(5)
    icon5:setVisible(false)
    icon5:setPosition(display.cx + display.height * 0.375,display.height * 0.1)
    self:addChild(icon5,2)
    icon5:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        return self:onTouch(event.name,event.x,event.y)
    end)
    table.insert(self.sceneIconsTable_,icon5)
    if CloudData.STAGE_PROGRESS > 5 or DataUtils.getSceneIsUnlock("ACHIEVEMENT_LAYER") then
        icon5:setVisible(true)
        --self:getIsAchievementCompleted_()
    end

    local icon6 = SceneIcon.new(6)
    icon6:setVisible(false)
    icon6:setPosition(display.cx + display.height * 0.625,display.height * 0.1)
    self:addChild(icon6,2)
    icon6:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        return self:onTouch(event.name,event.x,event.y)
    end)
    table.insert(self.sceneIconsTable_,icon6)
    if CloudData.STAGE_PROGRESS > 6 or DataUtils.getSceneIsUnlock("SHOP_SCENE") then
        icon6:setVisible(true)
    end

    -- local icon7 = SceneIcon.new(7)
    -- icon7:setPosition(display.width * 0.05,display.height * 0.45)
    -- self:addChild(icon7,2)
    -- icon7:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    --        return self:onTouch(event.name,event.x,event.y)
    --    end)

    --self.sceneIconsTable_ = {icon1,icon2,icon3,icon4,icon5,icon6}
end

--左边按钮
function ChapterScene:initLeftButton()
    --签到
    local signBtn = cc.ui.UIPushButton.new("chapter/qiandao.png")
        :onButtonPressed(function(event)
            event.target:setScale(0.8)
            self:touchLeftButton_(1)
        end)
        :onButtonRelease(function(event)
            event.target:setScale(1.0)
        end)
        -- :onButtonClicked(function()
        -- 	self:touchLeftButton_(1)
        -- end)
        :align(display.CENTER,display.width * 0.05,display.height * 0.75)
        :zorder(2)
        :addTo(self)
    if not CloudData.IS_SIGNED_TODAY then
        --"new"提示
        local pNew = display.newSprite("common_ui/new.png",signBtn:getPositionX() + 20,display.height * 0.80)
            :addTo(self,3,TAG_SIGN_NEW)
        local seq = transition.sequence({cc.FadeOut:create(0.5),cc.FadeIn:create(0.5)})
        pNew:runAction(cc.RepeatForever:create(seq))
    end

    --设置按钮
    cc.ui.UIPushButton.new("chapter/set.png")
        :onButtonPressed(function(event)
            event.target:setScale(0.8)
            self:touchLeftButton_(2)
        end)
        :onButtonRelease(function(event)
            event.target:setScale(1.0)
        end)
        -- :onButtonClicked(function()
        --     self:touchLeftButton_(2)
        -- end)
        :align(display.CENTER,display.width * 0.05,display.height * 0.35)
        :zorder(2)
        :addTo(self)

    --抽奖按钮
    local lotteryBtn = cc.ui.UIPushButton.new("chapter/lottery.png")
        :onButtonPressed(function(event)
            event.target:setScale(0.8)
            self:touchLeftButton_(3)
        end)
        :onButtonRelease(function(event)
            event.target:setScale(1.0)
        end)
        -- :onButtonClicked(function()
        --     self:touchLeftButton_(3)
        -- end)
        :align(display.CENTER,display.width * 0.05,display.height * 0.55)
        :zorder(2)
        :addTo(self)
    if CloudData.DRAW_NUM == 0 then
        --"new"提示
        local pNew1 = display.newSprite("common_ui/new.png",lotteryBtn:getPositionX() + 20,display.height * 0.60)
            :addTo(self,3,TAG_LOTTERY_NEW)
        local seq1 = transition.sequence({cc.FadeOut:create(0.5),cc.FadeIn:create(0.5)})
        pNew1:runAction(cc.RepeatForever:create(seq1))
    end

    --公告按钮
    local noticeBtn = cc.ui.UIPushButton.new({normal = "chapter/notice.png", pressed = "chapter/notice1.png"})
        :onButtonClicked(function(event)
            self:touchLeftButton_(4)
        end)
        :align(display.CENTER,display.width * 0.17,display.height * 0.765)
        :zorder(2)
        :addTo(self)
    noticeBtn:setTag(99)

--    dump(CloudData.NOTICE_INFO,"chapter notice : ")
    -- if CloudData.NOTICE_INFO == nil or #(CloudData.NOTICE_INFO) <= 0 then       
    --     noticeBtn:setVisible(false)
    --     noticeBtn:setTouchEnabled(false)
    -- else       
    --     noticeBtn:setVisible(true)
    --     noticeBtn:setTouchEnabled(true)
    -- end
    if CloudData.STAGE_PROGRESS < 1 then
        CloudData.NOTICE_SHOWED = true
    end

    if not CloudData.NOTICE_SHOWED then
        local notice = NoticeLayer.new()
        self:addChild(notice,20)                       
    end
end

--右边按钮
function ChapterScene:initRightButton()
    --print("玩家累计充值总数：" .. CloudData.COST_MONEY)
    local cost = tonumber(CloudData.COST_MONEY)
    --首充按钮
    local btn1 = cc.ui.UIPushButton.new("chapter/first_recharge.png")
        :onButtonPressed(function(event)
            event.target:setScale(0.8)
            self:touchRightButton_(1)
        end)
        :onButtonRelease(function(event)
            event.target:setScale(1.0)
        end)
        -- :onButtonClicked(function()
        --     self:touchRightButton_(1)
        -- end)
        :align(display.CENTER,display.width - 64,display.height * 0.8)
        :zorder(2)
        :addTo(self)
    --"new"提示
    -- if tonumber(CloudData.FIRST_PURCHASE_STATE) == 1 then
    --     local pNew1 = display.newSprite("common_ui/new.png",display.width - 84,btn1:getPositionY() + 40)
    --         :addTo(self,3,TAG_FIRST_RECHARGE_NEW)
    --     local seq = transition.sequence({cc.FadeOut:create(0.5),cc.FadeIn:create(0.5)})
    --     pNew1:runAction(cc.RepeatForever:create(seq))
    -- end

    local pNew1 = display.newSprite("common_ui/new.png",btn1:getPositionX() + 20,btn1:getPositionY() + 40)
        :addTo(self,3,TAG_LIMITED_TIME_RECHARGE)
    local seq = transition.sequence({cc.FadeOut:create(0.5),cc.FadeIn:create(0.5)})
    pNew1:runAction(cc.RepeatForever:create(seq))
    pNew1:setVisible(false)

    if CloudData.SHOW_LIMITED_TIME_RECHARGE == 1 then 
        pNew1:setVisible(true)
    end

    --充值按钮
    local btn2 = cc.ui.UIPushButton.new("chapter/recharge.png")
        :onButtonPressed(function(event)
            event.target:setScale(0.8)
            self:touchRightButton_(2)
        end)
        :onButtonRelease(function(event)
            event.target:setScale(1.0)
        end)
        -- :onButtonClicked(function()
        --     self:touchRightButton_(2)
        -- end)
        :align(display.CENTER,display.width - 64,display.height * 0.65)
        :zorder(2)
        :addTo(self)

    if cost >= 500 and CloudData.SHOW_LIMITED_TIME_RECHARGE == 0 then --CloudData.FIRST_PURCHASE_STATE == 2 then
        btn1:hide()
        btn2:setPositionY(display.height * 0.75)
    end

    --"new"提示
    -- if tonumber(CloudData.PAYMENT_ITEM_STATE[1]) == 1 or tonumber(CloudData.PAYMENT_ITEM_STATE[2]) == 1 or tonumber(CloudData.PAYMENT_ITEM_STATE[3]) == 1 then
    --     local pNew = display.newSprite("common_ui/new.png",display.width - 84,btn2:getPositionY() + 40)
    --         :addTo(self,3,TAG_RECHARGE_NEW)
    --     local seq = transition.sequence({cc.FadeOut:create(0.5),cc.FadeIn:create(0.5)})
    --     pNew:runAction(cc.RepeatForever:create(seq))
    -- end


    --日常按钮
    local daily = cc.ui.UIPushButton.new("chapter/daily.png")
        :onButtonPressed(function(event)
            event.target:setScale(0.8)
            -- self:touchRightButton_(3)
        end)
        :onButtonRelease(function(event)
            event.target:setScale(1.0)
        end)
        :onButtonClicked(function()
            self:touchRightButton_(3)
        end)
        :align(display.CENTER,display.width - 64,display.height * 0.35)
        :zorder(2)
        :addTo(self)

    if self.stageProgress_ < 20 then
        daily:setVisible(false)
    else
        if self.stageProgress_ == 20 and not DataUtils.getGuideIsFirstPlayed("GUIDE_STEP_DAILY") then     --引导日常关卡
            local guide = NoviceGuide.new(GUIDE_STEP_DAILY)
            self:addChild(guide,50)
            DataUtils.setGuideIsFirstPlayed("GUIDE_STEP_DAILY",true)
        end
    end

    --邮箱按钮
    local msgBtn = cc.ui.UIPushButton.new("chapter/mail.png")
        :onButtonPressed(function(event)
            event.target:setScale(0.8)
            self:touchRightButton_(4)
        end)
        :onButtonRelease(function(event)
            event.target:setScale(1.0)
        end)
        :align(display.CENTER,display.width - 64,display.height * 0.5)
        :zorder(2)
        :addTo(self)
    msgBtn:setTag(100)

    if cost >= 500 and CloudData.SHOW_LIMITED_TIME_RECHARGE == 0 then --CloudData.FIRST_PURCHASE_STATE == 2 then
        msgBtn:setPositionY(display.height * 0.55)
    end

    local redPoint = display.newSprite("common_ui/red_point.png",msgBtn:getPositionX() + 37,msgBtn:getPositionY() + 35)
        :addTo(self,3)
    redPoint:setTag(TAG_MAIL_NEW)
    redPoint:setVisible(false)

    --加载本地存储的邮件读取情况
    if CloudData.READ_MSG_TABLE == nil then
        DataUtils.getReadMsgId()
    end

    --    CloudData.SERVER_MSG = {{msg = "服务器即将维修即将维修即将维修", title = "系统通知", remainSecond = 7200, id = 1,
    --            sendTime = "2013 02 10 00:05:20", goods1 = 5,goods2 = 10, goods3 = 100, goods4 = 87},
    --        {msg = "服务器ling奖励领取奖励领取奖励", title = "系统消息", remainSecond = 200, id = 2,
    --            sendTime = "2014 02 10 ", goods1 = 0,goods2 = 0, goods3 = 0, goods4 = 0},
    --        {msg = "活动开服活动开服活动开服活动开服活动开服", title = "系统公告", remainSecond = 5621, id = 3,
    --            sendTime = "2015 02 10 00:05:20", goods1 = 60,goods2 = 52, goods3 = 0, goods4 = 0}}
    for i=1, #CloudData.SERVER_MSG do
        local id = CloudData.SERVER_MSG[i].id
        local sid = string.format("%d",id)
        if CloudData.READ_MSG_TABLE[sid] == nil then
            --邮箱图标上加小红点
            redPoint:setVisible(true)
            break
        else
            redPoint:setVisible(false)
        end
    end

    --问卷调查按钮
    local surveyBtn = cc.ui.UIPushButton.new({normal = "chapter/survey.png", pressed = "chapter/survey1.png"})
        :onButtonClicked(function(event)
            self:touchRightButton_(5)
        end)
        :align(display.CENTER,display.width * 0.81,display.height * 0.805)
        :zorder(2)
        :addTo(self)
    surveyBtn:setVisible(false)
    surveyBtn:setTouchEnabled(false)
end

-- 活动关卡按钮
function ChapterScene:initActivityStageButton()
    if CloudData.ACTIVITY_STAGE_STATUS == 1 then
        local activityBtn = cc.ui.UIPushButton.new("chapter/activity.png")
            :onButtonPressed(function(event)
                event.target:setScale(0.9)
            end)
            :onButtonRelease(function(event)
                event.target:setScale(1.0)
            end)
            :onButtonClicked(function()
                local pLayer = ActivityStageLayer.new()
                self:addChild(pLayer,20)       
            end)
            :align(display.CENTER,self.bg_:getContentSize().width * 0.80,self.bg_:getContentSize().height * 0.78)
            :zorder(2)
            :addTo(self.bg_)

        -- 图标上的动画
        local sp = display.newSprite("activity_stage/circle.png",self.bg_:getContentSize().width * 0.80,self.bg_:getContentSize().height * 0.78)
            :addTo(self.bg_,2)
        sp:runAction(cc.RepeatForever:create(cc.RotateBy:create(1.0,-720)))
    end  
end

--点击下方场景入口的图标
function ChapterScene:touchSceneIcon_(index)
    if index == 1 then
        print("Enter TeamScene")
        display.replaceScene(require("scenes.TeamScene").new())
    elseif index == 2 then
        -- print("Enter UpgradeScene")
        --       -- --加载四个界面的table
        --       GameManager.BUDDHA_MODEL_TABLE  = DataUtils.getBuddhaModelsTableUpgradeScene("BUDDHA")
        --       print("1 done")
        --       GameManager.MONSTER_MODEL_TABLE = DataUtils.getBuddhaModelsTableUpgradeScene("MONSTER")
        --       print("2 done")
        --       GameManager.TOWER_MODEL_TABLE   = DataUtils.getTableUpgradePropertyModel("TOWER")
        --       print("3 done")
        --       GameManager.TANG_MODEL_TABLE    = DataUtils.getTableUpgradePropertyModel("TANG")
        --       print("4 done")

        --       display.replaceScene(require("layers.UpgradeBuddhaLayer").new())

        display.replaceScene(require("scenes.UpgradeScene").new())

        --UPGRADESCENE.toLayer("UpgradeBuddhaLayer")
        --display.replaceScene(import(".UpgradeScene").new())
    elseif index == 3 then
        print("Enter SummonScene")
        display.replaceScene(require("scenes.SummonScene").new())
    elseif index == 4 then
        print("Enter TreasureScene")
        display.replaceScene(require("scenes.TreasureScene").new())
    elseif index == 5 then
        print("Open Achievement")
        local acl = AchievementLayer.new(1)
        self:addChild(acl,20)
    elseif index == 6 then
        print("Enter ShopScene")
        display.replaceScene(require("scenes.ShopScene1").new())
    end
end

--点击滚动地图上的章节图标
function ChapterScene:touchChapterIcon(num)
    local chapterlayer = ChapterLayer.new(num)
    self:addChild(chapterlayer,20)
end

--点击试炼按钮
function ChapterScene:clickTrial_(event,x, y)
    if event == "began" then
        self.touchBeginPoint_ = {x = x,y = y}
        self.pointBegan_ = cc.p(x,y)
        return true
    end

    if event == "moved" then
        local point_moved = cc.p(x,y)

        --滚动视图的判断
        local rect = cc.rect(display.cx - 490,display.cy - 237,980,475)
        if self.touchBeginPoint_ and cc.rectContainsPoint(rect,point_moved) then
            local cx, cy = self.mapNode_:getPosition()
            self.mapNode_:setPosition(cx + (x - self.touchBeginPoint_.x) * 2,cy)
            self.touchBeginPoint_ = {x = x,y = y}

            --限制超出边界
            local minX = display.cx - self.mapSize_.width * 1.5 + 50
            local maxX = display.cx - self.mapSize_.width * 0.5 - 50
            local currX = self.mapNode_:getPositionX()

            if currX < minX then
                self.mapNode_:setPositionX(minX)
            end

            if currX > maxX then
                self.mapNode_:setPositionX(maxX)
            end
        end
    end

    if event == "ended" then
        self.touchBeginPoint_ = nil
        local point_ended = cc.p(x,y)

        if math.abs(self.pointBegan_.x - point_ended.x) < 20 and math.abs(self.pointBegan_.y - point_ended.y) < 20 then
            if self.stageProgress_ < self.trialRequireStage then
                local t = WSToast.new(self.trialRequireStage .. "关开启",1.0)
                self:addChild(t,100)
            else
                local trial = TrialLayer.new(self.challengeStage)
                self:addChild(trial, 20)
            end
        end
    end
end

--左边按钮功能
function ChapterScene:touchLeftButton_(tag)
    if tag == 1 then                  --签到窗口
        local sign = SignLayer.new()
        self:addChild(sign,20)
        
    elseif tag == 2 then              --设置弹窗
        local setting = SetLayer.new()
        self:addChild(setting,20)

    elseif tag == 3 then              --抽奖弹窗
        local spin = SpinLayer.new()
        self:addChild(spin,20)
        --display.replaceScene(require("scenes.Chen").new(),'FADETR',1)

    elseif tag == 4 then              --公告弹窗
        local notice = NoticeLayer.new()
        self:addChild(notice,20)
    end
end

--右边按钮功能
function ChapterScene:touchRightButton_(tag)
    if tag == 1 then                   --首充
        local firstRecharge = CumulateRechargeLayer.new() --FirstRechargeLayer.new()
        self:addChild(firstRecharge,20)

    elseif tag == 2 then               --充值
        local recharge = PaymentLayer.new()
        self:addChild(recharge,100)

    elseif tag == 3 then               --日常
        local daily = DiaryLayer.new()
        self:addChild(daily,20)

    elseif tag == 4 then              --系统维护弹窗
        local msg = ServerMaintainLayer.new(1)
        self:addChild(msg,20)

    elseif tag == 5 then              --调查问卷弹窗
        local sur = SurveyLayer.new()
        self:addChild(sur,20)
    end
end

--点击事件的判断
function ChapterScene:onTouch(event,x,y)
    if event == "began" then
        --滚动视图的判断
        self.touchBeginPoint_ = {x = x,y = y}
        -- print("====== x : "..self.touchBeginPoint_.x)
        -- print("====== y : "..self.touchBeginPoint_.y)
        self.pointBegan_ = cc.p(x,y)

        --场景入口的判断
        for i = 1, 6 do
            local sceneIcon = self.sceneIconsTable_[i]
            if cc.rectContainsPoint(sceneIcon:getMyBoundingBox(),self.pointBegan_) then
                sceneIcon:setScale(0.8)
            else
                sceneIcon:setScale(1.0)
            end
        end
        return true
    end

    if event == "moved" then
        local point_moved = cc.p(x,y)

        --场景入口的判断
        for i=1, 6 do
            local sceneIcon = self.sceneIconsTable_[i]
            if cc.rectContainsPoint(sceneIcon:getMyBoundingBox(),point_moved) then
                sceneIcon:setScale(0.8)
                self.touchBeginPoint_ = nil   --如果响应了按钮区域,则不能滚动中央视图
            else
                sceneIcon:setScale(1.0)
            end
        end

        --滚动视图的判断
        local rect = cc.rect(display.cx - 490,display.cy - 237,980,475)
        if self.touchBeginPoint_ and cc.rectContainsPoint(rect,point_moved) then
            local cx, cy = self.mapNode_:getPosition()
            self.mapNode_:setPosition(cx + (x - self.touchBeginPoint_.x) * 2,cy)
            self.touchBeginPoint_ = {x = x,y = y}

            --限制超出边界
            local minX = display.cx - self.mapSize_.width * 1.5 + 50
            local maxX = display.cx - self.mapSize_.width * 0.5 - 50
            local currX = self.mapNode_:getPositionX()

            if currX < minX then
                self.mapNode_:setPositionX(minX)
            end

            if currX > maxX then
                self.mapNode_:setPositionX(maxX)
            end
        end
    end

    if event == "ended" then
        --滚动视图的判断
        self.touchBeginPoint_ = nil
        local point_ended = cc.p(x,y)

        --场景入口的判断
        for i=1, 6 do
            local sceneIcon = self.sceneIconsTable_[i]
            sceneIcon:setScale(1.0)
            if math.abs(self.pointBegan_.x - point_ended.x) < 20 and math.abs(self.pointBegan_.y - point_ended.y) < 20
                and cc.rectContainsPoint(sceneIcon:getMyBoundingBox(),point_ended) then
                if GameManager.SOUND_SWITCH_ON then
                    audio.playSound(string.format("sounds/sfx_touch_ti.%s",GameManager.POSTFIX))
                end
                self:touchSceneIcon_(i)
            end
        end

        --章节入口点击
        for j = 1, 8 do
            local chapterIcon = self.chapterIconsTable_[j]
            if math.abs(self.pointBegan_.x - point_ended.x) < 20 and math.abs(self.pointBegan_.y - point_ended.y) < 20
                and chapterIcon.isUnlock
                and cc.rectContainsPoint(chapterIcon:getMyBoundingBox(),point_ended) then

                self:touchChapterIcon(j)
            end
        end

    end
end

--章节解锁的动画
function ChapterScene:chapterUnlockAnimation_(chapterId)
    --创建动画
    display.addSpriteFrames("animation/jiesuo.plist","animation/jiesuo.png")
    display.addSpriteFrames("animation/shanxian.plist","animation/shanxian.png")

    local frames1 = display.newFrames("jiesuo%d.png",1,60)
    local animation1 = display.newAnimation(frames1, 0.04)
    local frames2 = display.newFrames("shanxian%d.png",1,35)
    local animation2 = display.newAnimation(frames2, 0.075)
    local animate1 = cc.Animate:create(animation1)
    local animate2 = cc.Animate:create(animation2)

    local sp1 = display.newSprite()
        :pos(self.lockPic_:getPosition())
        :addTo(self.lockPic_:getParent(),3)


    local lockIcon = self.chapterIconsTable_[chapterId]
    local unlockIcon  = display.newSprite(string.format("chapter/stage_icon%d.png",chapterId))
        :pos(lockIcon:getPosition())
        :opacity(0)
        :addTo(lockIcon:getParent(),2)

    --创建动作
    local delay1   = cc.DelayTime:create(2.2)
    local delay2   = cc.DelayTime:create(2.4)
    local delay3   = cc.DelayTime:create(2.4)
    local fadeOut_ = cc.FadeOut:create(1.5)
    local fadeIn_  = cc.FadeIn:create(1.5)

    self.lockPic_:runAction(animate1)
    sp1:runAction(transition.sequence({delay1,animate2}))
    lockIcon:runAction(transition.sequence({delay2,fadeOut_}))
    unlockIcon:runAction(transition.sequence({delay3,fadeIn_,cc.CallFunc:create(function()
        --存储已解锁
        DataUtils.setChapterIsUnlock(chapterId,true)
        lockIcon.isUnlock = true

        --箭头动画
        local point1 = cc.p(unlockIcon:getPositionX() + 15,unlockIcon:getPositionY() + 50)
        local point2 = cc.p(unlockIcon:getPositionX() + 15,unlockIcon:getPositionY() + 100)

        local mark = display.newSprite("chapter/mark.png",point2.x,point2.y):addTo(unlockIcon:getParent(),3)
        mark:runAction(cc.RepeatForever:create(transition.sequence({cc.MoveTo:create(0.5,point1),
            cc.MoveTo:create(0.5,point2)})))
    end)}))
end

--判断是否可以免费召唤
function ChapterScene:getIsSummonFree_()
    --距下次免费召唤的事件
    local nextFreeTimeExp   = CloudData.NEXT_FREESUMMON_TIME_EXP
    local nextFreeTimePeach = CloudData.NEXT_FREESUMMON_TIME_PEACH
    --当日经验免费剩余次数
    local freeNumExp        = CloudData.FREE_SUMMON_NUM_EXP
    --计算多长时间后显示"new"提示
    local delayTime = 0
    if CloudData.STAGE_PROGRESS >= 25 then
        if freeNumExp > 0 then
            if nextFreeTimeExp <= nextFreeTimePeach then
                delayTime = nextFreeTimeExp
            else
                delayTime = nextFreeTimePeach
            end
        else
            delayTime = nextFreeTimePeach
        end
    else
        if freeNumExp > 0 then
            delayTime = nextFreeTimeExp
        else
            delayTime = 24 * 3600     --(当天不会再有免费)
        end
    end

    self:performWithDelay(function()
        local icon = self.sceneIconsTable_[3]
        icon:setMarkVisible(true)
    end, delayTime)
end

--判断是否有宝物收集完整
function ChapterScene:getIsTreasureCompleted_()
    for i=1,8 do
        local treasureModel       = DataUtils.getTreasureModel(i)
        local isTreasureEffective = treasureModel.isTreasureEffective_
        if isTreasureEffective and not DataUtils.getIsTreasureUnlockAnimationPlayed(i) then
            --"new"提示
            DataUtils.setIsTreasureEffctive(i,true)
            local icon = self.sceneIconsTable_[4]
            icon:setMarkVisible(true)

            --弹窗提示
            local layer = TreasureShowLayer.new(i)
            self:addChild(layer,20)

            return
        end
    end
end

--判断是否有成就达成
function ChapterScene:getIsAchievementCompleted_()
    local icon = self.sceneIconsTable_[5]
    --成就
    for i=1,10 do
        local achievementModel = DataUtils.getAchievementModel(i)
        local rewardNum        = tonumber(achievementModel.rewardNum_)
        local achievementData  = tonumber(achievementModel.achievementData_)
        local currentData      = achievementModel.currentData_
        if DataUtils.getAchievementLevel(i) <= rewardNum and currentData >= achievementData then
            --icon:setMarkVisible(true)
            GameManager.IS_ACHIEVEMENT_NEW = true
        end
    end
    --print("IS_ACHIEVEMENT_NEW = %s",GameManager.IS_ACHIEVEMENT_NEW)
    --日常
    for j=1,13 do
        local dailyTaskModel = DataUtils.getDailyTaskModel(j)
        local dailyTaskId    = tonumber(dailyTaskModel.dailyTaskId_)
        --print("dailyTaskId = "..dailyTaskId)
        local totalData      = tonumber(dailyTaskModel.totalData_)
        --print("totalData = "..totalData)
        local currentData    = dailyTaskModel.currentData_
        --print("currentData = "..currentData)
        if not DataUtils.getDailyTaskCompleted(dailyTaskId) and currentData >= totalData then
            --icon:setMarkVisible(true)
            GameManager.IS_DAILY_TASK_NEW = true
        end
    end
    --print("IS_DAILY_TASK_NEW = %s",GameManager.IS_DAILY_TASK_NEW)
    --阶段
    for k=1,8 do
        local stageTaskModel = DataUtils.getStageTaskModel(k)
        local stageTaskId = tonumber(stageTaskModel.stageTaskId_)
        local totalData   = tonumber(stageTaskModel.totalData_)
        local currentData = stageTaskModel.currentData_
        if not DataUtils.getStageTaskCompleted(stageTaskId) and currentData >= totalData then
            --icon:setMarkVisible(true)
            GameManager.IS_STAGE_TASK_NEW = true
        end
    end
    --print("IS_STAGE_TASK_NEW = %s",GameManager.IS_STAGE_TASK_NEW)

    if GameManager.IS_ACHIEVEMENT_NEW or GameManager.IS_DAILY_TASK_NEW or GameManager.IS_STAGE_TASK_NEW then
        icon:setMarkVisible(true)
    else
        icon:setMarkVisible(false)
    end
end

--检测章节界面事件
function ChapterScene:updateChapterScene_()
    --关闭成就层时,刷新成就状态,以便确定是否有"new"提示
    if GameManager.IS_ACHIEVEMENT_LAYER_CLOSED then
        GameManager.IS_ACHIEVEMENT_LAYER_CLOSED = false
        self:getIsAchievementCompleted_()
    end

    --是否签到过
    if self:getChildByTag(TAG_SIGN_NEW) ~= nil then
        if CloudData.IS_SIGNED_TODAY then
            self:removeChildByTag(TAG_SIGN_NEW,true)
        end
    end

    --是否可免费抽奖
    if self:getChildByTag(TAG_LOTTERY_NEW) ~= nil then
        if CloudData.DRAW_NUM ~= 0 then
            self:removeChildByTag(TAG_LOTTERY_NEW,true)
        end
    end

    -- 检测充值界面是否关闭
    if GameManager.IS_PAYMENT_LAYER_CLOSED then
        GameManager.IS_PAYMENT_LAYER_CLOSED = false
        -- todo：联网处理

        local ac = AlertConnection.new(CONNECTION_MAIL_REFRESH)
        self:addChild(ac,100,12345)
        
        self.scheduleResult_ = self:schedule(function() 
            if not self:getChildByTag(12345) then
                self:stopAction(self.scheduleResult_)

                --礼包-限时充值是否完成
                local rechangeNewTag =  self:getChildByTag(TAG_LIMITED_TIME_RECHARGE)
                if rechangeNewTag ~= nil then
                    if CloudData.SHOW_LIMITED_TIME_RECHARGE == 0 then 
                        rechangeNewTag:setVisible(false)
                    else
                        rechangeNewTag:setVisible(true)
                    end
                end              

                local mailRedPoint =  self:getChildByTag(TAG_MAIL_NEW)
                if mailRedPoint == nil then
                    return
                end
                for i=1, #CloudData.SERVER_MSG do
                    local id = CloudData.SERVER_MSG[i].id
                    local sid = string.format("%d",id)
                    if CloudData.READ_MSG_TABLE[sid] == nil then
                        --邮箱图标上加小红点
                        mailRedPoint:setVisible(true)
                        return
                    else
                        mailRedPoint:setVisible(false)
                    end
                end                              
            end
        end,0.1)
    end

    --是否领取过充值里的奖励
    -- if self:getChildByTag(TAG_RECHARGE_NEW) ~= nil then
    --     if tonumber(CloudData.PAYMENT_ITEM_STATE[1]) ~= 1 and tonumber(CloudData.PAYMENT_ITEM_STATE[2]) ~= 1
    --         and tonumber(CloudData.PAYMENT_ITEM_STATE[3]) ~= 1 then
    --         self:removeChildByTag(TAG_RECHARGE_NEW,true)
    --     end
    -- end

    --首冲奖励是否领取
    -- if self:getChildByTag(TAG_FIRST_RECHARGE_NEW) ~= nil then
    --     if tonumber(CloudData.FIRST_PURCHASE_STATE) ~= 1 then
    --         self:removeChildByTag(TAG_FIRST_RECHARGE_NEW,true)
    --     end
    -- end
end

function ChapterScene:addAndroidReturnButton_()
    --退出游戏
    local btn = cc.ui.UIPushButton.new():addTo(self)
    btn:setKeypadEnabled(true)
    btn:addNodeEventListener(cc.KEYPAD_EVENT, function (event)
        if event.key == "back" then
            self:showReturnWarning_()
        end
    end)
end

function ChapterScene:showReturnWarning_()
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

function ChapterScene:onEnter()
end

function ChapterScene:onExit()
    self:removeAllChildren()
    display.removeUnusedSpriteFrames()
end

return ChapterScene