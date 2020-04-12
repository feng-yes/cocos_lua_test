local constant = require('_my_code.test.tiledmap_game.constant')
local mapInterface = require('_my_code.test.tiledmap_game.map.interface')

local flyTime = 0.5
local downTimes = 1 / 100 
local flyAngle = 45

local base = require('_my_code.test.tiledmap_game.unit.soldier.action_component.acrtion_base')
local cAction, Super = CreateClass(base)

function cAction:__init__(mgr, soldier)
    Super.__init__(self, mgr, soldier)

    self._aimPosi = nil
    self._nFlyLong = 0
end

function cAction:openStatus(lPara)
    local lPoint = unpack(lPara)
    self._aimPosi = lPoint
    local xPosi, yPosi = self._soldier:getPosi()
    local movex = lPoint[1] - xPosi
    local movey = lPoint[2] - yPosi
    local nAngle = math.atan2(movey, movex)
    local nFlyLong = math.sqrt(movex * movex + movey * movey)
    self._nFlyLong = nFlyLong

    local beginStepTime = os.clock()
    local lastMoveTime = beginStepTime
    local function moveFun()
        local now = os.clock()
        local xPre, yPre = self._soldier:getPosi()
        local nLong = nFlyLong * (now - beginStepTime) / flyTime
        lastMoveTime = now

        local nXLong = nLong * math.cos(nAngle)
        local nYLong = nLong * math.sin(nAngle)
        local nAimX, nAimY = xPosi + nXLong, yPosi + nYLong

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
            self:_stepRepeat(moveFun)
            self._soldier:setFaceToAngle(nAngle)
        end
    end
    self:_stepRepeat(moveFun)

    -- jump
    local jumpAction = self._soldier:getSp():runAction(
        cc.Sequence:create(
            cc.Spawn:create(
                cc.JumpBy:create(flyTime, cc.p(0,0), nFlyLong / 2, 1),
                cc.Sequence:create(
                    cc.RotateBy:create(flyTime / 2, movex > 0 and flyAngle or -flyAngle),
                    cc.RotateBy:create(flyTime / 2, movex > 0 and -flyAngle or flyAngle)
                )
            ),
            cc.CallFunc:create(functor(self._finish, self))
        )
    )
    jumpAction:setTag(constant.CHILD_LAYER_ACTION_TAG_HIT_FLY)
end

function cAction:_stepRepeat(moveFun)
    local walkAction = self._soldier:getLayer():runAction(cc.Sequence:create(
        cc.DelayTime:create(0.001),
        cc.CallFunc:create(moveFun)
    ))
    walkAction:setTag(constant.CHILD_SP_ACTION_TAG_HIT_FLY)
end

function cAction:_reset()
    self._soldier:getLayer():stopActionByTag(constant.CHILD_SP_ACTION_TAG_HIT_FLY)
    -- self._soldier:getSp():stopActionByTag(constant.CHILD_LAYER_ACTION_TAG_HIT_FLY)
    self._soldier:getSp():SetPosition(0, constant.CHILD_SP_DEFAULTY)
end

function cAction:_finish()
    self:_reset()
    self._mgr:changeStatus(self, constant.CHILD_ACTION_INVINCIBLE, {downTimes * self._nFlyLong})
    self._aimPosi = nil
    self._nFlyLong = 0
end

function cAction:HitFly(lPoint)
end

return cAction
