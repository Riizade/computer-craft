local utils = require("lib_utils")

--- track position and movement history as global variables ---
position = vector.new(0, 0, 0)
direction = vector.new(0, 0, 1)
movement_history = {}

function is_direction_vector(vec)
    --- check that the absolute value of any coordinate is no greater than 1
    if math.abs(v.x) > 1 or math.abs(v.y) > 1 or math.abs(v.z) > 1 then
        return false
    end

    --- check that there is exactly 1 1/-1 coordinate
    local count = 0
    if v.x == 1 or v.x == -1 then
        count = count + 1
    end

    if v.y == 1 or v.y == -1 then
        count = count + 1
    end

    if v.y == 1 or v.y == -1 then
        count = count + 1
    end

    if count ~= 1 then
        return false
    end

    return true
end

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
function direction_vector_to_string(vec)
    return direction_char(vec.x) .. direction_char(vec.y) .. direction_char(vec.z)
end

function direction_coord(char)
    if char == "-" then
        return -1
    elseif char == "0" then
        return 0
    else
        return 1
    end
end

function direction_string_to_vector(string)
    return vector.new(direction_coord(string[0]), direction_coord(string[1]), direction_coord(string[2]))
end

function vector_to_string(vec)
    return string.format("%d,%d,%d", vec.x, vec.y, vec.z)
end

function string_to_vector(s)
    list = utils.split(s)
    return vector.new(list[0], list[1], list[2])
end

function rotations_count(src_dir_string, dest_dir_string, rotations_table)
    local count = 0
    current_dir = src_dir_string

    while current_dir != dest_dir_string do
        current_dir = rotations_table[current_dir]
        count += 1
    end

    return count
end

function rotation_tables()
    --- defines clockwise rotations for each cardinal direction (src -> dest) ---
    local clockwise = {
        "00+"="+00",
        "+00"="00-",
        "00-"="-00",
        "-00"="00+",
    }

    --- same, for counterclockwise rotations ---
    local counterclockwise = {
        "+00"="00+",
        "00-"="+00",
        "-00"="00-",
        "00+"="-00",
    }

    return clockwise, counterclockwise
end

--- returns (count, direction) (number, string)
function rotations_needed_str(src_dir_string, dest_dir_string)
    clockwise, counterclockwise = rotation_tables()

    local clockwise_count = rotations_count(src_dir_string, dest_dir_string, clockwise)
    local counterclockwise_count = rotations_count(src_dir_string, dest_dir_string, counterclockwise)

    if counterclockwise_count < clockwise_count then
        return counterclockwise_count, "counterclockwise"
    else
        return clockwise_count, "clockwise"
    end
end

--- will not work properly if the vector is not a direction vector (unit vector with exactly one non-zero axis)
function rotate_direction_vector_clockwise(vec)
    local clockwise, counterclockwise = rotation_tables()
    local s = direction_vector_to_string(vec)
    return direction_string_to_vector(clockwise[s])
end

--- will not work properly if the vector is not a direction vector (unit vector with exactly one non-zero axis)
function rotate_direction_vector_counterclockwise(vec)
    local clockwise, counterclockwise = rotation_tables()
    local s = direction_vector_to_string(vec)
    return direction_string_to_vector(counterclockwise[s])
end

function rotations_needed(src_dir, dest_dir)
    return rotations_needed_string(destination_vector_to_string(src_dir), destination_vector_to_string(dest_dir))
end

function rotate_clockwise()
    clockwise, counterclockwise = rotation_tables()
    turtle.turnRight()
    --- convert to vector string, rotate using table, and convert back to a vector ---
    direction = direction_string_to_vector(clockwise[direction_vector_to_string(direction)])
end

function rotate_counterclockwise()
    clockwise, counterclockwise = rotation_tables()
    turtle.turnLeft()
    --- convert to vector string, rotate using table, and convert back to a vector ---
    direction = direction_string_to_vector(counter_clockwise[direction_vector_to_string(direction)])
end

function rotate_to(src_dir, dest_dir)
    count, rotation_dir = rotations_needed(src_dir, dest_dir)

    while count > 0 do
        if rotation_dir == "clockwise" then
            rotate_clockwise()
        else
            rotate_counterclockwise()
        end
        count -= 1
    end
end

