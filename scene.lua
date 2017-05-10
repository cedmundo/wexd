local class = require 'middleclass'
local StateMachine = require 'statemachine'
local Scene = class('Scene', StateMachine)

function Scene:initialize(manager)
   StateMachine.initialize(self)
   self.manager = manager
   self.events = {
       {name = 'load', from = {'standby'}, to = 'loading'},
       {name = 'start', from = {'loading', 'paused'}, to = 'running'},
       {name = 'pause', from = {'running'}, to = 'paused'},
       {name = 'stop', from = {'running', 'paused'}, to = 'stopped'},
   }
   self.initialState = 'standby'
   self.manager = nil
   self:buildstates()
end

return Scene
