-- infinite background stuff
local bg_image = nil
local bg_quad = nil
local bg_speed = 100
local bg_offset0 = 0
local bg_offset1 = 0

function bg_load()
  -- Load background
  bg_image = love.graphics.newImage("assets/background-1.png")
  bg_quad = love.graphics.newQuad(0, 0,
    bg_image:getWidth(), bg_image:getHeight(), bg_image:getDimensions())

  love.window.setMode(bg_image:getWidth(), bg_image:getHeight() - 1, {})
  bg_offset1 = - bg_image:getHeight()
end

function bg_update(dt)
  -- Background update
  bg_offset0 = bg_offset0 + dt * bg_speed
  if bg_offset0 > love.graphics.getHeight() then
    bg_offset0 = - bg_image:getHeight()
  end

  bg_offset1 = bg_offset1 + dt * bg_speed
  if bg_offset1  > love.graphics.getHeight() then
    bg_offset1 = - bg_image:getHeight()
  end
end

function bg_draw()
  -- Background draw
  -- love.graphics.setColor(0, 0, 1, 0.5)
  love.graphics.draw(bg_image, bg_quad, 0, bg_offset0)
  love.graphics.draw(bg_image, bg_quad, 0, bg_offset1)
end
