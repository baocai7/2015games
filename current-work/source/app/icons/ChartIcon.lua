--
-- 排行榜图标
--
local BuddhaIcon      = import("icons.BuddhaIcon")

local ChartIcon  =  class("ChartIcon", function()
    return display.newNode()
end)

function ChartIcon:ctor(index)
    self:initUI_()   
    self:showInfo_(index)      
end

function ChartIcon:initData_(index)
    self.index_ = index
    self.info_      = CloudData.CHART_TABLE[self.index_]
    
    if self.info_ == nil then
        return
    end
    
    self.name_      = self.info_.nick
    self.rank_      = self.info_.rank
    self.level_     = self.info_.reachTowerLevel 
    self.level1_    = self.info_.reachTowerWave 
    self.buddhaTable_= json.decode(self.info_.reachTowerTeam)
end

function ChartIcon:initUI_()
    --背景   
    self.bg = display.newSprite("chart/line.png")
    self:addChild(self.bg)

    --排名
    self.rankLabel_ = cc.ui.UILabel.new({
        UILabelType = 2,text = "",size = 30,font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,self.bg:getContentSize().width * 0.066,self.bg:getContentSize().height * 0.55)
        :addTo(self.bg)
        
    self.rankImg_ = display.newSprite()
        :pos(self.bg:getContentSize().width * 0.066,self.bg:getContentSize().height * 0.55)
        :addTo(self.bg)

    --玩家昵称
    self.nameLabel_ = cc.ui.UILabel.new({
        UILabelType = 2,text = "",size = 24,font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,self.bg:getContentSize().width * 0.261 ,self.bg:getContentSize().height * 0.7)
        :addTo(self.bg)  

    --玩家最高层数
    self.recordLabel_ = cc.ui.UILabel.new({
        UILabelType = 2,text = "",size = 20,font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,self.bg:getContentSize().width * 0.261,self.bg:getContentSize().height * 0.3)
        :addTo(self.bg)
    
    self.buddhaIconTable_ = {}
    --神仙阵容
    for i = 1, 6 do
        local buddhaModel = DataUtils.getBuddhaModel(1)
        self.buddhaIconTable_[i] = BuddhaIcon.new(buddhaModel) 
        self.buddhaIconTable_[i]:setScale(0.75)
        self.buddhaIconTable_[i]:setPosition(self.bg:getContentSize().width * (0.386 + 0.094 * i),self.bg:getContentSize().height * 0.55)
        self.bg:addChild(self.buddhaIconTable_[i])
    end
end

function ChartIcon:showInfo_(index)   
    self:initData_(index)
    
    if self.index_ > 3 then
        self.rankLabel_:setString(self.index_)
        self.rankLabel_:setVisible(true)
        self.rankImg_:setVisible(false)       

        self.nameLabel_:setString(self.name_) 
        self.nameLabel_:setColor(cc.c3b(255, 255, 255))
    else
        self.rankLabel_:setVisible(false)
        self.rankImg_:setTexture("chart/" .. self.index_ .. ".png")
        self.rankImg_:setVisible(true)               

        local col
        if self.index_ == 1 then
            col = cc.c3b(255, 64, 20)
        elseif self.index_ == 2 then
            col = cc.c3b(255, 20, 252)
        else
            col = cc.c3b(23, 192, 255)
        end
        
        self.nameLabel_:setString(self.name_) 
        self.nameLabel_:setColor(col)
    
    end 
    
    self.recordLabel_:setString("最高记录：" .. (self.level_) .. "层" .. (self.level1_) .. "波")      

    if(not self.buddhaTable_) then
        return 
    end

    --神仙阵容
    for i = 1, #self.buddhaTable_ do
        local buddhaId = tonumber(self.buddhaTable_[i].npcId)
        if buddhaId ~= 0 then
            self.buddhaIconTable_[i]:removeSelf()
            local buddhaModel = DataUtils.getBuddhaModel(buddhaId)
            self.buddhaIconTable_[i] = BuddhaIcon.new(buddhaModel)
            self.buddhaIconTable_[i]:setScale(0.75)
            self.buddhaIconTable_[i]:setPosition(self.bg:getContentSize().width * (0.386 + 0.094 * i),self.bg:getContentSize().height * 0.55)
            self.bg:addChild(self.buddhaIconTable_[i])            
                                   
            if tonumber(buddhaModel.summonPieceId_) == 0 then
                display.newSprite("chart/lv.png")
                    :scale(1.2)
                    :pos(-37,-40)
                    :addTo(self.buddhaIconTable_[i], 2) 
                    
                self.lvLabel_ = cc.ui.UILabel.new({
                    UILabelType = 1,text = self.buddhaTable_[i].level,font = "fonts/yellowNum.fnt"})
                    :scale(0.6)
                    :align(display.CENTER, -25, -38)
                    :addTo(self.buddhaIconTable_[i], 2)
                self.lvLabel_:setAnchorPoint(0, 0.5)
            end

            local addL = self.buddhaTable_[i].addLevel
            if addL > 0 or tonumber(buddhaModel.summonPieceId_) ~= 0 then
                self.upLabel_ = cc.ui.UILabel.new({
                UILabelType = 1, text = "+" .. addL, font = "fonts/greenNum.fnt"})
                :scale(0.6)
                :align(display.CENTER, 28, -38)
                :addTo(self.buddhaIconTable_[i], 2) 
            end                                                                   
        else           
             self.buddhaIconTable_[i]:setVisible(false)                     
        end
    end
    
    for i = #self.buddhaTable_ + 1, 6 do
        self.buddhaIconTable_[i]:setVisible(false)     
    end
end

return ChartIcon