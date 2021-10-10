
local constant = require('_my_code.test.tiledmap_game.constant')
local physics_object = require('_my_code.test.tiledmap_game.unit.physics.physics_object')
local rigidbody = require('_my_code.test.tiledmap_game.unit.physics.rigidbody')
local mapItem = require('_my_code.test.tiledmap_game.res.map_item')

CreateLocalModule('_my_code.test.tiledmap_game.unit.item.factory.item_base')

cItemBase, Super = CreateClass(physics_object.cPhysicsBody)

function cItemBase:__init__()
    Super.__init__(self)
    self.unitType = 0
    self.layer = cc.Layer:create()
    self._node = cc.Node:create()
    self.layer:addChild(self._node)

    self.nStatus = constant.ITEM_STATUS_READY

    self:_initSp()
    self:_initPhy()
end

function cItemBase:SetPoint(posList)
    self._lMapPoint = posList
end

-- 初始化精灵
function cItemBase:_initSp()
    self._spBox = mapItem.createMapItem(mapItem.box)
    self._spBoxGai = mapItem.createMapItem(mapItem.box_gai)
    self._node:addChild(self._spBox)
    self:initContentSp()
    self._node:addChild(self._spContent)
    self._node:addChild(self._spBoxGai)
    self._spBoxGai:SetPosition(0, 15)
    self._node:setScale(constant.ITEM_SP_BOX_SCALE)
    self.layer:setCameraMask(constant.MAP_CAMERA_FLAG)
end

function cItemBase:initContentSp()
    assert(false)
end

function cItemBase:_initPhy()
    local rigid = rigidbody.cPhySquare:New({self:getPosi()}, 30, 30)
    self:setRigiBody(rigid)
end

function cItemBase:Take(oUnit)
    self.nStatus = constant.ITEM_STATUS_GOT
end

