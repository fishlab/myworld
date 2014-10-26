
require("config")
require("framework.init")
require("framework.shortcodes")
require("framework.cc.init")

local MyApp = class("MyApp", cc.mvc.AppBase)

function MyApp:ctor()
    MyApp.super.ctor(self)
    self.objects_ = {}
end

function MyApp:run()
    cc.FileUtils:getInstance():addSearchPath("res/")
    -- CCFileUtils:sharedFileUtils():addSearchPath("res/")
    -- CCFileUtils:sharedFileUtils():addSearchPath("res/csb/")
    --CCFileUtils:sharedFileUtils():addSearchPath("res/DemoHead_UI/Resources")
    --display.addSpriteFramesWithFile(GAME_TEXTURE_DATA_FILENAME, GAME_TEXTURE_IMAGE_FILENAME)
    -- self:enterScene("TestScene")
    -- self:enterScene("FightScene");
    -- self:enterScene("TestLabelScene");
    -- self:enterScene("TestMap")
     self:enterScene("MainMenu")
    -- self:enterScene("TestAnimationFame")
end

function MyApp:setObject(id, object)
    assert(self.objects_[id] == nil, string.format("MyApp:setObject() - id \"%s\" already exists", id))
    self.objects_[id] = object
end

function MyApp:getObject(id)
    assert(self.objects_[id] ~= nil, string.format("MyApp:getObject() - id \"%s\" not exists", id))
    return self.objects_[id]
end

function MyApp:isObjectExists(id)
    return self.objects_[id] ~= nil
end

return MyApp
