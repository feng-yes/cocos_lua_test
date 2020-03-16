local constant = require('_my_code.test.tiledmap_game.constant')

local base = require('_my_code.test.tiledmap_game.unit.soldier.skill.skill_base')
local cSkill, Super = CreateClass(base)

function cSkill:__init__(soldier)
    Super.__init__(self, soldier)
end

function cSkill:Release(lPara)
    
end

return cSkill