
local MonsterPieceModel = class("MonsterPieceModel")

function MonsterPieceModel:ctor()
    self.monsterPieceID_   = 0          --妖怪碎片id
    self.monsterPieceName_ = ""         --妖怪碎片名字
    self.monsterPieceDesc_ = ""         --妖怪碎片描述
    self.pieceIconPath_    = ""         --妖怪碎片图标路径
    self.quality_          = 0          --妖怪碎片品质
    
    self.pieceLootStage1_    = 0
    self.pieceLootStage2_    = 0
    self.pieceLootStage3_    = 0
    self.pieceLootStage4_    = 0
    self.pieceLootStage5_    = 0

    self.currentNum_ = 0                --妖怪当前碎片数量
end

return MonsterPieceModel
