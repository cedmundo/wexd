require 'class'
require 'anim'

class 'EnemyManager'

function EnemyManager:EnemyManager(missileManager)
   self.enemies = {}
   self.missileManager = missileManager
end

function EnemyManager:reset()
   self.enemies = {}
end

function EnemyManager:update(dt)
   for _, v in pairs(self.enemies) do
      v:update(dt)
   end
end

function EnemyManager:draw()
   for k, v in pairs(self.enemies) do
       v:draw()
   end
end

function EnemyManager:addEnemy(name, enemy)
   enemy.didDestroy = function()
      self.enemies[name] = nil
      self.missileManager:delCollisionable(name)
   end

   self.enemies[name] = enemy
   self.missileManager:addCollisionable(name, enemy)
end

