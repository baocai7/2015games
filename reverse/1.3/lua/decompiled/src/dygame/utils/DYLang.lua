local M = {}
local S_LANG = {}
local DEFAULT = "default"

function M.load(lang, file)
  S_LANG[lang] = require(file)
end

function M.loadDefault(file)
  S_LANG[DEFAULT] = require(file)
end

function M.getString(key, default)
  local curLang = device.language
  local lang = S_LANG[curLang] or S_LANG[DEFAULT]
  local desc = lang and lang[key] or default
  return desc
end

return M
