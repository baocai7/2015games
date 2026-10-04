
--[[=============================================================================
#     FileName: InfiniteModeEntrance.lua
#         Desc: 无尽模式入口UI布置
#       Author: Hoo
#   LastChange: 2015-03-21 
#      History:
=============================================================================]]

local AlertConnection   = import("customs.AlertConnection")
local RoundListIcon     = import("icons.RoundListIcon")
local ChangeNameLayer   = import("layers.ChangeNameLayer")
local ChartLayer             = import("layers.ChartLayer")

local InfiniteModeEntrance = {}
InfiniteModeEntrance = class("InfiniteModeEntrance", function()
    return display.newScene("InfiniteModeEntrance")
end)   

TAG_DAILY_NEW         = 1
TAG_STAGE_NEW         = 2
TAG_ACHIEVEMENT_NEW   = 3      

function InfiniteModeEntrance:ctor()
    -- 播放音效(打开层)
    if GameManager.SOUND_SWITCH_ON then
        audio.playSound(string.format("sounds/sfx_touch_ti.%s",GameManager.POSTFIX))
    end

    -- 标记：无尽模式
    GameManager.INFINITE_MODE = true
    GameManager.INFINITE_STAGE_NUM = CloudData.INFINITE_STAGE_PROGRESS

    -- 初始化UI
    self:initUI_()

    -- 初始化阶层
    self:initFloorUI_(CloudData.INFINITE_STAGE_PROGRESS)

    -- 创建敌方兵种信息列表
    self:createListView_()

    self:addAndroidReturnButton_()

    -- 检测是否领奖,刷新列表
    -- self.schedule_ = self:schedule(function() 
    --     self:updateListView_()
    -- end,0.03)              
end



