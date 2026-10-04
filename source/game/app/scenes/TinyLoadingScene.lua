
local TinyLoadingScene = {}
TinyLoadingScene = class("TinyLoadingScene", function()
    return display.newScene("TinyLoadingScene")
end)

-- ios、Android的logo不同
if device.platform == "ios" or device.platform == "mac" then   
    LOGO_PATH = "common/logo_ios.png"
else
    LOGO_PATH = "common/logo.png"
end

function TinyLoadingScene:ctor( destination_scene , mode)

    self.destination_scene_ = destination_scene
    self.mode_ = mode
    --print("MODE = "..self.mode_)

    --label
    self.labelLoading_ = cc.ui.UILabel.new({text = "努力加载中...", size = 24,font = GameManager.FONTNAME_TTF})
        :align(display.CENTER, display.cx, display.bottom + 50)
        :addTo(self,5)

    if GameManager.IS_LITE_VERSION then
        self:initUI_()
    else
        self:initUI()
    end

    self:addAndroidReturnButton_()
end

function TinyLoadingScene:initUI()

    --bg
    display.newSprite("tiny_loading/bg.jpg",display.cx,display.cy):addTo(self)

    --logo
    local logo = display.newSprite(LOGO_PATH)
    logo:setScale(0.3)
    logo:setPosition(120, display.height * 0.9)
    self:addChild(logo)

    --hint
    local random1 = math.random(1,14)
    local hint = display.newSprite(string.format("tiny_loading/hint%d.png",random1))
    hint:setPosition(display.cx - display.height * 0.3, display.cy)
    self:addChild(hint)

    --role
    local random2 = math.random(1,5)
    local role = display.newSprite(string.format("tiny_loading/role%d.png",random2))
    role:setPosition(display.cx + display.height * 0.4, display.cy)
    self:addChild(role)

    --jiuwei
    cc.Texture2D:setDefaultAlphaPixelFormat( cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A4444 )
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("armature/jiuwei/jiuwei.csb")
    local jiuwei = ccs.Armature:create("jiuwei")
    jiuwei:setPosition(display.width * 0.15, display.height * 0.15)
    jiuwei:getAnimation():playWithIndex(1)
    self:addChild(jiuwei)
    cc.Texture2D:setDefaultAlphaPixelFormat( cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888 )

    --ball create
    local ball = display.newSprite("common/ball.png");
    
    -- ball rotate
    local function ballRotate()
        ball:runAction(cc.RotateBy:create(0.1,90))
    end

    -- jiuwei action
    jiuwei:runAction(
        cc.Sequence:create(
            cc.MoveBy:create(1.5,cc.p(display.width * 0.75,0)),
            cc.CallFunc:create(ballRotate,{}))
    )

    -- ball set
    ball:setPosition(display.width * 0.15,display.height * 0.1)
    self:addChild(ball)
    --    ball:runAction(cc.RepeatForever:create(cc.RotateBy:create(0.1,90)))
    ball:runAction(cc.Spawn:create(
        cc.RotateBy:create(1.5,900),
        cc.MoveBy:create(1.5,cc.p(display.width * 0.75,0))
    ))

    --loadLogic
    self:loadLogic()
end


--
function TinyLoadingScene:loadLogic()
    if self.destination_scene_ == "GAME_SCENE" then
        -- change color to rgba 4444
        cc.Texture2D:setDefaultAlphaPixelFormat( cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A4444 )

        -- start to load armature data after 2s...
        self:performWithDelay(function()
            self:loadArmatureAsync()
        end,2)
    elseif self.destination_scene_ == "CHAPTER_SCENE" then
        self:performWithDelay(function()
            display.replaceScene(require("scenes.ChapterScene").new(),"FADETR",1)
        end,2)

    elseif self.destination_scene_ == "INFINITE_MODE_ENTRANCE" then
        self:performWithDelay(function()
            display.replaceScene(require("scenes.InfiniteModeEntrance").new())
        end,2)

    elseif self.destination_scene_ == "GAME_SCENE_INFINITE" then
        cc.Texture2D:setDefaultAlphaPixelFormat( cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A4444 )
        self:performWithDelay(function()
            self:loadArmatureAsyncInfinite()
        end,2)
    end
end


