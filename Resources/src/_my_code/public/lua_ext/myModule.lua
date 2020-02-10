-- 自定义模块

-- 非全局单例模块
function CreateLocalModule(path)
    local module = {}
    setfenv(2, module)
    setmetatable(module, {__index = _G})
    package.loaded[path] = module
    return module
end