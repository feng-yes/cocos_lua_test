
local constant = require('_my_code.test.tiledmap_game.constant')

cAI = CreateClass()

function cAI:__init__(oBeetle)
    self.oUnit = oBeetle
end

return cAI