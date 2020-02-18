
-- 地图模块管理

local tiledmap = require('_my_code.test.tiledmap_game.map.tiledmap')

CreateLocalModule('_my_code.test.tiledmap_game.map.mgr')

local tagItemLayer = 1

local map = nil

local function initMap()
    map:setScale(0.6)
    -- 挂在地图的物体都放这个layer
    local layerItem = cc.Layer:create()
    map:addChild(layerItem, 0, tagItemLayer)
end

function addChild(obj)
    print('addChild12',map)
    local layerItem = map:getChildByTag(tagItemLayer)
    layerItem:addChild(obj)
end

function initMapLayer()
    local ret, mapObj = tiledmap.initLayer()
    print('init1',mapObj)
    map = mapObj
    initMap()

    return ret
end
