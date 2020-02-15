-- 信号常量

-- 枚举器
local function createCounter()
    local i = 0
    return function() 
        i = i + 1
        return i
    end
end
local counter = createCounter()


CreateLocalModule('_my_code.test.tiledmap_game.signal.signal_constant')

YAOGAN = counter()
KEYBOARD_PRESS = counter()
KEYBOARD_RELEASE = counter()