-- 异步加载骨骼动画
function TinyLoadingScene:loadArmatureAsync()

    -- Async回调方法
    local function dataLoaded( percent )
        if nil ~= self.labelLoading_ then
            self.labelLoading_:setString(string.format("努力加载中...%d％",(30 + percent * 60)))
            print("加载百分比:", percent)
        end
        if percent >= 1 then
            self:loadAnimationAsync()
        end
    end

    -- 先清理干净骨骼动画数据
    local manager = ccs.ArmatureDataManager:getInstance()
    for k,v in pairs(manager:getArmatureDatas()) do
        manager:removeArmatureFileInfo(string.format("animation/%s/%s.csb",k,k))
        manager:removeArmatureFileInfo(string.format("armature/%s/%s.csb",k,k))
    end

    -- monster armature
    local towerMonsterModel = nil

    if self.mode_ == "NORMAL" then
        print("GameManager.STAGE_NUM : "..GameManager.STAGE_NUM)
        towerMonsterModel = DataUtils.getTowerMonsterModel(GameManager.STAGE_NUM, self.mode_ )
    elseif self.mode_ == "CHALLENGE" then
        print("GameManager.STAGE_NUM_CHALLENGE : "..GameManager.STAGE_NUM_CHALLENGE)
        towerMonsterModel = DataUtils.getTowerMonsterModel(GameManager.STAGE_NUM_CHALLENGE, self.mode_)
    elseif self.mode_ == "DIARY" then
        print("GameManager.STAGE_NUM_DIARY : "..GameManager.STAGE_NUM_DIARY)
        towerMonsterModel = DataUtils.getTowerMonsterModel(GameManager.STAGE_NUM_DIARY, self.mode_)
    elseif self.mode_ == "ACTIVITY" then
        print("GameManager.STAGE_NUM_DIARY : "..GameManager.STAGE_NUM)
        towerMonsterModel = DataUtils.getTowerMonsterModel(GameManager.STAGE_NUM, self.mode_)
    end

    for i, monsterId in pairs(towerMonsterModel.monsterIdsTable_) do
        if ( 0 ~= tonumber(monsterId) ) then
            local monsterModel = DataUtils.getMonsterModel(monsterId)
            print(monsterId .. " .. " .. monsterModel.hurtFrame_)
            ccs.ArmatureDataManager:getInstance():addArmatureFileInfoAsync(string.format("armature/%s/%s.csb", monsterModel.hurtFrame_, monsterModel.hurtFrame_), dataLoaded)
            print("load success")
        end
    end

    -- buddha armature
    if GameManager.STAGE_NUM ~= 0 or self.mode_ == "CHALLENGE" or self.mode_ == "DIARY" then
        local teamInfo = DataUtils.getBuddhaTableOnTeam()
        for i, buddhaId in pairs(teamInfo) do
            if buddhaId ~= "" then
                local buddhaModel = DataUtils.getBuddhaModel(tonumber(buddhaId))
                ccs.ArmatureDataManager:getInstance():addArmatureFileInfoAsync(string.format("armature/%s/%s.csb", buddhaModel.hurtFrame_, buddhaModel.hurtFrame_), dataLoaded)
            end
        end
    else
        --第0关
        local tempTeam = {53,52,2,23,1,31,27}
        for i = 1, 6 do
            local buddhaModel = DataUtils.getBuddhaModel(tempTeam[i])
            ccs.ArmatureDataManager:getInstance():addArmatureFileInfoAsync(string.format("armature/%s/%s.csb", buddhaModel.hurtFrame_, buddhaModel.hurtFrame_), dataLoaded)
        end
    end


    -- 照妖镜闪电
    local towerBuddhaModel = DataUtils.getTowerBuddhaModel()
    local level = towerBuddhaModel.wandPropertyLevelTotal_
    --print("level tower : "..level)
    if ( level < 30 ) then
        ccs.ArmatureDataManager:getInstance():addArmatureFileInfoAsync("animation/shandiantexiao1/shandiantexiao1.csb", dataLoaded)
    elseif( level < 55 ) then
        ccs.ArmatureDataManager:getInstance():addArmatureFileInfoAsync("animation/shandiantexiao2/shandiantexiao2.csb", dataLoaded)
    else
        ccs.ArmatureDataManager:getInstance():addArmatureFileInfoAsync("animation/shandiantexiao3/shandiantexiao3.csb", dataLoaded)
    end
