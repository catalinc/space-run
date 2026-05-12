local physics = require("physics")
local EachFrame = require("libs.EachFrame")
local SpriteSheet = require("engine.shared.SpriteSheet")
local Pool = require("engine.shared.Pool")

local MIN_X = -100
local MAX_X = display.contentWidth + 100
local MIN_Y = -100
local MAX_Y = display.contentHeight + 100

-- typeId and physics category/mask bits per weapon name
local WEAPON_TYPES = {
  PlayerWeapon = {id = 5, cat = 0x0010, mask = 0x000E},
  EnemyWeapon  = {id = 6, cat = 0x0020, mask = 0x0005},
}

local function release(self)
  transition.cancel(self)
  EachFrame.remove(self)
  self.isVisible = false
  self.behaviour = nil
  -- isBodyActive cannot be set during a collision callback (world is locked),
  -- so defer the physics deactivation and pool insertion to the next frame.
  timer.performWithDelay(0, function()
    self.isBodyActive = false
    Pool.put(self.name, self)
  end)
end

local function eachFrame(self)
  if self.x < MIN_X or self.x > MAX_X or
    self.y < MIN_Y or self.y > MAX_Y then
    self:release()
    return
  end
  if self.behaviour then
    self.behaviour(self)
  end
end

local function finalize(self)
  EachFrame.remove(self)
end

local Weapon = {}

function Weapon.create(source, options)
  local weaponName = source.name .. "Weapon"
  local sprite = options.sprite
  local typeInfo = WEAPON_TYPES[weaponName]

  -- A deferred timer may have pooled a weapon after World:destroy() cleared the pool,
  -- leaving a dead proxy in the store. Discard it and fall through to create a fresh one.
  local pooled = Pool.get(weaponName)
  local newWeapon
  if pooled and display.isValid(pooled) then
    source.parent:insert(pooled)
    pooled.isVisible = true
    newWeapon = pooled
  end

  if not newWeapon then
    newWeapon = display.newImageRect(source.parent, SpriteSheet, sprite.frameIndex, sprite.width, sprite.height)
    newWeapon.name = weaponName
    newWeapon.isBullet = true
    newWeapon.eachFrame = eachFrame
    newWeapon.release = release
    newWeapon.finalize = finalize
    newWeapon:addEventListener("finalize")

    if typeInfo then
      newWeapon.typeId = typeInfo.id
    end

    physics.addBody(newWeapon, "dynamic", {
      isSensor = true,
      categoryBits = typeInfo and typeInfo.cat or nil,
      maskBits = typeInfo and typeInfo.mask or nil,
    })
  end

  newWeapon.source = source
  newWeapon.damage = options.damage or source.damage
  newWeapon.x = source.x
  newWeapon.y = source.y
  newWeapon:toBack()

  newWeapon.isBodyActive = true
  EachFrame.add(newWeapon)

  return newWeapon
end

return Weapon
