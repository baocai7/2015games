local AlertConnection = require("app.layers.AlertConnection")
local ErrorCodeLayer = require("app.layers.ErrorCodeLayer")
local M = {}
local S_ENTRANCE_URL = {
  "http://entrance1.xxxy.dayukeji.com/Entrance/entrance/info",
  "http://entrance2.xxxy.dayukeji.com/Entrance/entrance/info"
}
local S_LOGIN_URL = ""
local S_HOTFIX_URL = ""
local S_PAYMENT_URL = ""
local S_LOGIC_URL = ""
local ERROR_CODE_TIMEOUT = 600
local MAX_RECONNECT = 5
local requestWithLoading, requestCommon, generateGetURL

function M.initEntrance(handler, t)
  local ei = 0
  t = t or {}
  t.gameId = DYUtils.gameId()
  t.gameVer = DYUtils.gameVer()
  t.channel = DYUtils.channelName()
  t.plat = device.platform
  t.mode = DYUtils.gameMode()
  
  local function tFuncListener(param)
    ei = ei + 1
    if param and param.errorCode and param.errorCode == 0 then
      S_LOGIN_URL = param.data.account
      S_HOTFIX_URL = param.data.hotfix
      S_PAYMENT_URL = param.data.payment
      DYStat.setValueStr("S_LOGIN_URL", S_LOGIN_URL)
      DYStat.setValueStr("S_HOTFIX_URL", S_HOTFIX_URL)
      DYStat.setValueStr("S_PAYMENT_URL", S_PAYMENT_URL)
      if handler then
        handler(param)
      end
    elseif ei <= #S_ENTRANCE_URL then
      local serverUrl = S_ENTRANCE_URL[ei]
      requestCommon(tFuncListener, t, serverUrl)
    else
      S_LOGIN_URL = DYStat.getValueStr("S_LOGIN_URL", S_LOGIN_URL)
      S_HOTFIX_URL = DYStat.getValueStr("S_HOTFIX_URL", S_HOTFIX_URL)
      S_PAYMENT_URL = DYStat.getValueStr("S_PAYMENT_URL", S_PAYMENT_URL)
      if handler then
        handler(param)
      end
    end
  end
  
  tFuncListener()
end

function M.setLogicURL(ip, port, base)
  local baseLen = string.len(base)
  if string.byte(base, baseLen) == string.byte("/", 1) then
    base = string.sub(base, 1, baseLen - 1)
  end
  S_LOGIC_URL = string.format("http://%s:%s/%s", checkstring(ip), checkstring(port), checkstring(base))
  DDLOG(S_LOGIC_URL)
end

function M.getLogicURL()
  return S_LOGIC_URL
end

function M.getLoginURL()
  return S_LOGIN_URL
end

function M.getHotfixURL()
  return S_HOTFIX_URL
end

function M.getPaymentURL()
  return S_PAYMENT_URL
end

function M.requestDemo(handler, t)
  local serverUrl = DYHttpMgr.getServiceURL() .. "/register"
  requestWithLoading(handler, t, serverUrl)
end

function M.checkUpdateInfo(handler, t)
  t = t or {}
  t.gameId = DYUtils.gameId()
  t.gameVer = DYUtils.gameVer()
  t.gameOrigVer = DYUtils.gameOrigVer()
  t.channel = DYUtils.channelName()
  t.plat = device.platform
  t.mode = DYUtils.gameMode()
  local serverUrl = S_HOTFIX_URL .. "/checkupdate"
  requestWithLoading(handler, t, serverUrl)
end

function M.loginKugou(handler, t)
  local serverUrl = S_LOGIC_URL .. "/user/kugoulogin"
  requestWithLoading(handler, t, serverUrl)
end

function M.loginQQ(handler, t)
  local serverUrl = S_LOGIC_URL .. "/user/qqlogin"
  requestWithLoading(handler, t, serverUrl)
end

function M.loginWeChat(handler, t)
  local serverUrl = S_LOGIC_URL .. "/user/wechatlogin"
  requestWithLoading(handler, t, serverUrl)
end

function M.loginUC(handler, t)
  local serverUrl = S_LOGIC_URL .. "/user/uclogin"
  requestWithLoading(handler, t, serverUrl)
end

function M.login(handler, t)
  local serverUrl = S_LOGIC_URL .. "/user/login"
  requestWithLoading(handler, t, serverUrl)
end

function M.requestLogin(handler, t)
  local serverUrl = S_LOGIN_URL .. "/account/dylogin"
  requestWithLoading(handler, t, serverUrl)
end

function M.quickRegister(handler, t)
  local serverUrl = S_LOGIN_URL .. "/account/quickregister"
  requestWithLoading(handler, t, serverUrl)
end

function M.getPlayerInfo(handler, t)
  local serverUrl = S_LOGIC_URL .. "/user/userinit"
  requestWithLoading(handler, t, serverUrl)
end

