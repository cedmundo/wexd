require 'class'
class 'Missile'

function Missile:Missile(style)
   self.pos = {x = 0, y = 0}
   self.viewport = {w = 16, h = 16}
   self.style = style
   self.destroy = function() end
end

class 'PlayerMissile' (Missile)

function PlayerMissile:PlayerMissile(style, spos)
   Missile.Missile(self, style)
   self.pos = spos
   self.speed = 6
end

function PlayerMissile:update(dt)
   self.pos.y = self.pos.y - self.speed
   if self.pos.y < -16 then
       self.pos.y = love.graphics.getHeight() + self.viewport.h
   end
end

class 'EnemyMissile' (Missile)

function EnemyMissile:EnemyMissile(style, spos)
   Missile.Missile(self, style)
   self.pos = spos
   self.speed = 6
end

function EnemyMissile:update(dt)
   self.pos.y = self.pos.y + self.speed
   if self.pos.y > love.graphics.getHeight() + 16 then
      self:destroy()
   end
end
