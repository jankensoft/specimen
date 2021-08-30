# defmodule Specimen.HasFactoryTest do
#   use ExUnit.Case, async: true

#   doctest Specimen.Maker

#   alias UserFixture, as: User

#   describe "using Specimen.HasFactory" do
#     test "exposes a Factory.make_one/1 function inside the module" do
#       assert {user, _context} = User.Factory.make_one()
#       assert %User{} = user
#     end

#     test "exposes a Factory.make_many/2 function inside the module" do
#       assert {users, _context} = User.Factory.make_many(2)
#       assert [%User{}, %User{}] = users
#     end
#   end
# end
