
local slot = require('_my_code.test.tiledmap_game.signal.signal')
local slotConstant = require('_my_code.test.tiledmap_game.signal.signal_constant')

-- 自底而上的地图层名称
local MAP_LAYER1 = 'land'
local MAP_LAYER2 = 'wall'
local MAP_LAYER3 = 'top'

-- 地图块数量
local MAP_X_NUM, MAP_Y_NUM

local kTagTileMap = 1


local function createTileDemoLayer(title, subtitle)
    local layer = cc.Layer:create()

    local function onTouchesMoved(touches, event)
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

local function resetorder(sp)
    local p = cc.p(sp:getPosition())
    p = CC_POINT_POINTS_TO_PIXELS(p)
    sp:setPositionZ( -( (p.y+81) /81) )
    sp:setLocalZOrder(50000 - math.floor((p.y+81) /81*100))
    -- 开启深度检测后，涉及到几个重叠节点的显示还是会受localz大小影响，统一设置localz=0无果，设置比较大的值后就正常了，先这么用吧-_-
    -- 保证靠前的节点zorder大一些则正常显示
    print(10000 - math.floor((p.y+81) /81*100))
    print(sp:getPositionZ())
end

local function moveInit(sp)
    local nSpeed = 150
    local timePer = 0.1
    
    local function moveAction(nAngle)
        local move = cc.MoveBy:create(timePer, cc.p(nSpeed * timePer * math.cos(nAngle), nSpeed * timePer * math.sin(nAngle)))
        local callback = cc.CallFunc:create(functor(resetorder, sp))
        local callback2 = cc.CallFunc:create(functor(moveAction, nAngle))
        local seq = cc.Sequence:create(move, callback, callback2)
        sp:runAction(seq)
    end

    local function moveCon(bMove, nAngle, speed)
        sp:stopAllActions()
        if bMove then
            moveAction(nAngle)
        else
            resetorder(sp)
        end
    end

    slot.register(slotConstant.YAOGAN, moveCon)
end

local function createMapTest()
    local ret = createTileDemoLayer("", "")
    -- local map = ccexp.TMXTiledMap:create("TileMaps/orthogonal-test-vertexz.tmx")
    local map = ccexp.TMXTiledMap:create("mysource/tilmap_game/map/map.tmx")
    local layer1 = map:getLayer(MAP_LAYER1)
    MAP_X_NUM, MAP_Y_NUM = layer1:getLayerSize().width, layer1:getLayerSize().height
    ret:addChild(map, 0, kTagTileMap)
    map:setScale(0.8)

    -- print('------------', layer1:getTileGIDAt(cc.p(5,4)))
    -- local gIdSea = layer1:getTileGIDAt(cc.p(0,0))
    -- layer1:setTileGID(gIdSea, cc.p(5,4))

    local layerWall = map:getLayer(MAP_LAYER2)

    -- 碰撞物体放单独的地图层
    local layerItem = cc.Layer:create()
    map:addChild(layerItem)
    print(layerItem:getLocalZOrder())

    local mapItem = require('_my_code.test.tiledmap_game.map.map_item')
    local boy = mapItem.createMapItem(mapItem.boy1)
    -- layerWall:setTileGID(4, cc.p(0,MAP_Y_NUM-1))
    -- local boy = layerWall:getTileAt(cc.p(0,MAP_Y_NUM-1))
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

    -- 地图层设置cc_vertexz后，不设置2d方向cc_vertexz ~= 0的层都显示不出来
    local function onNodeEvent(event)
        if event == "enter" then
            cc.Director:getInstance():setProjection(cc.DIRECTOR_PROJECTION2_D )
        elseif event == "exit" then
            cc.Director:getInstance():setProjection(cc.DIRECTOR_PROJECTION_DEFAULT )
        end
    end

    ret:registerScriptHandler(onNodeEvent)
    return ret
end

return createMapTest