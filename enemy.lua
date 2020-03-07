require 'global_state'

-- Enemy
local en_s_image = nil
local en_s_quads = {}

local en_m_image = nil
local en_m_quads = {}

local en_b_image = nil
local en_b_quads = {}
local en_ships = {}
-- Layout: { id = 0, x = 0, y = 0, speed = 0, tick = 0, cur_quad = nil, all_cuads = {} }
local en_last_spawn = 0

function en_load()
  en_s_image = love.graphics.newImage("assets/enemy-small.png")
  en_s_quads = {
    love.graphics.newQuad(0, 0, 32, 16, en_s_image:getDimensions()),
    love.graphics.newQuad(0, 16, 32, 16, en_s_image:getDimensions()),
  }

  en_m_image = love.graphics.newImage("assets/enemy-medium.png")
  en_m_quads = {
    love.graphics.newQuad(0, 0, 64, 16, en_s_image:getDimensions()),
    love.graphics.newQuad(0, 32, 64, 16, en_s_image:getDimensions()),
  }

  en_b_image = love.graphics.newImage("assets/enemy-big.png")
  en_b_quads = {
    love.graphics.newQuad(0, 0, 64, 32, en_s_image:getDimensions()),
    love.graphics.newQuad(0, 32, 64, 32, en_s_image:getDimensions()),
  }
end

function en_update(dt)
  -- Spawn new ships
  procedural_spawn()

  -- Update current ships
  for _, ship in paris(en_ships) do
    -- Update position
    procedural_move(ship)

    -- Shoot
    procedural_shoot(ship)

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
end

function en_draw()
  -- Draw ships
  for _, ship in pairs(en_ships) do
    love.graphics.draw(ship.image, ship.quad, ship.x, ship.y)
  end
end

-- Background is 256x608, we will be using 6 tracks of 40 pixels each and leave
-- a padding of 16 on the sides.
--
-- Each ship will be assigned a track, procedural_move should also calculate when
-- the ship moves to other track.
function procedural_spawn()
end

function procedural_move(ship)
  ship.x = ship.x + ship.speed * dt
end

function procedural_shoot(ship)
end
