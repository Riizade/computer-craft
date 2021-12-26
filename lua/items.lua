function find_next(block_name)
    for i=1,16 do
        turtle.select(i)
        data = turtle.getItemDetail()
        if data.name == block_name then
            return i
        end
    end

    return nil
end

function count_blocks(block_name)
    local count = 0
    for i=1,16 do
        turtle.select(i)
        local data = turtle.getItemDetail()
        if data ~= nil and data.name == block_name then
            count = turtle.getItemCount(i) + count
        end
    end

    return count
end

return { find_next = find_next, count_blocks = count_blocks }