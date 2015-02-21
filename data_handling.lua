describe("minetest.serialize(table)", function()
	it("serializes large numeric indexes correctly (minetest/minetest#2206)", function()
		Given("a table with a large enough numeric index")
		local test_table = { [100000000000000123] = "test" }
		When("serializing the table")
		local serialized_table = minetest.serialize(test_table)
		Then("deserialize back to the original version")
		assert.are.same(test_table, minetest.deserialize(serialized_table))
	end)
	it("serializes nested tables correctly", function()
		Given("a table with a nested table")
		local test_table = {
			nested_table = {
				nested_value = 23,
			}
		}
		When("serializing the table")
		local serialized_table = minetest.serialize(test_table)
		Then("deserialize back to the original version")
		assert.are.same(test_table, minetest.deserialize(serialized_table))
	end)
	it("serializes floating point numbers correctly (minetest/minetest#2365)", function()
		Given("a table with floating point values and key")
		local test_table = {
			float1 = 1.1234567891234,
			float3 = 1234567891234.1,
			[1.1234567891234] = true,
			[1234567891234.1] = true,
			-- persisting anything with a higher precision than 14 seems currently unfeasible
			-- even though lua handles floating points in ram with a higher precision
			-- float2 = 12.1234567891234,
			-- float4 = 1234567891234.12,
			-- [12.1234567891234] = true,
			-- [1234567891234.12] = true,
		}
		When("serializing the table")
		local serialized_table = minetest.serialize(test_table)
		Then("deserialize back to the original version")
		assert.are.same(test_table, minetest.deserialize(serialized_table))
	end)
end)

local worldpath = minetest.get_worldpath()
describe("Settings:remove(key)", function()
	it("really persists written changes (minetest/minetest#2264)", function()
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

	it("fails when trying to remove some key that doesn't exist", function()
		Given("a settings file")
		local settings = Settings(worldpath .. "/test.conf")
		Then("fail when removing a key that doesn't exist")
		assert.is.False(settings:remove("cobble"))
	end)
end)

describe("table.copy(table)", function()
	it("doesn't crash when given false as value (minetest/minetest#2293)", function()
		Given("a table with a false boolean value")
		local test_table = { key = false }
		When("copying the table")
		local table_copy_func = function() table.copy(test_table) end
		Then("don't crash")
		assert.has_no.errors(table_copy_func)
	end)
end)
