-- 摇杆组件

local module = {}

local function onTouchBegan(touch, event)
    print(touch:getLocation())
    return true
end


local function initYaoganLayer()
    local bg = cc.Sprite:create("mysource/tilmap_game/yaogan/bei.png")
    bg:setScale(0.5)
    bg:SetPosition(50, 50)
    bg:setOpacity(180)

    local gan = cc.Sprite:create("mysource/tilmap_game/yaogan/anniu.png")
    bg:addChild(gan)
    gan:setScale(0.4)
    gan:setOpacity(180)
    gan:SetPosition('50%', '50%')
    gan:OpenTouch()
    gan.openClick = function()
        print('openClick')
    end

    gan.openTouchIn = function()
        print('openTouchIn')
    end

    gan.openTouchOut = function()
        print('openTouchOut')
    end

    -- local function onTouchesMoved(touch, event)
    --     -- print(touch:getLocation())
    --     local touchLocation = gan:convertToNodeSpace(cc.p(touch:getLocation().x, touch:getLocation().y))
    --     -- print(touchLocation)
    --     -- print(gan:getContentSize())
    --     if touchLocation.x < 0 or touchLocation.y < 0 or touchLocation.x > gan:getContentSize().width or touchLocation.y > gan:getContentSize().height then
    --         return
    --     end
    --     print(touchLocation)
    -- end

    -- local listener = cc.EventListenerTouchOneByOne:create()
    -- listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN)
    -- listener:registerScriptHandler(onTouchesMoved,cc.Handler.EVENT_TOUCH_MOVED)
    -- local eventDispatcher = gan:getEventDispatcher()
    -- eventDispatcher:addEventListenerWithSceneGraphPriority(listener, gan)
    -- listener:setSwallowTouches(true)
    
    local layer = cc.Layer:create()
    layer:addChild(bg)
    
    return layer
end

return initYaoganLayer