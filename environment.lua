local dummy = cubictest.dummies.nodes
local test_position = {x=51,y=1,z=50}

-- minetest.dig_node(pos)
--  * Dig node with the same effects that a player would cause
--  * Returns `true` if successful, `false` on failure (e.g. protected location)
describe("minetest.dig_node(pos)", function()
	set_up(function()
		original_protection = minetest.is_protected
	end)

	it("always calls destructors of nodes it replaces", function()
		Given "a node with destructors"
		local dummy = dummy.destructable
		local nodedef = dummy.def
		local node = { name = dummy.name }
		minetest.set_node(test_position, node)
		stub(nodedef, "on_destruct")
		stub(nodedef, "after_destruct")

		When "digging it"
		minetest.dig_node(test_position)

		Then "always call its destructor on_destruct"
		assert.stub(nodedef.on_destruct).was_called()
		assert.stub(nodedef.on_destruct).was_called_with(test_position)
		nodedef.on_destruct:revert()

		And "always call its destructor after_destruct"
		assert.stub(nodedef.after_destruct).was_called()
--		assert.stub(nodedef.after_destruct).was_called_with(test_position, node)
		nodedef.after_destruct:revert()
	end)

	it("Returns false on failure (e.g. protected location) (minetest/minetest#2015)", function()
		Given "an undiggable node"
		minetest.is_protected = function(pos, name) return true end
		minetest.set_node(test_position, {name = dummy.undiggable.name })

		When "digging it"
		local dig = minetest.dig_node(test_position)

		Then "return false"
		assert.is.False(dig)
	end)

	tear_down(function()
		-- revert to former state after run
		minetest.is_protected = original_protection
	end)
end)

-- minetest.set_node(pos, node)
-- minetest.add_node(pos, node): alias set_node(pos, node)`
-- * Set node at position (`node = {name="foo", param1=0, param2=0}`)
describe("minetest.set_node(pos, node)", function()
	it("always calls destructors of nodes it replaces", function()
		Given "a node with destructors"
		local dummy = dummy.destructable
		local nodedef = dummy.def
		local node = { name = dummy.name }
		minetest.set_node(test_position, node)
		stub(nodedef, "on_destruct")
		stub(nodedef, "after_destruct")

		When "replacing it with another node"
		minetest.set_node(test_position, {name="default:stone"})

		Then "always call its destructor on_destruct"
		assert.stub(nodedef.on_destruct).was_called()
		assert.stub(nodedef.on_destruct).was_called_with(test_position)
		nodedef.on_destruct:revert()

		And "always call its destructor after_destruct"
		assert.stub(nodedef.after_destruct).was_called()
--		assert.stub(nodedef.after_destruct).was_called_with(test_position, node)
		nodedef.after_destruct:revert()
	end)
end)
