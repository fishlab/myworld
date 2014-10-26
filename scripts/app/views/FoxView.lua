--
-- Author: Black Lotus
-- Date: 2014-09-25 14:37:15
--

--[[--
Fox的视图
视图注册模型事件，从而在模型发生变化时自动更新视图
]]

-- local FoxView = class("FoxView", function()
--     return CCNode:create();
-- end)
local RoleView = import(".RoleView")
local FoxView = class("FoxView", RoleView )


local defineAnimate=function(img,targetSize,row,line,offsetX,offsetY,delay,loopCount)
	-- local pw,ph=280,280;--动画帧大小
	local cw,ch=0,0;
	local arr=CCArray:create();
	for i=0,row do
		for j=0,line do
			cw=j*460+offsetX;--动画帧便偏移量
			ch=i*300+offsetY;
			local sfame= CCSpriteFrame:create(img, CCRectMake(cw, ch, targetSize, targetSize))
			arr:addObject(sfame)
		end
	end
	local animation=CCAnimation:createWithSpriteFrames(arr,delay)
	animation:setLoops(loopCount);
	local animate=CCAnimate:create(animation)
	return animate;
end

local defineAnimation=function(img,targetSize,row,line,offsetX,offsetY,delay)
    -- local pw,ph=280,280;--动画帧大小
    local cw,ch=0,0;
    local arr=CCArray:create();
    for i=0,row do
        for j=0,line do
            cw=j*460+offsetX;--动画帧便偏移量
            ch=i*300+offsetY;
            local sfame= CCSpriteFrame:create(img, CCRectMake(cw, ch, targetSize, targetSize))
            arr:addObject(sfame)
        end
    end
    local animation=CCAnimation:createWithSpriteFrames(arr,delay)
    -- animation:setLoops(loopCount);
    return animation;
end

--初始化所有动作
function FoxView:initAnimation()
    local catalog ="fox"
    self.actionDefinition={}
    self.actionDefinition["idle"]={
        img ="fox/idle.png",
        fameSize=360,
        loop=true,
        row=2,col=4,delay=1,
        offsetX=0,offsetY=70
    }
    self.actionDefinition["attacking"]={
        img ="fox/atkd.png",
        fameSize=360,
        loop=false,
        row=2,col=4,delay=1,
        offsetX=0,offsetY=70
    }
    self.actionDefinition["injuring"]={
        img ="fox/injure.png",
        fameSize=360,
        loop=false,row=2,col=4,delay=1,
        offsetX=0,offsetY=70
    }
    self.actionDefinition["moving"]={
        img ="fox/move.png",
        fameSize=360,
        loop=true,row=2,col=4,delay=1,
        offsetX=0,offsetY=70
    }
    self.actionDefinition["dead"]={
        img ="fox/die.png",
        fameSize=360,
        loop=false,row=3,col=4,delay=1.5,
        offsetX=0,offsetY=70
    }

    self.animateCache = CCAnimationCache:sharedAnimationCache();
    for k,v in pairs(self.actionDefinition) do
        self.animateCache:addAnimation(
            --local img=catalog.."/"..k..".png"
            defineAnimation(v.img,v.fameSize,v.row-1,v.col-1,v.offsetX,v.offsetY,v.delay/(v.row*v.col)),
       catalog.."."..k)
    end
    --[[
    self.animateCache:addAnimation(defineAnimation("fox/idle.png",360,1,3,0,70,1/8,-1),
       "fox.idle")
    self.animateCache:addAnimation(defineAnimation("fox/atk.png",360,1,3,0,70,1/8,1),
       "fox.attack")
    self.animateCache:addAnimation(defineAnimation("fox/injure.png",360,1,3,0,70,1/8,1),
       "fox.injure")
    self.animateCache:addAnimation(defineAnimation("fox/move.png",360,1,3,0,70,1/8,-1),
       "fox.move")
   ]]

end

--已弃用:无效的使用方式
function FoxView:initAnimate()
    self.animate ={}
    self.animate["idle"]=defineAnimate("fox/idle.png",360,1,3,0,70,1/8,-1);
    self.animate["attacking"]=defineAnimate("fox/atk.png",360,1,3,0,70,1/8,1);
    self.animate["injuring"]=defineAnimate("fox/injure.png",360,1,3,0,70,1/8,1);
    self.animate["moving"]=defineAnimate("fox/move.png",360,1,3,0,70,1/8,-1);

end

