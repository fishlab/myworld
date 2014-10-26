--
-- Author: Black Lotus
-- Date: 2014-09-28 17:43:09
--


local AIObject = import(".AIObject")
-- local PlayerAI =class ("PlayerAI",function ()
-- 	return AIObject.new()
-- 	end)
local PlayerAI =class ("PlayerAI", AIObject)

function PlayerAI:ctor()
	-- self.actions =
end
function PlayerAI:randomAction()

end

-- function PlayerAI:nearPoint()
-- 	-- body
-- end

--运行ai
function PlayerAI:run(context)
	local mapsize=context.map:getContentSize()
	local player =context.player;
	local enemies = context.enemies;
	local px,py = player:getPosition()
	local pm = player.model

	if ( pm:isAlive() and pm:canAttack() ) then
		local e=0
		local enemiesToAttack={}
		for i =1, #enemies do
			local ev = enemies[i]
			if (ev) then
				local vx,vy = ev:getPosition()

			 	if (ev.model:isAlive() and player:canAttack(vx, vy) ) then
			 		enemiesToAttack[e]=ev
			 		e=e+1
			 	end
			 end

		 end
		if (e>0) then
			pm:attackAll(enemiesToAttack)
		else --转向

			for i =1, #enemies do
				local ev = enemies[i]
				if (ev) then
					local vx,vy = ev:getPosition()

				 	if (ev.model:isAlive() and player:canAttackBack(vx, vy) ) then
				 		enemiesToAttack[e]=ev
				 		e=e+1
				 	end
				end
		 	end
		 	if (e>0) then
		 		player:turnOpposite();
				pm:attackAll(enemiesToAttack)
			end
		end

	end

end

return PlayerAI