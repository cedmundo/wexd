local class = require 'middleclass'
local StateMachine = require 'statemachine'
local Ship = class ('Ship', StateMachine)

function Ship:initialize(kind, destroycb)
   StateMachine.initialize(self)
   self.destroyCallback = destroycb

   local chunk, errormsg = love.filesystem.load('assets/' .. kind .. '-ship.lua')
   if errormsg then
      error(errormsg)
   end

   chunk()(self)
   StateMachine.buildstates(self)
end

function Ship:onDestroy(msg)
    if self.destroyCallback then
        self.destroyCallback(msg)
    end
end

function Ship:draw()
   StateMachine.draw(self)
end

function Ship:update(dt)
   StateMachine.update(self, dt)
end

return Ship
