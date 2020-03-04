
-- 公共常量模块
CreateLocalModule('_my_code.test.tiledmap_game.constant')

-- ========================== 地图相关
-- 地图块数量（加载地图后赋值）
MAP_X_NUM = 65
MAP_Y_NUM = 40
-- 地图大小（像素）
MAP_ZERO_POINT = {0, 19.46}
MAP_WIDTH = 3280
MAP_HIGH = 1640
-- 格子大小（像素）
MAP_CELL_WIDTH = (MAP_WIDTH - MAP_ZERO_POINT[1]) / MAP_X_NUM
MAP_CELL_HIGH = (MAP_HIGH - MAP_ZERO_POINT[2]) / MAP_Y_NUM
-- 自底而上的地图层名称
MAP_LAYER1 = 'land'
MAP_LAYER2 = 'wall'
MAP_LAYER3 = 'top'
-- 地图下背景层的globalZ
MAP_BG_GZ = -2^10

-- 地图区域point
-- 出生区
MAP_START_AREA = {
    {16, 5}, {17, 5}, {18, 5}, {19, 5}, 
    {16, 6}, {17, 6}, {18, 6}, {19, 6}, 
    {16, 7}, {17, 7}, {18, 7}, {19, 7}, 
    {16, 8}, {17, 8}, {18, 8}, {19, 8}, 
    {16, 9}, {17, 9}, {18, 9}, {19, 9}
}
-- 电玩迷宫
MAP_MAZE_AREA = {{55, 9}, {56, 9}, {56, 8}, {56, 7}, {57, 7}}
-- 月牙湖祭坛
MAP_MAZE_AREA = {
              {51, 32}, {52, 32}, 
    {50, 33}, {51, 33}, {51, 33}, {51, 33}, 
    {50, 34}, {51, 34}, {51, 34}, {51, 34}, 
              {51, 35}, {52, 35}, 
}
-- 失落殿堂
MAP_HOUSE_AREA = {
    {14, 30}, {15, 30}, {16, 30}, {17, 30}, {18, 30}, {19, 30},
    {14, 31}, {15, 31}, {16, 31}, {17, 31}, {18, 31}, {19, 31},
    {14, 32}, {15, 32}, {16, 32}, {17, 32}, {18, 32}, {19, 32},
}
-- 失落殿堂操练场
MAP_HOUSE_GYM_AREA = {
    {7, 31}, {8, 31}, {9, 31},
    {7, 32}, {8, 32}, {9, 32},
    {7, 33}, {8, 33}, {9, 33},
}
-- 湖心岛
MAP_ISLAND_AREA = {
          {39, 23}, {40, 23}, 
{36, 24}, {39, 24}, {40, 24}, {41, 24},  
{38, 25}, {39, 25}, {40, 25}, {41, 25}, 
          {39, 26}, {40, 26},
}

-- 摄像机FLAG
MAP_CAMERA_FLAG = cc.CameraFlag.USER1
-- ========================== 地图相关

-- 刚体模型
RIGI_ROUND = 1
RIGI_SQUARE = 2

--============================ 人物相关
-- 精灵相对layer向上偏移量
CHILD_SP_DEFAULTY = 16
-- 动作状态机名称
CHILD_ACTION_STAND = 'stand'
CHILD_ACTION_WALK = 'walk'

-- 行走相关
CHILD_WALK_STEPTIME = 0.4  -- 步速（每一步时间）
CHILD_WALK_STEPHIGH = 20  -- 步高
CHILD_WALK_STEPWIDTH = 50  -- 步长

-- layer动作tag
CHILD_LAYER_ACTION_TAG_MOVE = 1  -- 移动定时器tag

-- sp动作tag
CHILD_SP_ACTION_TAG_MOVE = 1  -- 移动跳跃

-- 战场UI
CHILD_HP_TEXT_TAG = 1
CHILD_ATTACK_TEXT_TAG = 2
CHILD_FOCUS_TAG = 3

--============================ 人物相关