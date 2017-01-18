local backpacks = {}

backpacks.form = "size[8,7]" ..
	default.gui_bg ..
	default.gui_bg_img ..
	default.gui_slots ..
	"list[current_name;main;0,0.3;8,2]" ..
	"list[current_player;main;0,2.85;8,1]" ..
	"list[current_player;main;0,4.08;8,3;8]" ..
	"listring[current_name;main]" ..
	"listring[current_player;main]"
backpacks.on_construct = function(pos)
	local meta = minetest.get_meta(pos)
	meta:set_string("infotext", "Backpack")
	meta:set_string("formspec", backpacks.form)
	local inv = meta:get_inventory()
	inv:set_size("main", 8*2)
end
backpacks.after_place_node = function(pos, placer, itemstack, pointed_thing)
	local meta = minetest.get_meta(pos)
	local stuff = minetest.deserialize(itemstack:get_metadata())
	if stuff then
		meta:from_table(stuff)
	end
	itemstack:take_item()
end
backpacks.on_dig = function(pos, node, digger)
	if minetest.is_protected(pos, digger:get_player_name()) then
		return false
	end
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	local list = {}
	for i, stack in ipairs(inv:get_list("main")) do
		if stack:get_name() == "" then
			list[i] = ""
		else 
			list[i] = stack:to_string()
		end
	end
	local new_list = {inventory = {main = list},
			fields = {infotext = "Backpack", formspec = backpacks.form}}
	local new_list_as_string = minetest.serialize(new_list)
	local new = ItemStack(node)
	new:set_metadata(new_list_as_string)
	minetest.remove_node(pos)
	local player_inv = digger:get_inventory()
	if player_inv:room_for_item("main", new) then
		player_inv:add_item("main", new)
	else
		minetest.add_item(pos, new)
	end
end
backpacks.allow_metadata_inventory_put = function(pos, listname, index, stack, player)
	if not string.match(stack:get_name(), "backpacks:backpack_") then
		return stack:get_count()
	else
		return 0
	end
end

-- Wool backpack
minetest.register_node("backpacks:backpack_wool", {
	description = "Wool Backpack",
	tiles = {
		"wool_white.png^backpacks_backpack_topbottom.png", -- Top
		"wool_white.png^backpacks_backpack_topbottom.png", -- Bottom
		"wool_white.png^backpacks_backpack_sides.png",     -- Right Side
		"wool_white.png^backpacks_backpack_sides.png",     -- Left Side
		"wool_white.png^backpacks_backpack_back.png",      -- Back
		"wool_white.png^backpacks_backpack_front.png"      -- Front
	},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.4375, -0.5, -0.375, 0.4375, 0.5, 0.375},
			{0.125, -0.375, 0.4375, 0.375, 0.3125, 0.5},
			{-0.375, -0.375, 0.4375, -0.125, 0.3125, 0.5},
			{0.125, 0.1875, 0.375, 0.375, 0.375, 0.4375},
			{-0.375, 0.1875, 0.375, -0.125, 0.375, 0.4375},
			{0.125, -0.375, 0.375, 0.375, -0.25, 0.4375},
			{-0.375, -0.375, 0.375, -0.125, -0.25, 0.4375},
			{-0.3125, -0.375, -0.4375, 0.3125, 0.1875, -0.375},
			{-0.25, -0.3125, -0.5, 0.25, 0.125, -0.4375},
		}
	},
	groups = {dig_immediate = 3, oddly_diggable_by_hand = 3},
	stack_max = 1,
	on_construct = backpacks.on_construct,
	after_place_node = backpacks.after_place_node,
	on_dig = backpacks.on_dig,
	allow_metadata_inventory_put = backpacks.allow_metadata_inventory_put,
})
minetest.register_craft({
	output = "backpacks:backpack_wool",
	recipe = {
		{"wool:white", "wool:white", "wool:white"},
		{"wool:white", "", "wool:white"},
		{"wool:white", "wool:white", "wool:white"},
	}
})

if mobs and mobs.redo then
	-- Leather backpack
	minetest.register_node("backpacks:backpack_leather", {
		description = "Leather Backpack",
		tiles = {
			"backpacks_leather.png^backpacks_backpack_topbottom.png", -- Top
			"backpacks_leather.png^backpacks_backpack_topbottom.png", -- Bottom
			"backpacks_leather.png^backpacks_backpack_sides.png",     -- Right Side
			"backpacks_leather.png^backpacks_backpack_sides.png",     -- Left Side
			"backpacks_leather.png^backpacks_backpack_back.png",      -- Back
			"backpacks_leather.png^backpacks_backpack_front.png"      -- Front
		},
		drawtype = "nodebox",
		paramtype = "light",
		paramtype2 = "facedir",
		node_box = {
			type = "fixed",
			fixed = {
				{-0.4375, -0.5, -0.375, 0.4375, 0.5, 0.375},
				{0.125, -0.375, 0.4375, 0.375, 0.3125, 0.5},
				{-0.375, -0.375, 0.4375, -0.125, 0.3125, 0.5},
				{0.125, 0.1875, 0.375, 0.375, 0.375, 0.4375},
				{-0.375, 0.1875, 0.375, -0.125, 0.375, 0.4375},
				{0.125, -0.375, 0.375, 0.375, -0.25, 0.4375},
				{-0.375, -0.375, 0.375, -0.125, -0.25, 0.4375},
				{-0.3125, -0.375, -0.4375, 0.3125, 0.1875, -0.375},
				{-0.25, -0.3125, -0.5, 0.25, 0.125, -0.4375},
			}
		},
		groups = {dig_immediate = 3, oddly_diggable_by_hand = 3},
		stack_max = 1,
		on_construct = backpacks.on_construct,
		after_place_node = backpacks.after_place_node,
		on_dig = backpacks.on_dig,
		allow_metadata_inventory_put = backpacks.allow_metadata_inventory_put,
	})
	minetest.register_craft({
		output = "backpacks:backpack_leather",
		recipe = {
			{"mobs:leather", "mobs:leather", "mobs:leather"},
			{"mobs:leather", "", "mobs:leather"},
			{"mobs:leather", "mobs:leather", "mobs:leather"},
		}
	})
end
