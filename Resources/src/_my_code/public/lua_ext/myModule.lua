-- 自定义模块

-- 非全局单例模块
function CreateLocalModule()
    local fInfo = debug.getinfo(2)
    local aPath = string.sub(fInfo.source, 3, -5)
    aPath = string.gsub(aPath, '/', '.')
    local module = {}
    setfenv(2, module)
    setmetatable(module, {__index = _G})
    package.loaded[aPath] = module
    return module
end