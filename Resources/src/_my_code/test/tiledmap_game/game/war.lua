
local constant = require('_my_code.test.tiledmap_game.constant')
local childMgr = require('_my_code.test.tiledmap_game.unit.soldier.child_mgr')
local mapMgr = require('_my_code.test.tiledmap_game.map.mgr')
local mapItem = require('_my_code.test.tiledmap_game.res.map_item')
local controlPlayerMgr = require('_my_code.test.tiledmap_game.controller.player.mgr')
local warUnitUi = require('_my_code.test.tiledmap_game.controller.game_mgr.war_panel')
local slot = require('_my_code.test.tiledmap_game.signal.signal')
local slotConstant = require('_my_code.test.tiledmap_game.signal.signal_constant')

-- 管理游戏战场

local cWar = CreateClass()

function cWar:__init__()
    -- 控制
    self.controlPlayer = nil
    self.controlAi = {}
    -- 摄像机跟随对象
    self._cameraObj = nil

    -- 单位在ui状态层的排布
    self._warUiToUnits = {}
    -- 阵型数据
    self.warSides = {}

    self:_initSlot()
end

function cWar:_initSlot()
    slot.register(slotConstant.WAR_UI_FOCUS, functor(self.changeCameraStatus, self))
end

-- 创建一个角色，作为阵营1
function cWar:addWarSide1Player(lArea)
    local child1 = childMgr.createPlayer1()
    mapMgr.addChild(child1:getLayer())
    child1:setPosiByPoint(table.random_pop(constant.MAP_START_AREA))

    if not self.warSides[1] then
        self.warSides[1] = {}
    end
    table.insert(self.warSides[1], child1)
    child1.nWarSide = 1
    self:setUnitId(child1, mapItem.boy1)
    return child1
end

-- 阵营2角色
function cWar:addWarSide2Player(lArea)
    local child2 = childMgr.createPlayer2()
    mapMgr.addChild(child2:getLayer())
    child2:setPosiByPoint(table.random_pop(constant.MAP_START_AREA))

    if not self.warSides[2] then
        self.warSides[2] = {}
    end
    table.insert(self.warSides[2], child2)
    child2.nWarSide = 2
    self:setUnitId(child2, mapItem.boy2)
    return child2
end

function cWar:setControlPlayer(unit)
    controlPlayerMgr.setUnitAndOpenControl(unit)
    self.controlPlayer = unit
    self:_setCameraObj(unit)
end

function cWar:changeCameraStatus(nId)
    if not self._cameraObj then
        self:_setCameraObj(self._warUiToUnits[nId])
        return
    end

    if self._warUiToUnits[nId] == self._cameraObj then
        self:_removeCameraObj()
        slot.emit(slotConstant.CAMERA_TOUCH_OPEN, true)
        slot.emit(slotConstant.WAR_UI_UNIT, nId, constant.CHILD_FOCUS_TAG, false)
        return
    end

    for id, unit in pairs(self._warUiToUnits) do
        if unit == self._cameraObj then
            self:_removeCameraObj()
            slot.emit(slotConstant.WAR_UI_UNIT, id, constant.CHILD_FOCUS_TAG, false)
            break
        end
    end
    self:_setCameraObj(self._warUiToUnits[nId])
end

function cWar:_setCameraObj(unit)
    unit.bCameraFocus = true
    self._cameraObj = unit

    slot.emit(slotConstant.WAR_UI_UNIT, unit.nWarUiId, constant.CHILD_FOCUS_TAG, true)
    slot.emit(slotConstant.CAMERA_TOUCH_OPEN, false)
    slot.emit(slotConstant.CAMERA_FOCUS_MOVE, {unit:getPosi()})
end

function cWar:_removeCameraObj()
    self._cameraObj.bCameraFocus = false
    self._cameraObj = nil
end

function cWar:setUnitId(unit, sSpPic)
    local nId = #self._warUiToUnits + 1
    unit.nWarUiId = nId
    self._warUiToUnits[nId] = unit
    warUnitUi.createChildInfo(nId, sSpPic)
end

local oWar = cWar:New()

return oWar