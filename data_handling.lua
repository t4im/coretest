describe("minetest.serialize(table)", function()
	it("serializes large numeric indexes correctly (minetest/minetest#2206)", function(assert)
		Given("a table with a large enough numeric index")
		local test_table = { [100000000000000123] = "test" }
		When("serializing the table")
		local serialized_table = minetest.serialize(test_table)
		Then("deserialize back to the original version")
		assert.are.same(test_table, minetest.deserialize(serialized_table))
	end)
end)

local worldpath = minetest.get_worldpath()
describe("Settings:remove(key)", function()
	it("really persists written changes (minetest/minetest#2264)", function(assert)
		Given("a settings file with an example entry")
		local settings = Settings(worldpath .. "/test.conf")
		settings:set("testkey", "testvalue")
		assert.equals("testvalue", settings:get("testkey"))
		assert.equals("testvalue", settings:to_table().testkey)

		When("successfully written")
		assert.is.True(settings:write())

		Then("really persist the change")
		settings = Settings(worldpath .. "/test.conf")
		assert.equals("testvalue", settings:get("testkey"))
		assert.equals("testvalue", settings:to_table().testkey)

		Given("a removal of the key")
		assert.is.True(settings:remove("testkey"))
		assert.is.Nil(settings:get("testkey"))
		assert.is.Nil(settings:to_table().testkey)

		When("successfully written")
		assert.is.True(settings:write())

		Then("really delete the entry from the file")
		settings = Settings(worldpath .. "/test.conf")
		assert.is.Nil(settings:get("testkey"))
	end)

	it("fails when trying to remove some key that doesn't exist", function(assert)
		Given("a settings file")
		local settings = Settings(worldpath .. "/test.conf")
		Then("fail when removing a key that doesn't exist")
		assert.is.False(settings:remove("cobble"))
	end)
end)

