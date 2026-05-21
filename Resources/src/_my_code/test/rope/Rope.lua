-- Rope.lua
local Rope = {}
Rope.__index = Rope

-- verlet: Verlet 求解器实例
-- pointsXY: 控制点初始位置 { {x,y}, {x,y}, ... }，第一个和最后一个是锚点
-- options: { color = {r,g,b}, thickness = 20, sharedPoints = {[index] = otherPoint} }
function Rope.new(verlet, pointsXY, options)
    local self = setmetatable({}, Rope)
    options = options or {}
    self.color = options.color or {255, 80, 80}
    self.thickness = options.thickness or 20
    self.points = {}  -- Verlet 质点列表
    
    -- 创建质点
    for i, pos in ipairs(pointsXY) do
        local sharedPoint = options.sharedPoints and options.sharedPoints[i]
        if sharedPoint then
            -- 共享结点：复用别的绳子已经创建的质点
            self.points[i] = sharedPoint
        else
            local isAnchor = (i == 1 or i == #pointsXY)
            self.points[i] = verlet:addPoint(pos[1], pos[2], isAnchor)
        end
    end
    
    -- 创建段约束
    self.constraints = {}
    for i = 1, #self.points - 1 do
        local c = verlet:addConstraint(self.points[i], self.points[i+1])
        table.insert(self.constraints, c)
    end
    
    -- 渲染节点：用 DrawNode 简单实现（后面教你换三角带）
    self.drawNode = cc.DrawNode:create()
    
    return self
end

-- Catmull-Rom 样条插值：把控制点变成密集采样点，让绳子平滑
function Rope:getSmoothPoints(samplesPerSegment)
    samplesPerSegment = samplesPerSegment or 12
    local pts = self.points
    local result = {}
    
    local function catmullRom(p0, p1, p2, p3, t)
        local t2 = t*t
        local t3 = t2*t
        local x = 0.5 * ((2*p1.x) + (-p0.x + p2.x)*t +
                  (2*p0.x - 5*p1.x + 4*p2.x - p3.x)*t2 +
                  (-p0.x + 3*p1.x - 3*p2.x + p3.x)*t3)
        local y = 0.5 * ((2*p1.y) + (-p0.y + p2.y)*t +
                  (2*p0.y - 5*p1.y + 4*p2.y - p3.y)*t2 +
                  (-p0.y + 3*p1.y - 3*p2.y + p3.y)*t3)
        return x, y
    end
    
    for i = 1, #pts - 1 do
        local p0 = pts[math.max(i-1, 1)]
        local p1 = pts[i]
        local p2 = pts[i+1]
        local p3 = pts[math.min(i+2, #pts)]
        local steps = (i == #pts - 1) and samplesPerSegment or samplesPerSegment - 1
        for s = 0, steps do
            local t = s / samplesPerSegment
            local x, y = catmullRom(p0, p1, p2, p3, t)
            table.insert(result, {x = x, y = y})
        end
    end
    return result
end

-- 渲染：用 DrawNode 画粗线条（原型版本）
function Rope:render()
    self.drawNode:clear()
    local smooth = self:getSmoothPoints(10)
    local c = self.color
    local color = cc.c4f(c[1]/255, c[2]/255, c[3]/255, 1)
    
    -- 画阴影（偏移几像素的深色描边）
    local shadowColor = cc.c4f(0, 0, 0, 0.25)
    for i = 1, #smooth - 1 do
        self.drawNode:drawSegment(
            cc.p(smooth[i].x + 3, smooth[i].y - 3),
            cc.p(smooth[i+1].x + 3, smooth[i+1].y - 3),
            self.thickness * 0.55,
            shadowColor
        )
    end
    
    -- 画绳子主体
    for i = 1, #smooth - 1 do
        self.drawNode:drawSegment(
            cc.p(smooth[i].x, smooth[i].y),
            cc.p(smooth[i+1].x, smooth[i+1].y),
            self.thickness * 0.5,
            color
        )
    end
    
    -- 画高光（细一点、亮一点、偏左上）
    local hlColor = cc.c4f(
        math.min(c[1]/255 + 0.3, 1),
        math.min(c[2]/255 + 0.3, 1),
        math.min(c[3]/255 + 0.3, 1),
        1
    )
    for i = 1, #smooth - 1 do
        self.drawNode:drawSegment(
            cc.p(smooth[i].x - 2, smooth[i].y + 2),
            cc.p(smooth[i+1].x - 2, smooth[i+1].y + 2),
            self.thickness * 0.15,
            hlColor
        )
    end
end

-- 画锚点圆盘
function Rope:renderAnchors(parent)
    if self.anchorNodes then return end
    self.anchorNodes = {}
    
    for _, idx in ipairs({1, #self.points}) do
        local p = self.points[idx]
        local node = cc.DrawNode:create()
        -- 外圈底座
        node:drawDot(cc.p(0, 0), 28, cc.c4f(0.85, 0.85, 0.85, 1))
        -- 内圈孔（绳子的颜色）
        node:drawDot(cc.p(0, 0), 20, cc.c4f(
            self.color[1]/255, self.color[2]/255, self.color[3]/255, 1))
        node:drawDot(cc.p(0, 0), 14, cc.c4f(
            self.color[1]/255 * 0.6,
            self.color[2]/255 * 0.6,
            self.color[3]/255 * 0.6, 1))
        node:setPosition(cc.p(p.x, p.y))
        parent:addChild(node, 10)  -- 锚点画在绳子上面
        table.insert(self.anchorNodes, {node = node, point = p})
    end
end

-- 更新锚点显示位置
function Rope:updateAnchorPositions()
    if not self.anchorNodes then return end
    for _, info in ipairs(self.anchorNodes) do
        info.node:setPosition(cc.p(info.point.x, info.point.y))
    end
end

-- 判断点是否在某个锚点上（用于拖动）
function Rope:hitAnchor(x, y)
    for _, info in ipairs(self.anchorNodes or {}) do
        local dx = x - info.point.x
        local dy = y - info.point.y
        if dx*dx + dy*dy < 30*30 then
            return info.point
        end
    end
    return nil
end

return Rope