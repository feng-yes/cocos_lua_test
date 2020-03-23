cSkillBase = CreateClass()

function cSkillBase:__init__(soldier)
    self._soldier = soldier

    self._nNo = 0
    self._cooldownTime = 0

    self._nLastUsedTime = 0
end

function cSkillBase:GetNo()
    return self._nNo
end

-- 技能效果（需要复写）
function cSkillBase:Release(nDirection)
end

function cSkillBase:Call(nDirection)
    if os.clock() - self._nLastUsedTime <= self._cooldownTime then
        print('技能冷却中，剩余' .. self._cooldownTime - (os.clock() - self._nLastUsedTime) .. 's')
        return
    end
    self:Release(nDirection)
    self._nLastUsedTime = os.clock()
end

return cSkillBase