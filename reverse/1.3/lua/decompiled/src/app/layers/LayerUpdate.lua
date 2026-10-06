local M = {}
M = class("LayerUpdate", function()
  return display.newLayer()
end)
M.TAG_UPDATE_SUCC = 100
M.TAG_UPDATE_FAIL = 200
M.TAG_UPDATE_CANCEL = 300

function M:ctor(params)
  if params == nil or params.type == nil or params.type ~= dy.update.EVENT_QUIET_UPDATE and params.type ~= dy.update.EVENT_TIP_UPDATE and params.type ~= dy.update.EVENT_FORCE_UPDATE then
    self:runAction(cc.RemoveSelf:create())
    if params and params.cb then
      params.cb(M.TAG_UPDATE_CANCEL)
    end
    return
  end
  self.mType = params.type
  self.mUrl = params.url
  self.mSavePath = params.savePath
  self.mUnzip = true
  self.mUnzipKey = nil
  self.mFileSize = params.fileSize or 0.1
  self.mFileList = params.list
  self.mCallback = params.cb
  self.mNode = nil
  self.LastAct = nil
  display.newColorLayer(cc.c4b(0, 0, 0, 150)):addTo(self, -1)
  self.mNode = display.newNode():scale(0):pos(display.cx, display.cy):addTo(self, 1)
  local popupLayer = transition.sequence({
    cc.ScaleTo:create(0.2, 1.1),
    cc.ScaleTo:create(0.1, 1)
  })
  self.mNode:runAction(popupLayer)
  if self.mType == dy.update.EVENT_FORCE_UPDATE then
    self.mUnzip = false
  end
  self:initData()
  self:initUI()
end

function M:initData()
  if self.mFileList.count > 0 then
    local sum = 0
    for i = 1, self.mFileList.count do
      local file = self.mFileList[checkstring(i)]
      sum = sum + checknumber(file.size)
    end
    self.mFileSize = sum
    self.mFileList.index = 1
    for i = 1, self.mFileList.count do
      local file = self.mFileList[checkstring(i)]
      file.weight = checknumber(file.size) / self.mFileSize
    end
    self.mFileList.curPer = 0
  end
end

function M:initUI()
  self.mBg = display.newSprite("update/bg.png"):addTo(self.mNode)
  if self.mType == dy.update.EVENT_QUIET_UPDATE then
    self:startDownload()
    return
  end
  local rightNow = cc.ui.UIPushButton.new({
    normal = "common_ui/btn_normal1.png",
    pressed = "common_ui/btn_pressed1.png"
  }):setButtonLabel("normal", DYLabelTTF.new({
    text = DYLang.getString("S985", ""),
    size = 26,
    color = cc.c3b(255, 240, 0),
    font = GameManager.FONTNAME_TTF
  }, {
    lineColor = cc.c3b(25, 30, 3),
    lineWidth = 2
  })):onButtonClicked(function()
    if self.mType == dy.update.EVENT_FORCE_UPDATE then
      DYUtils.gotoLink(self.mUrl)
    else
      self:startDownload()
    end
  end):align(display.CENTER, self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.2):addTo(self.mBg, 2)
  local labelInfo = {}
  if self.mType == dy.update.EVENT_FORCE_UPDATE then
    labelInfo = {
      {
        str = DYLang.getString("S986", ""),
        x = 0.5,
        y = 0.55,
        align = display.CENTER
      }
    }
  elseif self.mType == dy.update.EVENT_TIP_UPDATE then
    labelInfo = {
      {
        str = DYLang.getString("S987", ""),
        x = 0.5,
        y = 0.6,
        align = display.CENTER
      },
      {
        str = DYLang.getString("S988", ""),
        x = 0.1,
        y = 0.48
      },
      {
        str = string.format("%.2fM", self.mFileSize),
        color = cc.c3b(7, 144, 0),
        x = 0.22,
        y = 0.48
      },
      {
        str = DYLang.getString("S989", ""),
        x = 0.4,
        y = 0.48
      }
    }
  end
  for i = 1, #labelInfo do
    local labelColor = labelInfo[i].color or cc.c3b(80, 39, 3)
    local labelAlign = labelInfo[i].align or display.LEFT_CENTER
    cc.ui.UILabel.new({
      text = labelInfo[i].str,
      size = 26,
      color = labelColor,
      font = GameManager.FONTNAME_TTF
    }):align(labelAlign, self.mBg:getContentSize().width * labelInfo[i].x, self.mBg:getContentSize().height * labelInfo[i].y):addTo(self.mBg)
  end
