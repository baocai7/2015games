--
--游戏剧情
--

DIALOGUE_STAGE0_1                = 1
DIALOGUE_STAGE0_2                = 2
DIALOGUE_STAGE0_3                = 3
DIALOGUE_STAGE0_4                = 4
DIALOGUE_STAGE0_5                = 5
DIALOGUE_STAGE0_6                = 6
DIALOGUE_STAGE0_7                = 7
DIALOGUE_STAGE0_8                = 8
DIALOGUE_TIANJIANG_UNLOCK        = 9
DIALOGUE_UPGRADE                 = 10
DIALOGUE_TREASURE                = 11

import("utils.WordsTool")
local CSVParser = import("utils.CSVParser")

local GameDialogue = class("GameDialogue", function()
    return display.newLayer()
end)

function GameDialogue:ctor(dialogueId,dialogueType)
    
    if GameManager.SOUND_SWITCH_ON then 
        audio.playMusic(string.format("sounds/bgm_chatting.%s",GameManager.POSTFIX))
    end
    
    --dialogueType:     0->普通对话框   1->后接引导(关音乐)

    --读取引导配置文件
   local filePath = nil
    if dialogueId == DIALOGUE_STAGE0_1 then
        filePath = "dialogue/drama0_1.csv"
    elseif dialogueId == DIALOGUE_STAGE0_2 then
       filePath = "dialogue/drama0_2.csv"
    elseif dialogueId == DIALOGUE_STAGE0_3 then
       filePath = "dialogue/drama0_3.csv"
    elseif dialogueId == DIALOGUE_STAGE0_4 then
       filePath = "dialogue/drama0_4.csv"
    elseif dialogueId == DIALOGUE_STAGE0_5 then
       filePath = "dialogue/drama0_5.csv"
    elseif dialogueId == DIALOGUE_STAGE0_6 then
       filePath = "dialogue/drama0_6.csv"
    elseif dialogueId == DIALOGUE_STAGE0_7 then
       filePath = "dialogue/drama0_7.csv"
    elseif dialogueId == DIALOGUE_STAGE0_8 then
       filePath = "dialogue/drama0_8.csv"
    elseif dialogueId == DIALOGUE_TIANJIANG_UNLOCK then
        filePath = "dialogue/drama_tianjiang.csv"
    elseif dialogueId == DIALOGUE_UPGRADE then
        filePath = "dialogue/drama_upgrade.csv"  
    elseif dialogueId == DIALOGUE_TREASURE then
        filePath = "dialogue/drama_treasure.csv"  
    end

    --剧情对白类型
    if dialogueType ~= nil then
        self.dialogueType_ = 1
    else
        self.dialogueType_ = 0
    end
    
    --解析文件数据
    self:initFileData_(filePath)

    --init
    self:initUI_()
end

--解析文件数据
function GameDialogue:initFileData_(filePath)
    --将文件内容存入table
    self.dialogueContentTable_ = CSVParser.new(filePath)  

    --需要读取table的行序号
    self.rowId_ = 1

    --当前是否在播放文字
    self.isPlayText_ = false

    --剧情对白是否结束
    self.isDialogueEnd_ = false
end

