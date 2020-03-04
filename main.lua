-- main.lua
-- common variables
local elapsed = 0

-- infinite background stuff
local bg_image = nil
local bg_quad = nil
local bg_speed = 100
local bg_offset0 = 0
local bg_offset1 = 0

-- player stuff
local pl_image = nil -- 16x24 tiles
local pl_quads = {}
local pl_current_quad = nil
local pl_speed = 150
local pl_shots = {}
local pl_shots_elapsed = 0
local pl_anim_elapsed = 0

-- menu and stuff
local title_font = nil
local ui_font = nil
local ui_hud = false
local score = 0
local lifes = 2

function love.load()
  love.window.setTitle(".:: WEXD ::.")

  -- Load background
  bg_image = love.graphics.newImage("assets/background-1.png")
  bg_quad = love.graphics.newQuad(0, 0,
    bg_image:getWidth(), bg_image:getHeight(), bg_image:getDimensions())

  love.window.setMode(bg_image:getWidth(), bg_image:getHeight() - 1, {})
  bg_offset1 = - bg_image:getHeight()

  -- Load fonts
  title_font = love.graphics.newFont("assets/neuropol.ttf", 28)
  ui_font = love.graphics.newFont("assets/neuropol.ttf", 14)

  -- Load player stuff
  pl_image = love.graphics.newImage("assets/player.png")
  pl_quads = {
    love.graphics.newQuad(0, 0, 16, 24, pl_image:getDimensions()),
    love.graphics.newQuad(0, 24, 16, 24, pl_image:getDimensions()),
    love.graphics.newQuad(16, 0, 16, 24, pl_image:getDimensions()),
    love.graphics.newQuad(16, 24, 16, 24, pl_image:getDimensions()),
    love.graphics.newQuad(32, 0, 16, 24, pl_image:getDimensions()),
    love.graphics.newQuad(32, 24, 16, 24, pl_image:getDimensions()),
    love.graphics.newQuad(48, 0, 16, 24, pl_image:getDimensions()),
    love.graphics.newQuad(48, 24, 16, 24, pl_image:getDimensions()),
    love.graphics.newQuad(64, 0, 16, 24, pl_image:getDimensions()),
    love.graphics.newQuad(64, 24, 16, 24, pl_image:getDimensions()),
  }
  pl_state = 'moving_forward'
  pl_pos = {
    x=love.graphics.getWidth() / 2 - 12, 
    y=love.graphics.getHeight() - 50
  }
  pl_anim_elapsed = 0
  pl_current_quad = pl_quads[5]
end

function love.update()
  dt = love.timer.getDelta()

  -- Background update
  bg_offset0 = bg_offset0 + dt * bg_speed
  if bg_offset0 > love.graphics.getHeight() then
    bg_offset0 = - bg_image:getHeight()
  end

  bg_offset1 = bg_offset1 + dt * bg_speed
  if bg_offset1  > love.graphics.getHeight() then
    bg_offset1 = - bg_image:getHeight()
  end

  ui_hud = not (
    pl_pos.x == love.graphics.getWidth() / 2 - 12
      and pl_pos.y == love.graphics.getHeight() - 50
  )

  -- Player update
  pl_anim_elapsed = pl_anim_elapsed + dt
  if love.keyboard.isDown("left") or love.keyboard.isDown("a") then
    pl_pos.x = pl_pos.x - pl_speed * dt
    pl_state = 'moving_left'
  elseif love.keyboard.isDown("right") or love.keyboard.isDown("d") then
    pl_pos.x = pl_pos.x + pl_speed * dt
    pl_state = 'moving_right'
  else
    pl_state = 'moving_forward'
  end

  if love.keyboard.isDown("up") or love.keyboard.isDown("w") then
    pl_pos.y = pl_pos.y - pl_speed * dt
  elseif love.keyboard.isDown("down") or love.keyboard.isDown("s") then
    pl_pos.y = pl_pos.y + pl_speed * dt
  end

  if pl_anim_elapsed > 0.125 then -- 8 FPS for player
    -- TODO: Add anims for Left-Forward and Right-Forward
    pl_anim_elapsed = 0
    if pl_state == 'moving_forward' then
      if pl_current_quad == pl_quads[5] then
        pl_current_quad = pl_quads[6]
      else
        pl_current_quad = pl_quads[5]
      end
    elseif pl_state == 'moving_left' then
      if pl_current_quad == pl_quads[1] then
        pl_current_quad = pl_quads[2]
      else
        pl_current_quad = pl_quads[1]
      end
    elseif pl_state == 'moving_right' then
      if pl_current_quad == pl_quads[9] then
        pl_current_quad = pl_quads[10]
      else
        pl_current_quad = pl_quads[9]
      end
    end
  end

  if love.keyboard.isDown("space") then
    -- SHOT
  end
end

function love.draw()
  -- Background draw
  love.graphics.draw(bg_image, bg_quad, 0, bg_offset0)
  love.graphics.draw(bg_image, bg_quad, 0, bg_offset1)

  -- HUD and Game Title draw
  if ui_hud then
    love.graphics.setFont(ui_font)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print("Score: " .. score, 10, 10)
    for i=1,lifes do
      love.graphics.draw(pl_image, pl_quads[5], love.graphics.getWidth() - 24 * i, 10)
    end
  else
    love.graphics.setFont(title_font)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf("WEXD", 0, 
      love.graphics.getHeight() / 2, love.graphics.getWidth(), "center")
  end

  -- Player draw
  if pl_state == 'moving_forward' or
    pl_state == 'moving_left' or 
    pl_state == 'moving_right' then
      love.graphics.draw(pl_image, pl_current_quad, 
        pl_pos.x, pl_pos.y)
  end
end