function FoxView:ctor(model)
    FoxView.super.ctor(self, model)
    local cls = model.class

    -- self:initAnimate();
    self:initAnimation()
    -- 通过代理注册事件的好处：可以方便的在视图删除时，清理所以通过该代理注册的事件，
    -- 同时不影响目标对象上注册的其他事件
    --
    -- EventProxy.new() 第一个参数是要注册事件的对象，第二个参数是绑定的视图
    -- 如果指定了第二个参数，那么在视图删除时，会自动清理注册的事件
    cc.EventProxy.new(model, self)
        :addEventListener(cls.CHANGE_STATE_EVENT, handler(self, self.onStateChange_))
        :addEventListener(cls.KILL_EVENT, handler(self, self.onKill_))
        :addEventListener(cls.HP_CHANGED_EVENT, handler(self, self.updateLabel_))
        :addEventListener(cls.EXP_CHANGED_EVENT, handler(self, self.updateLabel_))
        :addEventListener("injure", handler(self, self.injure_))
        :addEventListener("say", handler(self, self.say))
        :addEventListener("attack", handler(self, self.attack))
        :addEventListener("attackFinish", handler(self, self.attackFinish))


    self.model_ = model
    --self.sprite_ = CCSprite:create()
    --self:addChild(self.sprite_)
	--newTTFLabel
	--[[
    self.idLabel_ = ui.newTTFLabelWithShadow({
            text = string.format("%s:%s", model:getId(), model:getNickname()),
            size = 22,
            color = display.COLOR_WHITE,
            shadowColor= cc.c3b(100, 100, 100)
    })
	]]
    --[[
	local bs =CCScale9Sprite:create("gui/box_2.png") --Button:create()
	--bs:setOpacity(120)
	local lbl=CCLabelTTF:create();
	self.idLabel_ =lbl;
	lbl:setFontSize(15)
	lbl:setString(string.format(" %s ","黑雪 Black Lotus") )
	local lsz=lbl:getContentSize()
	bs:size(lsz.width+6,lsz.height+6)
	--lbl:pos(bs:getPosition())
	lbl:pos( bs:getContentSize().width - lbl:getContentSize().width/2, bs:getContentSize().height / 2)
	bs:addChild(lbl)
	bs:setPosition(ccp(-5, 115))
	self:addChild(bs)
    ]]
    self.sprite_:setContentSize(CCSize(100, 100))
    -- local debug =CCScale9Sprite:create("gui/dnf/32.png")
    -- debug:size(self.sprite_:getContentSize()):addTo(self)

        --:pos(0, 50)
       self.sprite_:setAnchorPoint(ccp(0.65, 0.40))
      --self.sprite_:setAnchorPoint(ccp(0.6, 0.60))
       --self.idLabel_:setPosition(ccp(0, 100))
       --self.idLabel_:addTo(self)
    --[[
    self.stateLabel_ = ui.newTTFLabelWithShadow({
            text = "",
            size = 14,
            color = cc.c3b(255, 250, 250),
            -- shadowColor= cc.c3b(100, 100, 100)
        })
    -- self.stateLabel_:getTexture():setAliasTexParameters()
    self.stateLabel_:pos(0, 110)
   	:addTo(self)
    ]]

    -- self.isFlip=1;
    self.flipX=1
    self:updateSprite_(self.model_:getState())
    -- self.sprite_:runAction(self.animate["idle"])
    --self:updateLabel_()
    self:initDialog();
    self:initUILayer();
end

function FoxView:initDialog()
    local bs =CCScale9Sprite:create("gui/box_2.png") --Button:create()
    bs:setOpacity(150)
    local lbl=CCLabelTTF:create();
    self.idLabel_ =lbl;
    lbl:setFontSize(15)
    --lbl:setString(string.format(" %s ","黑雪 Black Lotus") )
    local lsz=lbl:getContentSize()
    --bs:size(lsz.width+6,lsz.height+6)
    --lbl:pos(bs:getPosition())
    --lbl:pos( bs:getContentSize().width - lbl:getContentSize().width/2, bs:getContentSize().height / 2)
    bs:addChild(lbl)
    lbl:setTag(1)
    bs:setPosition(ccp(-5, 100)) --115
    bs:setTag(1)
    bs:setVisible(false)
    self:addChild(bs)


end

function FoxView:initUILayer()
    self._uiLayer = TouchGroup:create()
    self:addChild(self._uiLayer)
end

function FoxView:setFlipX(flipx)
    self.flipX=flipx
    self.sprite_:runAction(CCScaleTo:create(0,flipx, 1))
end
function FoxView:flipX(flipx)

    --self.sprite_:flipX(flip)
    --return self
end

