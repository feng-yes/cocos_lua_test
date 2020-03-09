local constant = require('_my_code.test.tiledmap_game.constant')

local base = require('_my_code.test.tiledmap_game.unit.beetle.action_component.acrtion_base')
local cAction, Super = CreateClass(base)

function cAction:__init__(mgr, unit)
    Super.__init__(self, mgr, unit)
end

return cAction