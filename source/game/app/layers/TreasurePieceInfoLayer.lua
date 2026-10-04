--
--宝物界面点击宝物碎片的弹出层
--主要介绍当前碎片的相关信息
--

ChapterLayer = import("layers.ChapterLayer")

local TreasurePieceInfoLayer = class("TreasurePieceInfoLayer", function()
	return display.newLayer()
end)

function TreasurePieceInfoLayer:ctor( pieceId )
	--初始化基础节点
	self.emptyNode_ = display.newNode()
	self.emptyNode_:setPosition(display.cx,display.cy)
	self:addChild(self.emptyNode_)

	--弹出效果
	self.emptyNode_:setScale(0)
	local popupLayer = transition.sequence(
		{cc.ScaleTo:create(0.2, 1.1),
		cc.ScaleTo:create(0.1, 1.0)})
	self.emptyNode_:runAction(popupLayer)

    --加载道具数据信息
    self:initPieceData_(pieceId)

    --播放音效(打开层)
	if GameManager.SOUND_SWITCH_ON then
		audio.playSound(string.format("sounds/sfx_touch_ti.%s",GameManager.POSTFIX))
	end

	--init
    self:initUI_()
end

--加载道具数据信息
function TreasurePieceInfoLayer:initPieceData_(pieceId)
    local treasurePieceModel = DataUtils.getTreasurePieceModel(pieceId)

    self.treasurePieceId_      = tonumber(treasurePieceModel.treasurePieceId_)
    self.treasurePieceName_    = treasurePieceModel.treasurePieceName_
    self.treasurePieceDesc_    = treasurePieceModel.treasurePieceDesc_
    self.treasurePieceQuality_ = tonumber(treasurePieceModel.treasurePieceQuality_)
end

function TreasurePieceInfoLayer:initUI_()
    --背景图
    local bg = display.newSprite("treasure/alert/bg_frame.png"):addTo(self.emptyNode_)
    bg:setTouchEnabled(true)
    bg:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        return self:onTouch_(event.name,event.x,event.y)
    end)

    --碎片图片
    local piecePic = display.newSprite(string.format("treasure/alert/piece"..self.treasurePieceQuality_..".png"),
        bg:getContentSize().width * 0.45,bg:getContentSize().height * 0.7)
        :addTo(bg,1)

    --碎片名称
    local pieceNameLabel = cc.ui.UILabel.new({
        UILabelType = 2,text = self.treasurePieceName_,size = 40,color = display.COLOR_WHITE,font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,bg:getContentSize().width * 0.45 + piecePic:getContentSize().width * 0.6,bg:getContentSize().height * 0.7)
        :addTo(bg,1)
    pieceNameLabel:setAnchorPoint(0,0.5)

    --碎片信息描述
    local pieceDescFrame = display.newSprite("treasure/alert/describe.png",
        bg:getContentSize().width * 0.22,bg:getContentSize().height * 0.25)
        :addTo(bg,1)
    if self.treasurePieceId_ > 77 and self.treasurePieceId_ <= 80 then
        cc.ui.UILabel.new({
            UILabelType = 2,text = string.format(self.treasurePieceDesc_),size = 30,color = display.COLOR_WHITE,
            align = cc.ui.TEXT_ALIGN_LEFT,dimensions = cc.size(280,100),font = GameManager.FONTNAME_TTF})
            :align(display.CENTER,bg:getContentSize().width * 0.22 + pieceDescFrame:getContentSize().width * 1.22,bg:getContentSize().height * 0.21)
            :addTo(bg,2)
    else
        local pieceDescLabel = cc.ui.UILabel.new({
            UILabelType = 2,text = string.format(self.treasurePieceDesc_),size = 30,color = display.COLOR_WHITE,font = GameManager.FONTNAME_TTF})
            :align(display.CENTER,bg:getContentSize().width * 0.22 + pieceDescFrame:getContentSize().width * 0.42,bg:getContentSize().height * 0.25)
            :addTo(bg,2)
        pieceDescLabel:setAnchorPoint(0,0.5)
    end

    --碎片出处
    local pieceFromPic = display.newSprite("treasure/alert/from.png",
        bg:getContentSize().width * 0.55,bg:getContentSize().height * 0.25)
        :addTo(bg,1)
    local pieceFromLabel = cc.ui.UILabel.new({
        UILabelType = 2,text = string.format("第"..self.treasurePieceId_.."关"),size = 30,color = display.COLOR_WHITE,font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,bg:getContentSize().width * 0.55 + pieceFromPic:getContentSize().width * 0.5,bg:getContentSize().height * 0.25)
        :addTo(bg,1)
    pieceFromLabel:setAnchorPoint(0,0.5)

    --"去寻宝"
    local btn = cc.ui.UIPushButton.new({normal = "treasure/goto1.png",pressed = "treasure/goto2.png",disabled = "treasure/goto3.png"})
        :onButtonClicked(function()
            local chapterId = math.floor((self.treasurePieceId_ - 1) / 10) + 1
            local stageId   = self.treasurePieceId_ % 10
            local currScene = display.getRunningScene()
            local layer = ChapterLayer.new(chapterId,stageId)
            currScene:addChild(layer, 20)
        end)
        :align(display.CENTER,bg:getContentSize().width * 0.78,bg:getContentSize().height * 0.25)
        :zorder(2)
        :addTo(bg,2)
    if CloudData.STAGE_PROGRESS < self.treasurePieceId_ then
        btn:setButtonEnabled(false)
    end

    --添加空白图扩充点击区域
    local emptyLayer = display.newColorLayer(cc.c4b(255,255,255,0))
    emptyLayer:setPosition(bg:getContentSize().width * 0.5,bg:getContentSize().height * 0.5)
    emptyLayer:setAnchorPoint(0.5,0.5)
    emptyLayer:setContentSize(cc.size(display.width,display.height))
    bg:addChild(emptyLayer,-1)
end

--添加点击事件
function TreasurePieceInfoLayer:onTouch_(event,x,y)
    if event == "began" then
        self:closeCallBack_()
        return true
    end
end

function TreasurePieceInfoLayer:closeCallBack_()
    GameManager.IS_TREASURE_PIECE_LAYER_CLOSED   = true

    local popupLayer = transition.sequence({cc.ScaleTo:create(0,1.0),
        cc.ScaleTo:create(0.1,1.1),
        cc.ScaleTo:create(0.2,0),cc.CallFunc:create(function()
            self:removeSelf()
        end)
        })
    self.emptyNode_:runAction(popupLayer)
end


return TreasurePieceInfoLayer