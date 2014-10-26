--
-- Author: Black Lotus
-- Date: 2014-09-22 14:27:54
--
local TestLabelScene=class("TestLabelScene",function()
    return CCScene:create()
end)

function TestLabelScene:ctor()
	
	self._uiLayer = TouchGroup:create()
	-- local labelAtlas = LabelAtlas:create()	
 --    labelAtlas:setProperty("1234567890", "gui/labelatlas.png", 17, 22, "0")
 --    labelAtlas:setPosition(CCPoint(display.cx-100,display.cy) )
    -- self._uiLayer:setTouchEnabled(true)
    -- self._uiLayer:setTouchSwallowEnabled(false)
	self:addChild(self._uiLayer)

    self.touchLayer = CCLayer:create()
	local scheduler = CCDirector:sharedDirector():getScheduler()
    self.touchLayer:addNodeEventListener(NODE_TOUCH_EVENT, function(event)
    	print(event)

    	if (event.name~="endend") then
    	local labelAtlas = LabelAtlas:create()	
    	-- labelAtlas:setPosition(CCPoint(event.x,event.y)) 
    	labelAtlas:setPosition(ccp(event.x, event.y))
   		labelAtlas:setProperty(tostring(event.x).." "..tostring(event.y), "gui/labelatlas.png", 17, 22, "0")
   		labelAtlas.count=25;
    	--print(event)
    	self._uiLayer:addWidget(labelAtlas)
    	
    	local px,py = labelAtlas:getPosition();
    	local mvTo = CCMoveTo:create(0.4, ccp(px, py+40))

    	local rmself =CCCallFunc:create(function()
    		labelAtlas:removeSelf();
    	end)
    	labelAtlas:runAction(CCSequence:createWithTwoActions(mvTo, rmself) )
    	
    	--[[
    	labelAtlas.tmr=scheduler:scheduleScriptFunc(function(dt)
    		labelAtlas.count=labelAtlas.count-1;
    		local px,py = labelAtlas:getPosition();
    		labelAtlas:setPosition(ccp(px, py+4))
    		if (labelAtlas.count<0) then
    			  scheduler:unscheduleScriptEntry(labelAtlas.tmr);
    			  --self._uiLayer:removeWidget(labelAtlas)
    			  labelAtlas:removeSelf()
    		end
    		end, 0.05, false)
    	]]
    	--labelAtlas:setPosition(ccp(event.x, event.y))
    end
    	return true;
    end)
    self.touchLayer:setTouchEnabled(true)
    self.touchLayer:setTouchSwallowEnabled(false);--向下传递触摸事件
    self:addChild(self.touchLayer)
    self:setTouchEnabled(true);
end

return TestLabelScene;