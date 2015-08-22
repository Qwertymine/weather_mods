-- Rain

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
				collisiondetection=false, vertical=true, texture="weather_rain.png", player=player:get_player_name()})
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
			--]]
		end


	end
end)


minetest.register_node("weather:rain", {
	description = "RAIN",
	drawtype = "plantlike",
	visual_scale = 2.3,
	tiles = {
		{
			name = "weather_block_rain_ani.png",
			animation = {
				type = "vertical_frames",
				aspect_w = 256,
				aspect_h = 256,
				length = 1.0,
			},
		},
	},
	--tiles = {"weather_block_rain.png"},
	inventory_image = "default_junglegrass.png",
	wield_image = "default_junglegrass.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	buildable_to = true,
	groups = {weather_effect=1},
	selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, -5/16, 0.5},
	},
})

minetest.register_abm({
	nodenames = {"group:crumbly", "group:snappy", "group:cracky", "group:choppy"},
	neighbors = {"default:air"},
	interval = 20.0, 
	chance = 20,
	action = function (pos, node, active_object_count, active_object_count_wider)
		if weather == "rain" then
			if minetest.registered_nodes[node.name].drawtype == "normal"
			or minetest.registered_nodes[node.name].drawtype == "allfaces_optional" then
				local np = addvectors(pos, {x=0, y=1, z=0})
				local ap = addvectors(pos, {x=0, y=15, z=0})
				local vel = {x=0, y= -24, z=0}
				local acc = {x=0, y=-9.81, z=0}
				if minetest.env:get_node_light(np, 0.5) == 15
				and minetest.env:get_node(np).name == "air" then
					minetest.env:add_node(np, {name="weather:rain"})
				end
			end
		end
	end
})

minetest.register_abm({
	nodenames = {"weather:rain"},
	interval = 10.0, 
	chance = 8,
	action = function (pos, node, active_object_count, active_object_count_wider)
		minetest.remove_node(pos)
	end
})

minetest.register_abm({
	nodenames = {"weather:rain"},
	interval = 20.0, 
	chance = 1,
	action = function (pos, node, active_object_count, active_object_count_wider)
		if weather ~= "rain" then
			minetest.remove_node(pos)
		end
	end
})

