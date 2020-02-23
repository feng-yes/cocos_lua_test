
-- 按钮效果，暂时放在这吧

CreateLocalModule('_my_code.test.tiledmap_game.res.button')

local sprire1Tag = 1
local sprire2Tag = 2

-- sPath1 常态，sPath2 按下态
function createWithPic(sPath1, sPath2)
    local sprite1 = cc.Sprite:create(sPath1)
    local sprite2
    if sPath2 then
        sprite2 = cc.Sprite:create(sPath2)
    end

    return createWithSprite(sprite1, sprite2)
end

function createWithSprite(sprite1, sprite2)
    local node = cc.Node:create()
    node:addChild(sprite1, 0, sprire1Tag)
    node:SetContentSize(sprite1:GetContentSize())
    sprite1:SetPosition('50%', '50%')
    
    if sprite2 then
        node:addChild(sprite2, 0, sprire2Tag)
        sprite2:setVisible(false)
        sprite2:SetPosition('50%', '50%')
    end

    node:OpenTouch()

    node.openTouchIn = function()
        if sprite2 then
            sprite2:setVisible(true)
            sprite1:setVisible(false)
        else
            sprite1:setScale(0.8)
        end
    end

    node.openTouchOut = function()
        if sprite2 then
            sprite2:setVisible(false)
            sprite1:setVisible(true)
        else
            sprite1:setScale(1)
        end
    end

    node.openTouchEnd = function()
        node.openTouchOut()
    end

    return node
end