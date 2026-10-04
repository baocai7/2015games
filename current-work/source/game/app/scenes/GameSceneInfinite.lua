
--[[=============================================================================
#     FileName: GameSceneInfinite.lua
#         Desc: 无尽模式战斗场景
#       Author: Hoo
#   LastChange: 2015-03-19 
#      History:
=============================================================================]]


local Buddha        = import("sprites.Buddha")
local Monster       = import("sprites.Monster")

local TowerBuddha   = import("sprites.TowerBuddha")
local TowerMonster  = import("sprites.TowerMonster")

local UpgradeBtn    = import("customs.gamescene.UpgradeBtn")
local FireBtn       = import("customs.gamescene.FireBtn")
local PauseBtn      = import("customs.gamescene.PauseBtn")
local SpeedBtn      = import("customs.gamescene.SpeedBtn")
local SkillItemIcon = import("customs.gamescene.SkillItemIcon")
local UnitIcon      = import("icons.UnitIcon")

local SkillItemLayer   = import("layers.SkillItemLayer")
local GuideStage3Layer = import("layers.GuideStage3Layer")

local NoviceGuide     = import("utils.NoviceGuide")
local AlertConnection = import("customs.AlertConnection")

local SpiritCounter = import("sprites.SpiritCounter")
local BattleTimer   = import("sprites.BattleTimer")

local GameSceneInfinite = {}
GameSceneInfinite = class("GameSceneInfinite",function()
    return display.newScene("GameSceneInfinite")
end)

-- 求两点间距离
local function dist(p1, p2)
    local dx = p1.x - p2.x
    local dy = p1.y - p2.y
    return math.sqrt(dx * dx + dy * dy)
end


function GameSceneInfinite:ctor()
    
    -- 背景音乐
    if GameManager.MUSIC_SWITCH_ON then
        audio.playMusic(string.format("sounds/bgm_battle1.%s",GameManager.POSTFIX))
    end

    self:initData()

    self:initBG()

    self:initTower()

    self:initUI()

    self:initItems()

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
    Game.NEAREST_BUDDHA_X_  = 10000

    Game.NEAREST_MONSTER_ = nil
    Game.NEAREST_BUDDHA_ = nil
    
    self:addAndroidReturnButton_()
    
end

-- 求最近的目标
function GameSceneInfinite:calc()
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


function GameSceneInfinite:initData( mode )

    -- 当前层的model
    self.infiniteStageModel_ = DataUtils.getInfiniteStageModel(GameManager.INFINITE_STAGE_NUM)

    Game.MODE = "INFINITE"

    Game.BUDDHA_TABLE = {}
    Game.MONSTER_TABLE = {}
    Game.INVINCIBLE = false
    Game.CDZERO = false
    Game.MONSTER_TOWER_LIFE = self.infiniteStageModel_.monsterTowerLife_

    Game.SKILL_ITEM_USE = {}
    Game.SKILL_ITEM_BUY = {}

    for i = 1, 6 do
        Game.SKILL_ITEM_USE[i] = 0
        Game.SKILL_ITEM_BUY[i] = 0
    end

    -- 敌方出兵结束
    Game.MONSTER_WAVE_OVER = false

    Game.END = false

    -- 默认 1.3倍速
    cc.Director:getInstance():getScheduler():setTimeScale(1.3)
    self.timeScale_ = 1.3

    -- 唐僧等级（无尽模式默认灵气等级最大）
    GameManager.TANGMONK_LEVEL = 8
    -- 当前灵气
--    GameManager.CURRENT_SPIRIT = 0
    GameManager.resetSpiritIndex()
    GameManager.setCurrentSpirit(0)

    -- 当前波数
    Game.ROUND_NUM = 1

    -- 塔间距
    self.towerDistance_ = self.infiniteStageModel_.towerDistance_

    -- 最小缩放倍数
    self.minZoomRatio_ = 2 - self.towerDistance_ / 1000

    -- 默认缩放倍数
    self.zoomRatio_ = 2.5

    -- 初始化点击位置
    self.touchPoint1_ = cc.p(0,0)
    self.touchPoint2_ = cc.p(0,0)

    -- 手指间距
    self.fingerDistance_ = 0
end


