require 'class'
require 'anim'
class 'Enemy'

local tween = require 'tween'

function Enemy:Enemy(mm)
   self.pos = {x = 0, y = 0}
   self.viewport = {w = 0, h = 0}
   self.path = {}
   self.shoots = {}
   self.curtarget = 1
   self.state = 'alive'
   self.missileManager = mm
   self.didDestroy = function()end
   self.didReachEnd = function()end

   self.shipSprite = nil
   self.shipAnim = nil

   self.explSprite = nil
   self.explodeAnim = nil

   self.currentAnim = nil
   self.elapsed = 0
end

function Enemy:load()
    local explsprite = love.graphics.newImage('explosion.png')

    self.explodeAnim = Anim('explode', explsprite, 0.05, false)
    self.explodeAnim:loadFrames({w = 16, h = 16}, {x = 0, y = 0}, {x = 5, y = 0}, {x = 0, y = 0})
    self.explodeAnim.didPlay = function()
      self.state = 'destroyed'
      self.didDestroy()
    end

    self.explSprite = explsprite
    self.state = 'alive'
end

function Enemy:destroy()
   self.state = 'exploding'
   self.currentAnim = self.explodeAnim
end

function Enemy:addPathTarget(dur, tpos)
    table.insert(self.path, tween.new(dur, self.pos, tpos))
end

function Enemy:addShootOrder(t)
    table.insert(self.shoots, {time = t})
end

function Enemy:didCollision(other)
   if not other.state then
      other:destroy()
      self:destroy()
   end
end

function Enemy:shoot()
   local pm = EnemyMissile(self.missileManager.styles[0], {x = self.pos.x + (self.viewport.w / 2 - 8), y = self.pos.y + 25})
   self.missileManager:addProjectile(pm)
end

function Enemy:update(dt)
    self.elapsed = self.elapsed + dt
    self.currentAnim:update(dt)

    local tar = self.path[self.curtarget]
    if tar then
      if tar:update(dt) then
        self.curtarget = self.curtarget + 1
      end
    end

    for k, v in ipairs(self.shoots) do
        if v.time >= self.elapsed then
            self:shoot()
            table.remove(self.shoots, k)
        end
    end
end

function Enemy:draw()
   if self.state == 'alive' then
      love.graphics.draw(self.shipSprite, self.currentAnim:frame(), self.pos.x, self.pos.y, 0, 2, 2)
   end

   if self.state == 'exploding' then
      love.graphics.draw(self.explSprite, self.currentAnim:frame(), self.pos.x, self.pos.y, 0, 2, 2)
   end
end

class 'SmallEnemy' (Enemy)

function SmallEnemy:SmallEnemy(mm)
    Enemy.Enemy(self, mm)
    local shipsprite = love.graphics.newImage('enemy-small.png')

    self.shipAnim = Anim('straight', shipsprite, 0.2, true)
    self.shipAnim:loadFrames({w = 16, h = 16}, {x = 0, y = 0}, {x = 1, y = 0}, {x = 0, y = 0})
    self.viewport = {w = 16, h = 16}

    self.shipSprite = shipsprite
    self.currentAnim = self.shipAnim
end

class 'MediumEnemy' (Enemy)

function MediumEnemy:MediumEnemy(mm)
    Enemy.Enemy(self, mm)
    local shipsprite = love.graphics.newImage('enemy-medium.png')

    self.shipAnim = Anim('straight', shipsprite, 0.2, true)
    self.shipAnim:loadFrames({w = 32, h = 16}, {x = 0, y = 0}, {x = 1, y = 0}, {x = 0, y = 0})
    self.viewport = {w = 32, h = 16}

    self.shipSprite = shipsprite
    self.currentAnim = self.shipAnim
end

class 'BigEnemy' (Enemy)

function BigEnemy:BigEnemy(mm)
    Enemy.Enemy(self, mm)
    local shipsprite = love.graphics.newImage('enemy-big.png')

    self.shipAnim = Anim('straight', shipsprite, 0.2, true)
    self.shipAnim:loadFrames({w = 32, h = 32}, {x = 0, y = 0}, {x = 1, y = 0}, {x = 0, y = 0})
    self.viewport = {w = 32, h = 32}

    self.shipSprite = shipsprite
    self.currentAnim = self.shipAnim
end
