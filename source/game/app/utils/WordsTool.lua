
WordsTool = {}

--将整串字符逐个拆开,table里元素为单个字符
function WordsTool.getSingleWordTable(textStr)
 	local table = {}
    --print(string.byte(textStr,1,24))

    local i = 1
    while i < #textStr do
    	if string.byte(textStr,i) >=0 and string.byte(textStr,i) <= 127 then
    		--半角字符
    		table[#table + 1] = string.sub(textStr,i,i)
    	else
    	    --全角字符
    	    table[#table + 1] = string.sub(textStr,i,i+2)
    	    i = i + 2
    	end
    	i = i + 1
    end

    return table
 end 

--将整串字符逐个拆开,table里元素为逐渐加长的字符串
function WordsTool.getVariableWordsTable(textStr)
 	local table = {}
    --print(string.byte(textStr,1,24))

    local i = 1
    while i < #textStr do
    	if string.byte(textStr,i) >=0 and string.byte(textStr,i) <= 127 then
    		--半角字符
    		table[#table + 1] = string.sub(textStr,1,i)
    	else
    	    --全角字符
    	    table[#table + 1] = string.sub(textStr,1,i+2)
    	    i = i + 2
    	end
    	i = i + 1
    end

    return table
 end 
