local class = require 'middleclass'
local SceneManager = class 'SceneManager'

function SceneManager:initialize()
    self.currentScene = nil
end

function SceneManager:replaceScene(name)
    chunk, errmsg = love.filesystem.load('assets/' .. name .. '.lua')
    if errmsg then
        error(errmsg)
    end

    scene = chunk()(self)
    if scene.load then
        scene:load()
    end

    if self.currentScene then
        self.currentScene:stop()
    end

    self.currentScene = scene
end

function SceneManager:update(dt)
    if self.currentScene then
        self.currentScene:update(dt)
    end
end

function SceneManager:draw()
    if self.currentScene then
        self.currentScene:draw()
    end
end

return SceneManager