end

function M:startDownload()
  self.mBg:removeAllChildren()
  local barBg = display.newSprite("update/bar_bg.png", 274, 142)
  self.mBg:addChild(barBg)
  self.mProgressBar = display.newProgressTimer("update/bar.png", display.PROGRESS_TIMER_BAR)
  self.mProgressBar:setPosition(barBg:getContentSize().width * 0.5, barBg:getContentSize().height * 0.5)
  barBg:addChild(self.mProgressBar)
  self.mProgressBar:setMidpoint(cc.p(0, 0))
  self.mProgressBar:setBarChangeRate(cc.p(1, 0))
  self.mProgressBar:setPercentage(self.mFileList.curPer * 100)
  self.mPercentLabel = cc.ui.UILabel.new({
    text = string.format("%d%%", self.mFileList.curPer * 100),
    size = 28,
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, barBg:getContentSize().width * 0.5, barBg:getContentSize().height * 0.5):addTo(barBg, 1)
  self.mPercentLabel:enableOutline(cc.c4b(0, 0, 0, 255), 2)
  if 0 < self.mFileList.count then
    local loadNumLabel = cc.ui.UILabel.new({
      text = string.format("(%d/%d)", self.mFileList.index, self.mFileList.count),
      size = 28,
      font = GameManager.FONTNAME_TTF
    }):align(display.CENTER, self.mBg:getContentSize().width * 0.5, self.mBg:getContentSize().height * 0.2):addTo(self.mBg, 1)
    loadNumLabel:enableOutline(cc.c4b(0, 0, 0, 255), 2)
    local index = checkstring(self.mFileList.index)
    local url = self.mFileList[index].url
    DYUtils.download(url, self.mSavePath, self.mUnzip, self.mUnzipKey, handler(self, self.downLoading))
  else
    DYUtils.download(self.mUrl, self.mSavePath, self.mUnzip, self.mUnzipKey, handler(self, self.downLoading))
  end
end

function M:downLoading(event, totalDown, nowDown)
  if event == dy.download.EVENT_ERROR then
    self.mPercentLabel:setString(DYLang.getString("S990", ""))
    self:closeCallBack(M.TAG_UPDATE_FAIL)
  elseif event == dy.download.EVENT_SUCCESS then
    local bSucc = true
    if self.mFileList.count > 0 then
      local index = checkstring(self.mFileList.index)
      local url = self.mFileList[index].url
      local ver = checkstring(self.mFileList[index].ver)
      dy.Common:setGameVer(ver)
      if checknumber(index) >= checknumber(self.mFileList.count) then
        bSucc = true
      else
        self.mFileList.curPer = self.mFileList.curPer + self.mFileList[index].weight
        self.mFileList.index = self.mFileList.index + 1
        self:performWithDelay(handler(self, self.startDownload), 0)
        bSucc = false
      end
    end
    if bSucc then
      self.mProgressBar:setPercentage(100)
      self.mPercentLabel:setString(DYLang.getString("S991", ""))
      self:closeCallBack(M.TAG_UPDATE_SUCC)
    end
  elseif 0 < tonumber(totalDown) then
    local index = checkstring(self.mFileList.index)
    local percent = 100 * (tonumber(nowDown) / tonumber(totalDown) * self.mFileList[index].weight + self.mFileList.curPer)
    self.mPercentLabel:setString(string.format("%d%%", percent))
    self.mProgressBar:setPercentage(percent)
  end
end

function M:closeCallBack(tag)
  local popupLayer = transition.sequence({
    cc.ScaleTo:create(0.1, 1.1),
    cc.ScaleTo:create(0.2, 0),
    cc.CallFunc:create(function()
      self:invokeCallback(tag)
      self:runAction(cc.RemoveSelf:create())
    end)
  })
  self.mNode:runAction(popupLayer)
end

function M:invokeCallback(tag, param1, param2)
  if self.mCallback then
    self.mCallback(tag, param1, param2)
  end
end

return M
