
-- 地图摄像机
local constant = require('_my_code.test.tiledmap_game.constant')
local slot = require('_my_code.test.tiledmap_game.signal.signal')
local slotConstant = require('_my_code.test.tiledmap_game.signal.signal_constant')

CreateLocalModule('_my_code.test.tiledmap_game.camera.camera')

local nScale = 1.2
local nXFix = 0
local nYFix = 0

camera = nil

function setPosi(lPosi)
    local x, y = unpack(lPosi)
    camera:SetPosition(x + nXFix * nScale, y + nYFix * nScale)
end

local function moveSlow(lPosi)
    local x, y = unpack(lPosi)
    camera:runAction(cc.MoveTo:create(0.5, cc.p(x + nXFix * nScale, y + nYFix * nScale)))
end

local function doReleaseKeyMap(sKey)
    local nChange = false
    if sKey == ',' then
        nNewScale = nScale + 0.2
        nChange = true
    elseif sKey == '.' then
        nNewScale = nScale - 0.2
        nChange = true
    end

    if nChange then
        local x, y = camera:getPosition()
        local xCenter, yCenter = x - nXFix * nScale, y - nYFix * nScale
        local function scaleToFun()
            local nowScale = camera:getScale()
            nScale = nowScale
            setPosi({xCenter, yCenter})
            return 0.001
        end
        local stopFun = camera:DelayCall(0.001, scaleToFun)

        camera:runAction(
            cc.Sequence:create(
                cc.ScaleTo:create(0.3, nNewScale, nNewScale),
                cc.CallFunc:create(function()
                    scaleToFun()
                    stopFun()
                end)
            )
        )
    end
end

local function registerSlot()
    slot.register(slotConstant.CAMERA_FOCUS_MOVE, moveSlow)
    slot.register(slotConstant.CAMERA_FOCUS, setPosi)
    slot.register(slotConstant.KEYBOARD_RELEASE, doReleaseKeyMap)
end

function init()
    local s = cc.Director:getInstance():getOpenGLView():getVisibleRect()
    camera = cc.Camera:createOrthographic(s.width, s.height, -5000, 5000)
    camera:setCameraFlag(constant.MAP_CAMERA_FLAG)
    -- setPosi({-s.width/2, -s.height/2})
    camera:setScale(nScale)

    local function onTouchesMoved(touches, event)
        local diff = touches[1]:getDelta()
        local currentPosX, currentPosY= camera:getPosition()
        camera:setPosition(cc.p(currentPosX - diff.x * nScale, currentPosY - diff.y * nScale))
    end

    local listener = cc.EventListenerTouchAllAtOnce:create()
    listener:registerScriptHandler(onTouchesMoved,cc.Handler.EVENT_TOUCHES_MOVED )
    local eventDispatcher = camera:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, camera)

    nXFix = -s.width/2 
    nYFix = -s.height/2

    registerSlot()

    return camera
end
