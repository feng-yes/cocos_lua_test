
local mapItem = require('_my_code.test.tiledmap_game.res.map_item')
local cBeetle = require('_my_code.test.tiledmap_game.unit.beetle.beetle')

CreateLocalModule('_my_code.test.tiledmap_game.unit.beetle.beetle_mgr')

function createBeetle()
    local beetleSp = mapItem.createMapItem(mapItem.beetle)
    local oBeetle = cBeetle:New()
    oBeetle:setSp(beetleSp)
    return oBeetle
end