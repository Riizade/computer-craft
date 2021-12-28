local items = require("lib_items")
local navigation = require("lib_navigation")

desired_block_data = turtle.detect()
if desired_block_data == nil then
    error("no block in front of turtle")
end
blocks_seen = {}

--- look at all 6 directions and record positions of desired blocks
function discover_blocks()
    blocks = navigation.check_blocks()
    for key, block in pairs(blocks) do
        if block.data.name == desired_block_data.name then
            blocks_seen[navigation.vector_to_string(block.location)] = 1
        end
    end
end

--- returns the position of the closest desired block
function closest_desired_block()

end

--- check if we're looking at a desired block ---
local present, data = turtle.inspect()
if block.data.name == desired_block_data.name then
    --- dig block then replace it
    turtle.dig()
    turtle.forward()
    --- look around for new blocks
    discover_blocks()
end

