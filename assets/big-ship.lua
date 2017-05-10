local anim8 = require 'anim8'

return function(ship)
   local bss = love.graphics.newImage('assets/enemy-big.png')
   local ess = love.graphics.newImage('assets/explosion.png')
   local gb = anim8.newGrid(32, 32, bss:getWidth(), bss:getHeight())
   local ge = anim8.newGrid(16, 16, ess:getWidth(), ess:getHeight())

   ship.name = 'big'
   ship.initialState = 'moving'
   ship.initialAnim = anim8.newAnimation(gb('1-2', 1), 0.1)
   ship.initialSpritesheet = bss
   ship.initialOffset = {x = 16, y = 16}
   ship.events = {
      {name = 'explode', from = 'moving', to = 'exploding', spritesheet = ess,
      anim = anim8.newAnimation(ge('1-5', 1), 0.1, function(anim) anim:pause(); ship:destroy() end), offset = {x=8, y=8}},

      {name = 'destroy', from = 'exploding', to = 'destroyed'},
   }
end
