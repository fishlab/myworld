--
-- Author: Black Lotus
-- Date: 2014-09-27 13:27:16
--

--[[--
Fox的视图
视图注册模型事件，从而在模型发生变化时自动更新视图
]]
local RoleView = import(".RoleView")
-- local EnemyView = class("EnemyView", function()
--     return CCNode:create();
-- end)
local EnemyView = class("EnemyView", RoleView )

local defineAnimation=function(img,targetSize,row,line,offsetX,offsetY,delay)
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
    -- animation:setLoops(loopCount);
    return animation;
end

--初始化所有动作
local AnimationInited={}
function EnemyView:initAnimation(id)
    -- local catalog ="enemy"
    print("initAnimation")
    self.actionDefinition={}
    self.actionDefinition["idle"]={
        img ="enemy/"..id.."/daiji.png",
        fameSize=160,
        loop=true,
        row=2,col=4,delay=1,
        offsetX=0,offsetY=0
    }
    self.actionDefinition["attacking"]={
        img ="enemy/"..id.."/atk.png",
        fameSize=160,
        loop=false,
        row=2,col=4,delay=1,
        offsetX=0,offsetY=0
    }
    self.actionDefinition["injuring"]={
        img ="enemy/"..id.."/aida.png",
        fameSize=160,
        loop=false,
        row=2,col=4,delay=1,
        offsetX=0,offsetY=0
    }
    self.actionDefinition["moving"]={
        img ="enemy/"..id.."/yidong.png",
        fameSize=160,
        loop=true,
        row=2,col=4,delay=1,
        offsetX=0,offsetY=0
    }
    self.actionDefinition["dead"]={
        img ="enemy/"..id.."/si.png",
        fameSize=160,
        loop=false,
        row=2,col=4,delay=1,
        offsetX=0,offsetY=0
    }


    self.animateCache = CCAnimationCache:sharedAnimationCache();
     if (not AnimationInited[id]) then

	    for k,v in pairs(self.actionDefinition) do
	        self.animateCache:addAnimation(
	            defineAnimation(v.img,v.fameSize,v.row-1,v.col-1,v.offsetX,v.offsetY,v.delay/(v.row*v.col)),
	       self.catalog.."."..k)
	    end
   	 	AnimationInited[id] =true;
	end

end

function EnemyView:getModel()
	return  self.model_ ;
end


function EnemyView:ctor(model)
	EnemyView.super.ctor(self, model)
    local cls = model.class
    self.catalog="enemy"..model:getId()
   	self:initAnimation(model:getId())
    cc.EventProxy.new(model, self)
        :addEventListener(cls.CHANGE_STATE_EVENT, handler(self, self.onStateChange_))
        :addEventListener(cls.KILL_EVENT, handler(self, self.onKill_))
        :addEventListener("injure", handler(self, self.injure_))
        :addEventListener("say", handler(self, self.say))
        :addEventListener("attack", handler(self, self.attack))
        :addEventListener("attackFinish", handler(self, self.attackFinish))
        :addEventListener("die", handler(self, self.die))

    self.model_ = model
    -- self.sprite_ = CCSprite:create()
    -- self:addChild(self.sprite_)
    -- self.sprite_:setContentSize(CCSize(100, 100))
    --[[
    local debug =CCScale9Sprite:create("gui/dnf/32.png")
    debug:size(self.sprite_:getContentSize()):addTo(self)
    ]]
     self.sprite_:setAnchorPoint(ccp(0.5, 0.1))

    --self.flipX=-1;
    --self:setFlipX(1)
    self:randomDirection()
    self:updateSprite_(self.model_:getState())
    -- self.sprite_:runAction(self.animate["idle"])
    --self:updateLabel_()
    self:initStateLable()
    self:initDialog();
    self:initUILayer();
end

function EnemyView:randomDirection()
	--math.randomseed(os.time())
	--math.randomseed(tostring(os.time()):reverse():sub(1, 6))
	local rd= math.random(100);
	if (rd>50) then
		self:turnRight()
	end
end

function EnemyView:initStateLable()
    local text = string.format(" lv%d %s",self.model:getLevel(),self.model:getNickname())
    -- self.stateLabel_ = CCLabelTTF:create();
    -- self.stateLabel_:setColor(cc.c3b(238, 214, 124))
    -- self.stateLabel_:pos(0,100)
    -- self.stateLabel_:setString(text)

    self.stateLabel_ = ui.newTTFLabelWithOutline({
        text = text,
        -- font = "Arial",
        size = 16,
        color = cc.c3b(238, 214, 124),
        align = ui.TEXT_ALIGN_CENTER,
        -- valign = ui.TEXT_VALIGN_TOP,
        -- dimensions = CCSize(400, 200)
        outlineColor = cc.c3b(0,0,0)
    })
    self.stateLabel_:pos(0,100)
    self:addChild(self.stateLabel_,0,1000)

end

function EnemyView:initDialog()
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

function EnemyView:initUILayer()
    self._uiLayer = TouchGroup:create()
    self:addChild(self._uiLayer)
end
--
function EnemyView:canSee(tx,ty)
    local sx,sy = self:getPosition();
    return ccpDistance(ccp(sx,sy),ccp(tx, ty)) <= self.model_.sight_
end

function EnemyView:onStateChange_(event)
    --dump(event)
    print("onStateChange:",self.model_:getState())
    self:updateSprite_(self.model_:getState())
end


function EnemyView:updateLabel_()
    local h = self.model_
    self.stateLabel_:setString(string.format("LV.exp:%d.%d\nhp:%d attack:%d armor:%d",
       h:getLevel(), h:getExp(), h:getHp(), h:getAttack(), h:getArmor()))
end


function EnemyView:updateSprite_(state)

  printf("EnemyView:updateSprite:%s",state);
  -- local ani =self.animate[state];
  -- local ani =defineAnimate("fox/atk.png",360,1,3,0,70,1/8,-1);
  local animationName = self.catalog.."."..state;
  print(animationName)
  local actionDef = self.actionDefinition[state]
  if(actionDef ~=nil ) then
        local animation =  self.animateCache:animationByName(animationName)
        local ani =CCAnimate:create(animation)
        if (actionDef.loop) then ani=CCRepeatForever:create(ani) end
        print("EnemyView prepare to run animation:"..state)
        self.sprite_:stopAllActions();
        self.sprite_:runAction(ani)
        -- self.sprite_:runAction(CCScaleTo:create(0, -self.flipX, 1))
        self:ajustDirection()
  end

end

function EnemyView:injure_(event)
    print("EnemyView injure()")
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
-- local scheduler=CCDirector:sharedDirector():getScheduler()
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
function EnemyView:say(event)

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

function EnemyView:die(event)
    self.markAsRemove = true
    -- table.remove(self.container,self.index)
    print("EnemyView die and removeSelf()");
    -- self:removeAllChildren();
    -- self:removeChild(self.stateLabel_, true)
    -- self:removeAllChildrenWithCleanup(true)
    -- self:removeChildByTag(1000, true)
    -- self:removeSelf()
end

function EnemyView:attack(event)
    audio.playSound("sounds/effect/100-Attack12.mp3",false)
end
function EnemyView:attackFinish(event)
    local ev = event.enemy
    -- if
    local em = ev.model
    em:getInjured(self.model:getDamage(em))
end

return EnemyView
