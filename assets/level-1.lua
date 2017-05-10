local class = require 'middleclass'
local BaseLevel = require 'baselevel'
local Level = class('Level1', BaseLevel)

function Level:initialize(manager)
    BaseLevel.initialize(self, manager)
end

return function(manager)
    return Level:new(manager)
end
