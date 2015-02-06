describe("minetest.serialize(table) -- minetest/minetest#2206", function()
	local test_table
	given("a table with a large enough numeric index", function()
		test_table = {[1000000000000123] = "test" }
	end)

	it("deserializes the serialized value back to its original", function(assert)
		assert.are.same(test_table, minetest.deserialize(minetest.serialize(test_table)))
	end)
end)

