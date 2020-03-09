
-- menu and stuff
local title_font = nil
local ui_font = nil
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
  if game_state == 'playing' then
    love.graphics.setFont(ui_font)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print("Score: " .. score, 10, 10)
    for i=1,lifes do
      love.graphics.draw(life_image, life_quad, love.graphics.getWidth() - 24 * i, 10)
    end

    local hit_points_ind = (
      (love.graphics.getWidth()/pl_max_hit_points) * pl_cur_hit_points
    )
    love.graphics.setColor(0xce/255, 0x06/255, 0x09/255, 0.6)
    love.graphics.rectangle("fill", 0, love.graphics.getHeight() - 5, hit_points_ind, 5)
    love.graphics.setColor(1, 1, 1, 1)
  elseif game_state == 'title' then
    love.graphics.setFont(title_font)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf("WEXD", 0,
      love.graphics.getHeight() / 2, love.graphics.getWidth(), "center")
    love.graphics.setFont(ui_font)
    love.graphics.printf("Press space to start", 0,
      love.graphics.getHeight() / 2 + 25, love.graphics.getWidth(), "center")
  elseif game_state == 'game_over' then
    love.graphics.setFont(title_font)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf("Game over", 0,
      love.graphics.getHeight() / 2, love.graphics.getWidth(), "center")
    love.graphics.setFont(ui_font)
    love.graphics.printf("Max score: " .. score, 0,
      love.graphics.getHeight() / 2 + 25, love.graphics.getWidth(), "center")
    love.graphics.printf("Press space to try again", 0,
      love.graphics.getHeight() / 2 + 50, love.graphics.getWidth(), "center")
  end
end

function ui_keypressed(k)
  if k == 'space' and (game_state == 'title' or game_state == 'game_over') then
    game_start()
  end
end
