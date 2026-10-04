
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
    local stageId = stageInfo:getData(_stageIdRow,_stageIdColumn)
    local energyCost = stageInfo:getData(_stageIdRow,_energyCostColumn)
    local expAward = stageInfo:getData(_stageIdRow,_expAwardColumn)

    --加成经验
    --升级唐僧的加成
    local tbm = DataUtils.getTowerBuddhaModel()
    local addtionalExp = tonumber(expAward * tbm.expIncreaseParam_)
    --1宝物
    local tm = DataUtils.getTreasureModel(1)
    if tm.isTreasureEffective_ then
        addtionalExp = tonumber(expAward * (tbm.expIncreaseParam_ + tm.effectIncreaseRate_))
    end


    --local treasurePieceId = stageInfo:getData(_stageIdRow,_treasurePieceIdColumn)
    local towerDistance = stageInfo:getData(_stageIdRow,_distanceColumn)
    local monsterPieceId = stageInfo:getData(_stageIdRow,_monsterPieceIdColumn)
    local maxRollTimes = stageInfo:getData(_stageIdRow,_maxRollTimesColumn)
    local probability = stageInfo:getData(_stageIdRow,_probabilityColumn)
    local advancedPieceId = stageInfo:getData(_stageIdRow,_advancedPieceIdColumn)
    local advancedMaxRollTimes = stageInfo:getData(_stageIdRow,_advancedMaxRollTimesColumn)
    local advancedProbability = stageInfo:getData(_stageIdRow,_advancedProbabilityColumn)
    local isGrooveMode = stageInfo:getData(_stageIdRow,_isGrooveModeColumn)
    local grooveModeInterval = stageInfo:getData(_stageIdRow,_grooveModeIntervalColumn)

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