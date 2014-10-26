--
-- Author: Black Lotus
-- Date: 2014-09-20 13:12:06
--
local FightScene = class("FightScene", function()
    -- return display.newScene("FightScene")
    return CCScene:create()
end)

local HRocker = import ("..layers.HRocker")

function FightScene:ctor()
  --local view = CCEGLView:sharedOpenGLView();
  --view:setFrameSize(dis, height)
  --CCDirector:sharedDirector():setOpenGLView(view)
  -- CCEGLView:sharedOpenGLView():setDesignResolutionSize(960, 640, kResolutionNoBorder)

  local root=SceneReader:sharedSceneReader():createNodeWithSceneFile("csb/publish/FightScene.json", ATTACH_EMPTY_NODE)
  root:setZOrder(-1)

  --root:setRect(CCRect(0, 0, display.width, display.height))
  --print (cz.width,cz.height)

  --local spsz= root:getContentSize();
  --print ("spsz"..spsz.width,spsz.height)
  --root:setScaleX(display.width/spsz.width)
  --root:setScaleY(display.height/spsz.height)

   --root:setScale(1.5)
   --root:setContentSize(CCSize(display.width,display.height))

	-- root:setPosition(ccp(display.cx,display.cy))
  	self:addChild(root);
	local hero=root:getChildByTag(10005):getComponent("CCArmature")
	--tolua.cast(
	--,"CCComRender");
	--hero:getNode():setPosition(ccp(0, 0))

	self._uiLayer = TouchGroup:create()
	self:addChild(self._uiLayer)
  --[[
	local labelAtlas = LabelAtlas:create()
  labelAtlas:setProperty("123456789011", "gui/labelatlas.png", 17, 22, "0")
  labelAtlas:setPosition(CCPoint(display.cx,display.cy) )
  self._uiLayer:addWidget(labelAtlas)
  ]]

	--[[
	local rd=GUIReader:shareReader();
	local ui=rd:widgetFromJsonFile("csb/ui/FightScene_1/FightScene_1.ExportJson");
	self._uiLayer:addWidget(ui);
	--ui:setPosition(ccp(0, 0))
	local pc=self._uiLayer:getWidgetByTag(7)

	print (pc)
	pc:setPosition(ccp(display.cx+100, display.cy+100))
	pc:setVisible(true)]]

	--ui:getChildByTag(8):setPosition(ccp(display.cx, display.cy))
	--ui:getComponent("LoadingBar"):setPosition(ccp(display.cx, display.cy))

	--创建并播放骨骼动画
 	local sadm=CCArmatureDataManager:sharedArmatureDataManager();
 	sadm:addArmatureFileInfo("Hero/Hero.ExportJson")
 	local armature=CCArmature:create("Hero");

 	armature:getAnimation():play("run")
 	self.sprite=armature;
 	self.sprite.dir=1;
 	self.sprite:setPosition(CCPoint(display.cx, display.cy));
 	self:addChild(self.sprite);
 	-- armature:getAnimation():play("attack")

 	local spRocker=display.newCircle(25, {fill=true,color=ccc4f(240, 240, 240, 10)});

 	--CCDirector:sharedDirector():setAlphaBlending(true);
 	--CCTexture2D:PVRImagesHavePremultipliedAlpha(false);
 	--[[
 	local cr = CCCircleShape:create(400, true)
 	cr:setColor(ccc3(240, 110, 240))
 	cr:setOpacity(111)
 	self:addChild (cr);
 	]]

 	local spRockerBG=display.newCircle(100, {fill=true,color=ccc4f(25, 0, 250, 255)});

 	spRockerBG:setOpacity(155);
 	spRockerBG:setOpacityModifyRGB(true)
 	spRockerBG:setColor(ccc3(240, 240, 240));

 	--CCDirector:sharedDirector()
 	self.rocker=HRocker:HRockerWithCenter(ccp(210.0,130.0),50.0+54,spRocker,spRockerBG,false);--创建摇杆
	--rocker:setZOrder(10)
	--self.rocker:setOpacity(100)
	self.rocker:setTouchEnabled(true)
	self:addChild(self.rocker);--摇杆添加到scene中
	--self:addLayer(rocker);

	--[[
	local layer=CCLayer:create();
	layer:addNodeEventListener(NODE_TOUCH_EVENT,function(event)
        return self:onTouch(event)
  	end);
	layer:setTouchEnabled(true) -- 注册后还必须启用触摸
	layer:setTouchSwallowEnabled(false);--向下传递触摸事件
	self:addChild(layer)
	]]

 	self:scheduleUpdate(handler(self, self.updatePos))
	local attack=display.newCircle(25, {fill=true,color=ccc4f(240, 240, 40, 100)});
	local index=0;
	attack:addNodeEventListener(NODE_TOUCH_EVENT, function(event)
		--ani=self.sprite:getAnimation();
		--ani:play("attack",-1,0);

		local ani = self.cb:getAnimation()
		ani:playWithIndex(index)
		index=index+1
	end)
	attack:setTouchEnabled(true);

	sadm:addArmatureFileInfo("cb/Cowboy.ExportJson")
	self:armatureEventTest();

	self:addChild(attack);


