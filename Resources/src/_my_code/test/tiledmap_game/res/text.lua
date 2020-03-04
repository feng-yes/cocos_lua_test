
-- 文字

CreateLocalModule('_my_code.test.tiledmap_game.res.text')


function createTTF(fontSize)
    local ttfConfig = {}
    ttfConfig.fontFilePath="fonts/arial.ttf"
    ttfConfig.fontSize=fontSize or 18

    local label1 = cc.Label:createWithTTF(ttfConfig,"fonts/Marker Felt.ttf", cc.VERTICAL_TEXT_ALIGNMENT_CENTER, 0)
    -- label1:setTextColor( cc.c4b(0, 255, 0, 255))
    label1:setAnchorPoint( cc.p(0.5, 0.5) )
    return label1
end