
describe("minetest.serialize(table) -- minetest/minetest#2206", function()
	local table = {[1000000000000123] = "test" }

	it("deserializes the serialized value back to its original", function(assert)
		assert.are.same(table, minetest.deserialize(minetest.serialize(table)))
	end)
end)

