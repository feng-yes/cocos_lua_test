local constant = require('_my_code.test.tiledmap_game.constant')
local slot = require('_my_code.test.tiledmap_game.signal.signal')
local slotConstant = require('_my_code.test.tiledmap_game.signal.signal_constant')

local base = require('_my_code.test.tiledmap_game.unit.soldier.skill_component.skill_base')
local cSkill, Super = CreateClass(base)

function cSkill:__init__(soldier)
    Super.__init__(self, soldier)
    
    self._nNo = 1
    self._cooldownTime = 1
end

function cSkill:Release(nDirection)
    local startDir = -30
    for i = 1, 3 do
        if self._soldier:useBee() then
            slot.emit(slotConstant.WAR_UNIT_ADD, constant.WAR_UNIT_TYPE_BEETLE, {self._soldier, nDirection + i * 15 + startDir})
        end
    end
end

return cSkill