
local WSToast = {} 
WSToast = class("WSToast", function()
    return display.newNode()
end)

function WSToast:ctor( textStr, time )
	if time ~= nil then
		time = time
	else
		time = 1.5
	end
    self:setPosition(display.cx, display.cy)
    self:setText(textStr,time)
    self:setGlobalZOrder(100)
end

function WSToast:setText(textStr, time)		
	local toast1 = display.newSprite("common_ui/toast1.png"):addTo(self, 2)
		toast1:setAnchorPoint(0, 0.5)
	local toast2 = display.newSprite("common_ui/toast2.png"):addTo(self, 2)
		toast2:setAnchorPoint(0.5, 0.5)
	local toast3 = display.newSprite("common_ui/toast3.png"):addTo(self, 2)
		toast3:setAnchorPoint(1.0, 0.5)
		
	cc.ui.UILabel.new({text = textStr, size = 24,font = GameManager.FONTNAME_TTF}):align(display.CENTER):addTo(self, 3)
	
	local len = #textStr
	print("len: " .. len)
	
	local scale = 2.5
	if len < 30 then
		scale = 0.2
	elseif len >= 30 and len < 40 then 
		scale = 0.6
	elseif len >= 40 and len < 50 then 
		scale = 1.0
	elseif len >= 50 and len < 80 then 
		scale = 2.0
	end
	
	toast2:setScaleX(scale)	
	toast1:setPosition(toast2:getContentSize().width*0.5*scale, 0)
	toast3:setPosition(-(toast2:getContentSize().width*0.5*scale), 0)
	
	local popupLayer = transition.sequence({
		cc.DelayTime:create(time),
		cc.CallFunc:create(function()
				self:removeSelf()
			end)})			
    self:runAction(popupLayer)
 end
 
 return WSToast
