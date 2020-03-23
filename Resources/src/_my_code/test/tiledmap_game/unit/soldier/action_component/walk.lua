
local constant = require('_my_code.test.tiledmap_game.constant')
local camera = require('_my_code.test.tiledmap_game.camera.camera')
local mapInterface = require('_my_code.test.tiledmap_game.map.interface')

local base = require('_my_code.test.tiledmap_game.unit.soldier.action_component.acrtion_base')
local cAction, Super = CreateClass(base)

function cAction:__init__(mgr, soldier)
    Super.__init__(self, mgr, soldier)

    self._nextActionMove = true
    self._nextMovePara = {}
end

function cAction:_stepRepeat(moveFun)
    local walkAction = self._soldier:getLayer():runAction(cc.Sequence:create(
        cc.DelayTime:create(0.001),
        cc.CallFunc:create(moveFun)
    ))
    walkAction:setTag(constant.CHILD_LAYER_ACTION_TAG_MOVE)
end

function cAction:openStatus(lPara)
    self._nextActionMove = true
    local nDirection, nSpeed = unpack(lPara)
    self._nextMovePara = {nDirection, nSpeed}

    -- move
    local beginStepTime = os.clock()
    local lastMoveTime = beginStepTime
    local function moveFun()
        local now = os.clock()
        local xPre, yPre = self._soldier:getPosi()
        local nLong = constant.CHILD_WALK_STEPWIDTH * nSpeed / constant.CHILD_WALK_STEPTIME * (now - lastMoveTime)
        lastMoveTime = now

        local nXLong = nLong * math.cos(nDirection)
        local nYLong = nLong * math.sin(nDirection)
        local nAimX, nAimY = xPre + nXLong, yPre + nYLong

        local bCango = mapInterface.canGotoPosi(self._soldier, {nAimX, nAimY})
        if not bCango then
            -- 修正
            local lAimPoint = mapInterface.getPosiFix(self._soldier, {xPre, yPre}, {nAimX, nAimY})
            if lAimPoint then
                nAimX, nAimY = unpack(lAimPoint)
                bCango = true
            end
        end

        if bCango then
            self._soldier:setPosi(nAimX, nAimY)
            self._soldier:setFaceToAngle(nDirection)
            if now - beginStepTime < constant.CHILD_WALK_STEPTIME then
                self:_stepRepeat(moveFun)
            else
                self:_finishStep()
            end
        else
            -- 修正无效，不再逐帧计算
            local walkAction = self._soldier:getLayer():runAction(cc.Sequence:create(
                cc.DelayTime:create(beginStepTime + constant.CHILD_WALK_STEPTIME - now),
                cc.CallFunc:create(functor(self._finishStep, self))
            ))
            walkAction:setTag(constant.CHILD_LAYER_ACTION_TAG_MOVE)
        end
    end
    self:_stepRepeat(moveFun)

    -- jump
    local jumpAction = self._soldier:getSp():runAction(
        cc.JumpBy:create(constant.CHILD_WALK_STEPTIME, cc.p(0,0), constant.CHILD_WALK_STEPHIGH, 1)
    )
    jumpAction:setTag(constant.CHILD_SP_ACTION_TAG_MOVE)
end

function cAction:_reset()
    self._soldier:getLayer():stopActionByTag(constant.CHILD_LAYER_ACTION_TAG_MOVE)
    self._soldier:getSp():stopActionByTag(constant.CHILD_SP_ACTION_TAG_MOVE)
    self._soldier:getSp():SetPosition(0, constant.CHILD_SP_DEFAULTY)
end

function cAction:_finishStep()
    self:_reset()
    if self._nextActionMove then
        self:openStatus(self._nextMovePara)
    else
        self._mgr:changeStatus(self, constant.CHILD_ACTION_STAND)
    end
end

function cAction:Move(nDirection, nSpeed)
    self._nextActionMove = true
    self._nextMovePara = {nDirection, nSpeed}
end

function cAction:StopMove()
    self._nextActionMove = false
end

return cAction