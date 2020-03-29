

-- 人物及物品合图
local framePath = 'mysource/tilmap_game/map/map_item/map_item.plist'
cc.SpriteFrameCache:getInstance():addSpriteFrames(framePath)

CreateLocalModule('_my_code.test.tiledmap_game.res.map_item')

stone = 'map_item011.png'
girl1 = 'map_item001.png'
boy1 = 'map_item003.png'
boy2 = 'map_item004.png'
boy3 = 'map_item002.png'
king = 'map_item005.png'

key = 'map_item006.png'
heart = 'map_item010.png'
beetle = 'map_item009.png'

function createMapItem(frameName)
    return cc.Sprite:createWithSpriteFrameName(frameName)
end

-- 爆炸动画

local function buildBoomAni()
    local animationBoom = cc.Animation:create()
    local number, name
    for i = 48, 0, -1 do
        if i < 10 then
            number = "0"..i
        else
            number = i
        end
        name = "mysource/tilmap_game/ani/boom/boom_00"..number..".png"
        animationBoom:addSpriteFrameWithFile(name)
    end
    animationBoom:setDelayPerUnit(2 / 49.0)
    animationBoom:setRestoreOriginalFrame(true)
    return animationBoom
end

function createBoomAni()
    return buildBoomAni()
end