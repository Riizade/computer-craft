local items = require("items")

args = {...}

local width = tonumber(args[1])
local length = args[2]
if length != nil then
    length = tonumber(args[2])
end
local min_fuel = width + 1
local current_slot = 1
turtle.select(current_slot)


shell.run("min_fuel", tostring(min_fuel))
block_data = turtle.getItemDetail()

local right = true
local current_line_blocks = 0
turtle.forward()
while turtle.getFuelLevel() > 0 and items.count_blocks(block_name) > 0 do
    if current_line_blocks >= width then
        if right then
            turtle.turnLeft()
        else
            turtle.turnRight()
        end
        turtle.forward()
    end

    --- find next slot full of the desired item or break
    if turtle.getItemCount(current_slot) <= 0 then
        current_slot = turtle.find_next()
        if current_slot == nil then
            break
        end
    end

    turtle.select(current_slot)
    turtle.placeDown()
    turtle.forward()
end