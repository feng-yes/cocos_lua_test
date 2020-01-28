-- 游戏信号模块
-- 需要手动注销注册

local signalMap = {}

local module = {}

function module.register(nSign, func)
    if not signalMap[nSign] then
        signalMap[nSign] = {}
    end
    if table.contents(signalMap[nSign], func) then
        return
    end
    table.insert(signalMap[nSign], func)
end

function module.unRegister(nSign, func)
    if not signalMap[nSign] then
        return
    end
    table.remove_v(signalMap[nSign], func)
end

function module.emit(nSign, ...)
    if not signalMap[nSign] then
        return
    end

    local args = {...}
    local n = select('#', ...)
    for i, func in pairs(signalMap[nSign]) do
        func(unpack(args, 1, n))
    end
end