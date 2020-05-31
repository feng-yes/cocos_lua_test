
CreateLocalModule('_my_code.test.public_test.hock')

report = {}

function sethook()
    report = {}
    debug.sethook(function(event,line)
        local info = debug.getinfo(2)
        local s = info.short_src
        local f = info.name
        local startline = info.linedefined
        local endline = info.lastlinedefined
        if  string.find(s,"lualib") ~= nil then
            return
        end
        if report[s] == nil then
            report[s]={}
        end
        if f == nil then
            return 
        end
        if report[s][f] ==nil then
            report[s][f]={
                start = startline,
                endline=endline,
                exec = {},
                activelines = debug.getinfo(2,'L').activelines
                }
        end
        report[s][f].exec[tostring(line)]=true

    end,'l')
end

function printSelf()
    print(table.deepcopy(report))
end

function get_report()
    local res = {}
    for f,v in pairs(report) do
        item = {
            file=f,
            funcs={}
        }
        for m ,i in pairs(v) do
                local cover = 0
                local index = 0
                local notRunLines = {}
                for c,code in pairs(i.activelines) do
                    index = index + 1
                    if i.exec[tostring(c)] or i.exec[c] then
                        cover = cover + 1
                    else
                        table.insert(notRunLines, c)
                    end
                end
                item.funcs[#item.funcs+1] = { name = m ,coverage = string.format("%.2f",cover / index*100 ) .."%", notRunLines = notRunLines}
        end
        res[#res+1]=item
   end
   return res
end