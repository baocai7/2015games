
--[[=============================================================================
#     FileName: getInfiniteMonsterModel.lua
#         Desc: 读取无尽模式妖怪数据
#       Author: Hoo
#   LastChange: 2015-03-30 
#      History:
=============================================================================]]

local InfiniteMonsterModel = import("models.InfiniteMonsterModel")

-- 缓存findIndexOfValueFromRow结果 【第一次读取时存储】
-- 读第1行，获得各属性所在的列index
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
local _isBossSColumn = nil
local _isBossWColumn = nil

function DataUtils.getInfiniteMonsterModel( id )
    id = tonumber(id) -- 强转一次，防止传入非number型导致出错。要分析的地方太多，有空注释这行代码，正确查找错误。

    local monsterInfo = DataRetainer.INFINITE_MONSTER_INFO

    --读第1行，获得各属性所在的列index
    _npcIdColumn             = _npcIdColumn or monsterInfo:findIndexOfValueFromRow(1,"npcId")
    _nameColumn              = _nameColumn or monsterInfo:findIndexOfValueFromRow(1,"name")
    _iconColumn              = _iconColumn or monsterInfo:findIndexOfValueFromRow(1,"icon")
    _levelColumn             = _levelColumn or monsterInfo:findIndexOfValueFromRow(1,"level")
    _valueColumn             = _valueColumn or monsterInfo:findIndexOfValueFromRow(1,"value")
    _lifeColumn              = _lifeColumn or monsterInfo:findIndexOfValueFromRow(1,"life")
    _attackParamColumn       = _attackParamColumn or monsterInfo:findIndexOfValueFromRow(1,"attackParam")
    _attackFrequencyColumn   = _attackFrequencyColumn or monsterInfo:findIndexOfValueFromRow(1,"attackFrequency")
    _runSpeedColumn          = _runSpeedColumn or monsterInfo:findIndexOfValueFromRow(1,"runSpeed")
    _attackDistanceColumn    = _attackDistanceColumn or monsterInfo:findIndexOfValueFromRow(1,"attackDistance")
    _hasBulletAnimColumn     = _hasBulletAnimColumn or monsterInfo:findIndexOfValueFromRow(1,"hasBulletAnim")
    _bulletAnimIdColumn      = _bulletAnimIdColumn or monsterInfo:findIndexOfValueFromRow(1,"bulletAnimId")
    _waitTimeColumn          = _waitTimeColumn or monsterInfo:findIndexOfValueFromRow(1,"waitTime")
    _isAreaDamageColumn      = _isAreaDamageColumn or monsterInfo:findIndexOfValueFromRow(1,"isAreaDamage")
    _haveSpecialEffectColumn = _haveSpecialEffectColumn or monsterInfo:findIndexOfValueFromRow(1,"haveSpecialEffect")
    _effectIdColumn          = _effectIdColumn or monsterInfo:findIndexOfValueFromRow(1,"effectId")
    _backParamColumn         = _backParamColumn or monsterInfo:findIndexOfValueFromRow(1,"backParam")
    _isEliteColumn           = _isEliteColumn or monsterInfo:findIndexOfValueFromRow(1,"isElite")
    _firTurnUpColumn         = _firTurnUpColumn or monsterInfo:findIndexOfValueFromRow(1,"firTurnUp")
    _manualPriorityColumn    = _manualPriorityColumn or monsterInfo:findIndexOfValueFromRow(1,"manualPriority")
    _standFrameColumn        = _standFrameColumn or monsterInfo:findIndexOfValueFromRow(1,"standFrame")
    _hurtFrameColumn         = _hurtFrameColumn or monsterInfo:findIndexOfValueFromRow(1,"hurtFrame")
    _soundFileColumn         = _soundFileColumn or monsterInfo:findIndexOfValueFromRow(1,"soundFile")
    _attackFrameColumn       = _attackFrameColumn or monsterInfo:findIndexOfValueFromRow(1,"attackFrame")
    _npcDescColumn           = _npcDescColumn or monsterInfo:findIndexOfValueFromRow(1,"npcDesc")
    _monsterTypeColumn       = _monsterTypeColumn or monsterInfo:findIndexOfValueFromRow(1,"monsterType")
    _zoomMultipleColumn      = _zoomMultipleColumn or monsterInfo:findIndexOfValueFromRow(1,"zoomMultiple")
    _upMoveColumn            = _upMoveColumn or monsterInfo:findIndexOfValueFromRow(1,"upMove")
    _backLengthColumn        = _backLengthColumn or monsterInfo:findIndexOfValueFromRow(1,"backLength")
    _sizeInBattleColumn      = _sizeInBattleColumn or monsterInfo:findIndexOfValueFromRow(1,"sizeInBattle")
    _attackTimeColumn        = _attackTimeColumn or monsterInfo:findIndexOfValueFromRow(1,"attackTime")
    _qualityColumn           = _qualityColumn or monsterInfo:findIndexOfValueFromRow(1,"quality")
    _morphIdColumn           = _morphIdColumn or monsterInfo:findIndexOfValueFromRow(1,"morphId")
    _restrainTypeColumn      = _restrainTypeColumn or monsterInfo:findIndexOfValueFromRow(1,"restrainType")
    _isBossSColumn           = _isBossSColumn or monsterInfo:findIndexOfValueFromRow(1,"isBossS")
    _isBossWColumn           = _isBossWColumn or monsterInfo:findIndexOfValueFromRow(1,"isBossW")


    --查找 id 所在的行
    local _idRow = monsterInfo:findIndexOfValueFromColumn(_npcIdColumn, id.."")

    --读出 id 对应行的所有数据
    local npcId = monsterInfo:getData(_idRow,_npcIdColumn)
    local name = monsterInfo:getData(_idRow,_nameColumn)
    local icon = monsterInfo:getData(_idRow,_iconColumn)
    local defaultLevel = monsterInfo:getData(_idRow,_levelColumn)

    local value = monsterInfo:getData(_idRow,_valueColumn)
    --升级唐僧属性加成
    local tbm = _towerBuddhaModel or DataUtils.getTowerBuddhaModel()
    --宝物属性加成
    local tm = _treasureModel6 or DataUtils.getTreasureModel(6)
    if tm.isTreasureEffective_ then
        value = tonumber(value * (1 + tbm.spiritIncreaseParam_ + tm.effectIncreaseRate_ * 0.5))
    else
        value = value * (1 + tbm.spiritIncreaseParam_)
    end

    local life              = monsterInfo:getData(_idRow,_lifeColumn)
    local attackParam       = monsterInfo:getData(_idRow,_attackParamColumn)
    local attackFrequency   = monsterInfo:getData(_idRow,_attackFrequencyColumn)
    local runSpeed          = monsterInfo:getData(_idRow,_runSpeedColumn)
    local attackDistance    = monsterInfo:getData(_idRow,_attackDistanceColumn)
    local hasBulletAnim     = monsterInfo:getData(_idRow,_hasBulletAnimColumn)
    local bulletAnimId      = monsterInfo:getData(_idRow,_bulletAnimIdColumn)
    local waitTime          = monsterInfo:getData(_idRow,_waitTimeColumn)
    local isAreaDamage      = monsterInfo:getData(_idRow,_isAreaDamageColumn)
    local haveSpecialEffect = monsterInfo:getData(_idRow,_haveSpecialEffectColumn)
    local effectId          = monsterInfo:getData(_idRow,_effectIdColumn)
    local backParam         = monsterInfo:getData(_idRow,_backParamColumn)
    local backLength        = monsterInfo:getData(_idRow,_backLengthColumn)
    local isElite           = monsterInfo:getData(_idRow,_isEliteColumn)
    local standFrame        = monsterInfo:getData(_idRow,_standFrameColumn)
    local hurtFrame         = monsterInfo:getData(_idRow,_hurtFrameColumn)
    local soundFile         = monsterInfo:getData(_idRow,_soundFileColumn)
    local attackFrame       = monsterInfo:getData(_idRow,_attackFrameColumn)
    local npcDesc           = monsterInfo:getData(_idRow,_npcDescColumn)
    local adaptScale        = monsterInfo:getData(_idRow,_zoomMultipleColumn)
    local firstTurnUp       = monsterInfo:getData(_idRow,_firTurnUpColumn)           --图鉴追加：第一次出现此怪物的关卡
    local manualPriority    = monsterInfo:getData(_idRow,_manualPriorityColumn)   --图鉴排序优先级
    local sizeInBattle      = monsterInfo:getData(_idRow,_sizeInBattleColumn)
    local attackTime        = monsterInfo:getData(_idRow,_attackTimeColumn)
    local quality           = monsterInfo:getData(_idRow,_qualityColumn)
    local morphId           = monsterInfo:getData(_idRow,_morphIdColumn)
    local restrainType      = monsterInfo:getData(_idRow,_restrainTypeColumn)
    local isBossS           = monsterInfo:getData(_idRow,_isBossSColumn)
    local isBossW           = monsterInfo:getData(_idRow,_isBossWColumn)

    --生成MonsterModel
    local infiniteMonsterModel = InfiniteMonsterModel.new()
    infiniteMonsterModel.npcId_           = npcId
    infiniteMonsterModel.name_            = name
    infiniteMonsterModel.icon_            = icon
    infiniteMonsterModel.defaultLevel_    = defaultLevel
    infiniteMonsterModel.value_           = value
    infiniteMonsterModel.restrainType_    = restrainType
    infiniteMonsterModel.quality_         = quality
    infiniteMonsterModel.life_            = life
    infiniteMonsterModel.attackParam_     = attackParam
    infiniteMonsterModel.attackFrequency_ = attackFrequency
    infiniteMonsterModel.runSpeed_        = runSpeed
    infiniteMonsterModel.attackDistance_  = attackDistance
    infiniteMonsterModel.attackTime_      = attackTime

    infiniteMonsterModel.hasBulletAnim_     = hasBulletAnim
    infiniteMonsterModel.bulletAnimId_      = bulletAnimId
    infiniteMonsterModel.waitTime_          = waitTime
    infiniteMonsterModel.isAreaDamage_      = isAreaDamage
    infiniteMonsterModel.haveSpecialEffect_ = haveSpecialEffect
    infiniteMonsterModel.effectID_          = effectId
    infiniteMonsterModel.backParam_         = backParam
    infiniteMonsterModel.backLength_        = backLength
    infiniteMonsterModel.isElite_           = isElite
    infiniteMonsterModel.standFrame_        = standFrame
    infiniteMonsterModel.hurtFrame_         = hurtFrame
    infiniteMonsterModel.soundFile_         = soundFile
    infiniteMonsterModel.attackFrame_       = attackFrame
    infiniteMonsterModel.npcDesc_           = npcDesc
    infiniteMonsterModel.adaptScale_        = adaptScale

    infiniteMonsterModel.firstTurnUp_       = firstTurnUp
    infiniteMonsterModel.manualPriority_    = manualPriority
    infiniteMonsterModel.sizeInBattle_      = sizeInBattle
    infiniteMonsterModel.morphId_           = morphId

    infiniteMonsterModel.isBossS_ = isBossS
    infiniteMonsterModel.isBossW_ = isBossW
   

    return infiniteMonsterModel
end
