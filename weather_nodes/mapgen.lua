local c_air     = minetest.get_content_id("air")
local c_stone   = minetest.get_content_id("default:stone")
local c_weather = minetest.get_content_id("weather_nodes:idle_node")


minetest.register_on_generated(function(minp, maxp, seed)
	local pr = PseudoRandom(seed)
	if minp.y > (400) or maxp.y < (0) then
		return
	end
	-- read chunk data
	local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
	local area = VoxelArea:new{MinEdge=emin, MaxEdge=emax}
	local data = vm:get_data()
	local l_data = vm:get_light_data()

	local side_length = maxp.x - minp.x + 1
	local biglen = side_length+32

	local chulens = {x=side_length, y=side_length + 5, z=side_length}

	--minetest.debug(map_seed)
	for z = minp.z,maxp.z do
		if z%2 ==0 then
			for x = minp.x,maxp.x do
				if x%2 == 0 then
					local vi
					local vi_last
					for y = -maxp.y,-minp.y do
						if -y > 0 then
							vi_last = vi
							vi = area:index(x,-y,z)
							if vi_last then
								if data[vi] == c_air then
								--do nothing
								elseif l_data[vi_last]%16 == 15 then
									data[vi_last] = c_weather
									break
								else
									break
								end
							end
						end
					end
				end
			end
		end
	end
	vm:set_data(data)
	vm:write_to_map(data)
end)

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
		local np = {x=pos.x,y=pos.y+1,z=pos.z}
		if minetest.env:get_node_light(np, 0.5) == 15
		and minetest.env:get_node(np).name == "air" then
			minetest.env:add_node(np, {name="weather_nodes:idle_node"})
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
