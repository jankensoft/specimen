defmodule Specimen.MakerTest do
  use ExUnit.Case, async: true

  doctest Specimen.Maker

  alias UserFixture, as: User
  alias UserFixtureFactory, as: Factory

  describe "make_one/3 returns exactly one built struct" do
    test "by passing the same options as Specimen.Builder.make/4" do
      struct =
        User
        |> Specimen.Maker.make_one(Factory, states: [:status], overrides: [name: "John"])
        |> Specimen.Context.get_struct()

      assert %User{name: "John", lastname: "Schmoe", status: "active"} = struct
    end

    test "by passing the :context option" do
      struct =
        User
        |> Specimen.Maker.make_one(Factory, context: %{age: 18})
        |> Specimen.Context.get_struct()

      assert %User{name: "Joe", lastname: "Schmoe", age: 18} = struct
    end
  end

  describe "make_many/4 returns the given amount of built structs" do
    test "by passing the same options as Specimen.Builder.make/4" do
      structs =
        User
        |> Specimen.Maker.make_many(Factory, 1, states: [:status], overrides: [name: "John"])
        |> Specimen.Context.get_structs()

      assert [%User{name: "John", lastname: "Schmoe", status: "active"}] = structs
    end

    test "by passing the :context option" do
      structs =
        User
        |> Specimen.Maker.make_many(Factory, 1, context: %{age: 18})
        |> Specimen.Context.get_structs()

      assert [%User{name: "Joe", lastname: "Schmoe", age: 18}] = structs
    end
  end
end
