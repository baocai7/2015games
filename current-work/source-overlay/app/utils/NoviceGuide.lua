--
--新手引导
--

GUIDE_STEP_STAGE0_1                      = 1         --0关点击沙僧    (g1)
GUIDE_STEP_STAGE0_2                      = 2         --0关点击八戒    (g2)
GUIDE_STEP_STAGE0_3                      = 3         --0关点击悟空    (g3)
GUIDE_STEP_SELECT_CHAPTER                = 4         --选择关卡       (g4)
GUIDE_STEP_GAME_START                    = 5         --点击出战按钮   (g5)
GUIDE_STEP_SWIPE                         = 6         --滑动屏幕       (g6)
GUIDE_STEP_MAKE_BUDDHA                   = 7         --引导制造兵种   (g7)              
GUIDE_STEP_UPGRADE_SPIRIT                = 8         --引导升级灵气   (g8)
GUIDE_STEP_FIRE                          = 9         --引导发炮       (g9)
GUIDE_STEP_ENTER_TEAMSCENE               = 10        --进入队伍界面   (g10)
GUIDE_STEP_TIANJIANG_ON_TEAM             = 11        --引导天将上阵   (g11)
GUIDE_STEP_SCREEN_ZOOM                   = 12        --屏幕缩放       (g12)
GUIDE_STEP_ENTER_UPGRADESCENE            = 13        --进入升级界面   (g13)
GUIDE_STEP_UPGRADE_BUDDHA                = 14        --升级兵种       (g14)
GUIDE_STEP_UPGRADE_PROPERTY              = 15        --升级属性       (g15)   
GUIDE_STEP_ENTER_SUMMONSCENE             = 16        --进入召唤界面   (g16)
GUIDE_STEP_SUMMON1                       = 17        --引导免费召唤   (g17)
GUIDE_STEP_SUMMON2                       = 18        --召唤后提示每隔一段时间会有免费召唤机会 (g18)
GUIDE_STEP_SHASENG_ON_TEAM               = 19        --引导沙僧上阵   (g19)
GUIDE_STEP_ENTER_TREASURESCENE           = 20        --进入宝物界面   (g20)
GUIDE_STEP_TREASURE1                     = 21        --点击宝物碎片   (g21)
GUIDE_STEP_TREASURE2                     = 22        --碎片弹窗关闭后提醒多收集宝物  (g22)
GUIDE_STEP_OPEN_ACHIEVEMENT              = 23        --打开成就界面   (g23)
GUIDE_STEP_ACHIEVEMENT                   = 24        --引导领取奖励   (g24)
GUIDE_STEP_UNLOCK_MONSTER1               = 25        --进入升级界面   (g25)
GUIDE_STEP_UNLOCK_MONSTER2               = 26        --点击降妖       (g26)
GUIDE_STEP_UNLOCK_MONSTER3               = 27        --点击召唤       (g27)
GUIDE_STEP_LOSE_TIP1                     = 28        --失败三次的提示引导(没有首冲)  (g28)
GUIDE_STEP_LOSE_TIP2                     = 29        --失败三次的提示引导(有首冲过)  (g29)
GUIDE_STEP_ITEM1                         = 30        --第五关道具1引导      (g30) 
GUIDE_STEP_ITEM2                         = 31        --第五关道具2引导      (g31)
GUIDE_STEP_DAILY                         = 32        --日常试炼引导         (g32)
GUIDE_STEP_CHALLENGE                     = 33        --挑战关卡引导         (g33)

GUIDE_STEP_UPGRADE_TOWER1                = 34        --引导升级防御塔(第7关)
GUIDE_STEP_UPGRADE_TOWER2                = 35
GUIDE_STEP_UPGRADE_TANG1                 = 36        --引导升级唐僧(第10关)
GUIDE_STEP_UPGRADE_TANG2                 = 37
GUIDE_STEP_INFINITEMODE                  = 38        --通天塔引导

GUIDE_STEP_CHECK_SPIRIT_NUM              = 39        --引导查看灵气值

local CSVParser = import("utils.CSVParser")

local NoviceGuide = {} 
NoviceGuide = class("NoviceGuide", function()
    return display.newLayer()
end)

