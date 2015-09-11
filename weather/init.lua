-- Weather:
-- * rain
-- * snow
-- * wind (not implemented)

minetest.register_node("weather:idle_node", {
	description = "RAIN",
	drawtype = "airlike",
	--tiles = {"weather_block_rain_lag.png"},
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

addvectors = function (v1, v2)
	return {x=v1.x+v2.x, y=v1.y+v2.y, z=v1.z+v2.z}
end

save_weather = function ()
	local file = io.open(minetest.get_worldpath().."/weather", "w+")
	file:write(weather)
	file:close()
end

read_weather = function ()
	local file = io.open(minetest.get_worldpath().."/weather", "r")
	if not file then return end
	local readweather = file:read()
	file:close()
	return readweather
end

weather = "rain" -- read_weather()
--[[
minetest.register_globalstep(function(dtime)
	if weather == "rain" or weather == "snow" then
		if math.random(1, 10000) == 1 then
			weather = "none"
			save_weather()
		end
	else
		if math.random(1, 50000) == 1 then
			weather = "rain"
			save_weather()
		end
		if math.random(1, 50000) == 2 then
			weather = "snow"
			save_weather()
		end
	end
end)
--]]

dofile(minetest.get_modpath("weather").."/rain.lua")
dofile(minetest.get_modpath("weather").."/snow.lua")
dofile(minetest.get_modpath("weather").."/command.lua")

local c_air     = minetest.get_content_id("air")
local c_stone   = minetest.get_content_id("default:stone")
local c_weather = minetest.get_content_id("weather:idle_node")


minetest.register_on_generated(function(minp, maxp, seed)
	local pr = PseudoRandom(seed)
	--[[
	if minp.y > (height + depth) or maxp.y < (height - depth) then
		return
	end
	--]]
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
	vm:set_data(data)
	vm:write_to_map(data)
end)

