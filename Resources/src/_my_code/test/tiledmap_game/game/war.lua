
local constant = require('_my_code.test.tiledmap_game.constant')
local beetleMgr = require('_my_code.test.tiledmap_game.unit.beetle.beetle_mgr')
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
    self:_initData()
    self:_initConstant()
    self:_initSlot()
    self._initCrashModel()
end

function cWar:_initData()
    -- 控制
    self.controlPlayer = nil
    self.controlAi = {}
    -- 摄像机跟随对象
    self._cameraObj = nil

    -- 单位在ui状态层的排布
    self._warUiToUnits = {}
    -- 阵型数据
    self.warSides = {}

    -- 道具管理器
    self._itemMgr = nil
end

function cWar:_initConstant()
    -- 新增战场单位的处理
    self._unitAddFunMap = {
        [constant.WAR_UNIT_TYPE_CHILD] = functor(self._addPlayerAndSetSide, self),
        [constant.WAR_UNIT_TYPE_BEETLE] = functor(self._callBeetle, self),
    }
end

function cWar:_initSlot()
    slot.register(slotConstant.WAR_UI_FOCUS, functor(self.changeCameraStatus, self))
    slot.register(slotConstant.WAR_UNIT_ADD, functor(self._warUnitAdd, self))
    slot.register(slotConstant.WAR_UNIT_DEL, functor(self._delUnit, self))
    slot.register(slotConstant.WAR_ON_CRASH, functor(self._crashEvent, self))
end

-- ========== 增加或删除游戏单位 ==========

function cWar:_warUnitAdd(nUnitType, paramList)
    self._unitAddFunMap[nUnitType](unpack(paramList))
end

-- 创建一个角色及阵营
function cWar:_addPlayerAndSetSide(sSoilderPic, nSide, lArea)
    local oSoilder = childMgr.createPlayer(sSoilderPic)
    mapMgr.addChild(oSoilder:getLayer())
    oSoilder:setPosiByPoint(table.random_pop(lArea))

    if not self.warSides[nSide] then
        self.warSides[nSide] = {}
    end
    table.insert(self.warSides[nSide], oSoilder)
    oSoilder.nWarSide = nSide
    self:_setUnitId(oSoilder, sSoilderPic)
    oSoilder:UpdateWarUI()
    return oSoilder
end

-- 召唤虫子
function cWar:_callBeetle(oCallUnit, aimDirection)
    local oBee = beetleMgr.createBeetle()
    mapMgr.addChild(oBee:getLayer())
    oBee.nWarSide = oCallUnit.nWarSide
    table.insert(self.warSides[oCallUnit.nWarSide], oBee)
    oBee:setPosi(oCallUnit:getPosi())
    oBee:actJump(aimDirection)
    return oBee
end

-- 单位销毁时注销战场数据
function cWar:_delUnit(oUnit)
    if oUnit.unitType == constant.WAR_UNIT_TYPE_BEETLE then
        table.remove_v(self.warSides[oUnit.nWarSide], oUnit)
    end
    oUnit:Destory()
end

-- ========== 增加或删除游戏单位 ==========

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

    if unit.nWarUiId then
        slot.emit(slotConstant.WAR_UI_UNIT, unit.nWarUiId, constant.CHILD_FOCUS_TAG, true)
    end
    slot.emit(slotConstant.CAMERA_TOUCH_OPEN, false)
    slot.emit(slotConstant.CAMERA_FOCUS_MOVE, {unit:getPosi()})
end

function cWar:_removeCameraObj()
    self._cameraObj.bCameraFocus = false
    self._cameraObj = nil
end


-- ========== 道具 ==========
function cWar:StartItemSys()
    self._itemMgr = require('_my_code.test.tiledmap_game.unit.item.mgr'):New()
    self._itemMgr:StartFlash()
end
-- ========== 道具 ==========


-- ========== 碰撞 =========
function cWar:_initCrashModel()
    local crashModelMap = {
        {{constant.WAR_UNIT_TYPE_CHILD, constant.WAR_UNIT_ITEM}, function(oChild, oItem)
        end},
    }
end

function cWar:_crashEvent(oUnit1, oUnit2)
end
-- ========== 碰撞 ==========


function cWar:_setUnitId(unit, sSpPic)
    local nId = #self._warUiToUnits + 1
    unit.nWarUiId = nId
    self._warUiToUnits[nId] = unit
    warUnitUi.createChildInfo(nId, sSpPic)
end

local oWar = cWar:New()

return oWar