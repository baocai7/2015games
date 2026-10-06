local DYClass = "LayerNotice"
local M = {}
M = class(DYClass, function()
  return display.newLayer()
end)
local EffectMgr = require("app.utils.EffectMgr")

function M:ctor(canEmpty)
  DDLOG(DYClass .. ": onCreate")
  self.mTag = DYClass
  self.mKeypadListener = handler(self, self.onKeypad)
  DYSoundMgr.playEffect(DY_SND.sfx_touch_ti)
  self.mCoreNode = display.newNode():addTo(self)
  self.mCoreNode:setPosition(cc.p(display.cx, display.cy - 20))
  self.mPageView = nil
  self.mPanelRoot = nil
  self.mLabelTime = nil
  self.mPanelPage = nil
  self.mPageIndicator = nil
  self.mPageIndicators = {}
  self.mData = nil
  self.mCanEmpty = canEmpty
  self:layoutUI()
  self:setNodeEventEnabled(true)
end

function M:onEnter()
  DDLOG(DYClass .. ": onEnter")
  DYKeypadMgr.regKeyHandler(self.mKeypadListener)
end

function M:onExit()
  DDLOG(DYClass .. ": onExit")
  DYKeypadMgr.unregKeyHandler(self.mKeypadListener)
end

function M:onKeypad(keyCode, event)
  DDLOG("Key %d was on pressed!", keyCode)
  if keyCode == cc.KeyCode.KEY_ESCAPE then
    self:hide()
    return true
  end
  return false
end

function M:layoutUI()
  self:addWidget()
  self:addContent()
  self:initData()
end

function M:initData()
  local function tFuncListener(noticeInfo)
    if not (self and type(self) == "userdata" and self.mTag) or self.mTag ~= DYClass then
      return
    end
    CloudData.NOTICE_INFO = noticeInfo.data
    local data = noticeInfo.data
    self.mData = data
    local tDis = 40
    local ty = self.mPageIndicator:getPositionY()
    local tCount = #data
    if tCount <= 0 then
      if self.mCanEmpty then
        self.mLabelTitle:stopAllActions()
        self.mLabelTitle:setString(DYLang.getString("STR_NULL_NOTICE", ""))
        WSToast.new(DYLang.getString("STR_NULL_NOTICE", "")):addTo(self, 20)
      else
        self:runAction(cc.RemoveSelf:create())
      end
      return
    end
    local fileUtils = cc.FileUtils:getInstance()
    for i = 1, tCount do
      local item = self.mPageView:newItem()
      self.mPageView:addItem(item)
      display.newSprite("notice/content_bg.png"):addTo(item)
      local label = DYLabel.new({
        text = "",
        size = 24,
        color = cc.c3b(74, 44, 1),
        font = GameManager.FONTNAME_TTF,
        dimensions = cc.size(700, 360)
      }):align(display.CENTER, 400, 200):addTo(item)
      label:setString(data[i].content)
      label:setAnchorPoint(cc.p(0.5, 1))
      label:setPosition(cc.p(0, 160))
      item.labelContent = label
      if data[i].picName and data[i].picName ~= "" then
        local res = DYUtils.cachePath() .. data[i].picName
        
        local function tFuncShowPic(resPic)
          local image = item.imageContent
          resPic = resPic or res
          if not image then
            if not (self and type(self) == "userdata" and self.mTag) or self.mTag ~= DYClass then
              return
            end
            image = display.newSprite(resPic):addTo(item)
            item.imageContent = image
          else
            image:setTexture(resPic)
          end
        end
        
        if fileUtils:isFileExist(res) then
          tFuncShowPic(res)
        else
          tFuncShowPic("notice/loading.png")
          
          local function tFuncListener(event, total, now)
            if event == dy.download.EVENT_SUCCESS then
              tFuncShowPic(res)
            end
          end
          
          DYUtils.download(data[i].picUrl, DYUtils.cachePath(), false, "", tFuncListener)
        end
      end
      local px = (-0.5 * (tCount + 1) + i) * tDis
      local py = ty
      local pi = self.mPageIndicator:clone():pos(px, py):addTo(self.mWidget)
      pi:setVisible(true)
      pi:setTouchEnabled(false)
      self.mPageIndicators[i] = pi
    end
    self.mPageView:reload()
    self:onSlidePageView()
    self.mLabelTitle:stopAllActions()
    self.mLabelTime:setVisible(false)
  end
  
  DYHttpMgr.noticeInit(tFuncListener)
end

