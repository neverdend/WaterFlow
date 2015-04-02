require "Cocos2d"
require "Cocos2dConstants"

local GameScene = class("GameScene",function()
    return cc.Scene:create()
end)

function GameScene.create()
    local scene = GameScene.new()
    scene:addTouchPixelTest()
    scene:addChild(scene:createBgLayer(), 0)
    scene:dataProcess()
    scene:addChild(scene:createAnimationLayer(), 1)
    return scene
end

function GameScene:ctor()
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    self.schedulerID = nil
end

-- 触摸时显示坐标
function GameScene:addTouchPixelTest()
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)
    local function onTouchBegan(touch, event)
        local location = touch:getLocation()
        cclog("position is: "..location.x..", "..location.y)
    end
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithFixedPriority(listener, 1)
end

-- create background layer
function GameScene:createBgLayer()
    local bgLayer = cc.Layer:create()
    local bgImg = cc.Sprite:create("WaterFlowBg.jpg")
    bgImg:setAnchorPoint(0.5, 0.5)
    bgImg:setPosition(self.origin.x + self.visibleSize.width/2, self.origin.y + self.visibleSize.height/2)
    bgLayer:addChild(bgImg)
    
    return bgLayer
end

function GameScene:dataProcess()
--    local file = io.open("testIo.txt","r")
--    local line = file:read("*/")
    local file = cc.FileUtils:getInstance():getStringFromFile("RESULT45000BF_reduced.TXT")
    local nextLine, remainFile = getNextLine(file)
--    while nextLine ~= nil do
--        cclog(nextLine)
--        nextLine, remainFile = getNextLine(remainFile)
--    end
    
--    保存数据
--    local data = {}
--    local dataPos = 1
--    local dataKey = {}
end

function GameScene:createAnimationLayer()
    local animationLayer = cc.Layer:create()
    animationLayer:addChild(createMovingPoint(800, 800, 1000, 1000))
    return animationLayer
end

function createMovingPoint(startPointX, startPointY, endPointX, endPointY)
    local point = cc.Sprite:create("93-dot-red-16.png")
    local placeAction = cc.Place:create(cc.p(startPointX, startPointY))
    local moveToAction = cc.MoveTo:create(2, cc.p(endPointX, endPointY))
    local sequenceAction = cc.Sequence:create(placeAction, moveToAction)
    local repeatForeverAction = cc.RepeatForever:create(sequenceAction)
    point:runAction(repeatForeverAction)
    return point
end

function getNextLine(str)
    local pos = string.find(str, "\n")
    local nextLine = nil
    local remainStr = nil
    if pos ~= nil then
        nextLine = string.sub(str, 1, pos - 1)
        remainStr = string.sub(str, pos+1)
        return nextLine, remainStr
    else
        return nil, nil
    end
end

return GameScene