function FoxView:getFlipX()
    return self.flipX
    --return self.sprite_:isFlipX()
    --return self.isFlip ==-1;
end

function FoxView:ajustDirection()
     self.sprite_:runAction(CCScaleTo:create(0,-self.direction, 1))
end

function FoxView:onStateChange_(event)
    --dump(event)
    print("onStateChange:",self.model_:getState())
    self:updateSprite_(self.model_:getState())
end

function FoxView:onKill_(event)
    --local frames = display.newFrames("modelDead%04d.png", 1, 4)
    --local animation = display.newAnimation(frames, 0.6 / 4)
    --self.sprite_:playAnimationOnce(animation)
end

function FoxView:updateLabel_()
    local h = self.model_
    self.stateLabel_:setString(string.format("LV.exp:%d.%d\nhp:%d attack:%d armor:%d",
       h:getLevel(), h:getExp(), h:getHp(), h:getAttack(), h:getArmor()))
end


function FoxView:updateSprite_(state)

  printf("FoxView:updateSprite:%s",state);
  -- local ani =self.animate[state];
  -- local ani =defineAnimate("fox/atk.png",360,1,3,0,70,1/8,-1);
  local animationName = "fox."..state;
  local actionDef = self.actionDefinition[state]
  if(actionDef ~=nil ) then
        local animation =  self.animateCache:animationByName("fox."..state)
        local ani =CCAnimate:create(animation)
        if (actionDef.loop) then ani=CCRepeatForever:create(ani) end
        print("prepare to run animation:"..state)
        self.sprite_:stopAllActions();
        self.sprite_:runAction(ani)

         -- self.sprite_:runAction(CCScaleTo:create(0, self.flipX, 1))
         self:ajustDirection()

        -- self.sprite_:flipX(self.flipX==-1)

        -- self:stopAllActions();
        -- self:runAction(ani)

        -- self:runAction(CCScaleTo:create(0, self.flipX, 1))
  end
	--self.sprite_:runAction(self.animate[state])
	--[[
    local frameName
    if state == "idle" then
        frameName = "modelIdle.png"
    elseif state == "firing" then
         frameName = "modelFiring.png"
    end
    if not frameName then return end
    self.sprite_:setDisplayFrame(display.newSpriteFrame(frameName))
    ]]
end

function FoxView:injure_(event)
    print("FoxView injure()")
    local labelAtlas = LabelAtlas:create()
    -- labelAtlas:setPosition(CCPoint(event.x,event.y))
    --labelAtlas:setPosition(ccp(event.x, event.y))
    labelAtlas:setPosition(ccp(-5, 115))
    labelAtlas:setProperty(event.damage, "gui/labelatlas.png", 17, 22, "0")
    labelAtlas.count=25;
    --print(event)
    self._uiLayer:addWidget(labelAtlas)

    local px,py = labelAtlas:getPosition();
    local mvTo = CCMoveTo:create(0.9, ccp(px, py+45))

    local rmself =CCCallFunc:create(function()
        labelAtlas:removeSelf();
    end)
    labelAtlas:runAction(CCSequence:createWithTwoActions(mvTo, rmself) )

end

function FoxView:gainExp()

end

-- local scheduler=CCDirector:sharedDirector():getScheduler()
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
function FoxView:say(event)
    --self.stateLabel_:setString(event.content)
    local bs =self:getChildByTag(1)
    local lbl =bs:getChildByTag(1)
    lbl:setString(string.format(" %s ",event.content) )
    local lsz=lbl:getContentSize()
    bs:size(lsz.width+6,lsz.height+6)
    lbl:pos( bs:getContentSize().width - lbl:getContentSize().width/2, bs:getContentSize().height / 2)
    bs:setVisible(true);
    if (self.scheduleTar) then
        scheduler.unscheduleGlobal(self.scheduleTar)
    end
    self.scheduleTar=scheduler.performWithDelayGlobal(function()
            bs:setVisible(false);
        end, event.delay)
end
function FoxView:attack(even)
    audio.playSound("sounds/effect/100-Attack12.mp3",false)
end
function FoxView:attackFinish(event)
    local enemies =event.enemy
    -- dump(enemies)
    -- for i =0, #enemies do
    --     local ev = enemies[i]
    --     local em = ev.model
    --     em:getInjured(self.model:getDamage(em))
    -- end
    for k,ev in pairs(enemies) do
        local em = ev.model
        em:getInjured(self.model:getDamage(em))
        if (not em:isAlive()) then
            self.model:gainExp(em:getLevel())
        end
    end

end

return FoxView
