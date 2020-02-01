
local framePath = 'mysource/tilmap_game/map/map_item/map_item.plist'
cc.SpriteFrameCache:getInstance():addSpriteFrames(framePath)

local module = {}
module.stone = 'map_item011.png'
module.girl1 = 'map_item001.png'
module.boy1 = 'map_item003.png'
module.boy2 = 'map_item002.png'
module.boy3 = 'map_item004.png'

function module.createMapItem(frameName)
    return cc.Sprite:createWithSpriteFrameName(frameName)
end

return module