
local Buddha        = import("sprites.Buddha")
local Monster       = import("sprites.Monster")

local TowerMonster  = import("sprites.TowerMonster")
local TowerBuddha   = import("sprites.TowerBuddha")

local UpgradeBtn    = import("customs.gamescene.UpgradeBtn")
local FireBtn       = import("customs.gamescene.FireBtn")
local PauseBtn      = import("customs.gamescene.PauseBtn")
local SpeedBtn      = import("customs.gamescene.SpeedBtn")
local SkillItemIcon = import("customs.gamescene.SkillItemIcon")
local TimerIcon     = import("customs.gamescene.TimerIcon")
local UnitIcon      = import("icons.UnitIcon")

local SkillItemLayer   = import("layers.SkillItemLayer")
local GuideStage3Layer = import("layers.GuideStage3Layer")

local NoviceGuide     = import("utils.NoviceGuide")
local AlertConnection = import("customs.AlertConnection")

local SpiritCounter = import("sprites.SpiritCounter")

local GameScene = {}
GameScene = class("GameScene",function()
    return display.newScene("GameScene")
end)

-- 求两点间距离
local function dist(p1, p2)
    local dx = p1.x - p2.x
    local dy = p1.y - p2.y
    return math.sqrt(dx * dx + dy * dy)
end


function GameScene:ctor( mode )

    self:initMusic( mode )

    self:initData( mode )

    self:initBG( mode )

    self:initTower( mode )

    self:initUI(mode)

    self:initItems(mode)

    self:initTouchEvent()

    --打印纹理缓存
    --local info = cc.Director:getInstance():getTextureCache():getCachedTextureInfo()
    --print(info)

    -- 添加每帧刷新的方法
    self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT,handler(self , self.update))  -- 注册帧事件
    self:scheduleUpdate() -- 启用帧事件

    -- ray 由于lua性能问题 把兵种遍历放在这里统一每0.1s做一次，取出我方和敌方最前边的点
    self.schedule_ = self:schedule(function()
        self:calc()
    end , 0.1)

    Game.NEAREST_MONSTER_X_ = 0
    Game.NEAREST_BUDDHA_X_ = 10000

    Game.NEAREST_MONSTER_ = nil
    Game.NEAREST_BUDDHA_ = nil

    --加载引导部分
    self:initNoviceGuide_()

    self:addAndroidReturnButton_()
end


function GameScene:initMusic( mode )
    if mode == "NORMAL" then
        local num = 0
        if GameManager.STAGE_NUM % 2 == 0 then num = 1 else num = 0 end
        if GameManager.MUSIC_SWITCH_ON then
            if (cc.FileUtils:getInstance():isFileExist(string.format("sounds/bgm_battle%d.%s",num,GameManager.POSTFIX))) then
                audio.playMusic(string.format("sounds/bgm_battle%d.%s",num,GameManager.POSTFIX))
            else
                audio.playMusic(string.format("sounds/bgm_battle0.%s",GameManager.POSTFIX))
            end
        end
    elseif mode == "CHALLENGE" and GameManager.MUSIC_SWITCH_ON then
        if(cc.FileUtils:getInstance():isFileExist(string.format("sounds/bgm_battle1.%s",GameManager.POSTFIX))) then
            audio.playMusic(string.format("sounds/bgm_battle1.%s",GameManager.POSTFIX))
        else
            audio.playMusic(string.format("sounds/bgm_battle0.%s",GameManager.POSTFIX))
        end
    elseif mode == "DIARY" and GameManager.MUSIC_SWITCH_ON then
        if(cc.FileUtils:getInstance():isFileExist(string.format("sounds/bgm_battle1.%s",GameManager.POSTFIX))) then
            audio.playMusic(string.format("sounds/bgm_battle1.%s",GameManager.POSTFIX))
        else
            audio.playMusic(string.format("sounds/bgm_battle0.%s",GameManager.POSTFIX))
        end
    elseif mode == "ACTIVITY" and GameManager.MUSIC_SWITCH_ON then
        if(cc.FileUtils:getInstance():isFileExist(string.format("sounds/bgm_battle1.%s",GameManager.POSTFIX))) then
            audio.playMusic(string.format("sounds/bgm_battle1.%s",GameManager.POSTFIX))
        else
            audio.playMusic(string.format("sounds/bgm_battle0.%s",GameManager.POSTFIX))
        end
    end
end



