local function deprecatedTip(old_name, new_name)
  print([[


********** 
]] .. old_name .. " was deprecated please use " .. new_name .. [[
 instead.
**********]])
end

local CCControlDeprecated = {}

function CCControlDeprecated:addHandleOfControlEvent(func, controlEvent)
  deprecatedTip("addHandleOfControlEvent", "registerControlEventHandler")
  print("come in addHandleOfControlEvent")
  self:registerControlEventHandler(func, controlEvent)
end

CCControl.addHandleOfControlEvent = CCControlDeprecated.addHandleOfControlEvent
CCTableView.kTableViewScroll = cc.SCROLLVIEW_SCRIPT_SCROLL
CCTableView.kTableViewZoom = cc.SCROLLVIEW_SCRIPT_ZOOM
CCTableView.kTableCellTouched = cc.TABLECELL_TOUCHED
CCTableView.kTableCellSizeForIndex = cc.TABLECELL_SIZE_FOR_INDEX
CCTableView.kTableCellSizeAtIndex = cc.TABLECELL_SIZE_AT_INDEX
CCTableView.kNumberOfCellsInTableView = cc.NUMBER_OF_CELLS_IN_TABLEVIEW
CCScrollView.kScrollViewScroll = cc.SCROLLVIEW_SCRIPT_SCROLL
CCScrollView.kScrollViewZoom = cc.SCROLLVIEW_SCRIPT_ZOOM
