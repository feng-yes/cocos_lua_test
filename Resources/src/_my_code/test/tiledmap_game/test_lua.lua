local size = cc.Director:getInstance():getWinSize()
local scheduler = cc.Director:getInstance():getScheduler()

local kTagTileMap = 1


local function createTileDemoLayer(title, subtitle)
    local layer = cc.Layer:create()
    Helper.initWithLayer(layer)
    local titleStr = title == nil and "No title" or title
    local subTitleStr = subtitle  == nil and "drag the screen" or subtitle
    Helper.titleLabel:setString(titleStr)
    Helper.subtitleLabel:setString(subTitleStr)

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

local function CreateMapTest()
    local m_tamara = nil
    local ret = createTileDemoLayer("", "")
    local map = ccexp.TMXTiledMap:create("mysource/tilmap_game/map/map.tmx")
    ret:addChild(map, 0, kTagTileMap)
    map:setScale(0.5)

    return ret
end

local function RunTest()
    local scene = cc.Scene:create()
	scene:addChild(CreateBackButton())
	scene:addChild(CreateMapTest())
    return scene
end

return RunTest