
local rigibody = require('_my_code.test.tiledmap_game.unit.physics.rigidbody')
local mapInterface = require('_my_code.test.tiledmap_game.map.interface')

CreateLocalModule('_my_code.test.tiledmap_game.unit.physics.physics_object')

-- 物理体对象列表，进行碰撞检测
lPhysicsObject = {}

-- 带物理性质（碰撞）的物体都要继承此类
cPhysicsBody = CreateClass()

function cPhysicsBody:__init__()
    -- 是否物理体
    self.bPhysics = false
    self.oRigiBody = nil

    -- cocos主节点
    self.layer = nil 
end

function cPhysicsBody:setRigiBody(oRigiBody)
    assert(oRigiBody:IsInstance(rigibody.cPhyBase))
    self.oRigiBody = oRigiBody
    self.bPhysics = true
    table.insert(lPhysicsObject, self)
end

function cPhysicsBody:lostPhysics()
    self.bPhysics = false
    table.remove_v(lPhysicsObject, self)
end

-- ===============================碰撞相关

-- 碰撞时回调
function cPhysicsBody:onCrash(oCrashObj)
end

-- 移动及位置interface
function cPhysicsBody:getSp()
    return self._sp
end

function cPhysicsBody:getLayer()
    return self.layer
end

function cPhysicsBody:setPosi(x, y)
    self.layer:SetPosition(x, y)
    mapInterface.resetorder(self.layer)
end

function cPhysicsBody:getPosi()
    return self.layer:getPosition()
end

-- ===============================动作指令（输入接口，暂时写这里）
function cPhysicsBody:actMove(bMove, nAngle, speed)
end

function cPhysicsBody:actAttack(nNo)
end

function cPhysicsBody:actJump(nAngle, power)
end