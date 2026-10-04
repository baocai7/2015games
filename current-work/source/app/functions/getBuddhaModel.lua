
local BuddhaModel = import("models.BuddhaModel")

-- 缓存findIndexOfValueFromRow结果 【第一次读取时存储】
-- 读第1行，获得各属性所在的列index
local _npcIdColumn = nil
local _nameColumn = nil
local _iconColumn = nil
local _defaultLevelColumn = nil
local _maxLevelColumn = nil
local _costValueColumn = nil
local _cdTimeColumn = nil
local _advancedGuardIdColumn = nil
local _lifeParamKColumn = nil
local _lifeParamBColumn = nil
local _attackParamKColumn = nil
local _attackParamBColumn = nil
local _lifeParamKAddColumn = nil        --newly added
local _lifeParamBAddColumn = nil              --newly added
local _attackParamKAddColumn = nil          --newly added
local _attackParamBAddColumn = nil          --newly added

local _essenceValueColumn = nil
local _essenceParamKColumn = nil
local _essenceParamBColumn = nil
local _restraintypeColumn = nil

local _attackFrequencyKColumn = nil
local _attackFrequencyBColumn = nil
--local _runSpeedKColumn = buddhaInfo:findIndexOfValueFromRow(1,"runSpeedK")
--todo 删除 csv多余的一列
local _runSpeedColumn = nil
local _attackDistanceColumn = nil
local _hasBulletAnimColumn = nil
local _bulletAnimIdColumn = nil
local _waitTimeColumn = nil
local _isAreaDamageColumn = nil
local _haveSpecialEffectColumn = nil
local _effectIdColumn = nil
local _backParamColumn = nil
local _manualPriorityColumn = nil
local _summonPieceIdColumn = nil
local _summonNumColumn = nil
local _standFrameColumn = nil
local _hurtFrameColumn = nil
local _soundFileColumn = nil
local _attackFrameColumn = nil
local _npcDescColumn = nil
local _defaultSkillTypeColumn = nil
local _zoomMultipleColumn = nil
local _upMoveColumn = nil
local _backLengthColumn = nil
local _sizeInBattleColumn = nil
local _tag1Column = nil
local _tag2Column = nil
local _tag3Column = nil
local _attackTimeColumn = nil
local _qualityColumn = nil
local _isRebelColumn = nil
local _balanceColumn = nil
local _limitCDTimeColumn = nil


