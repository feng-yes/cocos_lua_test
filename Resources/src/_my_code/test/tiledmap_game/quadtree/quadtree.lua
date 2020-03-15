
-- 四叉树

local constant = require('_my_code.test.tiledmap_game.constant')
local rigibody = require('_my_code.test.tiledmap_game.unit.physics.rigidbody')

local cQuadTree = CreateClass()

function cQuadTree:__init__(iLevel, oSquare)
    self._iLevel = iLevel
    self._oSquare = oSquare
    self._lUnit = {}
    self._lQuadTree = {}
end

function cQuadTree:_split()
    if #self._lQuadTree > 0 then
        return
    end

    local nHalfW = self._oSquare.nWidth / 2
    local nHalfH = self._oSquare.nHight / 2

    local oSquare1 = rigibody.cPhySquare:New({self._oSquare.lCenter[1] + nHalfW / 2, self._oSquare.lCenter[2] + nHalfH / 2}, nHalfW, nHalfH)
    local childTree1 = cQuadTree:New(self._iLevel + 1, oSquare1)
    table.insert(self._lQuadTree, childTree1)

    local oSquare2 = rigibody.cPhySquare:New({self._oSquare.lCenter[1] - nHalfW / 2, self._oSquare.lCenter[2] + nHalfH / 2}, nHalfW, nHalfH)
    local childTree2 = cQuadTree:New(self._iLevel + 1, oSquare2)
    table.insert(self._lQuadTree, childTree2)

    local oSquare3 = rigibody.cPhySquare:New({self._oSquare.lCenter[1] - nHalfW / 2, self._oSquare.lCenter[2] - nHalfH / 2}, nHalfW, nHalfH)
    local childTree3 = cQuadTree:New(self._iLevel + 1, oSquare3)
    table.insert(self._lQuadTree, childTree3)

    local oSquare4 = rigibody.cPhySquare:New({self._oSquare.lCenter[1] + nHalfW / 2, self._oSquare.lCenter[2] - nHalfH / 2}, nHalfW, nHalfH)
    local childTree4 = cQuadTree:New(self._iLevel + 1, oSquare4)
    table.insert(self._lQuadTree, childTree4)
end

-- 单位归属于哪一象限的子树
function cQuadTree:_getIndex(oUnit)
    local oRigi = oUnit.oRigiBody
    local rigiX, rigiY = unpack(oRigi.lCenter)
    local rigiHalfW, rigiHalfH
    if oRigi.type == constant.RIGI_SQUARE then
        rigiHalfW, rigiHalfH = oRigi.nWidth / 2, oRigi.nHight / 2
    elseif oRigi.type == constant.RIGI_ROUND then
        rigiHalfW, rigiHalfH = oRigi.nRadius, oRigi.nRadius
    end

    local treeX, treeY = unpack(self._oSquare.lCenter)
    if rigiX - rigiHalfW > treeX then
        if rigiY - rigiHalfH > treeY then
            return 1
        end
        if rigiY + rigiHalfH < treeY then
            return 4
        end
    end
    if rigiX + rigiHalfW < treeX then
        if rigiY - rigiHalfH > treeY then
            return 2
        end
        if rigiY + rigiHalfH < treeY then
            return 3
        end
    end

    return -1
end

function cQuadTree:GetRigiObj()
    return self._oSquare
end

function cQuadTree:Clear()
    self._lUnit = {}
    for i, childTree in ipairs(self._lQuadTree) do
        childTree:Clear()
    end
    self._lQuadTree = {}
end

-- 插入单位
function cQuadTree:Insert(oUnit)
    if #self._lQuadTree > 0 then
        local nIdx = self:_getIndex(oUnit)
        if nIdx ~= -1 then
            self._lQuadTree[nIdx]:Insert(oUnit)
            return
        end
    end

    table.insert(self._lUnit, oUnit)
    -- 分块检查
    if #self._lUnit > constant.QUADTREE_MAX_OBJECTS and self._iLevel < constant.QUADTREE_MAX_LEVELS then
        if #self._lQuadTree > 0 then
            return
        end
        self:_split()
        local lNewUnit = {}
        for i, unit in ipairs(self._lUnit) do
            local nIdx = self:_getIndex(unit)
            if nIdx ~= -1 then
                self._lQuadTree[nIdx]:Insert(unit)
            else
                table.insert(lNewUnit, unit)
            end
        end
        self._lUnit = lNewUnit
    end
