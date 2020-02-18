
local childMgr = require('_my_code.test.tiledmap_game.unit.soldier.child_mgr')
local mapMgr = require('_my_code.test.tiledmap_game.map.mgr')
local controlPlayerMgr = require('_my_code.test.tiledmap_game.controller.player.mgr')

-- 管理游戏战场

local cWar = CreateClass()

function cWar:__init__()
    -- 控制
    self.controlPlayer = nil
    self.controlAi = {}

    -- 阵型数据
    self.warSides = {}
end

-- 创建一个角色，作为阵营1
function cWar:addWarSide1Player()
    local child1 = childMgr.createPlayer1()
    mapMgr.addChild(child1:getLayer())
    self:setControlPlayer(child1)
end

function cWar:setControlPlayer(unit)
    controlPlayerMgr.setUnitAndOpenControl(unit)
    self.controlPlayer = unit
end

local oWar = cWar:New()

return cWar