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
--    scene:setCordScale()
    scene:addChild(scene:createAnimationLayer(), 1)
    scene:printData()
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
    -- 保存txt中的数据
    -- 需要保存的内容
    self.data = {}
    self.cordXMin = 1000000
    self.cordXMax = -1
    self.cordYMin = 1000000
    self.cordYMax = -1
    local dataIndex = 1
    local dataKey = {"gridX", "gridY", "cordX", "cordY", "veloU", "veloV", "veloUV", "waterHeight", "landHeight", "waterDepth"}
    
    -- 读取txt数据，一次读一行
    local file = cc.FileUtils:getInstance():getStringFromFile("RESULT45000BF_reduced.TXT")
    local nextLine, remainFile = getNextLine(file)
    while nextLine ~= nil do
        -- 构造数据
        dataEle = {}
        dataKeyIndex = 1
        for num in string.gmatch(nextLine, "[%d.]+") do
            dataEle[dataKey[dataKeyIndex]] = tonumber(num)
            dataKeyIndex = dataKeyIndex+1
        end
--        -- 更新self.cordXMin, cordXMax, cordYMin, cordYMax
--        if dataEle["cordX"] ~= nil and dataEle["cordX"] > self.cordXMax then
--            self.cordXMax = dataEle["cordX"]
--        end
--        if dataEle["cordX"] ~= nil and dataEle["cordX"] < self.cordXMin then
--            self.cordXMin = dataEle["cordX"]
--        end
--        if dataEle["cordY"] ~= nil and dataEle["cordY"] > self.cordYMax then
--            self.cordYMax = dataEle["cordY"]
--        end
--        if dataEle["cordY"] ~= nil and dataEle["cordY"] < self.cordYMin then
--            self.cordYMin = dataEle["cordY"]
--        end
        -- 只有过水的点才保存
        if dataEle["waterDepth"] ~= 0.05 and dataEle["waterDepth"] ~= nil then
            self.data[dataIndex] = dataEle
            dataIndex = dataIndex+1
        end
        
        nextLine, remainFile = getNextLine(remainFile)
    end
end

function GameScene:printData()
    cclog("Xmax - Xmin: "..self.cordXMax-self.cordXMin)
    cclog("Ymax - Ymin: "..self.cordYMax-self.cordYMin)
    cclog("visibleSizeWidth: "..self.visibleSize.width)
    cclog("visibleSizeHeight: "..self.visibleSize.height)
--    for key, value in ipairs(self.data) do
--        print("key is "..key)
--        for key2, value2 in pairs(value) do
--            print("\t"..key2..":"..value2)
--        end
--    end
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
