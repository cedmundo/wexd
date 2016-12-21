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
   for _, v in ipairs(self.enemies) do
      v:update(dt)
   end
end

function EnemyManager:draw()
   for _, v in ipairs(self.enemies) do
       v:draw()
   end
end

function EnemyManager:addEnemy(enemy)
   table.insert(self.enemies, enemy)
   self.missileManager:addCollisionable(enemy)
end

