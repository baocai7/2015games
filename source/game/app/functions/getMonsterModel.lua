
local MonsterModel = import("models.MonsterModel")

-- 缓存findIndexOfValueFromRow结果 【第一次读取时存储】
--读第1行，获得各属性所在的列index
local _npcIdColumn = nil
local _nameColumn = nil
local _iconColumn = nil
local _levelColumn = nil
local _valueColumn = nil
local _lifeColumn = nil
local _attackParamColumn = nil
local _attackFrequencyColumn = nil
local _runSpeedColumn = nil
local _attackDistanceColumn = nil
local _hasBulletAnimColumn = nil
local _bulletAnimIdColumn = nil
local _waitTimeColumn = nil
local _isAreaDamageColumn = nil
local _haveSpecialEffectColumn = nil
local _effectIdColumn = nil
local _backParamColumn = nil
local _isBossColumn = nil
local _isEliteColumn = nil
local _firTurnUpColumn = nil
local _manualPriorityColumn = nil
local _standFrameColumn = nil
local _hurtFrameColumn = nil
local _soundFileColumn = nil
local _attackFrameColumn = nil
local _npcDescColumn = nil
local _monsterTypeColumn = nil
local _zoomMultipleColumn = nil
local _upMoveColumn = nil
local _backLengthColumn = nil
local _sizeInBattleColumn = nil
local _attackTimeColumn = nil
local _qualityColumn = nil
local _morphIdColumn = nil
local _restrainTypeColumn = nil

