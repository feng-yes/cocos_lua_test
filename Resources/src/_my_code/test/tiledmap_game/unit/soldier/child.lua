
local constant = require('_my_code.test.tiledmap_game.constant')
local physics_object = require('_my_code.test.tiledmap_game.unit.physics.physics_object')
local cActionMgr = require('_my_code.test.tiledmap_game.unit.soldier.action_component.action_mgr')

local cChild = CreateClass(physics_object.cPhysicsBody)

function cChild:__init__()
    self.layer = cc.Layer:create()
    self._sp = nil
    self._actionMgr = cActionMgr:New(self)

    -- 战场数据
    self._lMapPoint = {0, 0}
    self._nWarSide = 0
end

function cChild:setSp(sp)
    self._sp = sp
    self._sp:SetPosition(0, constant.CHILD_SP_DEFAULTY)
    self.layer:addChild(sp)
end

function cChild:setParent(parent, nZorder, nTag)
    parent:addChild(self.layer, nZorder, nTag)
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
end

return cChild