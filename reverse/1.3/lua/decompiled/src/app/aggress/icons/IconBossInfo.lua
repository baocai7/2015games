local M = {}
M = class("IconBossInfo", function()
  return display.newNode()
end)

function M:ctor(cb, param)
  self.mCallback = cb
  self.mData = param
  self:layoutUI()
end

function M:layoutUI()
  local bg = display.newScale9Sprite("aggress/img_boss_bottom.png", 0, 0, cc.size(732, 128), cc.rect(50, 50, 1, 1)):addTo(self)
  self.mCoreNode = bg
  local node = self.mCoreNode
  local model = DataUtils.getMonsterBaseInfo(self.mData.mid)
  self.mData.totalHP = model.life
  self.mData.level = model.level
  local icon = model.npcIcon
  local quality = model.quality
  local level = string.format("LV.%s  %s", checkstring(self.mData.level), checkstring(model.npcName))
  local nick = DYLang.getString("STR_FINDER", "") .. checkstring(self.mData.userNick)
  local spFrame = display.newSprite(string.format("common_ui/frame%d.png", quality)):scale(1):pos(70, 65):addTo(node)
  local spIcon = display.newSprite(icon):scale(1):pos(70, 65):addTo(node)
  local btnView = cc.ui.UIPushButton.new({
    normal = "common_ui/view_detail_n.png",
    pressed = "common_ui/view_detail_p.png"
  }):align(display.CENTER, 175, 85):onButtonClicked(handler(self, self.buttonListener)):addTo(node, 1)
  local labLevel = cc.ui.UILabel.new({
    text = level,
    size = 30,
    color = cc.c3b(80, 30, 0),
    font = GameManager.FONTNAME_TTF
  })
  labLevel:align(display.LEFT_CENTER, 230, 95):addTo(node)
  local labLevel = cc.ui.UILabel.new({
    text = nick,
    size = 26,
    color = cc.c3b(151, 105, 87),
    font = GameManager.FONTNAME_TTF
  })
  labLevel:align(display.RIGHT_CENTER, 700, 95):addTo(node)
  local prog = math.floor(self.mData.curHP / self.mData.totalHP * 100)
  if prog < 0 then
    prog = 0
  elseif 100 < prog then
    prog = 100
  end
  local progBg = display.newSprite("aggress/img_bar_01.png"):align(display.LEFT_CENTER, 140, 30):addTo(node)
  local progBar = display.newProgressTimer("aggress/img_bar_02.png", display.PROGRESS_TIMER_BAR):pos(progBg:getContentSize().width * 0.5, progBg:getContentSize().height * 0.5):addTo(progBg)
  progBar:setMidpoint(cc.p(0, 0))
  progBar:setBarChangeRate(cc.p(1, 0))
  progBar:setPercentage(prog)
  local labProg = DYLabelTTF.new({
    text = string.format("%s/%s", checkstring(self.mData.curHP), checkstring(self.mData.totalHP)),
    size = 25,
    color = cc.c3b(255, 255, 255),
    font = GameManager.FONTNAME_TTF
  })
  labProg:pos(progBg:getContentSize().width * 0.5, progBg:getContentSize().height * 0.5):addTo(progBg)
  local sprState = display.newSprite("aggress/img_boss_state.png"):align(display.RIGHT_CENTER, 725, 40):addTo(node)
  local labLeft
  if self.mData.state == "FIGHT" then
    labLeft = cc.ui.UILabel.new({
      text = "00:00",
      size = 36,
      color = cc.c3b(200, 0, 0),
      font = GameManager.FONTNAME_TTF
    })
    
    local function tFuncUpdate()
      local tLeft = 7200 - math.floor(DYUtils.currentSecond() - self.mData.meetTime / 1000)
      if tLeft < 0 then
        tLeft = 0
      end
      if 0 < tLeft then
        labLeft:performWithDelay(tFuncUpdate, 10)
      end
      labLeft:setString(string.format("%02d:%02d", math.floor(tLeft / 3600), math.floor(tLeft / 60) % 60))
    end
    
    labLeft:performWithDelay(tFuncUpdate, 0)
  elseif self.mData.state == "STRUGGLE" then
    local strState = DYLang.getString("STR_STRUGGLE", "")
    labLeft = cc.ui.UILabel.new({
      text = strState,
      size = 36,
      color = cc.c3b(80, 30, 0),
      font = GameManager.FONTNAME_TTF
    })
  elseif self.mData.state == "ESCAPE" then
    local strState = DYLang.getString("STR_ESCAPE", "")
    labLeft = cc.ui.UILabel.new({
      text = strState,
      size = 36,
      color = cc.c3b(80, 30, 0),
      font = GameManager.FONTNAME_TTF
    })
  elseif self.mData.state == "KILL" then
    local strState = DYLang.getString("STR_WIN", "")
    labLeft = cc.ui.UILabel.new({
      text = strState,
      size = 36,
      color = cc.c3b(80, 30, 0),
      font = GameManager.FONTNAME_TTF
    })
  end
  labLeft:align(display.CENTER, sprState:getContentSize().width * 0.5, sprState:getContentSize().height * 0.5):addTo(sprState)
end

function M:buttonListener(sender)
  if self.mCallback then
    self.mCallback(0, self.mData)
  end
end

return M
