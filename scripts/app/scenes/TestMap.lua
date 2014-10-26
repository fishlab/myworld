--
-- Author: Black Lotus
-- Date: 2014-09-23 08:35:03
--

local imp=import("..util.CollisionDetect")
local HRocker = import ("..layers.HRocker")

local Fox = import("..models.Fox")
local FoxView = import("..views.FoxView")

local Enemy = import("..models.Enemy")
local EnemyView = import("..views.EnemyView")

local Item = import("..models.Item")
local ItemView = import("..views.ItemView")
local PlayerStateView = import("..views.PlayerStateView")
local AIManager = import("..ai.AIManager")

local TestMap =class("TestMap",function()
	return display.newScene("TestMap")
	--return CCScene:create();
end)
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
function TestMap:ctor()
end
function TestMap:onEnter()
	audio.playMusic("sounds/bgm/015-Theme04.mp3", true)

	--CCEGLView:sharedOpenGLView():setDesignResolutionSize(CONFIG_SCREEN_WIDTH, CONFIG_SCREEN_HEIGHT,
	--	kResolutionFixedHeight)
	--[[
	local root=SceneReader:sharedSceneReader():createNodeWithSceneFile("csb/publish/FightScene.json", ATTACH_EMPTY_NODE)
	root:setZOrder(-1)
	local spsz= root:getContentSize();
  	self:addChild(root);
	]]
	--local sp=CCSprite:create("csb/img/bg1.png")
	--local spsz=sp:getContentSize();
	--print(sp:getContentSize().width )
	--print(sp:getContentSize().height )
	--sp:setScaleX(display.width/spsz.width)
	--sp:setScaleY(display.height/spsz.height)

	--sp:setPosition(ccp(display.cx, display.cy))
	--sp.setPosition(sp,ccp(display.cx, display.cy))
	--self:addChild(sp)
	--[[
	self._uiLayer = TouchGroup:create()
	self:addChild(self._uiLayer)
	local rd=GUIReader:shareReader();
	local ui=rd:widgetFromJsonFile("csb/ui/FightScene_1/FightScene_1.ExportJson");
	self._uiLayer:addWidget(ui);
	]]
	--[[
	local rect=CCRectShape:create(CCSize(40, 50));
	rect:setFill(true)
	rect:setColor(ccc3(210, 120, 180))
	rect:setOpacity(0.2)
	rect:setZOrder(3)
	rect:pos(display.cx+100, display.cy+200)
	self:addChild(rect)]]

	local layer=CCLayer:create();
	local  map = CCTMXTiledMap:create("map/test.tmx")
	-- map:tileAt(ccp(13,21))
	-- local x = 0
 --    local y = 0
 --    local z = 0
 --    x, y, z = map:getCamera():getEyeXYZ(x, y, z)
	local  s = map:getContentSize()
    printf("ContentSize: %f, %f", s.width,s.height)
   -- map:setPosition(ccp(display.cx,display.cy))
     local  mlayer = map:layerNamed("base")
     local mlayer3=map:layerNamed("layer3")
    mlayer:getTexture():setAntiAliasTexParameters()

    --map:setScale( 1 )

    local tile0 = mlayer:tileAt(ccp(10,10))
    --print(tile0:getPosition())
    local s= map:getContentSize()
    -- map:setAnchorPoint(ccp(0,0))

  	map:setPosition(ccp(0,0))
    --map:setPosition(ccp(mx, my))
    --local tile1 = mlayer:tileAt(ccp(2,5))
    --local tile2 = mlayer:tileAt(ccp(3,5))--ccp(1,62))
    --local tile3 = mlayer:tileAt(ccp(4,5))
    --tile0:setAnchorPoint( ccp(0.5, 0.5) )
    --tile1:setAnchorPoint( ccp(0.5, 0.5) )
    --tile1:setOpacity(100)
    --tile2:setAnchorPoint( ccp(0.5, 0.5) )
    --tile3:setAnchorPoint( ccp(0.5, 0.5) )
    --tile2:setVisible(false)
    layer:addChild(map,0,1)

    -- map:setScale(2)

    --[[--创建非失真块
    local  pChildrenArray = map:getChildren()
    local  child          = nil
    local  pObject        = nil
    local  i              = 0
    local  len            = pChildrenArray:count()

    for i = 0, len-1, 1 do
        child = tolua.cast(pChildrenArray:objectAtIndex(i), "CCSpriteBatchNode")
        if child == nil then
            break
        end
        child:getTexture():setAntiAliasTexParameters()
    end
    ]]

     local prev = {x = 0, y = 0}
 		local function onTouchEvent(eventType, x, y)
        if eventType == "began" then
            prev.x = x
            prev.y = y
            return true
        elseif  eventType == "moved" then
            local node  = layer:getChildByTag(1)
            local newX  = node:getPositionX()
            local newY  = node:getPositionY()
            local diffX = x - prev.x
            local diffY = y - prev.y

            node:setPosition( ccpAdd(ccp(newX, newY), ccp(diffX, diffY)) )
            prev.x = x
            prev.y = y
        end
    end

    layer:setTouchSwallowEnabled(false)
    layer:setTouchEnabled(true)
    self.layer =layer
    --layer:registerScriptTouchHandler(onTouchEvent)

    self.fox = Fox.new({
        id = "player",
        nickname = "黑雪",
        level = 1,
        velocity=180
    })

	self.fv=FoxView.new(self.fox)
        :pos(display.cx , display.cy)
        --:pos(tile0:getPosition())
    self.state=PlayerStateView.new(self.fox)
    -- self.state:pos(display.left+self.state:getContentSize().width/2, display.top)
    -- :pos(display.left+40, display.top-40)
    :pos(display.left+20, display.top+60-20)
    self.state:setZOrder(10)
    self:addChild(self.state)
	math.randomseed(os.time())
    --增加5个掉落物品
    for i=0,5 do
	    self.item = Item.new({
	    	id="1",
	    	catalog="weapon",
	    	name="锋利的小太刀",
	    	quality =math.random(0,4)
	    })
	    self.iv =ItemView.new(self.item);
	    --self.iv:pos(display.cx, display.cy)
	    self.iv:pos(math.random(display.width), math.random(display.height) )
	    self.iv:setZOrder(2)
	    map:addChild(self.iv)
    end
    --增加10个敌人
    self.enemy={}
    self.eview={}
    for i=1,11 do
	    local enemy = Enemy.new({
	    	id=tostring(math.random(1,8)),
	    	-- id ="_2",
	    	nickname="山贼",
	    	quality =math.random(0,4)
	    })
	    local ev =EnemyView.new(enemy);

	    --self.iv:pos(display.cx, display.cy)
	    ev:pos(math.random(display.width), math.random(display.height) )
	    ev:setZOrder(2)
	    self.enemy[i] =  enemy;
	    self.eview[i] = ev;
	    ev.index=i
	    ev.container=self.eview
	    map:addChild(ev)
	    self.ev=ev;
    end


    map:addChild(self.fv,  map:getChildren():count())

    --self:addChild(fv)
    self.fv:setZOrder(2)
    self:addChild(layer)
    --self:setAnchorPoint(ccp(10,1))
	--[[
	local bg = display.newScale9Sprite("csb/img/bg1.png", display.cx, display.cy,
		CCSize(display.width,display.height) );
	--local bg = display.newBackgroundTilesSprite("bg/bg-0.png",
	--	CCSize(display.width*2,display.height))
	self:addChild(bg);
	]]

	--print (circleIntersectRect(ccp(120, 120), 40,CCRect(100, 100, 100, 100)) )
	self._uiLayer = TouchGroup:create()

	local tl = CCLayer:create();
	local layout = Layout:create()
	layout:setSize(CCSize(150, 150))
	--[[
	local lbl = ui.newTTFLabel({
    text = "黑雪",
    --font = "Arial",
    size = 15,
    color = ccc3(255, 255, 255),
    align = ui.TEXT_ALIGN_CENTER,
    valign = ui.TEXT_VALIGN_CENTER,
    --dimensions = CCSize(400, 200)
	})
	]]
	--[[
	local bs =CCScale9Sprite:create("gui/button.png") --Button:create()
	bs:setOpacity(170)
	local lbl=CCLabelTTF:create();
	lbl:setFontSize(15)
	lbl:setString("黑雪")
	local lsz=lbl:getContentSize()
	bs:size(lsz.width+4,lsz.height+6)
	bs:setPosition(ccp(display.cx, display.cy))
	--lbl:pos(bs:getPosition())
	lbl:pos( bs:getContentSize().width - lbl:getContentSize().width/2, bs:getContentSize().height / 2)
	bs:addChild(lbl)
	self:addChild(bs)
    ]]
    -- button_scale9:setTouchEnabled(true)
    -- button_scale9:loadTextures("gui/button.png", "gui/button.png", "")
    -- button_scale9:setScale9Enabled(true)
    -- button_scale9:setSize(CCSize(100, button_scale9:getContentSize().height))
    --button_scale9:setPosition(CCPoint(layout:getSize().width - button_scale9:getContentSize().width / 2, button_scale9:getContentSize().height / 2))
    --layout:addChild(button_scale9)
    --self._uiLayer:addWidget(layout)

    self:addChild(self._uiLayer)
	--self.fox:attack();
	-- self.fox:attack();
	local flip =1;
	--self.fv=fv;
	--[[
	tl:addNodeEventListener(NODE_TOUCH_EVENT, function(event)
		fv:pos(event.x,event.y)
		if(event.name=="ended") then
			--fv:flipX(not fv:isFlipX())
			fv:flipX();
		end
		self.iv:pos(event.x,event.y)

		--sp:setPosition(ccp(display.cx+event.x,display.cy+event.y) )
		 local x, y = fv:getPosition()
        local p = ccp(x, y)

        local newZ = -(p.y+32) /16
        fv:setVertexZ( newZ )
		return true;
	end)
	]]
	tl:addNodeEventListener(NODE_TOUCH_EVENT, handler(self, self.onTouch))
	tl:setTouchEnabled(true)
	tl:setTouchSwallowEnabled(false)
	self:addChild(tl)
	-- self.fv.absPostion={
	-- 	x=self.fv:getPositionX(),
	-- 	y=self.fv:getPositionY()
	-- }

	local enemyAI = AIManager.getAI("enemy")
	local playerAI= AIManager.getAI("player")
	local aiContext={
		enemies = self.eview,
		map=map,
		player =self.fv
	}
	local i=1
	scheduler.scheduleGlobal(function ()
		--print(enemyAI)
		-- for i =0, #self.eview do
		-- 	local ev=self.eview[i]
		-- 	enemyAI:run(aiContext, ev:getModel(), ev)
		-- end
		local ev=self.eview[i]
		if(ev) then
			if (not ev.markAsRemove) then
				enemyAI:run(aiContext, ev:getModel(), ev)
			else
				table.remove(self.eview, i)
				--	2秒后删除自己
				scheduler.performWithDelayGlobal(function ()
					ev:removeSelf()
				end, 2)

			end
		end
		i=i+1
		if (i>table.getn(self.eview)) then i=1 end
	end
	, 0.2) -- 敌人AI
	scheduler.scheduleGlobal(function ()
		playerAI:run(aiContext)
		printf("self.eview len %d",#self.eview)
	end
	,1) --玩家AI

end
local actions={"start","move","stop","attack","stop","injure","stop"}
local actionId=2


function TestMap:printMap(map)
	local  pChildrenArray = map:getChildren()
    local  child          = nil
    local  pObject        = nil
    local  i              = 0
    local  len            = pChildrenArray:count()

    for i = 0, len-1, 1 do
        -- child = tolua.cast(pChildrenArray:objectAtIndex(i), "CCSpriteBatchNode")
        if child == nil then
            break
        end
        print(child)
        -- child:getTexture():setAntiAliasTexParameters()
    end
end

function TestMap:onTouch(event)
	--self.enemy[#self.enemy]:doEvent("die");
	--self.enemy[#self.enemy]:moveTo(10, event.x,event.y)

	-- self.ev:pos(event.x,event.y)
	-- self.ev:moveTo( event.x,event.y)
	-- self.fv:pos(event.x,event.y)
	--self.fox:attack();
	-- self.fv.absPostion

	local map = self.layer:getChildByTag(1)
	-- self:printMap(map)
	local fv=self.fv
	local fx,fy=self.fv:getPosition();

	local mapsize=map:getContentSize()
	print("map width ", mapsize.width)
	print("map height ", mapsize.height)
	printf("fx=%d,fy=%d", fx,fy)
	local fsize=fv:getContentSize();

	-- self.fv.absPostion.x=self.fv.absPostion.x+10
	-- self.fv.absPostion.y=self.fv.absPostion.y+100
	-- local ap=self.fv.absPostion;
	local tpx,tpy =0,0--ap.x,ap.y;
	-- if (tpx+100>=mapsize.width) then tpx=mapsize.width-100 end
	-- if (tpy+100>=mapsize.height) then tpy=mapsize.height-100 end
	-- local act=CCMoveTo:create(ccpDistance(), ccp(tpx,tpy))
	-- self.fv:runAction(act)

	--dump(self.fv.absPostion)
	--调整地图视觉位置
	local mx,my =0,0
	local nx,ny;
	--[[
	nx=math.modf(fx/display.width)
	if (nx>0) then
		mx=-mapsize.width+nx*display.width;
	end
	ny=math.modf(fy/(display.height*0.8) )
	if (ny>0) then
		my=-mapsize.height+ny*display.height;
	end
	]]
	local mapx,mapy =map:getPosition()
	tpx= -mapx+event.x
	tpy= -mapy+event.y
	if (tpx+100>=mapsize.width) then tpx=mapsize.width-100 end
	if (tpy+200>=mapsize.height) then tpy=mapsize.height-200 end

	-- if (tpx<fx) then
	-- 	if (self.fv:getFlipX()==-1) then
	-- 	self.fv:setFlipX(1) end
	-- else
	-- 	if (self.fv:getFlipX()==1) then
	-- 	self.fv:setFlipX(-1) end
	-- end
	-- local tgp =ccp(tpx, tpy)

	-- local act=CCMoveTo:create(ccpDistance(ccp(fx, fy),tgp) /500, tgp)

	-- local arr=CCArray:create()
	-- arr:addObject(CCCallFunc:create(function()
	-- 	self.fox:doEvent("move")
	-- end))
	-- arr:addObject(act)
	-- arr:addObject(CCCallFunc:create(function()
	-- 	self.fox:doEvent("stop")
	-- end))
	-- self.fv:stopAllActions()
	-- self.fv:runAction(CCSequence:create(arr))
	if (self.fv.model:canMove()) then
		self.fv:moveTo(tpx, tpy)
	end
	-- self.fox:doEvent("die")

	fx=tpx+200
	fy=tpy+200
	nx=math.modf(fx/display.width)
	if (nx>0) then
		mx=-mapsize.width+nx*display.width;
	end
	ny=math.modf(fy/(display.height*0.8) )
	if (ny>0) then
		my=-mapsize.height+ny*display.height;
	end
	--[[
	if(ap.x>display.width*0.7)then
		mx=-display.width*0.3;
	end
	if(ap.y>display.height*0.7)then
		my=-display.height*0.3;
	end]]
	--map:pos(mx, my)
	local tgmp=ccp(mx, my);
	map:stopAllActions()
	map:runAction(CCMoveTo:create(ccpDistance(ccp(mapx, mapy),tgmp) /500, tgmp))
	--map:pos(event.x,event.y)
	-- self.fox:attack();


	--self.fox:say("我靠"..tostring(actionId))
	--actionId=actionId+1;
	--self.fox:attack()
	-- self.fox:getInjured(15);
	--self.fox:doEvent("die")
	--[[
	for i =0, #self.enemy do
		local en=self.enemy[i]
		--en:attack()
		en:say("我试试"..i,i)
		--en:doEvent("move");
		en:getInjured(1588)
	end
	]]
	-- return true
end

return TestMap