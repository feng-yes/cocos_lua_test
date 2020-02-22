
-- 一些外调的地图相关接口放这里
local constant = require('_my_code.test.tiledmap_game.constant')

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
    return {(lPoint[1] + 0.5) * constant.MAP_CELL_WIDTH + xStart, (lPoint[2] + 0.5) * constant.MAP_CELL_WIDTH + yStart}
end