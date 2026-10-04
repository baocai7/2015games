--
--进入升级界面,预加载资源
--

local UpgradeScene = class("UpgradeScene", function()
    return display.newScene("UpgradeScene")
end)

function UpgradeScene:ctor()

    display.newSprite("common_ui/uibg.jpg",display.cx,display.cy):addTo(self)

    -- 加载函数，虽然比较安全，但开发时，难以获取错误
    local function loadTable()
        -- --加载四个界面的table
        GameManager.BUDDHA_MODEL_TABLE  = DataUtils.getBuddhaModelsTableUpgradeScene("BUDDHA")
        GameManager.MONSTER_MODEL_TABLE = DataUtils.getBuddhaModelsTableUpgradeScene("MONSTER")
        GameManager.TOWER_MODEL_TABLE   = DataUtils.getTableUpgradePropertyModel("TOWER")
        GameManager.TANG_MODEL_TABLE    = DataUtils.getTableUpgradePropertyModel("TANG")
        
        -- 测试
--        local npcInfoId                     = CloudData.NPC_INFO[120].level

        -- 解决不了资源多次释放的崩溃
--        local spt = cc.Sprite:create()
--        spt:release()
--        spt:release()
    end
    xpcall(loadTable, __G__TRACKBACK__)

    self:performWithDelay(function()
        display.replaceScene(require("layers.UpgradeBuddhaLayer").new())
    end, 0.1)
end

function UpgradeScene:onEnter()
end

function UpgradeScene:onExit()
end

return UpgradeScene
