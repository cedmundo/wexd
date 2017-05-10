local anim8 = require 'anim8'

return function(ship)
   local pss = love.graphics.newImage('assets/player.png')
   local ess = love.graphics.newImage('assets/explosion.png')
   local gp = anim8.newGrid(16, 24, pss:getWidth(), pss:getHeight())
   local ge = anim8.newGrid(16, 16, ess:getWidth(), ess:getHeight())

   ship.name = 'player'
   ship.initialState = 'movingForward'
   ship.initialAnim = anim8.newAnimation(gp(3, '1-2'), 0.05)
   ship.initialSpritesheet = pss
   ship.initialOffset = {x = 8, y = 12}
   ship.events = {
      {name = 'moveForward', from = {'movingLeft', 'movingRight'}, to = 'movingForward', spritesheet = pss,
      anim = anim8.newAnimation(gp(3, '1-2'), 0.2), offset = {x=8, y=12}},

      {name = 'moveLeft', from = {'movingForward', 'movingRight'}, to = 'movingLeft', spritesheet = pss,
      anim = anim8.newAnimation(gp(1, '1-2'), 0.2), offset = {x=8, y=12}},

      {name = 'moveRight', from = {'movingForward', 'movingLeft'}, to = 'movingRight', spritesheet = pss,
      anim = anim8.newAnimation(gp(5, '1-2'), 0.2), offset = {x=8, y=12}},

      {name = 'explode', from = {'movingForward', 'movingLeft', 'movingRight'}, to = 'exploding', spritesheet = ess,
      anim = anim8.newAnimation(ge('1-5', 1), 0.1, function(anim) anim:pause(); ship:destroy() end), offset = {x=8, y=8}},

      {name = 'destroy', from = {'exploding'}, to = 'destroyed'},
   }
end
