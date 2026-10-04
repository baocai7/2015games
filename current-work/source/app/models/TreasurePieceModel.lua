
local TreasurePieceModel = class("TreasurePieceModel")

function TreasurePieceModel:ctor()
    self.treasurePieceId_      = 0          --宝物碎片id
    self.treasurePieceName_    = ""         --宝物碎片名字
    self.treasurePieceDesc_    = ""         --宝物碎片描述
    self.treasurePieceQuality_ = 0          --宝物品质0～3 分别对应：未收集，铜，银，金
end

return TreasurePieceModel