-- 求最进的目标
function GameScene:calc()
    Game.NEAREST_MONSTER_X_ = 0

    if #Game.MONSTER_TABLE ~= 0 then
        for i,monster in pairs(Game.MONSTER_TABLE) do
            if not monster.isInHurt_ and not monster.isDead_ and monster:getPositionX() > Game.NEAREST_MONSTER_X_ then
                Game.NEAREST_MONSTER_X_ = monster:getPositionX()
                Game.NEAREST_MONSTER_ = monster
            end
        end
    else
        Game.NEAREST_MONSTER_ = nil
    end

    Game.NEAREST_BUDDHA_X_ = 10000

    if #Game.BUDDHA_TABLE ~= 0 then
        for i,buddha in pairs(Game.BUDDHA_TABLE) do
            if not buddha.isInHurt_ and not buddha.isDead_ and buddha:getPositionX() < Game.NEAREST_BUDDHA_X_ then
                Game.NEAREST_BUDDHA_X_ = buddha:getPositionX()
                Game.NEAREST_BUDDHA_ = buddha
            end
        end
    else
        Game.NEAREST_BUDDHA_ = nil
    end


    --print("=========self.NEAREST_MONSTER_X_========" .. Game.NEAREST_MONSTER_X_)
    --print("=========self.NEAREST_BUDDHA_X_========" .. Game.NEAREST_BUDDHA_X_)
end


function GameScene:initData( mode )

    Game.MODE = mode

    Game.BUDDHA_TABLE = {}
    Game.MONSTER_TABLE = {}
    Game.INVINCIBLE = false
    Game.CDZERO = false
    
    -- 记录在卍字符期间的出兵数量，超过10个则取消卍字符效果
    Game.makeBuddhaNumInCDZERO = 0

    Game.SKILL_ITEM_USE = {}
    Game.SKILL_ITEM_BUY = {}

    for i = 1, 6 do
        Game.SKILL_ITEM_USE[i] = 0
        Game.SKILL_ITEM_BUY[i] = 0
    end

    Game.END = false

    Game.EXP_ADD = 0
    Game.PEACH_ADD = 0
    Game.TREASURE_PIECE_QUALITY = 0
    Game.MONSTER_PIECE_ID_TABLE = {}
    Game.MONSTER_PIECE_NUM_TABLE = {}

    -- 默认 1.3倍速
    cc.Director:getInstance():getScheduler():setTimeScale(1.3)
    self.timeScale_ = 1.3

    GameManager.TANGMONK_LEVEL = 1
    --    GameManager.CURRENT_SPIRIT = 0
    GameManager.resetSpiritIndex()
    GameManager.setCurrentSpirit(0)

    if Game.MODE == "CHALLENGE" then
        self.towerDistance_ = GameManager.TOWER_DISTANCE
    elseif Game.MODE == "DIARY" then
        self.towerDistance_ = GameManager.TOWER_DISTANCE
    elseif Game.MODE == "ACTIVITY" then
        self.towerDistance_ = GameManager.TOWER_DISTANCE
    else
        local stageModel = DataUtils.getStageModel(GameManager.STAGE_NUM)
        self.towerDistance_ = tonumber(stageModel.towerDistance_)
    end
    self.minZoomRatio_ = 2 - self.towerDistance_ / 1000

    self.zoomRatio_ = 2.5
    self.touchPoint1_ = cc.p(0,0)
    self.touchPoint2_ = cc.p(0,0)

    self.fingerDistance_ = 0
end

function GameScene:initTower( mode )

    local towerMonsterModel = nil

    if mode == "CHALLENGE" then
        towerMonsterModel = DataUtils.getTowerMonsterModel(GameManager.STAGE_NUM_CHALLENGE, mode)
    elseif mode == "DIARY" then
        towerMonsterModel = DataUtils.getTowerMonsterModel(GameManager.STAGE_NUM_DIARY, mode)
    elseif mode == "ACTIVITY" then
        towerMonsterModel = DataUtils.getTowerMonsterModel(GameManager.STAGE_NUM,mode)
    else
        towerMonsterModel = DataUtils.getTowerMonsterModel(GameManager.STAGE_NUM, mode)
    end

    local towerBuddhaModel  = DataUtils.getTowerBuddhaModel()
    --    table.sort(towerMonsterModel.monsterIds_)
    --    for i,v in pairs(towerMonsterModel.monsterIds_) do
    --        print(i.."_"..v)
    --    end

    -- 敌方塔x位置
    local x = self.bg1_:getContentSize().width/2 - self.towerDistance_/2;
    -- 敌方塔
    self.towerMonster_ = TowerMonster.new(towerMonsterModel):addTo(self.bg1_)
    self.towerMonster_:setPosition(cc.p(x, display.height * 0.22))
    -- 我方塔
    self.towerBuddha_ = TowerBuddha.new(towerBuddhaModel):addTo(self.bg1_)
    self.towerBuddha_:setPosition(cc.p(x + self.towerDistance_,display.height * 0.22))

    -- 清场怪出场时间
    self.cleanTime_ = tonumber(towerMonsterModel.cleanTime_)

    -- 存储
    Game.TOWER_MONSTER = self.towerMonster_
    Game.TOWER_BUDDHA = self.towerBuddha_
