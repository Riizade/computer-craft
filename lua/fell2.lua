local items = require("lib_items")
local navigation = require("lib_navigation")

logs_seen = {}

--- look at all 6 directions and record positions of logs
function discover_logs()
    blocks = navigation.check_blocks()
    for key, block in pairs(blocks) do
        if is_log(block.data.name) then
            logs_seen[#logs_seen+1] = block
        end
    end
    --- TODO: implement
end

--- check if we're looking at a log ---
local present, data = turtle.inspect()
if is_log(data.name) then
    turtle.dig()
    turtle.forward()
end

