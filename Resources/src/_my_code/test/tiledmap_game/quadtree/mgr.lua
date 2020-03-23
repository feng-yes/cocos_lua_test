-- 系统碰撞处理

local constant = require('_my_code.test.tiledmap_game.constant')
local cQuadTree = require('_my_code.test.tiledmap_game.quadtree.quadtree')
local mapInterface = require('_my_code.test.tiledmap_game.map.interface')
local rigibody = require('_my_code.test.tiledmap_game.unit.physics.rigidbody')

CreateLocalModule('_my_code.test.tiledmap_game.quadtree.mgr')

-- 物理体对象列表，进行碰撞检测
local lPhysicsObject = {}
local quadtree = nil


-- 模拟单位改变位置后是否合法
local function isUnitNoCrash(oUnit, oIgnoreUnit)
    if not mapInterface.canGotoPosi(oUnit, oUnit.oRigiBody.lCenter) then
        return false
    end

    local lToCrashUnit = quadtree:FindToCrashObj({}, oUnit)
    for i, toCrashUnit in ipairs(lToCrashUnit) do
        if oUnit ~= toCrashUnit and toCrashUnit ~= oIgnoreUnit and toCrashUnit.bOpenRigi then
            if rigibody.isCrash(oUnit.oRigiBody, toCrashUnit.oRigiBody) then
                return false
            end
        end
    end
    return true
end

local function doRigiUnitInCrash(unit1, unit2)
    local rigi1 = unit1.oRigiBody
    local rigi2 = unit2.oRigiBody
    local rigi1X, rigi1Y = unpack(rigi1.lCenter)
    local rigi2X, rigi2Y = unpack(rigi2.lCenter)

    -- x，y方向的侵入量
    local crashX = rigi1.nWidth/2 + rigi2.nWidth/2 - math.abs(rigi1.lCenter[1] - rigi2.lCenter[1])
    local crashY = rigi1.nHight/2 + rigi2.nHight/2 - math.abs(rigi1.lCenter[2] - rigi2.lCenter[2])
    -- 单位1相对单位2在哪一边
    local bRigi1Left = rigi1.lCenter[1] < rigi2.lCenter[1]
    local bRigi1Up = rigi1.lCenter[2] > rigi2.lCenter[2]
    
    -- 判断碰撞方向，取侵入较小的方向
    if crashY > crashX then
        local nRigi1MoveX = crashX * unit2.nMass / (unit1.nMass + unit2.nMass)
        local nRigi2MoveX = crashX * unit1.nMass / (unit1.nMass + unit2.nMass)
        rigi1.lCenter = {bRigi1Left and rigi1X - nRigi1MoveX or rigi1X + nRigi1MoveX, rigi1Y}
        rigi2.lCenter = {bRigi1Left and rigi2X + nRigi2MoveX or rigi2X - nRigi2MoveX, rigi2Y}
    else
        local nRigi1MoveY = crashY * unit2.nMass / (unit1.nMass + unit2.nMass)
        local nRigi2MoveY = crashY * unit1.nMass / (unit1.nMass + unit2.nMass)
        rigi1.lCenter = {rigi1X, bRigi1Up and rigi1Y + nRigi1MoveY or rigi1Y - nRigi1MoveY}
        rigi2.lCenter = {rigi2X, bRigi1Up and rigi2Y - nRigi2MoveY or rigi2Y + nRigi2MoveY}
    end

    -- 1.
    local bUnit1TryFirst = isUnitNoCrash(unit1, unit2)
    local bUnit2TryFirst = isUnitNoCrash(unit2, unit1)
    if bUnit1TryFirst and bUnit2TryFirst then
        unit1:setPosi(unpack(rigi1.lCenter))
        unit2:setPosi(unpack(rigi2.lCenter))
        return
    end

    -- 2.
    if not bUnit1TryFirst then
        rigi1.lCenter = {rigi1X, rigi1Y}
        if crashY > crashX then
            local nRigi2MoveX = crashX
            rigi2.lCenter = {bRigi1Left and rigi2X + nRigi2MoveX or rigi2X - nRigi2MoveX, rigi2Y}
        else
            local nRigi2MoveY = crashY
            rigi2.lCenter = {rigi2X, bRigi1Up and rigi2Y - nRigi2MoveY or rigi2Y + nRigi2MoveY}
        end
        if isUnitNoCrash(unit2, unit1) then
            unit2:setPosi(unpack(rigi2.lCenter))
            return
        end
    end
    
    if not bUnit2TryFirst then
        rigi2.lCenter = {rigi2X, rigi2Y}
        if crashY > crashX then
            local nRigi1MoveX = crashX
            rigi1.lCenter = {bRigi1Left and rigi1X - nRigi1MoveX or rigi1X + nRigi1MoveX, rigi1Y}
        else
            local nRigi1MoveY = crashY
            rigi1.lCenter = {rigi1X, bRigi1Up and rigi1Y + nRigi1MoveY or rigi1Y - nRigi1MoveY}
        end
        if isUnitNoCrash(unit1, unit2) then
            unit1:setPosi(unpack(rigi1.lCenter))
            return
        end
    end

    rigi1.lCenter = {rigi1X, rigi1Y}
    rigi2.lCenter = {rigi2X, rigi2Y}
    print('doRigiUnitInCrash fail...')
