minetest.register_node("weather_nodes:idle_node", {
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
	after_destruct = function(pos)
		local node = minetest.get_node_or_nil(pos)
		if node and minetest.get_node_group(node.name,"weather_effect") ~= 0 then
			return
		end
		local newpos = w.search_up(pos)
		--minetest.chat_send_all("oldpos"..pos.y)
		if newpos then
			--minetest.chat_send_all("newpos".. newpos.y)
			minetest.env:set_node(newpos, {name="weather_nodes:idle_node"})
			return
		else
			newpos = w.search_down(pos)
		end
		if newpos then
			--minetest.chat_send_all("newpos".. newpos.y)
			minetest.env:set_node(newpos, {name="weather_nodes:idle_node"})
			return
		else
			minetest.debug("Idle Lost")
		end
	end,
})

minetest.register_abm({
	nodenames = {"weather_nodes:idle_node"},
	interval = 1.0, 
	chance = 32,
	action = function (pos, node, active_object_count, active_object_count_wider)
		if weather ~= "dry" then
			if weather == "rain" then
				minetest.env:set_node(pos, {name="weather_nodes:rain"})
			elseif weather == "snow" then
				minetest.env:set_node(pos, {name="weather_nodes:snow"})
			end
		end
	end
})
