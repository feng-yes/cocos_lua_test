
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