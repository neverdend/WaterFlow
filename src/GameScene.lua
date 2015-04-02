require "Cocos2d"
require "Cocos2dConstants"

local GameScene = class("GameScene",function()
    return cc.Scene:create()
end)

function GameScene.create()
    local scene = GameScene.new()
--    scene:addChild(scene:createLayerFarm())
    scene:addChild(scene:createBgLayer())
    scene:dataProcess()
    scene:addChild(scene:createAnimationLayer())
    return scene
end


function GameScene:ctor()
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    self.schedulerID = nil
end

function GameScene:creatDog()
    local frameWidth = 105
    local frameHeight = 95

    -- create dog animate
    local textureDog = cc.Director:getInstance():getTextureCache():addImage("dog.png")
    local rect = cc.rect(0, 0, frameWidth, frameHeight)
    local frame0 = cc.SpriteFrame:createWithTexture(textureDog, rect)
    rect = cc.rect(frameWidth, 0, frameWidth, frameHeight)
    local frame1 = cc.SpriteFrame:createWithTexture(textureDog, rect)

    local spriteDog = cc.Sprite:createWithSpriteFrame(frame0)
    spriteDog:setPosition(self.origin.x, self.origin.y + self.visibleSize.height / 4 * 3)
    spriteDog.isPaused = false

    local animation = cc.Animation:createWithSpriteFrames({frame0,frame1}, 0.5)
    local animate = cc.Animate:create(animation);
    spriteDog:runAction(cc.RepeatForever:create(animate))

    -- moving dog at every frame
    local function tick()
        if spriteDog.isPaused then return end
        local x, y = spriteDog:getPosition()
        if x > self.origin.x + self.visibleSize.width then
            x = self.origin.x
        else
            x = x + 1
        end

        spriteDog:setPositionX(x)
    end

    self.schedulerID = cc.Director:getInstance():getScheduler():scheduleScriptFunc(tick, 0, false)

    return spriteDog
end

-- create background layer
function GameScene:createBgLayer()
    local bgLayer = cc.Layer:create()
    local bgImg = cc.Sprite:create("WaterFlowBg.jpg")
--    bgImg:setContentSize(self.visibleSize.width, self.visibleSize.height)
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
    local dot = cc.Sprite:create("93-dot-red-5.png")
    
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
