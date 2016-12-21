require 'class'
class 'LevelManager'

function LevelManager:LevelManager(em, mm)
   self.levels = {}
   self.cindex = 1
   self.update = nil
   self.elapsed = 0
   self.spawned = {}
   self.enemyManager = em
   self.missileManager = mm
end

function LevelManager:load()
   files = love.filesystem.getDirectoryItems('levels')

   for _, file in ipairs(files) do
      if string.match(file, '^[a-zA-Z0-9]+.lua$') then
         chunk, errmsg = love.filesystem.load('levels/' .. file)
         if not errmsg then
            local level = chunk()
            table.insert(self.levels, level)
         else
            error(errmsg)
         end
      else
         print('do not match: ', file)
      end
   end

   self.update = self.levels[self.cindex]
end

function LevelManager:reset()
   self.elapsed = 0
   self.spawned = {}

   self.cindex = 1
   self.update = self.levels[self.cindex]
end

function LevelManager:didClearLevel(name)
   self.cindex = self.cindex + 1
   self.update = self.levels[self.cindex]
end

