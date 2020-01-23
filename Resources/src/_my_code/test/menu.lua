require "_my_code.test._others.back"

-- 测试名称及路径
local testCaseNames = {
	{name = 'cliping_node', path = '_my_code.test.cliping_node.test_cliping_node', autoReload = true},
	{name = 'replace_sprite_pic', path = '_my_code.test.replace_sprite_pic.test_replace_sprite_pic', autoReload = true},
}

local LINE_SPACE = 40
local allTests = {}

local function testCaseLoad()
	allTests = {}

	for i, caseList in pairs(testCaseNames) do
		-- 强制重新加载
		package.loaded[caseList.path] = nil
		local runTestFun = require(caseList.path)
		table.insert(allTests, {case_info = caseList, create_func = runTestFun})
	end

	print('reload finish!!!')
end

local function createMainLayer()
	local menu = cc.Menu:create()
	menu:setPosition(cc.p(0, 0))

	local s = cc.Director:getInstance():getWinSize()
	for i = 1, #allTests do
		local caseInfo = allTests[i].case_info
		local testLabel = cc.Label:createWithTTF(i .. ". " .. caseInfo.name, s_arialPath, 24)
		testLabel:setAnchorPoint(cc.p(0.5, 0.5))
		local testMenuItem = cc.MenuItemLabel:create(testLabel)
		testMenuItem:setPosition(cc.p(s.width / 2, (s.height - (i) * LINE_SPACE)))

		local function createTestScene()
			-- 创建测试场景前先重载测试模块并重新赋值
			if caseInfo.autoReload then
				package.loaded[caseInfo.path] = nil
				local runTestFun = require(caseInfo.path)
				allTests[i].create_func = runTestFun
			end

			-- 清理缓存
			cc.Director:getInstance():purgeCachedData()
			local testScene = allTests[i].create_func()
			if testScene then
				cc.Director:getInstance():pushScene(testScene)
			end
			return scene
		end
        testMenuItem:registerScriptTapHandler(createTestScene)
        menu:addChild(testMenuItem)
	end

	local layer = cc.Layer:create()
	layer:addChild(menu)
	return layer
end

local function createReloadBtn()
	local reload = function()
        testCaseLoad()
	end
	
    local label = cc.Label:createWithTTF("reload", s_arialPath, 20)
    label:setAnchorPoint(cc.p(0.5, 0.5))
    local MenuItem = cc.MenuItemLabel:create(label)
    MenuItem:registerScriptTapHandler(reload)

    local s = cc.Director:getInstance():getOpenGLView():getVisibleRect()
    local Menu = cc.Menu:create()
    Menu:addChild(MenuItem)
    Menu:setPosition(0, 0)
    MenuItem:setPosition(50, s.y + 25)

    return Menu
end

-------------------------------------
--  菜单入口
-------------------------------------
local function CreateMainScene()
	testCaseLoad()

	local scene = cc.Scene:create()
	scene:addChild(createMainLayer())
	scene:addChild(createReloadBtn())
	return scene
end

return CreateMainScene