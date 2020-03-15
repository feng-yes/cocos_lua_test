-- 系统碰撞处理

local constant = require('_my_code.test.tiledmap_game.constant')
local cQuadTree = require('_my_code.test.tiledmap_game.quadtree.quadtree')
local rigibody = require('_my_code.test.tiledmap_game.unit.physics.rigidbody')

CreateLocalModule('_my_code.test.tiledmap_game.quadtree.mgr')

-- 物理体对象列表，进行碰撞检测
local lPhysicsObject = {}
local quadtree = nil

local function doOneCrash(oUnit, toCrashUnit, dCrashRecord)
    if oUnit == toCrashUnit then
        return
    end
    if dCrashRecord[toCrashUnit] and dCrashRecord[toCrashUnit][oUnit] then
        return
    end

    dCrashRecord[oUnit][toCrashUnit] = true
    if rigibody.isCrash(oUnit.oRigiBody, toCrashUnit.oRigiBody) then
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
    
    local dCrashRecord = {}  -- 记录已检测的碰撞，避免重复计算回调
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
        return 0.01
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
    --     -- quadtree:DrawAllTree(layerTest)
    --     quadtree:DrawAllUnit(layerTest)

    --     -- print('===============================')
    --     -- quadtree:PrintUnitInfo()
    --     return 1
    -- end)

    layerMapItem = mapItemLayer
end