function M.testWizard(handler, t)
  local serverUrl = S_LOGIC_URL .. "/wizard/magic"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.accountBinding(handler, t)
  local serverUrl = S_LOGIN_URL .. "/account/accountbinding"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.accountChange(handler, t)
  local serverUrl = S_LOGIN_URL .. "/account/changeaccount"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.forgetPassword(handler, t)
  local serverUrl = S_LOGIN_URL .. "/account/gettelephone"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.sendVerification(handler, t)
  local serverUrl = S_LOGIN_URL .. "/account/getidentifyCode"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.updatePassword(handler, t)
  local serverUrl = S_LOGIN_URL .. "/account/resetpassword"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.accountBindPhone(handler, t)
  local serverUrl = S_LOGIN_URL .. "/account/bindtelephone"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.getPhoneAward(handler, t)
  local serverUrl = S_LOGIC_URL .. "/user/drawtelephoneaward"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.openningComic(handler, t)
  local serverUrl = S_LOGIC_URL .. "/user/guide"
  requestWithLoading(handler, t, serverUrl)
end

function M.chapterInfoNew(handler, t)
  local serverUrl = S_LOGIC_URL .. "/user/chapterinfo"
  requestWithLoading(handler, t, serverUrl)
end

function M.updateCommonTeam(handler, t)
  local serverUrl = S_LOGIC_URL .. "/user/updatecommonteam"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.unlockTeamNum(handler, t)
  local serverUrl = S_LOGIC_URL .. "/user/unlockmembernum"
  requestWithLoading(handler, t, serverUrl)
end

function M.npcUpgrade(handler, t)
  local serverUrl = S_LOGIC_URL .. "/buddha/upgrade"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.npcOnekeyUpgrade(handler, t)
  local serverUrl = S_LOGIC_URL .. "/buddha/upgradecontinue"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.npcBreak(handler, t)
  local serverUrl = S_LOGIC_URL .. "/buddha/break"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.npcCompose(handler, t)
  local serverUrl = S_LOGIC_URL .. "/buddha/compose"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.npcAddStar(handler, t)
  local serverUrl = S_LOGIC_URL .. "/buddha/upstar"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.upgradeBuddhaSkill(handler, t)
  local serverUrl = S_LOGIC_URL .. "/buddha/upskill"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.skillOnekeyUpgrade(handler, t)
  local serverUrl = S_LOGIC_URL .. "/buddha/upskillcontinue"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.summonInit(handler, t)
  local serverUrl = S_LOGIC_URL .. "/summon/init"
  requestWithLoading(handler, t, serverUrl)
end

function M.normalSingle(handler, t)
  local serverUrl = S_LOGIC_URL .. "/summon/commonsingle"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.normalContinue(handler, t)
  local serverUrl = S_LOGIC_URL .. "/summon/commoncontinue"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.advanceSingle(handler, t)
  local serverUrl = S_LOGIC_URL .. "/summon/advancesingle"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.advanceContinue(handler, t)
  local serverUrl = S_LOGIC_URL .. "/summon/advancecontinue"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.vipSingle(handler, t)
  local serverUrl = S_LOGIC_URL .. "/summon/hongmengsingle"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.vipContinue(handler, t)
  local serverUrl = S_LOGIC_URL .. "/summon/hongmengcontinue"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.shopInit(handler, t)
  local serverUrl = S_LOGIC_URL .. "/shop/shopinit"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.normalShopBuy(handler, t)
  local serverUrl = S_LOGIC_URL .. "/shop/commonbuy"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.featShopBuy(handler, t)
  local serverUrl = S_LOGIC_URL .. "/shop/medalbuy"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.purgatoryShopBuy(handler, t)
  local serverUrl = S_LOGIC_URL .. "/shop/purgatorybuy"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.mysteryShopBuy(handler, t)
  local serverUrl = S_LOGIC_URL .. "/shop/mysterybuy"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.featShopRefresh(handler, t)
  local serverUrl = S_LOGIC_URL .. "/shop/medalrefresh"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.purgatoryShopRefresh(handler, t)
  local serverUrl = S_LOGIC_URL .. "/shop/purgatoryrefresh"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.mysteryShopRefresh(handler, t)
  local serverUrl = S_LOGIC_URL .. "/shop/mysteryrefresh"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.pvpOlShopInit(handler, t)
  local serverUrl = S_LOGIC_URL .. "/shop/pvpolshopinit"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.pvpOlShopBuy(handler, t)
  local serverUrl = S_LOGIC_URL .. "/shop/pvpolbuy"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.pvpOlShopRefresh(handler, t)
  local serverUrl = S_LOGIC_URL .. "/shop/pvpolrefresh"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.getMailReward(handler, t)
  local serverUrl = S_LOGIC_URL .. "/mail/draw"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.getAllMailReward(handler, t)
  local serverUrl = S_LOGIC_URL .. "/mail/drawall"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.noticeInit(handler, t)
  local serverUrl = S_LOGIC_URL .. "/notice/list"
  requestWithLoading(handler, t, serverUrl)
