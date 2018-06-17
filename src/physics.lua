local sr = require "sr"

local physics = {}

function physics.init_state()
   return {
      t_p = 0,
      t_r = 0,
      x = 0.0,
      y = 0.0,
      v_x = 0.0,
      v_y = 0.0,
      sign_v_x = 1,
      sign_v_y = 1,
      angle = 0.0,
      food = 1.0,
      farm = 0.0
   }
end

function physics.update_state(state)
   local total_rapidity = sr.get_rapidity(state.v_x, state.v_y)
   local lorentz_factor = sr.get_lorentz_factor(total_rapidity)
   local is_burning = love.keyboard.isDown("up")
   local is_turning_left = love.keyboard.isDown("left")
   local is_turning_right = love.keyboard.isDown("right")
   local engine_power = 0.01
   local input_energy = ((food ~= 0 and is_burning) and engine_power or 0)
   local initial_energy_x = sr.get_lorentz_factor(state.v_x)
   local initial_energy_y = sr.get_lorentz_factor(state.v_y)
   local sign_v_x = state.sign_v_x
   local sign_v_y = state.sign_v_y
   local input_energy_x = (input_energy * sign_v_x * math.cos(state.angle))
   local input_energy_y = (input_energy * sign_v_y * math.sin(state.angle))
   local total_energy_x = initial_energy_x + input_energy_x
   local total_energy_y = initial_energy_y + input_energy_y
   if total_energy_x < 1 then
      sign_v_x = -1 * sign_v_x
      input_energy_x = (input_energy * sign_v_x * math.cos(state.angle))
      total_energy_x = initial_energy_x + input_energy_x
   end
   if total_energy_y < 1 then
      sign_v_y = -1 * sign_v_y
      input_energy_y = (input_energy * sign_v_y * math.sin(state.angle))
      total_energy_y = initial_energy_y + input_energy_y
   end
   local v_x = sign_v_x * math.sqrt(1.0 - math.pow(1.0 / total_energy_x, 2))
   local v_y = sign_v_y * math.sqrt(1.0 - math.pow(1.0 / total_energy_y, 2))
   local function can_harvest(x, y, food)
      harvest_distance = 20
      return food ~= 0
	 and math.abs(x) < harvest_distance
	 and math.abs(y) < harvest_distance
   end
   local function update_food(x, y, food, farm)
      hunger = -0.001
      return math.max(food + hunger + (can_harvest(x, y, food) and farm or 0), 0)
   end
   local function update_farm(x, y, lorentz_factor, farm)
      growth = 0.0008
      return (can_harvest(x, y, food) and 0 or farm) + (growth * lorentz_factor)
   end
   local function update_angle(angle, is_turning_left, is_turning_right, food)
      if food == 0 then
	 return angle
      end
      yaw_power = 0.05
      return
	 (angle
	     + (is_turning_left and 0 or yaw_power)
	     + (is_turning_right and 0 or -yaw_power))
	 % (2 * math.pi)
   end
   return {
      t_p = state.t_p + 1,
      t_r = state.t_r + lorentz_factor,
      x = state.x + (lorentz_factor * state.v_x),
      y = state.y + (lorentz_factor * state.v_y),
      v_x = v_x,
      v_y = v_y,
      sign_v_x = sign_v_x,
      sign_v_y = sign_v_y,
      angle = update_angle(state.angle, is_turning_left, is_turning_right, state.food),
      food = update_food(state.x, state.y, state.food, state.farm),
      farm = update_farm(state.x, state.y, lorentz_factor, state.farm)
   }
end

return physics
