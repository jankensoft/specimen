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
        |> Specimen.Creator.create_one(Factory,
          repo: Repo,
          states: [:status],
          overrides: [name: "John"]
        )
        |> Specimen.Context.get_struct()

      assert %User{name: "John", lastname: "Schmoe", status: "active"} = struct
    end

    test "by passing the :params option" do
      struct =
        User
        |> Specimen.Creator.create_one(Factory, repo: Repo, params: %{age: 18})
        |> Specimen.Context.get_struct()

      assert %User{name: "Joe", lastname: "Schmoe", age: 18} = struct
    end
  end

  describe "create_many/4 returns the given amount of built structs" do
    test "by passing the same options as Specimen.Builder.create/4" do
      structs =
        User
        |> Specimen.Creator.create_many(Factory, 1,
          repo: Repo,
          states: [:status],
          overrides: [name: "John"]
        )
        |> Specimen.Context.get_structs()

      assert [%User{name: "John", lastname: "Schmoe", status: "active"}] = structs
    end

    test "by passing the :params option" do
      structs =
        User
        |> Specimen.Creator.create_many(Factory, 1, repo: Repo, params: %{age: 18})
        |> Specimen.Context.get_structs()

      assert [%User{name: "Joe", lastname: "Schmoe", age: 18}] = structs
    end
  end

  describe "create_all/4 returns the given amount of built structs" do
    test "by passing the same options as Specimen.Builder.create_all/4" do
      opts = [
        repo: Repo,
        states: [:status],
        overrides: [name: "John"]
      ]

      structs =
        User
        |> Specimen.Creator.create_all(Factory, 1, opts)
        |> Specimen.Context.get_structs()

      assert [%User{name: "John", lastname: "Schmoe", status: "active"}] = structs
    end

    test "by passing the :params option" do
      opts = [
        repo: Repo,
        params: %{age: 18}
      ]

      structs =
        User
        |> Specimen.Creator.create_all(Factory, 1, opts)
        |> Specimen.Context.get_structs()

      assert [%User{name: "Joe", lastname: "Schmoe", age: 18}] = structs
    end
  end
end
