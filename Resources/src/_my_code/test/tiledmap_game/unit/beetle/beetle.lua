
local constant = require('_my_code.test.tiledmap_game.constant')
local physics_object = require('_my_code.test.tiledmap_game.unit.physics.physics_object')
local rigidbody = require('_my_code.test.tiledmap_game.unit.physics.rigidbody')
local cActionMgr = require('_my_code.test.tiledmap_game.unit.beetle.action_component.action_mgr')

local cBeetle, Super = CreateClass(physics_object.cPhysicsBody)

function cBeetle:__init__()
    Super.__init__(self)
    self.layer = cc.Layer:create()
    self._sp = nil
    self._actionMgr = cActionMgr:New(self)

    -- 战场数据
    self.nWarSide = 0

    self:_initPhy()
end

function cBeetle:_initPhy()
    local rigid = rigidbody.cPhySquare:New({self:getPosi()}, 15, 15)
    self:setRigiBody(rigid)
end

-- setSP是ui初始化最后一步，将setCameraMask放到这里
function cBeetle:setSp(sp)
    self._sp = sp
    self._sp:SetPosition(0, 0)
    self._sp:setScale(constant.BEETLE_SP_SCALE)
    self.layer:addChild(sp)
    self.layer:setCameraMask(constant.MAP_CAMERA_FLAG)
end

function cBeetle:setParent(parent, nZorder, nTag)
    parent:addChild(self.layer, nZorder, nTag)
end

function cBeetle:_getActionStatus()
    return self._actionMgr:GetStatus()
end

function cBeetle:IsBooming()
    return self:_getActionStatus() == constant.BEETLE_ACTION_BOOM
end

-- 动作指令
function cBeetle:actMove(bMove, nAngle, speed)
    if bMove then
        self._actionMgr:Move(nAngle, speed)
    else
        self._actionMgr:StopMove()
    end
end

function cBeetle:actAttack(nNo)
end

return cBeetle