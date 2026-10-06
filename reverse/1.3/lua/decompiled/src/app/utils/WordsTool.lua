local M = {}

function M.getSingleWordTable(textStr)
  local t = {}
  local i = 1
  while i < #textStr do
    if string.byte(textStr, i) >= 0 and string.byte(textStr, i) <= 127 then
      t[#t + 1] = string.sub(textStr, i, i)
    else
      t[#t + 1] = string.sub(textStr, i, i + 2)
      i = i + 2
    end
    i = i + 1
  end
  return t
end

function M.getVariableWordsTable(textStr)
  local t = {}
  local i = 1
  while i < #textStr do
    if string.byte(textStr, i) >= 0 and string.byte(textStr, i) <= 127 then
      t[#t + 1] = string.sub(textStr, 1, i)
    else
      t[#t + 1] = string.sub(textStr, 1, i + 2)
      i = i + 2
    end
    i = i + 1
  end
  return t
end

return M
