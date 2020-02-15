
local framePath = 'mysource/tilmap_game/map/map_item/map_item.plist'
cc.SpriteFrameCache:getInstance():addSpriteFrames(framePath)

CreateLocalModule('_my_code.test.tiledmap_game.res.map_item')

stone = 'map_item011.png'
girl1 = 'map_item001.png'
boy1 = 'map_item003.png'
boy2 = 'map_item002.png'
boy3 = 'map_item004.png'

function createMapItem(frameName)
    return cc.Sprite:createWithSpriteFrameName(frameName)
end