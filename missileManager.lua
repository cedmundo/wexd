require 'class'
class 'MissileManager'

function MissileManager:MissileManager()
   self.collisionables = {}
   self.projectiles = {}
   self.styles = {}
   self.sprite = nil
end

function MissileManager:reset()
   self.collisionables = {}
   self.projectiles = {}
end

function MissileManager:load()
   self.sprite = love.graphics.newImage('laser-bolts.png')
   self.styles[0] = love.graphics.newQuad(0, 0, 16, 16, self.sprite:getDimensions())
   self.styles[1] = love.graphics.newQuad(0, 16, 16, 16, self.sprite:getDimensions())
   self.styles[2] = love.graphics.newQuad(16, 0, 16, 16, self.sprite:getDimensions())
   self.styles[3] = love.graphics.newQuad(16, 16, 16, 16, self.sprite:getDimensions())
end

function MissileManager:update(dt)
   for _, proj in ipairs(self.projectiles) do
      proj:update(dt)

      for _, coll in ipairs(self.collisionables) do
         local pvwp = proj.viewport
         local cvwp = coll.viewport
         local ppos = proj.pos
         local cpos = coll.pos

         if checkCollision(ppos.x, ppos.y, pvwp.w, pvwp.h, cpos.x, cpos.y, cvwp.w, cvwp.h) then
            coll:didCollision(proj)
         end
      end
   end
end

function MissileManager:draw()
   for _, v in ipairs(self.projectiles) do
      love.graphics.draw(self.sprite, v.style, v.pos.x - v.viewport.w / 2, v.pos.y - v.viewport.h / 2, 0, 2, 2)
      --love.graphics.rectangle('line', v.pos.x, v.pos.y, v.viewport.w, v.viewport.h)
   end
end

function MissileManager:addProjectile(mis)
   if not mis.style then
      error('No style for missile')
   end

   if not mis.pos then
      error('Object doesn\'t have pos property')
   end

   if not mis.viewport then
      error('Object doesn\'t have viewport property')
   end

   table.insert(self.projectiles, mis)
end

function MissileManager:addCollisionable(obj)
   if not obj.didCollision then
      error('No didCollision method for object')
   end

   if not obj.pos then
      error('Object doesn\'t have pos property')
   end

   if not obj.viewport then
      error('Object doesn\'t have viewport property')
   end

   table.insert(self.collisionables, obj)
end

-- This script was written by Luiji Maryo, http://github.com/Luiji .
-- It has been released under the Public Domain.

-- Collision detection function.
-- Checks if box1 and box2 overlap.
-- w and h mean width and height.
function checkCollision(box1x, box1y, box1w, box1h, box2x, box2y, box2w, box2h)
    if box1x > box2x + box2w - 1 or -- Is box1 on the right side of box2?
       box1y > box2y + box2h - 1 or -- Is box1 under box2?
       box2x > box1x + box1w - 1 or -- Is box2 on the right side of box1?
       box2y > box1y + box1h - 1    -- Is b2 under b1?
    then
        return false                -- No collision.  Yay!
    else
        return true                 -- Yes collision.  Ouch!
    end
end
