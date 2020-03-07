require 'global_state'
-- player stuff
local pl_image = nil -- 16x24 tiles
local pl_quads = {}
local pl_current_quad = nil
local pl_speed = 150
local pl_bullet_speed = 250
local pl_anim_elapsed = 0
local pl_pos = {x = 0, y = 0}

function pl_load()
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

  pl_bullet_image = love.graphics.newImage("assets/laser-bolts.png")
  pl_bullet_quads = {
    love.graphics.newQuad(0, 16, 16, 16, pl_bullet_image:getDimensions()),
    love.graphics.newQuad(16, 16, 16, 16, pl_bullet_image:getDimensions()),
  }
end

function pl_update(dt)
  -- Collision check
  local coll_left = pl_pos.x <= 0
  local coll_right = pl_pos.x >= love.graphics:getWidth() - 16
  local coll_bot = pl_pos.y >= love.graphics:getHeight() - 24
  local coll_top = pl_pos.y <= 0
  local coll_enemy = false
  local coll_beam = false

  -- Position update
  pl_anim_elapsed = pl_anim_elapsed + dt
  if (love.keyboard.isDown("left") or love.keyboard.isDown("a")) and not coll_left then
    pl_pos.x = pl_pos.x - (pl_speed * dt)
    pl_state = 'moving_left'
  elseif (love.keyboard.isDown("right") or love.keyboard.isDown("d")) and not coll_right then
    pl_pos.x = pl_pos.x + (pl_speed * dt)
    pl_state = 'moving_right'
  else
    pl_state = 'moving_forward'
  end

  if (love.keyboard.isDown("up") or love.keyboard.isDown("w")) and not coll_top then
    pl_pos.y = pl_pos.y - pl_speed * dt
  elseif (love.keyboard.isDown("down") or love.keyboard.isDown("s")) and not coll_bot then
    pl_pos.y = pl_pos.y + pl_speed * dt
  end

  -- Animation update
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

  -- Bullets update (shot by player)
  local to_remove = {}
  for i,bullet in pairs(pl_bullets) do
    bullet.y = bullet.y - (pl_bullet_speed * dt)
    if bullet.y < -16 then
      table.insert(to_remove, i)
    end

    bullet.tick = bullet.tick + dt
    if bullet.tick > 0.100 then
      bullet.tick = 0
      if bullet.frame == 1 then
        bullet.frame = 2
      else
        bullet.frame = 1
      end
    end
  end

  for _, i in pairs(to_remove) do
    table.remove(pl_bullets, i)
  end
end

function pl_keyreleased(key)
   if key == "space" then
    table.insert(pl_bullets, {x = pl_pos.x, y = pl_pos.y, frame = 1, tick = 0})
   end
end

function pl_draw()
  -- Player draw
  if pl_state == 'moving_forward' or
    pl_state == 'moving_left' or
    pl_state == 'moving_right' then
      love.graphics.draw(pl_image, pl_current_quad,
        pl_pos.x, pl_pos.y)
  end

  for i,bullet in pairs(pl_bullets) do
    love.graphics.draw(pl_bullet_image, pl_bullet_quads[bullet.frame], bullet.x, bullet.y)
  end
end
