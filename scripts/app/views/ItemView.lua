--
-- Author: Black Lotus
-- Date: 2014-09-26 13:01:27
--

--[[--
Item的视图
视图注册模型事件，从而在模型发生变化时自动更新视图
]]

local ItemView = class("ItemView", function()
    return CCNode:create();
end)

ItemView.color={}
ItemView.color[0] = cc.c3b(255, 255, 255) --白
ItemView.color[1] = cc.c3b(104, 213, 237) --蓝
ItemView.color[2] = cc.c3b(179, 107, 225) --紫
ItemView.color[3] = cc.c3b(225, 0  , 240) --粉
ItemView.color[4] = cc.c3b(255, 177, 0  ) --橙


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

--初始化所有动作
function ItemView:initAnimate()
	self.animate={};

end
--让物品随机正向/反向摆放
function ItemView:randomFlip()
	--math.randomseed(os.time())
	--math.randomseed(tostring(os.time()):reverse():sub(1, 6))
	local rd= math.random(100);
	self.sprite_:flipX(rd>50)
end
function ItemView:ctor(model)
    local cls = model.class
    --self:initAnimate();
    cc.EventProxy.new(model, self)
    :addEventListener(cls.CHANGE_STATE_EVENT, handler(self, self.onStateChange_))
        -- :addEventListener(cls.KILL_EVENT, handler(self, self.onKill_))
        -- :addEventListener(cls.HP_CHANGED_EVENT, handler(self, self.updateLabel_))
        -- :addEventListener(cls.EXP_CHANGED_EVENT, handler(self, self.updateLabel_))
    self.model_ = model
    local img =string.format("item/%s/%s.png", model:getCatalog(),model:getId())
    self.sprite_ = CCSprite:create(img):addTo(self)
    self:randomFlip()

	local bs =CCScale9Sprite:create("gui/box_2l.png") --Button:create()
	--bs:setOpacity(250)
	local lbl=CCLabelTTF:create();
	self.idLabel_ =lbl;
	lbl:setColor(ItemView.color[model:getQuality()])
	lbl:setFontSize(12)
	lbl:setString(string.format(" %s ",model:getName() ) )
	local lsz=lbl:getContentSize()
	bs:size(lsz.width+2,lsz.height+6)
	--lbl:pos(bs:getPosition())
	lbl:pos( bs:getContentSize().width - lbl:getContentSize().width/2, bs:getContentSize().height / 2+1)
	bs:addChild(lbl)
	bs:setPosition(ccp(-5, self.sprite_:getContentSize().height+5))

	self:addChild(bs)

    self.sprite_:setAnchorPoint(ccp(0.65, 0.40))
    self.stateLabel_ = ui.newTTFLabelWithShadow({
            text = "",
            size = 14,
            color = cc.c3b(147, 250, 196),
            -- shadowColor= cc.c3b(100, 100, 100)
        })
   -- self.stateLabel_:getTexture():setAliasTexParameters()

    self.stateLabel_
    :pos(0, 70)
   	:addTo(self)

    self:updateSprite_(self.model_:getState())
    -- self.sprite_:runAction(self.animate["idle"])
    self:updateLabel_()
end

function ItemView:flipX(flip)
    self.sprite_:flipX(flip)
    return self
end

function ItemView:isFlipX()
    return self.sprite_:isFlipX()
end

function ItemView:onStateChange_(event)
    self:updateSprite_(self.model_:getState())
end


function ItemView:updateLabel_()
    --local h = self.model_
    --self.stateLabel_:setString(string.format("LV.exp:%d.%d\nhp:%d attack:%d armor:%d",
    --   h:getLevel(), h:getExp(), h:getHp(), h:getAttack(), h:getArmor()))
end

function ItemView:updateSprite_(state)
	--self.sprite_:runAction(self.animate["idle"])
end

return ItemView
