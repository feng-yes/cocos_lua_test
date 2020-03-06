
-- 玩家控制管理器
-- 管理游戏玩法相关的输入

local slot = require('_my_code.test.tiledmap_game.signal.signal')
local slotConstant = require('_my_code.test.tiledmap_game.signal.signal_constant')
local physics_object = require('_my_code.test.tiledmap_game.unit.physics.physics_object')
local yaogan = require('_my_code.test.tiledmap_game.controller.player.yaogan')
local keymap = require('_my_code.test.tiledmap_game.controller.keymap')

CreateLocalModule('_my_code.test.tiledmap_game.controller.player.mgr')

-- 接受控制的单位
local unit = nil
local controlLayer = nil
local lastAngle = nil

local function KeyToGan()
    local nowMovePressList = keymap.getOnPressKeys({'W', 'A', 'S', 'D'})
    local sKey
    if #nowMovePressList >= 2 then
        sKey = nowMovePressList[#nowMovePressList] .. nowMovePressList[#nowMovePressList-1]
    elseif #nowMovePressList == 1 then
        sKey = nowMovePressList[1]
    end
    
    if sKey == 'A' then
        yaogan.setKeyActionA()
    elseif sKey == 'S' then
        yaogan.setKeyActionS()
    elseif sKey == 'D' then
        yaogan.setKeyActionD()
    elseif sKey == 'W' then
        yaogan.setKeyActionW()
    elseif sKey == 'AS' or sKey == 'SA' then
        yaogan.setKeyActionAS()
    elseif sKey == 'SD' or sKey == 'DS' then
        yaogan.setKeyActionSD()
    elseif sKey == 'DW' or sKey == 'WD' then
        yaogan.setKeyActionDW()
    elseif sKey == 'WA' or sKey == 'AW' then
        yaogan.setKeyActionWA()
    else
        yaogan.setActionStop()
    end
end

local function doPressKeyMap(sKey)
    if table.contents({'A', 'S', 'W', 'D'}, sKey) then
        KeyToGan()
    end
end

local function doReleaseKeyMap(sKey)
    if table.contents({'A', 'S', 'W', 'D'}, sKey) then
        KeyToGan()
    end
end

local function doTouchGan(bMove, nAngle, speed)
    if not bMove then
        unit:actMove(false)
        lastAngle = nil
        return
    end
    
    -- 大于15度的移动才生效
    -- if not lastAngle or math.abs(nAngle - lastAngle) > 15 / 180 * math.pi then
    unit:actMove(bMove, nAngle, speed)
    --     lastAngle = nAngle
    -- end
end

function initLayer()
    controlLayer = cc.Layer:create()
    controlLayer:addChild(yaogan.initYaoganLayer())
    return controlLayer
end

function setUnitAndOpenControl(oUnit)
    assert(oUnit:IsInstance(physics_object.cPhysicsBody))
    -- if unit then
    --     unSetUnit()
    -- end
    unit = oUnit
    
    -- 注册键盘事件
    slot.register(slotConstant.KEYBOARD_PRESS, doPressKeyMap)
    slot.register(slotConstant.KEYBOARD_RELEASE, doReleaseKeyMap)

    -- 注册移动事件（摇杆）
    slot.register(slotConstant.YAOGAN, doTouchGan)
end

function unSetUnit()
    unit = nil

    slot.unregister(slotConstant.KEYBOARD_PRESS, doPressKeyMap)
    slot.unregister(slotConstant.KEYBOARD_RELEASE, doReleaseKeyMap)
    slot.unregister(slotConstant.YAOGAN, doTouchGan)
end