
-- cliping node用法测试

local STENCIL_SIZE = {200, 300}

local function GetStencilLayer()
    local layer = cc.LayerColor:create(cc.c4b(255, 255, 255, 255 * .75), STENCIL_SIZE[1], STENCIL_SIZE[2])
    layer:setPosition(cc.p(VisibleRect:center().x, VisibleRect:center().y))
    layer:setIgnoreAnchorPointForPosition(false)
    return layer
end

local function runClipNode()
    local layer = cc.Layer:create()
    local bg = cc.Sprite:create("mysource/pic/lbg.png")
    bg:setPosition(cc.p(VisibleRect:center().x, VisibleRect:center().y))
    layer:addChild(bg)

    local stencil = cc.Node:create()
    stencil:addChild(GetStencilLayer())
    print(stencil:getPosition(), stencil:getContentSize().height, stencil:getContentSize().width)

    local clipNode = cc.ClippingNode:create()
    -- clipNode:setPosition(cc.p(VisibleRect:center().x, VisibleRect:center().y))
    clipNode:setStencil(stencil)
    local di = cc.Sprite:create("Hello.png")
    di:setPosition(cc.p(VisibleRect:center().x, VisibleRect:center().y))
    clipNode:addChild(di)

    -- 底图适配不留黑边的缩放方案
    local diH, diW = di:getContentSize().height, di:getContentSize().width
    print("diH, diW ", di:getContentSize().height, di:getContentSize().width)
    local scaleW = STENCIL_SIZE[1] / diW
    local scaleH = STENCIL_SIZE[2] / diH
    print("scaleW, scaleH", scaleW, scaleH)

    di:setScale(math.max(scaleW, scaleH))


    layer:addChild(clipNode)

    -- 显示蒙版的位置信息
    -- layer:addChild(GetStencilLayer())


    local function onKeyPressed(keyCode, event)
        print('pre', keyCode)
    end

    local function onKeyReleased(keyCode, event)
        print('re', keyCode)

    end

    local listener = cc.EventListenerKeyboard:create()
    listener:registerScriptHandler(onKeyPressed, cc.Handler.EVENT_KEYBOARD_PRESSED)  
    listener:registerScriptHandler(onKeyReleased, cc.Handler.EVENT_KEYBOARD_RELEASED)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, layer) 

    return layer
end


local function RunTest()
    local scene = cc.Scene:create()
	scene:addChild(runClipNode())
	scene:addChild(CreateBackButton())
    return scene
end

return RunTest