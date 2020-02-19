
local constant = require('_my_code.test.tiledmap_game.constant')

local cActionMgr = CreateClass()

function cActionMgr:__init__(soldier)
    self._soldier = soldier
    self._statusMap = {}
    self:_initStatus()
    self._nowStatusName = constant.CHILD_ACTION_STAND
end

function cActionMgr:_initStatus()
    local actionList = {constant.CHILD_ACTION_STAND, constant.CHILD_ACTION_WALK}
    for i, v in ipairs(actionList) do
        local cStatus = require('_my_code.test.tiledmap_game.unit.soldier.action_component.' .. v)
        self._statusMap[v] = cStatus:New(self, self._soldier)
    end
end

function cActionMgr:changeStatus(oOldStatus, sNewStatus, lPara)
    oOldStatus:closeStatus()
    self._nowStatusName = sNewStatus
    self._statusMap[sNewStatus]:openStatus(lPara)
end

-- 输入
function cActionMgr:Move(nDirection, nSpeed)
    self._statusMap[self._nowStatusName]:Move(nDirection, nSpeed)
end

function cActionMgr:StopMove()
    self._statusMap[self._nowStatusName]:StopMove()
end

return cActionMgr