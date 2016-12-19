require 'class'
class 'Enemy'

local tween = require 'tween'

function Enemy:Enemy(mm)
   self.pos = {x = 0, y = 0}
   self.viewport = {w = 0, h = 0}
   self.path = {}
   self.curtarget = 0
   self.state = 'alive'
   self.missileManager = mm
   self.didDestroy = function()end
   self.didReachEnd = function()end

   self.sprite = nil
   self.speed = 0
   self.straightAnim = nil
   self.explodeAnim = nil
   self.currentAnim = nil
end

function Enemy:load()
end

function Enemy:destroy()
   self.state = 'exploding'
   self.currentAnim = self.explodeAnim
end

function Enemy:addPathTarget(tpos)
end

function Enemy:addShootOrder(tpos)
end

function Enemy:didCollide(_)
   self:destroy()
end

function Enemy:update(dt)
end

function Enemy:draw()
end

class 'SmallEnemy' (Enemy)


