--
-- Author: Black Lotus
-- Date: 2014-09-27 16:56:12
--
--[[
显示玩家状态
比如 昵称、HP、EXP的视图
]]
local PlayerStateView = class("PlayerStateView", function()
    return CCNode:create();
end)

function PlayerStateView:ctor(model)
	self.model =model

	cc.EventProxy.new(model, self)
        :addEventListener("injure", handler(self, self.updateValue))
        :addEventListener("gainExp", handler(self, self.updateExp))

    local cls = model.class
	--self.sprite_ = CCSprite:create()
    --self:addChild(self.sprite_)
    --- text information
    local bs =CCScale9Sprite:create("gui/box_2.png")
   	bs:setOpacity(220)
    local lbl=CCLabelTTF:create();
    lbl:setFontSize(21)

    lbl:setString(string.format(" %s ",model:getNickname()) )
    local lsz=lbl:getContentSize()
    bs:size(lsz.width,60)
    --lbl:pos(bs:getPosition())
    lbl:pos( bs:getContentSize().width - lbl:getContentSize().width/2, bs:getContentSize().height / 2)
    bs:addChild(lbl)
    lbl:setTag(1)
    --bs:setPosition(ccp(-5, 100)) --115
    bs:setTag(1)
    self:addChild(bs)
    bs:setAnchorPoint(ccp(0, 1))

	local box=CCScale9Sprite:create("gui/box_2.png")
	box:setAnchorPoint(ccp(0, 1))
	box:size(190,60)
	box:setOpacity(120)

    local lblv=CCLabelTTF:create();
    lblv:setFontSize(19)
    lblv:setColor(ccc3(238, 214, 124))
    -- lblv:setString(string.format("lv:%s",1) )

    --box:pos(bs:getPositionX()+bs:getContentSize().width/2+box:getContentSize().width/2, bs:getPositionY())
    box:pos (bs:getContentSize().width,0)

    --lblv:pos(bs:getPositionX()+bs:getContentSize().width/2,45)
    -- lblv:ignoreAnchorPointForPosition(false);
    lblv:setAnchorPoint(ccp(0, 1))
    lblv:pos(10,60)
    self.lblv=lblv
    box:addChild(lblv)
	self:addChild(box)
	self:setContentSize(CCSize(bs:getContentSize().width+box:getContentSize().width, 60))
	self:ignoreAnchorPointForPosition(false);
 	self:setAnchorPoint(ccp(0, 1))

 	local lbexp=CCLabelTTF:create();
    lbexp:setFontSize(15)
    lbexp:setAnchorPoint(ccp(0, 1))
    lbexp:pos(10,60-22)
    lbexp:setColor(ccc3(255, 255, 255))
    -- lbexp:setString(string.format(
    -- 	"exp:%d/%d\nattack/armor:%d/%d"
    -- 	,self.model:getExp(),self.model:getNextLvExp()
    -- 	,self.model:getAttack(),self.model:getArmor()
    -- 	) )

    self.lbexp = lbexp;

    self:updateExp()
    box:addChild(lbexp)

    local boxhp=CCScale9Sprite:create("gui/hps.png")
	boxhp:setOpacity(222)
    boxhp:setAnchorPoint(ccp(0, 1))
    boxhp:size(self:getContentSize().width,13)
    boxhp:pos(0,-60)
	self.boxhp=boxhp;
	self:addChild(boxhp)

	local lbhp =CCLabelTTF:create()
	lbhp:setAnchorPoint(ccp(0, 1))
	lbhp:setString(string.format(" %d/%d ",self.model:getHp(),self.model:getMaxHp()) )
	lbhp:pos(5,-58)
	lbhp:setFontSize(13)
	-- boxhp:addChild( lbhp)
	self:addChild(lbhp)
	self.lbhp = lbhp
    -- local debug =CCScale9Sprite:create("gui/dnf/32.png")
    -- debug:size(self:getContentSize()):addTo(self)
end

function PlayerStateView:updateExp(event)
    print(self.model:getExp())
    print(self.model:getNextLvExp())
    print(self.model:getAttack())
     print(self.model:getArmor())
    self.lbexp:setString(string.format(
        "exp:%d/%d\nattack/armor:%d/%d"
        ,self.model:getExp(),self.model:getNextLvExp()
        ,self.model:getAttack(),self.model:getArmor()
    ) )
    self.lblv:setString(string.format("lv:%s",self.model:getLevel()) )
end

function PlayerStateView:updateValue(event)
	print("PlayerStateView:updateValue()")
    local hp =self.model:getHp()
	local percent = hp/self.model:getMaxHp()
	self.lbhp:setString(string.format(" %d/%d ",self.model:getHp(),self.model:getMaxHp()) )
	if (hp>0) then
		self.boxhp:setVisible(true)
		self.boxhp:size(self:getContentSize().width*percent,13)
	else
		self.boxhp:setVisible(false)
	end
end



return PlayerStateView