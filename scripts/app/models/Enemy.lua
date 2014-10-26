--
-- Author: Black Lotus
-- Date: 2014-09-27 15:10:50
--

--[[
敌人类
从Role类继承，增加一些特有属性
]]

local Role = import(".Role")
local Enemy = class("Enemy", Role)
Enemy.schema = clone(Role.schema)
Enemy.schema["sight"]  ={"number", 250 } --视野 px
return Enemy
