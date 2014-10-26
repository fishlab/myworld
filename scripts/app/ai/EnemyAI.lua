--
-- Author: Black Lotus
-- Date: 2014-09-28 08:46:16
--

local AIObject = import(".AIObject")
-- local EnemyAI =class ("EnemyAI",function ()
-- 	return AIObject.new()
-- 	end)
local EnemyAI =class ("EnemyAI", AIObject)

function EnemyAI:ctor()
	-- self.actions =
end
function EnemyAI:randomAction()

end

-- function EnemyAI:nearPoint()
-- 	-- body
-- end
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
--运行ai
function EnemyAI:run(context,model,view)
	local mapsize=context.map:getContentSize()
	local player =context.player;
	local px,py = player:getPosition()
	local vx,vy = view:getPosition()
	local pm = player.model

	if ( pm:isAlive() ) then

		if (view:canAttack(px, py)and self:randomBool(70,100)) then --70%几率 攻击
			view:getModel():attack(player);
			--player.model:getInjured(model:getAttack()-player.model:getArmor())

		elseif (view:canSee(px, py) and self:randomBool(50,100) ) then --50%几率追击
			--移动到玩家附近的坐标
			view:turnTo(px, py)
			if(vx<px) then
				view:moveTo(px-50, py)
			else
				view:moveTo(px+50, py)
			end
		else
			local action = math.random(0,4)
			if (action == 0) then  --move
			local fx,fy =view:getPosition();
			local tgx,tgy=self:randomPosition(fx,fy,300)
			if (tgx+100>=mapsize.width) then tgx=mapsize.width-100 end
			if (tgy+200>=mapsize.height) then tgy=mapsize.height-200 end
			view:moveTo(tgx, tgy)
		end
		end
		-- pm:isAlive()
	else --其它动作
		local action = math.random(0,4)
		if (action == 0) then  --move
			local fx,fy =view:getPosition();
			local tgx,tgy=self:randomPosition(fx,fy,300)
			if (tgx+100>=mapsize.width) then
				tgx=mapsize.width-100
			elseif (tgx<0) then
				tgx=0
			end
			if (tgy+100>=mapsize.height) then
				tgy=mapsize.height-100
			elseif (tgy<0) then
				tgy=0
			end
			view:moveTo(tgx, tgy)
		end
	end


end

return EnemyAI