function GameSceneInfinite:initUI(mode)
    -- 暂停按钮
    self.pauseBtn_ = PauseBtn.new()
    self.pauseBtn_:setPosition(display.width * 0.07, display.height * 0.93)
    self:addChild(self.pauseBtn_, 4)

    -- 二倍速按钮
    self.speedBtn_ = SpeedBtn.new()
    self.speedBtn_:setPosition(display.width * 0.5, display.height * 0.93 )
    self:addChild(self.speedBtn_, 4)

    -- 灵气计数器
    self.spiritCounter_ = SpiritCounter.new()
    self.spiritCounter_:setPosition(display.cx + display.height * 0.6, display.height * 0.905)
    self:addChild(self.spiritCounter_,4)
    Game.SPIRIT_COUNTER = self.spiritCounter_

    -- 波次记录(当前第几波)
    local roundPanel = display.newSprite("game_infinite/wave_num.png",display.cx - display.height * 0.4,display.height * 0.945)
        :addTo(self,4)
    roundPanel:setScale(0.9)
    self.roundNumLabel_ = cc.ui.UILabel.newBMFontLabel_({text = ""..Game.ROUND_NUM, font = "fonts/whiteNum.fnt"})
    self.roundNumLabel_:setPosition(roundPanel:getContentSize().width * 0.5, roundPanel:getContentSize().height * 0.45)
    roundPanel:addChild(self.roundNumLabel_)

    -- 波次提示（每一波滑动出现）
    self.waveFrame_ = display.newSprite("game_infinite/wave_frame.png",0,0):addTo(self,5)
    self.waveNumLabel_ = display.newSprite(string.format("spin/%d.png",Game.ROUND_NUM),
        self.waveFrame_:getContentSize().width * 0.53,self.waveFrame_:getContentSize().height * 0.5)
        :scale(1.5)
        :addTo(self.waveFrame_)
    self:waveAction()
    
    -- 底部木纹装饰
    display.newSprite("gamescene/wood.png",display.cx, 42):addTo(self,4)

    -- 左下角灵气升级按钮
    self.upgradeBtn_ = UpgradeBtn.new()
    self.upgradeBtn_:setPosition(cc.p(self.upgradeBtn_:getContentSize().width * 0.5, self.upgradeBtn_:getContentSize().height * 0.5))
    self:addChild(self.upgradeBtn_,5)

    -- 右下角照妖镜发射按钮
    self.fireBtn_ = FireBtn.new()
    self.fireBtn_:setPosition(cc.p(display.width - self.fireBtn_:getContentSize().width * 0.5, self.fireBtn_:getContentSize().height * 0.5))
    self:addChild(self.fireBtn_,5)

    -- 底部出兵按钮
    Game.TEAM_ICON = {}
    local teamInfo = DataUtils.getBuddhaTableOnTeam()
    for i, buddhaId in pairs(teamInfo) do
        if buddhaId ~= "" then
            local buddhaModel = DataUtils.getBuddhaModel(tonumber(buddhaId))
            local icon = UnitIcon.new(buddhaModel):addTo(self,6)
            icon:setPosition(cc.p(display.cx + display.height * 0.17 * (i - 3.5), display.height * 0.1))
            icon.idx_ = i    -- 标记当前兵种位于队列的第几号位置
            Game.TEAM_ICON[#Game.TEAM_ICON + 1] = icon
        end
    end

    -- 倒计时标签
    local timer = BattleTimer.new()
    timer:setPosition(cc.p(200,display.height * 0.75))
    self:addChild(timer,5)
end

-- 波次提示的出现
function GameSceneInfinite:waveAction()
    local fadeIn  = cc.FadeIn:create(0.25)
    local fadeOut = cc.FadeOut:create(0.25)
    local moveTo1 = cc.MoveTo:create(0.25,cc.p(display.cx,display.cy))
    local moveTo2 = cc.MoveTo:create(0.25,cc.p(display.width * 1.5,display.cy))
    local spawn1  = cc.Spawn:create(fadeIn,moveTo1)
    local spawn2  = cc.Spawn:create(fadeOut,moveTo2)
    self.waveFrame_:setPosition(cc.p(-display.width * 0.5,display.cy))
    self.waveNumLabel_:setTexture(string.format("spin/%d.png",Game.ROUND_NUM))
    self.waveFrame_:runAction(transition.sequence({spawn1,cc.DelayTime:create(1.5),spawn2}))
end

-- 加载道具
function GameSceneInfinite:initItems(mode)    
    Game.SKILL_ITEM_ICON = {}         -- 前四种道具
    for i = 1, 4 do
        local icon = SkillItemIcon.new(i)
        icon:setPosition(cc.p(display.width - 64, display.height * 0.1 * (9-i)))
        self:addChild(icon,6)
        Game.SKILL_ITEM_ICON[#Game.SKILL_ITEM_ICON + 1] = icon
    end
end

-- 背景图
function GameSceneInfinite:initBG( mode )
    -- 三张背景图路径
    local bgPath       = "game_infinite/bg.png"
    local bgMiddlePath = "game_infinite/bg_middle.png"
    local bgSkyPath    = "game_infinite/bg_sky.png"

    -- 
    self.pointBg1_ = cc.p(display.cx - self.zoomRatio_ * self.towerDistance_/2, display.height * 0.2);

    self.bg1_ = display.newSprite(bgPath, display.cx - self.zoomRatio_ * self.towerDistance_/2, display.height * 0.2)
        :addTo(self)
    self.bg1_:setAnchorPoint(cc.p(0.5,0.2))
    self.bg1_:setScale(self.zoomRatio_)
    Game.BG1 = self.bg1_

    self.bg2_ = display.newSprite(bgMiddlePath, display.cx - self.zoomRatio_ * self.towerDistance_/2, display.height * 0.2)
        :addTo(self,-1)
    self.bg2_:setAnchorPoint(cc.p(0.5,0.2))
    self.bg2_:setScale(self.zoomRatio_)

    self.bg3_ = display.newSprite(bgSkyPath, display.cx - self.zoomRatio_ * self.towerDistance_/2, display.height * 0.2)
        :addTo(self,-2)
    self.bg3_:setAnchorPoint(cc.p(0.5,0.2))
    self.bg3_:setScale(self.zoomRatio_)

end


function GameSceneInfinite:initTower()
    -- 敌方塔
    local x = self.bg1_:getContentSize().width/2 - self.towerDistance_/2
    local monsterTower = TowerMonster.new("infiniteMode"):addTo(self.bg1_)
    monsterTower:setPosition(x,display.height * 0.22)
    -- local monsterTower = display.newSprite("monster_tower/12/bg.png",x,display.height * 0.22)
    --     :scale(0.4)
    --     :addTo(self.bg1_)
    -- monsterTower:setAnchorPoint(cc.p(0.5,0.2))
    Game.TOWER_MONSTER = monsterTower

    -- 我方塔
    local towerBuddhaModel  = DataUtils.getTowerBuddhaModel()
    self.towerBuddha_ = TowerBuddha.new(towerBuddhaModel)
        :addTo(self.bg1_)
    self.towerBuddha_:setPosition(cc.p(x + self.towerDistance_,display.height * 0.22))
    Game.TOWER_BUDDHA = self.towerBuddha_   
end


function GameSceneInfinite:initTouchEvent()
   
    -- 启用触摸
    self.bg1_:setTouchEnabled(true)
    -- 设置触摸模式
    self.bg1_:setTouchMode(cc.TOUCH_MODE_ALL_AT_ONCE) -- 多点
    -- 添加触摸事件处理函数
    self.bg1_:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        -- event.name 是触摸事件的状态：began, moved, ended, cancelled, added（仅限多点触摸）, removed（仅限多点触摸）
        -- event.points 包含所有触摸点，按照 events.point[id] = {x = ?, y = ?} 的结构组织
              
        if event.name == "began" or event.name == "added" then
            for id, point in pairs(event.points) do
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

-- 每帧刷新(检测滑动屏幕)
function GameSceneInfinite:update( dt )
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

function GameSceneInfinite:onEnter()

end

function GameSceneInfinite:onExit()
    print("onExit GameScene")

    self:removeAllChildren(true)

    local manager = ccs.ArmatureDataManager:getInstance()
    for k,v in pairs(manager:getArmatureDatas()) do
        manager:removeArmatureFileInfo(string.format("animation/%s/%s.ExportJson",k,k))
        manager:removeArmatureFileInfo(string.format("armature/%s/%s.ExportJson",k,k))
    end

    -- purge texture cache
    display.removeUnusedSpriteFrames()
end

function GameSceneInfinite:addAndroidReturnButton_()
    --退出游戏
    local btn = cc.ui.UIPushButton.new():addTo(self)
    btn:setKeypadEnabled(true)
    btn:addNodeEventListener(cc.KEYPAD_EVENT, function (event)
        if event.key == "back" then
            self:showReturnWarning_()
        end
    end)
end

function GameSceneInfinite:showReturnWarning_()
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

return GameSceneInfinite