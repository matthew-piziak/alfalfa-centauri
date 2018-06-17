local sr = {}

function sr.get_lorentz_factor(v)
   return 1.0 / math.sqrt(1.0 - v * v)
end

function sr.get_rapidity(v, u)
   return (math.abs(v) + math.abs(u)) / (1 + (math.abs(v) * math.abs(u)))
end

return sr
