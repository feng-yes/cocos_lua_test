
-- 刚体及碰撞检测，坐标统一使用地图像素单位
local constant = require('_my_code.test.tiledmap_game.constant')

CreateLocalModule('_my_code.test.tiledmap_game.unit.physics.rigidbody')

-- 圆形碰撞体
cPhyRound = CreateClass()

function cPhyRound:__init__(lCenter, nRadius)
    self.type = constant.RIGI_ROUND
    -- 圆心
    self.lCenter = lCenter
    -- 半径
    self.nRadius = nRadius
end

-- 矩形碰撞体
cPhySquare = CreateClass()

function cPhySquare:__init__(lCenter, nWidth, nHight)
    self.type = constant.RIGI_SQUARE
    -- 中心点
    self.lCenter = lCenter
    self.nWidth = nWidth
    self.nHight = nHight
end

-- 圆 vs 圆
function CrashRtoR(oRound1, oRound2)
    local x = oRound1.lCenter[1] - oRound2.lCenter[1]
    local y = oRound1.lCenter[2] - oRound2.lCenter[2]
    local r = oRound1.nRadius + oRound2.nRadius
    return x * x + y * y < r * r
end

-- 矩形 vs 矩形
function CrashStoS(oSquare1, oSquare2)
    local xDistance = math.abs(oSquare1.lCenter[1] - oSquare2.lCenter[1])
    if xDistance > oSquare1.nWidth / 2 + oSquare2.nWidth / 2 then
        return false
    end

    local yDistance = math.abs(oSquare1.lCenter[2] - oSquare2.lCenter[2])
    if yDistance > oSquare1.nHight / 2 + oSquare2.nHight / 2 then
        return false
    end

    return true
end

function isCrash(rigi1, rigi2)
    if rigi1.type == constant.RIGI_ROUND and rigi2.type == constant.RIGI_ROUND then
        return CrashRtoR(rigi1, rigi2)
    elseif rigi1.type == constant.RIGI_SQUARE and rigi2.type == constant.RIGI_SQUARE then
        return CrashStoS(rigi1, rigi2)
    else
        assert(false, '未实现..')
    end
end
