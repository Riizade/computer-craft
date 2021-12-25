--- track position and movement history as global variables ---
position = vector.new(0, 0, 0)
direction = vector.new(0, 0, 1)
movement_history = {}
logs_seen = {}

--- creates a string that records the sign of each vector axis (e.g. (-1, 0, 1) > "-0+")
function direction_char(coord)
    if coord < 0 then
        return "-"
    elseif coord > 0 then
        return "+"
    else
        return "0"
    end
end

--- returns a string representing a unit vector on a 3D grid (only meant to face cardinal directions, but the format supports any vector made of 0, 1, -1)
function direction_string(vec)
    return direction_char(vec.x) .. direction_char(vec.y) .. direction_char(vec.z)
end

function rotations_needed(src_dir, dest_dir)
    local clockwise = {}
end

function face(vec)
    if vec:length() != 1 or vec.y != 0 then
        return false
    end



end

function move(vector)
    if direction:lower() == "forward" then
        turtle.forward()
        position = position + vector.new
    end
end

--- check if we're looking at a log ---
local present, data = turtle.inspect()
if data.name:find("log") then
    turtle.dig()
    turtle.forward()
end

