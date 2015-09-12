minetest.register_node("weather_nodes:rain", {
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
		--minetest.chat_send_all(node.name)
		if node and minetest.get_node_group(node.name,"weather_effect") ~= 0 then
			return
		end
		local newpos = w.search_up(pos)
		--minetest.chat_send_all("oldpos"..pos.y)
		if newpos then
			--minetest.chat_send_all("newpos".. newpos.y)
			minetest.env:set_node(newpos, {name="weather_nodes:rain"})
			return
		else
			newpos = w.search_down(pos)
		end
		if newpos then
			--minetest.chat_send_all("newpos".. newpos.y)
			minetest.env:set_node(newpos, {name="weather_nodes:rain"})
			return
		else
			minetest.debug("Rain Lost")
		end
	end,
})

minetest.register_abm({
	nodenames = {"weather_nodes:rain"},
	interval = 1.0, 
	chance = 32,
	action = function (pos, node, active_object_count, active_object_count_wider)
		if weather ~= "rain" then
			if weather == "dry" then
				minetest.env:set_node(pos, {name="weather_nodes:idle_node"})
			elseif weather == "snow" then
				minetest.env:set_node(pos, {name="weather_nodes:snow"})
			end
		end
	end
})


