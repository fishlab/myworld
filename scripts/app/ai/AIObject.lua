--
-- Author: Black Lotus
-- Date: 2014-09-27 22:41:43
--
--[[
一个简单的AI类
]]

local AIObject =class ("AIObject")

function AIObject:randomPosition(x,y,dist)
	local factorX = math.random(-dist,dist)
	local factorY = math.random(-dist,dist)
	return x+factorX,y+factorY
end

function AIObject:randomBool(val,max)
	return math.random(0,max) <val
end

--需要实现的方法
function AIObject:run(context)
end

return AIObject