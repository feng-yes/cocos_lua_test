
-- 公共常量模块
CreateLocalModule('_my_code.test.tiledmap_game.constant')

-- 地图相关
-- 地图块数量（加载地图后赋值）
MAP_X_NUM = 0
MAP_Y_NUM = 0
-- 自底而上的地图层名称
MAP_LAYER1 = 'land'
MAP_LAYER2 = 'wall'
MAP_LAYER3 = 'top'
-- 地图下背景层的globalZ
MAP_BG_GZ = -2^10

-- 刚体模型
RIGI_ROUND = 1
RIGI_SQUARE = 2

--============================ 人物相关
-- 精灵相对layer向上偏移量
CHILD_SP_DEFAULTY = 16
-- 动作状态机名称
CHILD_ACTION_STAND = 'stand'
CHILD_ACTION_WALK = 'walk'

-- layer动作tag
-- 移动定时器tag
CHILD_LAYER_ACTION_TAG_MOVE = 1

-- bg动作tag
-- 移动跳跃
CHILD_BG_ACTION_TAG_MOVE = 1

--============================