
local constant = require('_my_code.test.tiledmap_game.constant')

CreateLocalModule('_my_code.test.tiledmap_game.map.bg')

function createBG()
    local sp = cc.Sprite:create('mysource/tilmap_game/bg/bg1.png')
    sp:setPositionZ(constant.MAP_BG_GZ)
    sp:setScaleX(1.2)
    sp:setScaleY(1.45)
    -- sp:setLocalZOrder(-100)
    return sp
end