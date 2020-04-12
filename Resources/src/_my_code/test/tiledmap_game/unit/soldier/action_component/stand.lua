local constant = require('_my_code.test.tiledmap_game.constant')

local base = require('_my_code.test.tiledmap_game.unit.soldier.action_component.acrtion_base')
local cAction, Super = CreateClass(base)

function cAction:__init__(mgr, soldier)
    Super.__init__(self, mgr, soldier)
end

function cAction:Move(nDirection, nSpeed)
    self._mgr:changeStatus(self, constant.CHILD_ACTION_WALK, {nDirection, nSpeed})
end

function cAction:HitFly(lPoint)
    self._mgr:changeStatus(self, constant.CHILD_ACTION_HIT_FLY, {lPoint})
end

return cAction