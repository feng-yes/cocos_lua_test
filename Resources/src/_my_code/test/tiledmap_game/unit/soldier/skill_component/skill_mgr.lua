
local cSkillMgr = CreateClass()

function cSkillMgr:__init__(soldier)
    self._soldier = soldier
    self._skillMap = {}
    self:_initSkills()
end

function cSkillMgr:_initSkills()
    local skillList = {'_my_code.test.tiledmap_game.unit.soldier.skill_component.callBeetle'}
    for i, v in ipairs(skillList) do
        local cSKill = require(v)
        local oSkill = cSKill:New(self._soldier)
        self._skillMap[oSkill:GetNo()] = oSkill
    end
end

-- 输入
function cSkillMgr:Attack(nNo, nDirection)
    if self._skillMap[nNo] then
        self._skillMap[nNo]:Call(nDirection)
    else
        print('no this skill ' .. nNo)
    end
end

return cSkillMgr