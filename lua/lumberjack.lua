local max_tree_height = 15

--- refuel (needs to go all the way up and all the way down) ---
shell.run("min_fuel", tostring(max_tree_height*2))

--- dig the base block and replace it ---
turtle.dig()
turtle.forward()
--- dig up until the tree is gone ---
while turtle.detectUp() do
	turtle.digUp()
	turtle.up()
end
--- head back down ---
while not turtle.detectDown() do
	turtle.down()
end

--- refuel, potentially burning the wood we just mined ---
shell.run("min_fuel", tostring(max_tree_height*2))