end
function TinyLoadingScene:loadArmatureAsyncInfinite()

    -- Async回调方法
    local function dataLoaded( percent )
        if nil ~= self.labelLoading_ then
            self.labelLoading_:setString(string.format("努力加载中...%d％",(30 + percent * 60)))
        end
        if percent >= 1 then
            self:loadAnimationAsync()
        end
    end
    
    -- 先清理干净骨骼动画数据
    local manager = ccs.ArmatureDataManager:getInstance()
    for k,v in pairs(manager:getArmatureDatas()) do
        manager:removeArmatureFileInfo(string.format("animation/%s/%s.csb",k,k))
        manager:removeArmatureFileInfo(string.format("armature/%s/%s.csb",k,k))
    end

    -- 加载妖怪骨骼
    local infiniteStageModel = DataUtils.getInfiniteStageModel(CloudData.INFINITE_STAGE_PROGRESS)
    for k, v in pairs(infiniteStageModel.monsterIdsTotalTable_) do
        if ( 0 ~= tonumber(k) ) then
            local monsterModel = DataUtils.getInfiniteMonsterModel(k)
            print(k .. " .. " .. monsterModel.hurtFrame_)
            ccs.ArmatureDataManager:getInstance():addArmatureFileInfoAsync(string.format("armature/%s/%s.csb", monsterModel.hurtFrame_, monsterModel.hurtFrame_), dataLoaded)
        end
    end

    -- 加载我方兵种骨骼
    local teamInfo = DataUtils.getBuddhaTableOnTeam()
    for i, buddhaId in pairs(teamInfo) do
        if buddhaId ~= "" then
            local buddhaModel = DataUtils.getBuddhaModel(tonumber(buddhaId))
            ccs.ArmatureDataManager:getInstance():addArmatureFileInfoAsync(string.format("armature/%s/%s.csb", buddhaModel.hurtFrame_, buddhaModel.hurtFrame_), dataLoaded)
        end
    end
    
    -- 照妖镜闪电
    local towerBuddhaModel = DataUtils.getTowerBuddhaModel()
    local level = towerBuddhaModel.wandPropertyLevelTotal_
    --print("level tower : "..level)
    if ( level < 30 ) then
        ccs.ArmatureDataManager:getInstance():addArmatureFileInfoAsync("animation/shandiantexiao1/shandiantexiao1.csb", dataLoaded)
    elseif( level < 55 ) then
        ccs.ArmatureDataManager:getInstance():addArmatureFileInfoAsync("animation/shandiantexiao2/shandiantexiao2.csb", dataLoaded)
    else
        ccs.ArmatureDataManager:getInstance():addArmatureFileInfoAsync("animation/shandiantexiao3/shandiantexiao3.csb", dataLoaded)
    end
end

function TinyLoadingScene:loadAnimationAsync()

    --todo async loading
    --道具芭蕉扇旋风效果
    display.addSpriteFrames("animation/daojuxuanfeng.plist","animation/daojuxuanfeng.pvr.ccz")
    --打斗烟雾
    display.addSpriteFrames("animation/dadouyanwu.plist","animation/dadouyanwu.png")
    --死亡烟雾
    display.addSpriteFrames("animation/difangsiwangyan.plist","animation/difangsiwangyan.png")
    display.addSpriteFrames("animation/wofangsiwangyan.plist","animation/wofangsiwangyan.png")
    --灵魂 灵气
    display.addSpriteFrames("animation/siwanglinghun.plist","animation/siwanglinghun.png")
    display.addSpriteFrames("animation/lingqi.plist","animation/lingqi.png")
    --道具金钟罩
    display.addSpriteFrames("animation/zhong.plist","animation/zhong.pvr.ccz")

    --道具解锁时出现的光效
    display.addSpriteFrames("item/item_appear.plist","item/item_appear.png")
    --星星效果(道具解锁，胜利界面用到)
    display.addSpriteFrames("animation/shengli_xingxing.plist","animation/shengli_xingxing.png")

    if self.destination_scene_ == "GAME_SCENE_INFINITE" then
        print("=========无尽模式=========")
        cc.Texture2D:setDefaultAlphaPixelFormat( cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888 )
        display.replaceScene(require("scenes.GameSceneInfinite").new(),'FADETR',1)
    else
        self:enterGameScene()
    end
end

function TinyLoadingScene:enterGameScene()

    -- restore color to rgba 8888
    cc.Texture2D:setDefaultAlphaPixelFormat( cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888 )

    if self.mode_ == "NORMAL" then
        --DataEye统计关卡
        if USE_DATAEYE then  
            DCLevels.begin(GameManager.STAGE_NUM .. "")               
        end
        if GameManager.STAGE_NUM == 0 then
            -- print("进入第0关")
            -- display.replaceScene(require("scenes.GameScene0").new(self.mode_),'FADETR',1)
        else
            local stageModel = DataUtils.getStageModel(GameManager.STAGE_NUM)
            if 1 == tonumber(stageModel.isGrooveMode_) then
                print(string.format("卡槽模式 第%d关",GameManager.STAGE_NUM))
                display.replaceScene(require("scenes.GameSceneGroove").new(self.mode_),'FADETR',1)
            else
                print(string.format("普通模式 第%d关",GameManager.STAGE_NUM))
                display.replaceScene(require("scenes.GameScene").new(self.mode_),'FADETR',1)
            end
        end

    elseif self.mode_ == "CHALLENGE" then
        print(string.format("进入挑战关 %d",GameManager.STAGE_NUM_CHALLENGE))
        display.replaceScene(require("scenes.GameScene").new(self.mode_),'FADETR',1)
    elseif self.mode_ == "DIARY" then
        print(string.format("进入日常关 %d",GameManager.STAGE_NUM_DIARY))
        display.replaceScene(require("scenes.GameScene").new(self.mode_),'FADETR',1)
    elseif self.mode_ == "ACTIVITY" then
        print(string.format("进入日常关 %d",GameManager.STAGE_NUM_DIARY))
        display.replaceScene(require("scenes.GameScene").new(self.mode_),'FADETR',1)
    end

