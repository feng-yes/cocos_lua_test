
local constant = require('_my_code.test.tiledmap_game.constant')
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
    local xPre, yPre = self._soldier:getPosi()
    local function moveFun()
        local nLong = constant.CHILD_WALK_STEPWIDTH * nSpeed / constant.CHILD_WALK_STEPTIME * (os.clock() - beginStepTime)
        local nXLong = nLong * math.cos(nDirection)
        local nYLong = nLong * math.sin(nDirection)
        self._soldier:setPosi(xPre + nXLong, yPre + nYLong)
        if os.clock() - beginStepTime < constant.CHILD_WALK_STEPTIME then
            self:_stepRepeat(moveFun)
        else
            self:_finishStep()
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