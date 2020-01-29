
local function doChange(strContent, nParentContent)
    local p1, p2, p3 = string.match(strContent, '([0-9.-]*)([%%]?)([0-9.-]*)')
    assert(p1 ~= '', 'illegal str for doChange')

    if p2 == '' then
        return tonumber(p1)
    end
    local numberPercent = tonumber(p1)
    local content = numberPercent / 100 * nParentContent
    if p3 ~= '' then
        content = content + tonumber(p3)
    end 
    return content
end

-- 支持按父节点百分比设置大小及位置 eg. 50%-30 , 30%20
function cc.Node:SetPosition(sX, sY)
    local x, y
    if type(sX) == "unmber" then
        x = sX
    end
    if type(sY) == "unmber" then
        y = sY
    end

    if x and y then
        self:setPosition(cc.p(x, y))
        return
    end
    
    local parent = self:getParent()
    assert(parent ~= nil, 'set parent before SetPosition!!!')

    local nPContent = parent:getContentSize()
    if not x then
        x = doChange(sX, nPContent.width)
    end
    if not y then
        y = doChange(sY, nPContent.height)
    end
    
    self:setPosition(cc.p(x, y))
end

function cc.Node:SetContentSize(sW, sH)
    local w, h
    if type(sW) == "unmber" then
        w = sW
    end
    if type(sH) == "unmber" then
        h = sH
    end

    if w and h then
        self:setContentSize(cc.size(w, h))
        return
    end
    
    local parent = self:getParent()
    assert(parent ~= nil, 'set parent before SetContentSize!!!')

    local nPContent = parent:getContentSize()
    if not w then
        w = doChange(sW, nPContent.width)
    end
    if not h then
        h = doChange(sH, nPContent.height)
    end
    
    self:setContentSize(cc.size(w, h))
end