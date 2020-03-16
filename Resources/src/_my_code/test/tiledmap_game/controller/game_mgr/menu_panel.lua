-- 菜单按钮

local constant = require('_my_code.test.tiledmap_game.constant')
local slot = require('_my_code.test.tiledmap_game.signal.signal')
local slotConstant = require('_my_code.test.tiledmap_game.signal.signal_constant')
local mapItem = require('_my_code.test.tiledmap_game.res.map_item')
local button = require('_my_code.test.tiledmap_game.res.button')
local textItem = require('_my_code.test.tiledmap_game.res.text')

CreateLocalModule('_my_code.test.tiledmap_game.controller.game_mgr.menu_panel')

local function createQuitBtn()
    local iconSp = cc.Sprite:create('ccb/btn-back-0.png')
    local btnBgSp = cc.Sprite:create('mysource/tilmap_game/btn/g1.png')
    btnBgSp:addChild(iconSp)
    iconSp:setScale(4)
    iconSp:SetPosition('50%', '50%')
    local btn = button.createWithSprite(btnBgSp)
    btn:SetPosition(VisibleRect:leftTop().x + 10, VisibleRect:leftTop().y - 40)
    btn:setScale(0.2)
    btn.openClick = function() 
        cc.Director:getInstance():popScene()
        -- 清理缓存
        cc.Director:getInstance():purgeCachedData()
    end
    return btn
end

function initLayer()
    mainLayer = cc.Layer:create()
    mainLayer:addChild(createQuitBtn())
    return mainLayer
end

