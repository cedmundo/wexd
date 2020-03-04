-- main.lua
-- infinite background stuff
local bg_image = nil
local bg_quad = nil
local bg_speed = 100
local bg_offset0 = 0
local bg_offset1 = 0

-- menu and stuff
local title_font = nil
local ui_font = nil
local ui_hud = true
local score = 0
local lifes = 2

function love.load()
  love.window.setTitle(".:: WEXD ::.")

  -- Load background
  bg_image = love.graphics.newImage('assets/background-1.png')
  bg_quad = love.graphics.newQuad(0, 0,
    bg_image:getWidth(), bg_image:getHeight(), bg_image:getDimensions())

  love.window.setMode(bg_image:getWidth(), bg_image:getHeight() - 1, {})
  bg_offset1 = - bg_image:getHeight()

  -- Load fonts
  title_font = love.graphics.newFont("assets/neuropol.ttf", 28)
  ui_font = love.graphics.newFont("assets/neuropol.ttf", 14)
end

function love.update()
  dt = love.timer.getDelta()
  bg_offset0 = bg_offset0 + dt * bg_speed
  if bg_offset0 > love.graphics.getHeight() then
    bg_offset0 = - bg_image:getHeight()
  end

  bg_offset1 = bg_offset1 + dt * bg_speed
  if bg_offset1  > love.graphics.getHeight() then
    bg_offset1 = - bg_image:getHeight()
  end
end

function love.draw()
  love.graphics.draw(bg_image, bg_quad, 0, bg_offset0)
  love.graphics.draw(bg_image, bg_quad, 0, bg_offset1)

  if ui_hud then
    love.graphics.setFont(ui_font)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print("Score: " .. score, 10, 10)
  else
    love.graphics.setFont(title_font)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf("WEXD", 0, love.graphics.getHeight() / 2, love.graphics.getWidth(), "center")
  end
end
