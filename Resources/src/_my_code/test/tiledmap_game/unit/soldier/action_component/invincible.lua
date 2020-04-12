local constant = require('_my_code.test.tiledmap_game.constant')

local base = require('_my_code.test.tiledmap_game.unit.soldier.action_component.acrtion_base')
local cAction, Super = CreateClass(base)

function cAction:__init__(mgr, soldier)
    Super.__init__(self, mgr, soldier)
end

function cAction:openStatus(lPara)
    local nAllTime = unpack(lPara)
    self._soldier:getSp():runAction(cc.Sequence:create(
        cc.Blink:create(nAllTime, nAllTime * 3),
        cc.CallFunc:create(functor(self.finish, self))
    ))
end

function cAction:finish()
    self._mgr:changeStatus(self, constant.CHILD_ACTION_STAND)
end


return cAction