
local function createMapTest()
    local funcMapLayer = require('_my_code.test.tiledmap_game.main')
    return funcMapLayer()
end

local function createYaogan()
    local layer = cc.Layer:create()
    local createYaoganLayer = require('_my_code.test.tiledmap_game.yaogan')
    local yaogan = createYaoganLayer()
    layer:addChild(yaogan)
    return layer
end

local function RunTest()
    -- 开始前先清除模块数据
    require('_my_code.test.tiledmap_game.reload')()

    -- tilmap需要深度测试
    cc.Director:getInstance():setDepthTest(true)
    local scene = cc.Scene:create()
	scene:addChild(createMapTest())
	scene:addChild(createYaogan())
	scene:addChild(CreateBackButton())
    return scene
end

return RunTest