require 'global_state'
-- player stuff
local image = nil -- 16x24 tiles
local quads = {}
local cur_quad = nil
local speed = 150
local bullet_speed = 250
local anim_elapsed = 0
local bullet_image = nil
local bullet_quads = {}
local next_time_score = 0

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
  pl_pos = {
    x=love.graphics.getWidth() / 2 - 12,
    y=love.graphics.getHeight() - 50
  }
  anim_elapsed = 0
  cur_quad = quads[5]

  bullet_image = love.graphics.newImage("assets/laser-bolts.png")
  bullet_quads = {
    love.graphics.newQuad(0, 16, 16, 16, bullet_image:getDimensions()),
    love.graphics.newQuad(16, 16, 16, 16, bullet_image:getDimensions()),
  }
end

function pl_update(dt)
  -- Collision check
  local coll_left = pl_pos.x <= 0
  local coll_right = pl_pos.x >= love.graphics:getWidth() - 16
  local coll_bot = pl_pos.y >= love.graphics:getHeight() - 24
  local coll_top = pl_pos.y <= 0

  -- Score update
  if ellapsed_time > next_time_score then
    next_time_score = ellapsed_time + 30
    score = score + 1
  end

  -- Position update
  if game_state == 'playing' then
    if (love.keyboard.isDown("left") or love.keyboard.isDown("a")) and not coll_left then
      pl_pos.x = pl_pos.x - (speed * dt)
      pl_state = 'moving_left'
    elseif (love.keyboard.isDown("right") or love.keyboard.isDown("d")) and not coll_right then
      pl_pos.x = pl_pos.x + (speed * dt)
      pl_state = 'moving_right'
    else
      pl_state = 'moving_forward'
    end

    if (love.keyboard.isDown("up") or love.keyboard.isDown("w")) and not coll_top then
      pl_pos.y = pl_pos.y - speed * dt
    elseif (love.keyboard.isDown("down") or love.keyboard.isDown("s")) and not coll_bot then
      pl_pos.y = pl_pos.y + speed * dt
    end
  end

  -- Animation update
  anim_elapsed = anim_elapsed + dt
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

  -- Collisions with bullets/enemy ships
  for _, en_bullet in pairs(en_bullets) do
    local cb_bullet = {
      x = en_bullet.x + en_bullet.cb_x_offset,
      y = en_bullet.y + en_bullet.cb_y_offset,
      w = en_bullet.cb_width,
      h = en_bullet.cb_height
    }

    if pl_pos.x < cb_bullet.x + cb_bullet.w and
       pl_pos.x + 16 > cb_bullet.x and
       pl_pos.y < cb_bullet.y + cb_bullet.h and
       pl_pos.y + 24 > cb_bullet.y then
       pl_cur_hit_points = pl_cur_hit_points - en_bullet.damage
       en_bullet.marked_remove = true
    end
  end

  if pl_cur_hit_points <= 0 then
    lifes = lifes - 1
    pl_cur_hit_points = pl_max_hit_points
    -- TODO: Explosion & Pause

    if lifes < 0 then
      game_over()
    end
  end

  -- Bullets update (shot by player)
  local to_remove = {}
  for i,bullet in pairs(pl_bullets) do
    bullet.y = bullet.y - (bullet_speed * dt)
    if bullet.y < -16 or bullet.marked_remove then
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
    table.insert(pl_bullets, {
      x = pl_pos.x,
      y = pl_pos.y,
      damage = 50,
      width = 16,
      height = 16,
      frame = 1,
      tick = 0,
      marked_remove = false,
    })
  end
end

function pl_draw()
  -- Player draw
  if pl_state == 'moving_forward' or
    pl_state == 'moving_left' or
    pl_state == 'moving_right' then
      love.graphics.draw(image, cur_quad,
        pl_pos.x, pl_pos.y)
  end

  for i,bullet in pairs(pl_bullets) do
    love.graphics.draw(bullet_image, bullet_quads[bullet.frame], bullet.x, bullet.y)
  end
end
