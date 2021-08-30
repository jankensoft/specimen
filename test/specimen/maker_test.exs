# defmodule Specimen.MakerTest do
#   use ExUnit.Case, async: true

#   doctest Specimen.Maker

#   alias Specimen.Maker
#   alias UserFixture, as: User
#   alias UserFixtureFactory, as: Factory

#   test "make_one/3 returns exactly one built struct" do
#     assert {user, _context} = Maker.make_one(User, Factory, states: [:status])
#     assert %User{name: "Joe", lastname: "Schmoe", status: "active"} = user
#   end

#   test "make_many/4 returns the specified amount of structs built" do
#     assert {[user], _context} = Maker.make_many(User, Factory, 1, states: [:status])
#     assert %User{name: "Joe", lastname: "Schmoe", status: "active"} = user
#   end

#   test "make_many/4 returns distinct results" do
#     assert {[first, second], _context} = Maker.make_many(User, Factory, 2)
#     assert first != second
#   end
# end
