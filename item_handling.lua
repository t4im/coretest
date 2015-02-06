describe("minetest/minetest#2222", function()
	it("returns the correct recipe", function(assert)
		local input = minetest.get_craft_recipe("default:chest")
		assert.are.same({
			"group:wood", "group:wood", "group:wood",
			"group:wood", nil, "group:wood",
			"group:wood", "group:wood", "group:wood",
		}, input.items)
	end)
end)

