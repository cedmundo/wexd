
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

-- Background
local background = nil
local offset = 0


function love.load()
    love.window.setTitle('WeXD')
    background = love.graphics.newImage('background.png')
    shipSprite = love.graphics.newImage('ship.png')

    straightFrames[0] = love.graphics.newQuad(32, 0, 16, 24, shipSprite:getDimensions())
    straightFrames[1] =love.graphics.newQuad(32, 24, 16, 24, shipSprite:getDimensions())

    leftFrames[0] = love.graphics.newQuad(0, 0, 16, 24, shipSprite:getDimensions())
    leftFrames[1] =love.graphics.newQuad(0, 24, 16, 24, shipSprite:getDimensions())

    rightFrames[0] = love.graphics.newQuad(64, 0, 16, 24, shipSprite:getDimensions())
    rightFrames[1] =love.graphics.newQuad(64, 24, 16, 24, shipSprite:getDimensions())

    currentAnim = straightFrames
    shipCurFrm = currentAnim[0]
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
    if frmet > 0.2 then
        frmet = 0
        shipFrmCnt = shipFrmCnt + 1
        shipCurFrm = currentAnim[shipFrmCnt % 2]
    end
end

function love.draw()
    love.graphics.draw(background, 0, offset - background:getHeight(), 0, 2, 2)
    love.graphics.draw(background, 0, offset, 0, 2, 2)
    -- love.graphics.line(0, offset, love.graphics.getWidth(), offset)

    love.graphics.draw(shipSprite, shipCurFrm, shipPosX, shipPosY, 0, 2, 2)
end
