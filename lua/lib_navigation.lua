--- track position and movement history as global variables ---
position = vector.new(0, 0, 0)
direction = vector.new(0, 0, 1)
movement_history = {}

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

--- checks if the given position is adjacent to the turtle
function is_adjacent(vec)
    --- TODO: Implement
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
    --- TODO: implement
end

--- move to the given coordinates, will not attempt to pathfind and can easily get stuck
function move(destination_vec)
    --- TODO: implement
end

--- move to the given coordinates by retracing its steps, will not work if it has not been to this location before
function backtrack(destination_vec)
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
    backtrack = backtrack }