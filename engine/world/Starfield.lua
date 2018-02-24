local EachFrame = require("libs.EachFrame")

local HEIGHT = display.contentHeight
local WIDTH = display.contentWidth
local PALETTE = {{0.3}, {0.5}, {0.8}, {1.0}, {1.0, 1.0, 0}}

local w = WIDTH / 100
local h = HEIGHT / 10
local r = 3

local STAR_TYPES = {
  small = {size = 1, speed = 2, maxCount = w * h}, 
  medium = {size = 3, speed = 8, maxCount = (w / r) * (h / r)}, 
  big = {size = 5, speed = 32, maxCount = (w / (r * r)) * (h / (r * r))}, 
}

local function eachFrame(self)
  local delta = EachFrame.deltaTime / 1000 -- seconds

  if delta > 1 then delta = 0.016 end

  for i = 1, #self.stars do
    local star = self.stars[i]
    star.y = star.y + star.speed * delta
    if star.y > HEIGHT then
      star.x = math.random(WIDTH)
      star.y = math.random(1, 10)
    end
  end
end

local function start(self)
  EachFrame.add(self)
end

local function stop(self)
  EachFrame.remove(self)
end

local function destroy(self)
  for i = 1, #self.stars do
    display.remove(self.stars[i])
    self.stars[i] = nil
  end
  self.stars = nil
end

local Starfield = {}

function Starfield.new(group)
  local newStarfield = {}

  local stars = {}
  for k, v in pairs(STAR_TYPES) do
    for i = 1, v.maxCount do
      local x = math.random(WIDTH)
      local y = math.random(HEIGHT)
      local newStar = display.newCircle(group, x, y, v.size)
      newStar.speed = v.speed
      local color = PALETTE[math.random(1, #PALETTE)]
      newStar:setFillColor(unpack(color))
      stars[#stars + 1] = newStar
    end
  end

  newStarfield.stars = stars
  newStarfield.eachFrame = eachFrame
  newStarfield.start = start
  newStarfield.stop = stop
  newStarfield.destroy = destroy

  return newStarfield
end

return Starfield
