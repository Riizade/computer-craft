args = {...}
min_fuel = tonumber(args[1])

local slot = 1
while turtle.getFuelLevel() < min_fuel and slot <= 16 do
  turtle.select(slot)
  while turtle.refuel(1) and turtle.getFuelLevel() < min_fuel do
    turtle.refuel(1)
  end
  slot = slot + 1
end

if turtle.getFuelLevel() < min_fuel then
	print("could not refuel, current fuel: " .. tostring(turtle.getFuelLevel()) .. ", desired fuel: " .. tostring(min_fuel) .. ".")
end