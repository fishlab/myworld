--
-- Author: Black Lotus
-- Date: 2014-09-29 02:37:50
--

AnimationLoader ={}
local _1480_320 = function(img)
	-- local pw,ph=280,280;--动画帧大小
	local cw,ch=0,0;
	local arr=CCArray:create();
	for i=0,1 do
		for j=0,3 do
			cw=j*352+100;--动画帧便偏移量
			ch=i*160;
			local sfame= CCSpriteFrame:create(img, CCRectMake(cw, ch, 210, 210))
			arr:addObject(sfame)
		end
	end
	local animation=CCAnimation:createWithSpriteFrames(arr,1/8)
	local animate=CCAnimate:create(animation)
	return animate;
end
AnimationLoader[9]=_1480_320
AnimationLoader[10]=_1480_320
AnimationLoader[11]=_1480_320
return AnimationLoader