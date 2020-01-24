-- 有参函数打包为无参函数
function functor(func, ...)
    local args = {...}
    local n = select('#', ...)

    local function run()
        func(unpack(args, 1, n))
    end

    return run
end