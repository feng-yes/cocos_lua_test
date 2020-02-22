
local data = cc.FileUtils:getInstance():getStringFromFile('mysource/tilmap_game/map/logic_map.lua')

local env = {}
setfenv(loadstring(data), env)()

return env.map_data