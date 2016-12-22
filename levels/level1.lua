require 'enemy'

return function(self, dt)
   self.elapsed = self.elapsed + dt
   if self.elapsed > 1 and not self.spawned['1'] then
      self.spawned['1'] = true

      local xcenter = love.graphics.getWidth() / 2 - 8
      local yoffscr = love.graphics.getHeight() + 64

      local enemy = SmallEnemy(self.missileManager)
      enemy:load()
      enemy.pos = {x = xcenter, y = -20}
      enemy:addPathTarget(6, {x = xcenter, y = yoffscr})
      self.enemyManager:addEnemy('1-e1', enemy)
   end

   if self.elapsed > 2 and not self.spawned['2'] then
      self.spawned['2'] = true

      local xcenter = love.graphics.getWidth() / 2 - 8
      local yoffscr = love.graphics.getHeight() + 64

      local e1 = SmallEnemy(self.missileManager)
      e1:load()
      e1.pos = {x = xcenter - 100, y = -20}
      e1:addPathTarget(6, {x = xcenter - 100, y = yoffscr})
      e1:addShootOrder(4)
      self.enemyManager:addEnemy('2-e1', e1)

      local e2 = SmallEnemy(self.missileManager)
      e2:load()
      e2.pos = {x = xcenter + 100, y = -20}
      e2:addPathTarget(6, {x = xcenter + 100, y = yoffscr})
      e2:addShootOrder(4)
      self.enemyManager:addEnemy('2-e2', e2)
   end

   if self.elapsed > 5 and not self.spawned['3'] then
      self.spawned['3'] = true

      local xcenter = love.graphics.getWidth() / 2 - 8
      local yoffscr = love.graphics.getHeight() + 64

      local enemy = MediumEnemy(self.missileManager)
      enemy:load()
      enemy.pos = {x = xcenter, y = -20}
      enemy:addPathTarget(6, {x = xcenter, y = yoffscr})
      self.enemyManager:addEnemy('3-e1', enemy)
   end
end
