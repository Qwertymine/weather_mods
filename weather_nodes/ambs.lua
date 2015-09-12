local search_height = 32
--local square_dist = 3
local search_attempts = 3

w = {}

w.search_up = function(pos,search)
	local nodes = minetest.find_nodes_in_area_under_air(
		{x=pos.x,y=pos.y,z=pos.z},
		{x=pos.x,y=pos.y+search_height,z=pos.z},
		{"group:crumbly",
		"group:snappy", 
		"group:cracky",
		"group:choppy",
		"group:liquid"})
	local s = search or 1
	if #nodes == 0 then
		if s<search_attempts then
			return w.search_up({x=pos.x,y=pos.y+search_height,z=pos.z},s+1)
		else
			--minetest.chat_send_all("hi")
			return nil
		end
	end
	local ret = -40000
	for i,v in ipairs(nodes) do
		if v.y > ret then
			ret = v.y
		end
	end
	if ret == -40000 then
		minetest.debug("Error in rain search_up")
		return
	end
	return {x=pos.x,y=ret+1,z=pos.z}
end

w.search_down = function(pos,search)
	local nodes = minetest.find_nodes_in_area_under_air(
		{x=pos.x,y=pos.y-search_height,z=pos.z},
		{x=pos.x,y=pos.y-1,z=pos.z},
		{"group:crumbly",
		"group:snappy", 
		"group:cracky",
		"group:choppy",
		"group:liquid"})
	local s = search or 1
	if #nodes == 0 then
		if s<search_attempts then
			return w.search_down({x=pos.x,y=pos.y-search_height,z=pos.z},s+1)
		else
			--minetest.chat_send_all("hi")
			return nil
		end
	end
	local ret = -40000
	for i,v in ipairs(nodes) do
		if v.y > ret then
			ret = v.y
		end
	end
	if ret == -40000 then
		minetest.debug("Error in rain search_down")
		return
	end
	return {x=pos.x,y=ret+1,z=pos.z}
end

local search_height = 32
--local square_dist = 3
local search_attempts = 3

w = {}

w.search_up = function(pos,search)
	local nodes = minetest.find_nodes_in_area_under_air(
		{x=pos.x,y=pos.y,z=pos.z},
		{x=pos.x,y=pos.y+search_height,z=pos.z},
		{"group:crumbly",
		"group:snappy", 
		"group:cracky",
		"group:choppy",
		"group:liquid"})
	local s = search or 1
	if #nodes == 0 then
		if s<search_attempts then
			return w.search_up({x=pos.x,y=pos.y+search_height,z=pos.z},s+1)
		else
			--minetest.chat_send_all("hi")
			return nil
		end
	end
	local ret = -40000
	for i,v in ipairs(nodes) do
		if v.y > ret then
			ret = v.y
		end
	end
	if ret == -40000 then
		minetest.debug("Error in rain search_up")
		return
	end
	return {x=pos.x,y=ret+1,z=pos.z}
end

w.search_down = function(pos,search)
	local nodes = minetest.find_nodes_in_area_under_air(
		{x=pos.x,y=pos.y-search_height,z=pos.z},
		{x=pos.x,y=pos.y-1,z=pos.z},
		{"group:crumbly",
		"group:snappy", 
		"group:cracky",
		"group:choppy",
		"group:liquid"})
	local s = search or 1
	if #nodes == 0 then
		if s<search_attempts then
			return w.search_down({x=pos.x,y=pos.y-search_height,z=pos.z},s+1)
		else
			--minetest.chat_send_all("hi")
			return nil
		end
	end
	local ret = -40000
	for i,v in ipairs(nodes) do
		if v.y > ret then
			ret = v.y
		end
	end
	if ret == -40000 then
		minetest.debug("Error in rain search_down")
		return
	end
	return {x=pos.x,y=ret+1,z=pos.z}
end
