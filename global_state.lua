seed = 0
start_time = 0
ellapsed_time = 0

score = 0
lifes = 2

game_state = 'title'

pl_pos = {x = 0, y = 0}
pl_state = ''
pl_bullets = {}
pl_max_hit_points = 200
pl_cur_hit_points = 200

en_bullets = {}
en_ships = {}

function game_over()
  game_state = 'game_over'
  pl_bullets = {}
  en_bullets = {}
  en_ships = {}

  pl_pos = {
    x=love.graphics.getWidth() / 2 - 12,
    y=love.graphics.getHeight() - 50
  }
end

function game_start()
  math.randomseed(781236)
  game_state = 'playing'
  start_time = love.timer.getTime()
  ellapsed_time = 0

  pl_state = ''
  pl_bullets = {}
  pl_max_hit_points = 200
  pl_cur_hit_points = 200

  en_bullets = {}
  en_ships = {}

  score = 0
  lifes = 2
end
