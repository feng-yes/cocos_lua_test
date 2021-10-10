local constant = require('_my_code.test.tiledmap_game.constant')
local boomObj = require('_my_code.test.tiledmap_game.unit.effect.boom.boom')
local base = require('_my_code.test.tiledmap_game.unit.beetle.action_component.acrtion_base')
local slot = require('_my_code.test.tiledmap_game.signal.signal')
local slotConstant = require('_my_code.test.tiledmap_game.signal.signal_constant')
local cAction, Super = CreateClass(base)

function cAction:__init__(mgr, unit)
    Super.__init__(self, mgr, unit)
end

function cAction:openStatus(lPara)
    local boom = boomObj:New()
    boom:setPosi(self._unit:getPosi())
    boom:startBoom()
    self._mgr:changeStatus(self, constant.BEETLE_ACTION_STAND)
    -- self._unit:Destory()
    slot.emit(slotConstant.WAR_UNIT_DEL, self._unit)
end

return cAction