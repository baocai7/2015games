--
-- 邮件图标
--

local MailIcon  =  class("MailIcon", function()
    return display.newNode()
end)

function MailIcon:ctor(index, tag)
    self.index = index
    self.isRead_ = tag
    self:initData_() 
    if tag then
        self:initUIOld_()
    else
        self:initUINew_()
    end      
end

function MailIcon:initData_(index)
    self.info_ = CloudData.SERVER_MSG[self.index]
    self.title_ = self.info_.title
    self.msg_ = self.info_.msg  

    local time = self.info_.remainSecond
    local day = math.floor(time / (24 * 3600))
    
    if day > 0 then
        self.deadline_ = "剩余".. day .. "天"
    else       
        local hour = math.floor(time / 3600)
        local min = math.floor((time % 3600) / 60)
        local sec = math.floor((time % 3600) % 60)
        self.deadline_ = "剩余" .. hour .."时" .. min .. "分" -- .. sec .. "秒"
    end
end

function MailIcon:initUINew_()
    --背景   
    self.icon = display.newSprite("server_maintain/new.png")
    self:addChild(self.icon)

    cc.ui.UILabel.new({
        UILabelType = 2,text = self.title_,size = 30,color = cc.c3b(255,5,5),font = GameManager.FONTNAME_TTF})
        :align(display.CENTER_LEFT,self.icon:getContentSize().width * 0.153,self.icon:getContentSize().height * 0.69)
        :addTo(self.icon)
        
    cc.ui.UILabel.new({
        UILabelType = 2,text = self.deadline_,size = 28,color = cc.c3b(151,115,71),font = GameManager.FONTNAME_TTF})
        :align(display.CENTER_RIGHT,self.icon:getContentSize().width - 30,self.icon:getContentSize().height * 0.64)
        :addTo(self.icon)
        
    cc.ui.UILabel.new({
        UILabelType = 2,text = self.msg_,size = 24,color = cc.c3b(78,48,13),align = cc.ui.TEXT_ALIGN_LEFT,dimensions = cc.size(600,30),font = GameManager.FONTNAME_TTF})
        :align(display.CENTER_LEFT,self.icon:getContentSize().width * 0.153,self.icon:getContentSize().height * 0.3)
        :addTo(self.icon)

    if #(self.msg_) > 75 then 
        cc.ui.UILabel.new({
        UILabelType = 2,text = "……",size = 28,color = cc.c3b(151,115,71),font = GameManager.FONTNAME_TTF})
        :align(display.CENTER_LEFT,self.icon:getContentSize().width - 130,self.icon:getContentSize().height * 0.25)
        :addTo(self.icon)
    end
end

function MailIcon:initUIOld_()
    --背景   
    self.icon = display.newGraySprite("server_maintain/old.png",nil)
    self:addChild(self.icon)
    self.icon:setTouchEnabled(false)

    cc.ui.UILabel.new({
        UILabelType = 2,text = self.title_,size = 30,color = cc.c3b(112,112,112),font = GameManager.FONTNAME_TTF})
        :align(display.CENTER_LEFT,self.icon:getContentSize().width * 0.153,self.icon:getContentSize().height * 0.69)
        :addTo(self.icon)

    cc.ui.UILabel.new({
        UILabelType = 2,text = self.deadline_,size = 28,color = cc.c3b(112,112,112),font = GameManager.FONTNAME_TTF})
        :align(display.CENTER_RIGHT,self.icon:getContentSize().width - 30,self.icon:getContentSize().height * 0.64)
        :addTo(self.icon)

    cc.ui.UILabel.new({
        UILabelType = 2,text = self.msg_,size = 24,color = cc.c3b(112,112,112),align = cc.ui.TEXT_ALIGN_LEFT,dimensions = cc.size(600,30),font = GameManager.FONTNAME_TTF})
        :align(display.CENTER_LEFT,self.icon:getContentSize().width * 0.153,self.icon:getContentSize().height * 0.3)
        :addTo(self.icon)

    if #(self.msg_) > 75 then 
        cc.ui.UILabel.new({
        UILabelType = 2,text = "……",size = 28,color = cc.c3b(151,115,71),font = GameManager.FONTNAME_TTF})
        :align(display.CENTER_LEFT,self.icon:getContentSize().width - 130,self.icon:getContentSize().height * 0.25)
        :addTo(self.icon)
    end
end

function MailIcon:readMail()
    self.isRead_ = true
    self.icon:removeSelf()   
    self:initUIOld_()
end

function MailIcon:getMailState()
    return self.isRead_
end

return MailIcon