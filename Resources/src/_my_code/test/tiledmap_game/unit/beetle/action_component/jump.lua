local constant = require('_my_code.test.tiledmap_game.constant')
local mapInterface = require('_my_code.test.tiledmap_game.map.interface')

local base = require('_my_code.test.tiledmap_game.unit.beetle.action_component.acrtion_base')
local cAction, Super = CreateClass(base)

function cAction:__init__(mgr, unit)
    Super.__init__(self, mgr, unit)

    self._startJumpPosi = nil
end

function cAction:openStatus(lPara)
    local nDirection = unpack(lPara)
    self._startJumpPosi = {self._unit:getPosi()}
    local beginStepTime = os.clock()
    local lastMoveTime = beginStepTime
    local function moveFun()
        local now = os.clock()
        local xPre, yPre = self._unit:getPosi()
        local nLong = constant.BEETLE_JUMP_SPEED * (now - lastMoveTime)
        lastMoveTime = now

        local nAngle = nDirection * math.pi / 180
        local nXLong = nLong * math.cos(nAngle)
        local nYLong = nLong * math.sin(nAngle)
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
            self:_stepRepeat(moveFun)
            self._unit:setFaceToAngle(nAngle)
        end
    end
    self:_stepRepeat(moveFun)

    -- jump
    local jumpAction = self._unit:getSp():runAction(
        cc.Sequence:create(
            cc.JumpBy:create(constant.BEETLE_JUMP_TIME, cc.p(0,0), constant.BEETLE_JUMP_HIGH, 1),
            cc.CallFunc:create(functor(self._finish, self))
        )
    )
    jumpAction:setTag(constant.BEETLE_SP_ACTION_TAG_JUMP)
end

function cAction:_stepRepeat(moveFun)
    local walkAction = self._unit:getLayer():runAction(cc.Sequence:create(
        cc.DelayTime:create(0.001),
        cc.CallFunc:create(moveFun)
    ))
    walkAction:setTag(constant.BEETLE_LAYER_ACTION_TAG_JUMP)
end

function cAction:_reset()
    self._unit:getLayer():stopActionByTag(constant.BEETLE_LAYER_ACTION_TAG_JUMP)
    -- self._soldier:getSp():stopActionByTag(constant.BEETLE_SP_ACTION_TAG_JUMP)
end

function cAction:_finish()
    self:_reset()
    self._mgr:changeStatus(self, constant.BEETLE_ACTION_STAND)
end

return cAction