-- Narrow diagnostics for legacy resource construction.  The original calls
-- remain untouched; this module only records their inputs and failures.
local CompatTrace = {}

local function stringify(value)
    return tostring(value == nil and "<nil>" or value)
end

function CompatTrace.log(tag, message)
    local line = string.format("[compat-trace][%s] %s", stringify(tag), stringify(message))
    print(line)
    local ok, old = pcall(function()
        return cc.UserDefault:getInstance():getStringForKey("compat_resource_trace")
    end)
    if not ok then return end
    old = old or ""
    old = old .. line .. "\n"
    if #old > 12000 then old = string.sub(old, -12000) end
    pcall(function()
        cc.UserDefault:getInstance():setStringForKey("compat_resource_trace", old)
    end)
end

function CompatTrace.resource(tag, path)
    local ok, exists = pcall(function()
        return cc.FileUtils:getInstance():isFileExist(path)
    end)
    CompatTrace.log(tag, string.format("path=%s exists=%s check_ok=%s", stringify(path), tostring(exists), tostring(ok)))
end

function CompatTrace.install()
    if CompatTrace.installed_ or not display or not display.addSpriteFrames then
        return
    end
    CompatTrace.installed_ = true
    local original = display.addSpriteFrames
    display.addSpriteFrames = function(plist, texture)
        CompatTrace.resource("atlas", plist)
        CompatTrace.resource("atlas", texture)
        local ok, err = xpcall(function()
            -- Keep the engine's original atlas-loading implementation.
            return original(plist, texture)
        end, debug.traceback)
        if ok then
            CompatTrace.log("atlas", string.format("loaded plist=%s texture=%s", stringify(plist), stringify(texture)))
            return
        end
        CompatTrace.log("atlas", string.format("FAILED plist=%s texture=%s\n%s", stringify(plist), stringify(texture), stringify(err)))
        -- Preserve the caller's control flow so a missing optional atlas can
        -- reach its local compatibility fallback and leave a diagnostic in
        -- the trace instead of aborting the entire scene constructor.
        return false
    end
end

return CompatTrace
