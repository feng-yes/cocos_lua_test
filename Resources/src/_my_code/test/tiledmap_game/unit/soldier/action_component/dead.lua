local constant = require('_my_code.test.tiledmap_game.constant')

local base = require('_my_code.test.tiledmap_game.unit.soldier.action_component.acrtion_base')
local cAction, Super = CreateClass(base)

function cAction:__init__(mgr, soldier)
    Super.__init__(self, mgr, soldier)
end

function cAction:openStatus()
    self._soldier:getSp():setRotation(80)
    self._soldier:getSp():runAction(cc.Sequence:create(
        cc.DelayTime:create(constant.CHILD_RECOVER),
        cc.CallFunc:create(functor(self.finish, self))
    ))
end

function cAction:finish()
    self._soldier:getSp():setRotation(0)
    self._soldier:HPChange(100)
    self._mgr:changeStatus(self, constant.CHILD_ACTION_INVINCIBLE, {constant.CHILD_RECOVER_INVINCIBLE})
end


return cAction