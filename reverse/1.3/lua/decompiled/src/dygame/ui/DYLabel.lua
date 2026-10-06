local UILabel
UILabel = class("UILabel", function(options)
  if not options then
    return
  end
  if 1 == options.UILabelType then
    return UILabel.newBMFontLabel_(options)
  elseif not options.UILabelType or 2 == options.UILabelType then
    return UILabel.newTTFLabel_(options)
  else
    printInfo("UILabel unkonw UILabelType")
  end
end)
UILabel.LABEL_TYPE_BM = 1
UILabel.LABEL_TYPE_TTF = 2

function UILabel:ctor(options)
  makeUIControl_(self)
  self:setLayoutSizePolicy(display.FIXED_SIZE, display.FIXED_SIZE)
  self:align(display.LEFT_CENTER)
end

function UILabel:setLayoutSize(width, height)
  self:getComponent("components.ui.LayoutProtocol"):setLayoutSize(width, height)
  return self
end

function UILabel.newBMFontLabel_(params)
  return display.newBMFontLabel(params)
end

function UILabel.newTTFLabel_(params)
  return display.newTTFLabel(params)
end

return UILabel
