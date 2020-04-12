
local constant = require('_my_code.test.tiledmap_game.constant')
local camera = require('_my_code.test.tiledmap_game.camera.camera')
local mapInterface = require('_my_code.test.tiledmap_game.map.interface')

local base = require('_my_code.test.tiledmap_game.unit.beetle.action_component.acrtion_base')
local cAction, Super = CreateClass(base)

function cAction:__init__(mgr, unit)
    Super.__init__(self, mgr, unit)

    self._nextActionMove = true
    self._nextMovePara = {}
end

function cAction:_stepRepeat(moveFun)
    local walkAction = self._unit:getLayer():runAction(cc.Sequence:create(
        cc.DelayTime:create(0.001),
        cc.CallFunc:create(moveFun)
    ))
    walkAction:setTag(constant.BEETLE_LAYER_ACTION_TAG_MOVE)
end

function cAction:openStatus(lPara)
    self._nextActionMove = true
    local nDirection, nSpeed = unpack(lPara)
    self._nextMovePara = {nDirection, nSpeed}

    -- move
    local lastMoveTime = os.clock()
    local function moveFun()
        if not self._nextActionMove then
            self:_finishMove()
            return
        end
        local now = os.clock()
        local xPre, yPre = self._unit:getPosi()
        local nLong = constant.BEETLE_WALK_SPEED * self._nextMovePara[2] * (now - lastMoveTime)
        lastMoveTime = now

        local nXLong = nLong * math.cos(self._nextMovePara[1])
        local nYLong = nLong * math.sin(self._nextMovePara[1])
        local nAimX, nAimY = xPre + nXLong, yPre + nYLong

        local bCango = mapInterface.canGotoPosi(self._unit, {nAimX, nAimY})
        if not bCango then
            -- 修正
            local lAimPoint = mapInterface.getPosiFix(self._unit, {xPre, yPre}, {nAimX, nAimY})
            if lAimPoint then
                nAimX, nAimY = unpack(lAimPoint)
                bCango = true
            end
        end

        if bCango then
            self._unit:setPosi(nAimX, nAimY)
            self._unit:setFaceToAngle(self._nextMovePara[1])
            self:_stepRepeat(moveFun)
        else
            -- 修正无效
            self:_finishMove()
        end
    end
    self:_stepRepeat(moveFun)
end

function cAction:_reset()
    self._unit:getLayer():stopActionByTag(constant.BEETLE_LAYER_ACTION_TAG_MOVE)
end

function cAction:_finishMove()
    self:_reset()
    self._mgr:changeStatus(self, constant.BEETLE_ACTION_STAND)
end

function cAction:StopMove()
    self._nextActionMove = false
end

function cAction:Move(nDirection, nSpeed)
    self._nextActionMove = true
    self._nextMovePara = {nDirection, nSpeed}
end

function cAction:Boom()
    self._mgr:changeStatus(self, constant.BEETLE_ACTION_BOOM)
end

return cAction