
-- 进入游戏的操作界面

local warLayer = require('_my_code.test.tiledmap_game.controller.game_mgr.war_panel')
local playerLayer = require('_my_code.test.tiledmap_game.controller.player.mgr')
local keyBoardLayer = require('_my_code.test.tiledmap_game.controller.keymap')

CreateLocalModule('_my_code.test.tiledmap_game.controller.game_mgr.game_panel')

function initLayer()
    controlLayer = cc.Layer:create()
    -- 玩家控制(移动，攻击等)
    controlLayer:addChild(playerLayer.initLayer())
    -- 战场ui
    controlLayer:addChild(warLayer.initLayer())
    -- 键盘
    controlLayer:addChild(keyBoardLayer.initKeyBoard())
    return controlLayer
end