end

function M.signInit(handler, t)
  local serverUrl = S_LOGIC_URL .. "/sign/init"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.toSign(handler, t)
  local serverUrl = S_LOGIC_URL .. "/sign/sign"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.spinInit(handler, t)
  local serverUrl = S_LOGIC_URL .. "/lottery/init"
  requestWithLoading(handler, t, serverUrl)
end

function M.awardLog(handler, t)
  local serverUrl = S_LOGIC_URL .. "/lottery/awardlog"
  requestWithLoading(handler, t, serverUrl)
end

function M.drawLottery(handler, t)
  local serverUrl = S_LOGIC_URL .. "/lottery/draw"
  requestWithLoading(handler, t, serverUrl)
end

function M.getTaskBox(handler, t)
  local serverUrl = S_LOGIC_URL .. "/daily/drawtaskbox"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.getDailyTaskAward(handler, t)
  local serverUrl = S_LOGIC_URL .. "/daily/taskdraw"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.getAchieveAward(handler, t)
  local serverUrl = S_LOGIC_URL .. "/daily/achievementdraw"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.dailyShare(handler, t)
  local serverUrl = S_LOGIC_URL .. "/daily/share"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.taskFinish(handler, t)
  local serverUrl = S_LOGIC_URL .. "/daily/taskfinish"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.initPVPInfo(handler, t)
  local serverUrl = S_LOGIC_URL .. "/pvp/initinfo"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.refreshPVPMatchTable(handler, t)
  local serverUrl = S_LOGIC_URL .. "/pvp/oppoents"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.updatePVPGuardTeam(handler, t)
  local serverUrl = S_LOGIC_URL .. "/pvp/setguardteam"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.costPVPRaceNum(handler, t)
  local serverUrl = S_LOGIC_URL .. "/pvp/costpvpracenum"
  requestWithLoading(handler, t, serverUrl)
end

function M.pvpRaceReward(handler, t)
  local serverUrl = S_LOGIC_URL .. "/pvp/race"
  requestWithLoading(handler, t, serverUrl)
end

function M.getPVPChart(handler, t)
  local serverUrl = S_LOGIC_URL .. "/pvp/ranklist"
  requestWithLoading(handler, t, serverUrl)
end

function M.pvpRevenge(handler, t)
  local serverUrl = S_LOGIC_URL .. "/pvp/oppoentteam"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.updatePVPAttackTeam(handler, t)
  local serverUrl = S_LOGIC_URL .. "/pvp/setattackteam"
  requestWithLoading(handler, t, serverUrl)
end

function M.getPVPRaceLog(handler, t)
  local serverUrl = S_LOGIC_URL .. "/pvp/racelogs"
  requestWithLoading(handler, t, serverUrl)
end

function M.exchangePvpShop(handler, t)
  local serverUrl = S_LOGIC_URL .. "/pvp/buy"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.pvpShopInit(handler, t)
  local serverUrl = S_LOGIC_URL .. "/pvp/goodslist"
  requestWithLoading(handler, t, serverUrl)
end

function M.changeNickName(handler, t)
  local serverUrl = S_LOGIC_URL .. "/user/updatenick"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.changeUserIcon(handler, t)
  local serverUrl = S_LOGIC_URL .. "/user/changeicon"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.getChartInfo(handler, t)
  local serverUrl = S_LOGIC_URL .. "/stage/towerrank"
  requestWithLoading(handler, t, serverUrl)
end

function M.dungeonInit(handler, t)
  local serverUrl = S_LOGIC_URL .. "/pve/dungeoninit"
  requestWithLoading(handler, t, serverUrl)
end

function M.getChapterBox(handler, t)
  local serverUrl = S_LOGIC_URL .. "/pve/maindraw"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.sweepInMain(handler, t)
  local serverUrl = S_LOGIC_URL .. "/pve/mainsweep"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.sweep5InMain(handler, t)
  local serverUrl = S_LOGIC_URL .. "/pve/mainsweep5"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.mainWarResult(handler, t)
  local serverUrl = S_LOGIC_URL .. "/pve/mainfightresult"
  requestWithLoading(handler, t, serverUrl)
end

function M.mainReset(handler, t)
  local serverUrl = S_LOGIC_URL .. "/pve/mainreset"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.getEliteBox(handler, t)
  local serverUrl = S_LOGIC_URL .. "/pve/elitedraw"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.sweepInElite(handler, t)
  local serverUrl = S_LOGIC_URL .. "/pve/elitesweep"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.sweep5InElite(handler, t)
  local serverUrl = S_LOGIC_URL .. "/pve/elitesweep5"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.eliteWarResult(handler, t)
  local serverUrl = S_LOGIC_URL .. "/pve/elitefightresult"
  requestWithLoading(handler, t, serverUrl)
end