end

function GameScene:initUI(mode)

    -- 暂停按钮
    self.pauseBtn_ = PauseBtn.new()
    self.pauseBtn_:setPosition(display.width * 0.07, display.height * 0.93)
    self:addChild(self.pauseBtn_, 4)

    -- 倒计时标识
    if self.cleanTime_ > 0 then
        self.timer_ = TimerIcon.new(self.cleanTime_)
        self.timer_:setPosition(display.width * 0.4, display.height * 0.93)
        self:addChild(self.timer_,4)
    end
    
    -- 二倍速按钮
    self.speedBtn_ = SpeedBtn.new()
    self.speedBtn_:setPosition(display.width * 0.61, display.height * 0.93 )
    self:addChild(self.speedBtn_, 4)

    -- 灵气计数器
    self.spiritCounter_ = SpiritCounter.new()
    self.spiritCounter_:setPosition(display.width * 0.9, display.height * 0.905)
    self:addChild(self.spiritCounter_,4)

    Game.SPIRIT_COUNTER = self.spiritCounter_

    -- 关卡编号牌 stagePanel
    if mode == "CHALLENGE" or mode == "DIARY" or mode == "ACTIVITY" then

    else
        local stagePanel = display.newSprite("gamescene/stageNum.png",display.width * 0.25,display.height * 0.945):addTo(self,4)
        stagePanel:setScale(0.9)
        local stageNum = cc.ui.UILabel.newBMFontLabel_({text = ""..GameManager.STAGE_NUM, font = "fonts/whiteNum.fnt"})
        stageNum:setPosition(stagePanel:getContentSize().width * 0.5, stagePanel:getContentSize().height * 0.45)
        stagePanel:addChild(stageNum)
    end


    -- 底部木纹装饰
    display.newSprite("gamescene/wood.png",display.cx, 42):addTo(self,4)

    -- 左下角
    self.upgradeBtn_ = UpgradeBtn.new()
    self.upgradeBtn_:setPosition(cc.p(self.upgradeBtn_:getContentSize().width * 0.5, self.upgradeBtn_:getContentSize().height * 0.5))
    self:addChild(self.upgradeBtn_,5)

    --右下角
    self.fireBtn_ = FireBtn.new()
    self.fireBtn_:setPosition(cc.p(display.width - self.fireBtn_:getContentSize().width * 0.5, self.fireBtn_:getContentSize().height * 0.5))
    self:addChild(self.fireBtn_,5)

    --出兵按钮
    Game.TEAM_ICON = {}
    local teamInfo = DataUtils.getBuddhaTableOnTeam()
    for i, buddhaId in pairs(teamInfo) do
        if buddhaId ~= "" then
            local buddhaModel = DataUtils.getBuddhaModel(tonumber(buddhaId))
            local icon = UnitIcon.new(buddhaModel):addTo(self,6)
            icon:setPosition(cc.p(display.cx + display.height * 0.17 * (i - 3.5), display.height * 0.1))
            icon.idx_ = i    --标记当前兵种位于队列的第几号位置
            Game.TEAM_ICON[#Game.TEAM_ICON + 1] = icon
        end
    end
end


function GameScene:initItems(mode)

    -- if mode == "NORMAL" then
    --     Game.SKILL_ITEM_ICON = {}
    --     for i = 1, 6 do
    --         local icon = SkillItemIcon.new(i)
    --         icon:setPosition(cc.p(display.width - 64, display.height * 0.1 * (9-i)))
    --         self:addChild(icon,6)
    --         Game.SKILL_ITEM_ICON[#Game.SKILL_ITEM_ICON + 1] = icon
    --     end
    -- endK!

    Game.SKILL_ITEM_ICON = {}
    for i = 1, 6 do
        local icon = SkillItemIcon.new(i)
        icon:setPosition(cc.p(display.width - 64, display.height * 0.1 * (9-i)))
        icon:setVisible(false)
        if mode == "NORMAL" or mode == "ACTIVITY" then
            icon:setVisible(true)
        end
        self:addChild(icon,6)
        Game.SKILL_ITEM_ICON[#Game.SKILL_ITEM_ICON + 1] = icon
    end
end


function GameScene:initBG( mode )

    local bgPath = ""
    local bgMiddlePath = ""
    local bgSkyPath = ""

    --精简版
    if GameManager.IS_LITE_VERSION then
        local num = math.random(1,2)
        if num == 2 then num = 5 end
        bgPath = string.format("gamescene/bg%d.png",num)
        bgMiddlePath = string.format("gamescene/bg_middle%d.png",num)
        bgSkyPath = string.format("gamescene/bg_sky%d.jpg",num)
    else
        --完整版
        if mode == "NORMAL" then
            local num = 0
            if GameManager.STAGE_NUM == 0 then num = 1 else
                num = 1 + ( GameManager.STAGE_NUM - 1 )% 10
            end
            bgPath = string.format("gamescene/bg%d.png",num)
            bgMiddlePath = string.format("gamescene/bg_middle%d.png",num)
            bgSkyPath = string.format("gamescene/bg_sky%d.jpg",num)
        elseif mode == "DIARY" then
            local num = 0
            if GameManager.STAGE_NUM_DIARY <=3 then
                num = 1
            elseif GameManager.STAGE_NUM_DIARY <= 6 then
                num = 2
            elseif GameManager.STAGE_NUM_DIARY <= 9 then
                num = 3
            end
            bgPath = string.format("gamescene/bg_d%d.png",num)
            bgMiddlePath = string.format("gamescene/bg_middle_d%d.png",num)
            bgSkyPath = string.format("gamescene/bg_sky_d%d.jpg",num)
        elseif mode == "CHALLENGE" then
            local num = 1
            bgPath = string.format("gamescene/bg_c%d.png",num)
            bgMiddlePath = string.format("gamescene/bg_middle_c%d.png",num)
            bgSkyPath = string.format("gamescene/bg_sky_c%d.jpg",num)
        elseif mode == "ACTIVITY" then
            if GameManager.ACTIVITY_STAGE_TYPE == 1 then
                bgPath = "gamescene/bg9.png"
                bgMiddlePath = "gamescene/bg_middle9.png"
                bgSkyPath = "gamescene/bg_sky9.jpg"
            elseif GameManager.ACTIVITY_STAGE_TYPE == 2 then
                bgPath = "gamescene/bg10.png"
                bgMiddlePath = "gamescene/bg_middle10.png"
                bgSkyPath = "gamescene/bg_sky10.jpg"
            elseif GameManager.ACTIVITY_STAGE_TYPE == 3 then
                bgPath = string.format("gamescene/bg_d%d.png",GameManager.ACTIVITY_STAGE_TYPE)
                bgMiddlePath = string.format("gamescene/bg_middle_d%d.png",GameManager.ACTIVITY_STAGE_TYPE)
                bgSkyPath = string.format("gamescene/bg_sky_d%d.jpg",GameManager.ACTIVITY_STAGE_TYPE)
            end 
        end
    end


    self.pointBg1_ = cc.p(display.cx - self.zoomRatio_ * self.towerDistance_/2, display.height * 0.2);

    self.bg1_ = display.newSprite(bgPath, display.cx - self.zoomRatio_ * self.towerDistance_/2, display.height * 0.2):addTo(self)
    self.bg1_:setAnchorPoint(cc.p(0.5,0.2))
    self.bg1_:setScale(self.zoomRatio_)

    Game.BG1 = self.bg1_

    self.bg2_ = display.newSprite(bgMiddlePath, display.cx - self.zoomRatio_ * self.towerDistance_/2, display.height * 0.2):addTo(self,-1)
    self.bg2_:setAnchorPoint(cc.p(0.5,0.2))
    self.bg2_:setScale(self.zoomRatio_)

    self.bg3_ = display.newSprite(bgSkyPath, display.cx - self.zoomRatio_ * self.towerDistance_/2, display.height * 0.2):addTo(self,-2)
    self.bg3_:setAnchorPoint(cc.p(0.5,0.2))
    self.bg3_:setScale(self.zoomRatio_)

end

function GameScene:initTouchEvent()
    --    self.cursors = {}
    --    self.touchIndex = 0

    --    local labelPoints = cc.ui.UILabel.new({text = "", size = 24})
    --        :align(display.CENTER_TOP, display.cx, display.top - 120)
    --        :addTo(self)
    --
    --    local label1 = cc.ui.UILabel.new({text = "", size = 24})
    --        :align(display.CENTER_TOP, display.cx, display.bottom + 120)
    --        :addTo(self)

    -- 启用触摸
    self.bg1_:setTouchEnabled(true)
    -- 设置触摸模式
    self.bg1_:setTouchMode(cc.TOUCH_MODE_ALL_AT_ONCE) -- 多点
    -- 添加触摸事件处理函数
    self.bg1_:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        -- event.name 是触摸事件的状态：began, moved, ended, cancelled, added（仅限多点触摸）, removed（仅限多点触摸）
        -- event.points 包含所有触摸点，按照 events.point[id] = {x = ?, y = ?} 的结构组织
        --        local str = {}
        --        for id, point in pairs(event.points) do
        --            str[#str + 1] = string.format("id: %s, x: %0.2f, y: %0.2f", point.id, point.x, point.y)
        --        end
        --        local pointsCount = #str
        --        table.sort(str)
        --        labelPoints:setString(table.concat(str, "\n"))

        if event.name == "began" or event.name == "added" then
            --self.touchIndex = self.touchIndex + 1
            for id, point in pairs(event.points) do
                --                local cursor = display.newSprite("Cursor.png")
                --                    :pos(point.x, point.y)
                --                    :scale(1.2)
                --                    :addTo(self)
                --                self.cursors[id] = cursor

                if point.id == "0" then
                    --print("touch point 1")
                    self.touchPoint1 = point
                elseif point.id == "1" then
                    --print("touch point 2")
                    self.touchPoint2 = point
                    self.fingerDistance_ = dist(self.touchPoint1, self.touchPoint2)
                    --print("distance : "..self.distance_)
                end
            end

        elseif event.name == "moved" then
            for id, point in pairs(event.points) do
                --                local cursor = self.cursors[id]
                --                local rect = self.bg1_:getBoundingBox()
                --                if cc.rectContainsPoint(rect, cc.p(point.x, point.y)) then
                --                    -- 检查触摸点的位置是否在矩形内
                --                    cursor:setPosition(point.x, point.y)
                --                    cursor:setVisible(true)
                --                else
                --                    cursor:setVisible(false)
                --                end

                if point.id == "0" then
                    local px,py = self.bg1_:getPosition()
                    --print("bg1 pos : "..px..",,,,,"..py)
                    self.bg1_:setPosition(cc.pAdd(cc.p(self.bg1_:getPosition()),cc.p(2 * (point.x - self.touchPoint1.x),0)))
                    --print("touch point 1")
                    self.touchPoint1 = point
                elseif point.id == "1" then
                    --print("touch point 2")
                    self.touchPoint2 = point
                    local curDistance = dist(self.touchPoint1, self.touchPoint2)
                    --print("distance : "..self.distance_)
                    local curRatio = curDistance/self.fingerDistance_;
                    self.zoomRatio_ = self.zoomRatio_ * curRatio

                    self.fingerDistance_ = curDistance

                    if self.zoomRatio_ > 2.5 then
                        self.zoomRatio_ = 2.5
                    elseif self.zoomRatio_ < self.minZoomRatio_ + 0.2 then
                        self.zoomRatio_ = self.minZoomRatio_ + 0.2
                    end

                    self.bg1_:setScale(self.zoomRatio_)
                    self.bg2_:setScale(self.zoomRatio_)
                    self.bg3_:setScale(self.zoomRatio_)
                end
            end
        elseif event.name == "removed" then
        --            for id, point in pairs(event.points) do
        --                self.cursors[id]:removeSelf()
        --                self.cursors[id] = nil
        --            end
        else
        --            for _, cursor in pairs(self.cursors) do
        --                cursor:removeSelf()
        --            end
        --            self.cursors = {}
        end

        --        local label = string.format("sprite: %s , count = %d, index = %d", event.name, pointsCount, self.touchIndex)
        --        label1:setString(label)

        --        if event.name == "ended" or event.name == "cancelled" then
        --            label1:setString("")
        --            labelPoints:setString("")
        --        end

        -- 返回 true 表示要响应该触摸事件，并继续接收该触摸事件的状态变化
        return true
    end)
end

--滑动屏幕所做限制
function GameScene:moveScreen()
    -- self.bg1_ 左边界
    if (self.bg1_:getPositionX() >= (self.bg1_:getContentSize().width/2 - 0.5 * ( 1000 - self.towerDistance_ )) * self.zoomRatio_ - 2) then
        self.bg1_:setPositionX((self.bg1_:getContentSize().width/2 - 0.5 * (1000 - self.towerDistance_)) * self.zoomRatio_ - 2)
    end
    -- self.bg1_ 右边界
    if (self.bg1_:getPositionX() <= display.width/2 - ((self.bg1_:getContentSize().width/2 - 0.5*(1000 - self.towerDistance_)) * self.zoomRatio_ - display.width/2) + 2) then
        self.bg1_:setPositionX( display.width/2 - ((self.bg1_:getContentSize().width/2 - 0.5*(1000 - self.towerDistance_)) * self.zoomRatio_ - display.width/2) + 2)
    end

    -- 视差计算
    local distanceBgMoved = self.bg1_:getPositionX() - self.pointBg1_.x
    self.bg2_:setPosition(cc.pAdd(cc.p(self.bg2_:getPosition()),cc.p(distanceBgMoved * 0.75,0)))
    self.bg3_:setPosition(cc.pAdd(cc.p(self.bg3_:getPosition()),cc.p(distanceBgMoved * 0.5,0)))
    self.pointBg1_ = cc.p(self.bg1_:getPosition())

    -- self.bg2_ 视差层中景 左右边界
    if (self.bg2_:getPositionX() > (self.bg2_:getContentSize().width/2 - 0.5*(1000 - self.towerDistance_)) * self.zoomRatio_) then
        self.bg2_:setPositionX((self.bg2_:getContentSize().width/2 - 0.5*(1000 - self.towerDistance_)) * self.zoomRatio_)
    end
    if (self.bg2_:getPositionX() < display.width/2 - ((self.bg2_:getContentSize().width/2 - 0.5*(1000 - self.towerDistance_)) * self.zoomRatio_ - display.width/2)) then
        self.bg2_:setPositionX( display.width/2 - ((self.bg2_:getContentSize().width/2 - 0.5*(1000 - self.towerDistance_)) * self.zoomRatio_ - display.width/2))
    end
    -- self.bg3_ 视差层天空 左右边界
    if (self.bg3_:getPositionX() > (self.bg3_:getContentSize().width/2 - 0.5*(1000 - self.towerDistance_)) * self.zoomRatio_) then
        self.bg3_:setPositionX((self.bg3_:getContentSize().width/2 - 0.5*(1000 - self.towerDistance_)) * self.zoomRatio_)
    end
    if (self.bg3_:getPositionX() < display.width/2 - ((self.bg3_:getContentSize().width/2 - 0.5*(1000 - self.towerDistance_)) * self.zoomRatio_ - display.width/2)) then
        self.bg3_:setPositionX( display.width/2 - ((self.bg3_:getContentSize().width/2 - 0.5*(1000 - self.towerDistance_)) * self.zoomRatio_ - display.width/2))
    end
end

--每帧刷新
function GameScene:update( dt )
    --检测滑动屏幕
    self:moveScreen()

    local currentSpirit = GameManager.getCurrentSpirit()
    --第一关引导:点击召唤天兵小王出场
    if GameManager.STAGE_NUM == 1 and currentSpirit >= 50 and not DataUtils.getGuideIsFirstPlayed("GUIDE_STEP_MAKE_BUDDHA") then
        local guide = NoviceGuide.new(GUIDE_STEP_MAKE_BUDDHA)
        self:addChild(guide,50)
        DataUtils.setGuideIsFirstPlayed("GUIDE_STEP_MAKE_BUDDHA",true)
    end

    --第一关引导:提高灵气的上线和收集速度吧
    if GameManager.STAGE_NUM == 1 and currentSpirit >= 40 and
        currentSpirit < 45 and DataUtils.getGuideIsFirstPlayed("GUIDE_STEP_MAKE_BUDDHA")
        and not DataUtils.getGuideIsFirstPlayed("GUIDE_STEP_UPGRADE_SPIRIT") then

        local guide = NoviceGuide.new(GUIDE_STEP_UPGRADE_SPIRIT)
        self:addChild(guide,50)

        DataUtils.setGuideIsFirstPlayed("GUIDE_STEP_UPGRADE_SPIRIT",true)
    end

    -- 第一关引导查看灵气上限和当前灵气值
    if GameManager.STAGE_NUM == 1 and DataUtils.getGuideIsFirstPlayed("GUIDE_STEP_UPGRADE_SPIRIT") and currentSpirit >= 48 
        and not DataUtils.getGuideIsFirstPlayed("GUIDE_STEP_CHECK_SPIRIT_NUM") then

        local guide = NoviceGuide.new(GUIDE_STEP_CHECK_SPIRIT_NUM)
        self:addChild(guide,50)

        self:performWithDelay(function()
            if self:getChildByName("guide") then
                self:removeChild(guide,true)
            end
        end, 5.0)

        DataUtils.setGuideIsFirstPlayed("GUIDE_STEP_CHECK_SPIRIT_NUM",true)
    end

    --第二关引导发炮(红孩儿)
    if GameManager.STAGE_NUM == 2 and not DataUtils.getGuideIsFirstPlayed("GUIDE_STEP_FIRE") then
        for i, buddha in pairs(Game.MONSTER_TABLE) do
            if tonumber(buddha.model_.npcId_) == 56 then
                if buddha:getPositionX() > self.fireBtn_.toRangeX_ + 20 then
                    --强制cd置为0
                    --self.fireBtn_.isReady_ = true
                    self.fireBtn_:readyForFire()

                    local guide = NoviceGuide.new(GUIDE_STEP_FIRE)
                    self:addChild(guide,50)

                    DataUtils.setGuideIsFirstPlayed("GUIDE_STEP_FIRE",true)
                end
            end
        end
    end

    --第三关引导自动出战
    if GameManager.STAGE_NUM == 3 and DataUtils.getGuideIsFirstPlayed("GUIDE_STEP_AUTO1") and not DataUtils.getGuideIsFirstPlayed("GUIDE_STEP_AUTO2") then
        DataUtils.setGuideIsFirstPlayed("GUIDE_STEP_AUTO2",true)
        self:performWithDelay(function()
            local layer = GuideStage3Layer.new(2)
            self:addChild(layer,100)
        end,15.0)
    end

    --第五关引导道具1的使用(老君金丹)
    if GameManager.STAGE_NUM == 5 and GameManager.ITEM1_ANIMATION_SHOWED_STAGE5 and not DataUtils.getGuideIsFirstPlayed("GUIDE_STEP_ITEM1") then
        local guide = NoviceGuide.new(GUIDE_STEP_ITEM1)
        self:addChild(guide,50)

        DataUtils.setGuideIsFirstPlayed("GUIDE_STEP_ITEM1",true)
    end

    --第五关奎木狼出场时引导道具金刚盾
    if GameManager.STAGE_NUM == 5 and not DataUtils.getItemIsUnlock(2) then
        for i, buddha in pairs(Game.MONSTER_TABLE) do
            if tonumber(buddha.model_.npcId_) == 57 then
                if buddha:getPositionX() > Game.TOWER_MONSTER:getPositionX() + 10 then
                    local layer = SkillItemLayer.new(TYPE_UNLOCK,2)
                    self:addChild(layer,50)
                    DataUtils.setItemIsUnlock(2,true)
                end
            end
        end
    end

    --第五关引导道具2的使用(金刚盾)
    if GameManager.STAGE_NUM == 5 and GameManager.ITEM2_ANIMATION_SHOWED_STAGE5 and not DataUtils.getGuideIsFirstPlayed("GUIDE_STEP_ITEM2") then
        local guide = NoviceGuide.new(GUIDE_STEP_ITEM2)
        self:addChild(guide,50)

        DataUtils.setGuideIsFirstPlayed("GUIDE_STEP_ITEM2",true)
    end
end


--加载引导部分
function GameScene:initNoviceGuide_()
    --第一关滑动屏幕引导
    if GameManager.STAGE_NUM == 1 and not DataUtils.getGuideIsFirstPlayed("GUIDE_STEP_SWIPE") then
        -- self:runAction(transition.sequence({cc.DelayTime:create(1.0),cc.CallFunc:create(function()
        --     local guide = NoviceGuide.new(GUIDE_STEP_SWIPE)
        --     self:addChild(guide,50,100)
        -- end),cc.DelayTime:create(4.0),cc.CallFunc:create(function()
        --     self:removeChildByTag(100, true)
        --     DataUtils.setGuideIsFirstPlayed("GUIDE_STEP_SWIPE",true)
        -- end)}))
        self:performWithDelay(function()
            local guide = NoviceGuide.new(GUIDE_STEP_SWIPE)
            self:addChild(guide,50)
            DataUtils.setGuideIsFirstPlayed("GUIDE_STEP_SWIPE",true)
        end,2.0)
    end

    --第二关伸缩屏幕引导
    if GameManager.STAGE_NUM == 2 and not DataUtils.getGuideIsFirstPlayed("GUIDE_STEP_SCREEN_ZOOM") then
        self:runAction(transition.sequence({cc.DelayTime:create(3.0),cc.CallFunc:create(function()
            local guide = NoviceGuide.new(GUIDE_STEP_SCREEN_ZOOM)
            self:addChild(guide,50,100)
        end),cc.DelayTime:create(4.0),cc.CallFunc:create(function()
            self:removeChildByTag(100, true)
            DataUtils.setGuideIsFirstPlayed("GUIDE_STEP_SCREEN_ZOOM",true)
        end)}))
    end

    --第三关引导自动出战
    if GameManager.STAGE_NUM == 3 and not DataUtils.getGuideIsFirstPlayed("GUIDE_STEP_AUTO1") then
        self:performWithDelay(function()
            local layer = GuideStage3Layer.new(1)
            self:addChild(layer,100)
        end,2.0)
    end

    --第五关开场引导道具老君金丹
    if GameManager.STAGE_NUM == 5 and not DataUtils.getItemIsUnlock(1) then --CloudData.ITEM1_UNLOCK == 0 then
        self:performWithDelay(function()
            DataUtils.setItemIsUnlock(1,true)
            local layer = SkillItemLayer.new(TYPE_UNLOCK,1)
            self:addChild(layer,50)

            --todo:联网存储
            --            local ac = AlertConnection.new(CONNECTION_GUIDE,"item1")
            --            self:addChild(ac,100,12345)
            --
            --            self.scheduleItem1_ = self:schedule(function()
            --                if not self:getChildByTag(12345) then
            --                    self:stopAction(self.scheduleItem1_)
            --
            --                    local layer = SkillItemLayer.new(TYPE_UNLOCK,1)
            --                    self:addChild(layer,50)
            --                    CloudData.ITEM1_UNLOCK = 1
            --                end
            --            end,0.1)
        end, 3.0)
    end

    --第六关开场引导道具芭蕉扇
    if GameManager.STAGE_NUM == 6 and not DataUtils.getItemIsUnlock(3) then --CloudData.ITEM3_UNLOCK == 0 then
        self:performWithDelay(function()
            DataUtils.setItemIsUnlock(3,true)
            local layer = SkillItemLayer.new(TYPE_UNLOCK,3)
            self:addChild(layer,50)

            --todo:联网存储
            --            local ac = AlertConnection.new(CONNECTION_GUIDE,"item3")
            --            self:addChild(ac,100,12345)
            --
            --            self.scheduleItem3_ = self:schedule(function()
            --                if not self:getChildByTag(12345) then
            --                    self:stopAction(self.scheduleItem3_)
            --
            --                    local layer = SkillItemLayer.new(TYPE_UNLOCK,3)
            --                    self:addChild(layer,50)
            --                    CloudData.ITEM3_UNLOCK = 1
            --                end
            --            end,0.1)
        end, 3.0)
    end

    --第七关开场引导道具金钟罩
    if GameManager.STAGE_NUM == 7 and not DataUtils.getItemIsUnlock(4) then --CloudData.ITEM4_UNLOCK == 0 then
        self:performWithDelay(function()
            DataUtils.setItemIsUnlock(4,true)
            local layer = SkillItemLayer.new(TYPE_UNLOCK,4)
            self:addChild(layer,50)

            --            --todo:联网存储
            --            local ac = AlertConnection.new(CONNECTION_GUIDE,"item4")
            --            self:addChild(ac,100,12345)
            --
            --            self.scheduleItem4_ = self:schedule(function()
            --                if not self:getChildByTag(12345) then
            --                    self:stopAction(self.scheduleItem4_)
            --
            --                    local layer = SkillItemLayer.new(TYPE_UNLOCK,4)
            --                    self:addChild(layer,50)
            --                    CloudData.ITEM4_UNLOCK = 1
            --                end
            --            end,0.1)
        end, 3.0)
    end

    --第九关开场引导道具卐字符
    if GameManager.STAGE_NUM == 9 and not DataUtils.getItemIsUnlock(5) then--CloudData.ITEM5_UNLOCK == 0 then
        self:performWithDelay(function()
            DataUtils.setItemIsUnlock(5,true)
            local layer = SkillItemLayer.new(TYPE_UNLOCK,5)
            self:addChild(layer,50)

            --            --todo:联网存储
            --            local ac = AlertConnection.new(CONNECTION_GUIDE,"item5")
            --            self:addChild(ac,100,12345)
            --
            --            self.scheduleItem5_ = self:schedule(function()
            --                if not self:getChildByTag(12345) then
            --                    self:stopAction(self.scheduleItem5_)
            --
            --                    local layer = SkillItemLayer.new(TYPE_UNLOCK,5)
            --                    self:addChild(layer,50)
            --                    CloudData.ITEM5_UNLOCK = 1
            --                end
            --            end,0.1)
        end, 3.0)
    end

    --第十关开场引导道具献宝令
    if GameManager.STAGE_NUM == 10 and not DataUtils.getItemIsUnlock(6) then --CloudData.ITEM6_UNLOCK == 0 then
        self:performWithDelay(function()
            DataUtils.setItemIsUnlock(6,true)
            local layer = SkillItemLayer.new(TYPE_UNLOCK,6)
            self:addChild(layer,50)

            --todo:联网存储
            --            local ac = AlertConnection.new(CONNECTION_GUIDE,"item6")
            --            self:addChild(ac,100,12345)
            --
            --            self.scheduleItem6_ = self:schedule(function()
            --                if not self:getChildByTag(12345) then
            --                    self:stopAction(self.scheduleItem6_)
            --
            --                    local layer = SkillItemLayer.new(TYPE_UNLOCK,6)
            --                    self:addChild(layer,50)
            --                    CloudData.ITEM6_UNLOCK = 1
            --                end
            --            end,0.1)
        end, 3.0)
    end
end


function GameScene:onEnter()
end

function GameScene:onExit()
    print("onExit GameScene")

    self:removeAllChildren(true)

    local manager = ccs.ArmatureDataManager:getInstance()
    for k,v in pairs(manager:getArmatureDatas()) do
        manager:removeArmatureFileInfo(string.format("animation/%s/%s.csb",k,k))
        manager:removeArmatureFileInfo(string.format("armature/%s/%s.csb",k,k))
    end

    -- purge texture cache
    display.removeUnusedSpriteFrames()
end

function GameScene:addAndroidReturnButton_()
    --退出游戏
    local btn = cc.ui.UIPushButton.new():addTo(self)
    btn:setKeypadEnabled(true)
    btn:addNodeEventListener(cc.KEYPAD_EVENT, function (event)
        if event.key == "back" then
            self:showReturnWarning_()
        end
    end)
end

function GameScene:showReturnWarning_()
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

return GameScene