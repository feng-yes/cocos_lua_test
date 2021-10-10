
local constant = require('_my_code.test.tiledmap_game.constant')
local item_base = require('_my_code.test.tiledmap_game.unit.item.factory.item_base')
local mapItem = require('_my_code.test.tiledmap_game.res.map_item')

CreateLocalModule()

cItem, Super = CreateClass(item_base.cItemBase)

-- 初始化精灵
function cItem:initContentSp()
    self._spContent = mapItem.createMapItem(mapItem.beetle)
    self._spContent:setScale(0.8)
    self._spContent:SetPosition(0, 15)
end