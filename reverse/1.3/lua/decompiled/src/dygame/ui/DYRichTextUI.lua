local CLASS_NAME = "DYRichTextUI"
local M = {}
M = class(CLASS_NAME, function()
  return display.newNode(CLASS_NAME)
end)
M.TAG_SIZE_CHANGED = 1000

function M:addElementText(tag, color, opacity, text, font, fontSize)
  local richText = self.mRichText
  local rc = ccui.RichElementText:create(tag, color, opacity, text, font, fontSize)
  richText:pushBackElement(rc)
  self:adjustContentSize()
end

function M:addElementImage(tag, color, opacity, filePath)
  local richText = self.mRichText
  local rc = ccui.RichElementImage:create(tag, color, opacity, filePath)
  richText:pushBackElement(rc)
  self:adjustContentSize()
end

function M:addElementCustomNode(tag, color, opacity, customNode)
  local richText = self.mRichText
  local rc = ccui.RichElementCustomNode:create(tag, color, opacity, customNode)
  richText:pushBackElement(rc)
  self:adjustContentSize()
end

function M:setAnchorPoint()
  return
end

function M:ctor(param)
  DDLOG(CLASS_NAME .. ": onCreate")
  self.mParam = param or {}
  self.mRichText = nil
  self.mSpriteBg = nil
  self.mAutoFit = param.autoFit
  self.mCallback = param.cb
  self.mCoreNode = display.newNode()
  self:addChild(self.mCoreNode)
  self:layoutUI()
end

function M:onEnter()
  DDLOG(CLASS_NAME .. ": onEnter")
end

function M:onExit()
  DDLOG(CLASS_NAME .. ": onExit")
end

function M:layoutUI()
  local node = self.mCoreNode
  local bg = self.mParam.bg
  local bgColor = self.mParam.bgColor or cc.c3b(255, 255, 255)
  local sp = display.newScale9Sprite(bg)
  sp:setColor(bgColor)
  sp:setAnchorPoint(cc.p(0.5, 0.5))
  node:addChild(sp)
  self.mSpriteBg = sp
  local richText = ccui.RichText:create()
  local size = self.mParam.size or cc.size(display.cx, 0)
  richText:ignoreContentAdaptWithSize(false)
  richText:setContentSize(size)
  richText:setAnchorPoint(cc.p(0.5, 0))
  node:addChild(richText, 10)
  self.mRichText = richText
end

function M:adjustContentSize()
  local function tFunc()
    local richText = self.mRichText
    
    local vrSize = richText:getVirtualRendererSize()
    local margin = self.mParam.margin or cc.p(30, 30)
    local sp = self.mSpriteBg
    sp:setPreferredSize(cc.size(vrSize.width + margin.x * 2, vrSize.height + margin.y * 2))
    if not self.mAutoFit or self.mAutoFit ~= true then
      return
    end
    if self:getContentSize().width ~= sp:getContentSize().width or self:getContentSize().height ~= sp:getContentSize().height then
      self:setContentSize(sp:getContentSize())
      self:invokeCallback(M.TAG_SIZE_CHANGED)
    end
  end
  
  performWithDelay(self, tFunc, 0)
end

function M:invokeCallback(tag, param1, param2)
  if self.mCallback then
    self.mCallback(tag, param1, param2)
  end
end

return M
