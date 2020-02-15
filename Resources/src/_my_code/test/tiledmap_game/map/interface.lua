
-- 其他模块需要调用的地图相关接口放这里

CreateLocalModule('_my_code.test.tiledmap_game.map.tiledmap')

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