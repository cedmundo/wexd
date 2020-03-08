require 'global_state'
require 'noise'

-- Enemy
local s_image = nil
local s_quads = {}

local m_image = nil
local m_quads = {}

local b_image = nil
local b_quads = {}

local bullet_image = nil
local bullet_quads = {}

local bullets = {}
local ships = {}
local ship_tracks = {}
local next_ship_spawn = 0

function en_load()
  s_image = love.graphics.newImage("assets/enemy-small.png")
  s_quads = {
    love.graphics.newQuad(0, 0, 16, 16, s_image:getDimensions()),
    love.graphics.newQuad(16, 0, 16, 16, s_image:getDimensions()),
  }

  m_image = love.graphics.newImage("assets/enemy-medium.png")
  m_quads = {
    love.graphics.newQuad(0, 0, 32, 16, m_image:getDimensions()),
    love.graphics.newQuad(32, 0, 32, 16, m_image:getDimensions()),
  }

  b_image = love.graphics.newImage("assets/enemy-big.png")
  b_quads = {
    love.graphics.newQuad(0, 0, 32, 32, b_image:getDimensions()),
    love.graphics.newQuad(32, 0, 32, 32, b_image:getDimensions()),
  }

  bullet_image = love.graphics.newImage("assets/laser-bolts.png")
  bullet_quads = {
    love.graphics.newQuad(0, 0, 16, 16, bullet_image:getDimensions()),
    love.graphics.newQuad(16, 0, 16, 16, bullet_image:getDimensions()),
  }

  en_generate_tracks()
end

function en_update(dt)
  -- Update tracks
  if ellapsed_time > next_ship_spawn then
    next_ship_spawn = ellapsed_time + 2
    en_generate_tracks()
  end

  -- Spawn ships on tracks
  for _, track in pairs(tracks) do
    if track.ship_count < 1 then
      if track.h > 20 then
        track.ship_count = 1
        if track.h < 22 then
          track.color = {0, 0, 1, 0.5}
          en_spawn("big", track.x)
        elseif track.h < 26 then
          en_spawn("medium", track.x)
          track.color = {0, 1, 0, 0.5}
        else
          en_spawn("small", track.x)
          track.color = {1, 0, 0, 0.5}
        end
      end
    end
  end

  -- Update bullets
  local bullets_to_remove = {}
  for j,bullet in pairs(bullets) do
    bullet.y = bullet.y + bullet.speed * dt
    if bullet.y > love.graphics:getHeight() then
      table.insert(bullets_to_remove,j)
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

  -- Update current ships
  local ships_to_remove = {}
  for i,ship in pairs(ships) do
    -- Check collisions

    -- Update position
    ship.y = ship.y + ship.speed * dt
    if ship.y > love.graphics:getHeight() then
      table.insert(ships_to_remove, i)
    end

    -- Shoot
    if ship.next_shoot < ellapsed_time then
      ship.next_shoot = ellapsed_time + ship.shoot_ratio
      for _, offset in pairs(ship.shoot_offsets) do
        table.insert(bullets, {
          x = ship.x + offset[1],
          y = ship.y + offset[2],
          speed = ship.bullet_speed,
          frame = 1,
          tick = 0
        })
      end
    end

    -- Update animations
    ship.tick = ship.tick + dt
    if ship.tick > 0.125 then
      ship.tick = 0
      if ship.cur_quad == ship.all_quads[1] then
        ship.cur_quad = ship.all_quads[2]
      else
        ship.cur_quad = ship.all_quads[1]
      end
    end
  end

  -- TODO: Refactor this into a function
  -- Remove ships outside window
  local keep_ships = {}
  for i, ship in pairs(ships) do
    must_remove = false
    for _, j in pairs(ships_to_remove) do
      if j == i then
        must_remove = true
      end
    end

    if not must_remove then
      table.insert(keep_ships, ship)
    end
  end
  ships = keep_ships

  -- Remove bullets outside window
  local keep_bullets = {}
  for i, bullet in pairs(bullets) do
    must_remove = false
    for _, j in pairs(bullets_to_remove) do
      if j == i then
        must_remove = true
      end
    end

    if not must_remove then
      table.insert(keep_bullets, bullet)
    end
  end
  bullets = keep_bullets
end

function en_generate_tracks()
  tracks = {}
  local n = 6
  local p = 8
  local s = (love.graphics:getWidth()-16) / n
  for h in random_ift(n, ampl_white) do
    table.insert(tracks, {
      x=p,
      y=0,
      w=s,
      h=h * math.random(5, 15),
      ship_count = 0,
      color = {1, 1, 1, 0.5}
    })
    p = p + s
  end
end

function en_draw()
  -- Draw ships
  for _, ship in pairs(ships) do
    love.graphics.draw(ship.image, ship.cur_quad, ship.x, ship.y)
  end

  -- Draw bullets
  for _, bullet in pairs(bullets) do
    love.graphics.draw(bullet_image, bullet_quads[bullet.frame], bullet.x, bullet.y)
  end

  -- Debug tracks
  for _, track in pairs(tracks) do
    love.graphics.setColor(track.color)
    love.graphics.rectangle("fill", track.x, track.y, track.w, track.h)
  end
  love.graphics.setColor(1, 1, 1, 1)
end

function en_spawn(kind, x)
  if kind == 'big' then
    shoot_ratio = math.random(0.8, 2)
    table.insert(ships, {
      x = x,
      y = -16,
      image = b_image,
      all_quads = b_quads,
      cur_quad = b_quads[1],
      speed = 90,
      tick = 0,
      shoot_offsets = {{0, 14}, {8, 16}, {16, 14}},
      next_shoot = ellapsed_time + shoot_ratio,
      shoot_ratio = shoot_ratio,
      bullet_speed = 210,
    })
  elseif kind == 'medium' then
    shoot_ratio = math.random(0.6, 2)
    table.insert(ships, {
      x = x,
      y = -16,
      image = m_image,
      all_quads = m_quads,
      cur_quad = m_quads[1],
      speed = 110,
      tick = 0,
      shoot_offsets = {{0, 4}, {16, 4}},
      next_shoot = ellapsed_time + shoot_ratio,
      shoot_ratio = shoot_ratio,
      bullet_speed = 220,
    })
  elseif kind == 'small' then
    shoot_ratio = math.random(0.6, 3)
    table.insert(ships, {
      x = x + 12,
      y = -16,
      image = s_image,
      all_quads = s_quads,
      cur_quad = s_quads[1],
      speed = 140,
      tick = 0,
      shoot_offsets = {{1, 4}},
      next_shoot = ellapsed_time + shoot_ratio,
      shoot_ratio = shoot_ratio,
      bullet_speed = 250,
    })
  end
end
