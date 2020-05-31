

local function tt()
end

return function()
    -- body
    local test = require('_my_code.test.public_test.hock')
    test.sethook()

    local ttt = {1,{{1,2,3}, 23, {33,44,55,{34,5,6,2}}},3}
    print(table.deepcopy(ttt))
    local a, b = tt()
    print(a, b)

    if true then
        print(12313)
    else
        print(34556)
        print(34556)
    end

    -- test.printSelf()

    print(test.get_report())
end