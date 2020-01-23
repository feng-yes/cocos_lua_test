--  入口

-- public
require "_my_code.public.print"
require "_my_code.public.table"

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