function M.initPurgatory(handler, t)
  local serverUrl = S_LOGIC_URL .. "/pve/purgatoryinit"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.getPurgatoryBox(handler, t)
  local serverUrl = S_LOGIC_URL .. "/pve/purgatorydraw"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.resetPurgatoryStage(handler, t)
  local serverUrl = S_LOGIC_URL .. "/pve/purgatoryreset"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.purgatoryDownstairs(handler, t)
  local serverUrl = S_LOGIC_URL .. "/pve/purgatorydownstairs"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.buddhaRecovery(handler, t)
  local serverUrl = S_LOGIC_URL .. "/pve/buddharecover"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.updatePurgatoryTeam(handler, t)
  local serverUrl = S_LOGIC_URL .. "/user/updatepurgatoryteam"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.purgatoryWarResult(handler, t)
  local serverUrl = S_LOGIC_URL .. "/pve/purgatoryfightresult"
  requestWithLoading(handler, t, serverUrl)
end

function M.towerReset(handler, t)
  local serverUrl = S_LOGIC_URL .. "/pve/towerreset"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.towerSweep(handler, t)
  local serverUrl = S_LOGIC_URL .. "/pve/towersweep"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.towerWarResult(handler, t)
  local serverUrl = S_LOGIC_URL .. "/pve/towerfightresult"
  requestWithLoading(handler, t, serverUrl)
end

function M.travelInit(handler, t)
  local serverUrl = S_LOGIC_URL .. "/pve/travelinit"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.travelWarResult(handler, t)
  local serverUrl = S_LOGIC_URL .. "/pve/travelfightresult"
  requestWithLoading(handler, t, serverUrl)
end

function M.getFightData(handler, t)
  local serverUrl = S_LOGIC_URL .. "/user/getfightdata"
  requestWithLoading(handler, t, serverUrl)
end

function M.initGinsen(handler, t)
  local serverUrl = S_LOGIC_URL .. "/user/initginsen"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.useGinsen(handler, t)
  local serverUrl = S_LOGIC_URL .. "/user/eatginsen"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.buyGinsen(handler, t)
  local serverUrl = S_LOGIC_URL .. "/user/buyginsen"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.codeExchange(handler, t)
  local serverUrl = S_LOGIC_URL .. "/gift/draw"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.paymentItemState(handler, t)
  local serverUrl = S_LOGIC_URL .. "/order/specialcardstatus"
  requestWithLoading(handler, t, serverUrl)
end

function M.getProductOrder(handler, t)
  local serverUrl = S_LOGIC_URL .. "/payment/addorder"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.paymentSuccessReport(handler, t)
  local serverUrl = S_LOGIC_URL .. "/payment/check"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.getPaymentList(handler, t)
  local serverUrl = S_LOGIC_URL .. "/payment/list"
  requestWithLoading(handler, t, serverUrl)
end

function M.buyVipGift(handler, t)
  local serverUrl = S_LOGIC_URL .. "/vip/buypackage"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.firstPayAward(handler, t)
  local serverUrl = S_LOGIC_URL .. "/payment/firstpaydraw"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.getRechargeReward(handler, t)
  local serverUrl = S_LOGIC_URL .. "/payment/payawarddraw"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.initPackageInfo(handler, t)
  local serverUrl = S_LOGIC_URL .. "/package/listdata"
  requestWithLoading(handler, t, serverUrl)
end

function M.salePackageItem(handler, t)
  local serverUrl = S_LOGIC_URL .. "/package/sell"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.usePackageItem(handler, t)
  local serverUrl = S_LOGIC_URL .. "/package/use"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.countPackageItem(handler, t)
  local serverUrl = S_LOGIC_URL .. "/package/thingcount"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.exchangeEssence(handler, t)
  local serverUrl = S_LOGIC_URL .. "/user/mining"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.cimeliaInit(handler, t)
  local serverUrl = S_LOGIC_URL .. "/cimelia/init"
  requestWithLoading(handler, t, serverUrl)
end

function M.cimeliaEquip(handler, t)
  local serverUrl = S_LOGIC_URL .. "/cimelia/arm"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.cimeliaUpgrade(handler, t)
  local serverUrl = S_LOGIC_URL .. "/cimelia/upgrade"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.cimeliaSynthesize(handler, t)
  local serverUrl = S_LOGIC_URL .. "/cimelia/compose"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.cimeliaSynthesize10(handler, t)
  local serverUrl = S_LOGIC_URL .. "/cimelia/compose10"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.cimeliaGuidecompose(handler, t)
  local serverUrl = S_LOGIC_URL .. "/cimelia/guidecompose"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.cimeliaRecipe(handler, t)
  local serverUrl = S_LOGIC_URL .. "/cimelia/listrecipe"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.cimeliaRecast(handler, t)
  local serverUrl = S_LOGIC_URL .. "/cimelia/openlight"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.cimeliaRecastReplace(handler, t)
  local serverUrl = S_LOGIC_URL .. "/cimelia/openlightreplace"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.cimeliaGradeUp(handler, t)
  local serverUrl = S_LOGIC_URL .. "/cimelia/upaptitude"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.activityList(handler, t)
  local serverUrl = S_LOGIC_URL .. "/activity/list"
  requestWithLoading(handler, t, serverUrl)
