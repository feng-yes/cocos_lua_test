
-- 进入游戏的操作界面

local menuPanel = require('_my_code.test.tiledmap_game.controller.game_mgr.menu_panel')
local warLayer = require('_my_code.test.tiledmap_game.controller.game_mgr.war_panel')
local playerLayer = require('_my_code.test.tiledmap_game.controller.player.mgr')
local keyBoardLayer = require('_my_code.test.tiledmap_game.controller.keymap')

CreateLocalModule('_my_code.test.tiledmap_game.controller.game_mgr.game_panel')

local controlLayer

function initLayer()
    controlLayer = cc.Layer:create()
    -- 玩家控制(移动，攻击等)
    controlLayer:addChild(playerLayer.initLayer())
    -- 战场ui
    controlLayer:addChild(warLayer.initLayer())
    -- 菜单区
    controlLayer:addChild(menuPanel.initLayer())
    -- 键盘
    controlLayer:addChild(keyBoardLayer.initKeyBoard())
    return controlLayer
end

-- controlLayer 充当通用节点，用来作定时器节点等
function getLayer()
    assert(controlLayer)
    return controlLayer
end