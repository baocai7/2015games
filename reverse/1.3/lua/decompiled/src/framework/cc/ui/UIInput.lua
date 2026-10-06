local UIInput
UIInput = class("UIInput", function(options)
  local inputLabel
  if not (options and options.UIInputType) or 1 == options.UIInputType then
    inputLabel = UIInput.newEditBox_(options)
    inputLabel.UIInputType = 1
  else
    if 2 == options.UIInputType then
      inputLabel = UIInput.newTextField_(options)
      inputLabel.UIInputType = 2
    else
    end
  end
  return inputLabel
end)

function UIInput:ctor(options)
  if 2 == options.UIInputType then
    self.getText = self.getStringValue
  end
end

function UIInput.newEditBox_(params)
  local imageNormal = params.image
  local imagePressed = params.imagePressed
  local imageDisabled = params.imageDisabled
  if type(imageNormal) == "string" then
    imageNormal = display.newScale9Sprite(imageNormal)
  end
  if type(imagePressed) == "string" then
    imagePressed = display.newScale9Sprite(imagePressed)
  end
  if type(imageDisabled) == "string" then
    imageDisabled = display.newScale9Sprite(imageDisabled)
  end
  local editboxCls
  if cc.bPlugin_ then
    editboxCls = ccui.EditBox
  else
    editboxCls = cc.EditBox
  end
  local editbox = editboxCls:create(params.size, imageNormal, imagePressed, imageDisabled)
  if editbox then
    if params.listener then
      editbox:registerScriptEditBoxHandler(params.listener)
    end
    if params.x and params.y then
      editbox:setPosition(params.x, params.y)
    end
  end
  return editbox
end

function UIInput.newTextField_(params)
  local textfieldCls
  if cc.bPlugin_ then
    textfieldCls = ccui.TextField
  else
    textfieldCls = cc.TextField
  end
  local editbox = textfieldCls:create()
  editbox:setPlaceHolder(params.placeHolder)
  editbox:setPosition(params.x, params.y)
  if params.listener then
    editbox:addEventListener(params.listener)
  end
  if params.size then
    editbox:setTextAreaSize(params.size)
  end
  if params.text then
    if editbox.setString then
      editbox:setString(params.text)
    else
      editbox:setText(params.text)
    end
  end
  if params.font then
    editbox:setFontName(params.font)
  end
  if params.fontSize then
    editbox:setFontSize(params.fontSize)
  end
  if params.maxLength and 0 ~= params.maxLength then
    editbox:setMaxLengthEnabled(true)
    editbox:setMaxLength(params.maxLength)
  end
  if params.passwordEnable then
    editbox:setPasswordEnabled(true)
  end
  if params.passwordChar then
    editbox:setPasswordStyleText(params.passwordChar)
  end
  return editbox
end

return UIInput
