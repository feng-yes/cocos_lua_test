
-- 地图模块管理

local tiledmap = require('_my_code.test.tiledmap_game.map.tiledmap')

CreateLocalModule('_my_code.test.tiledmap_game.map.mgr')

local tagItemLayer = 1

local map = nil

function initMapLayer()
    local ret, mapObj = map.initLayer()
    map = mapObj

    -- 挂在地图的物体都放这个layer
    local layerItem = cc.Layer:create()
    map:addChild(layerItem, 0, tagItemLayer)

    return ret
end

function addChild(obj)
    local layerItem = map:getChildByTag(tagItemLayer)
    layerItem:addChild(obj)
end