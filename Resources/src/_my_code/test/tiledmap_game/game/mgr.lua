
-- 游戏进程管理器

local constant = require('_my_code.test.tiledmap_game.constant')
local slot = require('_my_code.test.tiledmap_game.signal.signal')
local slotConstant = require('_my_code.test.tiledmap_game.signal.signal_constant')
local controllerMgr = require('_my_code.test.tiledmap_game.controller.game_mgr.game_panel')
local mapMgr = require('_my_code.test.tiledmap_game.map.mgr')
local mapItem = require('_my_code.test.tiledmap_game.res.map_item')

CreateLocalModule('_my_code.test.tiledmap_game.game.mgr')

local function _initSlot()
    slot.register(slotConstant.UI_BTN_QUIT, gameEsc)
end

function gameInit()
    _initSlot()

    -- tilmap需要深度测试
    cc.Director:getInstance():setDepthTest(true)
    local scene = cc.Scene:create()

    -- 初始化地图
    scene:addChild(mapMgr.initMapLayer())

    -- 初始化上层显示及控制相关
    scene:addChild(controllerMgr.initLayer())

    -- 初始化战场数据
    local war = require('_my_code.test.tiledmap_game.game.war')
    local startAreaList = table.copy(constant.MAP_AREA_POINT[constant.MAP_START_AREA])
    slot.emit(slotConstant.WAR_UNIT_ADD, constant.WAR_UNIT_TYPE_CHILD, {mapItem.boy1, 1, startAreaList})
    slot.emit(slotConstant.WAR_UNIT_ADD, constant.WAR_UNIT_TYPE_CHILD, {mapItem.boy2, 2, startAreaList})
    slot.emit(slotConstant.WAR_UNIT_ADD, constant.WAR_UNIT_TYPE_CHILD, {mapItem.boy3, 2, startAreaList})
    -- slot.emit(slotConstant.WAR_UNIT_ADD, constant.WAR_UNIT_TYPE_CHILD, {mapItem.girl1, 2, startAreaList})
    war:setControlPlayer(war.warSides[1][1])
    
    -- 测试操控虫子
    -- war:setControlPlayer(war:_callBeetle(war.warSides[1][1], 15))

    gameStart()

    return scene
end

function gameStart()
    local war = require('_my_code.test.tiledmap_game.game.war')
    war:StartItemSys()
end

function gameEnd()
end

function gameEsc()
    if package.loaded["_my_code.test.menu"] then
        cc.Director:getInstance():popScene()
        -- 清理缓存
        cc.Director:getInstance():purgeCachedData()
    else
        RunMyCode()
    end
end

