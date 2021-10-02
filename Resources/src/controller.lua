
-- avoid memory leak
collectgarbage("setpause", 100) 
collectgarbage("setstepmul", 5000)

----------------
-- run
CC_USE_DEPRECATED_API = true
require "cocos.init"

local director = cc.Director:getInstance()
local glView   = director:getOpenGLView()
if nil == glView then
    glView = cc.GLViewImpl:createWithRect("Lua Tests", cc.rect(0,0,960,640))
    director:setOpenGLView(glView)
end

--turn on display FPS
director:setDisplayStats(true)

--set FPS. the default value is 1.0/60 if you don't call this
director:setAnimationInterval(1.0 / 60)

local screenSize = glView:getFrameSize()

local designSize = {width = 480, height = 320}

if screenSize.height > 320 then
    local resourceSize = {width = 960, height = 640}
    cc.Director:getInstance():setContentScaleFactor(resourceSize.height/designSize.height)
end

glView:setDesignResolutionSize(designSize.width, designSize.height, cc.ResolutionPolicy.NO_BORDER)

local fileUtils = cc.FileUtils:getInstance()
local function addSearchPath(resPrefix, height)
    local searchPaths = fileUtils:getSearchPaths()
    table.insert(searchPaths, 1, resPrefix)
    table.insert(searchPaths, 1, resPrefix .. "cocosbuilderRes")
    
    if screenSize.height > 320 then
        table.insert(searchPaths, 1, resPrefix .. "hd")
        table.insert(searchPaths, 1, resPrefix .. "ccs-res")
        table.insert(searchPaths, 1, resPrefix .. "ccs-res/hd")
    end

    fileUtils:setSearchPaths(searchPaths)

end

local function runScene(scene)
    if cc.Director:getInstance():getRunningScene() then
        cc.Director:getInstance():replaceScene(scene)
    else
        cc.Director:getInstance():runWithScene(scene)
    end
end

addSearchPath("res/", screenSize.height)
addSearchPath("", screenSize.height)

require "VisibleRect"
require "testResource"
require "helper"
-- require "mainMenu"

-- local scene = cc.Scene:create()
-- scene:addChild(CreateTestMenu())
-- if cc.Director:getInstance():getRunningScene() then
--     cc.Director:getInstance():replaceScene(scene)
-- else
--     cc.Director:getInstance():runWithScene(scene)
-- end

-- 直接加载我的测试用例
require "Resources.src._my_code.init"
function RunMyCode()
    cc.Director:getInstance():purgeCachedData()
    local testScene = MyTestMain()
    runScene(testScene)
end

-- RunMyCode()
local startGameScene = require('_my_code.test.tiledmap_game.init')
runScene(startGameScene())