local physics_object = require('_my_code.test.tiledmap_game.unit.physics.physics_object')

local cChild = CreateClass(physics_object.cPhysicsBody)

function cChild:__init__()
    self.layer = cc.Layer:create()
    self._sp = nil

    -- 战场数据
    self._lMapPoint = {0, 0}
    self._nWarSide = 0
end


function cChild:setSp(sp)
    self._sp = sp
    self.layer:addChild(sp)
end

function cChild:setParent(parent, nZorder, nTag)
    parent:addChild(self.layer, nZorder, nTag)
end

-- 动作指令
function cChild:actMove(bMove, nAngle, speed)
end

function cChild:actAttack(nNo)
end

return cChild