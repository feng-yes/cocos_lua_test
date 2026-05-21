-- Verlet.lua
-- 基于 Position Based Dynamics 的简化版距离约束求解器

local Verlet = {}
Verlet.__index = Verlet

function Verlet.new()
    local self = setmetatable({}, Verlet)
    self.points = {}       -- 所有质点
    self.constraints = {}  -- 所有距离约束
    self.iterations = 10   -- 迭代次数，越大越"硬"
    self.zuni = 0.35          -- 阻尼系数，越小越"黏"
    return self
end

-- 添加一个质点
-- fixed: 是否固定（锚点为 true）
function Verlet:addPoint(x, y, fixed)
    local p = {
        x = x, y = y,
        oldX = x, oldY = y,
        fixed = fixed or false,
        targetX = x, targetY = y,  -- 用于锚点拖动
    }
    table.insert(self.points, p)
    return p
end

-- 添加一段距离约束（绳段）
function Verlet:addConstraint(p1, p2, restLength)
    local c = {
        p1 = p1, p2 = p2,
        restLength = restLength or self:distance(p1, p2),
        stiffness = 1.0,  -- 1.0 = 完全刚性；< 1.0 = 有弹性
    }
    table.insert(self.constraints, c)
    return c
end

function Verlet:distance(p1, p2)
    local dx, dy = p2.x - p1.x, p2.y - p1.y
    return math.sqrt(dx*dx + dy*dy)
end

-- 每帧更新
function Verlet:update(dt)
    -- 1. Verlet 积分（用上一帧位置推算这一帧惯性）
    --    这里我们不加重力，因为是俯视 2D 平面
    for _, p in ipairs(self.points) do
        if not p.fixed then
            local vx = (p.x - p.oldX) * self.zuni  -- 0.85 是阻尼，越小越"黏"
            local vy = (p.y - p.oldY) * self.zuni
            p.oldX, p.oldY = p.x, p.y
            p.x = p.x + vx
            p.y = p.y + vy
        end
    end
    
    -- 2. 多次迭代求解约束
    for iter = 1, self.iterations do
        -- 锚点强制归位到目标位置（玩家拖动的位置）
        for _, p in ipairs(self.points) do
            if p.fixed then
                p.x = p.targetX
                p.y = p.targetY
                p.oldX, p.oldY = p.x, p.y
            end
        end
        
        -- 距离约束求解
        for _, c in ipairs(self.constraints) do
            local p1, p2 = c.p1, c.p2
            local dx = p2.x - p1.x
            local dy = p2.y - p1.y
            local dist = math.sqrt(dx*dx + dy*dy)
            if dist > 0.0001 then
                local diff = (dist - c.restLength) / dist * c.stiffness
                local ox = dx * 0.5 * diff
                local oy = dy * 0.5 * diff
                if not p1.fixed then
                    p1.x = p1.x + ox
                    p1.y = p1.y + oy
                end
                if not p2.fixed then
                    p2.x = p2.x - ox
                    p2.y = p2.y - oy
                end
            end
        end
    end
end

return Verlet