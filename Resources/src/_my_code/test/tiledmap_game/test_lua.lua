local function test(a, b, c , d)
    print(a,b,c,d)
end

local function hoi()
    local func = functor(test, nil, 1, 3, nil)
    func()
end

local function RunTest()
    local scene = cc.Scene:create()
	hoi()
	scene:addChild(CreateBackButton())
    return scene
end

return RunTest