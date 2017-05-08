local class = require 'middleclass'
local Transformable = class 'Transformable'

function Transformable:initialize()
   self.pos = {x = 0.0, y = 0.0}
   self.sca = {x = 1.0, y = 1.0}
   self.rot = 0.0
end

function Transformable:incPos(pos)
   self.pos.x = self.pos.x + pos.x
   self.pos.y = self.pos.y + pos.y
end

function Transformable:incRot(rot)
   self.rot = self.rot + rot
end

function Transformable:incSca(sca)
   self.sca.x = self.sca.x + sca.x
   self.sca.y = self.sca.y + sca.y
end

return Transformable
