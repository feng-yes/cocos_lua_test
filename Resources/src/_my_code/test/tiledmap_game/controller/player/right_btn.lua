-- 右侧按钮区

local button = require('_my_code.test.tiledmap_game.res.button')
local mapItem = require('_my_code.test.tiledmap_game.res.map_item')
local slot = require('_my_code.test.tiledmap_game.signal.signal')
local slotConstant = require('_my_code.test.tiledmap_game.signal.signal_constant')

CreateLocalModule('_my_code.test.tiledmap_game.controller.player.right_btn')

local function createBtn1()
    local iconSp = mapItem.createMapItem(mapItem.beetle)
    local btnBgSp = cc.Sprite:create('mysource/tilmap_game/btn/y1.png')
    btnBgSp:addChild(iconSp)
    iconSp:setScale(1.8)
    iconSp:SetPosition('50%', '50%')
    iconSp:setRotation(-20)
    local btn = button.createWithSprite(btnBgSp)
    btn:SetPosition(VisibleRect:rightBottom().x - 80, VisibleRect:rightBottom().y + 30)
    btn:setScale(0.3)
    btn.openClick = function() 
        slot.emit(slotConstant.ATTACK, 1)
    end
    return btn
end

function initBtnLayer()
    btnLayer = cc.Layer:create()
    btnLayer:addChild(createBtn1())
    return btnLayer
end