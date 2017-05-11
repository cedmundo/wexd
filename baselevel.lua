local class = require 'middleclass'
local bump = require 'bump'
local Scene = require 'scene'
local Ship = require 'ship'
local BaseLevel = class('BaseLevel', Scene)

function BaseLevel:initialize(manager)
    Scene.initialize(self, manager)
end

function BaseLevel:onLoad()
    self.background = love.graphics.newImage('assets/background.png')
    self.offset = 0

    self.playerShip = Ship:new('player', function()
        self.manager:replaceScene('mainmenu')
    end)

    self.playerSpeed = 3
    self.playerShip.pos.x = love.graphics.getWidth() / 2 - 8
    self.playerShip.pos.y = love.graphics.getHeight() - 50

    self.world = bump.newWorld()
    local btop = {name='boundtop', kind='bound'}
    local bbot = {name='boundbot', kind='bound'}
    local bleft = {name='boundleft', kind='bound'}
    local bright = {name='boundright', kind='bound'}

    self.world:add(btop, 0, -32, love.graphics.getWidth(), 1)
    self.world:add(bbot, 0, love.graphics.getHeight()+32, love.graphics.getWidth(), 1)

    self.world:add(bleft, 0, 0, 1, love.graphics.getHeight()+32)
    self.world:add(bright, love.graphics.getWidth(), 0, 1, love.graphics.getHeight()+32)

    self.playerBounds = {name = 'player', kind = 'player'}
    self.world:add(self.playerBounds, love.graphics.getWidth() / 2, love.graphics.getHeight() - 50, 16, 32)

    self:start()
end

function BaseLevel:update(dt)
    if self.currentState ~= 'running' then
        return
    end

    if love.keyboard.isDown("left") then
        self.playerShip:moveLeft()
        self:movePlayer(-self.playerSpeed, 0, dt)
    elseif love.keyboard.isDown("right") then
        self.playerShip:moveRight()
        self:movePlayer(self.playerSpeed, 0, dt)
    else
        self.playerShip:moveForward()
    end

    if love.keyboard.isDown("up") then
        self:movePlayer(0, -self.playerSpeed, dt)
    elseif love.keyboard.isDown("down") then
        self:movePlayer(0, self.playerSpeed, dt)
    end

    self.offset = (self.offset + (dt * 40)) % self.background:getHeight()
    self.playerShip:update(dt)
end

function BaseLevel:movePlayer(x, y, dt)
    local goalX, goalY = self.playerShip.pos.x + x, self.playerShip.pos.y + y
    local actualX, actualY, cols, len = self.world:move(self.playerBounds, goalX, goalY)

    self.playerShip.pos.x = actualX
    self.playerShip.pos.y = actualY

    -- TODO(cedmundo): Handle collisions
    -- for i=1,len do
    --     print('collided with ' .. tostring(cols[i].other))
    -- end
end

function BaseLevel:draw()
    if self.currentState ~= 'running' then
        return
    end

    love.graphics.draw(self.background, 0, self.offset - self.background:getHeight(), 0, 2, 2)
    love.graphics.draw(self.background, 0, self.offset, 0, 2, 2)
    self.playerShip:draw()
end

return BaseLevel