end

-- 树与单位是否有碰撞
function cQuadTree:_isUnitNearTree(oUnit, oQuadTree)
    local oRigi = oUnit.oRigiBody
    if oRigi.type == constant.RIGI_ROUND then
        oRigi = rigibody.cPhySquare:New(oRigi.lCenter, oRigi.nRadius * 2, oRigi.nRadius * 2)
    end
    return rigibody.isCrash(oRigi, oQuadTree:GetRigiObj())
end

-- 返回与目标单位可能碰撞的单位
function cQuadTree:FindToCrashObj(lReturnUnit, oUnit)
    local nIdx = self:_getIndex(oUnit)
    if #self._lQuadTree > 0 then
        if nIdx ~= -1 then
            self._lQuadTree[nIdx]:FindToCrashObj(lReturnUnit, oUnit)
        else
            for i, oChildTree in ipairs(self._lQuadTree) do
                if self:_isUnitNearTree(oUnit, oChildTree) then
                    oChildTree:FindToCrashObj(lReturnUnit, oUnit)
                end
            end
        end
    end

    table.extend(lReturnUnit, self._lUnit)
    return lReturnUnit
end

-- 从树中移除对象
function cQuadTree:DeleteUnit(oUnit)
    local bSuc = table.remove_v(self._lUnit, oUnit)
    if bSuc then
        return true
    end

    for i, childTree in ipairs(self._lQuadTree) do
        bSuc = childTree:DeleteUnit(oUnit)
        if bSuc then
            return true
        end
    end

    return false
end

-- ======================= debug ========================
function cQuadTree:PrintUnitInfo()
    print('--level:', self._iLevel)
    for i, unit in pairs(self._lUnit) do
        print(unit.oRigiBody.lCenter, unit.oRigiBody.nWidth, unit.oRigiBody.nHight)
    end
    for i, childTree in pairs(self._lQuadTree) do
        childTree:PrintUnitInfo(layer)
    end
end

function cQuadTree:DrawAllTree(layer)
    -- local mapInterface = require('_my_code.test.tiledmap_game.map.interface')
    local pColorLayer = cc.LayerColor:create(cc.c4b(math.random(255), math.random(255), math.random(255), 255 * .25), self._oSquare.nWidth, self._oSquare.nHight)
    pColorLayer:setPosition(cc.p(self._oSquare.lCenter[1] - self._oSquare.nWidth / 2, self._oSquare.lCenter[2] - self._oSquare.nHight / 2))
    -- mapInterface.resetorder(pColorLayer)
    layer:addChild(pColorLayer)
    pColorLayer:setCameraMask(constant.MAP_CAMERA_FLAG)
    for i, childTree in pairs(self._lQuadTree) do
        childTree:DrawAllTree(layer)
    end
end

function cQuadTree:DrawAllUnit(layer)
    -- local mapInterface = require('_my_code.test.tiledmap_game.map.interface')
    for i, unit in pairs(self._lUnit) do
        local oSquare = unit.oRigiBody
        local pColorLayer = cc.LayerColor:create(cc.c4b(math.random(255), math.random(255), math.random(255), 255 * .5), oSquare.nWidth, oSquare.nHight)
        pColorLayer:setPosition(cc.p(oSquare.lCenter[1] - oSquare.nWidth / 2, oSquare.lCenter[2] - oSquare.nHight / 2))
        layer:addChild(pColorLayer)
        -- mapInterface.resetorder(pColorLayer)
        pColorLayer:setCameraMask(constant.MAP_CAMERA_FLAG)
    end
    for i, childTree in pairs(self._lQuadTree) do
        childTree:DrawAllUnit(layer)
    end
end

return cQuadTree