end



-- LITE VERSION LOADING
function TinyLoadingScene:initUI_()

    --两张背景
    display.newSprite("loading/bg.jpg",display.cx,display.cy):addTo(self)
    display.newSprite("loading/bg1.png",display.cx,display.cy):addTo(self,1)

    --师徒四人从四个方向出现
    --悟空
    self.wuKong_ = display.newSprite("loading/wukong.png",display.cx,-132):addTo(self,5)
    self.wuKong_:runAction(cc.MoveBy:create(0.3,cc.p(0,440)))
    --八戒
    self.baJie_ = display.newSprite("loading/bajie.png",-85,display.height * 0.52):addTo(self,4)
    self.baJie_:runAction(cc.MoveBy:create(0.3,cc.p(display.width * 0.46,0)))
    --沙僧
    self.shaSeng_ = display.newSprite("loading/shaseng.png",display.width + 107 ,display.height * 0.52):addTo(self,3)
    self.shaSeng_:runAction(cc.MoveBy:create(0.3,cc.p(-display.width * 0.46,0)))
    --唐僧
    self.tang_ = display.newSprite("loading/tangseng.png",display.cx,display.height + 161):addTo(self,2)
    self.tang_:runAction(transition.sequence({cc.MoveBy:create(0.3,cc.p(0,-350)),cc.CallFunc:create(function()
        self:action1_()
    end)}))
end
function TinyLoadingScene:action1_()
    --播放音效
    if GameManager.SOUND_SWITCH_ON then
        audio.playSound(string.format("sounds/sfx_go_1.%s",GameManager.POSTFIX))
    end

    --人物后方出现光圈
    local halo = display.newSprite("loading/halo.png",display.cx ,display.cy)
        :scale(0)
        :addTo(self,1)
    halo:runAction(transition.sequence({cc.ScaleTo:create(0.3,1.2),cc.ScaleTo:create(0.3,1.0),cc.CallFunc:create(function()
        self:action2_()
    end)}))
end
function TinyLoadingScene:action2_()
    --logo
    local logo = display.newSprite(LOGO_PATH,display.cx ,display.height * 0.23)
        :scale(3.0)
        :addTo(self,5)
    logo:runAction(transition.sequence({cc.ScaleTo:create(0.5,1.0),cc.CallFunc:create(function()
        self:action3_()
    end)}))
end
function TinyLoadingScene:action3_()
    --狐狸骨骼动画
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(string.format("armature/jiuwei/jiuwei.csb"))
    local armature = ccs.Armature:create("jiuwei")
    armature:setPosition(display.width * 0.06,display.height * 0.07)
    armature:setScale(0.8)
    armature:getAnimation():playWithIndex(1)
    self:addChild(armature,10)

    armature:runAction(transition.sequence({cc.MoveBy:create(1.5,cc.p(display.width * 0.85,0)),cc.CallFunc:create(function()
        --loadLogic
        self:loadLogic()
    end)}))

    --圆球滚动
    local ball = display.newSprite("common/ball.png",display.width * 0.11,display.height * 0.1)
        :scale(0.8)
        :addTo(self,10)
    local spawn = cc.Spawn:create(cc.RotateBy:create(1.5,900),cc.MoveBy:create(1.5,cc.p(display.width * 0.85,0)))
    ball:runAction(spawn)
end

function TinyLoadingScene:addAndroidReturnButton_()
    --退出游戏
    local btn = cc.ui.UIPushButton.new():addTo(self)
    btn:setKeypadEnabled(true)
    btn:addNodeEventListener(cc.KEYPAD_EVENT, function (event)
        if event.key == "back" then
            self:showReturnWarning_()
        end
    end)
end

function TinyLoadingScene:showReturnWarning_()
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

return TinyLoadingScene
