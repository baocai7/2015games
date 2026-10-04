--
--购买精力
--

local AlertConnection = import("customs.AlertConnection")
local WSToast = import("utils.WSToast")
local AlertLackPeachLayer = import("layers.AlertLackPeachLayer")


local BuyEnergyLayer  =  class("BuyEnergyLayer", function()
    return display.newLayer()
end)

function BuyEnergyLayer:ctor()
    --蟠桃数量: self.num_
    self.num_ = CloudData.GINSENG_FRUIT

    --添加遮罩层
    self.mask = display.newColorLayer(cc.c4b(0,0,0,150))
        :addTo(self,-1)

    --初始化基础节点
    self.node = display.newNode()
        :scale(0)
        :pos(display.cx, display.cy)
        :addTo(self,1)

    --弹出效果
    local popupLayer = transition.sequence(
        {cc.ScaleTo:create(0.2, 1.1),
            cc.ScaleTo:create(0.1, 1.0)})
    self.node:runAction(popupLayer)

    --播放音效(打开层)
    if GameManager.SOUND_SWITCH_ON then
        audio.playSound(string.format("sounds/sfx_touch_ti.%s",GameManager.POSTFIX))
    end

    --初始化界面
    self:init()

    --DataEye统计
    if USE_DATAEYE  then
        DCEvent.onEvent("lack_of_energy")
    end
end