function NoviceGuide:ctor( guideStep )
    --读取引导配置文件
    local filePath = nil
    if guideStep == GUIDE_STEP_STAGE0_1 then
        filePath = "novice_guide/guide_stage0_1.csv"
    elseif guideStep == GUIDE_STEP_STAGE0_2 then
        filePath = "novice_guide/guide_stage0_2.csv"
    elseif guideStep == GUIDE_STEP_STAGE0_3 then
        filePath = "novice_guide/guide_stage0_3.csv"
    elseif guideStep == GUIDE_STEP_SELECT_CHAPTER then
        filePath = "novice_guide/guide_select_chapter.csv"
    elseif guideStep == GUIDE_STEP_GAME_START then
        filePath = "novice_guide/guide_game_start.csv"
    elseif guideStep == GUIDE_STEP_SWIPE then
        filePath = "novice_guide/guide_swipe.csv"
    elseif guideStep == GUIDE_STEP_MAKE_BUDDHA then
        filePath = "novice_guide/guide_make_buddha.csv"
    elseif guideStep == GUIDE_STEP_UPGRADE_SPIRIT then
        filePath = "novice_guide/guide_spirit.csv"
    elseif guideStep == GUIDE_STEP_FIRE then
        filePath = "novice_guide/guide_fire.csv"
    elseif guideStep == GUIDE_STEP_ENTER_TEAMSCENE then
        filePath = "novice_guide/guide_team_scene.csv"
    elseif guideStep == GUIDE_STEP_TIANJIANG_ON_TEAM then
        filePath = "novice_guide/guide_team1.csv"
    elseif guideStep == GUIDE_STEP_SCREEN_ZOOM then
        filePath = "novice_guide/guide_screen_zoom.csv"
    elseif guideStep == GUIDE_STEP_ENTER_UPGRADESCENE then
        filePath = "novice_guide/guide_upgrade_scene.csv"
    elseif guideStep == GUIDE_STEP_UPGRADE_BUDDHA then
        filePath = "novice_guide/guide_upgrade_buddha.csv"
    elseif guideStep == GUIDE_STEP_UPGRADE_PROPERTY then
        filePath = "novice_guide/guide_upgrade_property.csv"
    elseif guideStep == GUIDE_STEP_ENTER_SUMMONSCENE then
        filePath = "novice_guide/guide_summon_scene.csv"
    elseif guideStep == GUIDE_STEP_SUMMON1 then
        filePath = "novice_guide/guide_summon1.csv"
    elseif guideStep == GUIDE_STEP_SUMMON2 then
        filePath = "novice_guide/guide_summon2.csv"
    elseif guideStep == GUIDE_STEP_SHASENG_ON_TEAM then
        filePath = "novice_guide/guide_team2.csv"
    elseif guideStep == GUIDE_STEP_ENTER_TREASURESCENE then
        filePath = "novice_guide/guide_treasure_scene.csv"
    elseif guideStep == GUIDE_STEP_TREASURE1 then
        filePath = "novice_guide/guide_treasure1.csv"
    elseif guideStep == GUIDE_STEP_TREASURE2 then
        filePath = "novice_guide/guide_treasure2.csv"
    elseif guideStep == GUIDE_STEP_OPEN_ACHIEVEMENT then
        filePath = "novice_guide/guide_achievement_open.csv"
    elseif guideStep == GUIDE_STEP_ACHIEVEMENT then
        filePath = "novice_guide/guide_achievement.csv"
    elseif guideStep == GUIDE_STEP_UNLOCK_MONSTER1 then
        filePath = "novice_guide/guide_unlock_monster1.csv"
    elseif guideStep == GUIDE_STEP_UNLOCK_MONSTER2 then
        filePath = "novice_guide/guide_unlock_monster2.csv"
    elseif guideStep == GUIDE_STEP_UNLOCK_MONSTER3 then
        filePath = "novice_guide/guide_unlock_monster3.csv"
    elseif guideStep == GUIDE_STEP_LOSE_TIP1 then
        filePath = "novice_guide/guide_lose1.csv"
    elseif guideStep == GUIDE_STEP_LOSE_TIP2 then
        filePath = "novice_guide/guide_lose2.csv"
    elseif guideStep == GUIDE_STEP_ITEM1 then
        filePath = "novice_guide/guide_item1.csv"
    elseif guideStep == GUIDE_STEP_ITEM2 then
        filePath = "novice_guide/guide_item2.csv"
    elseif guideStep == GUIDE_STEP_DAILY then
        filePath = "novice_guide/guide_daily.csv"
    elseif guideStep == GUIDE_STEP_CHALLENGE then
        filePath = "novice_guide/guide_challenge.csv"
    elseif guideStep == GUIDE_STEP_UPGRADE_TOWER1 then
        filePath = "novice_guide/guide_upgrade_tower1.csv"
    elseif guideStep == GUIDE_STEP_UPGRADE_TOWER2 then
        filePath = "novice_guide/guide_upgrade_tower2.csv"
    elseif guideStep == GUIDE_STEP_UPGRADE_TANG1 then
        filePath = "novice_guide/guide_upgrade_tang1.csv"
    elseif guideStep == GUIDE_STEP_UPGRADE_TANG2 then
        filePath = "novice_guide/guide_upgrade_tang2.csv"
    elseif guideStep == GUIDE_STEP_INFINITEMODE then
        filePath = "novice_guide/guide_infinite_mode.csv"
    elseif guideStep == GUIDE_STEP_CHECK_SPIRIT_NUM then
        filePath = "novice_guide/guide_spirit_num.csv"
    end
    
    --解析文件数据
    self:initFileData_(filePath)

    --init
    self:initUI_()