function M:addWidget()
  local node = self.mCoreNode
  display.newColorLayer(cc.c4b(0, 0, 0, 128)):addTo(self, -1)
  local widget = cc.uiloader:load("ui/LayerNotice.csb")
  widget:addTo(node)
  self.mWidget = widget
  local panelRoot = cc.uiloader:seekNodeByName(widget, "PanelRoot")
  panelRoot:setPosition(dy.p(0, 0))
  self.mPanel = panelRoot
  self.mBtnClose = cc.uiloader:seekNodeByName(widget, "ButtonClose")
  self.mBtnClose:addTouchEventListener(handler(self, self.onClickButtonClose))
  self.mPageView = DYPageView.new({
    bgColor = cc.c4b(0, 0, 0, 128),
    viewRect = cc.rect(-400, -200, 800, 400),
    padding = {
      left = 400,
      right = 0,
      top = 0,
      bottom = 200
    },
    columnSpace = 0,
    rowSpace = 0
  }):addTo(widget, 100)
  self.mPageView:onTouch(handler(self, self.onSlidePageView))
  self.mCheckBoxInvisible = cc.uiloader:seekNodeByName(widget, "CheckBoxInvisible")
  self.mCheckBoxInvisible:addTouchEventListener(handler(self, self.onClickCheckBoxInvisible))
  self.mLabelTitle = cc.uiloader:seekNodeByName(widget, "LabelTitle")
  EffectMgr.runEffectLoading(self.mLabelTitle, DYLang.getString("S768", ""), 0.5)
  self.mLabelTime = DYLabelTTF.new({
    text = "11\230\156\13610\230\151\16512\230\151\182-11\230\156\13611\230\151\16513\230\151\182",
    size = 24,
    color = cc.c3b(0, 220, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(40, 40, 40)
  }):pos(0, 210):addTo(panelRoot)
  self.mLabelTime:setVisible(false)
  self.mPanelPage = cc.uiloader:seekNodeByName(widget, "PanelPage")
  self.mPanelPage:setVisible(false)
  local pi = cc.uiloader:seekNodeByName(widget, "PageIndicator")
  pi:setVisible(false)
  self.mPageIndicator = pi
end

function M:addContent()
  local t = os.date("*t", os.time())
  local tag1 = string.format("%d%d%d", t.year, t.month, t.day)
  local tag2 = DYStat.getValueStr(DY_KEY.kNoticeInvisibleTag, "")
  if tag1 == tag2 then
    self.mCheckBoxInvisible:setSelected(true)
  else
    self.mCheckBoxInvisible:setSelected(false)
  end
end

function M:onClickCheckBoxInvisible(sender, eventType)
  if eventType ~= ccui.TouchEventType.ended then
    return
  end
  DYStat.setValueBool(DY_KEY.kNoticeSwitch, sender:isSelected())
  if not sender:isSelected() then
    local t = os.date("*t", os.time())
    DYStat.setValueStr(DY_KEY.kNoticeInvisibleTag, string.format("%d%d%d", t.year, t.month, t.day))
  else
    DYStat.setValueStr(DY_KEY.kNoticeInvisibleTag, "0")
  end
  DDLOG("onClickCheckBoxInvisible, %s, %s", checkstring(eventType), checkstring(sender:isSelected()))
end

function M:onClickButtonClose(sender, eventType)
  if eventType ~= ccui.TouchEventType.ended then
    return
  end
  self:hide()
end

function M:onSlidePageView()
  local pageNum = self.mPageView:getCurPageIdx()
  DDLOG("onPageViewSlide to %d", pageNum)
  for i = 1, #self.mPageIndicators do
    local pi = self.mPageIndicators[i]
    pi:setBright(false)
  end
  local tData1 = os.date("*t", self.mData[pageNum].sendTime / 1000)
  local tData2 = os.date("*t", self.mData[pageNum].endTime / 1000)
  local strTime = string.format("%d\230\156\136%d\230\151\165%d\230\151\182-%d\230\156\136%d\230\151\165%d\230\151\182", tData1.month, tData1.day, tData1.hour, tData2.month, tData2.day, tData2.hour)
  self.mPageIndicators[pageNum]:setBright(true)
  self.mLabelTitle:setString(self.mData[pageNum].title)
  self.mLabelTime:setString(strTime)
end

function M:show()
  local node = self.mCoreNode
  DYUtils.setGlobalZOrder(node, 1)
  local scene = display.getRunningScene()
  scene:addChild(self, 100)
end

function M:hide()
  DYSoundMgr.playEffect(DY_SND.sfx_touch_shu)
  self:stopAllActions()
  self:runAction(cc.RemoveSelf:create())
end

return M
