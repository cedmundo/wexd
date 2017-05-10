local class = require 'middleclass'
local StateMachine = require 'statemachine'
local Ship = class ('Ship', StateMachine)

function Ship:initialize(kind)
   StateMachine.initialize(self)

   local chunk, errormsg = love.filesystem.load('assets/' .. kind .. '-ship.lua')
   if errormsg then
      error(errormsg)
   end

   chunk()(self)
   StateMachine.buildstates(self)
end

function Ship:draw()
   StateMachine.draw(self)
end

function Ship:update(dt)
   StateMachine.update(self, dt)
end

return Ship
