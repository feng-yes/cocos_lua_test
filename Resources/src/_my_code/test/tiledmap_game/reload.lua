
local function doReload()
    package.loaded['_my_code.test.tiledmap_game.yaogan'] = nil
    package.loaded['_my_code.test.tiledmap_game.main'] = nil
    package.loaded['_my_code.test.tiledmap_game.signal.signal_constant'] = nil
    package.loaded['_my_code.test.tiledmap_game.signal.signal'] = nil
end

return doReload