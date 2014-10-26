--
-- Author: Black Lotus
-- Date: 2014-09-23 08:35:03
--

local Fox = import("..models.Fox")
local FoxView = import("..views.FoxView")

local Enemy = import("..models.Enemy")
local EnemyView = import("..views.EnemyView")

local Item = import("..models.Item")
local ItemView = import("..views.ItemView")
local PlayerStateView = import("..views.PlayerStateView")
local AIManager = import("..ai.AIManager")

local GameMap =class("GameMap",function()
	return display.newScene("GameMap")
	--return CCScene:create();
end)
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
function GameMap:ctor()
end
function GameMap:onEnter()
	audio.playMusic("sounds/bgm/015-Theme04.mp3", true)

	local layer=CCLayer:create();
	local  map = CCTMXTiledMap:create("map/test.tmx")

	local  s = map:getContentSize()
    printf("ContentSize: %f, %f", s.width,s.height)
     local  mlayer = map:layerNamed("base")
     local mlayer3=map:layerNamed("layer3")
    mlayer:getTexture():setAntiAliasTexParameters()
    local tile0 = mlayer:tileAt(ccp(10,10))
    --print(tile0:getPosition())
    local s= map:getContentSize()
    -- map:setAnchorPoint(ccp(0,0))
  	map:setPosition(ccp(0,0))
    layer:addChild(map,0,1)
    layer:setTouchSwallowEnabled(false)
    layer:setTouchEnabled(true)
    self.layer =layer

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
	    	nickname="雪山飞贼",
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
	self._uiLayer = TouchGroup:create()

	local tl = CCLayer:create();
	local layout = Layout:create()
	layout:setSize(CCSize(150, 150))

    self:addChild(self._uiLayer)
	--self.fox:attack();
	-- self.fox:attack();
	local flip =1;
	tl:addNodeEventListener(NODE_TOUCH_EVENT, handler(self, self.onTouch))
	tl:addNodeEventListener(KEYPAD_EVENT, handler(self,self.onPressKey))
	tl:setTouchEnabled(true)
	tl:setKeypadEnabled(true)
	tl:setTouchSwallowEnabled(false)
	self:addChild(tl)

	local enemyAI = AIManager.getAI("enemy")
	local playerAI= AIManager.getAI("player")
	local aiContext={
		enemies = self.eview,
		map=map,
		player =self.fv
	}
	local i=1
	self.enaihandler=scheduler.scheduleGlobal(function ()
		local ev=self.eview[i]
		if(ev) then
			if (not ev.markAsRemove) then
				enemyAI:run(aiContext, ev:getModel(), ev)
			else
				table.remove(self.eview, i)
				--	2秒后删除自己
				scheduler.performWithDelayGlobal(function ()
					ev:removeSelf()
					local new_enemy = Enemy.new({
				    	id=tostring(math.random(1,8)),
				    	-- id ="_2",
				    	level=math.random(1,self.fox:getLevel()),
				    	nickname="雪山飞贼_new"
				    })
				    local nev =EnemyView.new(new_enemy);

				    --self.iv:pos(display.cx, display.cy)
				    nev:pos(math.random(display.width), math.random(display.height) )
				    nev:setZOrder(2)
				    map:addChild(nev)
				    table.insert(self.eview,nev)
				end, 2)

			end
		end
		i=i+1
		if (i>table.getn(self.eview)) then i=1 end
	end
	, 0.2) -- 敌人AI
	self.playeraihandler=scheduler.scheduleGlobal(function ()
		playerAI:run(aiContext)
	end
	,1) --玩家AI

end
local actions={"start","move","stop","attack","stop","injure","stop"}
local actionId=2

function GameMap:onPressKey(event)
	if (event.key =="back") then
		scheduler.unscheduleGlobal(self.enaihandler)
		scheduler.unscheduleGlobal(self.playeraihandler)
		display.replaceScene(require("app.scenes.MainMenu").new())
	end

end
function GameMap:printMap(map)
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

function GameMap:onTouch(event)

	local map = self.layer:getChildByTag(1)
	-- self:printMap(map)
	local fv=self.fv
	local fx,fy=self.fv:getPosition();

	local mapsize=map:getContentSize()
	print("map width ", mapsize.width)
	print("map height ", mapsize.height)
	printf("fx=%d,fy=%d", fx,fy)
	local fsize=fv:getContentSize();

	local tpx,tpy =0,0--ap.x,ap.y;
	--调整地图视觉位置
	local mx,my =0,0
	local nx,ny;

	local mapx,mapy =map:getPosition()
	tpx= -mapx+event.x
	tpy= -mapy+event.y
	if (tpx+100>=mapsize.width) then tpx=mapsize.width-100 end
	if (tpy+200>=mapsize.height) then tpy=mapsize.height-200 end

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
	local tgmp=ccp(mx, my);
	map:stopAllActions()
	map:runAction(CCMoveTo:create(ccpDistance(ccp(mapx, mapy),tgmp) /500, tgmp))
end

return GameMap