--UI布置
function GameDialogue:initUI_()
    --开启遮罩层
    display.newColorLayer(cc.c4b(0,0,0,150))
        :addTo(self,-1)   

    --背景
    self.bg_ = display.newSprite("dialogue/dialogue_frame.png",display.cx,display.height * 0.13)
        :addTo(self)

    --添加左边角色
    self.leftRole_ = display.newSprite()
        :pos(self.bg_:getContentSize().width * 0.2,self.bg_:getContentSize().height * 1.85)
        :addTo(self.bg_,1)
    --右边角色
    self.rightRole_ = display.newSprite()
        :pos(self.bg_:getContentSize().width * 0.8,self.bg_:getContentSize().height * 1.85)
        :addTo(self.bg_,1) 

    --左边角色名字显示
    self.leftNameFrame_ = display.newSprite("dialogue/name_frame.png",self.bg_:getContentSize().width * 0.2,self.bg_:getContentSize().height * 0.95)
        :flipX(true)
        :addTo(self.bg_,2)
    self.leftNameLabel_ = cc.ui.UILabel.new({UILabelType = 2,text = "",size = 30,font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,self.leftNameFrame_:getContentSize().width * 0.5,self.leftNameFrame_:getContentSize().height * 0.5)  
        :addTo(self.leftNameFrame_)  
    --右边角色名字显示
    self.rightNameFrame_ = display.newSprite("dialogue/name_frame.png",self.bg_:getContentSize().width * 0.8,self.bg_:getContentSize().height * 0.95)
        :addTo(self.bg_,2)
    self.rightNameLabel_ = cc.ui.UILabel.new({UILabelType = 2,text = "",size = 30,font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,self.rightNameFrame_:getContentSize().width * 0.5,self.rightNameFrame_:getContentSize().height * 0.5)  
        :addTo(self.rightNameFrame_)         

    --添加文本
    self.textLabel_ = cc.ui.UILabel.new({
        UILabelType = 2,text = "" ,size = 30,color = cc.c3b(63,31,4),align = cc.ui.TEXT_ALIGN_LEFT,dimensions = cc.size(940,210),font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,self.bg_:getContentSize().width * 0.5,self.bg_:getContentSize().height * 0.22)
        :addTo(self.bg_)

    --添加黑色图层
    -- self.blackLayer_ = display.newColorLayer(cc.c4b(0,0,0,255))
    --     :hide()
    --     :addTo(self,10) 
    self.blackLayer_ = display.newSprite("opening_comic/bg_frame.png",display.cx,display.cy)
        :opacity(0)
        :addTo(self,10)

    --添加点击事件
    self:setTouchEnabled(true)
    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        return self:onTouch_(event.name,event.x,event.y)
    end) 

    self:nextDialogue_()    
end

--添加对白
function GameDialogue:nextDialogue_()
    local totalRows = self.dialogueContentTable_:getTotalRows() - 1 
    if self.dialogueContentTable_ ~= nil then
        if self.rowId_ > totalRows then
            --剧情对白结束
            self.isDialogueEnd_ = true
            --显示黑幕
            self.blackLayer_:show()
            self:setTouchEnabled(false)
            if self.dialogueType_ == 1 then
                self.blackLayer_:runAction(transition.sequence({cc.FadeIn:create(0.01),cc.CallFunc:create(function()
                    self:newFellow_()
                end),cc.CallFunc:create(function()
                    self:onExit()  
                end)}))
            else
                self.blackLayer_:runAction(transition.sequence({cc.FadeIn:create(1.5),cc.CallFunc:create(function()
                    self:newFellow_()
                end),cc.CallFunc:create(function()
                    self:onExit()  
                end)}))
            end
            
            return
        end

        --读取文件数据
        local rowData = self.dialogueContentTable_:objectAtIndex(self.rowId_)
        local textContent   = rowData["text"]                         --文本内容
        local leftId        = tonumber(rowData["leftId"])             --左角色id
        local leftRole      = tonumber(rowData["leftRole"])           --左角色头像地址
        local rightId       = tonumber(rowData["rightId"])            --右角色id
        local rightRole     = tonumber(rowData["rightRole"])          --右角色头像地址
        local isSprite      = tonumber(rowData["isSprite"])           --1:头像为精灵;0:头像为骨骼   
        self.newBuddhaID_   = tonumber(rowData["newBuddhaID"])       --新兵种id,若为0,则没有新兵种                                   

        --左人物说话
        if leftId > -1 then
            self.leftRole_:setVisible(true)
            self.leftNameFrame_:setVisible(true)
            --获取人物头像
            local rolePicPath = self:getRolePic_(leftId,leftRole)
            self.leftRole_:setTexture(rolePicPath)
            --获取人物名字
            local roleName = self:getRoleName_(leftId)
            self.leftNameLabel_:setString(roleName)
        else
            self.leftRole_:setVisible(false)
            self.leftNameFrame_:setVisible(false)
        end

        --右人物说话
        if rightId > -1 then
            self.rightNameFrame_:setVisible(true)
            --获取人物头像
            if isSprite == 1 then           --头像为精灵
                if self.rightArmature_ ~= nil then
                    self.rightArmature_:removeSelf()
                end

                self.rightRole_:setVisible(true)
                local rolePicPath = self:getRolePic_(rightId,rightRole)
                self.rightRole_:setTexture(rolePicPath)
            else                            --头像为骨骼
                self.rightRole_:setVisible(false)
                local rolePicPath = self:getRolePic_(rightId,rightRole)
                --加载骨骼
                ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(string.format("armature/%s/%s.csb",rolePicPath,rolePicPath))
                --创建骨骼
                if self.rightArmature_ ~= nil then
                    self.rightArmature_:removeSelf()
                end
                self.rightArmature_ = ccs.Armature:create(rolePicPath)
                self.rightArmature_:setPosition(self.bg_:getContentSize().width * 0.8,self.bg_:getContentSize().height * 0.8)
                self.bg_:addChild(self.rightArmature_)
                self.rightArmature_:setScale(self.ratio_ * 1.5)
                self.rightArmature_:getAnimation():playWithIndex(0)
            end
            
            --获取人物名字
            local roleName = self:getRoleName_(rightId)
            self.rightNameLabel_:setString(roleName)
        else
            self.rightRole_:setVisible(false)
            self.rightNameFrame_:setVisible(false)
            if self.rightArmature_ ~= nil then
                self.rightArmature_:removeSelf()
            end
        end

        --对话框文本内容
        self.wordsTable_ = WordsTool.getVariableWordsTable(textContent)
        self.countNum_ = 0     --用于文字计数,取出table里的文本
        self.schedule_ = self:schedule(function()
            self:updateText_()
        end, 0.1)
        
        --游戏暂停
        if self.isNeedPause_ == 1 then
            print("game pause")
        end

        --换到下一行
        self.rowId_ = self.rowId_ + 1
    end 
end

--更新文本内容
function GameDialogue:updateText_()
    self.countNum_ = self.countNum_ + 1
    if self.countNum_ <= #self.wordsTable_ then
        local textStr = self.wordsTable_[self.countNum_]
        self.textLabel_:setString(textStr)

        --标记当前在播放文字
        self.isPlayText_ = true
    else
        --计数归零
        self.countNum_ = 0
        --停止计时器
        self:stopAction(self.schedule_)
        --标记当前没在播放文字
        self.isPlayText_ = false
        --文字播放完成后右下小三角提示
        self:blink_()
    end
end
function GameDialogue:blink_()
    self.nextPic_ = display.newSprite("dialogue/next.png",self.bg_:getContentSize().width * 0.88,self.bg_:getContentSize().height * 0.2)
        :addTo(self.bg_,2)
        --创建动作
    local fadeOut_ = cc.FadeOut:create(0.2)
    local fadeIn_  = cc.FadeIn:create(0.2)
    local seq      = transition.sequence({fadeOut_,fadeIn_})
    self.nextPic_:runAction(cc.RepeatForever:create(seq))
end

--获取人物名字
function GameDialogue:getRoleName_(roleId)
    local nameStr = nil
    if roleId == 1 then
        nameStr = "玩家"
    elseif roleId == 2 then
        nameStr = "神秘人"
    elseif roleId == 3 then
        nameStr = "唐僧"
    elseif roleId == 4 then
        nameStr = "小天兵"
    elseif roleId == 5 then
        nameStr = "小天将"
    elseif roleId == 6 then
        nameStr = "小天兵和小天将"
    elseif roleId == 7 then
        nameStr = "沙僧"
    elseif roleId == 8 then
        nameStr = "小白龙"
    elseif roleId == 9 then
        nameStr = "喵道人"
    elseif roleId == 10 then
        nameStr = "雷震蛋"    
    elseif roleId == 11 then
        nameStr = "太上老君"
    elseif roleId == 12 then
        nameStr = "紫霞仙女"
    elseif roleId == 13 then
        nameStr = "悟空"
    elseif roleId == 14 then
        nameStr = "后裔"
    elseif roleId == 15 then
        nameStr = "九天玄女"
    elseif roleId == 16 then
        nameStr = "无天"
    elseif roleId == 17 then
        nameStr = "孙悟空"
    elseif roleId == 18 then
        nameStr = "猪八戒"
    elseif roleId == 19 then
        nameStr = "沙僧"
    elseif roleId == 20 then    
        nameStr = "合体"
    end
   
    return nameStr
end

--获取人物头像
function GameDialogue:getRolePic_(roleId,rolePic)
    --人物ID;  1----玩家
    --         2----神秘人   
    --         3----唐僧
    --         4----小天兵
    --         5----小天将
    --         6----小天兵和小天将合图
    --         7----沙僧
    --         8----小白龙
    --         9----喵道人
    --         10----雷震蛋
    --         11----老君
    --         12----紫霞
    --         13----悟空
    --         14----后裔  64
    --         15----九天玄女 61
    --         16----地藏王
    --         17----龙女
    local rolePicPath = nil
    local buddhaModel = DataUtils.getBuddhaModel(rolePic)
    self.ratio_ = buddhaModel.sizeInBattle_
    if roleId == 1 then
        rolePicPath = string.format("dialogue/player"..rolePic..".png")
    elseif roleId == 2 then
        rolePicPath = string.format("dialogue/mysterious_man"..rolePic..".png")
    elseif roleId == 3 then
        rolePicPath = string.format("dialogue/tangseng/tangseng"..rolePic..".png")
    elseif roleId == 4 then
        rolePicPath = string.format("dialogue/tianbing/tianbing"..rolePic..".png")
    elseif roleId == 5 then
        rolePicPath = string.format("dialogue/tianjiang/tianjiang"..rolePic..".png")
    elseif roleId == 6 then
        rolePicPath = string.format("dialogue/tianbingtianjiang"..rolePic..".png")
    elseif roleId == 7 then
        rolePicPath = string.format(buddhaModel.hurtFrame_)
    elseif roleId == 8 then
        rolePicPath = string.format(buddhaModel.hurtFrame_)
    elseif roleId == 9 then
        rolePicPath = string.format(buddhaModel.hurtFrame_)
    elseif roleId == 10 then
        rolePicPath = string.format(buddhaModel.hurtFrame_)
    elseif roleId == 11 then
        rolePicPath = string.format(buddhaModel.hurtFrame_)
    elseif roleId == 12 then
        rolePicPath = string.format(buddhaModel.hurtFrame_)
    elseif roleId == 13 then
        rolePicPath = string.format(buddhaModel.hurtFrame_)
    elseif roleId == 14 then
        rolePicPath = string.format(buddhaModel.hurtFrame_)
    elseif roleId == 15 then
        rolePicPath = string.format(buddhaModel.hurtFrame_)
    elseif roleId == 16 then
        rolePicPath = "dialogue/wutian/wutian.png"
    elseif roleId == 17 then
        rolePicPath = "dialogue/sunwukong/suwukong.png"
    elseif roleId == 18 then
        rolePicPath = "dialogue/zhubajie/zhubajie.png"
    elseif roleId == 19 then
        rolePicPath = "dialogue/shaseng/shaseng.png"
    elseif roleId == 20 then    
        rolePicPath = "dialogue/heti.png"
    end

    return rolePicPath
end

--判断是否有新兵种出现
function GameDialogue:newFellow_()
    if self.newBuddhaID_ > 0 then
        print("newFellow")
    elseif self.newBuddhaID_ < 0 then
        print("重新刷新章节界面")
        local currScene = self:getParent()
        currScene:dealUserProgress()   
    elseif self.newBuddhaID_ == 0 then
        print("恢复战斗界面")
    end
end

--添加点击事件
function GameDialogue:onTouch_(event,x,y)
    if event == "began" then
        if self.isPlayText_ then
            --文字全部显示
            local textStr = self.wordsTable_[#self.wordsTable_]
            self.textLabel_:setString(textStr)
            --计数归零
            self.countNum_ = 0
            --停止计时器
            self:stopAction(self.schedule_)
            --标记当前没在播放文字
            self.isPlayText_ = false
            --文字播放完成后右下小三角提示
            self:blink_()
        else
            if not self.isDialogueEnd_ then
                --移除右下的小三角
                if self.nextPic_ ~= nil then
                    self.nextPic_:removeSelf()
                    self.nextPic_ = nil
                end

                --进入下一段对话
                self:nextDialogue_()
            end
        end
        return true
    end
end

function GameDialogue:onEnter()
    
end
function GameDialogue:onExit()
    audio.stopMusic()
    if not audio.isMusicPlaying() and GameManager.MUSIC_SWITCH_ON then
        audio.playMusic(string.format("sounds/bgm_theme.%s",GameManager.POSTFIX))
    end
    
    self:removeSelf()
    display.removeUnusedSpriteFrames()
    --打印纹理缓存
    --local info1 = cc.Director:getInstance():getTextureCache():getCachedTextureInfo()
    --print(info1)
end

return GameDialogue