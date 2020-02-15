-- 节点扩展

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
    if type(sX) == "number" then
        x = sX
    end
    if type(sY) == "number" then
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
    if type(sW) == "number" then
        w = sW
    end
    if type(sH) == "number" then
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

function cc.Node:GetContentSize()
    local tContent = self:getContentSize()
    return tContent.width, tContent.height
end

cc.Node.GetPosition = cc.Node.getPosition

-- 开启触摸控制，触摸判定范围为节点contensize
-- 触摸回调方法名: openTouchBegan(), openTouchMoved(), openTouchEnd()
-- 其他回调方法/属性
-- 点击回调：openClick()
-- 是否触摸节点:bOpenTouching; 触摸进入节点:openTouchIn(); 触摸离开节点:openTouchOut()
function cc.Node:OpenTouch()
    self.bOpenTouching = false
    local onTouchBegan = function(touch, event)
        local touchLocation = self:convertToNodeSpace(cc.p(touch:getLocation().x, touch:getLocation().y))
        if touchLocation.x < 0 or touchLocation.y < 0 or 
        touchLocation.x > self:getContentSize().width or touchLocation.y > self:getContentSize().height then
            self.bOpenTouching = false
            return
        end
        self.bOpenTouching = true
        if self.openTouchBegan then
            return self.openTouchBegan(touch, event)
        end
        return true
    end

    local onTouchMoved = function(touch, event)
        local touchLocation = self:convertToNodeSpace(cc.p(touch:getLocation().x, touch:getLocation().y))
        local nowTouching
        if touchLocation.x < 0 or touchLocation.y < 0 or 
        touchLocation.x > self:getContentSize().width or touchLocation.y > self:getContentSize().height then
            nowTouching = false
        else
            nowTouching = true
        end
        
        if nowTouching ~= self.bOpenTouching then
            if nowTouching then
                if self.openTouchIn then 
                    self.openTouchIn(touch, event)
                end
            else
                if self.openTouchOut then 
                    self.openTouchOut(touch, event)
                end
            end
        end
        self.bOpenTouching = nowTouching

        if self.openTouchMoved then
            self.openTouchMoved(touch, event)
        end
    end
    
    local onTouchEnd = function(touch, event)
        local touchLocation = self:convertToNodeSpace(cc.p(touch:getLocation().x, touch:getLocation().y))
        if touchLocation.x > 0 and touchLocation.y > 0 and 
        touchLocation.x < self:getContentSize().width and touchLocation.y < self:getContentSize().height then
            if self.openClick then
                self.openClick(touch, event)
            end
        end
        if self.openTouchEnd then
            self.openTouchEnd(touch, event)
        end
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN)
    listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED)
    listener:registerScriptHandler(onTouchEnd,cc.Handler.EVENT_TOUCH_ENDED)
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
    -- 默认吞噬
    listener:setSwallowTouches(true)
    self._sysTouchListener = listener
end

function cc.Node:SetOpenTouchSwallow(bOpen)
    if self._sysTouchListener then
        self._sysTouchListener:setSwallowTouches(bOpen)
    end
end