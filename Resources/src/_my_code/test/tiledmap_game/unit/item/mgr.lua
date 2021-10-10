
-- 道具管理器

local constant = require('_my_code.test.tiledmap_game.constant')
local controllerMgr = require('_my_code.test.tiledmap_game.controller.game_mgr.game_panel')
local item_factory = require('_my_code.test.tiledmap_game.unit.item.factory.item_factory')
local mapMgr = require('_my_code.test.tiledmap_game.map.mgr')

local cItemMgr = CreateClass()

function cItemMgr:__init__()
    self:_initData()
end

function cItemMgr:_initData()
    -- 区域和物品刷新的表 { area : [item] }
    self._itemAreaMap = {}
    
    self:_initAreaMap()
end

function cItemMgr:_initAreaMap()
    for k,v in pairs(constant.MAP_AREA_POINT) do
        self._itemAreaMap[k] = {}
    end
end

function cItemMgr:StartFlash()
    -- local factory = item_factory.GetFactroyByType(constant.WAR_ITEM_TYPE_HEART)
    local factory = item_factory.GetFactroyByType(constant.WAR_ITEM_TYPE_BEETLE)
    local oItem = factory:CreateItem()
    mapMgr.addChild(oItem:getLayer())
    oItem:setPosiByPoint({16, 5})
end

return cItemMgr
