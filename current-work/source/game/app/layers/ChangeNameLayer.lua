
--[[=============================================================================
#     FileName: ChangeNameLayer.lua
#         Desc: 更改用户名（便于无尽模式统计）
#       Author: Hoo
#   LastChange: 2015-03-25 
#      History:
=============================================================================]]

local AlertConnection = import("customs.AlertConnection")
local WSToast = import("utils.WSToast")

local ChangeNameLayer = class("ChangeNameLayer", function()
	return display.newLayer()
end)

function ChangeNameLayer:ctor()
    math.randomseed(os.time()) 
    -- math.randomseed(socket.gettime())
	--添加遮罩层
	display.newColorLayer(cc.c4b(0,0,0,150)):addTo(self,-1)

	--初始化基础节点
	self.emptyNode_ = display.newNode()
	self.emptyNode_:setPosition(display.cx,display.height * 0.78)
	self:addChild(self.emptyNode_)

	--弹出效果
	self.emptyNode_:setScale(0)
	local popupLayer = transition.sequence(
		{cc.ScaleTo:create(0.2, 1.1),
		cc.ScaleTo:create(0.1, 1.0)})
	self.emptyNode_:runAction(popupLayer)

   --初始化界面
   self:initUI_()
end

--初始化UI
function ChangeNameLayer:initUI_()
    --背景
    local bg = display.newSprite("game_infinite/name_bg.png")
        :addTo(self.emptyNode_)

    -- 随机昵称
    self.randomNameLable_ = ""

    --输入框
    self.editBox_ = cc.ui.UIInput.new({
        image = "activity/inputk.png",
        size = cc.size(486, 57),
        x = bg:getContentSize().width * 0.1,
        y = bg:getContentSize().height * 0.60,
        listener = function(event, editbox)
            if event == "began" then
                self:onEditBoxBegan(editbox)
            elseif event == "ended" then
                self:onEditBoxEnded(editbox)
            elseif event == "return" then
                self:onEditBoxReturn(editbox)
            elseif event == "changed" then
                self:onEditBoxChanged(editbox)
            else
                printf("EditBox event %s", tostring(event))
            end
        end
    }) 
    self.editBox_:setPlaceHolder("请输入6字以内的昵称")
    self.editBox_:setAnchorPoint(0,0.5)
    self.editBox_:setScaleX(0.85)
    self.editBox_:setReturnType(cc.KEYBOARD_RETURNTYPE_SEND)
    bg:addChild(self.editBox_)

    -- 改名提示
    cc.ui.UILabel.new({UILabelType = 2,text = "100蟠桃/次,首次免费",size = 25,color = cc.c3b(56,175,29),font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,bg:getContentSize().width * 0.50,bg:getContentSize().height * 0.40)
        :addTo(bg,2)

    -- 随机取名
    cc.ui.UIPushButton.new({normal = "game_infinite/dice.png",pressed = "game_infinite/dice.png"})
        :align(display.CENTER,bg:getContentSize().width * 0.90,bg:getContentSize().height * 0.60)
        :onButtonClicked(function()
            self:randomName_()
        end)
        :addTo(bg)

    -- 确定按钮
    cc.ui.UIPushButton.new({normal = "common_ui/confirm.png",pressed = "common_ui/confirm_h.png"})
        :scale(165/216)
        :align(display.CENTER,bg:getContentSize().width * 0.73,bg:getContentSize().height * 0.20)
        :onButtonClicked(function()
            self:confirmCallBack_()
        end)
        :addTo(bg)

    -- 关闭按钮
    cc.ui.UIPushButton.new({normal = "activity/close.png",pressed = "activity/close_h.png"})
        :scale(0.8)
        :align(display.CENTER,bg:getContentSize().width * 0.27,bg:getContentSize().height * 0.20)
        :onButtonClicked(function()
            self:closeCallBack_()
        end)
        :addTo(bg)
end

-- 随机取名
local NAMES_TABLE = import("profiles.username")
function ChangeNameLayer:randomName_()
    -- 读取随机姓名表
    local table1 = NAMES_TABLE[1]
    local table2 = NAMES_TABLE[2]
    local table3 = NAMES_TABLE[3]

    math.random(1,10000)

    local lastName = table1[math.random(2,#table1)]
    local givenName = ""
    if(math.random(1,100) > 50) then
        givenName = table2[math.random(2,#table2)]
    else
        givenName = table3[math.random(2,#table3)]
    end

    -- 模拟键盘的return
    self.editBox_:setText(string.format("%s%s",lastName,givenName))
    self:onEditBoxReturn(self.editBox_)
    
end

-- “确定”
function ChangeNameLayer:confirmCallBack_()
    -- 逻辑处理
    local ac = AlertConnection.new(CONNECTION_CHANGE_NICKNAME,self.textInput_)
    self:addChild(ac,100,12345)
    
    self.schedule_ = self:schedule(function()
        if not self:getChildByTag(12345) then
            self:stopAction(self.schedule_)

            if CloudData.CHANGE_NICKNAME_ERRORCODE == 0 then
                -- if CloudData.NICK_NAME ~= CloudData.UID then
                --     CloudData.PEACH = CloudData.PEACH - 100
                -- end
                -- 修改成功
                CloudData.NICK_NAME = self.textInput_

                display.getRunningScene().nameLabel_:setString(self.textInput_)

                -- 关闭窗口
                self:closeCallBack_()
            else
                local toast = WSToast.new(CloudData.CHANGE_NICKNAME_ERRORMSG)
                self:addChild(toast,10)
            end
        end
    end,0.1)
end

function ChangeNameLayer:onEditBoxBegan(editbox)
    printf("editBox1 event began : text = %s", editbox:getText())
    self.textInput_ = editbox:getText()
end

function ChangeNameLayer:onEditBoxEnded(editbox)
    printf("editBox1 event ended : %s", editbox:getText())
    self.textInput_ = editbox:getText()
    
end

function ChangeNameLayer:onEditBoxReturn(editbox)
    printf("editBox1 event return : %s", editbox:getText())
    self.textInput_ = editbox:getText()
    
end

function ChangeNameLayer:onEditBoxChanged(editbox)
    printf("editBox1 event changed : %s", editbox:getText())
    self.textInput_ = editbox:getText()
end

function ChangeNameLayer:closeCallBack_()
    local popupLayer = transition.sequence({cc.ScaleTo:create(0,1.0),
        cc.ScaleTo:create(0.1,1.1),
        cc.ScaleTo:create(0.2,0),cc.CallFunc:create(function()
            self:removeSelf()
        end)
        })
    self.emptyNode_:runAction(popupLayer)
end


return ChangeNameLayer