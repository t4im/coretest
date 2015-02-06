describe("minetest/minetest#2222", function()
	local input

	given("a recipe request of default:chest", function()
		input = minetest.get_craft_recipe("default:chest")
	end)

	it("returns the correct recipe", function(assert)
		assert.are.same({
			"group:wood", "group:wood", "group:wood",
			"group:wood", nil, "group:wood",
			"group:wood", "group:wood", "group:wood",
		}, input.items)
	end)
end)

