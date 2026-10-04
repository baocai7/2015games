
local StageModel = import("models.StageModel")

-- 缓存findIndexOfValueFromRow结果 【第一次读取时存储】
--读第1行，获得各属性所在的列index
local _stageIdColumn = nil
local _energyCostColumn = nil
local _expAwardColumn = nil
--local _treasurePieceIdColumn = nil
local _distanceColumn = nil
local _monsterPieceIdColumn = nil
local _maxRollTimesColumn = nil
local _probabilityColumn = nil
local _advancedPieceIdColumn = nil
local _advancedMaxRollTimesColumn = nil
local _advancedProbabilityColumn = nil
local _isGrooveModeColumn = nil
local _grooveModeIntervalColumn = nil

function DataUtils.getStageModel( stageId )

    local stageInfo = DataRetainer.STAGE_INFO

    --读第1行，获得各属性所在的列index
    _stageIdColumn = _stageIdColumn or stageInfo:findIndexOfValueFromRow(1,"stageId")
    _energyCostColumn = _energyCostColumn or stageInfo:findIndexOfValueFromRow(1,"energyCost")
    _expAwardColumn = _expAwardColumn or stageInfo:findIndexOfValueFromRow(1,"expAward")
    -- _treasurePieceIdColumn = stageInfo:findIndexOfValueFromRow(1,"treasurePieceId")
    _distanceColumn = _distanceColumn or stageInfo:findIndexOfValueFromRow(1,"distance")
    _monsterPieceIdColumn = _monsterPieceIdColumn or stageInfo:findIndexOfValueFromRow(1,"monsterPieceId")
    _maxRollTimesColumn = _maxRollTimesColumn or stageInfo:findIndexOfValueFromRow(1,"maxRollTimes")
    _probabilityColumn = _probabilityColumn or stageInfo:findIndexOfValueFromRow(1,"probability")
    _advancedPieceIdColumn = _advancedPieceIdColumn or stageInfo:findIndexOfValueFromRow(1,"advancedPieceId")
    _advancedMaxRollTimesColumn = _advancedMaxRollTimesColumn or stageInfo:findIndexOfValueFromRow(1,"advancedMaxRollTimes")
    _advancedProbabilityColumn = _advancedProbabilityColumn or stageInfo:findIndexOfValueFromRow(1,"advancedProbability")
    _isGrooveModeColumn = _isGrooveModeColumn or stageInfo:findIndexOfValueFromRow(1,"isGrooveMode")
    _grooveModeIntervalColumn = _grooveModeIntervalColumn or stageInfo:findIndexOfValueFromRow(1,"grooveModeInterval")

    --查找 stageId 所在的行
    local _stageIdRow = stageInfo:findIndexOfValueFromColumn(_stageIdColumn, stageId.."")

    --读出 id 对应行的所有数据
    local stageId = tonumber(stageInfo:getData(_stageIdRow,_stageIdColumn)) or tonumber(stageId) or 1
    local energyCost = tonumber(stageInfo:getData(_stageIdRow,_energyCostColumn)) or 0
    local expAward = stageInfo:getData(_stageIdRow,_expAwardColumn)

    --加成经验
    --升级唐僧的加成
    local tbm = DataUtils.getTowerBuddhaModel()
    local expAwardNum = tonumber(expAward) or 0
    local expIncreaseNum = tonumber(tbm.expIncreaseParam_) or 0
    local addtionalExp = expAwardNum * expIncreaseNum
    --1宝物
    local tm = DataUtils.getTreasureModel(1)
    if tm.isTreasureEffective_ then
        local effectIncreaseNum = tonumber(tm.effectIncreaseRate_) or 0
        addtionalExp = expAwardNum * (expIncreaseNum + effectIncreaseNum)
    end


    --local treasurePieceId = stageInfo:getData(_stageIdRow,_treasurePieceIdColumn)
    local towerDistance = tonumber(stageInfo:getData(_stageIdRow,_distanceColumn)) or 1000
    local monsterPieceId = tonumber(stageInfo:getData(_stageIdRow,_monsterPieceIdColumn)) or 0
    local maxRollTimes = tonumber(stageInfo:getData(_stageIdRow,_maxRollTimesColumn)) or 0
    local probability = tonumber(stageInfo:getData(_stageIdRow,_probabilityColumn)) or 0
    local advancedPieceId = tonumber(stageInfo:getData(_stageIdRow,_advancedPieceIdColumn)) or 0
    local advancedMaxRollTimes = tonumber(stageInfo:getData(_stageIdRow,_advancedMaxRollTimesColumn)) or 0
    local advancedProbability = tonumber(stageInfo:getData(_stageIdRow,_advancedProbabilityColumn)) or 0
    local isGrooveMode = tonumber(stageInfo:getData(_stageIdRow,_isGrooveModeColumn)) or 0
    local grooveModeInterval = tonumber(stageInfo:getData(_stageIdRow,_grooveModeIntervalColumn)) or 0

    --生成MonsterModel
    local stageModel = StageModel.new()

    stageModel.stageId_              = stageId
    stageModel.energyCost_           = energyCost
    stageModel.expAward_             = expAward
    stageModel.addtionalExp_         = addtionalExp
    stageModel.treasurePieceId_      = stageId  --treasurePieceId
    stageModel.towerDistance_        = towerDistance
    stageModel.monsterPieceId_       = monsterPieceId
    stageModel.maxRollTimes_         = maxRollTimes
    stageModel.probability_          = probability
    stageModel.advancedPieceId_      = advancedPieceId
    stageModel.advancedMaxRollTimes_ = advancedMaxRollTimes
    stageModel.advancedProbability_  = advancedProbability

    stageModel.isGrooveMode_         = isGrooveMode
    stageModel.grooveModeInterval_   = grooveModeInterval

    return stageModel
end
