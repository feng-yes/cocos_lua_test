-- 重写print函数

release_print = print

local _moduleMt = {
    __index = _G,
}


function is_module(m)
    return type(m) == 'table' and _moduleMt == getmetatable(m)
end

local function _toString(v, bCallFromStr)
    if type(v) == 'table' then
        if is_module and is_module(v) then
            return string.format('[lua module %s %s]', v.__full_path__, tostring(v))
        elseif not bCallFromStr then
            return str(v)
        end
    elseif type(v) == 'function' then
        local fInfo = debug.getinfo(v)
        if fInfo.what == 'C' then
            return string.format('[%s %s]', fInfo.what, fInfo.func)
        elseif fInfo.what == 'Lua' then
            return string.format('[%s %s %s:%d]', fInfo.what, fInfo.func, fInfo.source, fInfo.linedefined)
        end
    end

    return tostring(v)
end

local function process_print_args(...)
    local args = {...}
    for i = 1, select('#', ...) do
        local argv = args[i]
        if argv == nil then
            args[i] = 'nil'
        elseif argv == '' then
            args[i] = '""'
        else
            args[i] = _toString(argv)
        end
    end

    return table.concat(args, '    ')
end

-- @desc:
--  返回一个数值的代码字符串
--  这个函数只支持key为字符串或者数字的table,否则可能得到的结果不理想   
str = function(t)
    local strResult = {}
    local tbCreated = {}    --1. table, 2.repre string
    local tbKeys = {"BASE"} --2. table, keys

    local function WriteStr(s)
        table.insert(strResult, s)
    end

    local function WriteTab(nCount)
        for i = 1, nCount do WriteStr('\t') end
    end

    local function Write(t, nTab)
        if type(t) == 'table' then
            local repre = tbCreated[t]
            if repre then
                --如果这个table别处有引用则输出引用字符串
                WriteStr(repre)
            else
                tbCreated[t] = string.format('[%s:%s]', tostring(t), table.concat(tbKeys, ','))

                if is_module and is_module(t) then
                    WriteStr(_toString(t, true))
                else
                    WriteStr('{\n')
                    --现输出数组再输出string的key
                    local keys = table.arr_bubble_sort(table.keys(t), function(v1, v2)
                        local bn1, bn2 = type(v1) == 'number', type(v2) == 'number'
                        if bn1 and bn2 then
                            return v1 < v2
                        elseif bn1 then
                            return true
                        elseif bn2 then
                            return false
                        else
                            return tostring(v1) < tostring(v2)
                        end
                    end)

                    for _, k in ipairs(keys) do
                        table.insert(tbKeys, tostring(k))
                        WriteTab(nTab)
                        WriteStr('[' .. tostring(k) ..'] = ')
                        Write(t[k], nTab + 1)
                        WriteStr(',\n')
                        table.remove(tbKeys)
                    end
                    WriteTab(nTab - 1)
                    WriteStr('}')
                end
            end
        elseif type(t) == 'string' then
            t = string.gsub(t, '\\', '\\\\')
            t = string.gsub(t, '\n', '\\n')
            local bDQuote = string.find(t, '"')
            local bQuote= string.find(t, "'")
            if bQuote and bDQuote then
                local function get_e_char_str(len)
                    local ret = {}
                    for i = 1, len do
                        ret[i] = '='
                    end
                    return table.concat(ret)
                end
                for i = 0, 999 do
                    local e_char_str = get_e_char_str(i)
                    local checkStr = '[' .. e_char_str .. '['
                    if not string.find(t, checkStr, 1, true) then
                        local checkStrEnd = ']' .. e_char_str ..']'
                        WriteStr(checkStr .. t .. checkStrEnd)
                        break
                    end
                end
            elseif bDQuote then
                WriteStr("'" .. t .. "'")
            else
                WriteStr('"' .. t .. '"')
            end
        elseif type(t) == 'number' or type(t) == 'boolean' then
            WriteStr(tostring(t))
        else
            Write(_toString(t, true))
        end
    end

    Write(t, 1)

    return table.concat(strResult)
end

function print(...)
    local printContent = process_print_args(...)
    release_print(printContent)
end
