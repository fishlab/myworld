--[[
测试一下物理引擎
]]
local PlayDuelController = import("..controllers.PlayDuelController")
local HRocker = import ("..layers.HRocker")
local TestLua = import ("..tests.testLua")
local ci=TestLua.new();
ci:p()
local TestScene = class("TestScene", function()
    return display.newScene("TestScene")
end)

local WALL_THICKNESS  = 40  --厚度
local WALL_FRICTION   = 1.0 --摩擦力
local WALL_ELASTICITY = 0.1 --弹力

function TestScene:ctor()
	display.newColorLayer(ccc4(215, 231, 245, 255)):addTo(self);
	self:addChild(ui.newTTFLabel({
        text = "物理引擎测试",
        size = 32,
        x = display.cx,
        y = display.cy,
	   	  color = ccc3(255, 0, 0),
        align = ui.TEXT_ALIGN_CENTER
    }));





	--从json中读取ui布局，失败。
    --local nr=NodeReader:getInstance();
   	--local nr=SceneReader:sharedSceneReader();

   	---从json中读取ui布局，成功。
   	local rd=GUIReader:shareReader();
	  local ui=rd:widgetFromJsonFile("DemoHead_UI/DemoHead_UI.json");
   	self:addChild(ui);
   	--local spr=CCSprite:create();
   	--导入场景 还未测试
   	--SceneReader:sharedSceneReader():createNodeWithSceneFile("fileName", ATTACH_EMPTY_NODE)

   	--创建并播放骨骼动画
   	local sadm=CCArmatureDataManager:sharedArmatureDataManager();
   	--sadm:addArmatureFileInfo("Hero/Hero0.png","Hero/Hero0.plist","Hero/Hero.ExportJson");
   	sadm:addArmatureFileInfo("Hero/Hero.ExportJson")
   	--sadm.addArmatureFileInfo(imagePath, plistPath, configFilePath)
   	--display.addSpriteFramesWithFile("Hero/Hero0.plist","Hero/Hero0.png");

   	--local ac=CCAnimationCache:sharedAnimationCache();
   	--ac:addAnimationsWithFile("Hero/blood.plist")

   	local armature=CCArmature:create("Hero");
   	armature:setPosition(CCPoint(display.cx,display.cy))
   	self:addChild(armature);
   	armature:getAnimation():play("attack")
   	armature:getAnimation():play("run")
   	--local annimation=ac:animationByName("attack");
   	--local animate = CCAnimate:create(annimation);
   	--spr:runAction(animate);

	--local nd=nr:createNode("DemoHead_UI/DemoHead_UI.json");
	--self:addChild(nd);
	local sprite = CCSprite:create() --CCSprite:create("Button02.png", CCRectMake(0,0,85,121) );
	local m_pUILayer = TouchGroup:create();
	self:addChild(sprite)
	sprite:setScale(4.5);
	--sprite:runAction(CCJumpTo:create(4, CCPointMake(300,48), 100, 4))

	--local rect1=display.newSprite("Button01.png",display.right);
	local rect1 = display.newRect(cc.rect(0, 0, display.width, 40),
       {fillColor = cc.c4f(1,10,40,1), borderColor = cc.c4f(0,1,0,1), borderWidth = 5})
	self:addChild(rect1);
	--创建一个重力为200的物理世界
	self.world = CCPhysicsWorld:create(10, -200)

	--[[for i,v in pairs() do
		print(i,v);
	end]]
	self:addChild(self.world)
	--创建一个静态物体(地面)

	--self.world:setCollisionLayers(layers);
  --rect1:setScaleX(display.width / WALL_THICKNESS)
  local bottomWallBody = self.world:createBoxBody(0, display.width, WALL_THICKNESS)
  bottomWallBody:setFriction(WALL_FRICTION)
  bottomWallBody:setElasticity(WALL_ELASTICITY)
  bottomWallBody:bind(rect1)

  bottomWallBody:setPosition(display.cx, display.bottom + WALL_THICKNESS / 2)
	--物理引擎调试Node
	--self.worldDebug = self.world:createDebugNode()
  --self:addChild(self.worldDebug)

	local layer=CCLayer:create();
	layer:addNodeEventListener(NODE_TOUCH_EVENT,function(event)
        return self:onTouch(event.name, event.x, event.y)
  end);
	layer:setTouchEnabled(true) -- 注册后还必须启用触摸
	self:addChild(layer)

	--
	--print( tostring(self.world.userdata))
    -- add controller
    --self:addChild(PlayDuelController.new())
end
function TestScene:onTouch(event, x, y)
    if event == "began" then
    	for i=0,10 do
	        self:createPhysicObject(x-10*i, y+10*i)
	    end
    end
end
function TestScene:createPhysicObject(x, y)
	--[[local points = {
		{10, 10},  -- point 1
		{50, 50},  -- point 2
		{100, 10}, -- point 3
	}]]

	--local polygon = display.newPolygon(points)
    local circle = display.newCircle(10);

	self:addChild(circle)

	-- add sprite to scene
    --local coinSprite = display.newSprite("#Coin.png")

    -- create physic body

    local po = self.world:createCircleBody(100, 20)
    po:setFriction(0.4)
    po:setElasticity(0.1)
    -- binding sprite to body
    po:bind(circle)
    -- set body position
    po:setPosition(x, y)

end

function TestScene:onEnter()
	 self.world:start() --启动物理引擎
end

function TestScene:onExit()
end

return TestScene
