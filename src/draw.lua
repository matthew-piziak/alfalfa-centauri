local sr = require "sr"

local draw = {}

local function value_format(display_string, value)
   return string.format("%s: %.3f", display_string, value)
end

local function draw_debug()
   local v = sr.get_rapidity(state.v_x, state.v_y)
   debug_row = 0
   local function draw_debug_row(display_string, value)
      local debug_height = debug_row * 12
      debug_row = debug_row + 1
      love.graphics.print(value_format(display_string, value), 0, debug_height)
   end
   draw_debug_row("t_p", state.t_p)
   draw_debug_row("t_r", state.t_r)
   draw_debug_row("x", state.x)
   draw_debug_row("y", state.y)
   draw_debug_row("v_x", state.v_x)
   draw_debug_row("v_y", state.v_y)
   draw_debug_row("v", v)
   draw_debug_row("angle", state.angle)
end

local function draw_hud()
   local hud_x = center_x + 200
   local hud_row = 10
   local function draw_hud_row(display_string, value)
      local hud_height = hud_row * 20
      hud_row = hud_row + 1
      love.graphics.print(value_format(display_string, value), hud_x, hud_height)
   end
   local v = sr.get_rapidity(state.v_x, state.v_y)
   draw_hud_row("Lorentz Factor", sr.get_lorentz_factor(v))
   draw_hud_row("Food", state.food)
end

local function draw_farm()
   love.graphics.print(value_format("Farm", state.farm), center_x - 10, center_y + 20)
   love.graphics.setColor(0, 0, 0)
   love.graphics.rectangle("fill", center_x - 10 + 2, center_y - 10 + 3, 20, 20)
   love.graphics.setColor(30, 230, 30)
   love.graphics.rectangle("fill", center_x - 10, center_y - 10, 20, 20)
end

local function draw_player()
   local player_x = state.x + center_x
   local player_y = state.y + center_y
   local player_scale = 0.5
   love.graphics.setColor(0, 0, 0)
   love.graphics.draw(
      player,
      player_x + 4,
      player_y + 6,
      state.angle,
      player_scale,
      player_scale,
      player:getWidth() / 2,
      player:getHeight() / 2)
   love.graphics.setColor(20, 100, 100)
   love.graphics.draw(
      player,
      player_x + 30,
      player_y - 10,
      math.atan2(state.x, -state.y) + (math.pi / 2),
      0.2,
      0.2,
      player:getWidth() / 2,
      player:getHeight() / 2)
   love.graphics.setColor(255, 255, 255)
   if state.food ~= 0 and love.keyboard.isDown("up") then
      love.graphics.draw(player_burning,
			 player_x,
			 player_y,
			 state.angle,
			 player_scale,
			 player_scale,
			 player:getWidth() / 2,
			 player:getHeight() / 2)
   else
      love.graphics.draw(player,
			 player_x,
			 player_y,
			 state.angle,
			 player_scale,
			 player_scale,
			 player:getWidth() / 2,
			 player:getHeight() / 2)
   end
   if state.food == 0 then
      love.graphics.printf("YOU STARVED",
			   player_x - 100,
			   player_y - 30,
			   200,
			   "center")
   end
end

local function draw_screen()
   draw_debug()
   draw_hud()
end

local function draw_world()
   love.graphics.print("ALFALFA CENTAURI PROOF OF CONCEPT", center_x - 200, 300)
   draw_farm()
   draw_player()
end

function draw.load()
   player = love.graphics.newImage("player.png")
   player_burning = love.graphics.newImage("player_burning.png")
   love.graphics.setBackgroundColor(170, 170, 170)
   center_x = (love.graphics.getWidth() / 2)
   center_y = (love.graphics.getHeight() / 2)
end

function draw.draw()
   draw_screen()
   love.graphics.translate(-state.x, -state.y)
   draw_world()
end

return draw