function DataUtils.getMonsterModel( id , _towerBuddhaModel, _treasureModel6)
    id = tonumber(id) -- 强转一次，防止传入非number型导致出错。要分析的地方太多，有空注释这行代码，正确查找错误。

    local monsterInfo = DataRetainer.MONSTER_INFO
   
    --读第1行，获得各属性所在的列index
    _npcIdColumn = _npcIdColumn or monsterInfo:findIndexOfValueFromRow(1,"npcId")
    _nameColumn = _nameColumn or monsterInfo:findIndexOfValueFromRow(1,"name")
    _iconColumn = _iconColumn or monsterInfo:findIndexOfValueFromRow(1,"icon")
    _levelColumn = _levelColumn or monsterInfo:findIndexOfValueFromRow(1,"level")
    _valueColumn = _valueColumn or monsterInfo:findIndexOfValueFromRow(1,"value")
    _lifeColumn = _lifeColumn or monsterInfo:findIndexOfValueFromRow(1,"life")
    _attackParamColumn = _attackParamColumn or monsterInfo:findIndexOfValueFromRow(1,"attackParam")
    _attackFrequencyColumn = _attackFrequencyColumn or monsterInfo:findIndexOfValueFromRow(1,"attackFrequency")
    _runSpeedColumn = _runSpeedColumn or monsterInfo:findIndexOfValueFromRow(1,"runSpeed")
    _attackDistanceColumn = _attackDistanceColumn or monsterInfo:findIndexOfValueFromRow(1,"attackDistance")
    _hasBulletAnimColumn = _hasBulletAnimColumn or monsterInfo:findIndexOfValueFromRow(1,"hasBulletAnim")
    _bulletAnimIdColumn = _bulletAnimIdColumn or monsterInfo:findIndexOfValueFromRow(1,"bulletAnimId")
    _waitTimeColumn = _waitTimeColumn or monsterInfo:findIndexOfValueFromRow(1,"waitTime")
    _isAreaDamageColumn = _isAreaDamageColumn or monsterInfo:findIndexOfValueFromRow(1,"isAreaDamage")
    _haveSpecialEffectColumn = _haveSpecialEffectColumn or monsterInfo:findIndexOfValueFromRow(1,"haveSpecialEffect")
    _effectIdColumn = _effectIdColumn or monsterInfo:findIndexOfValueFromRow(1,"effectId")
    _backParamColumn = _backParamColumn or monsterInfo:findIndexOfValueFromRow(1,"backParam")
    _isEliteColumn = _isEliteColumn or monsterInfo:findIndexOfValueFromRow(1,"isElite")
    _firTurnUpColumn = _firTurnUpColumn or monsterInfo:findIndexOfValueFromRow(1,"firTurnUp")
    _manualPriorityColumn = _manualPriorityColumn or monsterInfo:findIndexOfValueFromRow(1,"manualPriority")
    _standFrameColumn = _standFrameColumn or monsterInfo:findIndexOfValueFromRow(1,"standFrame")
    _hurtFrameColumn = _hurtFrameColumn or monsterInfo:findIndexOfValueFromRow(1,"hurtFrame")
    _soundFileColumn = _soundFileColumn or monsterInfo:findIndexOfValueFromRow(1,"soundFile")
    _attackFrameColumn = _attackFrameColumn or monsterInfo:findIndexOfValueFromRow(1,"attackFrame")
    _npcDescColumn = _npcDescColumn or monsterInfo:findIndexOfValueFromRow(1,"npcDesc")
    _monsterTypeColumn = _monsterTypeColumn or monsterInfo:findIndexOfValueFromRow(1,"monsterType")
    _zoomMultipleColumn = _zoomMultipleColumn or monsterInfo:findIndexOfValueFromRow(1,"zoomMultiple")
    _upMoveColumn = _upMoveColumn or monsterInfo:findIndexOfValueFromRow(1,"upMove")
    _backLengthColumn = _backLengthColumn or monsterInfo:findIndexOfValueFromRow(1,"backLength")
    _sizeInBattleColumn = _sizeInBattleColumn or monsterInfo:findIndexOfValueFromRow(1,"sizeInBattle")
    _attackTimeColumn = _attackTimeColumn or monsterInfo:findIndexOfValueFromRow(1,"attackTime")
    _qualityColumn = _qualityColumn or monsterInfo:findIndexOfValueFromRow(1,"quality")
    _morphIdColumn = _morphIdColumn or monsterInfo:findIndexOfValueFromRow(1,"morphId")
    _restrainTypeColumn = _restrainTypeColumn or monsterInfo:findIndexOfValueFromRow(1,"restrainType")
    _isBossColumn = _isBossColumn or monsterInfo:findIndexOfValueFromRow(1,"isBoss")
    

    --查找 id 所在的行
    local _idRow = monsterInfo:findIndexOfValueFromColumn(_npcIdColumn, id.."")

    --读出 id 对应行的所有数据
    local npcId = monsterInfo:getData(_idRow,_npcIdColumn)
    local name = monsterInfo:getData(_idRow,_nameColumn)
    local icon = monsterInfo:getData(_idRow,_iconColumn)
    local defaultLevel = monsterInfo:getData(_idRow,_levelColumn)

    local value = tonumber(monsterInfo:getData(_idRow,_valueColumn)) or 1
    --升级唐僧属性加成
    local tbm = _towerBuddhaModel or DataUtils.getTowerBuddhaModel()
    --宝物属性加成
    local tm = _treasureModel6 or DataUtils.getTreasureModel(6)
    if tm.isTreasureEffective_ then
        value = value * (1 + (tonumber(tbm.spiritIncreaseParam_) or 0) + (tonumber(tm.effectIncreaseRate_) or 0) * 0.5)
    else
        value = value * (1 + (tonumber(tbm.spiritIncreaseParam_) or 0))
    end

    local life = tonumber(monsterInfo:getData(_idRow,_lifeColumn)) or 100
    local attackParam = tonumber(monsterInfo:getData(_idRow,_attackParamColumn)) or 10
    local attackFrequency = tonumber(monsterInfo:getData(_idRow,_attackFrequencyColumn)) or 1
    local runSpeed = tonumber(monsterInfo:getData(_idRow,_runSpeedColumn)) or 1
    local attackDistance = tonumber(monsterInfo:getData(_idRow,_attackDistanceColumn)) or 100
    local hasBulletAnim = monsterInfo:getData(_idRow,_hasBulletAnimColumn)
    local bulletAnimId = monsterInfo:getData(_idRow,_bulletAnimIdColumn)
    local waitTime = tonumber(monsterInfo:getData(_idRow,_waitTimeColumn)) or 0
    local isAreaDamage = monsterInfo:getData(_idRow,_isAreaDamageColumn)
    local haveSpecialEffect = monsterInfo:getData(_idRow,_haveSpecialEffectColumn)
    local effectId = monsterInfo:getData(_idRow,_effectIdColumn)
    local backParam = tonumber(monsterInfo:getData(_idRow,_backParamColumn)) or 0.2
    local backLength = tonumber(monsterInfo:getData(_idRow,_backLengthColumn)) or 0
    local isElite = monsterInfo:getData(_idRow,_isEliteColumn)
    local standFrame = monsterInfo:getData(_idRow,_standFrameColumn)
    local hurtFrame = monsterInfo:getData(_idRow,_hurtFrameColumn)
    local soundFile = monsterInfo:getData(_idRow,_soundFileColumn)
    local attackFrame = monsterInfo:getData(_idRow,_attackFrameColumn)
    local npcDesc = monsterInfo:getData(_idRow,_npcDescColumn)
    local adaptScale = tonumber(monsterInfo:getData(_idRow,_zoomMultipleColumn)) or 1
    local firstTurnUp = monsterInfo:getData(_idRow,_firTurnUpColumn)           --图鉴追加：第一次出现此怪物的关卡
    local manualPriority = monsterInfo:getData(_idRow,_manualPriorityColumn)   --图鉴排序优先级
    local sizeInBattle = tonumber(monsterInfo:getData(_idRow,_sizeInBattleColumn)) or 1
    local attackTime = tonumber(monsterInfo:getData(_idRow,_attackTimeColumn)) or 0
    local quality = tonumber(monsterInfo:getData(_idRow,_qualityColumn)) or 0
    local morphId = monsterInfo:getData(_idRow,_morphIdColumn)
    local restrainType = tonumber(monsterInfo:getData(_idRow,_restrainTypeColumn)) or 0
    local isBoss = monsterInfo:getData(_idRow,_isBossColumn)

    --生成MonsterModel
    local monsterModel = MonsterModel.new()
    monsterModel.npcId_           = npcId
    monsterModel.name_            = name
    monsterModel.icon_            = icon
    monsterModel.defaultLevel_    = defaultLevel
    monsterModel.value_           = value
    monsterModel.restrainType_    = restrainType
    monsterModel.quality_         = quality
    monsterModel.life_            = life
    monsterModel.attackParam_     = attackParam
    monsterModel.attackFrequency_ = attackFrequency
    monsterModel.runSpeed_        = runSpeed
    monsterModel.attackDistance_  = attackDistance
    monsterModel.attackTime_      = attackTime

    monsterModel.hasBulletAnim_     = hasBulletAnim
    monsterModel.bulletAnimId_      = bulletAnimId
    monsterModel.waitTime_          = waitTime
    monsterModel.isAreaDamage_      = isAreaDamage
    monsterModel.haveSpecialEffect_ = haveSpecialEffect
    monsterModel.effectID_          = effectId
    monsterModel.backParam_         = backParam
    monsterModel.backLength_        = backLength
    monsterModel.isElite_           = isElite
    monsterModel.standFrame_        = standFrame
    monsterModel.hurtFrame_         = hurtFrame
    monsterModel.soundFile_         = soundFile
    monsterModel.attackFrame_       = attackFrame
    monsterModel.npcDesc_           = npcDesc
    monsterModel.adaptScale_        = adaptScale

    monsterModel.firstTurnUp_     = firstTurnUp
    monsterModel.manualPriority_  = manualPriority
    monsterModel.sizeInBattle_    = sizeInBattle
    monsterModel.morphId_         = morphId

    monsterModel.isBoss_  = isBoss
   

    return monsterModel
end

--返回MonsterModel的table
function DataUtils.getMonsterModelTable()

    -- 缓存数据 
    local towerBuddhaModel = DataUtils.getTowerBuddhaModel()
    local tm6 = DataUtils.getTreasureModel(6)

    local monsterModel = {}
    local monsterInfo = nil
    if GameManager.INFINITE_MODE then
        monsterInfo = DataRetainer.INFINITE_MONSTER_INFO
    else
        monsterInfo = DataRetainer.MONSTER_INFO
    end
    local totalNum     = monsterInfo:getTotalRows() - 1
    for i=1,totalNum do
        local model = DataUtils.getMonsterModel(i, towerBuddhaModel, tm6)
        if tonumber(model.manualPriority_) ~= -1 then
            table.insert(monsterModel,model)
        end
    end
    return monsterModel
end
