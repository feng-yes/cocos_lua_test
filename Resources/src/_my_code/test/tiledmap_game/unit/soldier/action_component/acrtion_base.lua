cActionBase = CreateClass()

function cActionBase:__init__(mgr, soldier)
    self._mgr = mgr
    self._soldier = soldier
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

function cActionBase:HitFly(lPoint)
end

function cActionBase:Die()
end

return cActionBase