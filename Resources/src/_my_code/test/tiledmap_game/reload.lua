
-- 测试功能： 清空模块(重载)

local fInfo = debug.getinfo(1)
local aPath = string.sub(fInfo.source, 3)
aPath = string.gsub(aPath, 'reload.lua', '')

local function reloadDir(dirPath, dirFileList)
    local startIndex = #dirPath + 1
    for _, path in ipairs(dirFileList) do
        local isDir = string.sub(path, -1) == '/'
        local name = string.sub(path, startIndex, isDir and -2 or -1)
        if name ~= '.' and name ~= '..' then
            if isDir then
                local filePathList = cc.FileUtils:getInstance():listFiles(path)
                reloadDir(path, filePathList)
            else
                local aStartIndex = string.find(path, aPath)
                local toReloadPath = string.sub(path, aStartIndex)
                if string.sub(toReloadPath, -4) == '.lua' then
                    toReloadPath = string.sub(toReloadPath, 0, -5)
                end
                toReloadPath = string.gsub(toReloadPath, '/', '.')
                package.loaded[toReloadPath] = nil
            end
        end
    end
end

local function doReload()
    local filePathList = cc.FileUtils:getInstance():listFiles(aPath)
    local reloadFilePathList = {}
    for _, path in ipairs(filePathList) do
        if string.find(path, '/./') or string.find(path, '/../') or string.find(path, '/init.lua') then
            goto continue
        end
        table.insert(reloadFilePathList, path)
        ::continue::
    end
    reloadDir(aPath, reloadFilePathList)

    -- package.loaded['_my_code.test.tiledmap_game.camera.camera'] = nil
    -- package.loaded['_my_code.test.tiledmap_game.controller.keymap'] = nil
    -- package.loaded['_my_code.test.tiledmap_game.controller.game_mgr.game_panel'] = nil
    -- package.loaded['_my_code.test.tiledmap_game.controller.game_mgr.menu_panel'] = nil
    -- package.loaded['_my_code.test.tiledmap_game.controller.game_mgr.war_panel'] = nil
    -- package.loaded['_my_code.test.tiledmap_game.controller.player.yaogan'] = nil
    -- package.loaded['_my_code.test.tiledmap_game.controller.player.right_btn'] = nil
    -- package.loaded['_my_code.test.tiledmap_game.controller.player.mgr'] = nil
    -- package.loaded['_my_code.test.tiledmap_game.game.mgr'] = nil
    -- package.loaded['_my_code.test.tiledmap_game.game.war'] = nil
    -- package.loaded['_my_code.test.tiledmap_game.map.mgr'] = nil
    -- package.loaded['_my_code.test.tiledmap_game.map.interface'] = nil
    -- package.loaded['_my_code.test.tiledmap_game.map.tiledmap'] = nil
    -- package.loaded['_my_code.test.tiledmap_game.map.bg'] = nil
    -- package.loaded['_my_code.test.tiledmap_game.quadtree.mgr'] = nil
    -- package.loaded['_my_code.test.tiledmap_game.quadtree.quadtree'] = nil
    -- package.loaded['_my_code.test.tiledmap_game.res.button'] = nil
    -- package.loaded['_my_code.test.tiledmap_game.res.map_item'] = nil
    -- package.loaded['_my_code.test.tiledmap_game.res.text'] = nil
    -- package.loaded['_my_code.test.tiledmap_game.signal.signal_constant'] = nil
    -- package.loaded['_my_code.test.tiledmap_game.signal.signal'] = nil
    -- package.loaded['_my_code.test.tiledmap_game.unit.physics.physics_object'] = nil
    -- package.loaded['_my_code.test.tiledmap_game.unit.physics.rigidbody'] = nil
    -- package.loaded['_my_code.test.tiledmap_game.unit.beetle.action_component.acrtion_base'] = nil
    -- package.loaded['_my_code.test.tiledmap_game.unit.beetle.action_component.action_mgr'] = nil
    -- package.loaded['_my_code.test.tiledmap_game.unit.beetle.action_component.stand'] = nil
    -- package.loaded['_my_code.test.tiledmap_game.unit.beetle.action_component.jump'] = nil
    -- package.loaded['_my_code.test.tiledmap_game.unit.beetle.action_component.walk'] = nil
    -- package.loaded['_my_code.test.tiledmap_game.unit.beetle.action_component.boom'] = nil
    -- package.loaded['_my_code.test.tiledmap_game.unit.beetle.beetle_mgr'] = nil
    -- package.loaded['_my_code.test.tiledmap_game.unit.beetle.beetle'] = nil
    -- package.loaded['_my_code.test.tiledmap_game.unit.effect.boom.boom'] = nil
    -- package.loaded['_my_code.test.tiledmap_game.unit.soldier.action_component.acrtion_base'] = nil
    -- package.loaded['_my_code.test.tiledmap_game.unit.soldier.action_component.action_mgr'] = nil
    -- package.loaded['_my_code.test.tiledmap_game.unit.soldier.action_component.stand'] = nil
    -- package.loaded['_my_code.test.tiledmap_game.unit.soldier.action_component.walk'] = nil
    -- package.loaded['_my_code.test.tiledmap_game.unit.soldier.action_component.dead'] = nil
    -- package.loaded['_my_code.test.tiledmap_game.unit.soldier.action_component.hit_fly'] = nil
    -- package.loaded['_my_code.test.tiledmap_game.unit.soldier.action_component.invincible'] = nil
    -- package.loaded['_my_code.test.tiledmap_game.unit.soldier.skill_component.callBeetle'] = nil
    -- package.loaded['_my_code.test.tiledmap_game.unit.soldier.skill_component.skill_base'] = nil
    -- package.loaded['_my_code.test.tiledmap_game.unit.soldier.skill_component.skill_mgr'] = nil
    -- package.loaded['_my_code.test.tiledmap_game.unit.soldier.child_mgr'] = nil
    -- package.loaded['_my_code.test.tiledmap_game.unit.soldier.child'] = nil
    -- package.loaded['_my_code.test.tiledmap_game.constant'] = nil
end

return doReload