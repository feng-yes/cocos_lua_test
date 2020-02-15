
local gameMgr = require('_my_code.test.tiledmap_game.game.mgr')

local function RunTest()
    -- 开始前先清除模块数据
    require('_my_code.test.tiledmap_game.reload')()

    return gameMgr.gameInit()
end

return RunTest