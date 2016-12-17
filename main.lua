require 'spaceship'

-- Ship variables
local spaceship = Spaceship()

-- Bolts
local boltSprite = nil
local shipBolts = {}
local bolt = {}

-- Background
local background = nil
local offset = 0

-- Game state
local gameState = 'title'

-- Title screen
local title = nil

function love.load()
    love.window.setTitle('WeXD')
    title = love.graphics.newImage('logo.png')
    background = love.graphics.newImage('background.png')
    boltSprite = love.graphics.newImage('laser-bolts.png')

    -- Spaceship
    spaceship:load()

    -- Laser bolts
    bolt[0] = love.graphics.newQuad(0, 0, 16, 16, boltSprite:getDimensions())
    bolt[1] = love.graphics.newQuad(0, 16, 16, 16, boltSprite:getDimensions())
    bolt[2] = love.graphics.newQuad(16, 0, 16, 16, boltSprite:getDimensions())
    bolt[3] = love.graphics.newQuad(16, 16, 16, 16, boltSprite:getDimensions())

    spaceship.weapon = bolt[0]
end

function love.update(dt)
   -- Update background state
   offset = (offset + (dt * 40)) % background:getHeight()

    -- Update current anim (ship)
    spaceship:update(dt)

    spaceship.movingLeft   = love.keyboard.isDown('left')
    spaceship.movingRight  = love.keyboard.isDown('right')
    spaceship.movingUp     = love.keyboard.isDown('up')
    spaceship.movingDown   = love.keyboard.isDown('down')

    -- Update bolts state
    for k,v in ipairs(shipBolts) do
        v.y = v.y - 5
        if v.y < 0 then
            v.y = love.graphics.getHeight()
        end

        local _, _, bw, bh = v.b:getViewport()
        local _, _, sw, sb = spaceship.currentAnim:frame():getViewport()

        if CheckCollision(v.x, v.y, bw, bh, spaceship.pos.x, spaceship.pos.y, sw, sb) then
            shipBolts = {}

            spaceship.didDestroy = function()
               gameState = 'title'
            end
            spaceship:destroy()
        end
    end
end

function love.keypressed(key)
   if key == "space" then
       table.insert(shipBolts, {x = spaceship.pos.x, y = spaceship.pos.y - spaceship.shootOffset, b = spaceship.weapon})
   end

   if gameState == 'title' then
       gameState = 'game'
       spaceship:reset()
   end
end

function love.draw()
    love.graphics.draw(background, 0, offset - background:getHeight(), 0, 2, 2)
    love.graphics.draw(background, 0, offset, 0, 2, 2)

    if gameState == 'game' then
        spaceship:draw()

        for k,v in ipairs(shipBolts) do
            love.graphics.draw(boltSprite, v.b, v.x, v.y, 0, 2, 2)
        end
    elseif gameState == 'title' then
        love.graphics.draw(title, love.graphics.getWidth()/2 - title:getWidth()/2, 0, 0, 1, 1)
    end
end

-- This script was written by Luiji Maryo, http://github.com/Luiji .
-- It has been released under the Public Domain.

-- Collision detection function.
-- Checks if box1 and box2 overlap.
-- w and h mean width and height.
function CheckCollision(box1x, box1y, box1w, box1h, box2x, box2y, box2w, box2h)
    if box1x > box2x + box2w - 1 or -- Is box1 on the right side of box2?
       box1y > box2y + box2h - 1 or -- Is box1 under box2?
       box2x > box1x + box1w - 1 or -- Is box2 on the right side of box1?
       box2y > box1y + box1h - 1    -- Is b2 under b1?
    then
        return false                -- No collision.  Yay!
    else
        return true                 -- Yes collision.  Ouch!
    end
end
