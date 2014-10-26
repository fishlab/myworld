--
-- Author: Black Lotus
-- Date: 2014-09-27 22:13:39
--

local EnemyAI = import(".EnemyAI")
local PlayerAI = import(".PlayerAI")

local AIManager =class ("AIManager")
local AI_REG = {}
AI_REG["enemy"] = EnemyAI.new()
AI_REG["player"] =PlayerAI.new()

function AIManager.getAI(name)
	return AI_REG [name]
end
function AIManager.addAI(name,aiObj)
	AI_REG[name] = aiObj
end
-- local INSTANCE = AIManager.new()
-- return INSTANCE

return AIManager