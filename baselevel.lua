local class = require 'middleclass'
local Scene = require 'scene'
local Ship = require 'ship'
local BaseLevel = class('BaseLevel', Scene)

function BaseLevel:initialize(manager)
    Scene.initialize(self, manager)
end

function BaseLevel:onLoad()
    self.background = love.graphics.newImage('assets/background.png')
    self.offset = 0

    self.playerShip = Ship:new('player')
    self.playerSpeed = 2
    self.playerShip.pos.x = love.graphics.getWidth() / 2 - 8
    self.playerShip.pos.y = love.graphics.getHeight() - 50
    self:start()
end

function BaseLevel:update(dt)
    if self.currentState ~= 'running' then
        return
    end

    if love.keyboard.isDown("left") then
        self.playerShip:moveLeft()
        self.playerShip:incPos({x = -self.playerSpeed, y = 0})
    elseif love.keyboard.isDown("right") then
        self.playerShip:moveRight()
        self.playerShip:incPos({x = self.playerSpeed, y = 0})
    else
        self.playerShip:moveForward()
    end

    if love.keyboard.isDown("up") then
        self.playerShip:incPos({x = 0, y = -self.playerSpeed})
    elseif love.keyboard.isDown("down") then
        self.playerShip:incPos({x = 0, y = self.playerSpeed})
    end


    self.offset = (self.offset + (dt * 40)) % self.background:getHeight()
    self.playerShip:update(dt)
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
