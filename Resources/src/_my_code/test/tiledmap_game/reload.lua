
local function doReload()
    package.loaded['_my_code.test.tiledmap_game.camera.camera'] = nil
    package.loaded['_my_code.test.tiledmap_game.controller.keymap'] = nil
    package.loaded['_my_code.test.tiledmap_game.controller.game_mgr.game_panel'] = nil
    package.loaded['_my_code.test.tiledmap_game.controller.player.yaogan'] = nil
    package.loaded['_my_code.test.tiledmap_game.controller.player.mgr'] = nil
    package.loaded['_my_code.test.tiledmap_game.game.mgr'] = nil
    package.loaded['_my_code.test.tiledmap_game.game.war'] = nil
    package.loaded['_my_code.test.tiledmap_game.map.mgr'] = nil
    package.loaded['_my_code.test.tiledmap_game.map.interface'] = nil
    package.loaded['_my_code.test.tiledmap_game.map.tiledmap'] = nil
    package.loaded['_my_code.test.tiledmap_game.map.bg'] = nil
    package.loaded['_my_code.test.tiledmap_game.res.map_item'] = nil
    package.loaded['_my_code.test.tiledmap_game.signal.signal_constant'] = nil
    package.loaded['_my_code.test.tiledmap_game.signal.signal'] = nil
    package.loaded['_my_code.test.tiledmap_game.unit.physics.physics_object'] = nil
    package.loaded['_my_code.test.tiledmap_game.unit.physics.rigidbody'] = nil
    package.loaded['_my_code.test.tiledmap_game.unit.soldier.action_component.acrtion_base'] = nil
    package.loaded['_my_code.test.tiledmap_game.unit.soldier.action_component.action_mgr'] = nil
    package.loaded['_my_code.test.tiledmap_game.unit.soldier.action_component.stand'] = nil
    package.loaded['_my_code.test.tiledmap_game.unit.soldier.action_component.walk'] = nil
    package.loaded['_my_code.test.tiledmap_game.unit.soldier.child_mgr'] = nil
    package.loaded['_my_code.test.tiledmap_game.unit.soldier.child'] = nil
    package.loaded['_my_code.test.tiledmap_game.constant'] = nil
end

return doReload