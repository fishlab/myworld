--
-- Author: Black Lotus
-- Date: 2014-09-25 14:55:17
--

local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
--local scheduler=CCDirector:sharedDirector():getScheduler()
--[[--

“角色”类
level 是角色的等级，角色的攻击力、防御力、初始 Hp 都和 level 相关
]]

local Role = class("Role", cc.mvc.ModelBase)

-- 常量

-- 定义事件
Role.CHANGE_STATE_EVENT = "CHANGE_STATE_EVENT"
Role.START_EVENT         = "START_EVENT"
Role.READY_EVENT         = "READY_EVENT"
Role.FREEZE_EVENT        = "FREEZE_EVENT"
Role.THAW_EVENT          = "THAW_EVENT"
Role.KILL_EVENT          = "KILL_EVENT"
Role.RELIVE_EVENT        = "RELIVE_EVENT"
Role.HP_CHANGED_EVENT    = "HP_CHANGED_EVENT"

Role.ATTACK_EVENT        = "ATTACK_EVENT"
Role.UNDER_ATTACK_EVENT  = "UNDER_ATTACK_EVENT"

-- 定义属性
Role.schema = clone(cc.mvc.ModelBase.schema)
Role.schema["nickname"] = {"string"} -- 字符串类型，没有默认值
Role.schema["level"]    = {"number", 1} -- 数值类型，默认值 1
Role.schema["hp"]       = {"number", 0} -- 生命值
Role.schema["velocity"] = {"number", 150} --移动速度 px/s

function Role:ctor(properties, events, callbacks)
    Role.super.ctor(self, properties)

    -- 因为角色存在不同状态，所以这里为 Role 绑定了状态机组件
    self:addComponent("components.behavior.StateMachine")
    -- 由于状态机仅供内部使用，所以不应该调用组件的 exportMethods() 方法，改为用内部属性保存状态机组件对象
    self.fsm__ = self:getComponent("components.behavior.StateMachine")

    -- 设定状态机的默认事件
    local defaultEvents = {
        --初始化·
        {name = "start",  from = "none",    to = "idle" },
        --行走
        {name = "move",  from = {"idle","moving"},    to = "moving" },
        --停止
        {name = "stop",  from = {"moving","attacking","injuring","idle"},    to = "idle" },
        -- 攻击
        {name = "attack",   from = "idle",    to = "attacking"},
        -- 受伤
        {name = "injure",   from = {"idle","moving","injuring","attacking"},    to = "injuring"},
        -- 死亡
        {name = "die",  --[[ from = "idle", ]]   to = "dead"},

    }
    -- 如果继承类提供了其他事件，则合并
    table.insertto(defaultEvents, checktable(events))

    -- 设定状态机的默认回调
    local defaultCallbacks = {
        onchangestate = handler(self, self.onChangeState_),
        -- onsay         = handler(self,self.onSay_),
        onstart       = handler(self, self.onStart_),
        onattack       = handler(self, self.onAttack_),
        onleaveattack  = handler(self,self.onLeaveAttack_),
        onmove         = handler(self,self.onMove_),
        onstop         = handler(self,self.onStop_),
        oninjure       = handler(self,self.onInjure_),
        onleaveinjuring  = handler(self, self.onLeaveInjuring_),
        ondie           = handler(self,self.onDie_),
        -- onready       = handler(self, self.onAttack_),
        onfreeze      = handler(self, self.onFreeze_),
        onthaw        = handler(self, self.onThaw_),
        onkill        = handler(self, self.onKill_),
        onrelive      = handler(self, self.onRelive_),
        onleavefiring = handler(self, self.onLeaveFiring_),
    }
    -- 如果继承类提供了其他回调，则合并
    table.merge(defaultCallbacks, checktable(callbacks))

    self.fsm__:setupState({
        events = defaultEvents,
        callbacks = defaultCallbacks
    })

    self.fsm__:doEvent("start") -- 启动状态机
end
function Role:doEvent(name)
    self.fsm__:doEvent(name)
end
function Role:getNickname()
    return self.nickname_
end
function Role:getVelocity()
    return self.velocty_
end
function Role:getLevel()
    return self.level_
end

function Role:getHp()
    return self.hp_
