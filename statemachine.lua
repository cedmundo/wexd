local class = require 'middleclass'
local Transformable = require 'transformable'
local StateMachine = class ('StateMachine', Transformable)

function StateMachine:initialize()
   Transformable.initialize(self)
   self.eventMethods = {}
end

function StateMachine:update(dt)
   if self.currentAnim then
      self.currentAnim:update(dt)
   end
end

function StateMachine:draw()
   if self.currentAnim and self.currentSpritesheet then
      self.currentAnim:draw(self.currentSpritesheet, self.pos.x, self.pos.y, self.rot, self.sca.x, self.sca.y, self.currentOffset.x, self.currentOffset.y)
   end
end

function StateMachine:buildstates()
   if not self.events then
      return
   end

   self.currentState = self.initialState
   self.currentAnim = self.initialAnim
   self.currentSpritesheet = self.initialSpritesheet
   self.currentOffset = self.initialOffset

   for _, event in ipairs(self.events) do
      self[event.name] = newHandler(event)
   end
end

function newHandler(event)
   return function(self, msg)
      local canChange = false
      if type(event.from) == 'string' and event.from == self.currentState then
         canChange = true
      elseif type(event.from) == 'table' then
         for _, trigevt in ipairs(event.from) do
            if trigevt == self.currentState then
               canChange = true
               break
            end
         end
      end

      if canChange then
         self.currentState = event.to
         self.currentAnim = event.anim
         self.currentSpritesheet = event.spritesheet
         self.currentOffset = event.offset

         evthdl = getmetatable(self)['on' .. ftu(event.name)]
         if evthdl then
            evthdl(self, msg)
         end
      end
   end
end

function ftu(str)
    return (str:gsub("^%l", string.upper))
end

return StateMachine
