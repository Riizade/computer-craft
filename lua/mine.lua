args = {...}

local width = tonumber(args[1])
local height = tonumber(args[2])
local direction = args[3]
--- assume we are going up and left (start at bottom right) ---
local up = true
local left = true
--- if "down" is passed, reverse assumption ---
if direction == "down" then
  up = false
  left = false
end

for j=1,height do
  for i=1,width-1 do
	while turtle.detect() do
    	turtle.dig()
	end
    if left then
      turtle.turnLeft()
      turtle.forward()
      turtle.turnRight()
    else
      turtle.turnRight()
      turtle.forward()
      turtle.turnLeft()
    end
   end
  turtle.dig()
  if up then
    turtle.up()
  else
    turtle.down()
  end
  --- reverse direction for the next line ---
  left = not left
end