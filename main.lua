local SceneManager = require 'scenemanager'
local manager

function love.load()
    manager = SceneManager:new()
    manager:replaceScene("mainmenu")

    love.window.setTitle(".:WEXD:.")
end

function love.update(dt)
    manager:update(dt)
end

function love.draw()
    manager:draw()
end
