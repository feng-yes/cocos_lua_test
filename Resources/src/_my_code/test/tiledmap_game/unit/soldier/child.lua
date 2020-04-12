
local constant = require('_my_code.test.tiledmap_game.constant')
local physics_object = require('_my_code.test.tiledmap_game.unit.physics.physics_object')
local rigidbody = require('_my_code.test.tiledmap_game.unit.physics.rigidbody')
local cActionMgr = require('_my_code.test.tiledmap_game.unit.soldier.action_component.action_mgr')
local cSkillMgr = require('_my_code.test.tiledmap_game.unit.soldier.skill_component.skill_mgr')

local cChild, Super = CreateClass(physics_object.cPhysicsBody)

function cChild:__init__()
    Super.__init__(self)
    self.unitType = constant.WAR_UNIT_TYPE_CHILD
    self.layer = cc.Layer:create()
    self._sp = nil
    self._actionMgr = cActionMgr:New(self)
    self._skillMgr = cSkillMgr:New(self)

    self._nFaceDirection = 0

    -- 战场数据
    self.nWarUiId = 0
    self.nWarSide = 0

    self:_initPhy()
end

function cChild:_initPhy()
    local rigid = rigidbody.cPhySquare:New({self:getPosi()}, 30, 20)
    self:setRigiBody(rigid)
    self.nMass = constant.CHILD_PHY_MASS
    self.bOpenRigi = true
end

-- setSP是ui初始化最后一步，将setCameraMask放到这里
function cChild:setSp(sp)
    self._sp = sp
    self._sp:SetPosition(0, constant.CHILD_SP_DEFAULTY)
    self.layer:addChild(sp)
    self.layer:setCameraMask(constant.MAP_CAMERA_FLAG)
end

function cChild:setParent(parent, nZorder, nTag)
    parent:addChild(self.layer, nZorder, nTag)
end

-- 面朝方向
function cChild:setFaceToAngle(nAngle)
    self._nFaceDirection = nAngle / math.pi * 180
end

function cChild:OnCrash(oCrashObj)
    if oCrashObj.unitType == constant.WAR_EFFECT_TYPE_BOOM and not oCrashObj:IsCrashUnit(self) then
        local xMy, yMy = self:getPosi()
        local xBoom, yBoom = oCrashObj:getPosi()
        local movex = xMy - xBoom
        local movey = yMy - yBoom
        local nDistance = math.sqrt(movex * movex + movey * movey)
        local nAngle = math.atan2(movey, movex)
        local nFlyLong = 2 * (constant.BOOM_RANGE_X - nDistance)
        -- print(constant.BOOM_RANGE_X - nDistance)
        -- local nFlyLong = 100
        print(math.cos(nAngle) * nFlyLong, math.sin(nAngle) * nFlyLong)
        self._actionMgr:HitFly({math.cos(nAngle) * nFlyLong + xMy, math.sin(nAngle) * nFlyLong + yMy})
    end
end

-- 动作指令
function cChild:actMove(bMove, nAngle, speed)
    if bMove then
        self._actionMgr:Move(nAngle, speed)
    else
        self._actionMgr:StopMove()
    end
end

function cChild:actAttack(nNo)
    self._skillMgr:Attack(nNo, self._nFaceDirection)
end

return cChild