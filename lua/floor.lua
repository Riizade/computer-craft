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
block_data = turtle.getItemDetail()


shell.run("min_fuel", tostring(min_fuel))
print("placing block " .. block_data.name)

local right = true
local current_line_blocks = 0
local completed_lines = 0
turtle.forward()
if width >= 1 then
    if right then
        turtle.turnRight()
    else
        turtle.turnLeft()
    end
end
while turtle.getFuelLevel() > 0 and items.count_blocks(block_data.name) > 0 do
    --- place block down
    turtle.select(current_slot)
    placed, err = turtle.placeDown()
    if err ~= nil then
        print("could not place block: " .. err)
    end
    current_line_blocks = current_line_blocks + 1

    --- find next slot full of the desired item or break
    if turtle.getItemCount(current_slot) <= 0 then
        current_slot = items.find_next()
        if current_slot == nil then
            print("ran out of " .. block_data.name)
            break
        end
    end

    --- if we are at the end of the line
    if current_line_blocks < width then
        turtle.forward()
    else
        --- move to the next line
        if width > 1 then --- if the width is 1, we will never turn in the first place
            if right then
                turtle.turnLeft()
                turtle.forward()
                turtle.turnLeft()
            else
                turtle.turnRight()
                turtle.forward()
                turtle.turnLeft()
            end
        else
            turtle.forward()
        end

        -- flip direction for next line
        right = not right

        --- update counts
        current_line_blocks = 0
        completed_lines = completed_lines + 1

        if length ~= nil and completed_lines >= length then
            print("completed desired length")
            break
        end


        shell.run("min_fuel", tostring(min_fuel))
    end
end

print("finished job")