-- 摇杆组件

local slot = require('_my_code.test.tiledmap_game.signal.signal')
local slotConstant = require('_my_code.test.tiledmap_game.signal.signal_constant')

CreateLocalModule('_my_code.test.tiledmap_game.controller.player.yaogan')



function initYaoganLayer()
    local bg = createBg()
    local gan = createGan(bg)

    local layer = cc.Layer:create()
    layer:addChild(bg)
    layer:addChild(gan)
    
    return layer
end
