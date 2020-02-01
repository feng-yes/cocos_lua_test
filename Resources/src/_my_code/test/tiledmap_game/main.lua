
local size = cc.Director:getInstance():getWinSize()

local kTagTileMap = 1


local function createTileDemoLayer(title, subtitle)
    local layer = cc.Layer:create()

    local function onTouchesMoved(touches, event )
        local diff = touches[1]:getDelta()
        local node = layer:getChildByTag(kTagTileMap)
        local currentPosX, currentPosY= node:getPosition()
        node:setPosition(cc.p(currentPosX + diff.x, currentPosY + diff.y))
    end

    local listener = cc.EventListenerTouchAllAtOnce:create()
    listener:registerScriptHandler(onTouchesMoved,cc.Handler.EVENT_TOUCHES_MOVED )
    local eventDispatcher = layer:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, layer)

    return layer
end

local function createMapTest()
    local m_tamara = nil
    local ret = createTileDemoLayer("", "")
    -- local map = ccexp.TMXTiledMap:create("TileMaps/orthogonal-test-vertexz.tmx")
    local map = ccexp.TMXTiledMap:create("mysource/tilmap_game/map/map.tmx")
    ret:addChild(map, 0, kTagTileMap)
    map:setScale(0.8)

    local layer1 = map:getLayer("land")
    print('------------', layer1:getLayerSize())
    print('------------', layer1:getTileGIDAt(cc.p(0,0)))
    local gIdSea = layer1:getTileGIDAt(cc.p(0,0))
    print('------------', layer1:getTileGIDAt(cc.p(5,4)))
        layer1:setTileGID(gIdSea, cc.p(5,4))

    -- 地图层设置cc_vertexz后，不设置2d方向cc_vertexz ~= 0的层都显示不出来
    local function onNodeEvent(event)
        if event == "enter" then
            cc.Director:getInstance():setProjection(cc.DIRECTOR_PROJECTION2_D )
        elseif event == "exit" then
            cc.Director:getInstance():setProjection(cc.DIRECTOR_PROJECTION_DEFAULT )
            if m_tamara ~= nil then
                m_tamara:release()
            end
        end
    end

    ret:registerScriptHandler(onNodeEvent)
    return ret
end

return createMapTest