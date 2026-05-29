--!strict
--!native

local ReplicatedStorage = game:GetService('ReplicatedStorage')

const require = require(ReplicatedStorage.Packages.Loader).load()
const Table = require("Table")

return function()
	describe('Table.append', function()
		it('should append source values to target', function()
			local target = { 1, 2, 3 }
			local source = { 4, 5, 6 }
			local result = Table.append(target, source)
			expect(result).to.equal(target)
			expect(#result).to.equal(6)
			expect(result[4]).to.equal(4)
			expect(result[5]).to.equal(5)
			expect(result[6]).to.equal(6)
		end)

		it('should return the target table', function()
			local target = { 1 }
			local result = Table.append(target, { 2 })
			expect(result).to.equal(target)
		end)

		it('should handle empty source', function()
			local target = { 1, 2 }
			Table.append(target, {})
			expect(#target).to.equal(2)
		end)

		it('should handle empty target', function()
			local target = {}
			Table.append(target, { 1, 2 })
			expect(#target).to.equal(2)
		end)
	end)

	describe('Table.merge', function()
		it('should merge two maps without modifying either', function()
			local orig = { a = 1, b = 2 }
			local new = { c = 3, d = 4 }
			local result = Table.merge(orig, new)
			expect(result.a).to.equal(1)
			expect(result.b).to.equal(2)
			expect(result.c).to.equal(3)
			expect(result.d).to.equal(4)
		end)

		it('should not modify original tables', function()
			local orig = { a = 1 } :: any
			local new = { b = 2 }
			Table.merge(orig, new)
			expect(orig.b).to.equal(nil)
		end)

		it('should overwrite keys from orig with new', function()
			local orig = { a = 1 }
			local new = { a = 99 }
			local result = Table.merge(orig, new)
			expect(result.a).to.equal(99)
		end)
	end)

	describe('Table.reverse', function()
		it('should reverse a list', function()
			local result = Table.reverse({ 1, 2, 3 })
			expect(result[1]).to.equal(3)
			expect(result[2]).to.equal(2)
			expect(result[3]).to.equal(1)
		end)

		it('should not modify the original', function()
			local orig = { 1, 2, 3 }
			Table.reverse(orig)
			expect(orig[1]).to.equal(1)
		end)

		it('should handle empty table', function()
			local result = Table.reverse({})
			expect(#result).to.equal(0)
		end)

		it('should handle single element', function()
			local result = Table.reverse({ 42 })
			expect(result[1]).to.equal(42)
		end)
	end)

	describe('Table.values', function()
		it('should return all values from a map', function()
			local source = { a = 1, b = 2, c = 3 }
			local result = Table.values(source)
			expect(#result).to.equal(3)
		end)

		it('should handle empty table', function()
			local result = Table.values({})
			expect(#result).to.equal(0)
		end)
	end)

	describe('Table.keys', function()
		it('should return all keys from a map', function()
			local source = { a = 1, b = 2, c = 3 }
			local result = Table.keys(source)
			expect(#result).to.equal(3)
		end)

		it('should handle empty table', function()
			local result = Table.keys({})
			expect(#result).to.equal(0)
		end)
	end)

	describe('Table.mergeLists', function()
		it('should merge two lists', function()
			local result = Table.mergeLists({ 1, 2 }, { 3, 4 })
			expect(#result).to.equal(4)
			expect(result[1]).to.equal(1)
			expect(result[3]).to.equal(3)
		end)

		it('should not modify original lists', function()
			local orig = { 1, 2 }
			Table.mergeLists(orig, { 3 })
			expect(#orig).to.equal(2)
		end)

		it('should handle empty lists', function()
			local result = Table.mergeLists({}, {})
			expect(#result).to.equal(0)
		end)
	end)

	describe('Table.swapKeyValue', function()
		it('should swap keys and values', function()
			local result = Table.swapKeyValue({ a = 1, b = 2 })
			expect(result[1]).to.equal('a')
			expect(result[2]).to.equal('b')
		end)

		it('should handle empty table', function()
			local result = Table.swapKeyValue({})
			expect(next(result)).to.equal(nil)
		end)
	end)

	describe('Table.flip', function()
		it('should be an alias for swapKeyValue', function()
			local orig = { x = 10, y = 20 }
			local flipped = Table.flip(orig)
			expect(flipped[10]).to.equal('x')
			expect(flipped[20]).to.equal('y')
		end)
	end)

	describe('Table.toList', function()
		it('should convert a map to a list', function()
			local result = Table.toList({ a = 1, b = 2 })
			expect(#result).to.equal(2)
		end)

		it('should handle empty table', function()
			local result = Table.toList({})
			expect(#result).to.equal(0)
		end)
	end)

	describe('Table.count', function()
		it('should count array entries', function()
			expect(Table.count({ 1, 2, 3 })).to.equal(3)
		end)

		it('should count map entries', function()
			expect(Table.count({ a = 1, b = 2 })).to.equal(2)
		end)

		it('should return 0 for empty table', function()
			expect(Table.count({})).to.equal(0)
		end)
	end)

	describe('Table.copy', function()
		it('should shallow copy a table', function()
			local orig = { 1, 2, 3 }
			local copy = Table.copy(orig)
			expect(copy).never.to.equal(orig)
			expect(copy[1]).to.equal(1)
		end)

		it('should not deep copy nested tables', function()
			local nested = { a = 1 }
			local orig = { nested = nested }
			local copy = Table.copy(orig)
			expect(copy.nested).to.equal(nested)
		end)
	end)

	describe('Table.deepCopy', function()
		it('should deep copy a table', function()
			local nested = { a = 1 }
			local orig = { nested = nested }
			local copy = Table.deepCopy(orig)
			expect(copy.nested).never.to.equal(nested)
			expect(copy.nested.a).to.equal(1)
		end)

		it('should handle non-table values', function()
			expect(Table.deepCopy(42)).to.equal(42)
			expect(Table.deepCopy('hello')).to.equal('hello')
		end)
	end)

	describe('Table.deepOverwrite', function()
		it('should overwrite target with source values', function()
			local target = { a = 1, b = 2 }
			local result = Table.deepOverwrite(target, { b = 99, c = 3 })
			expect(result.b).to.equal(99)
			expect(result.c).to.equal(3)
		end)

		it('should recursively overwrite nested tables', function()
			local target = { nested = { a = 1, b = 2 } }
			Table.deepOverwrite(target, { nested = { b = 99 } })
			expect(target.nested.a).to.equal(1)
			expect(target.nested.b).to.equal(99)
		end)
	end)

	describe('Table.getIndex', function()
		it('should return the index of a value', function()
			expect(Table.getIndex({ 10, 20, 30 }, 20)).to.equal(2)
		end)

		it('should return nil if not found', function()
			expect(Table.getIndex({ 1, 2, 3 }, 99)).to.equal(nil)
		end)

		it('should error if needle is nil', function()
			expect(function()
				Table.getIndex({ 1 }, nil :: any)
			end).to.throw()
		end)
	end)

	describe('Table.stringify', function()
		it('should return a string', function()
			local result = Table.stringify({ a = 1 })
			expect(type(result)).to.equal('string')
		end)

		it('should contain key names', function()
			local result = Table.stringify({ hello = 1 })
			expect(result:find('hello')).never.to.equal(nil)
		end)
	end)

	describe('Table.contains', function()
		it('should return true if value is in table', function()
			expect(Table.contains({ 1, 2, 3 }, 2)).to.equal(true)
		end)

		it('should return false if value is not in table', function()
			expect(Table.contains({ 1, 2, 3 }, 99)).to.equal(false)
		end)

		it('should handle empty table', function()
			expect(Table.contains({}, 1)).to.equal(false)
		end)
	end)

	describe('Table.overwrite', function()
		it('should overwrite target with source values', function()
			local target = { a = 1 } :: any
			Table.overwrite(target, { b = 2 })
			expect(target.b).to.equal(2)
		end)

		it('should return target', function()
			local target = {}
			local result = Table.overwrite(target, {})
			expect(result).to.equal(target)
		end)
	end)

	describe('Table.deepEquivalent', function()
		it('should return true for identical tables', function()
			expect(Table.deepEquivalent({ 1, 2, 3 }, { 1, 2, 3 })).to.equal(true)
		end)

		it('should return false for different tables', function()
			expect(Table.deepEquivalent({ 1 }, { 2 })).to.equal(false)
		end)

		it('should compare nested tables', function()
			expect(Table.deepEquivalent({ a = { b = 1 } }, { a = { b = 1 } })).to.equal(
				true
			)
			expect(Table.deepEquivalent({ a = { b = 1 } }, { a = { b = 2 } })).to.equal(
				false
			)
		end)

		it('should return true for same reference', function()
			local t = { 1, 2 }
			expect(Table.deepEquivalent(t, t)).to.equal(true)
		end)
	end)

	describe('Table.take', function()
		it('should take the first n elements', function()
			local result = Table.take({ 1, 2, 3, 4, 5 }, 3)
			expect(#result).to.equal(3)
			expect(result[1]).to.equal(1)
			expect(result[3]).to.equal(3)
		end)

		it('should take all if count exceeds length', function()
			local result = Table.take({ 1, 2 }, 10)
			expect(#result).to.equal(2)
		end)

		it('should handle count of 0', function()
			local result = Table.take({ 1, 2, 3 }, 0)
			expect(#result).to.equal(0)
		end)
	end)

	describe('Table.readonly', function()
		it('should freeze the table', function()
			local t = Table.readonly({ a = 1 })
			expect(table.isfrozen(t)).to.equal(true)
		end)

		it('should error when indexing nil key', function()
			local t = Table.readonly({}) :: any
			expect(function()
				local _ = t.nonexistent
			end).to.throw()
		end)
	end)

	describe('Table.deepReadonly', function()
		it('should freeze nested tables', function()
			local nested = { b = 2 }
			local t = Table.deepReadonly({ a = nested })
			expect(table.isfrozen(t)).to.equal(true)
		end)
	end)

	describe('Table.reduce', function()
		it('should reduce to a sum', function()
			local result = Table.reduce(
				{ 1, 2, 3, 4 },
				function(acc: number, val: { number })
					return acc + val :: any
				end,
				0
			)
			expect(result).to.equal(10)
		end)

		it('should use initial value', function()
			local result = Table.reduce({}, function(acc: number, val: { number })
				return acc + val :: any
			end, 42)
			expect(result).to.equal(42)
		end)
	end)

	describe('Table.map', function()
		it('should map values', function()
			local result = Table.map({ 1, 2, 3 }, function(v: number)
				return v * 2
			end)
			expect(result[1]).to.equal(2)
			expect(result[2]).to.equal(4)
			expect(result[3]).to.equal(6)
		end)

		it('should pass index to mapper', function()
			local result = Table.map({ 10, 20 }, function(_, i)
				return i
			end)
			expect(result[1]).to.equal(1)
			expect(result[2]).to.equal(2)
		end)

		it('should handle empty table', function()
			local result = Table.map({}, function(v)
				return v
			end)
			expect(#result).to.equal(0)
		end)
	end)

	describe('Table.filter', function()
		it('should filter values by predicate', function()
			local result = Table.filter({ 1, 2, 3, 4 }, function(v: number)
				return v % 2 == 0
			end)
			expect(#result).to.equal(2)
			expect(result[1]).to.equal(2)
			expect(result[2]).to.equal(4)
		end)

		it('should return empty if none match', function()
			local result = Table.filter({ 1, 3, 5 }, function(v: number)
				return v % 2 == 0
			end)
			expect(#result).to.equal(0)
		end)
	end)

	describe('Table.find', function()
		it('should return the first matching value and index', function()
			local val, idx = Table.find({ 10, 20, 30 }, function(v)
				return v == 20
			end)
			expect(val).to.equal(20)
			expect(idx).to.equal(2)
		end)

		it('should return nil if not found', function()
			local val, idx = Table.find({ 1, 2, 3 }, function(v)
				return v == 99
			end)
			expect(val).to.equal(nil)
			expect(idx).to.equal(nil)
		end)
	end)

	describe('Table.every', function()
		it('should return true if all match', function()
			expect(Table.every({ 2, 4, 6 }, function(v: number)
				return v % 2 == 0
			end)).to.equal(true)
		end)

		it('should return false if any don\'t match', function()
			expect(Table.every({ 2, 3, 6 }, function(v: number)
				return v % 2 == 0
			end)).to.equal(false)
		end)

		it('should return true for empty table', function()
			expect(Table.every({}, function()
				return false
			end)).to.equal(true)
		end)
	end)

	describe('Table.some', function()
		it('should return true if any match', function()
			expect(Table.some({ 1, 2, 3 }, function(v)
				return v == 2
			end)).to.equal(true)
		end)

		it('should return false if none match', function()
			expect(Table.some({ 1, 3, 5 }, function(v: number)
				return v % 2 == 0
			end)).to.equal(false)
		end)

		it('should return false for empty table', function()
			expect(Table.some({}, function()
				return true
			end)).to.equal(false)
		end)
	end)

	describe('Table.flat', function()
		it('should flatten one level', function()
			local result = Table.flat({ { 1, 2 }, { 3, 4 } })
			expect(#result).to.equal(4)
			expect(result[1]).to.equal(1)
			expect(result[4]).to.equal(4)
		end)

		it('should handle empty inner tables', function()
			local result = Table.flat({ {}, { 1 } })
			expect(#result).to.equal(1)
		end)
	end)

	describe('Table.flatMap', function()
		it('should map and flatten', function()
			local result = Table.flatMap({ 1, 2, 3 }, function(v: number)
				return { v, v * 2 }
			end)
			expect(#result).to.equal(6)
			expect(result[1]).to.equal(1)
			expect(result[2]).to.equal(2)
		end)
	end)

	describe('Table.shuffle', function()
		it('should return a table of the same length', function()
			local result = Table.shuffle({ 1, 2, 3, 4, 5 })
			expect(#result).to.equal(5)
		end)

		it('should not modify the original', function()
			local orig = { 1, 2, 3 }
			Table.shuffle(orig)
			expect(#orig).to.equal(3)
		end)

		it('should contain the same values', function()
			local orig = { 1, 2, 3 }
			local result = Table.shuffle(orig)
			expect(Table.contains(result, 1)).to.equal(true)
			expect(Table.contains(result, 2)).to.equal(true)
			expect(Table.contains(result, 3)).to.equal(true)
		end)
	end)

	describe('Table.sample', function()
		it('should return n items', function()
			local result = Table.sample({ 1, 2, 3, 4, 5 }, 3)
			expect(#result).to.equal(3)
		end)

		it('should return all if count exceeds length', function()
			local result = Table.sample({ 1, 2 }, 10)
			expect(#result).to.equal(2)
		end)
	end)

	describe('Table.isEmpty', function()
		it('should return true for empty table', function()
			expect(Table.isEmpty({})).to.equal(true)
		end)

		it('should return false for non-empty table', function()
			expect(Table.isEmpty({ 1 })).to.equal(false)
		end)

		it('should work with map tables', function()
			expect(Table.isEmpty({ a = 1 })).to.equal(false)
		end)
	end)

	describe('Table.swapRemove', function()
		it('should remove element at index', function()
			local t = { 1, 2, 3, 4 }
			local removed = Table.swapRemove(t, 2)
			expect(removed).to.equal(2)
			expect(#t).to.equal(3)
		end)

		it('should return nil for out of bounds index', function()
			local t = { 1, 2, 3 }
			expect(Table.swapRemove(t, 0)).to.equal(nil)
			expect(Table.swapRemove(t, 99)).to.equal(nil)
		end)
	end)

	describe('Table.swapRemoveFirstValue', function()
		it('should remove first occurrence of value', function()
			local t = { 1, 2, 3 }
			local removed = Table.swapRemoveFirstValue(t, 2)
			expect(removed).to.equal(true)
			expect(#t).to.equal(2)
		end)

		it('should return false if value not found', function()
			local t = { 1, 2, 3 }
			expect(Table.swapRemoveFirstValue(t, 99)).to.equal(false)
		end)
	end)

	describe('Table.assign', function()
		it('should assign source keys to target', function()
			local target = { a = 1 } :: any
			Table.assign(target, { b = 2 }, { c = 3 })
			expect(target.b).to.equal(2)
			expect(target.c).to.equal(3)
		end)

		it('should return target', function()
			local target = {}
			expect(Table.assign(target, {})).to.equal(target)
		end)
	end)

	describe('Table.extend', function()
		it('should extend target with source arrays', function()
			local target = { 1, 2 }
			Table.extend(target, { 3, 4 }, { 5 })
			expect(#target).to.equal(5)
		end)

		it('should return target', function()
			local target = {}
			expect(Table.extend(target, {})).to.equal(target)
		end)
	end)

	describe('Table.zip', function()
		it('should zip two arrays', function()
			local result = Table.zip({ 1, 2, 3 }, { 'a', 'b', 'c' } :: { any })
			expect(#result).to.equal(3)
			expect(result[1][1]).to.equal(1)
			expect(result[1][2]).to.equal('a')
		end)

		it('should truncate to shortest array', function()
			local result = Table.zip({ 1, 2, 3 }, { 'a', 'b' } :: { any })
			expect(#result).to.equal(2)
		end)
	end)

	describe('Table.truncate', function()
		it('should truncate to given length', function()
			local t = { 1, 2, 3, 4, 5 }
			Table.truncate(t, 3)
			expect(#t).to.equal(3)
		end)

		it('should return the table', function()
			local t = { 1, 2, 3 }
			expect(Table.truncate(t, 2)).to.equal(t)
		end)
	end)

	describe('Table.reconcile', function()
		it('should add keys from source', function()
			local target = { a = 1 } :: any
			Table.reconcile(target, { a = 1, b = 2 })
			expect(target.b).to.equal(2)
		end)

		it('should remove keys not in source', function()
			local target = { a = 1, b = 2 }
			Table.reconcile(target, { a = 1 })
			expect(target.b).to.equal(nil)
		end)
	end)

	describe('Table.sync', function()
		it('should sync target with source', function()
			local target = { a = 1, b = 2 } :: any
			Table.sync(target, { a = 99, c = 3 })
			expect(target.a).to.equal(99)
			expect(target.b).to.equal(nil)
			expect(target.c).to.equal(3)
		end)

		it('should recursively sync nested tables', function()
			local target = { nested = { a = 1, b = 2 } }
			Table.sync(target, { nested = { a = 99 } })
			expect(target.nested.a).to.equal(99)
			expect(target.nested.b).to.equal(nil)
		end)
	end)

	describe('Table.forEach', function()
		it('should call callback for each element', function()
			local count = 0
			Table.forEach({ 1, 2, 3 }, function()
				count += 1
			end)
			expect(count).to.equal(3)
		end)

		it('should pass value and index', function()
			local values = {}
			Table.forEach({ 10, 20 }, function(v, i)
				values[i] = v
			end)
			expect(values[1]).to.equal(10)
			expect(values[2]).to.equal(20)
		end)
	end)

	describe('Table.diff', function()
		it('should return changed keys', function()
			local result = Table.diff({ a = 1, b = 2 }, { a = 1, b = 99 })
			expect(result.a).to.equal(nil)
			expect(result.b).to.equal(99)
		end)

		it('should return new keys', function()
			local result = Table.diff({ a = 1 }, { a = 1, b = 2 })
			expect(result.b).to.equal(2)
		end)
	end)

	describe('Table.deepDiff', function()
		it('should detect nested changes', function()
			local result = Table.deepDiff({ a = { b = 1 } }, { a = { b = 99 } })
			expect(result.a).never.to.equal(nil)
		end)

		it('should not include unchanged keys', function()
			local result = Table.deepDiff({ a = 1, b = 2 }, { a = 1, b = 2 })
			expect(next(result)).to.equal(nil)
		end)
	end)

	describe('Table.filterMap', function()
		it('should filter map entries by predicate', function()
			local result = Table.filterMap({ a = 1, b = 2, c = 3 }, function(v)
				return v > 1
			end)
			expect(result.a).to.equal(nil)
			expect(result.b).to.equal(2)
			expect(result.c).to.equal(3)
		end)

		it('should pass key to predicate', function()
			local result = Table.filterMap({ a = 1, b = 2 }, function(_, k)
				return k == 'a'
			end)
			expect(result.a).to.equal(1)
			expect(result.b).to.equal(nil)
		end)
	end)
end
