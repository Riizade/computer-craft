args = {...}
 
local width = tonumber(args[1])
local height = tonumber(args[2])
local min_fuel = width*height
local up = true

local walls_mined = 0
--- first fueling ---
shell.run("min_fuel", tostring(min_fuel))
while turtle.getFuelLevel() > min_fuel and turtle.getItemCount(16) == 0 do
	--- refuel ---
	shell.run("min_fuel", tostring(min_fuel))
	--- mine ---
	if up then
		shell.run("mine", tostring(width), tostring(height))
	else
		shell.run("mine", tostring(width), tostring(height), "down")
	end
	--- crawl forward for next wall ---
	turtle.forward()
	--- change direction for next wall ---
	up = not up
	--- track walls mined ---
	walls_mined = walls_mined + 1
end

print("total walls mined: " .. tostring(walls_mined) .. ".")
print("total blocks mined: " .. tostring(walls_mined * width * height) .. ".")
