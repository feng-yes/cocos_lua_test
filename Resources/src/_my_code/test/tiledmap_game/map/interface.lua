
-- 一些外调的地图相关接口放这里
local constant = require('_my_code.test.tiledmap_game.constant')
local map_data = require('_my_code.test.tiledmap_game.res.map_physics')

CreateLocalModule('_my_code.test.tiledmap_game.map.interface')

-- 所有地图上的物体y方向移动后需要重设zorder
function resetorder(sp)
    local p = cc.p(sp:getPosition())
    p = CC_POINT_POINTS_TO_PIXELS(p)
    sp:setPositionZ( -( (p.y+81) /81) )
    -- 开启深度检测后，涉及到几个重叠节点的显示还是会受localz大小影响，统一设置localz=0无果，设置比较大的值后就正常了，先这么用吧-_-
    -- 保证靠前的节点zorder大一些则正常显示
    sp:setLocalZOrder(10000 - math.floor((p.y+81) /81*100))
    -- print(10000 - math.floor((p.y+81) /81*100))
    -- print(sp:getPositionZ())
end


function addProjectionEvent(node)
    -- 地图层设置cc_vertexz后，不设置2d项目，cc_vertexz ~= 0的层都显示不出来，需要设置为2d项目才可以正常显示
    -- DEFAULT下tiledmap会有移动节点时不同层位移不一样的3d视觉效果
    local function onNodeEvent(event)
        if event == "enter" then
            cc.Director:getInstance():setProjection(cc.DIRECTOR_PROJECTION2_D )
        elseif event == "exit" then
            cc.Director:getInstance():setProjection(cc.DIRECTOR_PROJECTION_DEFAULT )
        end
    end

    node:registerScriptHandler(onNodeEvent)
end

function getMapPoint(lPosi)
    local xStart, yStart = unpack(constant.MAP_ZERO_POINT)
    local x = math.floor((lPosi[1] - xStart) / constant.MAP_CELL_WIDTH) 
    local y = math.floor((lPosi[2] - yStart) / constant.MAP_CELL_HIGH)
    return {x, y}
end

function getMapPosi(lPoint)
    local xStart, yStart = unpack(constant.MAP_ZERO_POINT)
    return {(lPoint[1] + 0.5) * constant.MAP_CELL_WIDTH + xStart, (lPoint[2] + 0.5) * constant.MAP_CELL_HIGH + yStart}
end

-- 获取格子边界（左下x，左下y，右上x，右上y）
function getMapPosiSide(lPoint)
    local xStart, yStart = unpack(constant.MAP_ZERO_POINT)
    return {
        lPoint[1] * constant.MAP_CELL_WIDTH + xStart, 
        lPoint[2] * constant.MAP_CELL_WIDTH + yStart,
        (lPoint[1] + 1) * constant.MAP_CELL_WIDTH + xStart, 
        (lPoint[2] + 1) * constant.MAP_CELL_WIDTH + yStart
    }
end

-- 判断地图障碍点
function isMapPointLegal(lPoint)
    local x, y = unpack(lPoint)
    if x < 0 or x >= constant.MAP_X_NUM or y < 0 or y >= constant.MAP_Y_NUM then
        return false
    end
    return map_data[#map_data - y][x + 1] == 0
end

function isMapPosiInLegalPoint(lPosi)
    return isMapPointLegal(getMapPoint(lPosi))
end

-- 目标点是否可达，从视觉效果，上下可贴墙，左右不可贴墙
function canGotoPosi(unit, lPosi)
    local physics_object = require('_my_code.test.tiledmap_game.unit.physics.physics_object')
    assert(unit:IsInstance(physics_object.cPhysicsBody))
    local bPosiInLegal = isMapPosiInLegalPoint(lPosi)
    if not unit.bPhysics or not bPosiInLegal then
        return bPosiInLegal
    end

    local xPoint, yPoint = unpack(getMapPoint(lPosi))

    local bLeftPointLegal = isMapPointLegal({xPoint - 1, yPoint})
    local bRightPointLegal = isMapPointLegal({xPoint + 1, yPoint})
    if bLeftPointLegal and bRightPointLegal then
        return true
    end

    local minX, minY, maxX, maxY = unpack(getMapPosiSide(getMapPoint(lPosi)))
    local nHalfWidth = 0
    if unit.oRigiBody.type == constant.RIGI_ROUND then
        nHalfWidth = unit.oRigiBody.nRadius
    elseif unit.oRigiBody.type == constant.RIGI_SQUARE then
        nHalfWidth = unit.oRigiBody.nWidth / 2
    end

    if not bLeftPointLegal then
        if lPosi[1] < minX + nHalfWidth then
            return false
        end
    end

    if not bRightPointLegal then
        if lPosi[1] > maxX - nHalfWidth then
            return false
        end
    end

    return true
end

-- 对目标点修正为可达点，找x方向或y方向的可达点
function getPosiFix(unit, lPrePosi, lAimPosi)
    local point1 = {lPrePosi[1], lAimPosi[2]}
    local point2 = {lAimPosi[1], lPrePosi[2]}
    if canGotoPosi(unit, point1) then
        return point1
    elseif canGotoPosi(unit, point2) then
        return point2
    end
end
