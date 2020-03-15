
local mapItem = require('_my_code.test.tiledmap_game.res.map_item')
local cChild = require('_my_code.test.tiledmap_game.unit.soldier.child')

CreateLocalModule('_my_code.test.tiledmap_game.unit.soldier.child_mgr')


function createChild(sp)
    local oChild = cChild:New()
    oChild:setSp(sp)
    return oChild
end

-- sPic
-- mapItem.boy1
-- mapItem.boy2
-- mapItem.boy3
-- mapItem.girl1
-- mapItem.king
function createPlayer(sPic)
    local boy = mapItem.createMapItem(sPic)
    return createChild(boy)
end


function createPlayer1()
    local boy = mapItem.createMapItem(mapItem.boy1)
    return createChild(boy)
end

function createPlayer2()
    local boy = mapItem.createMapItem(mapItem.boy2)
    return createChild(boy)
end

function createPlayer3()
    local boy = mapItem.createMapItem(mapItem.boy3)
    return createChild(boy)
end

function createGirl()
    local boy = mapItem.createMapItem(mapItem.girl1)
    return createChild(boy)
end

function createKing()
    local boy = mapItem.createMapItem(mapItem.king)
    return createChild(boy)
end