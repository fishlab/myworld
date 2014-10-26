--
-- Author: Black Lotus
-- Date: 2014-09-25 14:59:56
--

--[[
角色Fox类
从Role类继承，增加了经验值等属性
]]

local Role = import(".Role")
local Fox = class("Fox", Role)

Fox.EXP_CHANGED_EVENT = "EXP_CHANGED_EVENT"
Fox.LEVEL_UP_EVENT    = "LEVEL_UP_EVENT"

Fox.schema = clone(Role.schema)
Fox.schema["exp"] = {"number", 0}
-- Fox.schema["nextLvExp"] = {"number", 0}

-- 升到下一级需要的经验值
Fox.NEXT_LEVEL_EXP = 50
local calculateExp=function (lv)
    return lv * Fox.NEXT_LEVEL_EXP / 2
end
function Fox:ctor(properties, events, callbacks)
    Fox.super.ctor(self,properties, events, callbacks)
    self.nextLvExp =calculateExp(self.level_)
end

function Fox:gainExp(exp)
     self.exp_ = self.exp_ + exp *10
     if (self.exp_ >=  self.nextLvExp) then
        self.level_ = self.level_ + 1
        self.exp_ = self.exp_  - self.nextLvExp
        self.nextLvExp =calculateExp(self.level_)
        self:setFullHp()
    end
    self:dispatchEvent({name = "gainExp"})
end

-- 增加经验值，并检测升级
function Fox:increaseEXP(exp)
    assert(not self:isDead(), string.format("Fox %s:%s is dead, can't increase Exp", self:getId(), self:getNickname()))
    assert(exp > 0, "Fox:increaseEXP() - invalid exp")

    self.exp_ = self.exp_ + exp
    -- 简化的升级算法，每一个级别升级的经验值都是固定的
    while self.exp_ >= Fox.NEXT_LEVEL_EXP do
        self.level_ = self.level_ + 1
        self.exp_ = self.exp_ - Fox.NEXT_LEVEL_EXP
        self:setFullHp() -- 每次升级，HP 都完全恢复
        self:dispatchEvent({name = Fox.LEVEL_UP_EVENT})
    end
    self:dispatchEvent({name = Fox.EXP_CHANGED_EVENT})

    return self
end
--下一级所需经验
function Fox:getNextLvExp( )
    return self.nextLvExp
end

function Fox:getExp()
    return self.exp_
end

function Fox:getAttack()
    return self.level_ * 50
end

function Fox:attackAll(enemies)
    self:say("看招...",2)
    self.fsm__:doEvent("attack",enemies)
end

function Fox:hit(target)
    -- 调用父类的 hit() 方法
    local damage = Fox.super.hit(self, target)
    if damage > 0 then
        -- 每次攻击成功，增加 10 点 EXP
        self:increaseEXP(10)
    end
    return damage
end

return Fox
