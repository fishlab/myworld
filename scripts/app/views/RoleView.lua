--
-- Author: Black Lotus
-- Date: 2014-09-28 01:14:35
--


local RoleView = class("RoleView", function()
    return CCNode:create()
end)

RoleView.LEFT = -1
RoleView.RIGHT = 1

function RoleView:ctor(model)
	-- self.flipX=1
	self.direction = RoleView.RIGHT
	self.model=model
	self.sprite_=CCSprite:create()
    self:addChild(self.sprite_)
end

function RoleView:ajustDirection()
	 self.sprite_:runAction(CCScaleTo:create(0,self.direction, 1))
end
function RoleView:getDirection()
	return self.direction
end
function RoleView:turnOpposite()
	self.direction= -self.direction
	self:ajustDirection()
end
function RoleView:turnRight()
	self.direction = RoleView.RIGHT
	self:ajustDirection()
end
function RoleView:turnLeft()
	self.direction = RoleView.LEFT
	self:ajustDirection()
end
--[[
function RoleView:setDirection(direction)
    -- self.flipX=flipx
    self.direction =direction
    self.sprite_:runAction(CCScaleTo:create(0,direction, 1))
end

function RoleView:getFlipX()
    return self.flipX
end
]]

function RoleView:canAttackBack(tx,ty)
	local range = 100;
	local sx,sy = self:getPosition();
	if (self.direction == RoleView.RIGHT) then
		if (sx>tx) then
			return ccpDistance(ccp(sx,sy),ccp(tx, ty)) <= range
		end
	else
		if (sx<tx) then
			return ccpDistance(ccp(sx,sy),ccp(tx, ty)) <= range
		end
	end
    return false
end

--判断是否可以攻击
function RoleView:canAttack(tx,ty)
	local range = 100;
	local sx,sy = self:getPosition();
	if (self.direction == RoleView.RIGHT) then
		if (sx<tx) then
			return ccpDistance(ccp(sx,sy),ccp(tx, ty)) <= range
		end
	else
		if (sx>tx) then
			return ccpDistance(ccp(sx,sy),ccp(tx, ty)) <= range
		end
	end
    return false
end
--转向
function RoleView:turnTo(tpx,tpy)
	local fx,fy=self:getPosition()
	if (tpx<fx) then
		if (self.direction == RoleView.RIGHT) then
			self:turnLeft()
			--print("role view turn right")
			--self:turnRight()
		end
	else
		if (self.direction == RoleView.LEFT) then
			self:turnRight()
			--self:turnLeft()
		end
	end
end
--移动到指定坐标
function RoleView:moveTo(tpx, tpy)
	local fx,fy=self:getPosition()
	self:turnTo(tpx, tpy)
	local tgp =ccp(tpx, tpy)
	local act=CCMoveTo:create(ccpDistance(ccp(fx, fy),tgp) /self.model.velocity_, tgp)
	local arr=CCArray:create()
	arr:addObject(CCCallFunc:create(function()
		self.model:doEvent("move")
	end))
	arr:addObject(act)
	arr:addObject(CCCallFunc:create(function()
		self.model:doEvent("stop")
	end))
	self:stopAllActions()
	self:runAction(CCSequence:create(arr))
end

return RoleView