end

-- 简化算法：最大 Hp = 等级 x 100
function Role:getMaxHp()
    return self.level_ * 100
end

function Role:getAttack()
    -- 简化算法：攻击力是等级 x 5
    return self.level_ * 5
end

function Role:getArmor()
    -- 简化算法：防御是等级 x 2
    return self.level_ * 2
end

function Role:getState()
    return self.fsm__:getState()
end
function Role:canMove()
    return self.fsm__:canDoEvent("move")
end
function Role:canAttack()
    return self.fsm__:canDoEvent("attack")
end
function Role:isAlive()
    return self.fsm__:getState() ~= "dead"
end
function Role:isDead()
    return self.fsm__:getState() == "dead"
end

function Role:isFrozen()
    return self.fsm__:getState() == "frozen"
end

function Role:setFullHp()
    self.hp_ = self:getMaxHp()
    return sef
end

function Role:increaseHp(hp)
    assert(not self:isDead(), string.format("Role %s:%s is dead, can't change Hp", self:getId(), self:getNickname()))
    assert(hp > 0, "Role:increaseHp() - invalid hp")

    local newhp = self.hp_ + hp
    if newhp > self:getMaxHp() then
        newhp = self:getMaxHp()
    end

    if newhp > self.hp_ then
        self.hp_ = newhp
        self:dispatchEvent({name = Role.HP_CHANGED_EVENT})
    end

    return self
end

function Role:decreaseHp(hp)
    assert(not self:isDead(), string.format("Role %s:%s is dead, can't change Hp", self:getId(), self:getNickname()))
    assert(hp > 0, "Role:increaseHp() - invalid hp")

    local newhp = self.hp_ - hp
    if newhp <= 0 then
        newhp = 0
    end

    if newhp < self.hp_ then
        self.hp_ = newhp
        self:dispatchEvent({name = Role.HP_CHANGED_EVENT})
        if newhp == 0 then
            self.fsm__:doEvent("kill")
        end
    end

    return self
end

-- 攻击
--[[
function Role:attack()
    -- print("----------")
    self:say("看招...",2)
    self.fsm__:doEvent("attack")
    --self.fsm__:doEvent("ready", Role.FIRE_COOLDOWN)
end
]]
--enemy为视图
function Role:attack(enemy)
    self:say("看招...",2)
    self.fsm__:doEvent("attack",enemy)
end

-- 简化算法：伤害 = 自己的攻击力 - 目标防御
function Role:getDamage(model)
    local damage = 0
    if math.random(1, 100) <= 80 then -- 命中率 80%
        local armor = model:getArmor()
        damage= self:getAttack() - armor
        if(damage<0) then
            damage = 0
        end
    end
    return damage  --miss
end
-- 命中目标
function Role:hit(enemy)
    -- assert(not self:isDead(), string.format("Role %s:%s is dead, can't change Hp", self:getId(), self:getNickname()))

    -- 简化算法：伤害 = 自己的攻击力 - 目标防御
    local damage = 0
    if math.random(1, 100) <= 80 then -- 命中率 80%
        local armor = 0
        if not enemy:isFrozen() then -- 如果目标被冰冻，则无视防御
            armor = enemy:getArmor()
        end
        damage = self:getAttack() - armor
        if damage <= 0 then damage = 1 end -- 只要命中，强制扣 HP
    end
    -- 触发事件，damage <= 0 可以视为 miss
    self:dispatchEvent({name = Role.ATTACK_EVENT, enemy = enemy, damage = damage})
    if damage > 0 then
        -- 扣除目标 HP，并触发事件
        enemy:decreaseHp(damage) -- 扣除目标 Hp
        enemy:dispatchEvent({name = Role.UNDER_ATTACK_EVENT, source = self, damage = damage})
    end

    return damage
end
--
function Role:say(content,delay)
    delay=delay or 2
    self:dispatchEvent({name = "say", content=content,delay=delay})
end



