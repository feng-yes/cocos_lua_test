-- 摇杆组件

local slot = require('_my_code.test.tiledmap_game.signal.signal')
local slotConstant = require('_my_code.test.tiledmap_game.signal.signal_constant')

local function onTouchBegan(touch, event)
    print(touch:getLocation())
    return true
end

local function createBg()
    local bg = cc.Sprite:create("mysource/tilmap_game/yaogan/bei.png")
    bg:setScale(0.5)
    bg:SetPosition(50, 50)
    bg:setOpacity(180)
    return bg
end

local function createGan(bg)
    local gan = cc.Sprite:create("mysource/tilmap_game/yaogan/anniu.png")
    gan:setScale(0.2)
    gan:setOpacity(180)
    gan:SetPosition(bg:getPosition())

    gan:OpenTouch()
    local maxMoved = 30
    local ganPrePos = {gan:getPosition()}
    local ganTouchPos
    gan.openTouchBegan = function(touch)
        gan:stopAllActions()
        local spawn = cc.Spawn:create(
            cc.ScaleTo:create(0.3, 0.25),
            cc.FadeTo:create(0.3, 255)
        )
        gan:runAction(spawn)

        local actbg = cc.RotateBy:create(1, 360)
        local repbg = cc.RepeatForever:create(actbg)
        bg:runAction(repbg)

        ganTouchPos = touch:getLocation()
        return true
    end

    gan.openTouchMoved = function(touch)
        local movex = touch:getLocation().x - ganTouchPos.x
        local movey = touch:getLocation().y - ganTouchPos.y
        local touchl = math.sqrt(movex * movex + movey * movey)
        local nAngle = math.atan2(movey, movex)
        if touchl < maxMoved then
            gan:SetPosition(ganPrePos[1] + touch:getLocation().x - ganTouchPos.x, 
            ganPrePos[2] + touch:getLocation().y - ganTouchPos.y)
        else
            -- print(math.atan2(movey, movex) * 180 / math.pi)
            gan:SetPosition(ganPrePos[1] + maxMoved * math.cos(nAngle), 
            ganPrePos[2] + maxMoved * math.sin(nAngle))
        end

        slot.emit(slotConstant.YAOGAN, true, nAngle, touchl > maxMoved and 1 or touchl / maxMoved)
        print(slotConstant.YAOGAN, true, nAngle, touchl > maxMoved and 1 or touchl / maxMoved)
    end

    gan.openTouchEnd = function()
        gan:SetPosition(bg:getPosition())
        gan:stopAllActions()
        local spawn = cc.Spawn:create(
            cc.ScaleTo:create(0.3, 0.2),
            cc.FadeTo:create(0.3, 180)
        )
        gan:runAction(spawn)

        bg:stopAllActions()

        slot.emit(slotConstant.YAOGAN, false)
    end 
    return gan
end

local function initYaoganLayer()
    local bg = createBg()
    local gan = createGan(bg)

    local layer = cc.Layer:create()
    layer:addChild(bg)
    layer:addChild(gan)
    
    return layer
end

return initYaoganLayer