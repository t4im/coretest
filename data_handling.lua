describe("minetest.serialize(table) -- minetest/minetest#2206", function()
	local test_table
	given("a table with a large enough numeric index", function()
		test_table = {[1000000000000123] = "test" }
	end)

	it("deserializes the serialized value back to its original", function(assert)
		assert.are.same(test_table, minetest.deserialize(minetest.serialize(test_table)))
	end)
end)


local worldpath = minetest.get_worldpath()
describe("Settings:remove(key) -- minetest/minetest#2264", function()
	local settings
	given("a written settings file with an example entry", function()
		settings = Settings(worldpath .. "/test.conf")
		settings:set("testkey", "testvalue")
		mtt.assert.equals("testvalue", settings:get("testkey"))
		mtt.assert.equals("testvalue", settings:to_table().testkey)
		mtt.assert.is.True(settings:write())
	end)

	it("has written the change", function(assert)
		settings = Settings(worldpath .. "/test.conf")
		assert.equals("testvalue", settings:get("testkey"))
		assert.equals("testvalue", settings:to_table().testkey)
	end)

	it("removes the existing key when requested", function(assert)
		assert.is.True(settings:remove("testkey"))
		assert.is.Nil(settings:get("testkey"))
		assert.is.Nil(settings:to_table().testkey)
		assert.is.True(settings:write())
	end)

	it("persists the removal of a key", function(assert)
		settings = Settings(worldpath .. "/test.conf")
		assert.is.Nil(settings:get("testkey"))
	end)

	it("fails when trying to remove some key that doesn't exist", function(assert)
		assert.is.False(settings:remove("cobble"))
	end)
end)

