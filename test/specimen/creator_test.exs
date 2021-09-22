defmodule Specimen.CreatorTest do
  use ExUnit.Case, async: true

  doctest Specimen.Creator

  alias UserFixture, as: User
  alias UserFixtureFactory, as: Factory
  alias Specimen.TestRepo, as: Repo

  describe "create_one/3 returns exactly one built struct" do
    test "by passing the same options as Specimen.Builder.create/4" do
      struct =
        User
        |> Specimen.Creator.create_one(Factory, repo: Repo, states: [:status], overrides: [name: "John"])
        |> Specimen.Context.get_struct()

      assert %User{name: "John", lastname: "Schmoe", status: "active"} = struct
    end

    test "by passing the :context option" do
      struct =
        User
        |> Specimen.Creator.create_one(Factory, repo: Repo, context: %{age: 18})
        |> Specimen.Context.get_struct()

      assert %User{name: "Joe", lastname: "Schmoe", age: 18} = struct
    end
  end

  describe "create_many/4 returns the given amount of built structs" do
    test "by passing the same options as Specimen.Builder.create/4" do
      structs =
        User
        |> Specimen.Creator.create_many(Factory, 1, repo: Repo, states: [:status], overrides: [name: "John"])
        |> Specimen.Context.get_structs()

      assert [%User{name: "John", lastname: "Schmoe", status: "active"}] = structs
    end

    test "by passing the :context option" do
      structs =
        User
        |> Specimen.Creator.create_many(Factory, 1, repo: Repo, context: %{age: 18})
        |> Specimen.Context.get_structs()

      assert [%User{name: "Joe", lastname: "Schmoe", age: 18}] = structs
    end
  end

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
end
