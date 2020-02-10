-- 游戏信号模块
-- 需要手动注销注册

CreateLocalModule('_my_code.test.tiledmap_game.signal.signal')

local signalMap = {}

function register(nSign, func)
    if not signalMap[nSign] then
        signalMap[nSign] = {}
    end
    if table.contents(signalMap[nSign], func) then
        return
    end
    table.insert(signalMap[nSign], func)
end

function unRegister(nSign, func)
    if not signalMap[nSign] then
        return
    end
    table.remove_v(signalMap[nSign], func)
end

function emit(nSign, ...)
    if not signalMap[nSign] then
        return
    end

    local args = {...}
    local n = select('#', ...)
    for i, func in pairs(signalMap[nSign]) do
        func(unpack(args, 1, n))
    end
end
