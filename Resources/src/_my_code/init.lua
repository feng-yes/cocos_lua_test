--  入口

-- public
require "_my_code.public.lua_ext.print"
require "_my_code.public.lua_ext.table"
require "_my_code.public.lua_ext.functor"
require "_my_code.public.lua_ext.class"
require "_my_code.public.lua_ext.myModule"

require "_my_code.public.cocos_ext.timer"
require "_my_code.public.cocos_ext.node"

-------------------------------------
--  my Test
-------------------------------------
function MyTestMain()
	-- my扩展菜单
	local createMainScene = require("_my_code.test.menu")
	local scene = createMainScene()
	scene:addChild(CreateBackMenuItem())

	return scene
end