function BuyEnergyLayer:init()
    --背景
    self.frame = display.newSprite("common_ui/common_bg.png")
        --:align(display.CENTER, display.cx, display.cy)
        :addTo(self.node)

    self.frame:setScale(0)
    local popupLayer = transition.sequence(
        {cc.ScaleTo:create(0.2, 1.1),
            cc.ScaleTo:create(0.1, 1.0)})
    self.frame:runAction(popupLayer)

    cc.ui.UILabel.new({text = "剩余人参果数量:" ,size = 20, color = display.COLOR_BLACK,font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,self.frame:getContentSize().width * 0.58,self.frame:getContentSize().height * 0.83)
        :addTo(self.frame)

    local iconframe = display.newSprite("sign/renshen.png")
        :scale(0.5)
        :align(display.CENTER,self.frame:getContentSize().width * 0.75, self.frame:getContentSize().height * 0.83)
        :addTo(self.frame)

    cc.ui.UILabel.new({text = "x" .. self.num_,size = 24, color = display.COLOR_BLACK,font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,self.frame:getContentSize().width * 0.835,self.frame:getContentSize().height * 0.83)
        :addTo(self.frame)

    local textStr
    if self.num_ == 0 then
        textStr = "消耗30蟠桃补充100体力\n\n也可以去升级体力上限"
        cc.ui.UIPushButton.new({normal = "common_ui/confirm.png",pressed = "common_ui/confirm_h.png"})
            :onButtonClicked(function()
                self:clickConfirm1_()
            end)
            :scale(0.7)
            :align(display.CENTER,self.frame:getContentSize().width * 0.32,self.frame:getContentSize().height * 0.26)
            :addTo(self.frame)
    else
        textStr = "消耗1个人参果补充100体力\n\n也可以去升级体力上限"
        cc.ui.UIPushButton.new({normal = "common_ui/confirm.png",pressed = "common_ui/confirm_h.png"})
            :onButtonClicked(function()
                self:clickConfirm2_()
            end)
            :scale(0.7)
            :align(display.CENTER,self.frame:getContentSize().width * 0.32,self.frame:getContentSize().height * 0.26)
            :addTo(self.frame)
    end

    cc.ui.UIPushButton.new({normal = "common_ui/to_upgrade.png",pressed = "common_ui/to_upgrade1.png"})
        :onButtonClicked(function()
            self:upgradeEnergyLimit_()
        end)
        :scale(0.7)
        :pos(self.frame:getContentSize().width * 0.68,self.frame:getContentSize().height * 0.26)
        :addTo(self.frame)

    cc.ui.UILabel.new({text = textStr ,size = 24, color = display.COLOR_BLACK,font = GameManager.FONTNAME_TTF})
        :align(display.CENTER,self.frame:getContentSize().width * 0.5,self.frame:getContentSize().height * 0.55)
        :addTo(self.frame)

    cc.ui.UIPushButton.new({normal = "common_ui/close.png",pressed = "common_ui/close_h.png"})
        :onButtonClicked(function()
            self:closeCallBack_()
        end)
        :scale(0.8)
        :align(display.CENTER,self.frame:getContentSize().width * 0.96,self.frame:getContentSize().height * 0.96)
        :addTo(self.frame)
end

function BuyEnergyLayer:isEnergyFull_()
    if CloudData.ENERGY == CloudData.MAX_ENERGY then
        local t = WSToast.new("体力值已满",1.0)
        self:addChild(t,100)
        return true
    else
        return false
    end
end

--蟠桃恢复
function BuyEnergyLayer:clickConfirm1_()

    if CloudData.PEACH >= 30 then
        local ac = AlertConnection.new(CONNECTION_ADD_ENERGY)
        self:addChild(ac,100,12345)

        self.scheduleResult_ = self:schedule(function()
            if not self:getChildByTag(12345) then
                self:stopAction(self.scheduleResult_)
                -- if not self:isEnergyFull_() then
                --     CloudData.PEACH = CloudData.PEACH - 30
                -- end
                CloudData.PEACH = CloudData.PEACH - 30
                --CloudData.ENERGY = CloudData.MAX_ENERGY
                CloudData.ENERGY = CloudData.ENERGY + 100
                self:closeCallBack_()
            end
        end, 0.1)
    else
        local alert = AlertLackPeachLayer.new()
        self:addChild(alert, 20)
        --[[local t = WSToast.new("蟠桃不足",1.0)
        self:addChild(t,100)--]]
    end

end

--人参果恢复
function BuyEnergyLayer:clickConfirm2_()
    local ac = AlertConnection.new(CONNECTION_ADD_ENERGY)
    self:addChild(ac,100,12345)

    self.scheduleResult_ = self:schedule(function()
        if not self:getChildByTag(12345) then
            self:stopAction(self.scheduleResult_)
            -- if not self:isEnergyFull_() then
            --     CloudData.GINSENG_FRUIT = CloudData.GINSENG_FRUIT - 1
            -- end
            --CloudData.ENERGY = CloudData.MAX_ENERGY
            CloudData.ENERGY = CloudData.ENERGY + 100
            self:closeCallBack_()
        end
    end, 0.1)
end

function BuyEnergyLayer:upgradeEnergyLimit_()
    GameManager.BUDDHA_MODEL_TABLE  = DataUtils.getBuddhaModelsTableUpgradeScene("BUDDHA")
    print("1 done")
    GameManager.MONSTER_MODEL_TABLE = DataUtils.getBuddhaModelsTableUpgradeScene("MONSTER")
    print("2 done")
    GameManager.TOWER_MODEL_TABLE   = DataUtils.getTableUpgradePropertyModel("TOWER")
    print("3 done")
    GameManager.TANG_MODEL_TABLE    = DataUtils.getTableUpgradePropertyModel("TANG")
    print("4 done")
    display.replaceScene(require("layers.UpgradeTangLayer").new(6))
end

--弹窗关闭
function BuyEnergyLayer:closeCallBack_()
    --播放音效(关闭层)
    if GameManager.SOUND_SWITCH_ON then
        audio.playSound(string.format("sounds/sfx_touch_shu.%s",GameManager.POSTFIX))
    end

    local popupLayer = transition.sequence({cc.ScaleTo:create(0,1.0),
        cc.ScaleTo:create(0.1,1.1),
        cc.ScaleTo:create(0.2,0),cc.CallFunc:create(function()
            self:removeSelf()
        end)
    })
    self.frame:runAction(popupLayer)
end

return BuyEnergyLayer