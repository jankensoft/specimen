# defmodule Specimen.CreatorTest do
#   use ExUnit.Case, async: true

#   doctest Specimen.Creator

#   alias Specimen.Creator
#   alias UserFixture, as: User
#   alias UserFixtureFactory, as: Factory
#   alias Specimen.TestRepo, as: Repo

#   test "create_one/3 returns exactly one persisted struct" do
#     assert {user, _context} = Creator.create_one(User, Factory, repo: Repo, states: [:status])
#     assert %User{id: id} = user
#     assert %User{id: ^id, name: "Joe", lastname: "Schmoe", status: "active"} = Repo.get!(User, id)
#   end

#   test "create_one/3 invokes after_creating callback" do
#     assert {user, _context} = Creator.create_one(User, Factory, repo: Repo, states: [:status])
#     assert user.email == String.downcase("#{user.name}.#{user.lastname}@mail.com")
#   end

#   test "create_many/4 returns the specified amount of structs persisted" do
#     assert {[user], _context} =
#              Creator.create_many(User, Factory, 1, repo: Repo, states: [:status])

#     assert %User{id: id} = user
#     assert %User{id: ^id, name: "Joe", lastname: "Schmoe", status: "active"} = Repo.get!(User, id)
#   end

#   test "create_many/4 applies after_creating callback" do
#     assert {[user], _context} =
#              Creator.create_many(User, Factory, 1, repo: Repo, states: [:status])

#     assert user.email == String.downcase("#{user.name}.#{user.lastname}@mail.com")
#   end

#   # test "create_all/4 returns the specified amount of structs persisted" do
#   #   assert {[user], _context} =
#   #            Creator.create_all(User, Factory, 1,
#   #              repo: Repo,
#   #              states: [:status],
#   #              patch: &Map.drop(&1, [:__meta__, :__struct__, :id])
#   #            )

#   #   assert %User{id: id} = user
#   #   assert %User{id: ^id, name: "Joe", lastname: "Schmoe", status: "active"} = Repo.get!(User, id)
#   # end

#   # test "create_all/4 applies after_creating callback" do
#   #   assert {[user], _context} =
#   #            Creator.create_all(User, Factory, 1,
#   #              repo: Repo,
#   #              states: [:status],
#   #              patch: &Map.drop(&1, [:__meta__, :__struct__, :id])
#   #            )

#   #   assert user.email == String.downcase("#{user.name}.#{user.lastname}@mail.com")
#   # end
# end
