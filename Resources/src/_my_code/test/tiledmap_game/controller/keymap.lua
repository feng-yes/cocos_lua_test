
local slot = require('_my_code.test.tiledmap_game.signal.signal')
local slotConstant = require('_my_code.test.tiledmap_game.signal.signal_constant')

CreateLocalModule('_my_code.test.tiledmap_game.controller.keymap')

local key_map = {
    [124] = 'A',
    [142] = 'S',
    [127] = 'D',
    [146] = 'W',
    [133] = 'J',
    [134] = 'K',
    [6] = 'esc',
    [8] = 'tab',
}

onPressKey = {}

function initKeyBoard()
    local function onKeyPressed(keyCode, event)
        if key_map[keyCode] then
            table.insert(onPressKey, key_map[keyCode])
            slot.emit(slotConstant.KEYBOARD_PRESS, key_map[keyCode])
        end
    end

    local function onKeyReleased(keyCode, event)
        if key_map[keyCode] then
            table.remove_v(onPressKey, key_map[keyCode])
            slot.emit(slotConstant.KEYBOARD_RELEASE, key_map[keyCode])
        end
    end

    local layer = cc.Layer:create()
    local listener = cc.EventListenerKeyboard:create()
    listener:registerScriptHandler(onKeyPressed, cc.Handler.EVENT_KEYBOARD_PRESSED)  
    listener:registerScriptHandler(onKeyReleased, cc.Handler.EVENT_KEYBOARD_RELEASED)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, layer) 
    return layer
end
