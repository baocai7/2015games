local M = {}
M = class("TeamFateIcon", function()
  return display.newNode()
end)

function M:ctor(buddhaId)
  self:initData(buddhaId)
  self:initUI()
end

function getIconHeight(self)
  local h1 = 50
  local h2 = 184
  local h3 = 5
  local height = h1 + (h2 + h3) * #self.mFateInfo
  return height
end

function M:initData(buddhaId)
  self.mBuddhaId = buddhaId
  self.mFateInfo = DataUtils.getFateInfoForAssist(buddhaId)
  self.mBuddhaModel = DataUtils.getBuddhaModelBaseInfo(buddhaId)
  self.mHeight = getIconHeight(self)
  local tb1 = DataUtils.getBuddhaTableOnTeam()
  local tb2 = DataUtils.getBuddhaTableOnAssist()
  table.insertto(tb1, tb2)
  self.mBuddhaTable = table.unique(tb1)
  self.mFateUITable = {}
end

function M:initUI()
  local bg = display.newScale9Sprite("common_ui/blank.png", 0, 0, cc.size(498, self.mHeight), cc.rect(240, 75, 5, 5)):addTo(self)
  self.mBg = bg
  local nameFrame = display.newSprite("team/name_frame.png"):pos(bg:getContentSize().width * 0.5, self.mHeight - 40):addTo(bg)
  cc.ui.UILabel.new({
    text = self.mBuddhaModel.name,
    size = 26,
    color = cc.c3b(75, 42, 3),
    font = GameManager.FONTNAME_TTF
  }):align(display.CENTER, nameFrame:getContentSize().width * 0.5, nameFrame:getContentSize().height * 0.56):addTo(nameFrame)
  for i = 1, #self.mFateInfo do
    local currFate = self.mFateInfo[i]
    local frame = display.newSprite("team/fate_frame.png"):align(display.CENTER_TOP, nameFrame:getContentSize().width * 0.5, -190 * (i - 1) + 25):addTo(nameFrame, -1)
    local nameLabel = DYLabelTTF.new({
      text = string.format("[%s]", currFate.fateName),
      size = 20,
      color = cc.c3b(255, 222, 1),
      font = GameManager.FONTNAME_TTF
    }, {
      lineWidth = 1.5,
      lineColor = cc.c3b(71, 45, 8)
    }):pos(frame:getContentSize().width * 0.5, frame:getContentSize().height * 0.83):addTo(frame)
    local addLabel = DYLabelTTF.new({
      text = currFate.fataDesc,
      size = 20,
      color = cc.c3b(4, 254, 2),
      font = GameManager.FONTNAME_TTF,
      dyalign = "CENTER_LEFT"
    }, {lineWidth = 1.5}):pos(frame:getContentSize().width * 0.05, frame:getContentSize().height * 0.12):addTo(frame)
    if not currFate.isFateActive then
      frame:setTexture("team/fate_frame_h.png")
      nameLabel:setColor(cc.c3b(215, 198, 164))
      addLabel:setColor(cc.c3b(252, 230, 195))
    end
    local icontb = {}
    for i = 1, #currFate.buddhaIds + 1 do
      local buddhaModel
      local dsNum = 1
      if 1 == i then
        buddhaModel = self.mBuddhaModel
      else
        buddhaModel = DataUtils.getBuddhaModelBaseInfo(currFate.buddhaIds[i - 1])
        local index = table.indexof(self.mBuddhaTable, tostring(currFate.buddhaIds[i - 1]))
        if not index then
          dsNum = 2
        end
      end
      local frameList = {}
      local iconList = {}
      for a = 1, 2 do
        local iconFrame, icon
        if 1 == a then
          iconFrame = display.newSprite(string.format("common_ui/frame%d.png", buddhaModel.quality))
          icon = display.newSprite(buddhaModel.icon)
        else
          iconFrame = display.newGraySprite(string.format("common_ui/frame%d.png", buddhaModel.quality), {
            0.2,
            0.3,
            0.5,
            0.1
          })
          icon = display.newGraySprite(buddhaModel.icon, {
            0.2,
            0.3,
            0.5,
            0.1
          })
        end
        iconFrame:setScale(0.75)
        iconFrame:setPosition(frame:getContentSize().width * (0.23 * i - 0.09), frame:getContentSize().height * 0.48)
        frame:addChild(iconFrame)
        icon:setPosition(iconFrame:getContentSize().width * 0.5, iconFrame:getContentSize().height * 0.5)
        iconFrame:addChild(icon)
        if 0 == buddhaModel.isRebel then
          icon:setScaleX(-1)
        end
        if dsNum == a then
          iconFrame:show()
        else
          iconFrame:hide()
        end
        frameList[a] = iconFrame
        iconList[a] = icon
      end
      local tb1 = {frame = frameList, icon = iconList}
      table.insert(icontb, tb1)
    end
    local tb = {
      fateFrame = frame,
      name = nameLabel,
      add = addLabel,
      icon = icontb
    }
    table.insert(self.mFateUITable, tb)
  end
end

function M:updateUI()
  self.mFateInfo = DataUtils.getFateInfoForAssist(self.mBuddhaId)
  local tb1 = DataUtils.getBuddhaTableOnTeam()
  local tb2 = DataUtils.getBuddhaTableOnAssist()
  table.insertto(tb1, tb2)
  self.mBuddhaTable = table.unique(tb1)
  for i = 1, #self.mFateInfo do
    local currFate = self.mFateInfo[i]
    local frame = self.mFateUITable[i].fateFrame
    local nameLabel = self.mFateUITable[i].name
    local addLabel = self.mFateUITable[i].add
    local iconTable = self.mFateUITable[i].icon
    if currFate.isFateActive then
      frame:setTexture("team/fate_frame.png")
      nameLabel:setColor(cc.c3b(255, 222, 1))
      addLabel:setColor(cc.c3b(4, 254, 2))
    else
      frame:setTexture("team/fate_frame_h.png")
      nameLabel:setColor(cc.c3b(215, 198, 164))
      addLabel:setColor(cc.c3b(252, 230, 195))
    end
    for i = 2, #currFate.buddhaIds + 1 do
      local dsNum = 1
      local index = table.indexof(self.mBuddhaTable, tostring(currFate.buddhaIds[i - 1]))
      if not index then
        dsNum = 2
      end
      local frameList = iconTable[i].frame
      local iconList = iconTable[i].icon
      for i = 1, #frameList do
        local iconFrame = frameList[i]
        local icon = iconList[i]
        if dsNum == i then
          iconFrame:show()
        else
          iconFrame:hide()
        end
      end
    end
  end
end

return M
