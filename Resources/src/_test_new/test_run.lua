print("123123")

local STENCIL_SIZE = {200, 300}

function runClipNode()
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

    return layer
end

function GetStencilLayer()
    local layer = cc.LayerColor:create(cc.c4b(255, 255, 255, 255 * .75), STENCIL_SIZE[1], STENCIL_SIZE[2])
    layer:setPosition(cc.p(VisibleRect:center().x, VisibleRect:center().y))
    layer:setIgnoreAnchorPointForPosition(false)
    return layer
end

function RunTest()
    local scene = cc.Scene:create()
	scene:addChild(runClipNode())
	scene:addChild(CreateBackMenuItem())
    return scene
end