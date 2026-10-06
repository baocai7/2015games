local M = {}

function M.init()
  M.IS_BTN_ENABLED = true
  M.RUNNING_LAYER = nil
  M.EVENT_LIST = {}
  M.DOUBLE_AWARD = false
  M.IGNORE_EVENT = false
  M.GAME_COMPLETE = false
end

M.FATE_CARD = {
  [1] = {
    name = "\229\129\156\230\173\162\231\137\140",
    icon = "img_card_tingzhi",
    num = 0
  },
  [2] = {
    name = "\233\129\129\229\156\176\231\137\140",
    icon = "img_card_dundi",
    num = 0
  },
  [3] = {
    name = "\231\165\158\232\161\140\231\137\140",
    icon = "img_card_shenxing",
    num = 0
  },
  [4] = {
    name = "\229\143\140\229\128\141\231\137\140",
    icon = "img_card_shuangbei",
    num = 0
  },
  [5] = {
    name = "\229\133\141\231\150\171\231\137\140",
    icon = "img_card_mianyi",
    num = 0
  },
  [6] = {
    name = "\229\143\141\232\189\172\231\137\140",
    icon = "img_card_fanzhuan",
    num = 0
  }
}
M.EVENT_STEP_OVER = "step_over"
return M
