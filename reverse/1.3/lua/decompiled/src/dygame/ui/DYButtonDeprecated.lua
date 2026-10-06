local M = {}

function M.onStateChanged(param)
  DDLOG("tFuncStateChanged: " .. param.name)
  local onEvent = {
    [cc.ui.UIPushButton.PRESSED_EVENT] = function()
      param.target:setScale(0.9)
    end,
    [cc.ui.UIPushButton.RELEASE_EVENT] = function()
      param.target:setScale(1)
    end
  }
  onEvent[param.name](param)
end

function M.create(param)
  local nImage = param.nImage
  local pImage = param.pImage
  local cached = param.cached
  local listener = param.listener
  local title = param.title or ""
  local bZoom = true
  local hScale = param.scale or 1.02
  local fColor = param.color or cc.c3b(169, 76, 0)
  local event = param.event or cc.CONTROL_EVENTTYPE_TOUCH_UP_INSIDE
  if pImage == nil or pImage == nImage then
    pImage = nImage
    if param.scale then
      bZoom = false
    end
  else
    hScale = 1
    bZoom = false
  end
  local nSprite = DYSprite.createScale9(nImage, cached)
  local pSprite = DYSprite.createScale9(pImage, cached)
  pSprite:setScale(hScale)
  local nSize = param.size or nSprite:getPreferredSize()
  local pTitleButton = cc.Label:createWithSystemFont(title, "Helvetica", 28)
  pTitleButton:setColor(fColor)
  pTitleButton:enableOutline(fColor, 1)
  local pButton = cc.ControlButton:create(pTitleButton, nSprite)
  pButton:setBackgroundSpriteForState(pSprite, cc.CONTROL_STATE_HIGH_LIGHTED)
  pButton:setPreferredSize(nSize)
  pButton:setScaleRatio(hScale)
  pButton:setZoomOnTouchDown(true)
  
  local function tListener()
    if listener ~= nil and pButton:isEnabled() then
      local tag = param.tag or 0
      listener(tag, pButton)
    end
  end
  
  pButton:registerControlEventHandler(tListener, event)
  param.nSprite = nSprite
  param.pSprite = pSprite
  pButton.param = param
  return pButton
end

function M.createByNode(param)
  local nImage = param.nImage
  local pImage = param.pImage
  local listener = param.listener
  local title = param.title or ""
  local nSize = param.size or param.nImage:getContentSize()
  local fColor = param.color or cc.c3b(169, 76, 0)
  local nSprite = DYSprite.createScale9("uikit/gi_trans.png", true)
  nImage:setPosition(nSize.width * 0.5, nSize.height * 0.5)
  nSprite:addChild(nImage)
  local pSprite
  if pImage ~= nil and pImage ~= nImage then
    pSprite = DYSprite.createScale9("uikit/gi_trans.png", true)
    pImage:setPosition(nSize.width * 0.5, nSize.height * 0.5)
    pSprite:addChild(pImage)
  end
  local pTitleButton = cc.LabelTTF:create(title, "Helvetica", 28)
  pTitleButton:setColor(fColor)
  local pButton = cc.ControlButton:create(pTitleButton, nSprite)
  if pSprite == nil then
    pButton:setZoomOnTouchDown(true)
  else
    pButton:setBackgroundSpriteForState(pSprite, cc.CONTROL_STATE_HIGH_LIGHTED)
    pButton:setZoomOnTouchDown(false)
  end
  pButton:setPreferredSize(nSize)
  
  local function tListener()
    if listener ~= nil and pButton:isEnabled() then
      local tag = param.tag or 0
      listener(tag, pButton)
    end
  end
  
  pButton:registerControlEventHandler(tListener, cc.CONTROL_EVENTTYPE_TOUCH_UP_INSIDE)
  param.nSprite = nSprite
  param.pSprite = pSprite
  pButton.param = param
  return pButton
end

function M.createWithBMFont(param)
  local nImage = param.nImage
  local pImage = param.pImage
  local cached = param.cached
  local listener = param.listener
  local title = param.title or ""
  local bZoom = true
  local hScale = param.scale or 1.02
  local font = param.font or "uikit/gf_default.fnt"
  local fColor = param.fColor or cc.c3b(0, 0, 0)
  local fScale = param.fScale or 1
  local event = param.event or cc.CONTROL_EVENTTYPE_TOUCH_UP_INSIDE
  if pImage == nil or pImage == nImage then
    pImage = nImage
    if param.scale then
      bZoom = false
    end
  else
    hScale = 1
  end
  local nSprite = DYSprite.createScale9(nImage, cached)
  local pSprite = DYSprite.createScale9(pImage, cached)
  pSprite:setScale(hScale)
  local nSize = param.size or nSprite:getPreferredSize()
  local pTitleButton = cc.LabelBMFont:create(title, font)
  pTitleButton:setColor(fColor)
  pTitleButton:setScale(fScale)
  local pButton = cc.ControlButton:create(pTitleButton, nSprite)
  pButton:setBackgroundSpriteForState(pSprite, cc.CONTROL_STATE_HIGH_LIGHTED)
  pButton:setScaleRatio(hScale)
  pButton:setZoomOnTouchDown(true)
  pButton:setPreferredSize(nSize)
  
  local function tListener()
    if listener ~= nil and pButton:isEnabled() then
      local tag = param.tag or 0
      listener(tag, pButton)
    end
  end
  
  pButton:registerControlEventHandler(tListener, cc.CONTROL_EVENTTYPE_TOUCH_UP_INSIDE)
  param.nSprite = nSprite
  param.pSprite = pSprite
  pButton.param = param
  return pButton
end

function M.selected(button)
  local nSprite = button.param.nSprite
  nSprite:retain()
  local pSprite = button.param.pSprite
  pSprite:retain()
  local tsn = DYSprite.createScale9("uikit/gi_trans.png", true)
  local tsp = DYSprite.createScale9("uikit/gi_trans.png", true)
  button:setBackgroundSpriteForState(tsn, cc.CONTROL_STATE_NORMAL)
  button:setBackgroundSpriteForState(tsp, cc.CONTROL_STATE_HIGH_LIGHTED)
  button:setBackgroundSpriteForState(pSprite, cc.CONTROL_STATE_NORMAL)
  button:setBackgroundSpriteForState(nSprite, cc.CONTROL_STATE_HIGH_LIGHTED)
  nSprite:release()
  pSprite:release()
  button.tagSelected = true
end

function M.unselected(button)
  local nSprite = button.param.nSprite
  nSprite:retain()
  local pSprite = button.param.pSprite
  pSprite:retain()
  local tsn = DYSprite.createScale9("uikit/gi_trans.png", true)
  local tsp = DYSprite.createScale9("uikit/gi_trans.png", true)
  button:setBackgroundSpriteForState(tsn, cc.CONTROL_STATE_NORMAL)
  button:setBackgroundSpriteForState(tsp, cc.CONTROL_STATE_HIGH_LIGHTED)
  button:setBackgroundSpriteForState(nSprite, cc.CONTROL_STATE_NORMAL)
  button:setBackgroundSpriteForState(pSprite, cc.CONTROL_STATE_HIGH_LIGHTED)
  nSprite:release()
  pSprite:release()
  button.tagSelected = false
end

function M.setSelected(button, flag)
  if flag then
    M.selected(button, flag)
  else
    M.unselected(button, flag)
  end
end

function M.isSelected(button)
  return button.tagSelected == true
end

function M.sayHi()
  DDLOG("DYButton ---------> Hi")
end

return M