function DataUtils.getBuddhaModel( id,_towerBuddhaModel,treasureModel4,treasureModel5,treasureModel8 )
    id = tonumber(id) -- 强转一次，防止传入非number型导致出错。要分析的地方太多，有空注释这行代码，正确查找错误。
    local buddhaInfo = DataRetainer.BUDDHA_INFO

    -- 读第1行，获得各属性所在的列index
    _npcIdColumn = _npcIdColumn or buddhaInfo:findIndexOfValueFromRow(1,"npcId")
    _nameColumn = _nameColumn or buddhaInfo:findIndexOfValueFromRow(1,"name")
    _iconColumn = _iconColumn or buddhaInfo:findIndexOfValueFromRow(1,"icon")
    _defaultLevelColumn = _defaultLevelColumn or buddhaInfo:findIndexOfValueFromRow(1,"defaultLevel")
    _maxLevelColumn = _maxLevelColumn or buddhaInfo:findIndexOfValueFromRow(1,"maxLevel")
    _costValueColumn = _costValueColumn or buddhaInfo:findIndexOfValueFromRow(1,"costValue")
    _limitCDTimeColumn = _limitCDTimeColumn or buddhaInfo:findIndexOfValueFromRow(1,"limitCD")
    _cdTimeColumn = _cdTimeColumn or buddhaInfo:findIndexOfValueFromRow(1,"cdTime")
    _advancedGuardIdColumn = _advancedGuardIdColumn or buddhaInfo:findIndexOfValueFromRow(1,"advancedGuardId")
    _lifeParamKColumn = _lifeParamKColumn or buddhaInfo:findIndexOfValueFromRow(1,"lifeParamK")
    _lifeParamBColumn = _lifeParamBColumn or buddhaInfo:findIndexOfValueFromRow(1,"lifeParamB")
    _attackParamKColumn = _attackParamKColumn or buddhaInfo:findIndexOfValueFromRow(1,"attackParamK")
    _attackParamBColumn = _attackParamBColumn or buddhaInfo:findIndexOfValueFromRow(1,"attackParamB")
    _lifeParamKAddColumn = _lifeParamKAddColumn or buddhaInfo:findIndexOfValueFromRow(1,"lifeParamKAdd")              --newly added
    _lifeParamBAddColumn = _lifeParamBAddColumn or buddhaInfo:findIndexOfValueFromRow(1,"lifeParamBAdd")              --newly added
    _attackParamKAddColumn = _attackParamKAddColumn or buddhaInfo:findIndexOfValueFromRow(1,"attackParamKAdd")          --newly added
    _attackParamBAddColumn = _attackParamBAddColumn or buddhaInfo:findIndexOfValueFromRow(1,"attackParamBAdd")          --newly added

    _essenceValueColumn = _essenceValueColumn or buddhaInfo:findIndexOfValueFromRow(1,"essenceValue")
    _essenceParamKColumn = _essenceParamKColumn or buddhaInfo:findIndexOfValueFromRow(1,"essenceParamK")
    _essenceParamBColumn = _essenceParamBColumn or buddhaInfo:findIndexOfValueFromRow(1,"essenceParamB")
    _restraintypeColumn = _restraintypeColumn or buddhaInfo:findIndexOfValueFromRow(1,"restrainType")

    _attackFrequencyKColumn = _attackFrequencyKColumn or buddhaInfo:findIndexOfValueFromRow(1,"attackFrequencyK")
    _attackFrequencyBColumn = _attackFrequencyBColumn or buddhaInfo:findIndexOfValueFromRow(1,"attackFrequencyB")
    --local _runSpeedKColumn = buddhaInfo:findIndexOfValueFromRow(1,"runSpeedK")
    --todo 删除 csv多余的一列
    _runSpeedColumn = _runSpeedColumn or buddhaInfo:findIndexOfValueFromRow(1,"runSpeedB")
    _attackDistanceColumn = _attackDistanceColumn or buddhaInfo:findIndexOfValueFromRow(1,"attackDistance")
    _hasBulletAnimColumn = _hasBulletAnimColumn or buddhaInfo:findIndexOfValueFromRow(1,"hasBulletAnim")
    _bulletAnimIdColumn = _bulletAnimIdColumn or buddhaInfo:findIndexOfValueFromRow(1,"bulletAnimId")
    _waitTimeColumn = _waitTimeColumn or buddhaInfo:findIndexOfValueFromRow(1,"waitTime")
    _isAreaDamageColumn = _isAreaDamageColumn or buddhaInfo:findIndexOfValueFromRow(1,"isAreaDamage")
    _haveSpecialEffectColumn = _haveSpecialEffectColumn or buddhaInfo:findIndexOfValueFromRow(1,"haveSpecialEffect")
    _effectIdColumn = _effectIdColumn or buddhaInfo:findIndexOfValueFromRow(1,"effectId")
    _backParamColumn = _backParamColumn or buddhaInfo:findIndexOfValueFromRow(1,"backParam")
    _manualPriorityColumn = _manualPriorityColumn or buddhaInfo:findIndexOfValueFromRow(1,"manualPriority")
    _summonPieceIdColumn = _summonPieceIdColumn or buddhaInfo:findIndexOfValueFromRow(1,"summonPieceID")
    _summonNumColumn = _summonNumColumn or buddhaInfo:findIndexOfValueFromRow(1,"summonNum")
    _standFrameColumn = _standFrameColumn or buddhaInfo:findIndexOfValueFromRow(1,"standFrame")
    _hurtFrameColumn = _hurtFrameColumn or buddhaInfo:findIndexOfValueFromRow(1,"hurtFrame")
    _soundFileColumn = _soundFileColumn or buddhaInfo:findIndexOfValueFromRow(1,"soundFile")
    _attackFrameColumn = _attackFrameColumn or buddhaInfo:findIndexOfValueFromRow(1,"attackFrame")
    _npcDescColumn = _npcDescColumn or buddhaInfo:findIndexOfValueFromRow(1,"npcDesc")
    _defaultSkillTypeColumn = _defaultSkillTypeColumn or buddhaInfo:findIndexOfValueFromRow(1,"defaultSkillType")
    _zoomMultipleColumn = _zoomMultipleColumn or buddhaInfo:findIndexOfValueFromRow(1,"zoomMultiple")
    _upMoveColumn = _upMoveColumn or buddhaInfo:findIndexOfValueFromRow(1,"upMove")
    _backLengthColumn = _backLengthColumn or buddhaInfo:findIndexOfValueFromRow(1,"backLength")
    _sizeInBattleColumn = _sizeInBattleColumn or buddhaInfo:findIndexOfValueFromRow(1,"sizeInBattle")
    _tag1Column = _tag1Column or buddhaInfo:findIndexOfValueFromRow(1,"tag1")
    _tag2Column = _tag2Column or buddhaInfo:findIndexOfValueFromRow(1,"tag2")
    _tag3Column = _tag3Column or buddhaInfo:findIndexOfValueFromRow(1,"tag3")
    _attackTimeColumn = _attackTimeColumn or buddhaInfo:findIndexOfValueFromRow(1,"attackTime")
    _qualityColumn = _qualityColumn or buddhaInfo:findIndexOfValueFromRow(1,"quality")
    _isRebelColumn = _isRebelColumn or buddhaInfo:findIndexOfValueFromRow(1,"isRebel")
    _balanceColumn = _balanceColumn or buddhaInfo:findIndexOfValueFromRow(1,"balance")

    --查找 id 所在的行
    local _idRow = buddhaInfo:findIndexOfValueFromColumn(_npcIdColumn, id.."")
    
    -- 获取所在行的所有数据（PS:虽然data已经是复数形式了，加个s，只为标记）
    local datas = buddhaInfo:getDatas(_idRow) or {}

    --读出 id 对应行的所有数据
    local npcId = datas[_npcIdColumn] -- buddhaInfo:getData(_idRow,_npcIdColumn)
    local name = datas[_nameColumn] --buddhaInfo:getData(_idRow,_nameColumn)
    local icon = datas[_iconColumn] --buddhaInfo:getData(_idRow,_iconColumn)
    local defaultLevel = datas[_defaultLevelColumn] --buddhaInfo:getData(_idRow,_defaultLevelColumn)
    local maxLevel = datas[_maxLevelColumn] --buddhaInfo:getData(_idRow,_maxLevelColumn)
    local costValue = tonumber(datas[_costValueColumn]) or 40 --buddhaInfo:getData(_idRow,_costValueColumn)

    -- 最短CD时间
    local limitCDTime = tonumber(datas[_limitCDTimeColumn]) or 0

    local cdTime = tonumber(datas[_cdTimeColumn]) or 1 --buddhaInfo:getData(_idRow,_cdTimeColumn)
     -- 基础cd时间
    local basicCDTime = cdTime
    --宝物加成
    local treasureModel = treasureModel4 or DataUtils.getTreasureModel(4)
    local decreaseRate = 0
    if treasureModel.isTreasureEffective_ then
        decreaseRate = tonumber(treasureModel.effectIncreaseRate_) or 0
        decreaseRate = decreaseRate * 0.5
    end
    --升级唐僧属性加成
    local towerBuddhaModel = _towerBuddhaModel or DataUtils.getTowerBuddhaModel()
    cdTime = tonumber(cdTime * (1 - (tonumber(towerBuddhaModel.cdTimeDecreaseParam_) or 0) * (1 + decreaseRate))) or 1

    -- 兵种最短cd时间限制
    if cdTime < tonumber(limitCDTime) then
        cdTime = tonumber(limitCDTime)
    end

    local advancedGuardId = datas[_advancedGuardIdColumn] --buddhaInfo:getData(_idRow,_advancedGuardIdColumn)
    local lifeParamK = tonumber(datas[_lifeParamKColumn]) or 0 --buddhaInfo:getData(_idRow,_lifeParamKColumn)
    local lifeParamB = tonumber(datas[_lifeParamBColumn]) or 100 --buddhaInfo:getData(_idRow,_lifeParamBColumn)
    local attackParamK = tonumber(datas[_attackParamKColumn]) or 0 --buddhaInfo:getData(_idRow,_attackParamKColumn)
    local attackParamB = tonumber(datas[_attackParamBColumn]) or 10 --buddhaInfo:getData(_idRow,_attackParamBColumn)

    local lifeParamKAdd = tonumber(datas[_lifeParamKAddColumn]) or 0 --buddhaInfo:getData(_idRow,_lifeParamKAddColumn)                    --newly added
    local lifeParamBAdd = tonumber(datas[_lifeParamBAddColumn]) or 0 --buddhaInfo:getData(_idRow,_lifeParamBAddColumn)                    --newly added
    local attackParamKAdd = tonumber(datas[_attackParamKAddColumn]) or 0 --buddhaInfo:getData(_idRow,_attackParamKAddColumn)                --newly added
    local attackParamBAdd = tonumber(datas[_attackParamBAddColumn]) or 0 --buddhaInfo:getData(_idRow,_attackParamBAddColumn)                --newly added

    local essenceValue = datas[_essenceValueColumn] --buddhaInfo:getData(_idRow,_essenceValueColumn)
    local essenceParamK = tonumber(datas[_essenceParamKColumn]) or 0 --buddhaInfo:getData(_idRow,_essenceParamKColumn)
    local essenceParamB = tonumber(datas[_essenceParamBColumn]) or 0 --buddhaInfo:getData(_idRow,_essenceParamBColumn)
    local restrainType = tonumber(datas[_restraintypeColumn]) or 0 --buddhaInfo:getData(_idRow,_restraintypeColumn)

    local attackFrequencyK = tonumber(datas[_attackFrequencyKColumn]) or 0 --buddhaInfo:getData(_idRow,_attackFrequencyKColumn)
    local attackFrequencyB = tonumber(datas[_attackFrequencyBColumn]) or 1 --buddhaInfo:getData(_idRow,_attackFrequencyBColumn)
    --local runSpeedK = buddhaInfo:getData(_idRow,_runSpeedKColumn)
    local runSpeed = tonumber(datas[_runSpeedColumn]) or 1 --buddhaInfo:getData(_idRow,_runSpeedColumn)
    local attackDistance = tonumber(datas[_attackDistanceColumn]) or 100 --buddhaInfo:getData(_idRow,_attackDistanceColumn)
    local adaptScale = tonumber(datas[_zoomMultipleColumn]) or 1 --buddhaInfo:getData(_idRow,_zoomMultipleColumn)
    local hasBulletAnim = datas[_hasBulletAnimColumn] --buddhaInfo:getData(_idRow,_hasBulletAnimColumn)
    local bulletAnimId = datas[_bulletAnimIdColumn] --buddhaInfo:getData(_idRow,_bulletAnimIdColumn)
    local waitTime = tonumber(datas[_waitTimeColumn]) or 0 --buddhaInfo:getData(_idRow,_waitTimeColumn)
    local isAreaDamage = datas[_isAreaDamageColumn] --buddhaInfo:getData(_idRow,_isAreaDamageColumn)
    local haveSpecialEffect = datas[_haveSpecialEffectColumn] --buddhaInfo:getData(_idRow,_haveSpecialEffectColumn)
    local effectId = datas[_effectIdColumn] --buddhaInfo:getData(_idRow,_effectIdColumn)
    local backParam = tonumber(datas[_backParamColumn]) or 0.2 --buddhaInfo:getData(_idRow,_backParamColumn)
    local backLength = tonumber(datas[_backLengthColumn]) or 0 --buddhaInfo:getData(_idRow,_backLengthColumn)
    local upMove = tonumber(datas[_upMoveColumn]) or 0 --buddhaInfo:getData(_idRow,_upMoveColumn)
    local summonPieceId = tonumber(datas[_summonPieceIdColumn]) or 0 --buddhaInfo:getData(_idRow,_summonPieceIdColumn)
    local summonNum = tonumber(datas[_summonNumColumn]) or 0 --buddhaInfo:getData(_idRow,_summonNumColumn)
    local standFrame = datas[_standFrameColumn] --buddhaInfo:getData(_idRow,_standFrameColumn)
    local hurtFrame = datas[_hurtFrameColumn] --buddhaInfo:getData(_idRow,_hurtFrameColumn)
    local soundFile = datas[_soundFileColumn] --buddhaInfo:getData(_idRow,_soundFileColumn)
    local attackFrame = datas[_attackFrameColumn] --buddhaInfo:getData(_idRow,_attackFrameColumn)
    local npcDesc = datas[_npcDescColumn] --buddhaInfo:getData(_idRow,_npcDescColumn)
    local manualPriority = datas[_manualPriorityColumn] --buddhaInfo:getData(_idRow,_manualPriorityColumn)
    local sizeInBattle = tonumber(datas[_sizeInBattleColumn]) or 1 --buddhaInfo:getData(_idRow,_sizeInBattleColumn)
    local tag1 = tonumber(datas[_tag1Column]) or 0 --buddhaInfo:getData(_idRow,_tag1Column)
    local tag2 = tonumber(datas[_tag2Column]) or 0 --buddhaInfo:getData(_idRow,_tag2Column)
    local tag3 = tonumber(datas[_tag3Column]) or 0 --buddhaInfo:getData(_idRow,_tag3Column)
    local attackTime = tonumber(datas[_attackTimeColumn]) or 0 --buddhaInfo:getData(_idRow,_attackTimeColumn)
    local quality = tonumber(datas[_qualityColumn]) or 0 --buddhaInfo:getData(_idRow,_qualityColumn)
    local isRebel = datas[_isRebelColumn] --buddhaInfo:getData(_idRow,_isRebelColumn)
    local balance = datas[_balanceColumn] --buddhaInfo:getData(_idRow,_balanceColumn)


    --生成BuddhaModel
    local buddhaModel = BuddhaModel.new()
    buddhaModel.npcId_                  = npcId
    buddhaModel.name_                   = name
    buddhaModel.icon_                   = icon
    buddhaModel.defaultLevel_           = defaultLevel
    buddhaModel.maxLevel_               = maxLevel
    buddhaModel.costValue_              = costValue
    buddhaModel.basicCdTime_            = basicCDTime
    buddhaModel.cdTime_                 = cdTime
    buddhaModel.advancedGuardID_        = advancedGuardId
    buddhaModel.restrainType_           = restrainType
    buddhaModel.attackTime_             = attackTime
    buddhaModel.quality_                = quality
    buddhaModel.isRebel_                = isRebel
    buddhaModel.balance_                = balance

    buddhaModel.lifeParamK_             = lifeParamK
    buddhaModel.lifeParamB_             = lifeParamB
    buddhaModel.attackParamK_           = attackParamK
    buddhaModel.attackParamB_           = attackParamB

    buddhaModel.lifeParamKAdd_          = lifeParamKAdd
    buddhaModel.lifeParamBAdd_          = lifeParamBAdd
    buddhaModel.attackParamKAdd_        = attackParamKAdd
    buddhaModel.attackParamBAdd_        = attackParamBAdd

    buddhaModel.attackFrequencyK_       = attackFrequencyK
    buddhaModel.attackFrequencyB_       = attackFrequencyB
    --buddhaModel.runSpeedK_              = runSpeedK
    buddhaModel.runSpeed_               = runSpeed
    buddhaModel.attackDistance_         = attackDistance

    buddhaModel.essenceValue_           = essenceValue
    buddhaModel.essenceParamK_          = essenceParamK
    buddhaModel.essenceParamB_          = essenceParamB

    buddhaModel.hasBulletAnim_          = hasBulletAnim
    buddhaModel.bulletAnimId_           = bulletAnimId
    buddhaModel.waitTime_               = waitTime
    buddhaModel.isAreaDamage_           = isAreaDamage
    buddhaModel.haveSpecialEffect_      = haveSpecialEffect
    buddhaModel.effectID_               = effectId
    buddhaModel.backParam_              = backParam
    buddhaModel.backLength_             = backLength
    buddhaModel.summonPieceId_          = summonPieceId
    buddhaModel.summonNum_              = summonNum
    buddhaModel.standFrame_             = standFrame
    buddhaModel.hurtFrame_              = hurtFrame
    buddhaModel.soundFile_              = soundFile
    buddhaModel.attackFrame_            = attackFrame
    buddhaModel.npcDesc_                = npcDesc
    buddhaModel.adaptScale_             = adaptScale
    buddhaModel.upMove_                 = upMove
    buddhaModel.tag1_                   = tag1
    buddhaModel.tag2_                   = tag2
    buddhaModel.tag3_                   = tag3
    buddhaModel.manualPriority_         = manualPriority
    buddhaModel.sizeInBattle_           = sizeInBattle

    --读CloudData
    local npcInfoId                     = CloudData.NPC_INFO[id] or {level = 1, addlevel = 0, status = 1, isActive = 1}
    if(npcInfoId==nil) then
        local x = 1
    end
    buddhaModel.level_                  = tonumber(npcInfoId.level) or 1 --CloudData.NPC_INFO[id].level
    if buddhaModel.level_ > 21 then
        buddhaModel.level_ = 1
    end
    buddhaModel.addLevel_               = tonumber(npcInfoId.addlevel) or 0 --CloudData.NPC_INFO[id].addlevel
    buddhaModel.buddhaState_            = npcInfoId.status --CloudData.NPC_INFO[id].status
    buddhaModel.buddhaIsActive_         = npcInfoId.isActive --CloudData.NPC_INFO[id].isActive

    --计算兵种血量与攻击力
    local life   = tonumber(lifeParamK * buddhaModel.level_ + lifeParamB + lifeParamKAdd * buddhaModel.addLevel_ + lifeParamBAdd)
    local attack = tonumber(attackParamK * buddhaModel.level_ + attackParamB + attackParamKAdd * buddhaModel.addLevel_ + attackParamBAdd)
    --宝物加成
    local tm1 = treasureModel5 or DataUtils.getTreasureModel(5)
    if tm1.isTreasureEffective_ then
        life = tonumber(life * (1 + (tonumber(tm1.effectIncreaseRate_) or 0) * 0.5)) or life
    end
    local tm2 = treasureModel8 or DataUtils.getTreasureModel(8)
    if tm2.isTreasureEffective_ then
        attack = tonumber(attack * (1 + (tonumber(tm2.effectIncreaseRate_) or 0) * 0.5)) or attack
    end

    buddhaModel.life_   = life
    buddhaModel.attack_ = attack

    --计算升级经验值
    if(id==101) then
        local x = 1
    end
    local buddhaExp = DataRetainer.BUDDHA_EXP_COST_INFO:objectAtIndex(id) or {}
    buddhaModel.expCost_ = tonumber(buddhaExp[string.format("level%dupgrade",buddhaModel.level_)]) or 0

    --计算消耗精华石 (公式:((N^2.5+50)*2+essenceParamB*N-2))
    --buddhaModel.essenceCost_            = tonumber(buddhaModel.addLevel_ * buddhaModel.essenceParamK_ + buddhaModel.essenceParamB_)
    local temp1 = math.pow((buddhaModel.addLevel_ + 1),2.5)
    local temp2 = buddhaModel.essenceParamB_ * (buddhaModel.addLevel_ + 1)
    local temp3 = (temp1 + 50) * 2 + temp2 * 0.5 - 2
    local temp4 = math.floor(temp3 / 100)
    buddhaModel.essenceCost_ = temp4 * 100
    --妖怪兵种的碎片
    buddhaModel.currPieceNum_ = 0
    local summonPieceId = tonumber(buddhaModel.summonPieceId_)
    if summonPieceId > 0 then
