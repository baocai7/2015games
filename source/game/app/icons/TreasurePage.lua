--
--宝物界面的8个分页
--

local TreasurePieceIcon = import("icons.TreasurePieceIcon")
local AlertConnection   = import("customs.AlertConnection")

local TreasurePage  =  class("TreasurePage", function()
	return display.newNode()
end)

function TreasurePage:ctor(treasureId)
	self:initTreasureData(treasureId)
	self:initPiecePosition()
	self:initScrollView()
end

--读取宝物数据
function TreasurePage:initTreasureData(treasureId)
	--获取treasureModel
	local treasureModel = DataUtils.getTreasureModel(treasureId)

	self.treasureId_          = tonumber(treasureModel.treasureId_)          --宝物id
    self.treasureName_        = treasureModel.treasureName_                  --宝物名字
    self.treasureDesc_        = treasureModel.treasureDesc_           		 --宝物描述
    self.treasureIconPath_    = treasureModel.treasureIconPath_       		 --中间的大宝物的路径
    self.attribIconPath_      = treasureModel.attribIconPath_         		 --属性图标的路径
    self.attribNamePath_      = treasureModel.attribNamePath_         		 --属性说明图片的路径

    self.isTreasureEffective_ = treasureModel.isTreasureEffective_   		 --宝物是否生效
    self.effectIncreaseRate_  = tonumber(treasureModel.effectIncreaseRate_)  --效果提升率33%~100%

    --存储宝物碎片icon
    self.treasurePieceIconTable_  = {}
end

--初始化碎片在UI布置上位置
function TreasurePage:initPiecePosition()
	local point1  = cc.p(471,529)
	local point2  = cc.p(563,432)
	local point3  = cc.p(570,294)
	local point4  = cc.p(504,171)
	local point5  = cc.p(369,112)
	local point6  = cc.p(224,147)
	local point7  = cc.p(143,255)
	local point8  = cc.p(138,388)
	local point9  = cc.p(206,508)
	local point10 = cc.p(332,548)
	self.piecePosTable_ = {point1,point2,point3,point4,point5,point6,point7,point8,point9,point10}
end
	
