require 'global_state'
-- player stuff
local image = nil -- 16x24 tiles
local quads = {}
local cur_quad = nil
local speed = 150
local bullet_speed = 250
local anim_elapsed = 0
local pos = {x = 0, y = 0}

function pl_load()
  -- Load player stuff
  image = love.graphics.newImage("assets/player.png")
  quads = {
    love.graphics.newQuad(0, 0, 16, 24, image:getDimensions()),
    love.graphics.newQuad(0, 24, 16, 24, image:getDimensions()),
    love.graphics.newQuad(16, 0, 16, 24, image:getDimensions()),
    love.graphics.newQuad(16, 24, 16, 24, image:getDimensions()),
    love.graphics.newQuad(32, 0, 16, 24, image:getDimensions()),
    love.graphics.newQuad(32, 24, 16, 24, image:getDimensions()),
    love.graphics.newQuad(48, 0, 16, 24, image:getDimensions()),
    love.graphics.newQuad(48, 24, 16, 24, image:getDimensions()),
    love.graphics.newQuad(64, 0, 16, 24, image:getDimensions()),
    love.graphics.newQuad(64, 24, 16, 24, image:getDimensions()),
  }
  pl_state = 'moving_forward'
  pos = {
    x=love.graphics.getWidth() / 2 - 12,
    y=love.graphics.getHeight() - 50
  }
  anim_elapsed = 0
  cur_quad = quads[5]

  pl_bullet_image = love.graphics.newImage("assets/laser-bolts.png")
  pl_bullet_quads = {
    love.graphics.newQuad(0, 16, 16, 16, pl_bullet_image:getDimensions()),
    love.graphics.newQuad(16, 16, 16, 16, pl_bullet_image:getDimensions()),
  }
end

function pl_update(dt)
  -- Collision check
  local coll_left = pos.x <= 0
  local coll_right = pos.x >= love.graphics:getWidth() - 16
  local coll_bot = pos.y >= love.graphics:getHeight() - 24
  local coll_top = pos.y <= 0
  local coll_enemy = false
  local coll_beam = false

  -- Position update
  anim_elapsed = anim_elapsed + dt
  if (love.keyboard.isDown("left") or love.keyboard.isDown("a")) and not coll_left then
    pos.x = pos.x - (speed * dt)
    pl_state = 'moving_left'
  elseif (love.keyboard.isDown("right") or love.keyboard.isDown("d")) and not coll_right then
    pos.x = pos.x + (speed * dt)
    pl_state = 'moving_right'
  else
    pl_state = 'moving_forward'
  end

  if (love.keyboard.isDown("up") or love.keyboard.isDown("w")) and not coll_top then
    pos.y = pos.y - speed * dt
  elseif (love.keyboard.isDown("down") or love.keyboard.isDown("s")) and not coll_bot then
    pos.y = pos.y + speed * dt
  end

  -- Animation update
  if anim_elapsed > 0.125 then -- 8 FPS for player
    -- TODO: Add anims for Left-Forward and Right-Forward
    anim_elapsed = 0
    if pl_state == 'moving_forward' then
      if cur_quad == quads[5] then
        cur_quad = quads[6]
      else
        cur_quad = quads[5]
      end
    elseif pl_state == 'moving_left' then
      if cur_quad == quads[1] then
        cur_quad = quads[2]
      else
        cur_quad = quads[1]
      end
    elseif pl_state == 'moving_right' then
      if cur_quad == quads[9] then
        cur_quad = quads[10]
      else
        cur_quad = quads[9]
      end
    end
  end

  -- Bullets update (shot by player)
  local to_remove = {}
  for i,bullet in pairs(pl_bullets) do
    bullet.y = bullet.y - (bullet_speed * dt)
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

  local keep_bullets = {}
  for i, bullet in pairs(pl_bullets) do
    must_remove = false
    for _, j in pairs(to_remove) do
      if j == i then must_remove = true end
    end

    if not must_remove then
      table.insert(keep_bullets, bullet)
    end
  end
  pl_bullets = keep_bullets
end

function pl_keyreleased(key)
   if key == "space" then
    table.insert(pl_bullets, {x = pos.x, y = pos.y, frame = 1, tick = 0})
   end
end

function pl_draw()
  -- Player draw
  if pl_state == 'moving_forward' or
    pl_state == 'moving_left' or
    pl_state == 'moving_right' then
      love.graphics.draw(image, cur_quad,
        pos.x, pos.y)
  end

  for i,bullet in pairs(pl_bullets) do
    love.graphics.draw(pl_bullet_image, pl_bullet_quads[bullet.frame], bullet.x, bullet.y)
  end
end