end

--解析文件数据
function NoviceGuide:initFileData_(filePath)
    --将文件内容存入table
    self.guideContentTable_ = CSVParser.new(filePath)  

    --需要读取table的行序号
    self.rowId_ = 1
end

--UI布置
function NoviceGuide:initUI_()
    --背景
    self.bg_ = display.newSprite("novice_guide/guide_bg.png"):addTo(self)

    --添加手指
    self.finger1_ = display.newSprite("novice_guide/finger.png"):addTo(self,3)
    self.finger2_ = display.newSprite("novice_guide/finger.png")
        :flipX(true)
        :flipY(true)
        :addTo(self,3)

    --添加光圈
    self.circle_ = display.newSprite("novice_guide/circle.png"):addTo(self,2)

    --添加箭头
    self.arrow_ = display.newSprite("novice_guide/arrow.png"):addTo(self,1)

    --添加文本
    self.textLabel_ = cc.ui.UILabel.new({
        UILabelType = 2,text = "" ,size = 26,align = cc.ui.TEXT_ALIGN_LEFT,dimensions = cc.size(240,105),font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,self.bg_:getContentSize().width * 0.67,self.bg_:getContentSize().height * 0.18)
        :addTo(self.bg_)

    --添加遮罩层
    local maskLayer = display.newColorLayer(cc.c4b(0,0,0,150))
        :addTo(self,-1)   
    maskLayer:setTouchSwallowEnabled(false)

    --添加点击事件
    self:setTouchEnabled(true)
    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        return self:onTouch_(event.name,event.x,event.y)
    end) 

    self:nextStep_()    
end

--引导步骤
function NoviceGuide:nextStep_()
    local totalRows = self.guideContentTable_:getTotalRows() - 1 
    if self.guideContentTable_ ~= nil then
        if self.rowId_ > totalRows then
            self:removeSelf()
            --display.removeUnusedSpriteFrames()
            --todo:联网存储数据
            return
        end

        --读取文件数据
        local rowData = self.guideContentTable_:objectAtIndex(self.rowId_)
        local textContent   = rowData["text"]                                --文本内容
        local pointType     = tonumber(rowData["pointType"])                 --坐标转换类型（1：以中间为标准；2：以左边界为标准；3：以右边界为标准;4:以display为标准）
        local pointX        = tonumber(rowData["pointX"])                    --手指位置
        local pointY        = tonumber(rowData["pointY"])
        local bgPointX      = tonumber(rowData["bgPointX"])                  --背景的位置
        local bgPointY      = tonumber(rowData["bgPointY"])
        self.guideType_     = tonumber(rowData["type"])                      --0:人物引导；1：单手指点击引导；2：单手指滑动引导；3：双指伸缩引导
        self.roleDerection_ = tonumber(rowData["direction"])                 --判断人物所在方向（0：左边；1：右边）
        self.rangeX_        = tonumber(rowData["rangeX"])                    --手指引导作用范围X
        self.rangeY_        = tonumber(rowData["rangeY"])                    --手指引导作用范围Y
        self.isNeedPause_   = tonumber(rowData["isNeedPause"])               --当前场景是否需要暂停                                                   

        --背景位置
        self.bg_:setPosition(display.cx + bgPointX,display.cy + bgPointY)
        self.bg_:setFlippedX(false)

        --手指的位置及运动方向
        if pointType == 1 then
            pointX = display.cx + pointX
        elseif pointType == 3 then
            pointX = display.width - pointX
        elseif pointType == 4 then
            pointX = display.width * pointX
            pointY = display.height * pointY
        end
        self.fingerPoint_ = cc.p(pointX,pointY)
        self:fingerAction_()

        --文本内容
        self.textLabel_:setString(textContent)
        if roleDerection_ == 1 then
            self.bg_:setFlippedX(true)
            self.textLabel_:setPosition(self.bg_:getContentSize().width * 0.33,self.bg_:getContentSize().height * 0.20)
        end

        --游戏暂停
        if self.isNeedPause_ == 1 then
            operateAllSchedulerAndActions(display.getRunningScene(),"PAUSE")
        end

        --换到下一行
        self.rowId_ = self.rowId_ + 1
    end 
