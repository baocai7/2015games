--
--分区选择
--

local AlertConnection = import("customs.AlertConnection")

local ServersBtn = {} 
ServersBtn = class("ServersBtn", function()
    return display.newNode()
end)

ServersBtn.TAG_SHOW_ALERT = 1000

function ServersBtn:ctor(cb)   
    self.serverId = nil     -- 玩家上次选择的分区
    self.color  = nil       -- 该分区字体颜色  
    self.label  = nil       -- 显示已选分区的文本框
    self.bg     = nil       -- 显示已选分区的背景框
    self.mask   = nil       -- 显示分区列表的背景遮罩层
    self.listView = nil     -- 分区列表
    self.button = nil       -- 上下箭头按钮
    self.text = nil         -- 分区名称
    self.selectedItem = nil -- 选定的项目
    self.tipLabel = nil     -- “点击换区”标签
    self.cb = cb            -- 联网成功回调事件

    self:getServersInfo()   
end


function ServersBtn:invokeCallback(tag, param1, param2)
    if self.cb then
        self.cb(tag, param1, param2)
    end
end

function ServersBtn:getServersInfo()  
    local userName = nil 
    local password = nil
    
    if device.platform == "windows" or device.platform == "mac" then
        userName = GameManager.USER_NAME
        password = GameManager.PASSWORD
    elseif device.platform == "android" and PaymentInfo.CHANNEL == 0 or PaymentInfo.CHANNEL == 5 or PaymentInfo.CHANNEL == 10086 or PaymentInfo.CHANNEL == 10010 or PaymentInfo.CHANNEL == 10000 then
        userName = cc.UserDefault:getInstance():getStringForKey("userName","")
        password = cc.UserDefault:getInstance():getStringForKey("password","")
    else
        self:initData() 
        return
    end
    
    local function tFuncListener()
        self:initData() 
    end
    
    local ac = AlertConnection.new(CONNECTION_LOGIN, userName, password, tFuncListener)
    self:invokeCallback(ServersBtn.TAG_SHOW_ALERT, ac) 
end

