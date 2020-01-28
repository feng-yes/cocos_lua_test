-- 信号常量

local module = {}

local function createCounter()
    local i = 0
    return function() 
        i = i + 1
        return i
    end
end

local counter = createCounter()

------------------信号常量-----------------
module.YAOGAN = counter()
------------------信号常量-----------------

counter = nil
createCounter = nil

return module