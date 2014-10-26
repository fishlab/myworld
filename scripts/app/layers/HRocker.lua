--
-- Author: Black Lotus
-- Date: 2014-09-19 23:47:08
--
--require("framework.init")
--require("framework.shortcodes")
--require("framework.cc.init")
--[[
local HRocker  = class("HRocker ", function()
    return CCLayer:create()
--    return display.newLayer();
    end)
]]
local HRocker  = class("HRocker ", function()
    return CCLayer:create()
--    return display.newLayer();
    end)

function HRocker:ctor()
	--HRocker.super.ctor(self)
	-- self.centerPoint
end
--缓慢改变摇杆位置
function HRocker:updatePos(dt)
    local px,py=self.jsSprite:getPosition();
    --print(px,py)
    --print(dt)
    --print(self.jsSprite:getPosition());
   local po=CCPoint(px, py)
    self.jsSprite:setPosition(
    	ccpAdd(po,
    	ccpMult(ccpSub(self.currentPoint,po),0.05))
    );
end

--激活摇杆
function HRocker:Active()
    if (not self.active) then
        self.active=true;
        self:setTouchSwallowEnabled(false);

        --schedule(schedule_selector(HRocker.updatePos));--添加刷新函数
        --schedule(schedule_selector(  handler(self, self.updatePos)));
        self:scheduleUpdate(handler(self, self.updatePos))
        
        
        --scheduler.unscheduleGlobal(hd)
        --self:addNodeEventListener(Schedu, listener, tag)

        self:addNodeEventListener(NODE_TOUCH_EVENT,function(event)
            return self:onTouch(event)
        end);
        --CCTouchDispatcher:sharedDispatcher():addTargetedDelegate(self,0,false);--添加触摸委托
        
        -- self:addNodeEventListener(NODE_TOUCH_EVENT, function(event)
        --     return self:onTouch(event.name, event.x, event.y)
        -- end)
    end
end

--解除摇杆
function HRocker:Inactive()

    if (self.active) then
        self.active=false
        --取消更新
        self:unscheduleUpdate()
        --this:unschedule(schedule_selector(HRocker.updatePos));--删除刷新
        --CCTouchDispatcher:sharedDispatcher():removeDelegate(this);--删除委托
    end
end

--摇杆方位
function HRocker:getDirection()
    return ccpNormalize(ccpSub(self.centerPoint, self.currentPoint));
end

--摇杆力度
function HRocker:getVelocity()
    return ccpDistance(self.centerPoint, self.currentPoint);
end

function HRocker:HRockerWithCenter( aPoint , aRadius , aJsSprite,aJsBg, _isFollowRole)
    -- local jstick=self:create();
    local jstick = HRocker.new();
    jstick:initWithCenter(aPoint,aRadius,aJsSprite,aJsBg,_isFollowRole);
    return jstick;
end
--触摸摇杆操作
function HRocker:onTouch(event)
    --print("touch "..event.name)
    if (event.name~="ended") then
        local tp = CCPoint(event.x, event.y);
        if ( ccpDistance(tp,self.centerPoint) < self.radius) then
            --self.jsSprite:setPosition(tp);
            self.currentPoint = tp;
        end
    else --end
        self.currentPoint=self.centerPoint;
       -- self.jsSprite:setPosition(self.centerPoint)
    end
    return true;
end
--[[
function HRocker:ccTouchBegan(touch, event) 
    if (not self.active) then
        return false;
    end

    self:setIsVisible(true);
    local touchPoint = touch:locationInView(touch:view());    
    touchPoint = CCDirector:sharedDirector():convertToGL(touchPoint);
    if(not self.isFollowRole) then
        if (ccpDistance(touchPoint, self.centerPoint) > self.radius) then
            return false;
        end
    end
    self.currentPoint = touchPoint;
    if(self.isFollowRole) then
       	self.centerPoint=self.currentPoint;
        jsSprite:setPosition(self.currentPoint);
        self:getChildByTag(88):setPosition(self.currentPoint);
    end
    return true;
end

function HRocker:ccTouchMoved(touch,event)
    local touchPoint = touch:locationInView(touch:view());
    touchPoint = CCDirector: sharedDirector():convertToGL(touchPoint);
    if (ccpDistance(touchPoint, self.centerPoint) > self.radius) then
        self.currentPoint =
        	ccpAdd(self.centerPoint,
        	ccpMult(ccpNormalize(ccpSub(touchPoint, self.centerPoint)), self.radius));
    else 
        self.currentPoint = touchPoint;
    end
end

function  HRocker:ccTouchEnded( touch, event)
    self.currentPoint = self.centerPoint;
    if(self.isFollowRole) then    
        self:setIsVisible(false);
    end
end
 ]]
function HRocker:initWithCenter(aPoint ,aRadius , aJsSprite, aJsBg, _isFollowRole)
    self.isFollowRole =_isFollowRole;
    self.active = false;
    self.radius = aRadius;
    if(not _isFollowRole) then
        self.centerPoint =aPoint;
    else
        self.centerPoint =ccp(0,0);
    end
 
    self.currentPoint = self.centerPoint;
    self.jsSprite = aJsSprite;
    dump(aPoint)
    dump(self.centerPoint);

    self.jsSprite:setPosition(self.centerPoint);
    aJsBg:setPosition(self.centerPoint);
    aJsBg:setTag(88);
    self:addChild(aJsBg);
    self:addChild(self.jsSprite);
    if(self.isFollowRole) then
        self:setIsVisible(false);
    end
    self:Active();--激活摇杆
    return self;
end


return HRocker;