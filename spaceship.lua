-- Spaceship game object
require 'class'
require 'anim'
require 'missile'

class 'Spaceship'

function Spaceship:Spaceship()
   self.state = 'alive'
   self.shipSprite = nil
   self.explSprite = nil
   self.currentAnim = nil
   self.straightAnim = nil
   self.leftAnim = nil
   self.rightAnim = nil
   self.explodeAdmin = nil
   self.speed = 5
   self.pos = {x = 0, y = 0}
   self.weapon = nil
   self.shootOffset = 25
   self.didDestroy = function() end
   self.viewport = {w = 32, h = 48}

   self.movingRight = false
   self.movingLeft = false
   self.movingTop = false
   self.movingBot = false
end

function Spaceship:load()
    local shipsprite = love.graphics.newImage('ship.png')
    local explsprite = love.graphics.newImage('explosion.png')

    self.straightAnim = Anim('straight', shipsprite, 0.2, true)
    self.straightAnim:loadFrames({w = 16, h = 24}, {x = 0, y = 0}, {x = 0, y = 1}, {x = 32, y = 0})

    self.leftAnim = Anim('left', shipsprite, 0.1, true)
    self.leftAnim:loadFrames({w = 16, h = 24}, {x = 0, y = 0}, {x = 0, y = 1}, {x = 0, y = 0})

    self.rightAnim = Anim('right', shipsprite, 0.1, true)
    self.rightAnim:loadFrames({w = 16, h = 24}, {x = 0, y = 0}, {x = 0, y = 1}, {x = 64, y = 0})

    self.explodeAnim = Anim('explode', explsprite, 0.05, false)
    self.explodeAnim:loadFrames({w = 16, h = 16}, {x = 0, y = 0}, {x = 5, y = 0}, {x = 0, y = 0})
    self.explodeAnim.didPlay = function()
      self.state = 'destroyed'
      self.didDestroy()
    end

    self.currentAnim = self.straightAnim
    self.shipSprite = shipsprite
    self.explSprite = explsprite
    self.state = 'alive'
end

function Spaceship:destroy()
    self.state = 'exploding'
    self.currentAnim = self.explodeAnim
end

function Spaceship:reset()
   self.state = 'alive'
   self.explodeAnim:reset()
   self.currentAnim = self.straightAnim
end

function Spaceship:didCollision(proj)
   self:destroy()
end

function Spaceship:update(dt)
    self.currentAnim:update(dt)

    -- Exploding state removes
    if self.state == 'exploding' then
       return
    end

    -- Update ship state
    if self.movingRight and self.pos.x < love.graphics.getWidth() - 32 then
        self.pos.x = self.pos.x + self.speed
        self.currentAnim = self.rightAnim
    elseif self.movingLeft and self.pos.x > 0 then
        self.pos.x = self.pos.x - self.speed
        self.currentAnim = self.leftAnim
    else
        self.currentAnim = self.straightAnim
    end

    if self.movingUp then
        self.pos.y = self.pos.y - self.speed
    end

    if self.movingDown then
        self.pos.y = self.pos.y + self.speed
    end
end

function Spaceship:shoot(mm)
   local pm = PlayerMissile(mm.styles[0], {x = self.pos.x + (self.viewport.w / 2 - 8), y = self.pos.y - 25})
   mm:addProjectile(pm)
end

function Spaceship:draw()
   if self.state == 'alive' then
      love.graphics.draw(self.shipSprite, self.currentAnim:frame(), self.pos.x, self.pos.y, 0, 2, 2)
   end

   if self.state == 'exploding' then
      love.graphics.draw(self.explSprite, self.currentAnim:frame(), self.pos.x, self.pos.y, 0, 2, 2)
   end
   -- love.graphics.rectangle('line', self.pos.x, self.pos.y, self.viewport.w, self.viewport.h)
end
