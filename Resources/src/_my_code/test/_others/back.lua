-- 公共返回按钮
function CreateBackButton(beforeFunc)
	local goBack = function()
        if beforeFunc then
            beforeFunc()
        end
        cc.Director:getInstance():popScene()
        -- 清理缓存
        cc.Director:getInstance():purgeCachedData()
	end
	
    local label = cc.Label:createWithTTF("back", s_arialPath, 20)
    label:setAnchorPoint(cc.p(0.5, 0.5))
    local MenuItem = cc.MenuItemLabel:create(label)
    MenuItem:registerScriptTapHandler(goBack)

    local s = cc.Director:getInstance():getOpenGLView():getVisibleRect()
    local Menu = cc.Menu:create()
    Menu:addChild(MenuItem)
    Menu:setPosition(0, 0)
    MenuItem:setPosition(s.width - 50, s.y + 25)

    return Menu
end