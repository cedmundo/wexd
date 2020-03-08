require 'global_state'
require 'background'
require 'player'
require 'enemy'
require 'ui'

function love.load()
  love.window.setTitle(".:: WEXD ::.")
  math.randomseed(781236)

  bg_load()
  ui_load()
  pl_load()
  en_load()
  start_time = love.timer.getTime()
end

function love.update()
  dt = love.timer.getDelta()
  ellapsed_time = love.timer.getTime() - start_time
  bg_update(dt)
  pl_update(dt)
  ui_update(dt)
  en_update(dt)
end

function love.draw()
  bg_draw()
  ui_draw()
  pl_draw()
  en_draw()
end

function love.keyreleased(key)
   if key == "escape" then
      love.event.quit()
      return
   end

   pl_keyreleased(key)
end

function love.keypressed(key)
   ui_keypressed(key)
end
