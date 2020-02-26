
-- 战场ui

local constant = require('_my_code.test.tiledmap_game.constant')
local slot = require('_my_code.test.tiledmap_game.signal.signal')
local slotConstant = require('_my_code.test.tiledmap_game.signal.signal_constant')
local mapItem = require('_my_code.test.tiledmap_game.res.map_item')
local button = require('_my_code.test.tiledmap_game.res.button')
local textItem = require('_my_code.test.tiledmap_game.res.text')

CreateLocalModule('_my_code.test.tiledmap_game.controller.game_mgr.war_panel')

local mainLayer = nil

local function changeUnitStatus(nodeTag, orderTag, value)
    local layer = mainLayer:getChildByTag(nodeTag)
    local item = layer:getChildByTag(orderTag)
    if orderTag == constant.CHILD_FOCUS_TAG then
        item.SetCheck(value and 1 or 2)
    else
        item:setString(value)
    end
end

local function registerSlot()
    slot.register(slotConstant.WAR_UI_UNIT, changeUnitStatus)
end

function createChildInfo(tag)
    local layer = cc.Layer:create()
    layer:SetPosition(VisibleRect:rightTop().x-100, VisibleRect:rightTop().y-25 * tag + 10)

    local cameraAim = button.createCheckButton('mysource/tilmap_game/pic/eye1.png', 'mysource/tilmap_game/pic/eye0.png')
    cameraAim:SetPosition(-27, -8)
    cameraAim:setTag(constant.CHILD_FOCUS_TAG)
    cameraAim.OpenChange = function(nStatus) 
        slot.emit(slotConstant.WAR_UI_FOCUS, layer:getTag())
    end
    layer:addChild(cameraAim)

    local child = mapItem.createMapItem(mapItem.boy1)
    local childBtn = button.createWithSprite(child)
    childBtn:setScale(0.55)
    local width, height = childBtn:GetContentSize()
    childBtn:SetPosition(-10, -12)
    childBtn.openClick = function() 
    end
    layer:addChild(childBtn)

    local hpItem = mapItem.createMapItem(mapItem.heart)
    hpItem:setScale(0.35)
    hpItem:SetPosition(23, 0)
    layer:addChild(hpItem)

    local hptext = textItem.createTTF(13)
    hptext:setString(100)
    hptext:SetPosition(43, 0)
    hptext:setTag(constant.CHILD_HP_TEXT_TAG)
    layer:addChild(hptext)

    local attackItem = mapItem.createMapItem(mapItem.beetle)
    attackItem:setScaleY(0.4)
    attackItem:setScaleX(0.32)
    attackItem:SetPosition(65, 0)
    layer:addChild(attackItem)
    
    local attacktext = textItem.createTTF(13)
    attacktext:setString(0)
    attacktext:SetPosition(85, 0)
    attacktext:setTag(constant.CHILD_ATTACK_TEXT_TAG)
    layer:addChild(attacktext)

    layer:setTag(tag)

    mainLayer:addChild(layer)
end

function reSetNodePosi(nodeTag, newTag)
    local layer = mainLayer:getChildByTag(nodeTag)
    layer:SetPosition(VisibleRect:rightTop().x-100, VisibleRect:rightTop().y-25 * tag + 10)
    layer:setTag(newTag)
end

function initLayer()
    registerSlot()
    mainLayer = cc.Layer:create()
    return mainLayer
end