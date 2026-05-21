-- RopeScene.lua
local Verlet = require("_my_code.test.rope.Verlet")
local Rope = require("_my_code.test.rope.Rope")

local RopeScene = class("RopeScene", function()
    return cc.Scene:create()
end)

function RopeScene:ctor()
    -- 背景色
    local bg = cc.LayerColor:create(cc.c4b(245, 230, 210, 255))
    self:addChild(bg)
    
    -- 物理世界
    self.verlet = Verlet.new()
    self.ropes = {}
    
    -- ============ 创建绳子 ============
    -- 屏幕中心
    local size = cc.Director:getInstance():getWinSize()
    local cx, cy = size.width / 2, size.height / 2
    
    -- 设计 3 根缠在一起的绳子，共享 2 个中间结点
    -- 先创建共享结点（先随便放在中心）
    local knotA = self.verlet:addPoint(cx - 30, cy + 20, false)
    local knotB = self.verlet:addPoint(cx + 30, cy - 20, false)
    
    -- 红绳：左下锚点 → knotA → knotB → 右上锚点
    local red = Rope.new(self.verlet,
        { {cx - 200, cy - 250}, {cx - 80, cy - 80}, {0,0}, {0,0}, {cx + 200, cy + 250} },
        {
            color = {220, 60, 60},
            thickness = 28,
            sharedPoints = { [3] = knotA, [4] = knotB }
        }
    )
    table.insert(self.ropes, red)
    
    -- 粉绳：左上锚点 → knotA → 右下锚点
    local pink = Rope.new(self.verlet,
        { {cx - 200, cy + 200}, {0,0}, {cx + 180, cy - 200} },
        {
            color = {255, 150, 180},
            thickness = 28,
            sharedPoints = { [2] = knotA }
        }
    )
    table.insert(self.ropes, pink)
    
    -- 紫绳：上锚点 → knotB → 右锚点
    local purple = Rope.new(self.verlet,
        { {cx, cy + 280}, {0,0}, {cx + 250, cy} },
        {
            color = {170, 50, 200},
            thickness = 28,
            sharedPoints = { [2] = knotB }
        }
    )
    table.insert(self.ropes, purple)
    
    -- ============ 渲染容器（管理 z-order）============
    self.ropeLayer = cc.Node:create()
    self:addChild(self.ropeLayer)
    
    for i, rope in ipairs(self.ropes) do
        self.ropeLayer:addChild(rope.drawNode, i)  -- 暂时按创建顺序排 z
        rope:renderAnchors(self.ropeLayer)
    end
    
    -- ============ 输入 ============
    self:setupTouch()
    
    -- ============ 每帧更新 ============
    self:scheduleUpdateWithPriorityLua(function(dt)
        self:onUpdate(dt)
    end, 0)
end

function RopeScene:onUpdate(dt)
    -- 物理求解
    self.verlet:update(dt)
    
    -- 重绘所有绳子
    for _, rope in ipairs(self.ropes) do
        rope:render()
        rope:updateAnchorPositions()
    end
end

function RopeScene:setupTouch()
    self.draggingPoint = nil
    
    local listener = cc.EventListenerTouchOneByOne:create()
    
    listener:registerScriptHandler(function(touch, event)
        local pos = touch:getLocation()
        for _, rope in ipairs(self.ropes) do
            local p = rope:hitAnchor(pos.x, pos.y)
            if p then
                self.draggingPoint = p
                return true
            end
        end
        return false
    end, cc.Handler.EVENT_TOUCH_BEGAN)
    
    listener:registerScriptHandler(function(touch, event)
        if self.draggingPoint then
            local pos = touch:getLocation()
            self.draggingPoint.targetX = pos.x
            self.draggingPoint.targetY = pos.y
        end
    end, cc.Handler.EVENT_TOUCH_MOVED)
    
    listener:registerScriptHandler(function(touch, event)
        self.draggingPoint = nil
    end, cc.Handler.EVENT_TOUCH_ENDED)
    
    listener:registerScriptHandler(function(touch, event)
        self.draggingPoint = nil
    end, cc.Handler.EVENT_TOUCH_CANCELLED)
    
    cc.Director:getInstance():getEventDispatcher()
        :addEventListenerWithSceneGraphPriority(listener, self)
end

return RopeScene