--        local monsterPiecemodel   = DataUtils.getMonsterPieceModel(summonPieceId)
        --碎片数量
--        local currMonsterPieceNum = tonumber(monsterPiecemodel.currentNum_)  --现有数量
        --存储妖怪兵种现有碎片
--        buddhaModel.currPieceNum_ = currMonsterPieceNum
        
        buddhaModel.currPieceNum_ = tonumber(CloudData.MONSTER_PIECE_INFO[summonPieceId]) or 0
--        print("碎片:",buddhaModel.currPieceNum_)        
    end

    return buddhaModel
end

-- 返回所有现有可用 buddhaIds在 TeamScene中使用
function DataUtils.getBuddhaIdsTableTeamScene()

    local tableNpc = {}

    for i,npcInfo in pairs(CloudData.NPC_INFO) do
        if 1 == npcInfo.status and 1 == npcInfo.isActive then
            tableNpc[#tableNpc + 1] = npcInfo.npcId
        end
    end

    return tableNpc
end


-- BUDDHA 返回是否反叛信息，是否拥有高级数据
local function getBuddhaInfo(id)
    if(id==nil) then
        local x = 1
    end
    
    id = tonumber(id)

    local buddhaInfo = DataRetainer.BUDDHA_INFO
    _isRebelColumn = _isRebelColumn or buddhaInfo:findIndexOfValueFromRow(1,"isRebel")
    _advancedGuardIdColumn = _advancedGuardIdColumn or buddhaInfo:findIndexOfValueFromRow(1,"advancedGuardId")
    _npcIdColumn = _npcIdColumn or buddhaInfo:findIndexOfValueFromRow(1,"npcId")
    
    local _idRow = buddhaInfo:findIndexOfValueFromColumn(_npcIdColumn, id.."")

    -- 获取所在行的所有数据（PS:虽然data已经是复数形式了，加个s，只为标记）
    local datas = buddhaInfo:getDatas(_idRow)
    
    local isRebel = datas[_isRebelColumn] -- 是否是神仙
    local advancedGuardId = datas[_advancedGuardIdColumn] -- 是否有高等级兵种
    if(CloudData.NPC_INFO[tonumber(id)]==nil) then
        local x = 2
    end
    local buddhaState = CloudData.NPC_INFO[tonumber(id)].status -- 是否拥有
    return isRebel,advancedGuardId,buddhaState
end

-- flag  "BUDDHA" "MONSTER"
function DataUtils.getBuddhaModelsTableUpgradeScene( flag )

    local tableNpcModel = {}

    --csv
    local buddhaInfo = DataRetainer.BUDDHA_INFO
    local npcNumTotal = buddhaInfo:getTotalRows() - 1

    -- 缓存数据
    local towerBuddhaModel = DataUtils.getTowerBuddhaModel()
    local tm4 = DataUtils.getTreasureModel(4)
    local tm5 = DataUtils.getTreasureModel(5)
    local tm8 = DataUtils.getTreasureModel(8)

    if flag == "BUDDHA" then
        for id = 1, npcNumTotal do
            local isRebel,advancedGuardID,buddhaState = getBuddhaInfo(id)
            
            -- 只检查 低级兵种，神仙
            if("0" == isRebel and 0 ~= tonumber(advancedGuardID)) then
                local isRebel2,advancedGuardID2,buddhaState2 = getBuddhaInfo(tonumber(advancedGuardID))
                
                if(1==buddhaState2) then
                    tableNpcModel[#tableNpcModel + 1] = DataUtils.getBuddhaModel( tonumber(advancedGuardID), towerBuddhaModel,tm4,tm5,tm8 )
                else
                    tableNpcModel[#tableNpcModel + 1] = DataUtils.getBuddhaModel( id, towerBuddhaModel,tm4,tm5,tm8 )
                end
--                local buddhaModel = DataUtils.getBuddhaModel( id, towerBuddhaModel,tm4,tm5,tm8 )
--                -- 神仙
--                if "0" == buddhaModel.isRebel_ then
--                    --是低级兵种
--                    if 0 ~= tonumber(buddhaModel.advancedGuardID_) then
--                        --取高级兵种
--                        local advancedBuddhaModel = DataUtils.getBuddhaModel( tonumber(buddhaModel.advancedGuardID_),towerBuddhaModel,tm4,tm5,tm8 )
--                        --高级兵种已获得
--                        if 1 == advancedBuddhaModel.buddhaState_ then
--                            tableNpcModel[#tableNpcModel + 1] = advancedBuddhaModel
--                        else
--                            tableNpcModel[#tableNpcModel + 1] = buddhaModel
--                        end
--                    end
--                end
            end
        end

        --神仙兵种排序
        local buddhaSortTable1 = {}     --已拥有
        local buddhaSortTable2 = {}     --未拥有
        for idx = 1,#tableNpcModel do
            local model = tableNpcModel[idx]
            if model.buddhaState_ == 1 then
                table.insert(buddhaSortTable1,model)
            else
                table.insert(buddhaSortTable2,model)
            end
        end
        table.insertto(buddhaSortTable1,buddhaSortTable2)
        tableNpcModel = buddhaSortTable1

    elseif flag == "MONSTER" then
        for id = 1, npcNumTotal do
            local isRebel,advancedGuardID,buddhaState = getBuddhaInfo(id)
            if("1" == isRebel) then
                tableNpcModel[#tableNpcModel + 1] = DataUtils.getBuddhaModel( id, towerBuddhaModel,tm4,tm5,tm8 )
            end
            
--            local buddhaModel = DataUtils.getBuddhaModel( id, towerBuddhaModel,tm4,tm5,tm8 )
--            -- 叛变的妖怪
--            if "1" == buddhaModel.isRebel_ then
--                tableNpcModel[#tableNpcModel + 1] = buddhaModel
--            end
        end

        --妖怪兵种排序
        local monsterSortTable1 = {}         --可召唤
        local monsterSortTable2 = {}         --已召唤
        local monsterSortTable3 = {}         --不可召唤
        for idx = 1,#tableNpcModel do
            local model     = tableNpcModel[idx]
            local currNum   = model.currPieceNum_
            local summonNum = tonumber(model.summonNum_)
            if(summonNum==nil or currNum == nil) then
                local y = 1
            end
            if (currNum >= summonNum) and model.buddhaState_ == 0 then
                table.insert(monsterSortTable1,model)
            elseif model.buddhaState_ == 1 then
                table.insert(monsterSortTable2,model)
            else
                table.insert(monsterSortTable3,model)
            end
        end
        --不可召唤的按碎片需求量排序
        local tempModel = nil
        for m=1,#monsterSortTable3 do
            for n=1,(#monsterSortTable3 - 1) do
                local model1 = monsterSortTable3[n]
                local model2 = monsterSortTable3[n + 1]
                if tonumber(model1.summonNum_) > tonumber(model2.summonNum_) then
                    tempModel = model1
                    monsterSortTable3[n] = model2
                    monsterSortTable3[n + 1] = tempModel
                end
            end
        end

        table.insertto(monsterSortTable1,monsterSortTable2)
        table.insertto(monsterSortTable1,monsterSortTable3)
        tableNpcModel = monsterSortTable1

    end

    return tableNpcModel
end


--成就使用 求 "BUDDHA"或 "MONSTER"数量
function DataUtils.getAlreadyHaveNpcIdNum( flag )
    local npcIdTable = DataUtils.getBuddhaIdsTableTeamScene()

    local countNum = 0

    for i,npcId in pairs(npcIdTable) do
        local buddhaModel = DataUtils.getBuddhaModel(npcId)
        if "BUDDHA" == flag then
            if buddhaModel.isRebel_ == "0" then
                countNum = countNum + 1
            end
        elseif "MONSTER" == flag then
            if buddhaModel.isRebel_ == "1" then
                countNum = countNum + 1
            end
        else

        end
    end

    return countNum
end






