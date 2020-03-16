
local constant = require('_my_code.test.tiledmap_game.constant')
local rigibody = require('_my_code.test.tiledmap_game.unit.physics.rigidbody')
local mapInterface = require('_my_code.test.tiledmap_game.map.interface')
local slot = require('_my_code.test.tiledmap_game.signal.signal')
local slotConstant = require('_my_code.test.tiledmap_game.signal.signal_constant')
local quadtreeMgr = require('_my_code.test.tiledmap_game.quadtree.mgr')

CreateLocalModule('_my_code.test.tiledmap_game.unit.physics.physics_object')


-- 地图物体都要继承此类
cPhysicsBody = CreateClass()

function cPhysicsBody:__init__()
    self.unitType = constant.WAR_UNIT_TYPE_BASE

    -- 物理相关，bPhysics是否物理体(物理体进行碰撞检测)，bOpenRigi是否开启实体碰撞处理
    self.bPhysics = false
    self.oRigiBody = nil
    self.bOpenRigi = false
    self.nMass = 100  -- 质量

    -- cocos主节点
    self.layer = nil 
    self._sp = nil

    -- 位置
    self._lMapPoint = {0, 0}

    -- 摄像机跟随
    self.bCameraFocus = false
end

function cPhysicsBody:setRigiBody(oRigiBody)
    assert(oRigiBody:IsInstance(rigibody.cPhyBase))
    self.oRigiBody = oRigiBody
    self.bPhysics = true
    quadtreeMgr.insertToUnitList(self)
end

function cPhysicsBody:lostPhysics()
    self.bPhysics = false
    quadtreeMgr.removeFromUnitList(self)
end

function cPhysicsBody:Destory()
    if self.layer then
        self.layer:removeFromParent()
    end
    quadtreeMgr.removeFromUnitList(self)
end

-- ===============================节点
function cPhysicsBody:getSp()
    return self._sp
end

function cPhysicsBody:getLayer()
    return self.layer
end

-- ===============================碰撞相关
-- 碰撞时回调
function cPhysicsBody:OnCrash(oCrashObj)
    -- print(oCrashObj.unitType)
end

-- ===============================地图位置相关
function cPhysicsBody:setPosi(x, y)
    self.layer:SetPosition(x, y)
    mapInterface.resetorder(self.layer)
    self._lMapPoint = mapInterface.getMapPoint({x, y})
    if self.bPhysics then
        self.oRigiBody.lCenter = {x, y}
    end
    if self.bCameraFocus then
        slot.emit(slotConstant.CAMERA_FOCUS, {x, y})
    end
end

function cPhysicsBody:setPosiByPoint(lPoint)
    local lPosi = mapInterface.getMapPosi(lPoint)
    self:setPosi(unpack(lPosi))
end

function cPhysicsBody:getPosi()
    return self.layer:getPosition()
end

function cPhysicsBody:getMapPoint()
    return self._lMapPoint
end

-- ===============================动作指令（输入接口，暂时写这里）
function cPhysicsBody:actMove(bMove, nAngle, speed)
end

function cPhysicsBody:actAttack(nNo)
end
