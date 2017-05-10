local class = require 'middleclass'
local Scene = require 'scene'
local Level = class('Level1', Scene)

function Level:initialize(manager)
    Scene.initialize(self, manager)
end

function Level:onLoad()
    self:start()
end

function Level:update(dt)
    if self.currentState ~= 'running' then
        return
    end
end

function Level:draw()
    if self.currentState ~= 'running' then
        return
    end
end

return function(manager)
    return Level:new(manager)
end
