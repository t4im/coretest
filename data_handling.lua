mtt.test("minetest.serialize(table) -- minetest/minetest#2206", function(assert)
	local table = {[1000000000000123] = "test" }
	assert.are.same(table, minetest.deserialize(minetest.serialize(table)))	
end)

