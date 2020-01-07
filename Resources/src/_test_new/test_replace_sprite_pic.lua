
-- 替换sprite的纹理


local function runSpriteReplaceNode()

    local scheduler = cc.Director:getInstance():getScheduler()

    local layer = cc.Layer:create()
    local sprite = cc.Sprite:create("extensions/potentiometerButton.png")
    sprite:setPosition(cc.p(VisibleRect:center().x, VisibleRect:center().y))
    layer:addChild(sprite)
    print(sprite:getContentSize())

    -- 法1(ContentSize 手动改变)
    local schedulerID1
    local function ch1()
        scheduler:unscheduleScriptEntry(schedulerID1)

        local path1 = 'extensions/switch-mask.png'
        local texture
        texture = cc.Director:getInstance():getTextureCache():addImage(path1)
        -- 也可以这样获取
        -- texture = cc.Director:getInstance():getTextureCache():getTextureForKey(path1)
        sprite:setContentSize(cc.size(texture:getContentSize().width * 2, texture:getContentSize().height * 2))
        sprite:setTexture(texture)
        print(sprite:getContentSize())
    end
    schedulerID1 = scheduler:scheduleScriptFunc(ch1, 2.0, false)

    -- 法2
    local schedulerID2
    local function ch2() 
        scheduler:unscheduleScriptEntry(schedulerID2)
        
        local path2 = 'extensions/potentiometerProgress.png'
        local texture2 = cc.Director:getInstance():getTextureCache():addImage(path2)
        local size = texture2:getContentSize()
        local spriteframe = cc.SpriteFrame:createWithTexture(texture2, cc.rect(0, 0, size.width, size.height))
        sprite:setSpriteFrame(spriteframe)
        print(sprite:getContentSize())
    end
    schedulerID2 = scheduler:scheduleScriptFunc(ch2, 4.0, false)

    
    -- 法3 从合图中获取
    local schedulerID3
    local function ch3() 
        scheduler:unscheduleScriptEntry(schedulerID3)
        
        local plistPath = 'zwoptex/grossini-generic.plist'
        local path3 = 'grossini_dance_generic_01.png'
        local frameCache = cc.SpriteFrameCache:getInstance()
        frameCache:addSpriteFrames(plistPath)
        sprite:setSpriteFrame(frameCache:getSpriteFrame(path3))
        print(sprite:getContentSize())

        -- new精灵也可以直接用SpriteFrame
        local path4 = 'grossini_dance_generic_02.png'
        local sprite2 = cc.Sprite:createWithSpriteFrameName(path4)
        sprite2:setPosition(cc.p(VisibleRect:center().x/2, VisibleRect:center().y/2))
        layer:addChild(sprite2)
    end
    schedulerID3 = scheduler:scheduleScriptFunc(ch3, 6.0, false)
    -- local frameCache = cc.SpriteFrameCache:getInstance()

    return layer
end

function RunTest2()
    local scene = cc.Scene:create()
	scene:addChild(runSpriteReplaceNode())
	scene:addChild(CreateBackMenuItem())
    return scene
end