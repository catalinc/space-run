local Sounds = require("libs.Sounds")
local EachFrame = require("libs.EachFrame")
local Weapon = require("engine.weapons.Weapon")

local options = {
  sprite = {frameIndex = 5, width = 14, height = 40},
}

local function fire(self, options)
  if options.playSound then
    Sounds.play("fire")
  end

  self.target = options.target
  self.speed = options.speed or 1
  self.maxAge = options.maxAge or 3000
  self.age = 0
end

local function behaviour(self)
  if (not self.target) or self.target.state == "exploding" then
    display.remove(self)
    return
  end
  local dx = self.target.x - self.x
  local dy = self.target.y - self.y
  local angle = math.deg(math.atan2(dy, dx)) + 90
  if angle < 0 then angle = angle + 360 end
  angle = angle % 360
  local dt = EachFrame.deltaTime / 1000
  self.x = self.x + (dx * self.speed * dt)
  self.y = self.y + (dy * self.speed * dt)
  self.rotation = angle

  self.age = self.age + EachFrame.deltaTime
  if self.age >= self.maxAge then display.remove(self) end
end

local Missile = {}

function Missile.create(source)
  local newMissile = Weapon.create(source, options)

  newMissile.fire = fire
  newMissile.behaviour = behaviour

  return newMissile
end

return Missile
