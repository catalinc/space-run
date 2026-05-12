local physics = require("physics")
local EachFrame = require("libs.EachFrame")
local SpriteSheet = require("engine.shared.SpriteSheet")
local EventBus = require("engine.shared.EventBus")
local HealthBar = require("engine.unit.HealthBar")

local MIN_X = -100
local MAX_X = display.contentWidth + 100
local MIN_Y = -100
local MAX_Y = display.contentHeight + 100
local START_X = display.contentWidth / 2
local START_Y = -40

-- typeId and physics category/mask bits per unit name
local UNIT_TYPES = {
  Player   = {id = 1, cat = 0x0001, mask = 0x002E},
  Enemy    = {id = 2, cat = 0x0002, mask = 0x0011},
  Asteroid = {id = 3, cat = 0x0004, mask = 0x0031},
  Mine     = {id = 4, cat = 0x0008, mask = 0x0011},
}

local function eachFrame(self)
  if self.x < MIN_X or self.x > MAX_X or
    self.y < MIN_Y or self.y > MAX_Y then
    display.remove(self)
    return
  end
  if self.healthBar then
    self.healthBar.x = self.x + self.healthBarOffsetX
    self.healthBar.y = self.y + self.healthBarOffsetY
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

function Unit.create(name, group, x, y, options)
  local sprite = options.sprite
  local newUnit = display.newImageRect(group, SpriteSheet, sprite.frameIndex, sprite.width, sprite.height)

  newUnit.name = name
  newUnit.x = x or START_X
  newUnit.y = y or START_Y
  newUnit.state = "idle"
  newUnit.damage = options.damage or 1
  newUnit.behaviour = options.behaviour
  newUnit.lives = options.maxLives or 1
  newUnit.maxHealth = options.maxHealth or 100
  newUnit.health = newUnit.maxHealth

  local typeInfo = UNIT_TYPES[name]
  if typeInfo then
    newUnit.typeId = typeInfo.id
  end

  if options.showHealthBar then
    local offsetX = -(newUnit.contentWidth / 2) + 5
    local offsetY = -(newUnit.contentHeight / 2) - 5
    newUnit.healthBar = HealthBar.create(group, newUnit.x + offsetX, newUnit.y + offsetY, newUnit.contentWidth - 10, 5)
    newUnit.healthBarOffsetX = offsetX
    newUnit.healthBarOffsetY = offsetY
  end

  newUnit.eachFrame = eachFrame
  EachFrame.add(newUnit)
  newUnit.takeDamage = takeDamage
  newUnit.isDead = isDead
  newUnit.finalize = finalize
  newUnit:addEventListener("finalize")

  -- Merge physics options with collision category/mask bits
  local phys = options.physics or {}
  local bodyOpts = {}
  for k, v in pairs(phys) do bodyOpts[k] = v end
  if not bodyOpts.radius then bodyOpts.radius = 1 end
  if typeInfo then
    bodyOpts.categoryBits = typeInfo.cat
    bodyOpts.maskBits = typeInfo.mask
  end
  physics.addBody(newUnit, "dynamic", bodyOpts)

  EventBus.publish("unitCreated", newUnit)

  return newUnit
end

return Unit
