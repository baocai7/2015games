
--[[=============================================================================
#     FileName: RoundListIcon.lua
#         Desc: 无尽模式当前波次敌方出兵信息列表
#       Author: Hoo
#   LastChange: 2015-03-21 
#      History:
=============================================================================]]

local RoundListIcon  =  class("RoundListIcon", function()
	return display.newNode()
end)

function RoundListIcon:ctor(roundNum,waveId)
	-- print("======= roundNum : "..roundNum)
	-- print("======= waveId : "..waveId)
	-- 存放兵种头像
	self.iconTable_ = {}
	-- 存放兵种Id
	self.monsterIdTable_ = {}
  
	-- 边框
	self.cellFrame_ = display.newSprite("game_infinite/cell_frame.png"):addTo(self)

	-- 第N波
	cc.ui.UILabel.new({UILabelType = 2,text = string.format("第%d波",roundNum) ,size = 20,color = cc.c3b(138,81,49),font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,self.cellFrame_:getContentSize().width * 0.08,self.cellFrame_:getContentSize().height * 0.88)
        :addTo(self.cellFrame_)

    -- 读取model
    local monsterWaveModel = DataUtils.getMonsterWaveModel(waveId)

    -- 加载兵种(根据id进行排序)
    -- dump(monsterWaveModel.totalIdsTable_)
    local tempTable = {}
    local i = 0
    for k,v in pairs(monsterWaveModel.totalIdsTable_) do
    	table.insert(tempTable,tonumber(v))
	end
	self.monsterIdsTable_ = self:sortOfMonsterIds(tempTable)
	-- print("=============monsterIdsTable : ")
	-- dump(self.monsterIdsTable_)
	for m,n in pairs(self.monsterIdsTable_) do
		i = i + 1
    	-- print("================ monsterID : "..tonumber(v))
    	local monsterModel = DataUtils.getInfiniteMonsterModel(tonumber(n))

		-- 读取兵种相关信息
		local monsterIcon    = monsterModel.icon_
		local monsterQuality = monsterModel.quality_ + 1
		if i == 1 then
			monsterQuality = 6
		end

		-- 兵种头像外框
		local iconFrame = display.newSprite("upgrade/q"..monsterQuality..".png",
			self.cellFrame_:getContentSize().width / 6 * i - 40 ,self.cellFrame_:getContentSize().height * 0.36)
			:scale(70/114)
			:addTo(self.cellFrame_)

		-- 兵种头像
		local icon = display.newSprite(monsterIcon,iconFrame:getContentSize().width * 0.5,iconFrame:getContentSize().height * 0.5)
			:addTo(iconFrame)
	end
    	
    -- 信息展示框
	self.tipFrame_ = display.newSprite("game_infinite/tips.png",0,0)
		:hide()
		:addTo(self.cellFrame_)
		-- 等级
	self.monsterLevelNum_ = cc.ui.UILabel.new({UILabelType = 2,text = "100",size = 24,color = display.COLOR_WHITE})
        :align(display.CENTER,self.tipFrame_:getContentSize().width * 0.20,self.tipFrame_:getContentSize().height * 0.6)
        :addTo(self.tipFrame_)
        -- 血量
	self.monsterHpNum_ = cc.ui.UILabel.new({UILabelType = 2,text = "100",size = 24,color = display.COLOR_WHITE})
        :align(display.CENTER,self.tipFrame_:getContentSize().width * 0.20,self.tipFrame_:getContentSize().height * 0.4)
        :addTo(self.tipFrame_)
        -- 攻击
	self.monsterAttackNum_ = cc.ui.UILabel.new({UILabelType = 2,text = "100",size = 24,color = display.COLOR_WHITE})
        :align(display.CENTER,self.tipFrame_:getContentSize().width * 0.30,self.tipFrame_:getContentSize().height * 0.2)
        :addTo(self.tipFrame_)
end

-- 根据兵种id进行排序
function RoundListIcon:sortOfMonsterIds(tb)
	for i=1,#tb do
		for j=1,#tb-1 do
			local value1 = tb[j]
			local value2 = tb[j + 1]
			if value1 < value2 then
				tb[j]     = value2
				tb[j + 1] = value1
			end
		end
	end

	return tb
end

-- 当选中兵种头像时，显示兵种信息
function RoundListIcon:monsterInfoShow(idx)
	local icon      = self.iconTable_[idx]
	local monsterId = self.monsterIdTable_[idx]
	if icon then
		self.tipFrame_:show()
		self.tipFrame_:setPosition(self.cellFrame_:getContentSize().width / 6 * idx - 40 ,self.cellFrame_:getContentSize().height * 0.45)
		self.monsterLevelNum_:setString(10)
		self.monsterHpNum_:setString(100)
		self.monsterAttackNum_:setString(60)
	end
end

return RoundListIcon