end

function M.activityVIPList(handler, t)
  local serverUrl = S_LOGIC_URL .. "/activity/listvip"
  requestWithLoading(handler, t, serverUrl)
end

function M.activityBuddha(handler, t)
  local serverUrl = S_LOGIC_URL .. "/activity/listbuddha"
  requestWithLoading(handler, t, serverUrl)
end

function M.getTaskActivityAward(handler, t)
  local serverUrl = S_LOGIC_URL .. "/activity/draw"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.getBuyActivityAward(handler, t)
  local serverUrl = S_LOGIC_URL .. "/activity/buy"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.getWeekCardAward(handler, t)
  local serverUrl = S_LOGIC_URL .. "/activity/drawweekreward"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.getMonthCardAward(handler, t)
  local serverUrl = S_LOGIC_URL .. "/activity/drawmonthreward"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.getWelfareAward(handler, t)
  local serverUrl = S_LOGIC_URL .. "/activity/drawwelfarereward"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.getDailyFood(handler, t)
  local serverUrl = S_LOGIC_URL .. "/activity/drawrice"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.sevenActivityInit(handler, t)
  local serverUrl = S_LOGIC_URL .. "/activity/seveninit"
  requestWithLoading(handler, t, serverUrl)
end

function M.getSevenActivityAward(handler, t)
  local serverUrl = S_LOGIC_URL .. "/activity/sevendraw"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.getSevenRankingAward(handler, t)
  local serverUrl = S_LOGIC_URL .. "/activity/sevenrankinit"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.buddhaActivityInit(handler, t)
  local serverUrl = S_LOGIC_URL .. "/askgod/init"
  requestWithLoading(handler, t, serverUrl)
end

function M.buddhaSummon(handler, t)
  local serverUrl = S_LOGIC_URL .. "/askgod/ask"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.buddhaSummon10(handler, t)
  local serverUrl = S_LOGIC_URL .. "/askgod/ask10"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.chessInit(handler, t)
  local serverUrl = S_LOGIC_URL .. "/flightchess/init"
  requestWithLoading(handler, t, serverUrl)
end

function M.shakeDice1(handler, t)
  local serverUrl = S_LOGIC_URL .. "/flightchess/shake"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.shakeDice5(handler, t)
  local serverUrl = S_LOGIC_URL .. "/flightchess/shakecontinue"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.useFateCard(handler, t)
  local serverUrl = S_LOGIC_URL .. "/flightchess/usecard"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.dropItems(handler, t)
  local serverUrl = S_LOGIC_URL .. "/flightchess/dropitem"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.dropFateCard(handler, t)
  local serverUrl = S_LOGIC_URL .. "/flightchess/dropcard"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.updateCurrPos(handler, t)
  local serverUrl = S_LOGIC_URL .. "/flightchess/saveseat"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.gameComplete(handler, t)
  local serverUrl = S_LOGIC_URL .. "/flightchess/bingo"
  requestWithLoading(handler, t, serverUrl)
end

function M.setForbiddenAdd(handler, t)
  local serverUrl = S_LOGIC_URL .. "/friend/forbiddenfriend"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.setForbiddenPk(handler, t)
  local serverUrl = S_LOGIC_URL .. "/friend/forbiddenchallenge"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.sendFriendEnergy(handler, t)
  local serverUrl = S_LOGIC_URL .. "/friend/sendenegy"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.getFriendEnergy(handler, t)
  local serverUrl = S_LOGIC_URL .. "/friend/drawenegy"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.updateGuideStep(handler, t)
  local serverUrl = S_LOGIC_URL .. "/user/updateguide"
  requestWithLoading(handler, t, serverUrl)
end

function M.getGuideStep(handler, t)
  local serverUrl = S_LOGIC_URL .. "/user/getguide"
  requestWithLoading(handler, t, serverUrl)
end

function M.initRedPacket(handler, t)
  local serverUrl = S_LOGIC_URL .. "/red/init"
  requestWithLoading(handler, t, serverUrl)
end

function M.openSingle(handler, t)
  local serverUrl = S_LOGIC_URL .. "/red/draw"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.openMutiple(handler, t)
  local serverUrl = S_LOGIC_URL .. "/red/drawcontinue"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.updatePacketMsg(handler, t)
  local serverUrl = S_LOGIC_URL .. "/red/redshow"
  requestWithLoading(handler, t, serverUrl)
end

function M.initNewYearActivity(handler, t)
  local serverUrl = S_LOGIC_URL .. "/newyear/init"
  requestWithLoading(handler, t, serverUrl)
end

