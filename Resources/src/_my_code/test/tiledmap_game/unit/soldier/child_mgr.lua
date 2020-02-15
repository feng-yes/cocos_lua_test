
local mapItem = require('_my_code.test.tiledmap_game.res.map_item')
local cChild = require('_my_code.test.tiledmap_game.soldier.child')

CreateLocalModule('_my_code.test.tiledmap_game.soldier.child_mgr')


function createChild(sp)
    local oChild = cChild:New()
    oChild:setSp(sp)
    return sp
end

function createPlayer1()
    local boy = mapItem.createMapItem(mapItem.boy1)
    return createChild(boy)
end

function createPlayer2()
    local boy = mapItem.createMapItem(mapItem.boy2)
    return createChild(boy)
end