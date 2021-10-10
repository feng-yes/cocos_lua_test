
-- 工厂方法类

local constant = require('_my_code.test.tiledmap_game.constant')
local item_heart = require('_my_code.test.tiledmap_game.unit.item.factory.item_heart')
local item_beetle = require('_my_code.test.tiledmap_game.unit.item.factory.item_beetle')

CreateLocalModule('_my_code.test.tiledmap_game.unit.item.factory.item_factory')



local itemClassMap = {
    [constant.WAR_ITEM_TYPE_HEART] = item_heart.cItem,
    [constant.WAR_ITEM_TYPE_BEETLE] = item_beetle.cItem,
}

local itemFactoryClassMap = {}
-- 工厂实例，工厂可以复用，只需要全局保存一份
local itemFactoryObjMap = {}

for k,v in pairs(itemClassMap) do
    local factoryClass = CreateClass()
    factoryClass.__init__ = function(self) end
    factoryClass.CreateItem = function(self)
        return v:New()
    end
    itemFactoryClassMap[k] = factoryClass
end

function GetFactroyByType(nType)
    if not itemFactoryObjMap[nType] then
        itemFactoryObjMap[nType] = itemFactoryClassMap[nType]:New()
    end
    return itemFactoryObjMap[nType]
end