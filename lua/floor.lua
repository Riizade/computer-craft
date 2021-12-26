local items = require("items")

args = {...}

local width = tonumber(args[1])
local length = args[2]
if length ~= nil then
    length = tonumber(args[2])
end
local min_fuel = width + 1
local current_slot = 1
turtle.select(current_slot)


shell.run("min_fuel", tostring(min_fuel))
block_data = turtle.getItemDetail()

local right = true
local current_line_blocks = 0
local completed_lines = 0
turtle.forward()
while turtle.getFuelLevel() > 0 and items.count_blocks(block_name) > 0 do
    --- if we are at the end of the line
    if current_line_blocks >= width then
        --- move to the next line
        if right then
            turtle.turnLeft()
        else
            turtle.turnRight()
        end
        turtle.forward()
        --- update counts
        current_line_blocks = 0
        completed_lines = completed_lines + 1

        if length ~= nil and completed_lines >= length then
            break
        end
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
    current_line_blocks = current_line_blocks + 1
end