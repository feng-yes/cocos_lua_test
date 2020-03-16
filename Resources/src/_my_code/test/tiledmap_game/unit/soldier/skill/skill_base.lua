cSkillBase = CreateClass()

function cSkillBase:__init__(soldier)
    self._soldier = soldier

    self._nNo = 0
    self._cooldownTime = 0

    self._nLastUsedTime = 0
end

-- 技能效果（需要复写）
function cSkillBase:Release(lPara)
end

function cSkillBase:Call(lPara)
    if os.clock() - self._nLastUsedTime <= self._cooldownTime then
        print('技能冷却中，剩余' .. os.clock() - self._nLastUsedTime .. 's')
        return
    end
    Release(lPara)
    self._nLastUsedTime = os.clock()
end

return cSkillBase