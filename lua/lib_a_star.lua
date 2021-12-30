max_distance = 100000

--- modified from https://en.wikipedia.org/wiki/A*_search_algorithm
function reconstruct_path(cameFrom, current)
    --- create the total path, appending to end (causing the path to be backward)
    total_path = {current}
    while current, bleh in pairs(cameFrom) do
        current = cameFrom[current]
        total_path[#total_path+1] = current
    reversed = {}
    --- reverse the path to the correct order
    for i=1,#total_path,-1 do
        reversed[#reversed+1] = total_path[i]
    end
    return reversed

function lowest_fScore(fScore, openSet)
    local minKey = nil
    local minScore = max_distance
    for key, val in pairs(openSet) do
        if fScore[key] < minScore then
            minKey = key
            minScore = fScore[key]
        end
    end
    return minKey
end

-- A* finds a path from start to goal.
-- h is the heuristic function. h(n) estimates the cost to reach goal from node n.
-- here we use h(goal, n) for simplicity
function A_Star(start, goal, h, enumerate_neighbors)
    -- The set of discovered nodes that may need to be (re-)expanded.
    -- Initially, only the start node is known.
    -- This is usually implemented as a min-heap or priority queue rather than a hash-set.
    openSet = {start}

    -- For node n, cameFrom[n] is the node immediately preceding it on the cheapest path from start
    -- to n currently known.
    cameFrom = {}

    -- For node n, gScore[n] is the cost of the cheapest path from start to n currently known.
    gScore = {}
    gScore[start] = 0

    -- For node n, fScore[n] := gScore[n] + h(n). fScore[n] represents our current best guess as to
    -- how short a path from start to finish can be if it goes through n.
    fScore = {}
    fScore[start] = h(goal, start)

    while #openSet ~= 0 do
        -- This operation can occur in O(1) time if openSet is a min-heap or a priority queue
        current = lowest_fScore(fScore, openSet)
        if current = goal then
            return reconstruct_path(cameFrom, current)
        end

        openSet.remove(current)
        for idx, neighbor in pairs(enumerate_neighbors(current)) do
            -- d(current,neighbor) is the weight of the edge from current to neighbor (always 1 for a grid)
            -- tentative_gScore is the distance from start to the neighbor through current
            tentative_gScore = gScore[current] + 1 -- the 1 here is d(current, neighbor)
            if tentative_gScore < gScore[neighbor] then
                -- This path to neighbor is better than any previous one. Record it!
                cameFrom[neighbor] = current
                gScore[neighbor] = tentative_gScore
                fScore[neighbor] = tentative_gScore + h(goal, neighbor)
                if neighbor[openSet] == nil then
                    openSet.insert(neighbor, "dummy")
                end
            end
        end
    end

    -- Open set is empty but goal was never reached
    return failure
end

return {a_star = a_star, manhattan_distance = manhattan_distance, max_distance = max_distance}