--受伤
function Role:getInjured(damage)
    printf("Role %s:%s get injured by %d", self:getId(), self.nickname_,damage)
    --form =self.fsm__:getState(),to="injure",
    --self:dispatchEvent({name = "injured", damage=damage})
    self.hp_=self.hp_-damage
    if (self.hp_ <=0) then
        self.hp_ =0
        self:doEvent("die")
        self:say("oh... Fuck")
        self:dispatchEvent({name = "injure", damage=damage})
        return
    end
    print(self.fsm__:getState());
    self:say("呃...")
    if(damage>0 and self.fsm__:getState() == "idle") then
       self.fsm__:doEvent("injure",damage)
    else
       self:dispatchEvent({name = "injure", damage=damage})
    end

end

---- state callbacks

function Role:onChangeState_(event)
    printf("Role %s:%s state change from %s to %s", self:getId(), self.nickname_, event.from, event.to)
    event = {name = Role.CHANGE_STATE_EVENT, from = event.from, to = event.to}
    self:dispatchEvent(event)
end

-- 启动状态机时，设定角色默认 Hp
function Role:onStart_(event)
    printf("Role %s:%s start", self:getId(), self.nickname_)
    self:setFullHp()
    self:dispatchEvent({name = Role.START_EVENT})
end

function Role:onSay_(event)
    printf("Role %s:%s say %s", self:getId(), self.nickname_,event.args[1])
    self:dispatchEvent({name = "say", content=event.args[1]})
end

function Role:onReady_(event)
    printf("Role %s:%s ready", self:getId(), self.nickname_)
    self:dispatchEvent({name = Role.READY_EVENT})
end

function Role:onAttack_(event)
    printf("Role %s:%s attack", self:getId(), self.nickname_)
        scheduler.performWithDelayGlobal(function()
            print("scheduler after attack,do stop")
            self:dispatchEvent({name = "attackFinish",enemy = event.args[1]});
            self.fsm__:doEvent("stop")
        end, 1)
    self:dispatchEvent({name = "attack"})
end

function Role:onLeaveAttack_(event)
    printf("Role %s:%s leave attack", self:getId(), self.nickname_)
    --self:dispatchEvent({name = Role.ATTACK_EVENT})
end


function Role:onMove_(event)
    printf("Role %s:%s move", self:getId(), self.nickname_)
    --self:dispatchEvent({name = Role.ATTACK_EVENT})
    self:dispatchEvent({name ="move"})
end

function Role:onStop_(event)
    printf("Role %s:%s stop", self:getId(), self.nickname_)
    --self:dispatchEvent({name = Role.ATTACK_EVENT})
     self:dispatchEvent({name ="stop"})
end

function Role:onInjure_(event)

    printf("Role %s:%s onInjure() damage %s", self:getId(), self.nickname_,event.args[1] or "unkonown")
    -- local actDef=self.actionDefinition["injure"]
      -- self:dispatchEvent({name ="injure"})

        scheduler.performWithDelayGlobal(function()
             print("scheduler after injure,do stop")
             --event.transition()
             self.fsm__:doEvent("stop")
        end, 1)
     self:dispatchEvent({name ="injure",damage=event.args[1]})
     -- return "async"
end

function Role:onLeaveInjuring_(event)
    print("prepare leave injuring")
end

function Role:onDie_(event)
    self:dispatchEvent({name = "die"})
end

function Role:onFreeze_(event)
    printf("Role %s:%s frozen", self:getId(), self.nickname_)
    self:dispatchEvent({name = Role.FREEZE_EVENT})
end

function Role:onThaw_(event)
    printf("Role %s:%s thawing", self:getId(), self.nickname_)
    self:dispatchEvent({name = Role.THAW_EVENT})
end

function Role:onKill_(event)
    printf("Role %s:%s dead", self:getId(), self.nickname_)
    self.hp_ = 0
    self:dispatchEvent({name = Role.KILL_EVENT})
end

function Role:onRelive_(event)
    printf("Role %s:%s relive", self:getId(), self.nickname_)
    self:setFullHp()
    self:dispatchEvent({name = Role.RELIVE_EVENT})
end

function Role:onLeaveFiring_(event)
    local cooldown = checknumber(event.args[1])
    if cooldown > 0 then
        -- 如果开火后的冷却时间大于 0，则需要等待
        scheduler.performWithDelayGlobal(function()
            event.transition()
        end, cooldown)
        return "async"
    end
end

return Role
