local PaymentModel = require("app.models.PaymentModel")
local _idColumn, _typeColumn, _priceColumn, _peachNumColumn, _addedNumColumn, _dailyGetColumn, _validTimeColumn, _titleColumn, _descColumn, _picPathColumn

function DataUtils.getPaymentModel(id)
  local paymentInfo
  if device.platform == "ios" then
    paymentInfo = DataRetainer.PAYMENT_IOS_INFO
  else
    paymentInfo = DataRetainer.PAYMENT_INFO
  end
  _idColumn = _idColumn or paymentInfo:findIndexOfValueFromRow(1, "ID")
  _typeColumn = _typeColumn or paymentInfo:findIndexOfValueFromRow(1, "type")
  _priceColumn = _priceColumn or paymentInfo:findIndexOfValueFromRow(1, "price")
  _peachNumColumn = _peachNumColumn or paymentInfo:findIndexOfValueFromRow(1, "peachNum")
  _addedNumColumn = _addedNumColumn or paymentInfo:findIndexOfValueFromRow(1, "addedNum")
  _dailyGetColumn = _dailyGetColumn or paymentInfo:findIndexOfValueFromRow(1, "dailyGet")
  _validTimeColumn = _validTimeColumn or paymentInfo:findIndexOfValueFromRow(1, "validTime")
  _titleColumn = _titleColumn or paymentInfo:findIndexOfValueFromRow(1, "title")
  _descColumn = _descColumn or paymentInfo:findIndexOfValueFromRow(1, "desc")
  _picPathColumn = _picPathColumn or paymentInfo:findIndexOfValueFromRow(1, "picPath")
  local _idRow = paymentInfo:findIndexOfValueFromColumn(_idColumn, id .. "")
  local id = paymentInfo:getData(_idRow, _idColumn)
  local type_ = paymentInfo:getData(_idRow, _typeColumn)
  local price = paymentInfo:getData(_idRow, _priceColumn)
  local peachNum = paymentInfo:getData(_idRow, _peachNumColumn)
  local addedNum = paymentInfo:getData(_idRow, _addedNumColumn)
  local dailyGet = paymentInfo:getData(_idRow, _dailyGetColumn)
  local validTime = paymentInfo:getData(_idRow, _validTimeColumn)
  local title = paymentInfo:getData(_idRow, _titleColumn)
  local desc = paymentInfo:getData(_idRow, _descColumn)
  local picPath = paymentInfo:getData(_idRow, _picPathColumn)
  local paymentModel = PaymentModel.new()
  paymentModel.id_ = tonumber(id)
  paymentModel.type_ = tonumber(type_)
  paymentModel.price_ = tonumber(price)
  paymentModel.peachNum_ = tonumber(peachNum)
  paymentModel.addedNum_ = tonumber(addedNum)
  paymentModel.dailyGet_ = tonumber(dailyGet)
  paymentModel.validTime_ = tonumber(validTime)
  paymentModel.title_ = title
  paymentModel.desc_ = desc
  paymentModel.picPath_ = picPath
  return paymentModel
end

function DataUtils.getPaymentModelTable()
  local paymentInfo
  if device.platform == "ios" then
    paymentInfo = DataRetainer.PAYMENT_IOS_INFO
  else
    paymentInfo = DataRetainer.PAYMENT_INFO
  end
  local total = paymentInfo:getTotalRows() - 1
  local modelTable = {}
  for i = 1, total do
    local model = DataUtils.getPaymentModel(i)
    table.insert(modelTable, model)
  end
  return modelTable
end
