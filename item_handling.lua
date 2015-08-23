describe("minetest.get_craft_recipe() ", function()
	it("will return only fully matching recipes (minetest/minetest#2222)", function()
		Given("a recipe request of default:chest")
		local input = minetest.get_craft_recipe("default:chest")
		Then("return the correct recipe")
		assert.are.same({
			"group:wood", "group:wood", "group:wood",
			"group:wood", nil, "group:wood",
			"group:wood", "group:wood", "group:wood",
		}, input.items)
	end)
end)

