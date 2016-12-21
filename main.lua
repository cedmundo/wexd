require 'spaceship'
require 'missileManager'
require 'enemyManager'
require 'enemy'

-- Ship variables
local spaceship = Spaceship()

-- Missile Manager
local missileManager = MissileManager()

-- Enemy Manager
local enemyManager = EnemyManager(missileManager)

-- Background
local background = nil
local offset = 0

-- Game state
local gameState = 'title'

-- Title screen
local title = nil

-- Temp: enemy
local enemy = BigEnemy(missileManager)

function love.load()
   love.window.setTitle('WeXD')
   title = love.graphics.newImage('logo.png')
   background = love.graphics.newImage('background.png')

   -- Spaceship
   spaceship:load()
   spaceship.didDestroy = function()
      gameState = 'title'
      missileManager:reset()
      missileManager:addCollisionable(spaceship)
   end

   -- Missile Manager
   missileManager:load()
   missileManager:addCollisionable(spaceship)

   -- Temp: Enemy load
   enemy:load()
   enemy.pos = {x = 10, y = 10}
   enemy:addPathTarget(2, {x = 200, y = 100})
   enemy:addPathTarget(2, {x = 0, y = 200})
   enemy:addPathTarget(2, {x = 200, y = 300})
   enemyManager:addEnemy(enemy)
end

function love.update(dt)
   -- Update background state
   offset = (offset + (dt * 40)) % background:getHeight()

   -- Update current anim (ship)
   spaceship:update(dt)

   -- Update missile manager
   missileManager:update(dt)

   -- Update enemy manager
   enemyManager:update(dt)

   spaceship.movingLeft   = love.keyboard.isDown('left')
   spaceship.movingRight  = love.keyboard.isDown('right')
   spaceship.movingUp     = love.keyboard.isDown('up')
   spaceship.movingDown   = love.keyboard.isDown('down')
end

function love.keypressed(key)
   if key == " " or key == "space" then
      spaceship:shoot(missileManager)
   end

   if key == "escape" then
      love.event.quit()
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
      missileManager:draw()
      enemyManager:draw()

   elseif gameState == 'title' then
      love.graphics.draw(title, love.graphics.getWidth()/2 - title:getWidth()/2, 0, 0, 1, 1)
   end
end

