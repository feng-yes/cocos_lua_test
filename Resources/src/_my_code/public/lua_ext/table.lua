-- table扩展

-- 是否包含
function table.contents(array, value)
    for i, v in ipairs(array) do
        if v == value then
            return true
        end
    end

    return false
end

-- 移除值（仅第一个）
function table.remove_v(array, value)
    for i, v in ipairs(array) do
        if v == value then
            return i, table.remove(array, i)
        end
    end
end

-- 浅复制
function table.copy(t)
    local t2 = {}
    for k, v in pairs(t) do
        t2[k] = v
    end
    return t2
end

-- 深复制
function table.deepcopy(tb)
    local tbs = {}
    local function copy(t)
        if type(t) ~= 'table' then return t end
        local ret = tbs[t]
        if ret then return ret end
        ret = {}
        tbs[t] = ret
        for k, v in pairs(t) do
            ret[k] = copy(v)
        end
        return ret
    end
    return copy(tb)
end

-- 两个array的交集array
function table.intersection(array1, array2)
    local array3 = {}
    for i, v in ipairs(array1) do
        if table.contents(array2, v) then
            table.insert(array3, v)
        end
    end
    return array3
end

-- 随机选取
function table.random_get(array)
    if #array == 0 then
        return 0, nil
    end
    local randomNum = math.random(#array)
    return array[randomNum], randomNum
end

function table.random_pop(array)
    if #array == 0 then
        return 0, nil
    end
    local randomNum = math.random(#array)
    return table.remove(array, randomNum), randomNum
end

function table.extend(array1, array2)
    for _, v in ipairs(array2) do
        table.insert(array1, v)
    end
    return array1
end

function table.arr_bubble_sort(array, cmp)
    local len = #array
    local i = len  
    while i > 0 do
        local j = 1
        while j < i do
            if not cmp(array[j], array[j+1]) then
                array[j], array[j+1] = array[j+1], array[j]
            end
            j = j + 1
        end
        i = i - 1
    end

    return array
end