--初始化界面UI
function InfiniteModeEntrance:initUI_()
    -- 背景
    self.bg_ = display.newSprite("game_infinite/bg_frame.jpg",display.cx,display.cy)
    self:addChild(self.bg_)

    -- 昵称
    self.nameLabel_ = cc.ui.UILabel.new({UILabelType = 2,text = CloudData.NICK_NAME,size = 25,color = display.COLOR_WHITE,font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,self.bg_:getContentSize().width * 0.30,self.bg_:getContentSize().height * 0.93)
        :addTo(self.bg_,2)

    -- 当前最高纪录 
    local str = string.format("第%d层%d波",CloudData.INFINITE_STAGE_PROGRESS,CloudData.INFINITE_WAVES_PROGRESS)
    self.bestRecordLabel_ = cc.ui.UILabel.new({UILabelType = 2,text = str,size = 25,color = cc.c3b(0,255,0),font = GameManager.FONTNAME_TTF})
        :align(display.CENTER_LEFT,self.bg_:getContentSize().width * 0.67,self.bg_:getContentSize().height * 0.93)
        :addTo(self.bg_,2)

    -- 妖怪信息显示
    self.infoTip_ = display.newSprite("game_infinite/tips.png",self.bg_:getContentSize().width * 0.45,self.bg_:getContentSize().height * 0.59)
        :hide()
        :addTo(self.bg_,10)
        -- 等级
    self.levelLabel_ = cc.ui.UILabel.new({UILabelType = 2,text = string.format("等级:%d",0),size = 20,color = display.COLOR_WHITE,font = GameManager.FONTNAME_TTF})
        :align(display.CENTER_LEFT,self.infoTip_:getContentSize().width * 0.1,self.infoTip_:getContentSize().height * 0.60)
        :addTo(self.infoTip_,2)
        -- 血量
    self.bloodLabel_ = cc.ui.UILabel.new({UILabelType = 2,text = string.format("血量:%d",0),size = 20,color = display.COLOR_WHITE,font = GameManager.FONTNAME_TTF})
        :align(display.CENTER_LEFT,self.infoTip_:getContentSize().width * 0.1,self.infoTip_:getContentSize().height * 0.40)
        :addTo(self.infoTip_,2)
        -- 攻击
    self.attackLabel_ = cc.ui.UILabel.new({UILabelType = 2,text = string.format("攻击力:%d",0),size = 20,color = display.COLOR_WHITE,font = GameManager.FONTNAME_TTF})
        :align(display.CENTER_LEFT,self.infoTip_:getContentSize().width * 0.1,self.infoTip_:getContentSize().height * 0.20)
        :addTo(self.infoTip_,2)

    -- 修改昵称按钮
    cc.ui.UIPushButton.new({normal = "game_infinite/change_name.png",pressed = "game_infinite/change_name1.png"})
        :onButtonPressed(function()
            print("change name")
            local pLayer = ChangeNameLayer.new()
            self:addChild(pLayer,10)
        end)
        :align(display.CENTER,self.bg_:getContentSize().width * 0.46,self.bg_:getContentSize().height * 0.93)
        :addTo(self.bg_,5)

    -- 排行榜入口
    cc.ui.UIPushButton.new({normal = "game_infinite/rankings.png",pressed = "game_infinite/rankings1.png"})
        :onButtonClicked(function()
            print("ENTER RANKINGS")
            display.replaceScene(require("layers.ChartLayer").new())
        end)
        :align(display.CENTER,self.bg_:getContentSize().width * 0.87,self.bg_:getContentSize().height * 0.93)
        :addTo(self.bg_,5)

    -- 进入战斗
    cc.ui.UIPushButton.new({normal = "game_infinite/game_start.png",pressed = "game_infinite/game_start1.png"})
        :onButtonClicked(function()
            display.replaceScene(require("scenes.TinyLoadingScene").new("GAME_SCENE_INFINITE","NORMAL"))
        end)
        :align(display.CENTER,self.bg_:getContentSize().width * 0.72,self.bg_:getContentSize().height * 0.08)
        :addTo(self.bg_,5)

    -- 返回按钮
    cc.ui.UIPushButton.new({normal = "common_ui/back.png",pressed = "common_ui/back_h.png"})
        :scale(0.8)
        :onButtonPressed(function()
            self:closeCallBack_()
        end)
        -- :onButtonClicked(function()
        --  self:closeCallBack_()
        -- end)
        :align(display.CENTER,self.bg_:getContentSize().width * 0.13,self.bg_:getContentSize().height * 0.93)
        :addTo(self.bg_,5)
end

-- 初始化阶层UI --
-- 当前页面显示5层，最下层为当前进度
function InfiniteModeEntrance:initFloorUI_(currFloor)
    local posXRatioTable = {0.40,0.30,0.40,0.30,0.40}  -- X位置系数
    for i=0,4 do
        local picPath  = nil     -- 底座图片路径
        local numColor = nil     -- 层数字体颜色
        if i == 0 then
            picPath  = "game_infinite/pedestal.png"
            numColor = cc.c3b(255,255,16)
        else
            picPath  = "game_infinite/pedestal1.png"
            numColor = cc.c3b(138,81,49)
        end
        
        -- 底座
        local floorPic = display.newSprite(picPath,
            self.bg_:getContentSize().width * posXRatioTable[i + 1],self.bg_:getContentSize().height * 0.157 * (i + 1))
            :addTo(self.bg_,1)
        -- 标签
        local numFrame = display.newSprite("game_infinite/num_frame.png",0,0)
            :addTo(self.bg_,2)
        if i ==  0 then
            numFrame:setPosition(cc.p(floorPic:getPositionX(),floorPic:getPositionY() - 10))
        else
            if i % 2 == 0 then
                numFrame:setPosition(cc.p(floorPic:getPositionX() + 50,floorPic:getPositionY() - 10))
            else
                floorPic:setScaleX(-1)
                numFrame:setPosition(cc.p(floorPic:getPositionX() - 50,floorPic:getPositionY() - 10))
            end
        end
        local numLabel = cc.ui.UILabel.new({UILabelType = 2,text = string.format("第%d层",currFloor + i),
            size = 20,color = numColor,font = GameManager.FONTNAME_TTF})
            :align(display.CENTER,numFrame:getContentSize().width * 0.5,numFrame:getContentSize().height * 0.5)
            :addTo(numFrame)

        -- 奖励
        display.newSprite("game_infinite/reward_pic.png",0,0)
            :align(display.CENTER_RIGHT,numFrame:getPositionX() - 50,numFrame:getPositionY() - 40)
            :addTo(self.bg_,2)
            -- 精华石
        display.newSprite("summon_scene/essence_pic.png",numFrame:getPositionX() - 30,numFrame:getPositionY() - 40)
            :scale(0.4)
            :addTo(self.bg_,2)
            -- 随机包
        display.newSprite("game_infinite/unknown.png",numFrame:getPositionX() + 10,numFrame:getPositionY() - 40)
            :scale(0.4)
            :addTo(self.bg_,2)
            -- 妖怪碎片
        if (currFloor + i) % 5 == 0 then
            -- 读取当前层的model,解析奖励数据
            local tempStageModel = DataUtils.getInfiniteStageModel(currFloor + i) 
            if tempStageModel.monsterPieceId_ > 0 then
                display.newSprite(string.format("monster_piece_icon/piece%d.png",tempStageModel.monsterPieceId_),numFrame:getPositionX() + 50,numFrame:getPositionY() - 40)
                    :scale(0.6)
                    :addTo(self.bg_,2) 
            end  
        end

        -- 若为最底层，加上唐僧头像
        if i == 0 then
            display.newSprite("game_infinite/tang_pic.png",
                floorPic:getContentSize().width * 0.5,floorPic:getContentSize().height * 1.35)
                :addTo(floorPic)
        end
    end
end

--创建列表
function InfiniteModeEntrance:createListView_()
    -- 获取infiniteStageModel
    local infiniteStageModel = DataUtils.getInfiniteStageModel(CloudData.INFINITE_STAGE_PROGRESS)

    -- 每一波兵种的id
    self.monsterIdsPerWave_ = {}

    -- 加载成就列表
    self.listView = cc.ui.UIListView.new {
        bgColor = cc.c4b(255,255,255,0),
        --bg = "achievement/table_bg.png",
        viewRect = cc.rect(680,132,480,400),
        direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
        --scrollbarImgV = "tasks/bar.png"
        }
        :onTouch(handler(self, self.touchListener))
        :addTo(self.bg_)
    -- add items
    for i=1,#infiniteStageModel.waveIdTable_ do
        local item = self.listView:newItem()
        local content = RoundListIcon.new(i,infiniteStageModel.waveIdTable_[i])
        item:addContent(content)
        item:setItemSize(480,110)
        self.listView:addItem(item)   
        table.insert(self.monsterIdsPerWave_,content.monsterIdsTable_)
    end
    self.listView:reload()
end

-- listView监听
function InfiniteModeEntrance:touchListener(event)
    local lv = event.listView
    if "clicked" == event.name then
        local column = math.ceil(event.point.x / 80)
        if column >= 1 and column <= 6 then
            -- print("========= itemPos : "..event.itemPos)
            -- print("========= column : "..column)
            local monsterId = self.monsterIdsPerWave_[event.itemPos][column]
--            print("========= monsterId : "..monsterId)
            if monsterId ~= nil then
                self.infoTip_:show()
                -- self.infoTip_:setPosition(cc.p(self.bg_:getContentSize().width * 0.57,self.bg_:getContentSize().height * 0.78))
                self:monsterInfoShow_(monsterId)
            else
                self.infoTip_:hide()
            end
        end   
    elseif "moved" == event.name then
        self.infoTip_:hide()
    elseif "ended" == event.name then
        
    else
        --print("event name:" .. event.name)
    end
end

-- 妖怪兵种信息展示
function InfiniteModeEntrance:monsterInfoShow_(monsterId)
    local monsterModel  = DataUtils.getInfiniteMonsterModel(monsterId)
    local monsterLevel  = monsterModel.defaultLevel_
    local monsterBlood  = monsterModel.life_
    local monsterAttack = monsterModel.attackParam_

    self.levelLabel_:setString(string.format("等级:%d",monsterLevel))
    self.bloodLabel_:setString(string.format("血量:%d",monsterBlood))
    self.attackLabel_:setString(string.format("攻击力:%d",monsterAttack))
end

-- 返回章节界面
function InfiniteModeEntrance:closeCallBack_()
    if GameManager.SOUND_SWITCH_ON then
        audio.playSound(string.format("sounds/sfx_touch_shu.%s",GameManager.POSTFIX))
    end
    
    display.replaceScene(require("scenes.ChapterScene").new())
end

function InfiniteModeEntrance:onEnter()
end

function InfiniteModeEntrance:onExit()
    self:removeAllChildren()
    display.removeUnusedSpriteFrames()
end

function InfiniteModeEntrance:addAndroidReturnButton_()
    --退出游戏
    local btn = cc.ui.UIPushButton.new():addTo(self)
    btn:setKeypadEnabled(true)
    btn:addNodeEventListener(cc.KEYPAD_EVENT, function (event)
        if event.key == "back" then
            self:showReturnWarning_()
        end
    end)
end

function InfiniteModeEntrance:showReturnWarning_()
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

return InfiniteModeEntrance