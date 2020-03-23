cActionBase = CreateClass()

function cActionBase:__init__(mgr, unit)
    self._mgr = mgr
    self._unit = unit
end

-- 进入状态(每个状态进入参量不同，直接列表传参)
function cActionBase:openStatus(lPara)
end

-- 退出状态
function cActionBase:closeStatus()
end

-- 输入
function cActionBase:Move(nDirection, nSpeed)
end

function cActionBase:StopMove()
end

function cActionBase:Jump(nDirection)
end

function cActionBase:Boom()
end

return cActionBase