function M.getLoginReward(handler, t)
  local serverUrl = S_LOGIC_URL .. "/newyear/dlhldraw"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.getWishReward(handler, t)
  local serverUrl = S_LOGIC_URL .. "/newyear/rszfdraw"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.getGiftReward(handler, t)
  local serverUrl = S_LOGIC_URL .. "/newyear/cssldraw"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.collectionInit(handler, t)
  local serverUrl = S_LOGIC_URL .. "/jizi/init"
  requestWithLoading(handler, t, serverUrl)
end

function M.collectionRefresh(handler, t)
  local serverUrl = S_LOGIC_URL .. "/jizi/refresh"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.collectionExchange(handler, t)
  local serverUrl = S_LOGIC_URL .. "/jizi/exchange"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.getUserThingCount(handler, t)
  local serverUrl = S_LOGIC_URL .. "/user/thingcount"
  requestWithLoading(handler, t, serverUrl)
end

function M.requestPlaceActiveOpen(handler, t)
  local serverUrl = S_LOGIC_URL .. "/nianshou/checkcon"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.requestPlaceActiveInit(handler, t)
  local serverUrl = S_LOGIC_URL .. "/nianshou/init"
  requestWithLoading(handler, t, serverUrl)
end

function M.requestPlaceActiveInspire(handler, t)
  local serverUrl = S_LOGIC_URL .. "/nianshou/inspire"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.requestPlaceActiveBomb(handler, t)
  local serverUrl = S_LOGIC_URL .. "/nianshou/marroon"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.requestPlaceActiveDraw(handler, t)
  local serverUrl = S_LOGIC_URL .. "/nianshou/draw"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.requestPlaceActiveRank(handler, t)
  local serverUrl = S_LOGIC_URL .. "/nianshou/currentrank"
  requestWithLoading(handler, t, serverUrl)
end

function M.requestPlaceActiveLastRank(handler, t)
  local serverUrl = S_LOGIC_URL .. "/nianshou/lastrank"
  requestWithLoading(handler, t, serverUrl)
end

function M.requestTotalHurt(handler, t)
  local serverUrl = S_LOGIC_URL .. "/nianshou/totalhurt"
  requestWithLoading(handler, t, serverUrl)
end

function M.requestRankFresh(handler, t)
  local serverUrl = S_LOGIC_URL .. "/nianshou/rankfresh"
  requestWithLoading(handler, t, serverUrl)
end

function M.requestUpdateFullPower(handler, t)
  local serverUrl = S_LOGIC_URL .. "/user/updatefullpower"
  requestWithLoading(handler, t, serverUrl)
end

function M.getRankingList(handler, t)
  local serverUrl = S_LOGIC_URL .. "/rank/rank"
  requestWithLoading(handler, t, serverUrl)
end

function M.getEquipmentInfo(handler, t)
  local serverUrl = S_LOGIC_URL .. "/equipment/equipmentinfo"
  requestWithLoading(handler, t, serverUrl)
end

