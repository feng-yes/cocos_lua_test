local physics_object = require('_my_code.test.tiledmap_game.unit.physics.physics_object')

local cChild = CreateClass(physics_object.cPhysicsBody)

function cChild:__init__()
    self.layer = cc.Layer:create()
    self._sp = nil
    self._lMapPoint = {0, 0}
end


function cChild:setSp(sp)
    self._sp = sp
    self.layer:addChild(sp)
end

function cChild:setParent(parent, nZorder, nTag)
    parent:addChild(self.layer, nZorder, nTag)
end

function cChild:getLayer()
    return self.layer
end


return cChild