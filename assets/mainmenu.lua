local class = require 'middleclass'
local Scene = require 'scene'
local MainMenu = class('MainMenu', Scene)

function MainMenu:initialize(manager)
    Scene.initialize(self, manager)
end

function MainMenu:onLoad()
    self.fontTitle = love.graphics.newFont('assets/neuropol.ttf', 48)
    self.fontText = love.graphics.newFont('assets/neuropol.ttf', 24)
    self.title = love.graphics.newText(self.fontTitle, 'WEXD')
    self.text1 = love.graphics.newText(self.fontText, 'Press any key to start')
    self:start()
end

function MainMenu:update(dt)
    if self.currentState ~= 'running' then
        return
    end
end

function MainMenu:draw()
    if self.currentState ~= 'running' then
        return
    end

    local wh = love.graphics:getHeight()
    local ww = love.graphics:getWidth()

    love.graphics.draw(self.title, ww / 2 - self.title:getWidth() / 2, wh / 2 - self.title:getHeight() / 2)
    love.graphics.draw(self.text1, ww / 2 - self.text1:getWidth() / 2, wh / 2 - self.text1:getHeight() / 2 + 40)
end

function MainMenu:keyreleased(key)
    self.manager:replaceScene('level-1')
end

return function(manager)
    return MainMenu:new(manager)
end
