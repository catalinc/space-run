-- Base unit

local physics = require("physics")
local EachFrame = require("libs.EachFrame")
local SpriteSheet = require("engine.SpriteSheet")
local HealthBar = require("engine.HealthBar")
local EventBus = require("engine.EventBus")

local MIN_X = -100
local MAX_X = display.contentWidth + 100
local MIN_Y = -100
local MAX_Y = display.contentHeight + 100
local START_X = display.contentWidth / 2
local START_Y = -60

local function eachFrame(self)
    if self.x < MIN_X or self.x > MAX_X or
       self.y < MIN_Y or self.y > MAX_Y then
        display.remove(self)
        return
    end
    if self.healthBar then
        self.healthBar.x = self.x - (self.contentWidth / 2) + 5
        self.healthBar.y = self.y - (self.contentHeight / 2) - 5
    end
    if self.behaviour then
        self.behaviour(self)
    end
end

local function takeDamage(self, amount)
    self.health = self.health - amount
    if self.health <= 0 then
        self.health = 0
        if self.lives > 0 then
            self.lives = self.lives - 1
        end
    end
    if self.healthBar then
        self.healthBar:setHealth(self.health, self.maxHealth)
    end
end

local function isDead(self)
    return self.lives == 0
end

local function finalize(self)
    if self.healthBar then
        display.remove(self.healthBar)
        self.healthBar = nil
    end
    EachFrame.remove(self)
    EventBus.publish("unitDestroyed", self)
end

local Unit = {}

function Unit.create(className, group, x, y, options)
    local sprite = options.sprite
    local newUnit = display.newImageRect(group, SpriteSheet, sprite.frameIndex, sprite.width, sprite.height)
    newUnit.className = className
    newUnit.x = x or START_X
    newUnit.y = y or START_Y
    newUnit.state = "idle"
    newUnit.damage = options.damage or 1
    newUnit.behaviour = options.behaviour
    newUnit.lives = options.maxLives or 1
    newUnit.maxHealth = options.maxHealth or 100
    newUnit.health = newUnit.maxHealth

    if options.showHealthBar then
        newUnit.healthBar = HealthBar.create(group, newUnit.x, newUnit.y, newUnit.contentWidth - 10, 5)
    end

    newUnit.eachFrame = eachFrame
    EachFrame.add(newUnit)
    newUnit.takeDamage = takeDamage
    newUnit.isDead = isDead
    newUnit.finalize = finalize
    newUnit:addEventListener("finalize")

    physics.addBody(newUnit, "dynamic", options.physics or {radius = 1})

    EventBus.publish("unitCreated", newUnit)

    return newUnit
end

return Unit