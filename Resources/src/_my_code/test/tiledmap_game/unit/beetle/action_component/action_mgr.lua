
local constant = require('_my_code.test.tiledmap_game.constant')

local cActionMgr = CreateClass()

function cActionMgr:__init__(unit)
    self._unit = unit
    self._statusMap = {}
    self:_initStatus()
    self._nowStatusName = constant.BEETLE_ACTION_STAND
end

function cActionMgr:_initStatus()
    local actionList = {constant.BEETLE_ACTION_STAND, constant.BEETLE_ACTION_WALK, constant.BEETLE_ACTION_BOOM}
    for i, v in ipairs(actionList) do
        local cStatus = require('_my_code.test.tiledmap_game.unit.beetle.action_component.' .. v)
        self._statusMap[v] = cStatus:New(self, self._unit)
    end
end

function cActionMgr:changeStatus(oOldStatus, sNewStatus, lPara)
    oOldStatus:closeStatus()
    self._nowStatusName = sNewStatus
    self._statusMap[sNewStatus]:openStatus(lPara)
end

function cActionMgr:GetStatus()
    return self._nowStatusName
end

-- 输入
function cActionMgr:Move(nDirection, nSpeed)
    self._statusMap[self._nowStatusName]:Move(nDirection, nSpeed)
end

function cActionMgr:StopMove()
    self._statusMap[self._nowStatusName]:StopMove()
end

function cActionMgr:Attack(nNo)
    if nNo == constant.BEETLE_SKILL_BOOM then
        self._statusMap[self._nowStatusName]:Boom()
    end
end

return cActionMgr