end

local function doOneCrash(oUnit, toCrashUnit, dCrashRecord)
    if oUnit == toCrashUnit then
        return
    end
    if dCrashRecord[toCrashUnit] and dCrashRecord[toCrashUnit][oUnit] then
        return
    end

    dCrashRecord[oUnit][toCrashUnit] = true
    if rigibody.isCrash(oUnit.oRigiBody, toCrashUnit.oRigiBody) then
        if oUnit.bOpenRigi and toCrashUnit.bOpenRigi then
            doRigiUnitInCrash(oUnit, toCrashUnit)
        end

        oUnit:OnCrash(toCrashUnit)
        toCrashUnit:OnCrash(oUnit)
    end
end

-- 单次碰撞处理
local function doCrash()
    quadtree:Clear()
    for i, obj in ipairs(lPhysicsObject) do
        quadtree:Insert(obj)
    end
    
    local dCrashRecord = {}  -- 记录已检测的碰撞，避免同一次处理中重复触发回调
    for i, oUnit in ipairs(lPhysicsObject) do
        dCrashRecord[oUnit] = {}

        local lToCrashUnit = quadtree:FindToCrashObj({}, oUnit)
        for i, toCrashUnit in ipairs(lToCrashUnit) do
            doOneCrash(oUnit, toCrashUnit, dCrashRecord)
        end
    end
end

function getUnitList()
    return lPhysicsObject
end

function insertToUnitList(oUnit)
    table.insert(lPhysicsObject, oUnit)
end

function removeFromUnitList(oUnit)
    table.remove_v(lPhysicsObject, oUnit)
    if quadtree then
        quadtree:DeleteUnit(oUnit)
    end
end

function initQuadtree(mapItemLayer)
    local w = constant.MAP_WIDTH - constant.MAP_ZERO_POINT[1]
    local h = constant.MAP_HIGH - constant.MAP_ZERO_POINT[2]
    local lCenter = {constant.MAP_ZERO_POINT[1] + w / 2, constant.MAP_ZERO_POINT[2] + h / 2}

    local mapSquare = rigibody.cPhySquare:New(lCenter, w, h)
    quadtree = cQuadTree:New(1, mapSquare)

    -- 碰撞处理时间间隔
    mapItemLayer:DelayCall(0.1, function() 
        doCrash()
        return 0.001
    end)
    
    -- 测试
    -- mapItemLayer:DelayCall(0.1, function()
    --     local lastLaer = mapItemLayer:getChildByTag(50)
    --     if lastLaer then
    --         lastLaer:removeFromParent()
    --     end
    --     local layerTest = cc.Layer:create()
    --     mapItemLayer:addChild(layerTest)
    --     layerTest:setTag(50)
    --     quadtree:DrawAllTree(layerTest)
    --     quadtree:DrawAllUnit(layerTest)

    --     -- print('===============================')
    --     -- quadtree:PrintUnitInfo()
    --     return 1
    -- end)

    layerMapItem = mapItemLayer
end