--- checks all blocks around the turtle and returns a list of tables with two entries: (global_coordinates, block_data)
function check_blocks()
    local blocks = {}
    local block_location = nil
    local block_data = nil

    --- rotate to check sides
    for i=1,4 do
        block_location = position + direction
        block_data = turtle.detect()
        blocks[#blocks + 1] = { location = block_location, data = block_data }
        turtle.rotate_clockwise()
    end

    --- check above
    block_location = position + vector.new(0, 1, 0)
    block_data = turtle.detectUp()
    blocks[#blocks + 1] = { location = block_location, data = block_data }
    --- check below
    block_location = position + vector.new(0, -1, 0)
    block_data = turtle.detectDown()
    blocks[#blocks + 1] = { location = block_location, data = block_data }

    return blocks
end

--- checks if b is above a
function is_above(a, b)
    if a + vector.new(0, 1, 0) == b then
        return true
    else
        return false
    end
end

--- checks if b is below a
function is_below(a, b)
    if a + vector.new(0, -1, 0) == b then
        return true
    else
        return false
    end
end

--- checks if the b is left of a
function is_left(a, b)
    local left = rotate_direction_vector_counterclockwise(direction)
    if a + left == b then
        return true
    else
        return false
    end
end

--- checks if b is right of a
function is_right(a, b)
    local right = rotate_direction_vector_clockwise(direction)
    if a + right == b then
        return true
    else
        return false
    end
end

--- checks if b is in front of a
function is_front(a, b)
    if a + direction == b then
        return true
    else
        return false
    end
end

--- checks if b is behind a
function is_behind(a, b)
    local behind = rotate_direction_vector_clockwise(rotate_direction_vector_clockwise(direction))
    if a + behind == b then
        return true
    else
        return false
    end
end

--- checks if the given positions are adjacent to each other (above, below, beside)
function is_adjacent(a, b)
    return is_above(a, b) or is_below(a, b) or is_right(a, b) or is_left(a, b) or is_front(a, b) or is_behind(a, b)
end

--- moves the turtle forward and records history
function move_forward()
    turtle.forward()
    position = position + direction
    movement_history[vector_to_string(position)]
end

--- moves the turtle up and records history
function move_up()
    turtle.up()
    position = position + vector.new(0, 1, 0)
    movement_history[vector_to_string(position)]
end

--- moves the turtle down and records history
function move_down()
    turtle.down()
    position = position + vector.new(0, -1, 0)
    movement_history[vector_to_string(position)]
end

--- mines the block at the given position if it is adjacent
function mine_adjacent(vec)
    --- TODO: implement
end

--- mines the block at the given position if it is adjacent, then moves the turtle to where the block was
function mine_into_adjacent(vec)
    --- TODO: implement
end

--- move in the direction determined by the given vector, rotating if necessary
function move_direction(vec)
    if not is_direction_vector(vec) then
        error("non-direction vector " .. vector_to_string(vec) .. " given to move_direction()")
    end

    --- if the y vector is 0, we rotate and move forward
    if vec.y == 0 then
        rotate_to(direction, vec)
        move_forward()
    elseif vec.y == 1 then
        move_up()
    elseif vec.y == -1 then
        move_down()
    else
        error("a bug is present, should not have been able to reach this error in move_direction() (given " .. vector_to_string(vec) .. ")")
    end
end

--- move the turtle to the given adjacent position
function move_adjacent(vec)
    move_direction(vec - position)
end

--- move to the given coordinates, will not attempt to pathfind and can easily get stuck
function move(destination_vec)
    --- TODO: implement
end

--- finds any position in the movement history adjacent to the given position, or nil if none is found
function find_adjacent_history(target_vec)
    local destination_vec = nil
    for pos_string, bleh in pairs(movement_history) do
        vec = string_to_vector(pos_string)
        if is_adjacent(vec, target_vec) then
            destination_vec = vec
            break
        end
    end

    return destination_vec
end

--- move adjacent to the given coordinates by retracing its steps, will not work if it has not been to this location before
function backtrack_adjacent(target_vec)
    destination_vec = find_adjacent_history(target_vec)

    if destination_vec == nil then
        error("could not backtrack to target " .. vector_to_string(target_vec))
    end
    --- TODO: implement
end

return {
    rotations_needed = rotations_needed,
    rotate_clockwise = rotate_clockwise,
    rotate_counterclockwise = rotate_counterclockwise,
    rotate_to = rotate_to,
    check_blocks = check_blocks,
    move_direction = move_direction,
    move = move,
    backtrack_adjacent = backtrack_adjacent }