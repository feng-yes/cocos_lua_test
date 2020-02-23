
-- 地图摄像机
local constant = require('_my_code.test.tiledmap_game.constant')
local slot = require('_my_code.test.tiledmap_game.signal.signal')
local slotConstant = require('_my_code.test.tiledmap_game.signal.signal_constant')

CreateLocalModule('_my_code.test.tiledmap_game.camera.camera')

local spCameraTag = 1
local nScale = 1.2
local nXFix = 0
local nYFix = 0

local bOpenTouch = false

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

local function setTouchOpen(bOpen)
    bOpenTouch = bOpen
end

local function initTouch()
    local function onTouchesBegan(touches, event)
        if not bOpenTouch then
            return
        end
        local sp = camera:getChildByTag(spCameraTag)
        sp:SetPosition(touches[1]:getLocation().x, touches[1]:getLocation().y)
        sp:setVisible(true)
        sp:runAction(cc.Spawn:create(
            cc.Sequence:create(
                cc.ScaleTo:create(0.1, 0.5),
                cc.ScaleTo:create(0.1, 0.3)
            ),
            cc.Sequence:create(
                cc.FadeTo:create(0.1, 180),
                cc.FadeTo:create(0.1, 255)
            )
        ))
        return true
    end

    local function onTouchesMoved(touches, event)
        if not bOpenTouch then
            return
        end
        local diff = touches[1]:getDelta()
        local currentPosX, currentPosY= camera:getPosition()
        camera:setPosition(cc.p(currentPosX - diff.x * nScale, currentPosY - diff.y * nScale))
        camera:getChildByTag(spCameraTag):SetPosition(touches[1]:getLocation().x, touches[1]:getLocation().y)

        -- local x1, y1 = camera:getPosition()
        -- local x2, y2 = camera:getChildByTag(spCameraTag):getPosition()
        -- local mapInterface = require('_my_code.test.tiledmap_game.map.interface')
        -- print(mapInterface.getMapPoint({(x1 / nScale + x2), (y1 / nScale + y2)}))
    end

    local function onTouchesEnd(touches, event)
        if not bOpenTouch then
            return
        end
        local sp = camera:getChildByTag(spCameraTag)
        sp:stopAllActions()
        sp:setScale(0.3)
        sp:setVisible(false)
    end

    local listener = cc.EventListenerTouchAllAtOnce:create()
    listener:registerScriptHandler(onTouchesBegan,cc.Handler.EVENT_TOUCHES_BEGAN)
    listener:registerScriptHandler(onTouchesMoved,cc.Handler.EVENT_TOUCHES_MOVED)
    listener:registerScriptHandler(onTouchesEnd,cc.Handler.EVENT_TOUCHES_ENDED)
    local eventDispatcher = camera:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, camera)
end

local function registerSlot()
    slot.register(slotConstant.CAMERA_FOCUS_MOVE, moveSlow)
    slot.register(slotConstant.CAMERA_FOCUS, setPosi)
    slot.register(slotConstant.CAMERA_TOUCH_OPEN, setTouchOpen)
    slot.register(slotConstant.KEYBOARD_RELEASE, doReleaseKeyMap)
end

function init()
    local s = cc.Director:getInstance():getOpenGLView():getVisibleRect()
    camera = cc.Camera:createOrthographic(s.width, s.height, -5000, 5000)
    camera:setCameraFlag(constant.MAP_CAMERA_FLAG)
    -- setPosi({-s.width/2, -s.height/2})
    camera:setScale(nScale)
    initTouch()
    local spCamera = cc.Sprite:create('mysource/tilmap_game/pic/camera.png')
    spCamera:setScale(0.3)
    spCamera:setVisible(false)
    spCamera:setCameraMask(constant.MAP_CAMERA_FLAG)
    camera:addChild(spCamera, 0, spCameraTag)

    nXFix = -s.width/2 
    nYFix = -s.height/2

    registerSlot()

    return camera
end
