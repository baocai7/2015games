-- Narrow diagnostics for legacy resource construction.  The original calls
-- remain untouched; this module only records their inputs and failures.
local CompatTrace = {}

local function stringify(value)
    return tostring(value == nil and "<nil>" or value)
end

function CompatTrace.log(tag, message)
    local line = string.format("[compat-trace][%s] %s", stringify(tag), stringify(message))
    print(line)
    pcall(function()
        local writable = cc.FileUtils:getInstance():getWritablePath()
        local file = io.open(writable .. "compat_trace.log", "ab")
        if file ~= nil then
            file:write(os.date("!%Y-%m-%dT%H:%M:%SZ ") .. line .. "\n")
            file:close()
        end
    end)
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

function CompatTrace.canUseActorFallback(model)
    if model == nil then
        CompatTrace.log("actor-fallback", "model=<nil>")
        return false
    end
    local path = model.standFrame_
    local ok, exists = pcall(function()
        return cc.FileUtils:getInstance():isFileExist(path)
    end)
    CompatTrace.log("actor-fallback", string.format("npc=%s stand=%s exists=%s check_ok=%s",
        stringify(model.npcId_), stringify(path), tostring(exists), tostring(ok)))
    return ok and exists == true
end

function CompatTrace.canUseSummonFallback()
    local paths = {"buddha/buddha1.png", "buddha_icon/buddha1.png"}
    local ok, available = pcall(function()
        for _, path in ipairs(paths) do
            if not cc.FileUtils:getInstance():isFileExist(path) then return false end
        end
        return true
    end)
    CompatTrace.log("summon-resource", string.format("bundled_static_fallback=%s check_ok=%s",
        tostring(available), tostring(ok)))
    return ok and available == true
end

function CompatTrace.node(tag, node)
    if node == nil then
        CompatTrace.log(tag, "node=<nil>")
        return false
    end
    local ok, visible, sx, sy, width, height = pcall(function()
        local size = node:getContentSize()
        return node:isVisible(), node:getScaleX(), node:getScaleY(), size.width, size.height
    end)
    if not ok then
        CompatTrace.log(tag, "node=present inspect=FAILED")
        return false
    end
    CompatTrace.log(tag, string.format("node=present visible=%s scale=(%s,%s) size=(%s,%s)",
        tostring(visible), tostring(sx), tostring(sy), tostring(width), tostring(height)))
    return width > 0 and height > 0
end

function CompatTrace.createArmature(name, path)
    CompatTrace.resource("actor-armature", path)
    local function create()
        local value = ccs.Armature:create(name)
        if value ~= nil and value.getAnimation ~= nil then
            local animation = value:getAnimation()
            if animation ~= nil then return value end
        end
        return nil
    end
    local ok, value = xpcall(create, debug.traceback)
    if ok and value ~= nil and CompatTrace.node("actor-armature", value) then
        CompatTrace.log("actor-armature", "created name=" .. stringify(name) .. " registration=async")
        return value
    end
    CompatTrace.log("actor-armature", "async registration produced no renderable node name=" .. stringify(name))
    local syncOk, syncValue = xpcall(function()
        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(path)
        return create()
    end, debug.traceback)
    if syncOk and syncValue ~= nil then
        CompatTrace.node("actor-armature", syncValue)
        CompatTrace.log("actor-armature", "created name=" .. stringify(name) .. " registration=sync-retry")
        return syncValue
    end
    CompatTrace.log("actor-armature", "sync retry FAILED name=" .. stringify(name) .. "\n" .. stringify(syncValue))
    return nil
end

function CompatTrace.install()
    if CompatTrace.installed_ or not display or not display.addSpriteFrames then return end
    CompatTrace.installed_ = true
    local original = display.addSpriteFrames
    display.addSpriteFrames = function(plist, texture)
        CompatTrace.resource("atlas", plist)
        CompatTrace.resource("atlas", texture)
        local ok, err = xpcall(function() return original(plist, texture) end, debug.traceback)
        if ok then
            CompatTrace.log("atlas", string.format("loaded plist=%s texture=%s", stringify(plist), stringify(texture)))
            return
        end
        CompatTrace.log("atlas", string.format("FAILED plist=%s texture=%s\n%s", stringify(plist), stringify(texture), stringify(err)))
        return false
    end
end

return CompatTrace
