local HealthBar = {}

function HealthBar.create(group, x, y, width, height)
  width = width or 35
  height = height or 6

  local newBar = display.newGroup()
  newBar.anchorX = 0
  newBar.anchorY = 0
  newBar.anchorChildren = true

  local redBar = display.newRect(0, 0, width, height)
  redBar.anchorX = 0
  redBar.anchorY = 0
  redBar:setFillColor(255, 0, 0)
  newBar:insert(redBar)

  local greenBar = display.newRect(0, 0, width, height)
  greenBar.anchorX = 0
  greenBar.anchorY = 0
  greenBar:setFillColor(0, 255, 0)
  newBar:insert(greenBar)

  function newBar:setHealth(current, max)
    local percent = current / max
    if percent == 0 then percent = 0.01 end
    greenBar.xScale = percent
  end

  group:insert(newBar)
  newBar.x = x
  newBar.y = y

  return newBar
end

return HealthBar
