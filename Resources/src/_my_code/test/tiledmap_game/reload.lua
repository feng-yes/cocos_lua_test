
local function doReload()
    package.loaded['_my_code.test.tiledmap_game.controller.player.yaogan'] = nil
    package.loaded['_my_code.test.tiledmap_game.controller.player.mgr'] = nil
    package.loaded['_my_code.test.tiledmap_game.main'] = nil
    package.loaded['_my_code.test.tiledmap_game.signal.signal_constant'] = nil
    package.loaded['_my_code.test.tiledmap_game.signal.signal'] = nil
    package.loaded['_my_code.test.tiledmap_game.unit.physics.rigidbody'] = nil
    package.loaded['_my_code.test.tiledmap_game.res.map_item'] = nil
    package.loaded['_my_code.test.tiledmap_game.constant'] = nil
end

return doReload