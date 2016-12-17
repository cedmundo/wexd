
-- Ship variables
local shipSprite = nil
local shipCurFrm = nil
local currentAnim = {}
local straightFrames = {}
local leftFrames = {}
local rightFrames = {}
local frmet = 0
local shipFrmCnt = 0

local shipPosX = 0
local shipPosY = 0

-- Bolts
local boltSpawnOffset = 25
local boltSprite = nil
local bolt = {}
local shipWeapon = {}
local shipBolts = {}

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
    shipSprite = love.graphics.newImage('ship.png')
    boltSprite = love.graphics.newImage('laser-bolts.png')

    -- Ship frames
    straightFrames[0] = love.graphics.newQuad(32, 0, 16, 24, shipSprite:getDimensions())
    straightFrames[1] =love.graphics.newQuad(32, 24, 16, 24, shipSprite:getDimensions())

    leftFrames[0] = love.graphics.newQuad(0, 0, 16, 24, shipSprite:getDimensions())
    leftFrames[1] =love.graphics.newQuad(0, 24, 16, 24, shipSprite:getDimensions())

    rightFrames[0] = love.graphics.newQuad(64, 0, 16, 24, shipSprite:getDimensions())
    rightFrames[1] =love.graphics.newQuad(64, 24, 16, 24, shipSprite:getDimensions())

    currentAnim = straightFrames
    shipCurFrm = currentAnim[0]

    -- Laser bolts
    bolt[0] = love.graphics.newQuad(0, 0, 16, 16, boltSprite:getDimensions())
    bolt[1] = love.graphics.newQuad(0, 16, 16, 16, boltSprite:getDimensions())
    bolt[2] = love.graphics.newQuad(16, 0, 16, 16, boltSprite:getDimensions())
    bolt[3] = love.graphics.newQuad(16, 16, 16, 16, boltSprite:getDimensions())

    shipWeapon = bolt[0]

    shipPosX = love.graphics.getWidth()/2 - shipSprite:getWidth()/2
    shipPosY = background:getHeight()
end

function love.update(dt)
    offset = (offset + (dt * 40)) % background:getHeight()

    if love.keyboard.isDown('right') and shipPosX < love.graphics.getWidth() - 32 then
        shipPosX = shipPosX + 5
        currentAnim=rightFrames
    elseif love.keyboard.isDown('left') and shipPosX > 0 then
        shipPosX = shipPosX - 5
        currentAnim=leftFrames
    else
        currentAnim=straightFrames
    end

    if love.keyboard.isDown('up') then
        shipPosY = shipPosY - 5
    end

    if love.keyboard.isDown('down') then
        shipPosY = shipPosY + 5
    end

    frmet = frmet + dt
    if frmet > 0.1 then
        frmet = 0
        shipFrmCnt = shipFrmCnt + 1
        shipCurFrm = currentAnim[shipFrmCnt % 2]
    end

    for k,v in ipairs(shipBolts) do
        v.y = v.y - 5
        if v.y < 0 then
            v.y = love.graphics.getHeight()
        end

        local _, _, bw, bh = v.b:getViewport()
        local _, _, sw, sb = shipCurFrm:getViewport()

        if CheckCollision(v.x, v.y, bw, bh, shipPosX, shipPosY, sw, sb) then
            gameState = 'title'
            table.remove(shipBolts, k)
        end
    end
end

function love.keypressed(key)
   if key == "space" then
       table.insert(shipBolts, {x = shipPosX, y = shipPosY - boltSpawnOffset, b = shipWeapon})
   end

   if gameState == 'title' then
       gameState = 'game'
   end
end

function love.draw()
    love.graphics.draw(background, 0, offset - background:getHeight(), 0, 2, 2)
    love.graphics.draw(background, 0, offset, 0, 2, 2)

    if gameState == 'game' then
        -- love.graphics.line(0, offset, love.graphics.getWidth(), offset)
        love.graphics.draw(shipSprite, shipCurFrm, shipPosX, shipPosY, 0, 2, 2)

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
