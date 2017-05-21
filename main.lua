-- main.lua
local SceneManager = require 'scenemanager'
local manager

function love.load()
    manager = SceneManager:new()
    manager:enter()

    manager:replaceScene("mainmenu")
    love.window.setTitle(".: WEXD :.")
end

function love.update(dt)
    manager:update(dt)
end

function love.draw()
    manager:draw()
end

function love.keyreleased(key)
   if key == "escape" then
      love.event.quit()
   end

   manager:keyreleased(key)
end

function love.quit()
    manager:exit()
    return false
end
