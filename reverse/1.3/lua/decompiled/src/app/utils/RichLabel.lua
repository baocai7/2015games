local M = {}
M = class("RichLabel", function()
  return display.newNode()
end)

function M:ctor(params)
  self.mTextArr = params.textArr
  self.mRowHight = params.rowHeight
  self.mMaxWidth = params.maxWidth
  self.mLabelArr = {}
  self:setLabelSize()
  self:layoutUI()
end

function M:setLabelSize()
  local lineWidth = 0
  for i = 1, #self.mTextArr do
    local textInfo = self.mTextArr[i]
    local lb = DYLabelTTF.new({
      text = textInfo.text,
      size = textInfo.size,
      color = textInfo.color,
      font = textInfo.font,
      dyalign = "TOP_LEFT"
    })
    lineWidth = lineWidth + lb:getContentSize().width
    table.insert(self.mLabelArr, lb)
  end
  local height = math.ceil(lineWidth / self.mMaxWidth) * self.mRowHight
  self:setContentSize(self.mMaxWidth, height)
end

local function getWordsTable(textStr)
  local list1 = {}
  local list2 = {}
  local len = string.len(textStr)
  local i = 1
  while len >= i do
    local c = string.byte(textStr, i)
    local shift = 1
    if 0 < c and c <= 127 then
      shift = 1
    elseif 192 <= c and c <= 223 then
      shift = 2
    elseif 224 <= c and c <= 239 then
      shift = 3
    elseif 240 <= c and c <= 247 then
      shift = 4
    end
    local char1 = string.sub(textStr, 1, i + shift - 1)
    local char2 = string.sub(textStr, i + shift, len)
    i = i + shift
    table.insert(list1, char1)
    table.insert(list2, char2)
  end
  return list1, list2
end

local function splitTextStr(label, width)
  local label1, label2
  local list1, list2 = getWordsTable(label:getString())
  if 1 < #list1 then
    for i = 1, #list1 - 1 do
      local text1 = list1[i]
      local text2 = list1[i + 1]
      label1 = DYLabelTTF.new({
        text = text1,
        size = label:getFontSize(),
        color = label:getColor(),
        font = label:getFontName(),
        dyalign = "TOP_LEFT"
      })
      label2 = DYLabelTTF.new({
        text = text2,
        size = label:getFontSize(),
        color = label:getColor(),
        font = label:getFontName(),
        dyalign = "TOP_LEFT"
      })
      local w1 = label1:getContentSize().width
      local w2 = label2:getContentSize().width
      if width < w1 then
        label1 = nil
        label2 = DYLabelTTF.new({
          text = list1[#list1],
          size = label:getFontSize(),
          color = label:getColor(),
          font = label:getFontName(),
          dyalign = "TOP_LEFT"
        })
        break
      end
      if width >= w1 and width < w2 then
        label2 = DYLabelTTF.new({
          text = list2[i],
          size = label:getFontSize(),
          color = label:getColor(),
          font = label:getFontName(),
          dyalign = "TOP_LEFT"
        })
        break
      end
    end
  elseif #list1 == 1 then
    label1 = DYLabelTTF.new({
      text = list1[1],
      size = label:getFontSize(),
      color = label:getColor(),
      font = label:getFontName(),
      dyalign = "TOP_LEFT"
    })
  end
  return label1, label2
end

function M:layoutUI()
  local offsetX = 0
  local offsetY = 0
  local height = self:getContentSize().height
  for i = 1, #self.mLabelArr do
    local label = self.mLabelArr[i]
    local width = label:getContentSize().width
    offsetX = offsetX + width
    if offsetX > self.mMaxWidth then
      local leftWidth = self.mMaxWidth - offsetX + width
      local label1, label2 = splitTextStr(label, leftWidth)
      if label1 then
        label1:setPosition(offsetX - width, height - offsetY * self.mRowHight)
        label1:addTo(self)
      end
      offsetY = offsetY + 1
      offsetX = 0
      if label2 then
        label2:setPosition(offsetX, height - offsetY * self.mRowHight)
        label2:addTo(self)
        offsetX = offsetX + label2:getContentSize().width
      end
    else
      label:setPosition(offsetX - width, height - offsetY * self.mRowHight)
      label:addTo(self)
    end
  end
end

return M