end

local ccs = ccs or {}
ccs.MovementEventType = {
    START = 0,
    COMPLETE = 1,
    LOOP_COMPLETE = 2,
}

function FightScene:armatureEventTest()

	local armature =CCArmature:create("Cowboy");
 	self.cb=armature
 	self.cb:setScale(0.2)
 	self.cb:setPosition( ccp(display.cx-100,display.cy-100) )
 	--self:add(self.cb);

  armature:getAnimation():play("Fire")
  armature:setScaleX(-0.24)
  armature:setScaleY(0.24)
  armature:setPosition(ccp(display.cx,display.cy))

  local function callback1()
      armature:runAction(CCScaleTo:create(0, 0.25, 0.25))
      armature:getAnimation():play("FireMax", 10)
  end

  local function callback2()
      armature:runAction(CCScaleTo:create(0, -0.25, 0.25))
      armature:getAnimation():play("Fire", 10)
  end

    local function animationEvent(armatureBack,movementType,movementID)
        local id = movementID
        print(id)
        if movementType == ccs.MovementEventType.LOOP_COMPLETE then
            if id == "Fire" then
                armatureBack:stopAllActions()
                local actionToRight = CCMoveTo:create(2, ccp(display.right - 50, display.right))
                local arr = CCArray:create()
                arr:addObject(actionToRight)
                arr:addObject(CCCallFunc:create(callback1))
                armatureBack:runAction(CCSequence:create(arr))
                armatureBack:getAnimation():play("Walk")
            elseif id == "FireMax" then
                armatureBack:stopAllActions()
                local actionToLeft = CCMoveTo:create(2, ccp(display.left + 50, display.right) )
                local arr = CCArray:create()
                arr:addObject(actionToLeft)
                arr:addObject(CCCallFunc:create(callback2))
                armatureBack:runAction(CCSequence:create(arr))
                armatureBack:getAnimation():play("Walk")
            end
        end
    end

    armature:getAnimation():setMovementEventCallFunc(animationEvent)

    self:addChild(armature)
end


function FightScene:updatePos(dt)
	local vol=self.rocker:getVelocity();
	local dir=self.rocker:getDirection();

	-- dump(vol)
	--local pos=CCPoint(self.sprite:getPosition() );
	--local res=ccpSub(pos, ccpMult(dir,vol*dt) );

	local px,py=self.sprite:getPosition();
	--self.sprite:flipX(true);
	--print(dir.x)
	local dir0=self.sprite.dir;
	--print(dir0)
	if (dir.x~=1) then
		if (dir0==1) then
			if (dir.x>0) then
				self.sprite.dir=-1;
				self.sprite:runAction(CCScaleTo:create(0, -1, 1))
			end
		elseif (dir0==-1) then
			if (dir.x<0) then
				self.sprite.dir=1;
				self.sprite:runAction(CCScaleTo:create(0, 1, 1))
			end
		end

	end
	--todo
	--if (dir0 <1 and dir0 >0 or dir0<0 and dir0>-1) then --反向
	--	self.sprite.dir=-self.sprite.dir;
	--	self.sprite:runAction(CCScaleTo:create(0, self.sprite.dir, 1))
	--end


	local res=CCPoint(px-dir.x*vol*0.09, py-dir.y*vol*0.04)
	self.sprite:setPosition(res);
end

function FightScene:onTouch(event )
	--print (event.name)
    if event.name == "began" then
    	--if(self.ts) then transition.stopAction(self.ts)
    	--end
    	transition.stopTarget(self.sprite)
    	--ccpDistance(v1, v2)
    	--dump(self.sprite:getPosition():getPoints(),"pos")
    	--self.sprite:setPosition(CCPoint(event.x,event.y));
    	--dump(CCPoint(event.x,event.y))
    	--dump(self.sprite:getPosition() );

    	--local ccp=ccpAdd(CCPoint(
    	--	self.sprite:getPositionX(), self.sprite:getPositionY() ),
    	--	ccpMult(CCPoint(10, 3), 0.2));

    	--self.sprite:setPosition(CCPoint(
    	--	self.sprite:getPositionX()+10, self.sprite:getPositionY()+5 ))
		if (self.attacking) then
    		self.sprite:getAnimation():play("attack");
    		self.attacking=false;
		else
			self.attacking=true;
			self.sprite:getAnimation():play("run");
		end
    	transition.moveTo(self.sprite, {x = event.x, y = event.y,time=1})
    	--transition.moveBy(self.sprite, {x = event.x, y =  event.y ,time=1})
    end
    return true;
end




return FightScene;