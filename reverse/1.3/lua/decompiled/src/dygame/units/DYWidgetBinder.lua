local CLASS_NAME = "DYWidgetBinder"
local M = class(CLASS_NAME, DYUnitBase)

function M:bindWidget(widget, items)
  local target = self:getTarget()
  if not target then
    return
  end
  for i = 1, #items do
    local name = items[i]
    local item = cc.uiloader:seekNodeByName(widget, name)
    local ki = "m" .. name
    target[ki] = item
    local isBtn = string.find(name, "Button") == 1
    if isBtn then
      item:addTouchEventListener(handler(self, self.onEventButton_))
    end
    local isListView = string.find(name, "ListView") == 1
    if isListView then
      item:addEventListener(handler(self, self.onEventListView_))
      item:addScrollViewEventListener(handler(self, self.onEventScrollView_))
    end
    local isPageView = string.find(name, "PageView") == 1
    if isPageView then
      item:addEventListener(handler(self, self.onEventPageView_))
    end
  end
end

function M:onEventListView_(...)
  local target = self:getTarget()
  if target and target.onEventListView then
    target:onEventListView(...)
  end
end

function M:onEventScrollView_(...)
  local target = self:getTarget()
  if target and target.onEventScrollView then
    target:onEventScrollView(...)
  end
end

function M:onEventPageView_(...)
  local target = self:getTarget()
  if target and target.onEventPageView then
    target:onEventPageView(...)
  end
end

function M:onEventButton_(...)
  local target = self:getTarget()
  if target and target.onEventButton then
    target:onEventButton(...)
  end
end

return M
