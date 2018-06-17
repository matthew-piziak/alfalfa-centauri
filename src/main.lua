local physics = require "physics"
local draw = require "draw"

function love.load()
   state = physics.init_state()
   draw.load()
end

function love.update(dt)
   state = physics.update_state(state)
end

function love.draw()
   draw.draw()
end
