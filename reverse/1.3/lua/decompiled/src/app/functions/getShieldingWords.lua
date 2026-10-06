local function getShieldingWords()
  if CloudData.SHIELDINGWORDS then
    return
  end
  CloudData.SHIELDINGWORDS = {}
  local words = DataRetainer.SHIELDING_WORDS
  for i = 1, #words do
    local str = ""
    if words[i] and checkstring(words[i][1]) ~= "" then
      CloudData.SHIELDINGWORDS[checkstring(words[i][1])] = 1
    end
  end
end

local function getWordsTable(words)
  local t = {}
  if not words then
    return t
  end
  local i = 1
  local mark = 0
  while i <= #words do
    if 0 <= string.byte(words, i) and string.byte(words, i) <= 127 then
      local bt = string.byte(words, i)
      if 64 < bt and bt < 91 or 96 < bt and bt < 123 or 47 < bt and bt < 58 then
        if mark == 0 then
          mark = i
        end
      elseif 0 < mark then
        t[#t + 1] = string.sub(words, mark, i - 1)
        mark = 0
      end
      i = i + 1
      if i > #words and 0 < mark then
        t[#t + 1] = string.sub(words, mark, i - 1)
      end
    else
      if 0 < mark then
        t[#t + 1] = string.sub(words, mark, i - 1)
        mark = 0
      end
      t[#t + 1] = string.sub(words, i, i + 2)
      i = i + 3
    end
  end
  return t
end

local function splitWords(wordsTable, num)
  local info = {}
  if not wordsTable then
    return info
  end
  for i = 0, #wordsTable do
    if wordsTable[i + num] then
      local str = ""
      for j = i + 1, i + num do
        str = str .. wordsTable[j]
      end
      info[#info + 1] = str
    end
  end
  return info
end

local function isLegal(words)
  if CloudData.SHIELDINGWORDS[tostring(words)] then
    return false
  else
    return true
  end
end

function DataUtils.isChatLegal(words)
  getShieldingWords()
  local strTable = getWordsTable(words)
  for i = 1, 7 do
    local wordsTable = splitWords(strTable, i)
    for j = 1, #wordsTable do
      if not isLegal(wordsTable[j]) then
        return false
      end
    end
  end
  return true
end

function DataUtils.checkChat(words)
  local strTable = getWordsTable(words)
  for i = 1, 5 do
    local wordsTable = splitWords(strTable, i)
    for j = 1, #wordsTable do
      if not isLegal(wordsTable[j]) then
        return false
      end
    end
  end
  return true
end

local function getWordsTable(words)
  local t = {}
  if not words then
    return t
  end
  local i = 1
  local mark = 0
  local sum = 0
  local sentence = {}
  local lastPos = 0
  while i <= #words do
    if 0 <= string.byte(words, i) and string.byte(words, i) <= 127 then
      local bt = string.byte(words, i)
      if 64 < bt and bt < 91 or 96 < bt and bt < 123 then
        if mark == 0 then
          mark = i
        end
      elseif 0 < mark then
        t[#t + 1] = string.sub(words, mark, i - 1)
        mark = 0
      end
      i = i + 1
      sum = sum + 1
    else
      if 0 < mark then
        t[#t + 1] = string.sub(words, mark, i - 1)
        mark = 0
      end
      t[#t + 1] = string.sub(words, i, i + 2)
      i = i + 3
      sum = sum + 2
    end
    if 40 <= sum or i > #words then
      print("sum = " .. sum .. "  lastPos = " .. lastPos .. "   i = " .. i)
      local str = string.sub(words, lastPos + 1, i - 1)
      table.insert(sentence, str)
      sum = 0
      lastPos = i - 1
    end
  end
  dump(sentence)
  return t, sentence
end

function DataUtils.getChatSentence(words)
  local t = {}
  if not words then
    return t
  end
  local i = 1
  local length = 0
  local sentence = {}
  local lastPos = 0
  while i <= #words do
    if 0 <= string.byte(words, i) and string.byte(words, i) <= 127 then
      i = i + 1
      length = length + 13.1
    else
      i = i + 3
      length = length + 22.27
    end
    if 460 <= length or i > #words then
      local str = string.sub(words, lastPos + 1, i - 1)
      local info = {num = length, msg = str}
      table.insert(sentence, info)
      length = 0
      lastPos = i - 1
    end
  end
  return sentence
end

local function getStrWidth(params)
  local lb = cc.ui.UILabel.new({
    text = params.text,
    size = params.size,
    color = display.COLOR_WHITE,
    font = params.font
  })
  return lb:getContentSize().width
end

function DataUtils.getNewStrWithAlign(params)
  local tempTable = {}
  
  local function getStrTable(textStr)
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
      local char = string.sub(textStr, 1, i + shift - 1)
      local w = getStrWidth({
        text = char,
        size = params.size,
        font = params.font
      })
      if w > params.lineWidth then
        local char1 = string.sub(textStr, 1, i - 1)
        local char2 = string.sub(textStr, i)
        table.insert(tempTable, char1)
        getStrTable(char2)
        break
      elseif i + shift - 1 == len then
        table.insert(tempTable, char)
      end
      i = i + shift
    end
  end
  
  getStrTable(params.text)
  local newStr = ""
  for i = 1, #tempTable do
    local str = tempTable[i]
    if i == #tempTable then
      newStr = newStr .. str
    else
      newStr = newStr .. str .. "\n"
    end
  end
  return newStr
end
