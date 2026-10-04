local Clist = {}
Clist = class('Clist')

function Clist:ctor(className)
    self.className_ = className
    self.p = 0
    self.list = {next = nil ,v = nil,p=0}
    self.count = 0
end

function Clist:add(data)
    self.list={ next=self.list, v=data,p=(self.list.p+1)}
    self.count = self.list.p
end

function Clist:find(data)
    local list = self.list

    while list do
        if data == list.v then
            return list.p
        else
            list = list.next
        end
    end
end

function Clist:get(flag)
    local ls = self.list
    while ls do
        if flag == ls.p  then
            return ls.v
        end
        ls = ls.next
    end
end
function Clist:broken(data)
    --find postion
    local pt = self:find(data)
    print('^pt: ' .. pt)

    print(self.list.p)

    local lt = { next = nil, v=self.list.v }
    self.list.p = self.list.p - pt

    for i=0,self.list.p-pt do
        lt = {next = lt,v=self.list.next.v}
        self.list = self.list.next
    end
    self.list = self.list.next
    self.list = self.list.next
    while lt do
        self.list = { next = self.list, v=lt.v,p=(self.list.p+1)}
        lt = lt.next
    end
    self.count = self.list.p
end

function Clist:ll()
    print('list-----------------------------')
    while self.list do
        print('lua sucks')
        print(self.list.v)
        self.list = self.list.next
    end
end

function Clist:clear()
    self.list = {next = nil ,v = nil,p=0}
end

return Clist
