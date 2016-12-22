require 'spaceship'
require 'missileManager'
require 'enemyManager'
require 'levelManager'

-- Ship variables
local spaceship = Spaceship()

-- Missile Manager
local missileManager = MissileManager()

-- Enemy Manager
local enemyManager = EnemyManager(missileManager)

-- Level Manager
local levelManager = LevelManager(enemyManager, missileManager)

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

   -- Spaceship
   spaceship:load()
   spaceship.didDestroy = function()
      gameState = 'title'
      enemyManager:reset()
      levelManager:reset()
      missileManager:reset()
      missileManager:addCollisionable('spaceship', spaceship)
   end

   -- Missile Manager
   missileManager:load()
   missileManager:addCollisionable('spaceship', spaceship)

   -- Level manager
   levelManager:load()
end

function love.update(dt)
   -- Update background state
   offset = (offset + (dt * 40)) % background:getHeight()

   if gameState == 'game' then
      -- Update current anim (ship)
      spaceship:update(dt)

      -- Update missile manager
      missileManager:update(dt)

      -- Update enemy manager
      enemyManager:update(dt)

      -- Update level manager
      if levelManager.update then
         levelManager:update(dt)
      end

      spaceship.movingLeft   = love.keyboard.isDown('left')
      spaceship.movingRight  = love.keyboard.isDown('right')
      spaceship.movingUp     = love.keyboard.isDown('up')
      spaceship.movingDown   = love.keyboard.isDown('down')
   end
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

