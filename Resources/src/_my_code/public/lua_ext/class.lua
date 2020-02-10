-- 面向对象

-- 检查是否超类
local function issubclass(subCls, parentCls)
    while subCls do
        if subCls == parentCls then
            return true
        end

        subCls = subCls.__clsBase
    end
    return false
end

-- @desc:
--     产生一个类模板
-- @return:
--     返回新建类的模板
function CreateClass(baseClass)
    local subClass = {}

    subClass.__clsBase = baseClass

    --default functions:
    if baseClass == nil then
        -- @desc:
        --    class method
        --     return the object of the class, the returned object has no metatable
        function subClass:New(...)
            local ret = {}
            setmetatable(ret, {__index = self}) --obj 函数引用 class
            ret.__objCls = self

            --auto init
            ret:__init__(...)
            return ret
        end

        -- @desc:
        --     Called when obj is constructed
        function subClass:__init__()
            assert(false, 'not implemented')
        end
        
        -- @desc:
        --     check wether obj / cls is a kind of class
        function subClass:IsInstance(tagClass)
            return issubclass(self.__objCls, tagClass)
        end

        function subClass:Super()
            return self.__clsBase
        end
    else
        assert(isclass(baseClass))

        for k, v in pairs(baseClass) do
            subClass[k] = v
        end
    end

    return subClass, baseClass
end
