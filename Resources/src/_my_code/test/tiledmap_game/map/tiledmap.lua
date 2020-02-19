
local mapInterface = require('_my_code.test.tiledmap_game.map.interface')
local constant = require('_my_code.test.tiledmap_game.constant')

CreateLocalModule('_my_code.test.tiledmap_game.map.tiledmap')

local tagTileMap = 1

-- 在镜头搞完前，保留这个吧
local function createTileDemoLayer()
    local layer = cc.Layer:create()

    local function onTouchesMoved(touches, event)
        local diff = touches[1]:getDelta()
        local node = layer:getChildByTag(tagTileMap)
        local currentPosX, currentPosY= node:getPosition()
        node:setPosition(cc.p(currentPosX + diff.x, currentPosY + diff.y))
    end

    local listener = cc.EventListenerTouchAllAtOnce:create()
    listener:registerScriptHandler(onTouchesMoved,cc.Handler.EVENT_TOUCHES_MOVED )
    local eventDispatcher = layer:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, layer)

    return layer
end

local function test()

    -- local layer1 = map:getLayer(constant.MAP_LAYER1)
    -- print('------------', layer1:getTileGIDAt(cc.p(5,4)))
    -- local gIdSea = layer1:getTileGIDAt(cc.p(0,0))
    -- layer1:setTileGID(gIdSea, cc.p(5,4))
    -- local layerWall = map:getLayer(constant.MAP_LAYER2)
    -- layerWall:setTileGID(4, cc.p(0,MAP_Y_NUM-1))
    -- local boy = layerWall:getTileAt(cc.p(0,MAP_Y_NUM-1))

    local mapItem = require('_my_code.test.tiledmap_game.res.map_item')
    local boy = mapItem.createMapItem(mapItem.boy1)
    boy:setAnchorPoint(cc.p(0.5,0))
    boy:SetPosition(850, 272)
    resetorder(boy)

    local boy2 =  mapItem.createMapItem(mapItem.boy1)
    boy2:setAnchorPoint(cc.p(0.5,0))
    boy2:SetPosition(890, 322)
    resetorder(boy2)
    layerItem:addChild(boy2)
    moveInit(boy2)

    layerItem:addChild(boy)
end

function initLayer()
    local ret = createTileDemoLayer()
    map = ccexp.TMXTiledMap:create("mysource/tilmap_game/map/map.tmx")
    local layer1 = map:getLayer(constant.MAP_LAYER1)
    constant.MAP_X_NUM, constant.MAP_Y_NUM = layer1:getLayerSize().width, layer1:getLayerSize().height

    ret:addChild(map, 0, tagTileMap)
    mapInterface.addProjectionEvent(ret)
    return ret, map
end