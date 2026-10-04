--
--设置账号弹窗
--
local WSToast = import("utils.WSToast")
local AlertConnection = import("customs.AlertConnection")

local SetAccountLayer = {} 
SetAccountLayer = class("SetAccountLayer", function ()
    return display.newLayer()
end)

function SetAccountLayer:ctor() 
    --遮罩层  
    display.newColorLayer(cc.c4b(0,0,0,150))
        :addTo(self,-1) 

    --初始化基础节点
    self.emptyNode_ = display.newNode()
        :scale(0)
        :pos(display.cx, display.cy)
        :addTo(self)

    --弹出效果
    local popupLayer = transition.sequence(
        {cc.ScaleTo:create(0.2, 1.1),
            cc.ScaleTo:create(0.1, 1.0)})
    self.emptyNode_:runAction(popupLayer)

    --初始化背景
    self:initBG_()
end

function SetAccountLayer:initBG_()  
    -- 背景图片
    local bg = display.newSprite("settings/bg.png")
        :addTo(self.emptyNode_)

    --修改账户按钮
    local addAccountBtn = cc.ui.UIPushButton.new({normal = "login_scene/bounding_account.png",pressed = "login_scene/bounding_account_h.png"})
        --:scale(0.9)
        :align(display.CENTER,bg:getContentSize().width * 0.5,bg:getContentSize().height * 0.5)
        :onButtonClicked(function()
            self:addAccount_()
        end)
        :addTo(bg,2)

    --切换账号按钮
    local changeAccountBtn = cc.ui.UIPushButton.new({normal = "login_scene/change_account.png",pressed = "login_scene/change_account_h.png"})
        --:scale(0.9)
        :align(display.CENTER,bg:getContentSize().width * 0.5,bg:getContentSize().height * 0.3)
        :onButtonClicked(function()
            self:changeAccount_()
        end)
        :addTo(bg,2)

    local isNew = cc.UserDefault:getInstance():getBoolForKey("is_new_user",true)
    
    local account
    if isNew then
        account = "当前帐户：游客"
    else
        local lastUser = cc.UserDefault:getInstance():getStringForKey("userName","")
        account = "当前帐户：" .. lastUser

        addAccountBtn:setVisible(false)
        changeAccountBtn:setPosition(bg:getContentSize().width * 0.5,bg:getContentSize().height * 0.45)
    end

    --当前账号
    cc.ui.UILabel.new({
        text = account ,size = 36,color = display.COLOR_BLACK,font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,bg:getContentSize().width * 0.5,bg:getContentSize().height * 0.7)
        :addTo(bg)

    --关闭按钮
    cc.ui.UIPushButton.new({normal = "common_ui/close.png",pressed = "common_ui/close_h.png"})
        :scale(0.9)
        :align(display.CENTER,bg:getContentSize().width * 0.95,bg:getContentSize().height * 0.93)
        :onButtonClicked(function()
            self:closeCallBack_()
        end)
        :addTo(bg,2)  
end

function SetAccountLayer:addAccount_()   
    -- 添加遮罩层    
    self.addMaskLayer_ = display.newColorLayer(cc.c4b(0,0,0,150))
        :addTo(self, 20) 
        
    -- 背景图
    local bg = display.newSprite("settings/bg.png", display.cx, display.cy)
        :scale(0)
        :addTo(self.addMaskLayer_)
    bg:runAction(transition.sequence({cc.ScaleTo:create(0.2, 1.1),cc.ScaleTo:create(0.1, 1.0)}))

    -- 修改账号
    display.newSprite("login_scene/label_bounding.png")
        :pos(bg:getContentSize().width * 0.25,bg:getContentSize().height * 0.8)
        :addTo(bg)    

    -- 账号
    local account = display.newSprite("login_scene/lb_account.png")
        :pos(bg:getContentSize().width * 0.18,bg:getContentSize().height * 0.62)
        :addTo(bg)

    self.uName_ = cc.ui.UIInput.new({
        image = "login_scene/input_frame.png",
        size = cc.size(486, 57),
        x = bg:getContentSize().width * 0.58,
        y = bg:getContentSize().height * 0.62,
        listener = function(event)
            if event == "began" then
                self:onEditBoxBegan(self.uName_)
            end
        end
    }) 
    --self.uName_:setText("5~16位数字、字母组合")
    self.uName_:setPlaceHolder("5-16位数字、字母组合")
    self.uName_:setPlaceholderFontColor(cc.c3b(144,124,93))
    self.uName_:setPlaceholderFontName(GameManager.FONTNAME_TTF)
    self.uName_:setPlaceholderFontSize(24)
    self.uName_:setFontColor(cc.c3b(47, 17 , 8))
    self.uName_:setReturnType(cc.KEYBOARD_RETURNTYPE_SEND)
    bg:addChild(self.uName_)
    
    

--    self.tip1_ = display.newSprite("login_scene/tip1.png")
--        :pos(bg:getContentSize().width * 0.58,bg:getContentSize().height * 0.62)
--        :addTo(bg)

    --密码
    display.newSprite("login_scene/lb_password.png")
        :pos(bg:getContentSize().width * 0.18,bg:getContentSize().height * 0.4)
        :addTo(bg)


    self.pWord_ = cc.ui.UIInput.new({
        image = "login_scene/input_frame.png",
        size = cc.size(486, 57),
        x = bg:getContentSize().width * 0.58,
        y = bg:getContentSize().height * 0.4,
        listener = function(event)
            if event == "began" then
                self:onEditBoxBegan(self.pWord_)
            end
        end
    --passwordEnable = true
    }) 
    --self.pWord_:setText("4~16位")
    --self.pWord_:setInputFlag(cc.EDITBOX_INPUT_FLAG_PASSWORD)
    self.pWord_:setPlaceHolder("4-16位(除空格、逗号、单双引号)")
    self.pWord_:setPlaceholderFontColor(cc.c3b(144,124,93))
    self.pWord_:setPlaceholderFontName(GameManager.FONTNAME_TTF)
    self.pWord_:setPlaceholderFontSize(24)
    self.pWord_:setFontColor(cc.c3b(47, 17 , 8))
    self.pWord_:setReturnType(cc.KEYBOARD_RETURNTYPE_SEND)
    bg:addChild(self.pWord_)

--    self.tip2_ = display.newSprite("login_scene/tip2.png")
--        :pos(bg:getContentSize().width * 0.58,bg:getContentSize().height * 0.4)
--        :addTo(bg)

    --确认按钮
    cc.ui.UIPushButton.new({normal = "common_ui/confirm.png",pressed = "common_ui/confirm_h.png"})
        :scale(0.9)
        :align(display.CENTER,bg:getContentSize().width * 0.5,bg:getContentSize().height * 0.21)
        :onButtonClicked(function()
            self:confirmAddCallBack_()
        end)
        :addTo(bg,2)

    -- 关闭按钮
    cc.ui.UIPushButton.new({normal = "common_ui/close.png",pressed = "common_ui/close_h.png"})
        :scale(0.9)
        :align(display.CENTER,bg:getContentSize().width * 0.95,bg:getContentSize().height * 0.93)
        :onButtonClicked(function()
            -- self:closeCallBack_()
            bg:runAction(transition.sequence({cc.ScaleTo:create(0,1.0),cc.ScaleTo:create(0.1,1.1),
                cc.ScaleTo:create(0.2,0),cc.CallFunc:create(function()
                    self.addMaskLayer_:removeSelf()
                end)
            }))
        end)
        :addTo(bg,2)
end

function SetAccountLayer:onEditBoxBegan(editbox)
    printf("editBox1 event began : text = %s", editbox:getText())
    --self.codeInput_ = editbox:getText()
    editbox:setText("")

--    if editbox == self.uName_ and self.tip1_ ~= nil then
--        self.tip1_:removeSelf()
--        self.tip1_ = nil
--    elseif editbox == self.pWord_ and self.tip2_ ~= nil then
--        self.tip2_:removeSelf()
--        self.tip2_ = nil
--        --self.pWord_:setInputFlag(cc.EDITBOX_INPUT_FLAG_PASSWORD)
--    end
end

function SetAccountLayer:confirmAddCallBack_()
    local lastUser = cc.UserDefault:getInstance():getStringForKey("userName","")
    local lastpword = cc.UserDefault:getInstance():getStringForKey("password","")
    print("lastUser = " .. lastUser)
    print("lastpword = " .. lastpword)

    local name = self.uName_:getText()
    local pw = self.pWord_:getText()
    
    print("name = " .. name)
    print("pw = " .. pw)
    
    if name == nil or name == "" or pw == nil or pw == "" then 
        local t = WSToast.new("请输入用户名和密码", 2)
        display.getRunningScene():addChild(t, 250)
        return
    end 

    self.uName_:setTouchEnabled(false)
    self.pWord_:setTouchEnabled(false)

    --连网
    local ac = AlertConnection.new(CONNECTION_CHANGE_ACCOUNT, name, pw, lastUser, lastpword)
        self:addChild(ac,100,123456)

    self.schedule1_ = self:schedule(function()
        if not self:getChildByTag(123456) then
            self:stopAction(self.schedule1_)

            -- DataEye统计,设置用户登录，在Android里，初始化DataEye在用户登录后开始记录
            -- if USE_DATAEYE then
            --     DCAccount.login(CloudData.UID.."")
            -- end

            -- self:performWithDelay(function()
            --     self:toScene()
            -- end,0.2)
        self:addSuccess_(name, pw)
        end
    end,0.1)
end

function SetAccountLayer:addSuccess_(name, password)  
    self.uName_:setTouchEnabled(true)
    self.pWord_:setTouchEnabled(true)

    local tip = ""
    if CloudData.CHANGE_ACCOUNT_TIP == nil then 
        --存储用户名
        cc.UserDefault:getInstance():setStringForKey("userName",name)
        --存储密码
        cc.UserDefault:getInstance():setStringForKey("password",password)
        --是否为新用户
        cc.UserDefault:getInstance():setBoolForKey("is_new_user",false)

        tip = name .. "绑定账号成功"
        local t = WSToast.new(tip, 2.5)
        display.getRunningScene():addChild(t, 250)
        self:closeCallBack_()
    else
        tip = CloudData.CHANGE_ACCOUNT_TIP
        local t = WSToast.new(tip, 2.5)
        display.getRunningScene():addChild(t, 250)
    end   
end

function SetAccountLayer:changeAccount_()   
    -- self.mask_:removeSelf()
    -- self.mask_ = nil
    -- self.mask_ = display.newColorLayer(cc.c4b(0,0,0,150))
    --     :addTo(self,10)
    -- self.emptyNode_ = display.newNode()
    --     :pos(display.cx, display.cy)
    --     :addTo(self.mask_,1)
    -- --背景图片
    -- local bg = display.newSprite("settings/bg.png"):addTo(self.emptyNode_, 2)
    
    -- 添加遮罩层   
    self.changeMaskLayer_ = display.newColorLayer(cc.c4b(0,0,0,150))
        :addTo(self, 20) 

    -- 背景图
    local bg = display.newSprite("settings/bg.png", display.cx, display.cy)
        :scale(0)
        :addTo(self.changeMaskLayer_)
    bg:runAction(transition.sequence({cc.ScaleTo:create(0.2, 1.1),cc.ScaleTo:create(0.1, 1.0)}))

    --切换账号
    display.newSprite("login_scene/label_login.png")
        :pos(bg:getContentSize().width * 0.25,bg:getContentSize().height * 0.8)
        :addTo(bg)    

    --账号
    local account = display.newSprite("login_scene/lb_account.png")
        :pos(bg:getContentSize().width * 0.18,bg:getContentSize().height * 0.62)
        :addTo(bg)

    self.uName_ = cc.ui.UIInput.new({
        image = "login_scene/input_frame.png",
        size = cc.size(486, 57),
        x = bg:getContentSize().width * 0.58,
        y = bg:getContentSize().height * 0.62,
        listener = function(event)
            if event == "began" then
                self:onEditBoxBegan(self.uName_)
            end
        end
    }) 
    --self.uName_:setText("5~16位数字、字母组合")
    self.uName_:setFontColor(cc.c3b(47, 17 , 8))
    self.uName_:setReturnType(cc.KEYBOARD_RETURNTYPE_SEND)
    bg:addChild(self.uName_)

    --密码
    display.newSprite("login_scene/lb_password.png")
        :pos(bg:getContentSize().width * 0.18,bg:getContentSize().height * 0.4)
        :addTo(bg)


    self.pWord_ = cc.ui.UIInput.new({
        image = "login_scene/input_frame.png",
        size = cc.size(486, 57),
        x = bg:getContentSize().width * 0.58,
        y = bg:getContentSize().height * 0.4,
        listener = function(event)
            if event == "began" then
                self:onEditBoxBegan(self.pWord_)
            end
        end
    --passwordEnable = true
    }) 
    --self.pWord_:setText("4~16位")
    --self.pWord_:setInputFlag(cc.EDITBOX_INPUT_FLAG_PASSWORD)
    self.pWord_:setFontColor(cc.c3b(47, 17 , 8))
    self.pWord_:setReturnType(cc.KEYBOARD_RETURNTYPE_SEND)
    bg:addChild(self.pWord_)

    --确认按钮
    cc.ui.UIPushButton.new({normal = "common_ui/confirm.png",pressed = "common_ui/confirm_h.png"})
        :scale(0.9)
        :align(display.CENTER,bg:getContentSize().width * 0.5,bg:getContentSize().height * 0.21)
        :onButtonClicked(function()
            self:confirmChangeCallBack_()
        end)
        :addTo(bg,2)

    --关闭按钮
    cc.ui.UIPushButton.new({normal = "common_ui/close.png",pressed = "common_ui/close_h.png"})
        :scale(0.9)
        :align(display.CENTER,bg:getContentSize().width * 0.95,bg:getContentSize().height * 0.93)
        :onButtonClicked(function()
--            self:closeCallBack_()
            bg:runAction(transition.sequence({cc.ScaleTo:create(0,1.0),cc.ScaleTo:create(0.1,1.1),
                cc.ScaleTo:create(0.2,0),cc.CallFunc:create(function()
                    self.changeMaskLayer_:removeSelf()
                end)
            }))
        end)
        :addTo(bg,2)
end

function SetAccountLayer:confirmChangeCallBack_()
    local lastUser = cc.UserDefault:getInstance():getStringForKey("userName","")
    local password = cc.UserDefault:getInstance():getStringForKey("password","")
    print("lastUser = " .. lastUser)
    print("password = " .. password)


    local name = self.uName_:getText()
    local pw = self.pWord_:getText()
    
    print("name = " .. name)
    print("pw = " .. pw)

    if name == nil or name == "" or pw == nil or pw == "" then 
        local t = WSToast.new("请输入用户名和密码", 2)
        display.getRunningScene():addChild(t, 250)
        return
    end   

    self.uName_:setTouchEnabled(false)
    self.pWord_:setTouchEnabled(false)

    --连网
    local ac = AlertConnection.new(CONNECTION_LOGIN, name, pw)
        self:addChild(ac,100,123456)

    CloudData.CHECK_ACCOUNT_ONLY = true
    self.schedule1_ = self:schedule(function()
        if not self:getChildByTag(123456) then
            self:stopAction(self.schedule1_)

            -- DataEye统计,设置用户登录，在Android里，初始化DataEye在用户登录后开始记录
            -- if USE_DATAEYE then
            --     DCAccount.login(CloudData.UID.."")
            -- end

            -- self:performWithDelay(function()
            --     self:toScene()
            -- end,0.2)
            self:changeSuccess_(name, pw)
        end
    end,0.1)
end

function SetAccountLayer:changeSuccess_(name, password)    
    self.uName_:setTouchEnabled(true)
    self.pWord_:setTouchEnabled(true)

    CloudData.CHECK_ACCOUNT_ONLY = false

    if CloudData.CHANGE_ACCOUNT_TIP == nil then 
        --存储用户名
        cc.UserDefault:getInstance():setStringForKey("userName",name)
        --存储密码
        cc.UserDefault:getInstance():setStringForKey("password",password)
        --是否为新用户
        cc.UserDefault:getInstance():setBoolForKey("is_new_user",false)

        local tip = name .. "登录成功"
        local t = WSToast.new(tip, 2.5)
        display.getRunningScene():addChild(t, 250)

        self:closeCallBack_()
    else
        tip = CloudData.CHANGE_ACCOUNT_TIP

        local t = WSToast.new(tip, 2.5)
        display.getRunningScene():addChild(t, 250)
    end   
end

function SetAccountLayer:closeCallBack_()   
    local popupLayer = transition.sequence({cc.ScaleTo:create(0,1.0),
        cc.ScaleTo:create(0.1,1.1),
        cc.ScaleTo:create(0.2,0),
        cc.CallFunc:create(function()
            self:removeSelf()
        end)
    })
    self.emptyNode_:runAction(popupLayer)
end

return SetAccountLayer