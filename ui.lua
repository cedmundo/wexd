
-- menu and stuff
local title_font = nil
local ui_font = nil
local ui_hud = false
local life_image = nil
local life_quad = nil

function ui_load()
  -- Load HUD stuff
  life_image = love.graphics.newImage("assets/player.png")
  life_quad = love.graphics.newQuad(32, 0, 16, 24, life_image:getDimensions())
  title_font = love.graphics.newFont("assets/neuropol.ttf", 28)
  ui_font = love.graphics.newFont("assets/neuropol.ttf", 14)
end

function ui_update(dt)
end

function ui_draw()
  -- HUD and Game Title draw
  if ui_hud then
    love.graphics.setFont(ui_font)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print("Score: " .. score, 10, 10)
    for i=1,lifes do
      love.graphics.draw(life_image, life_quad, love.graphics.getWidth() - 24 * i, 10)
    end
  else
    love.graphics.setFont(title_font)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf("WEXD", 0,
      love.graphics.getHeight() / 2, love.graphics.getWidth(), "center")
  end
end

function ui_keypressed(_)
  ui_hud = true
end