function ServersBtn:initData()
    self.table = CloudData.SERVERS_TABLE 

    --没有分区信息
    if self.table == nil or #self.table == 0 then 
        self:removeSelf()
        return
    end

    self.regionTable = {}
    if CloudData.REGIONS ~= nil then 
        local tb = split(CloudData.REGIONS,",")

        if tb == nil or #tb == 0 then 
            self.regionTable = {}
        else 
            for i = 1, #tb do
                self.regionTable[tostring(tb[i])] = true
            end
        end
    end
    dump(self.regionTable, "regionTable:")

    --读取本地存储的玩家上次选择的服务器信息
    CloudData.USER_SERVER_ID = cc.UserDefault:getInstance():getIntegerForKey("user_server",0)
    self.serverId = CloudData.USER_SERVER_ID

    --未选过分区
    if self.serverId == nil or self.serverId == 0 then 
        self.serverId = tonumber(self.table[#self.table].regionId)
    end

    --遍历查找服务器信息
    local found = false
    for i = 1, #self.table do 
        if tonumber(self.table[i].regionId) == self.serverId then
            self.tag = tonumber(self.table[i].flag)
            self.text = self.table[i].name

        --    self.gotRole = 0

            found = true
            i = #self.table
        end
    end

    --上次选择的服务器已被删除
    if found == false then
        self.serverId = tonumber(self.table[#self.table].regionId) 
        self.tag = tonumber(self.table[#self.table].flag)
        self.text = self.table[#self.table].name

    --    self.gotRole = 0
    end

    --设定文本框内容和字体颜色
    if self.tag == 0 then 
        self.color = cc.c3b(0, 255, 0)
        self.text = self.text .. "(新)"
    else 
        self.color = cc.c3b(255, 0, 0)
        self.text = self.text .. "(爆满)"
    end

    CloudData.USER_SERVER_ID = self.serverId
    CloudData.USER_SERVER_IP = (self.table[self.serverId].ip) .. ":" .. (self.table[self.serverId].port)

    self:initUI()
end

function ServersBtn:initUI()   
    --背景框
    self.bg = display.newSprite("login_scene/server_selected.png")
        :addTo(self)

    --点击事件
    self.bg:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        return self:onTouch(event.name)
    end)
    self.bg:setTouchEnabled(true)

    --显示已选分区的文本框
    self.label = cc.ui.UILabel.new({
        UILabelType = 2,text = self.text,size = 28,color = self.color,font = GameManager.FONTNAME_TTF})
        :align(display.CENTER_LEFT, 20, self.bg:getContentSize().height * 0.5)
        :addTo(self.bg, 1)

    --点击换区文本框
    self.tipLabel = cc.ui.UILabel.new({
        UILabelType = 2,text = "点击换区",size = 22,color = self.color,font = GameManager.FONTNAME_TTF})
        :align(display.CENTER_RIGHT, self.bg:getContentSize().width * 0.85, self.bg:getContentSize().height * 0.5)
        :addTo(self.bg, 1)

    --上下箭头按钮
    self.button = cc.ui.UIPushButton.new({normal = "login_scene/server_tip.png",disabled = "login_scene/server_tip_h.png"})
        :pos(self.bg:getContentSize().width * 0.92,self.bg:getContentSize().height * 0.5)
        :addTo(self.bg)
    self.button:setTouchSwallowEnabled(false)       
end

--点击文本框事件的判断
function ServersBtn:onTouch(event)
    if event == "began" then
        return true
    end

    if event == "ended" then
        if self.mask == nil then 
            self:showServers()
        else 
            self.mask:removeSelf()
            self.mask = nil
            self.button:setButtonEnabled(true)
        end       
    end
end

--显示服务器列表
function ServersBtn:showServers()
    --避免重复显示
    if self.mask ~= nil then 
        self.mask:removeSelf()
        self.mask = nil
        self.button:setButtonEnabled(true)
    end

    --设置上下箭头状态
    self.button:setButtonEnabled(false)

    --添加遮罩层，方便点击空白区域移除服务器列表
    local x, y = self:getPositionX() , self:getPositionY()
    self.mask = display.newColorLayer(cc.c4b(255,255,255,0))
        :pos(-x, -y)
        :addTo(self,-1)
    self.mask:addNodeEventListener(cc.NODE_TOUCH_EVENT, function()
            self.mask:removeSelf()
            self.mask = nil
            self.button:setButtonEnabled(true)
        end)
    self.mask:setTouchEnabled(true)

    --背景图
    local listBg = display.newSprite("login_scene/server_bg.png")
        :pos(display.cx, display.height * 0.645)
        :addTo(self.mask)

    --添加listView
    self.listView = cc.ui.UIListView.new {
        viewRect = cc.rect(1,6,482,366),
        direction = cc.ui.UIScrollView.DIRECTION_VERTICAL}
        :onTouch(handler(self,self.touchListener))
        :addTo(listBg)
    --添加items
    for i=1,#self.table do
        local no = #self.table - i + 1
        local info = self.table[no]
        local item = self.listView:newItem()
        local content = display.newSprite("login_scene/server_item.png")
        item:addContent(content)
        item:setItemSize(480,81)
        self.listView:addItem(item)

        --选定的区设置成选定状态
        if tonumber(info.regionId) == self.serverId then 
            content:setTexture("login_scene/server_item_h.png")
            self.selectedItem = content
        end

        --设置每个服务器的状态（新区或爆满）和显示的颜色
        local col = cc.c3b(255, 0, 0)
        local tex = "爆满"
        if tonumber(info.flag) == 0 then 
            col = cc.c3b(0, 255, 0)
            tex = "新"
        end

        --服务器名字标签
        cc.ui.UILabel.new({
            UILabelType = 2,text = info.name ,size = 28,color = col,font = GameManager.FONTNAME_TTF})
            :align(display.CENTER_LEFT, 25, content:getContentSize().height * 0.5)
            :addTo(content, 1)

        --服务器状态标签
        cc.ui.UILabel.new({
            UILabelType = 2,text = tex,size = 28,color = col,font = GameManager.FONTNAME_TTF})
            :align(display.CENTER, content:getContentSize().width * 0.9, content:getContentSize().height * 0.5)
            :addTo(content, 1)

        if self.regionTable[tostring(info.regionId)] ~= nil then --self.gotRole ~= 0 then 
            display.newSprite("login_scene/role.png")
            :pos(content:getContentSize().width * 0.75, content:getContentSize().height * 0.5)
            :addTo(content, 1)
        end
    end
    self.listView:reload()
end

--服务器列表的监听事件
function ServersBtn:touchListener(event)   
    -- dump(event, " event : ")
    if "clicked" == event.name then
        --将上个选定区的选定状态移除
        if self.selectedItem ~= nil then 
            self.selectedItem:setTexture("login_scene/server_item.png")
        end

        --将点中的项目设为选定项
        local content = event.item:getContent()
        content:setTexture("login_scene/server_item_h.png")
        self.selectedItem = content
        
        --设置选定区的id、状态、颜色、名字等变量
        local no = #self.table + 1 - event.itemPos
        local info = self.table[no]
        self.serverId = tonumber(info.regionId)
        self.tag = tonumber(info.flag)
        if self.tag == 0 then 
            self.color = cc.c3b(0, 255, 0)
            self.text = info.name .. "(新)"
        else 
            self.color = cc.c3b(255, 0, 0)
            self.text = info.name .. "(爆满)"
        end

        --更新已选服务器的显示
        self.label:setString(self.text)
        self.label:setColor(self.color)
        self.tipLabel:setColor(self.color)

        --移除服务器列表
        self.mask:removeSelf()
        self.mask = nil
        self.button:setButtonEnabled(true)

        --记录本次选择的服务器
        CloudData.USER_SERVER_ID = self.serverId
        CloudData.USER_SERVER_IP = (info.ip) .. ":" .. (info.port)

    --    self.gotRole = 1

    elseif "began" == event.name then
        --将上个选定区的选定状态移除
        if self.selectedItem ~= nil then 
            self.selectedItem:setTexture("login_scene/server_item.png")
        end

        --将点中的项目设为选定项
        local content = event.item:getContent()
        content:setTexture("login_scene/server_item_h.png")
        self.selectedItem = content
    end
end

return ServersBtn