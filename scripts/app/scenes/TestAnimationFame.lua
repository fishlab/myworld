--
-- Author: Black Lotus
-- Date: 2014-09-24 23:34:51
--
local al=import("..util.AnimationLoader")
local TestAnimationFame =class("TestAnimationFame",function ( )
	return CCScene:create();
end)

local defineAnimate=function(img,targetSize,row,line,offsetX,offsetY,delay,loopCount)
	-- local pw,ph=280,280;--动画帧大小
	local cw,ch=0,0;
	local arr=CCArray:create();
	for i=0,row do
		for j=0,line do
			cw=j*352+offsetX;--动画帧便偏移量
			ch=i*160+offsetY;
			local sfame= CCSpriteFrame:create(img, CCRectMake(cw, ch, targetSize, targetSize))
			arr:addObject(sfame)
		end
	end
	local animation=CCAnimation:createWithSpriteFrames(arr,delay)
	animation:setLoops(loopCount);
	local animate=CCAnimate:create(animation)
	return animate;
end

local defineEnemyAnimate=function(img,targetSize,row,line,offsetX,offsetY,delay,loopCount)
	-- local pw,ph=280,280;--动画帧大小
	local cw,ch=0,0;
	local arr=CCArray:create();
	for i=0,row do
		for j=0,line do
			cw=j*160+offsetX;--动画帧便偏移量
			ch=i*160+offsetY;
			local sfame= CCSpriteFrame:create(img, CCRectMake(cw, ch, targetSize, targetSize))
			arr:addObject(sfame)
		end
	end
	local animation=CCAnimation:createWithSpriteFrames(arr,delay)
	animation:setLoops(loopCount);
	local animate=CCAnimate:create(animation)
	return animate;
end


function TestAnimationFame:ctor()
	-- local pw,ph=280,280;--动画帧大小
	--[[
	local pw,ph=360,360;
	local cw,ch=0,0;
	local arr=CCArray:create();
	for i=0,1 do
		for j=0,3 do
			cw=j*460;--动画帧便偏移量
			ch=i*300+70;
			local sfame= CCSpriteFrame:create("fox/fanhui.png", CCRectMake(cw, ch, pw, ph))
			arr:addObject(sfame)
			print (i,j)
		end
	end
	--CCSpriteFrame:create("fox/attacked.png", CCRectMake(0, 0, pw, ph))
	local animation=CCAnimation:createWithSpriteFrames(arr,1/8)
	--animation:setRestoreOriginalFrame(true)

	-- self:addChild(ani)
	animation:setLoops(-1);
	local animate=CCAnimate:create(animation)
	-- self:runAction(ani)
	]]
	local sprite = CCSprite:create();
	sprite:setPosition(ccp(display.cx, display.cy))
	-- sprite:runAction(animate)
	-- local atku=defineAnimate("enemy/9/atk.png",210,1,3,100,0,1/8,-1);
	local atku = al[9]("enemy/11/atk.png")
	local spatku=CCSprite:create();
	spatku:setPosition(ccp(display.cx-100, display.cy-100))
	spatku:runAction(atku);

	local layer=CCLayer:create();
	layer:setTouchEnabled(true);
	sprite=spatku;
	layer:addNodeEventListener(NODE_TOUCH_EVENT, function(event)
		sprite:setPosition(ccp(event.x, event.y))
		return true
	end)
	layer:addChild(sprite);
	--layer:addChild(spatku)
	self:addChild(layer)

end


return TestAnimationFame;