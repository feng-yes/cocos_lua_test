
local constant = require('_my_code.test.tiledmap_game.constant')
local childMgr = require('_my_code.test.tiledmap_game.unit.soldier.child_mgr')
local mapMgr = require('_my_code.test.tiledmap_game.map.mgr')
local controlPlayerMgr = require('_my_code.test.tiledmap_game.controller.player.mgr')
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

    -- 阵型数据
    self.warSides = {}
end

-- 创建一个角色，作为阵营1
function cWar:addWarSide1Player()
    local child1 = childMgr.createPlayer1()
    mapMgr.addChild(child1:getLayer())
    child1:setPosiByPoint(table.random_get(constant.MAP_START_AREA))

    print(self.warSides)
    if not self.warSides[1] then
        self.warSides[1] = {}
    end
    table.insert(self.warSides[1], child1)
    child1.nWarSide = 1

    self:setControlPlayer(child1)
end

function cWar:setControlPlayer(unit)
    controlPlayerMgr.setUnitAndOpenControl(unit)
    self.controlPlayer = unit
    self:setCameraObj(unit)
end

function cWar:setCameraObj(unit)
    if self._cameraObj then
        self._cameraObj.bCameraFocus = false
    end
    unit.bCameraFocus = true
    self._cameraObj = unit

    slot.emit(slotConstant.CAMERA_FOCUS_MOVE, {unit:getPosi()})
end

local oWar = cWar:New()

return oWar