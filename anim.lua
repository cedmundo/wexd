-- anim.class
require 'class'
class 'Anim'

function Anim:Anim(name, spritesheet, speed, loop)
   self.name = name
   self.spritesheet = spritesheet
   self.speed = speed
   self.loop = loop
   self.frames = {}
   self.elapsed = 0
   self.totalFrames = 0
   self.curFrameNum = 0
   self.didPlayThrown = false
   self.didPlay = function() end
end

function Anim:loadFrames(inc, posini, posend, offset)
   local li = 0
   for i = posini.x, posend.x do
      for j = posini.y, posend.y do
         li = i + j
         self.frames[li] = love.graphics.newQuad(offset.x + inc.w * i, offset.y + inc.h * j, inc.w, inc.h, self.spritesheet:getDimensions())
      end
   end

   self.totalFrames = (posend.x - posini.x + 1) * (posend.y - posini.y + 1)
end

function Anim:reset()
   self.curFrameNum = 0
   self.elapsed = 0
   self.didPlayThrown = false
end

function Anim:update(dt)
   if not self.loop and self.curFrameNum > self.totalFrames then
      if not self.didPlayThrown then
         self.didPlayThrown = true
         self:didPlay()
      end

      return
   end

   self.elapsed = self.elapsed + dt
   if self.elapsed > self.speed then
      self.elapsed = 0
      self.curFrameNum = self.curFrameNum + 1
   end
end

function Anim:frame()
   return self.frames[self.curFrameNum % self.totalFrames]
end
