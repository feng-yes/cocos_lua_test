-- 摇杆组件

local slot = require('_my_code.test.tiledmap_game.signal.signal')
local slotConstant = require('_my_code.test.tiledmap_game.signal.signal_constant')

CreateLocalModule('_my_code.test.tiledmap_game.controller.player.yaogan')


local bg = nil
local gan = nil

-- touch data
local maxMoved = 30
local ganPrePos = {}
local ganTouchPos = {}

local function beginTouch(x, y)
    gan:stopAllActions()
    local spawn = cc.Spawn:create(
        cc.ScaleTo:create(0.3, 0.44),
        cc.FadeTo:create(0.3, 255)
    )
    gan:runAction(spawn)

    -- local actbg = cc.RotateBy:create(1, 360)
    -- local repbg = cc.RepeatForever:create(actbg)
    -- bg:runAction(repbg)

    ganTouchPos = {x, y}
end

local function moveTouch(x, y)
    local movex = x - ganTouchPos[1]
    local movey = y - ganTouchPos[2]
    local touchl = math.sqrt(movex * movex + movey * movey)
    local nAngle = math.atan2(movey, movex)
    if touchl < maxMoved then
        gan:SetPosition(ganPrePos[1] + x - ganTouchPos[1], 
        ganPrePos[2] + y - ganTouchPos[2])
    else
        -- print(math.atan2(movey, movex) * 180 / math.pi)
        gan:SetPosition(ganPrePos[1] + maxMoved * math.cos(nAngle), 
        ganPrePos[2] + maxMoved * math.sin(nAngle))
    end
    gan:setRotation(-nAngle / math.pi * 180)

    slot.emit(slotConstant.YAOGAN, true, nAngle, touchl > maxMoved and 1 or touchl / maxMoved)
end

local function endTouch(x, y)
    gan:SetPosition(bg:getPosition())
    gan:stopAllActions()
    local spawn = cc.Spawn:create(
        cc.ScaleTo:create(0.3, 0.38),
        cc.FadeTo:create(0.3, 180)
    )
    gan:runAction(spawn)

    -- bg:stopAllActions()

    slot.emit(slotConstant.YAOGAN, false)
end

local function createBg()
    bg = cc.Sprite:create("mysource/tilmap_game/yaogan/timg.png")
    bg:setScale(0.4)
    bg:SetPosition(60, 60)
    bg:setOpacity(180)
    
    bg:OpenTouch()
    bg.openTouchBegan = function(touch)
        beginTouch(bg:getPosition())
        moveTouch(touch:getLocation().x, touch:getLocation().y)
        return true
    end

    bg.openTouchMoved = function(touch)
        moveTouch(touch:getLocation().x, touch:getLocation().y)
    end

    bg.openTouchEnd = function(touch)
        endTouch(touch:getLocation().x, touch:getLocation().y)
    end 
    return bg
end

local function createGan(bg)
    gan = cc.Sprite:create("mysource/tilmap_game/yaogan/mid.png")
    gan:setScale(0.38)
    gan:setOpacity(180)
    gan:SetPosition(bg:getPosition())
    ganPrePos = {gan:getPosition()}

    gan:OpenTouch()
    gan.openTouchBegan = function(touch)
        beginTouch(touch:getLocation().x, touch:getLocation().y)
        return true
    end

    gan.openTouchMoved = function(touch)
        moveTouch(touch:getLocation().x, touch:getLocation().y)
    end

    gan.openTouchEnd = function(touch)
        endTouch(touch:getLocation().x, touch:getLocation().y)
    end 
    return gan
end

function setKeyActionW()
    beginTouch(0, 0)
    moveTouch(0, maxMoved)
end

function setKeyActionA()
    beginTouch(0, 0)
    moveTouch(-maxMoved, 0)
end

function setKeyActionS()
    beginTouch(0, 0)
    moveTouch(0, -maxMoved)
end

function setKeyActionD()
    beginTouch(0, 0)
    moveTouch(maxMoved, 0)
end

function setKeyActionWA()
    beginTouch(0, 0)
    moveTouch(-maxMoved, maxMoved)
end

function setKeyActionAS()
    beginTouch(0, 0)
    moveTouch(-maxMoved, -maxMoved)
end

function setKeyActionSD()
    beginTouch(0, 0)
    moveTouch(maxMoved, -maxMoved)
end

function setKeyActionDW()
    beginTouch(0, 0)
    moveTouch(maxMoved, maxMoved)
end

function setActionStop()
    endTouch()
end

function initYaoganLayer()
    local bg = createBg()
    local gan = createGan(bg)

    local layer = cc.Layer:create()
    layer:addChild(bg)
    layer:addChild(gan)
    
    return layer
end
