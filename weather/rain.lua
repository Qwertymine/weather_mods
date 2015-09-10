local search_height = 32
local glass_check = false
local square_dist = 3

-- Rain
--[[
minetest.register_globalstep(function(dtime)
	if weather ~= "rain" then return end
	for _, player in ipairs(minetest.get_connected_players()) do
		local ppos = player:getpos()
		ppos.y = ppos.y + 2
		
		-- Make sure player is not in a cave/house...
		if minetest.env:get_node_light(ppos, 0.5) == 15 then 
			local minp = addvectors(ppos, {x=-9, y=7, z=-9})
			local maxp = addvectors(ppos, {x= 9, y=7, z= 9})

			local vel = {x=0, y=   -4, z=0}
			local acc = {x=0, y=-9.81, z=0}

			minetest.add_particlespawner({amount=12, time=0.5,
				minpos=minp, maxpos=maxp,
				minvel=vel, maxvel=vel,
				minacc=acc, maxacc=acc,
				minexptime=0.8, maxexptime=0.8,
				minsize=50, maxsize=50,
				collisiondetection=false, vertical=true, texture="weather_rain.png", player=player:get_player_name()})--]]
			--[[
		else
			local minp = addvectors(ppos, {x=-6, y=-7, z=-6})
			local maxp = addvectors(ppos, {x= 6, y=7, z= 6})
			local minpp = addvectors(ppos, {x=-6, y=7, z=-6})
			local vel = {x=0, y=   -4, z=0}
			local acc = {x=0, y=-9.81, z=0}
			local nodes = minetest.find_nodes_in_area_under_air(minp, maxp,{"group:crumbly"})
			local node = false
			for i,v in ipairs(nodes) do
				if minetest.env:get_node_light({x=v.x,y=v.y+1,z=v.z}, 0.5) == 15 then
					node = true
					break
				end
			end
			if node then
				minetest.add_particlespawner({amount=12, time=0.5,
				minpos=minpp, maxpos=maxp,
				minvel=vel, maxvel=vel,
				minacc=acc, maxacc=acc,
				minexptime=0.8, maxexptime=0.8,
				minsize=25, maxsize=25,
				collisiondetection=true, vertical=true, texture="weather_rain.png", player=player:get_player_name()})
			end
			for i,v in ipairs(nodes) do
				if minetest.env:get_node_light({x=v.x,y=v.y+1,z=v.z}, 0.5) == 15 then
					local p = addvectors(v, {x=0, y=7, z=0})
					minetest.add_particlespawner({amount=12, time=0.2,
					minpos=p, maxpos=p,
					minvel=vel, maxvel=vel,
					minacc=acc, maxacc=acc,
					minexptime=0.8, maxexptime=0.8,
					minsize=25, maxsize=25,
					collisiondetection=false, vertical=true, texture="weather_rain.png", player=player:get_player_name()})
				end
			end
			--]]--[[
		end


	end
end)
--]]--]]
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
})
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
		if weather == "rain" then
		--[
			if minetest.find_node_near(pos,search_dist,{"group:weather_effect"}) then
				return
			end
			--]
			local np = addvectors(pos, {x=0, y=1, z=0})
			if minetest.env:get_node_light(np, 0.5) == 15
			and minetest.env:get_node(np).name == "air" then
				if glass_check and #minetest.find_nodes_in_area(pos,{x=pos.x,y=pos.y+search_height,z=pos.z},{"group:cracky"}) ~= 0 then
					return
				end
				minetest.env:add_node(np, {name="weather:rain"})
			end
		end
	--]
	end
})
--]]

minetest.register_abm({
	nodenames = {"group:weather_effect"},
	interval = 1.0, 
	chance = 256,
	action = function (pos, node, active_object_count, active_object_count_wider)
		if weather == "rain" then
			minetest.env:set_node(pos, {name="weather:rain"})
		elseif weather == "dry" then
			minetest.env:set_node(pos, {name="weather:idle_node"})
		end
	end
})

minetest.register_abm({
	nodenames = {"group:weather_effect"},
	interval = 1.0, 
	chance = 256,
	action = function (pos, node, active_object_count, active_object_count_wider)
		if minetest.env:get_node_light(pos, 0.5) == 15 then
			return
		end
		--minetest.remove_node(pos)
	end
})

--[[
minetest.register_abm({
	nodenames = {"group:weather_effect"},
	interval = 1.0, 
	chance = 32,
	action = function (pos, node, active_object_count, active_object_count_wider)
		if minetest.env:get_node_light(pos, 0.5) == 15 then
			return
		end
		minetest.remove_node(pos)
	end
})


minetest.register_abm({
	nodenames = {"group:rain"},
	interval = 20.0, 
	chance = 1,
	action = function (pos, node, active_object_count, active_object_count_wider)
		if weather ~= "rain" then
			minetest.remove_node(pos)
		end
	end
})
--]]
