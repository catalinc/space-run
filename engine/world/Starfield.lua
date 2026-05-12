local EachFrame = require("libs.EachFrame")

local HEIGHT = display.contentHeight
local WIDTH = display.contentWidth
local HALF_W = WIDTH / 2
local HALF_H = HEIGHT / 2
local PALETTE = {{0.3}, {0.5}, {0.8}, {1.0}, {1.0, 1.0, 0}}

local w = WIDTH / 100
local h = HEIGHT / 10
local r = 3

local STAR_TYPES = {
  small  = {size = 1, speed = 2,  maxCount = w * h},
  medium = {size = 3, speed = 8,  maxCount = (w / r) * (h / r)},
  big    = {size = 5, speed = 32, maxCount = (w / (r * r)) * (h / (r * r))},
}

local function eachFrame(self)
  local delta = EachFrame.deltaTime / 1000
  if delta > 0.05 then delta = 0.05 end

  local stars = self.stars
  for i = 1, #stars do
    local star = stars[i]
    star.y = star.y + star.speed * delta
    if star.y > HALF_H then
      star.x = math.random(WIDTH) - HALF_W
      star.y = -HALF_H + math.random(1, 10)
    end
  end
  self.snapshot:invalidate()
end

local function start(self)
  EachFrame.add(self)
end

local function stop(self)
  EachFrame.remove(self)
end

local function destroy(self)
  EachFrame.remove(self)
  display.remove(self.snapshot)
  self.snapshot = nil
  self.stars = nil
end

local Starfield = {}

function Starfield.new(group)
  local newStarfield = {}

  -- Single snapshot batches all star draw calls into one GPU quad
  local snapshot = display.newSnapshot(group, WIDTH, HEIGHT)
  snapshot.x = HALF_W
  snapshot.y = HALF_H

  local stars = {}
  for k, v in pairs(STAR_TYPES) do
    local size = v.size
    for i = 1, v.maxCount do
      -- Snapshot children use coordinates relative to snapshot center
      local sx = math.random(WIDTH) - HALF_W
      local sy = math.random(HEIGHT) - HALF_H
      local star = display.newRect(snapshot.group, sx, sy, size * 2, size * 2)
      star.speed = v.speed
      local color = PALETTE[math.random(1, #PALETTE)]
      star:setFillColor(unpack(color))
      stars[#stars + 1] = star
    end
  end

  snapshot:invalidate()

  newStarfield.snapshot = snapshot
  newStarfield.stars = stars
  newStarfield.eachFrame = eachFrame
  newStarfield.start = start
  newStarfield.stop = stop
  newStarfield.destroy = destroy

  return newStarfield
end

return Starfield
