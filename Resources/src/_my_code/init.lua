--  入口

-- public
require "_my_code.public.lua_ext.print"
require "_my_code.public.lua_ext.table"
require "_my_code.public.lua_ext.functor"

require "_my_code.public.cocos_ext.timer"

-- my扩展菜单
local createMainScene = require("_my_code.test.menu")

-------------------------------------
--  my Test
-------------------------------------
function MyTestMain()
	local scene = createMainScene()
	scene:addChild(CreateBackMenuItem())

	return scene
end
