
-- 游戏进程管理器

local mapMgr = require('_my_code.test.tiledmap_game.map.mgr')
local controllerMgr = require('_my_code.test.tiledmap_game.controller.game_mgr.game_panel')

CreateLocalModule('_my_code.test.tiledmap_game.game.mgr')

function gameInit()
    -- tilmap需要深度测试
    cc.Director:getInstance():setDepthTest(true)
    local scene = cc.Scene:create()

    -- 初始化地图
    scene:addChild(mapMgr.initMapLayer())

    -- 初始化上层显示及控制相关
    scene:addChild(controllerMgr.initLayer())

    return scene
end

function gameStart()
end

function gameEnd()
end

function gameEsc()
end