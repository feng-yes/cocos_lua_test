
local constant = require('_my_code.test.tiledmap_game.constant')
local physics_object = require('_my_code.test.tiledmap_game.unit.physics.physics_object')
local rigidbody = require('_my_code.test.tiledmap_game.unit.physics.rigidbody')
local mapMgr = require('_my_code.test.tiledmap_game.map.mgr')
local mapItem = require('_my_code.test.tiledmap_game.res.map_item')

local timeGrow = 0.2
local timeHold = 0.5
local rangeX = constant.BOOM_RANGE_X
local rangeY = constant.BOOM_RANGE_Y

local cBoom, Super = CreateClass(physics_object.cPhysicsBody)

function cBoom:__init__()
    Super.__init__(self)
    self.unitType = constant.WAR_EFFECT_TYPE_BOOM

    -- 波及的对象
    self._effectObj = {}

    self.layer = cc.Layer:create()
    self.layer:setCameraMask(constant.MAP_CAMERA_FLAG)
    mapMgr.addChild(self.layer)

    self:_initPhy()
    -- test
    self._bShowRange = false
end

function cBoom:_initPhy()
    local rigid = rigidbody.cPhySquare:New({self:getPosi()}, 0, 0)
    self:setRigiBody(rigid)
end

function cBoom:setPosi(x, y)
    Super.setPosi(self, x, y)
end

function cBoom:startBoom()

    local action = cc.Animate:create(mapItem.createBoomAni())

    local aniSp = cc.Sprite:create()
    self.layer:addChild(aniSp)
    aniSp:SetPosition(7, 6)
    aniSp:setCameraMask(constant.MAP_CAMERA_FLAG)
    aniSp:runAction(cc.Sequence:create(action, cc.CallFunc:create(function() 
        aniSp:removeFromParent()
        self:Destory()
    end)))

    local startTime = os.clock()
    self.layer:DelayCall(0, function()
        local delta = os.clock() - startTime
        -- local delta = cc.Director:getInstance():getDeltaTime()
        local oSquare = self.oRigiBody

        if delta < timeGrow then
            oSquare.nWidth = rangeX / timeGrow * delta
            oSquare.nHight = rangeY / timeGrow * delta
        elseif delta < timeHold then
        else
            oSquare.nWidth = 0
            oSquare.nHight = 0
            if self._bShowRange then
                if self._testColorLayer ~= nil then
                    self._testColorLayer:removeFromParent()
                    self._testColorLayer = nil
                end
            end
            return
        end
        
        if self._bShowRange then
            if self._testColorLayer ~= nil then
                self._testColorLayer:removeFromParent()
                self._testColorLayer = nil
            end
            local pColorLayer = cc.LayerColor:create(cc.c4b(255, 255, 255, 255 * .5), oSquare.nWidth, oSquare.nHight)
            pColorLayer:setPosition(cc.p(- oSquare.nWidth / 2, - oSquare.nHight / 2))
            self.layer:addChild(pColorLayer)
            -- mapInterface.resetorder(pColorLayer)
            pColorLayer:setCameraMask(constant.MAP_CAMERA_FLAG)
            self._testColorLayer = pColorLayer
        end
        return 0.01
    end)
end

function cBoom:OnCrash(oCrashObj)
    if oCrashObj.unitType == constant.WAR_UNIT_TYPE_CHILD then
        if not table.contents(self._effectObj, oCrashObj) then
            table.insert(self._effectObj, oCrashObj)
        end
    end
end

-- 单位调用的接口，检查是否已经波及
function cBoom:IsCrashUnit(oCrashObj)
    return table.contents(self._effectObj, oCrashObj) 
end

return cBoom