function M.singleLearn(handler, t)
  local serverUrl = S_LOGIC_URL .. "/buddha/apperceptionarousalskill"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.mutipleLearn(handler, t)
  local serverUrl = S_LOGIC_URL .. "/buddha/apperceptionarousalskill10"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.awakeSkillResolve(handler, t)
  local serverUrl = S_LOGIC_URL .. "/buddha/meltarousalskill"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.awakeSkillEquip(handler, t)
  local serverUrl = S_LOGIC_URL .. "/buddha/equiparousalskill"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.awakeSkillReplace(handler, t)
  local serverUrl = S_LOGIC_URL .. "/buddha/replacearousalskill"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.awakeSkillUpgrade(handler, t)
  local serverUrl = S_LOGIC_URL .. "/buddha/uparousalskill"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.awakeSkillUpgradeOnekey(handler, t)
  local serverUrl = S_LOGIC_URL .. "/buddha/uparousalskillcontinue"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.useSkillBook(handler, t)
  local serverUrl = S_LOGIC_URL .. "/buddha/usebook"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.babelInit(handler, t)
  local serverUrl = S_LOGIC_URL .. "/babel/init"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.babelResult(handler, t)
  local serverUrl = S_LOGIC_URL .. "/babel/bossfightresult"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.babelRank(handler, t)
  local serverUrl = S_LOGIC_URL .. "/babel/ranklist"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.babelReward(handler, t)
  local serverUrl = S_LOGIC_URL .. "/babel/scanowninfo"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.getBabelReward(handler, t)
  local serverUrl = S_LOGIC_URL .. "/babel/drawincome"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.babelSeatDetail(handler, t)
  local serverUrl = S_LOGIC_URL .. "/babel/scanopponentinfo"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.refreshSeat(handler, t)
  local serverUrl = S_LOGIC_URL .. "/babel/refreshseat"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.babelMeditation(handler, t)
  local serverUrl = S_LOGIC_URL .. "/babel/occupyseat"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.babelPeachMeditation(handler, t)
  local serverUrl = S_LOGIC_URL .. "/babel/accelerateincome"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.babelAvoidWar(handler, t)
  local serverUrl = S_LOGIC_URL .. "/babel/usedefence"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.babelToFight(handler, t)
  local serverUrl = S_LOGIC_URL .. "/babel/checkplayer"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.babelFightResult(handler, t)
  local serverUrl = S_LOGIC_URL .. "/babel/plunderfightresult"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.babelFightLog(handler, t)
  local serverUrl = S_LOGIC_URL .. "/babel/plunderlog"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.babelSeatIncome(handler, t)
  local serverUrl = S_LOGIC_URL .. "/babel/scanseatincome"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.dungeonNew(handler, t)
  local serverUrl = S_LOGIC_URL .. "/pve/experienceredpoint"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.getScrollCaptionList(handler, t)
  local serverUrl = S_LOGIC_URL .. "/notice/listroll"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.investAward(handler, t)
  local serverUrl = S_LOGIC_URL .. "/user/invest"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.aggressInit(handler, t)
  local serverUrl = S_LOGIC_URL .. "/aggress/init"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.aggressFightReady(handler, t)
  local serverUrl = S_LOGIC_URL .. "/aggress/fightready"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.aggressFightResult(handler, t)
  local serverUrl = S_LOGIC_URL .. "/aggress/fightresult"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.aggressReward(handler, t)
  local serverUrl = S_LOGIC_URL .. "/aggress/draw"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.aggressRemove(handler, t)
  local serverUrl = S_LOGIC_URL .. "/aggress/lookaggress"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.aggressFriendInvited(handler, t)
  local serverUrl = S_LOGIC_URL .. "/aggress/friendinvited"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.aggressInviteFriend(handler, t)
  local serverUrl = S_LOGIC_URL .. "/aggress/invitefriend"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.patrolInit(handler, t)
  local serverUrl = S_LOGIC_URL .. "/patrol/init"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.changeRentId(handler, t)
  local serverUrl = S_LOGIC_URL .. "/patrol/rentbuddha"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.patrolGoalBox(handler, t)
  local serverUrl = S_LOGIC_URL .. "/patrol/drawgoalaward"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.patrolTaskInit(handler, t)
  local serverUrl = S_LOGIC_URL .. "/patrol/refreshtask"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.patrolTaskGetAward(handler, t)
  local serverUrl = S_LOGIC_URL .. "/patrol/drawtaskaward"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.patrolTaskGiveup(handler, t)
  local serverUrl = S_LOGIC_URL .. "/patrol/giveuppatrol"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.patrolTaskStart(handler, t)
  local serverUrl = S_LOGIC_URL .. "/patrol/beginpatrol"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.patrolNew(handler, t)
  local serverUrl = S_LOGIC_URL .. "/patrol/redpoint"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.equipmentInit(handler, t)
  local serverUrl = S_LOGIC_URL .. "/equipment/init"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.equipmentOn(handler, t)
  local serverUrl = S_LOGIC_URL .. "/equipment/dress"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.equipmentDown(handler, t)
  local serverUrl = S_LOGIC_URL .. "/equipment/undress"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.equipmentUpgrade(handler, t)
  local serverUrl = S_LOGIC_URL .. "/equipment/upgrade"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.equipmentUpstar(handler, t)
  local serverUrl = S_LOGIC_URL .. "/equipment/melt"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.equipmentUpstarReplace(handler, t)
  local serverUrl = S_LOGIC_URL .. "/equipment/meltreplace"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.equipmentQuenching(handler, t)
  local serverUrl = S_LOGIC_URL .. "/equipment/quenching"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.equipmentQuenchingReplace(handler, t)
  local serverUrl = S_LOGIC_URL .. "/equipment/quenchingreplace"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.equipmentResolvePreview(handler, t)
  local serverUrl = S_LOGIC_URL .. "/equipment/resolvepreview"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.equipmentResolve(handler, t)
  local serverUrl = S_LOGIC_URL .. "/equipment/resolve"
  requestWithLoading(handler, t, serverUrl, true)
end

function M.reportError(label, log)
  local params = {}
  params.uid = CloudData.UID or ""
  params.regionId = CloudData.USER_SERVER_ID or ""
  params.game = DYUtils.gameId()
  params.channel = DYUtils.channelName()
  params.mode = DYUtils.gameMode()
  params.label = label
  params.logData = log
  local serverUrl = "http://120.132.92.95:10101/WebRoot/log/xxxycrashlog"
  requestCommon(nil, params, serverUrl, "GET")
end

