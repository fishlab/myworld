--
-- Author: Black Lotus
-- Date: 2014-09-28 18:02:29
--
local GameMap = import(".GameMap");
local MainMenu = class("MainMenu", function()
    --return CCScene:create()
     return display.newScene("MainMenu")
end)
local ccs =ccs or {}
ccs.LayoutBackGroundColorType =
{
    none = 0,
    solid = 1,
    gradient = 2,
}

function MainMenu:ctor()
end

function MainMenu:onEnter()
	audio.playMusic("sounds/bgm/014-Theme03.mp3", true)
	self:setBG()
	self:setMenu()
	self:showAbout()
end
function MainMenu:setBG()
	local sp=CCSprite:create("img/index.jpg")
	local spsz=sp:getContentSize();
	sp:setScaleX(display.width/spsz.width)
	sp:setScaleY(display.height/spsz.height)
	sp:setPosition(ccp(display.cx, display.cy))
	sp.setPosition(sp,ccp(display.cx, display.cy))
	self:addChild(sp)
end

function MainMenu:setMenu()
	self._uiLayer = TouchGroup:create()
    self:addChild(self._uiLayer)
    local layout = Layout:create()
    local name=CCLabelTTF:create();
    name:setString("我的世界")
    name:setFontSize(70);
    name:setPosition(CCPoint(display.cx, display.cy + display.cy/1.5) )
    self:addChild(name);
    -- layout:setBackGroundColorType(ccs.LayoutBackGroundColorType.gradient)
    -- layout:setBackGroundColor(ccc3(64, 64, 64), ccc3(192, 192, 192))
    -- layout:setSize(CCSize(280, 150))
    -- layout:setAnchorPoint(ccp(1,0))
    layout:setPosition( ccp(display.cx, display.cy+100) )
    self._uiLayer:addWidget(layout)

    -- CCMenuItemLabel:create(label)

    local button = Button:create()
    button:setTitleText("进入世界")
    button:setTitleFontSize(25)
    -- button:setTitleText(CCLabelTTF:create("Exit",  "Arial", 20))
    button:setTouchEnabled(true)
	button:setSize(CCSize(150,50))

	button:setOpacity(152)
	-- button:setAnchorPoint(ccp(0.5,0.5))
    button:setScale9Enabled(true)
    button:loadTextures("gui/box_2.png", "gui/box_2.png", "")
    -- button:setPosition(CCPoint(button:getSize().width / 2, layout:getSize().height - button:getSize().height / 2))
    button:addTouchEventListener(function()
    	audio.stopMusic(true)
    	display.replaceScene(GameMap.new(), "fade", 0.6, display.COLOR_WHITE)
    end)
    layout:addChild(button)

    local aboutButton = Button:create()
    aboutButton:setTitleText("游戏帮助")
    aboutButton:setTitleFontSize(20)
    aboutButton:setTouchEnabled(true)
	aboutButton:setSize(CCSize(150,50))
	aboutButton:setOpacity(152)
	-- aboutButton:setAnchorPoint(ccp(0.5,0.5))
    aboutButton:setScale9Enabled(true)
    aboutButton:loadTextures("gui/box_2.png", "gui/box_2.png", "")
    aboutButton:setPosition( CCPoint(0, button:getPositionY() - 60) )
    layout:addChild(aboutButton)

    local exitButton = Button:create()
    exitButton:setTitleText("退出游戏")
    exitButton:setTitleFontSize(20)
    exitButton:setTouchEnabled(true)
	exitButton:setSize(CCSize(150,50))
	exitButton:setOpacity(152)
    exitButton:setScale9Enabled(true)
    exitButton:loadTextures("gui/box_2.png", "gui/box_2.png", "")
    exitButton:setPosition( CCPoint(0, aboutButton:getPositionY() - 60) )
    exitButton:addTouchEventListener(function(event)
    	audio.stopMusic(true)
    	-- os.exit()
    	self:quitEvent(event)

  --   	local function onButtonClicked(event)
		--     if event.buttonIndex == 1 then
		--         os.exit()
		--     end
		-- end
		-- device.showAlert("确定退出", "真的要退出吗？", {"是的", "不"}, onButtonClicked)
    end)
    layout:addChild(exitButton)
end

function MainMenu:quitEvent(event)
  if device.platform == "android" then
    -- self.touchLayer = display.newLayer()
    -- self.touchLayer:addNodeEventListener(cc.KEYPAD_EVENT, function(event)
        --CCDirector:sharedDirector():endToLua()
        -- local javaClassName = "com/sc/game/LuajBridge"
        -- local javaMethodName = "exit"
        -- luaj.callStaticMethod(javaClassName, javaMethodName)
        CCDirector:sharedDirector():endToLua()
    -- end)
    -- self.touchLayer:setKeypadEnabled(true)
    -- self:addChild(self.touchLayer)
  else
  		os.exit()
  end
end

function MainMenu:showAbout()
	local layer=CCLayer:create()
	self:addChild(layer)
	local RichLabel = require("app.ext.RichLabel")
	local context= "[fontColor=f75d85 fontSize=28]hello world!ss!!![/fontColor]"
	local curWidth = 200
	local curHeight = 200

	local params = {
						text = context,
						dimensions = CCSize(curWidth, curHeight)
					}
	local testLabel = RichLabel:create(params)
	layer:addChild(testLabel)
	layer:setZOrder(10)
end

function MainMenu:onExit()
	--audio.stopMusic(isReleaseData)
	self:removeAllChildren()
end

return MainMenu