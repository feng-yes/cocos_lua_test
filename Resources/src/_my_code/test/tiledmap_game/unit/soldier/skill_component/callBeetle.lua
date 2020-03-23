local constant = require('_my_code.test.tiledmap_game.constant')

local base = require('_my_code.test.tiledmap_game.unit.soldier.skill_component.skill_base')
local cSkill, Super = CreateClass(base)

function cSkill:__init__(soldier)
    Super.__init__(self, soldier)
    
    self._nNo = 1
    self._cooldownTime = 1
end

function cSkill:Release(nDirection)
    print(nDirection)
    local war = require('_my_code.test.tiledmap_game.game.war')
    local startDir = -30
    for i = 1, 3 do
        war:CallBeetle(self._soldier, nDirection + i * 15 + startDir)
    end
end

return cSkill