end

--手指位置及运动方向
function NoviceGuide:fingerAction_()
    if self.guideType_ == 0 then
        self.finger1_:hide()
        self.finger2_:hide()
        self.circle_:hide()
        self.arrow_:hide()

    elseif self.guideType_ == 1 then
        self.finger1_:show()
        self.finger2_:hide()
        self.circle_:show()
        self.arrow_:hide()

        self.finger1_:setPosition(self.fingerPoint_.x + self.finger1_:getContentSize().width * 0.65,
            self.fingerPoint_.y - self.finger1_:getContentSize().height * 0.65)
        self.circle_:setPosition(self.fingerPoint_.x, self.fingerPoint_.y)
        --创建动作
        local moveTo1 = cc.MoveTo:create(0.5,cc.p(self.fingerPoint_.x + self.finger1_:getContentSize().width * 0.35,
            self.fingerPoint_.y - self.finger1_:getContentSize().height * 0.35))
        local moveTo2 = cc.MoveTo:create(0.5,cc.p(self.fingerPoint_.x + self.finger1_:getContentSize().width * 0.65,
            self.fingerPoint_.y - self.finger1_:getContentSize().height * 0.65))
        local seq = transition.sequence({moveTo1,moveTo2})
        self.finger1_:runAction(cc.RepeatForever:create(seq))

        local scaleTo1 = cc.ScaleTo:create(0.5,1.0)
        local scaleTo2 = cc.ScaleTo:create(0.5,1.5)
        local seq1 = transition.sequence({scaleTo1,scaleTo2})
        self.circle_:runAction(cc.RepeatForever:create(seq1))

    elseif self.guideType_ == 2 then
        --self.finger1_:show()
        self.finger2_:hide()
        self.circle_:hide()
        self.arrow_:show()

        self.finger1_:setPosition(self.fingerPoint_.x - self.arrow_:getContentSize().width * 0.5,
            self.fingerPoint_.y - self.finger1_:getContentSize().height * 0.5)
        self.arrow_:setPosition(self.fingerPoint_.x, self.fingerPoint_.y)
        --创建动作
        local moveTo1 = cc.MoveTo:create(1.5,cc.p(self.fingerPoint_.x + self.arrow_:getContentSize().width * 0.5,
            self.fingerPoint_.y - self.finger1_:getContentSize().height * 0.5))
        local moveTo2 = cc.MoveTo:create(0,cc.p(self.fingerPoint_.x - self.arrow_:getContentSize().width * 0.5,
            self.fingerPoint_.y - self.finger1_:getContentSize().height * 0.5))
        local seq = transition.sequence({moveTo1,moveTo2})
        self.finger1_:runAction(cc.RepeatForever:create(seq))

    else
        self.finger1_:show()
        self.finger2_:show()
        self.circle_:show()
        self.arrow_:hide()

        self.finger1_:setPosition(self.fingerPoint_.x + self.finger1_:getContentSize().width * 0.95,
            self.fingerPoint_.y - self.finger1_:getContentSize().height * 0.95)
        self.finger2_:setPosition(self.fingerPoint_.x - self.finger2_:getContentSize().width * 0.95,
            self.fingerPoint_.y + self.finger2_:getContentSize().height * 0.95)
        self.circle_:setPosition(self.fingerPoint_.x, self.fingerPoint_.y)
        --创建动作
        local moveTo1 = cc.MoveTo:create(0.8,cc.p(self.fingerPoint_.x + self.finger1_:getContentSize().width * 0.60,
            self.fingerPoint_.y - self.finger1_:getContentSize().height * 0.60))
        local moveTo2 = cc.MoveTo:create(0.8,cc.p(self.fingerPoint_.x + self.finger1_:getContentSize().width * 0.95,
            self.fingerPoint_.y - self.finger1_:getContentSize().height * 0.95))
        local moveTo3 = cc.MoveTo:create(0.8,cc.p(self.fingerPoint_.x - self.finger2_:getContentSize().width * 0.60,
            self.fingerPoint_.y + self.finger1_:getContentSize().height * 0.60))
        local moveTo4 = cc.MoveTo:create(0.8,cc.p(self.fingerPoint_.x - self.finger1_:getContentSize().width * 0.95,
            self.fingerPoint_.y + self.finger1_:getContentSize().height * 0.95))
        local seq1 = transition.sequence({moveTo1,moveTo2})
        local seq2 = transition.sequence({moveTo3,moveTo4})
        self.finger1_:runAction(cc.RepeatForever:create(seq1))
        self.finger2_:runAction(cc.RepeatForever:create(seq2))

        local scaleTo1 = cc.ScaleTo:create(0.8,1.0)
        local scaleTo2 = cc.ScaleTo:create(0.8,1.5)
        local seq3 = transition.sequence({scaleTo1,scaleTo2})
        self.circle_:runAction(cc.RepeatForever:create(seq3))
    end
