local Ship = require 'ship'
local playerShip
local bigShip

function love.load()
   bigShip = Ship:new('big')
   playerShip = Ship:new('player')
end

function love.update(dt)
   if love.keyboard.isDown("left") then
      playerShip:moveLeft()
      playerShip:incPos({x = -2, y = 0})
   elseif love.keyboard.isDown("right") then
      playerShip:moveRight()
      playerShip:incPos({x = 2, y = 0})
   else
      playerShip:moveForward()
   end

   if love.keyboard.isDown("up") then
      playerShip:incPos({x = 0, y = -2})
   elseif love.keyboard.isDown("down") then
      playerShip:incPos({x = 0, y = 2})
   end

   if love.keyboard.isDown("space") then
      playerShip:explode()
   end

   playerShip:update(dt)
   bigShip:update(dt)
end

function love.draw()
   playerShip:draw()
   bigShip:draw()
end
