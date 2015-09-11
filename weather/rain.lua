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

minetest.register_node("weather:rain", {
	description = "RAIN",
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			-- body
			{-0.5,0.0,0.0,0.5,20.0,0.0},
			{0.0,0.0,-0.5,0.0,20.0,0.5},
		}
	},
	visual_scale = 2.3,
	tiles = {
		{
			name = "weather_block_rain_ani.png",
			animation = {
				type = "vertical_frames",
				aspect_w = 144,
				aspect_h = 256,
				length = 1.0,
			},
		},
		{
			name = "weather_block_rain_ani.png",
			animation = {
				type = "vertical_frames",
				aspect_w = 144,
				aspect_h = 256,
				length = 1.0,
			},
		},
				{
			name = "weather_block_rain_ani.png",
			animation = {
				type = "vertical_frames",
				aspect_w = 144,
				aspect_h = 256,
				length = 1.0,
			},
		},
		{
			name = "weather_block_rain_ani.png",
			animation = {
				type = "vertical_frames",
				aspect_w = 144,
				aspect_h = 256,
				length = 1.0,
			},
		},
				{
			name = "weather_block_rain_ani.png",
			animation = {
				type = "vertical_frames",
				aspect_w = 144,
				aspect_h = 256,
				length = 1.0,
			},
		},
		{
			name = "weather_block_rain_ani.png",
			animation = {
				type = "vertical_frames",
				aspect_w = 144,
				aspect_h = 256,
				length = 1.0,
			},
		},
	},
	--tiles = {"weather_block_rain_lag.png"},
	inventory_image = "default_junglegrass.png",
	wield_image = "default_junglegrass.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	buildable_to = true,
	groups = {weather_effect=1,rain=1},
	selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, -5/16, 0.5},
	},
	on_blast = function() end,
	after_destruct = function(pos)
		local node = minetest.get_node_or_nil(pos)
		if node and minetest.get_node_group(node.name,"group:weather_effect") ~= 0 then
			return
		end
		--minetest.chat_send_all("trig")
		local newpos = w.search_up(pos)
		--minetest.chat_send_all("oldpos"..pos.y)
		if newpos then
			--minetest.chat_send_all("newpos".. newpos.y)
		---[[
			minetest.env:set_node(newpos, {name="weather:rain"})
			return
		--]]
		else
			newpos = w.search_down(pos)
		end
		if newpos then
			--minetest.chat_send_all("newpos".. newpos.y)
		---[[
			minetest.env:set_node(newpos, {name="weather:rain"})
			return
		--]]
		else
			minetest.debug("Rain Lost")
		end
	end,
})

minetest.register_abm({
	nodenames = {"weather:rain"},
	interval = 1.0, 
	chance = 32,
	action = function (pos, node, active_object_count, active_object_count_wider)
		if weather ~= "rain" then
			if weather == "dry" then
				minetest.env:set_node(pos, {name="weather:idle_node"})
			elseif weather == "snow" then
				minetest.env:set_node(pos, {name="weather:snow"})
			end
		end
	end
})

--To add weather nodes to old maps
--[[
minetest.register_abm({
	nodenames = {"group:crumbly", "group:snappy", "group:cracky", "group:choppy","group:liquid"},
	neighbors = {"default:air"},
	interval = 1.0, 
	chance = 256,
	action = function (pos, node, active_object_count, active_object_count_wider)
		if pos.x%square_dist ~= 0 or pos.z%square_dist ~= 0 then
			return
		end
		local np = addvectors(pos, {x=0, y=1, z=0})
		if minetest.env:get_node_light(np, 0.5) == 15
		and minetest.env:get_node(np).name == "air" then
			minetest.env:add_node(np, {name="weather:idle_node"})
		end
	end
})
--]]

--Remove All weather nodes from a world
--[[
minetest.register_abm({
	nodenames = {"group:weather_effect"},
	interval = 20.0, 
	chance = 1,
	action = function (pos, node, active_object_count, active_object_count_wider)
		minetest.remove_node(pos)
	end
})
--]]
