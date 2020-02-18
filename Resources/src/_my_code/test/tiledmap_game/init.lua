

local function RunTest()
    -- 开始前先清除模块数据
    package.loaded['_my_code.test.tiledmap_game.reload'] = nil
    require('_my_code.test.tiledmap_game.reload')()

    local gameMgr = require('_my_code.test.tiledmap_game.game.mgr')
    return gameMgr.gameInit()
end

return RunTest