end

--添加点击事件
function NoviceGuide:onTouch_(event,x,y)
    if event == "began" then
        self.beginPoint_ = {x = x,y = y}
        if self.guideType_ == 1 then
            if math.abs(self.beginPoint_.x - self.fingerPoint_.x) < self.rangeX_ and math.abs(self.beginPoint_.y - self.fingerPoint_.y) < self.rangeY_ then
                self:setTouchSwallowEnabled(false)
            else
                self:setTouchSwallowEnabled(true)
            end
        end
        if self.guideType_ >= 2 then
            self:setTouchSwallowEnabled(false)
            --屏幕背景的位置
            self.bgX_ = display.getRunningScene().bg1_:getPositionX()
        end

        return true

    elseif event == "moved" then
        if self.guideType_ == 2 then
            display.getRunningScene():moveScreen()
            if display.getRunningScene().bg1_:getPositionX() >= ((self.bgX_ + display.width/3) * (display.getRunningScene().zoomRatio_/2.5)) 
            or display.getRunningScene().bg1_:getPositionX() <= ((self.bgX_ - display.width/3) * (display.getRunningScene().zoomRatio_/2.5)) then
                if self.isNeedPause_ == 1 then
                    operateAllSchedulerAndActions(display.getRunningScene(),"RESUME")
                end
                self:nextStep_()
            end 
        end

    elseif event == "ended" then
        local endPoint = {x = x,y = y}
        if math.abs(self.beginPoint_.x - endPoint.x) < self.rangeX_ and math.abs(self.beginPoint_.y - endPoint.y) < self.rangeY_ then
            if self.guideType_ == 0 then
                if self.isNeedPause_ == 1 then
                    operateAllSchedulerAndActions(display.getRunningScene(),"RESUME")
                end
                self:nextStep_()

            elseif self.guideType_ == 1 then
                if math.abs(endPoint.x - self.fingerPoint_.x) < self.rangeX_ and math.abs(endPoint.y - self.fingerPoint_.y) < self.rangeY_ then
                    if self.isNeedPause_ == 1 then
                        operateAllSchedulerAndActions(display.getRunningScene(),"RESUME")
                    end

                    --停止上一动作
                   self.finger1_:stopAllActions()
                   self.circle_:stopAllActions()
                   
                    --进入下一步
                    self:nextStep_()
                end    
            elseif self.guideType_ == 3 then
                if self.isNeedPause_ == 1 then
                    operateAllSchedulerAndActions(display.getRunningScene(),"RESUME")
                end
            end
        end
    end
end

return NoviceGuide