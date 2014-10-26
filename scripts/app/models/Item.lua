--
-- Author: Black Lotus
-- Date: 2014-09-26 09:56:46
--

--[[--
物品类
]]

local Item = class("Item", cc.mvc.ModelBase)

Item.schema = clone(cc.mvc.ModelBase.schema)

Item.schema["catalog"] = {"string"} -- 字符串类型，没有默认值
Item.schema["name"] = {"string"} -- 字符串类型，没有默认值
Item.schema["level"]    = {"number", 1} -- 数值类型，默认值 1
Item.schema["quality"] ={"number",0}
Item.schema["description"]= {"string", "此物品暂无描述"}


Item.CHANGE_STATE_EVENT ="CHANGE_STATE_EVENT"

function Item:ctor(properties,events,callbacks)
	Item.super.ctor(self, properties)
	self:addComponent("components.behavior.StateMachine")
    -- 由于状态机仅供内部使用，所以不应该调用组件的 exportMethods() 方法，改为用内部属性保存状态机组件对象
    self.fsm = self:getComponent("components.behavior.StateMachine")
     -- 设定状态机的默认事件
    local defaultEvents = {
        -- 初始化后，物品处于 idle 状态
        {name = "start",  from = "none", to = "disappear" },
        {name = "display",from = "disappear", to = "appear"},
        {name = "drop" ,from = "appear",to ="droped"},
        {name = "pick",from = "droped",to ="picked"}
    }
    -- 如果继承类提供了其他事件，则合并
    table.insertto(defaultEvents, checktable(events))
    -- 设定状态机的默认回调
    local defaultCallbacks = {
        onchangestate = handler(self, self.onChangeState_),
        onstart       = handler(self, self.onStart_),
    }
    -- 如果继承类提供了其他回调，则合并
    table.merge(defaultCallbacks, checktable(callbacks))
    self.fsm:setupState({
        events = defaultEvents,
        callbacks = defaultCallbacks
    })
    self.fsm:doEvent("start") -- 启动状态机
end
---常用方法
function Item:getCatalog()
    return self.catalog_
end
function Item:getName()
    return self.name_
end
function Item:getQuality()
    return self.quality_
end

function Item:getState()
    return self.fsm:getState()
end

---状态事件
function Item:onStart_(event)
    printf("Item %s:%s start", self:getId(), self.name_)
    self:dispatchEvent({name = "start"})
end

function Item:onChangeState_(event)
    printf("Item %s:%s state change from %s to %s", self:getId(), self.name_, event.from, event.to)
    event = {name = Item.CHANGE_STATE_EVENT, from = event.from, to = event.to}
    self:dispatchEvent(event)
end

return Item