function TreasurePage:initScrollView()
	--初始化金银铜碎片数量
	local nGoldPieceNum   = 0
	local nSilverPieceNum = 0
	local nCopperPieceNum = 0

	--page背景
	local bg = display.newSprite("treasure/treasure_frame.png")
		bg:setAnchorPoint(0,0)
		self:addChild(bg)

	--宝物名称
	display.newSprite(string.format("treasure/treasure"..self.treasureId_.."_name.png"),
		bg:getContentSize().width * 0.80,bg:getContentSize().height * 0.855)
		:addTo(bg)

	--宝物功能描述
	display.newSprite(string.format(self.attribNamePath_),
		bg:getContentSize().width * 0.80,bg:getContentSize().height * 0.18)
		:addTo(bg,1)
	--宝物功能图标
	display.newSprite(string.format(self.attribIconPath_),
		bg:getContentSize().width * 0.80,bg:getContentSize().height * 0.28)
		:scale(0.75)
		:addTo(bg,1)

	--宝物碎片图标
	for i=1,10 do
		local treasurePieceId    = (self.treasureId_ - 1) * 10 + i
		local treasurePieceModel = DataUtils.getTreasurePieceModel(treasurePieceId)
		local treasurePiecePos   = self.piecePosTable_[i]
		local treasurePieceIcon  = TreasurePieceIcon.new(treasurePieceModel)
		treasurePieceIcon:setPosition(treasurePiecePos)
		bg:addChild(treasurePieceIcon,1)
		table.insert(self.treasurePieceIconTable_,treasurePieceIcon)

		--获取品质,计算各品质碎片数量
		local quality = tonumber(treasurePieceModel.treasurePieceQuality_) 
		if quality == 1 then
			nCopperPieceNum = nCopperPieceNum + 1 
		elseif quality == 2 then
			nSilverPieceNum = nSilverPieceNum + 1 
		elseif quality == 3 then
			nGoldPieceNum = nGoldPieceNum + 1 
		end
	end

	--标签:宝物收集(收集全后改为宝物加成)
	local pieceLabel = display.newSprite("treasure/label1.png",
		bg:getContentSize().width * 0.74,bg:getContentSize().height * 0.78)
		:addTo(bg,1)
	
	--金品质碎片数量及加成
		--碎片数量
	local goldPieceNumLabel = cc.ui.UILabel.new({
        UILabelType = 2,text = nGoldPieceNum,size = 26,color = cc.c3b(41,20,2),font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,bg:getContentSize().width * 0.86,bg:getContentSize().height * 0.695)
        :addTo(bg,1)
        --加成的标识（向上的箭头）
    local upPic1 = display.newSprite("treasure/up.png",bg:getContentSize().width * 0.91,bg:getContentSize().height * 0.71)
    	:addTo(bg,1)
	upPic1:setVisible(false)
		--加成的数值
	local upNumLabel1 = cc.ui.UILabel.new({
        UILabelType = 1,text = "",font = "fonts/greenNum.fnt"})
        :align(display.CENTER,bg:getContentSize().width * 0.91,bg:getContentSize().height * 0.68)
        :scale(0.5)
        :addTo(bg,1)
    upNumLabel1:setVisible(false)

    --银品质碎片数量及加成
		--碎片数量
	local silverPieceNumLabel = cc.ui.UILabel.new({
        UILabelType = 2,text = nSilverPieceNum,size = 26,color = cc.c3b(41,20,2),font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,bg:getContentSize().width * 0.86,bg:getContentSize().height * 0.625)
        :addTo(bg,1)
        --加成的标识（向上的箭头）
    local upPic2 = display.newSprite("treasure/up.png",bg:getContentSize().width * 0.91,bg:getContentSize().height * 0.64)
    	:addTo(bg,1)
	upPic2:setVisible(false)
		--加成的数值
	local upNumLabel2 = cc.ui.UILabel.new({
        UILabelType = 1,text = "",font = "fonts/greenNum.fnt"})
        :align(display.CENTER,bg:getContentSize().width * 0.91,bg:getContentSize().height * 0.61)
        :scale(0.5)
        :addTo(bg,1)
    upNumLabel2:setVisible(false)

    --铜品质碎片数量及加成
		--碎片数量
	local copperPieceNumLabel = cc.ui.UILabel.new({
        UILabelType = 2,text = nCopperPieceNum,size = 26,color = cc.c3b(41,20,2),font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,bg:getContentSize().width * 0.86,bg:getContentSize().height * 0.545)
        :addTo(bg,1)
        --加成的标识（向上的箭头）
    local upPic3 = display.newSprite("treasure/up.png",bg:getContentSize().width * 0.91,bg:getContentSize().height * 0.56)
    	:addTo(bg,1)
	upPic3:setVisible(false)
		--加成的数值
	local upNumLabel3 = cc.ui.UILabel.new({
        UILabelType = 1,text = "",font = "fonts/greenNum.fnt"})
        :align(display.CENTER,bg:getContentSize().width * 0.91,bg:getContentSize().height * 0.53)
        :scale(0.5)
        :addTo(bg,1)
    upNumLabel3:setVisible(false)

    --宝物是否收集齐全标识(收集进度)
	local progressLabel = display.newSprite("treasure/treasure_label1.png",
		bg:getContentSize().width * 0.805,bg:getContentSize().height * 0.45)
		:addTo(bg,1)

	--完整宝物图片
	self.treasurePic_ = display.newSprite("treasure/treasure0_pic.png")
	self.treasurePic_:setPosition(bg:getContentSize().width * 0.379,bg:getContentSize().height * 0.515)
	bg:addChild(self.treasurePic_)

	local isTreasureCompleted = self.isTreasureEffective_        --当前宝物碎片是否收集完整
	if isTreasureCompleted then
		pieceLabel:setTexture("treasure/label2.png")
		progressLabel:setTexture("treasure/treasure_label2.png")

		upPic1:setVisible(true)
		upPic2:setVisible(true)
		upPic3:setVisible(true)

		local upNum1       = nGoldPieceNum   * 10.0
		local upNum2       = nSilverPieceNum * 10.0 * 2 / 3
		local upNum3       = nCopperPieceNum * 10.0 * 1 / 3
		local increaseRate = self.effectIncreaseRate_ * 100
		if self.treasureId_ ~= 1 then
			upNum1       = upNum1 * 0.5
			upNum2       = upNum2 * 0.5
			upNum3       = upNum3 * 0.5
			increaseRate = increaseRate * 0.5
		end
		
		upNumLabel1:setVisible(true)
		upNumLabel1:setString(string.format("%.0f%%",upNum1))
		upNumLabel2:setVisible(true)
		upNumLabel2:setString(string.format("%.0f%%",upNum2))
		upNumLabel3:setVisible(true)
		upNumLabel3:setString(string.format("%.0f%%",upNum3))

		--总加成提示
		cc.ui.UILabel.new({
	        UILabelType = 1,text = string.format("%d%%",increaseRate),font = "fonts/greenNum.fnt"})
	        :align(display.CENTER,progressLabel:getContentSize().width * 0.86,progressLabel:getContentSize().height * 0.5)
	        :scale(0.75)
	        :addTo(progressLabel,1)

        --是否播放解锁动画
        if DataUtils.getIsTreasureUnlockAnimationPlayed(self.treasureId_) then
        	self.treasurePic_:setTexture(self.treasureIconPath_)

        	--创建星星闪烁的动画
			display.addSpriteFrames("animation/shengli_xingxing.plist","animation/shengli_xingxing.png")
			local frames = display.newFrames("shengli-xingxing%d.png",1,19)
		    local animation = display.newAnimation(frames, 0.12)
		    local emptySp = display.newSprite()
		    	:scale(1.2)
		     	:pos(self.treasurePic_:getContentSize().width * 0.5,self.treasurePic_:getContentSize().height * 0.5)
		    	:addTo(self.treasurePic_,1)
		    emptySp:playAnimationForever(animation)
	    else
	    	--self.treasurePic_ = display.newSprite("treasure/treasure0_pic.png")
	    	--播放解锁动画
	    	--DataUtils.setIsTreasureUnlockAnimationPlayed(self.treasureId_,true) 
	    	self:playUnlockAnimation_()
    	end
    else
    	--self.treasurePic_ = display.newSprite("treasure/treasure0_pic.png")
    	--宝物碎片数量显示
    		--当前碎片数量
    	local currPieceNum = nGoldPieceNum + nSilverPieceNum + nCopperPieceNum
    	cc.ui.UILabel.new({
	        UILabelType = 1,text = currPieceNum,font = "fonts/red.fnt"})
	        :align(display.CENTER,progressLabel:getContentSize().width * 0.7,progressLabel:getContentSize().height * 0.46)
	        :scale(0.9)
	        :addTo(progressLabel)
	        --总碎片数量(10)
        cc.ui.UILabel.new({
	        UILabelType = 1,text = "/10",font = "fonts/whiteNum.fnt"})
	        :align(display.CENTER,progressLabel:getContentSize().width * 0.85,progressLabel:getContentSize().height * 0.54)
	        :scale(0.75)
	        :addTo(progressLabel)
	end
end

function TreasurePage:playUnlockAnimation_()
	--创建动画
	display.addSpriteFrames("animation/treasure_tx.plist","animation/treasure_tx.png")
	local frames = display.newFrames("treasure_pic%d.png",1,20)
    local animation = display.newAnimation(frames, 0.1)
    local emptySp = display.newSprite()
     	:pos(self.treasurePic_:getContentSize().width * 0.5,self.treasurePic_:getContentSize().height * 0.5)
    	:addTo(self.treasurePic_,1)
    emptySp:playAnimationOnce(animation,true,function()
    	display.getRunningScene().backBtn_:setButtonEnabled(true)
        DataUtils.setIsTreasureUnlockAnimationPlayed(self.treasureId_,true) 
    end)

	--原图片消失
	self.treasurePic_:runAction(transition.sequence({cc.FadeOut:create(2.0),cc.CallFunc:create(function()
		self.treasurePic_:setTexture(self.treasureIconPath_)
		self.treasurePic_:setOpacity(255)
	end)}) )

	--创建星星闪烁的动画
	display.addSpriteFrames("animation/shengli_xingxing.plist","animation/shengli_xingxing.png")
	local frames = display.newFrames("shengli-xingxing%d.png",1,19)
    local animation = display.newAnimation(frames, 0.12)
    local emptySp = display.newSprite()
    	:scale(1.2)
     	:pos(self.treasurePic_:getContentSize().width * 0.5,self.treasurePic_:getContentSize().height * 0.5)
    	:addTo(self.treasurePic_,1)
    emptySp:playAnimationForever(animation)

	--新图片出现
	local newPic = display.newSprite(self.treasureIconPath_)
		:opacity(0)
		:pos(self.treasurePic_:getPosition())
		:addTo(self.treasurePic_:getParent())
	newPic:runAction(transition.sequence({cc.FadeIn:create(2.0),cc.CallFunc:create(function()
		newPic:removeSelf()
	end)}))
end

return TreasurePage