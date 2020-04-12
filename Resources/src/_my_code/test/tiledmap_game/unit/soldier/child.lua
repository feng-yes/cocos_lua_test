
local constant = require('_my_code.test.tiledmap_game.constant')
local physics_object = require('_my_code.test.tiledmap_game.unit.physics.physics_object')
local rigidbody = require('_my_code.test.tiledmap_game.unit.physics.rigidbody')
local slot = require('_my_code.test.tiledmap_game.signal.signal')
local slotConstant = require('_my_code.test.tiledmap_game.signal.signal_constant')
local cActionMgr = require('_my_code.test.tiledmap_game.unit.soldier.action_component.action_mgr')
local cSkillMgr = require('_my_code.test.tiledmap_game.unit.soldier.skill_component.skill_mgr')

local cChild, Super = CreateClass(physics_object.cPhysicsBody)

function cChild:__init__()
    Super.__init__(self)
    self.unitType = constant.WAR_UNIT_TYPE_CHILD
    self.layer = cc.Layer:create()
    self._sp = nil
    self._actionMgr = cActionMgr:New(self)
    self._skillMgr = cSkillMgr:New(self)

    self._nFaceDirection = 0

    -- 战场数据
    self.nWarUiId = 0
    self.nWarSide = 0

    -- 状态
    self._HP = 100
    self._BeeNums = 5

    self:_initPhy()
end

function cChild:_initPhy()
    local rigid = rigidbody.cPhySquare:New({self:getPosi()}, 30, 20)
    self:setRigiBody(rigid)
    self.nMass = constant.CHILD_PHY_MASS
    self.bOpenRigi = true
end

-- setSP是ui初始化最后一步，将setCameraMask放到这里
function cChild:setSp(sp)
    self._sp = sp
    self._sp:SetPosition(0, constant.CHILD_SP_DEFAULTY)
    self.layer:addChild(sp)
    self.layer:setCameraMask(constant.MAP_CAMERA_FLAG)
end

function cChild:setParent(parent, nZorder, nTag)
    parent:addChild(self.layer, nZorder, nTag)
end

-- 面朝方向
function cChild:setFaceToAngle(nAngle)
    self._nFaceDirection = nAngle / math.pi * 180
end

-- 状态量相关
function cChild:useBee()
    if self._BeeNums > 0 then
        self._BeeNums = self._BeeNums - 1
        slot.emit(slotConstant.WAR_UI_UNIT, self.nWarUiId, constant.CHILD_ATTACK_TEXT_TAG, self._BeeNums)
        return true
    end
end

function cChild:AddBees(nums)
    self._BeeNums = self._BeeNums + nums
    slot.emit(slotConstant.WAR_UI_UNIT, self.nWarUiId, constant.CHILD_ATTACK_TEXT_TAG, self._BeeNums)
end

function cChild:HPChange(changeNum)
    self._HP = self._HP + changeNum
    if self._HP <= 0 then
        self._HP = 0
        self:die()
    end
    slot.emit(slotConstant.WAR_UI_UNIT, self.nWarUiId, constant.CHILD_HP_TEXT_TAG, self._HP)
end

function cChild:UpdateWarUI()
    slot.emit(slotConstant.WAR_UI_UNIT, self.nWarUiId, constant.CHILD_ATTACK_TEXT_TAG, self._BeeNums)
    slot.emit(slotConstant.WAR_UI_UNIT, self.nWarUiId, constant.CHILD_HP_TEXT_TAG, self._HP)
end



function cChild:OnCrash(oCrashObj)
    if oCrashObj.unitType == constant.WAR_EFFECT_TYPE_BOOM and not oCrashObj:IsCrashUnit(self) then
        local xMy, yMy = self:getPosi()
        local xBoom, yBoom = oCrashObj:getPosi()
        local movex = xMy - xBoom
        local movey = yMy - yBoom
        local nDistance = math.sqrt(movex * movex + movey * movey)
        local nAngle = math.atan2(movey, movex)
        local nFlyLong = 2 * (constant.BOOM_RANGE_X - nDistance)
        self._actionMgr:HitFly({math.cos(nAngle) * nFlyLong + xMy, math.sin(nAngle) * nFlyLong + yMy})
        self:HPChange(-30)
    end
end

-- 动作指令
function cChild:actMove(bMove, nAngle, speed)
    if bMove then
        self._actionMgr:Move(nAngle, speed)
    else
        self._actionMgr:StopMove()
    end
end

function cChild:actAttack(nNo)
    self._skillMgr:Attack(nNo, self._nFaceDirection)
end

function cChild:die()
    self._actionMgr:Die()
end

return cChild