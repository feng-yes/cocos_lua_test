
-- 地图模块管理

local tiledmap = require('_my_code.test.tiledmap_game.map.tiledmap')
local bg = require('_my_code.test.tiledmap_game.map.bg')

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
    local layerItem = map:getChildByTag(tagItemLayer)
    layerItem:addChild(obj)
end

function initMapLayer()
    local mainLayer = cc.Layer:create() 
    local ret, mapObj = tiledmap.initLayer()
    map = mapObj
    initMap()

    local bgSp = bg.createBG()
    mainLayer:addChild(bgSp)
    bgSp:SetPosition('50%', '50%')
    mainLayer:addChild(ret)
    return mainLayer
end
