function DataUtils.getSortedPaymentInfo(info)
  local paymentTable = {}
  
  if info == nil then
    return paymentTable
  end
  for _, data in pairs(info) do
    table.insert(paymentTable, data)
  end
  table.sort(paymentTable, function(v1, v2)
    return tonumber(v1.sortWeight) < tonumber(v2.sortWeight)
  end)
  return paymentTable
end
