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
      love.graphics.draw(v.sprite, v.style, v.pos.x - v.viewport.w / 2, v.pos.y - v.viewport.h / 2, 0, 2, 2)
      --love.graphics.rectangle('line', v.pos.x, v.pos.y, v.viewport.w, v.viewport.h)
   end
end

function EnemyManager:addEnemy(enemy)
   table.insert(self.enemies, enemy)
   self.missilleManager:addCollisionable(enemy)
end