function M.checkLoginPoint(tag, forNew)
  forNew = forNew or false
  local bFlag = true
  if forNew then
    bFlag = DYStat.getValueStr(DY_KEY.kUserName, "") == ""
  end
  if not bFlag then
    return
  end
  local curSec = DYUtils.currentSecond()
  if tag == "1_before_entrance" then
    M.S_LOGIN_BEGIN = curSec
  end
  DYAnalyze.event.onEventBeforeLogin("checkpoint_login", {checkpoint_v170321 = tag}, curSec - M.S_LOGIN_BEGIN)
  local serverUrl = "http://tool.dayukeji.com/gsjb/index/insertData"
  local t = {}
  t.gameId = DYUtils.gameId()
  t.event = "checkpoint_login"
  t.label = tag
  t.uid = DYAnalyze.agent.getUID()
  t.channel = DYUtils.channelName()
  t.plat = device.platform
  t.uname = DYStat.getValueStr(DY_KEY.kUserName, "")
  if tag == "4_platform_login_failed" then
    local subChannel = DYUtils.subChannelName()
    DYAnalyze.event.onEventBeforeLogin("platform_login_failed", {channel = subChannel}, curSec - M.S_LOGIN_BEGIN)
    t.subChannel = subChannel
  end
  requestCommon(nil, t, serverUrl)
end

function requestWithLoading(handler, t, url, isNeedErrMsg)
  local layer = AlertConnection.new()
  local scene = display.getRunningScene()
  scene:addChild(layer, 500)
  layer.root = scene
  
  local function tFuncHandler(param)
    if layer.root == display.getRunningScene() then
      layer:removeSelf()
      layer = nil
    end
    local errCode = param.errorCode
    local errMsg = param.errorMsg or "UNKNOWN"
    if tonumber(errCode) == 8 then
      local pLayer = ErrorCodeLayer.new(errCode, errMsg)
      display.getRunningScene():addChild(pLayer, 600)
      return
    end
    if tonumber(errCode) == 1 then
      local function tFunc()
        SocketMgr:logout()
        
        DYSoundMgr.stopMusic()
        DYUtils.restartGame()
      end
      
      local pLayer = ErrorCodeLayer.new(errCode, errMsg, tFunc)
      display.getRunningScene():addChild(pLayer, 600)
      return
    end
    if 254 == tonumber(errCode) then
      local toast = WSToast.new(errMsg)
      display.getRunningScene():addChild(toast, 600)
      return
    end
    if 0 < errCode and not isNeedErrMsg then
      local pLayer = ErrorCodeLayer.new(errCode)
      display.getRunningScene():addChild(pLayer, 600)
      return
    end
    if handler then
      handler(param)
    end
  end
  
  local params = t or {}
  if not params.token then
    params.token = CloudData.TOKEN or ""
  end
  if not params.sign then
    params.sign = CloudData.SIGN or ""
  end
  params.uid = CloudData.UID or ""
  params.regionId = CloudData.USER_SERVER_ID or ""
  params.game = DYUtils.gameId()
  params.channel = DYUtils.channelName()
  params.mode = DYUtils.gameMode()
  requestCommon(tFuncHandler, params, url)
end

function requestCommon(handler_, params_, url_, method)
  local params = params_ or {}
  local request
  method = method or "GET"
  
  local function onRequestFinished(event)
    local en = event.name or "failed"
    if en == "progress" then
      return
    end
    if en == "failed" then
      if params.repeatForError <= MAX_RECONNECT then
        params.repeatForError = params.repeatForError + 1
        
        local function tFuncRepeat()
          request = network.createHTTPRequest(onRequestFinished, url_ .. "&repeatCount=" .. params.repeatForError, "GET")
          request:start()
        end
        
        DYUtils.schedule(tFuncRepeat, 4, 1)
        return
      end
      if handler_ then
        handler_({errorCode = ERROR_CODE_TIMEOUT})
      end
      return
    end
    local request = event.request
    local code = request:getResponseStatusCode()
    local ret = {}
    if code ~= 200 then
      ret.errorCode = code
    else
      local response = request:getResponseString()
      ret = json.decode(response) or {}
      ret.errorCode = ret.errorCode or 0
    end
    if handler_ then
      handler_(ret)
    end
  end
  
  if string.upper(tostring(method)) == "POST" then
    request = network.createHTTPRequest(onRequestFinished, url_, method)
    
    local function tFuncAddParam(v, k)
      request:addPOSTValue(k, v)
    end
    
    table.walk(params, tFuncAddParam)
  else
    url_ = generateGetURL(url_, params)
    request = network.createHTTPRequest(onRequestFinished, url_, method)
  end
  request:setAcceptEncoding(cc.kCCHTTPRequestAcceptEncodingGzip)
  params.repeatForError = 1
  request:start()
end

function generateGetURL(url, t)
  local postStr = ""
  local nCount = 0
  local param = t or {}
  
  local function tFuncAddParam(v, k)
    if nCount ~= 0 then
      postStr = postStr .. "&"
    end
    postStr = postStr .. string.format("%s=%s", tostring(k), string.urlencode(checkstring(v)))
    nCount = nCount + 1
  end
  
  table.walk(param, tFuncAddParam)
  postStr = string.format("%s?%s", url, postStr)
  return postStr
end

return M
