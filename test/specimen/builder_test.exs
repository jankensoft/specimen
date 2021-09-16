defmodule Specimen.BuilderTest do
  use ExUnit.Case, async: true

  alias UserFixture, as: User
  alias UserFixtureFactory, as: Factory
  alias Specimen.Context

  doctest Specimen.Builder

  describe "make/4 returns the given amount of built structs" do
    test "without options" do
      structs =
        User
        |> Specimen.new()
        |> Specimen.Builder.make(Factory, 1)
        |> Context.get_structs()

      assert [%User{name: "Joe", lastname: "Schmoe"}] = structs
    end

    test "with states" do
      structs =
        User
        |> Specimen.new()
        |> Specimen.Builder.make(Factory, 1, states: [:status])
        |> Context.get_structs()

      assert [%User{status: "active"}] = structs
    end

    test "with overrides" do
      structs =
        User
        |> Specimen.new()
        |> Specimen.Builder.make(Factory, 1, overrides: [name: "John"])
        |> Context.get_structs()

      assert [%User{name: "John"}] = structs
    end
  end

  describe "create/4 returns the given amount of built structs" do
    alias Specimen.TestRepo, as: Repo

    test "with repo" do
      structs =
        User
        |> Specimen.new()
        |> Specimen.Builder.create(Factory, 1, repo: Repo)
        |> Context.get_structs()

      assert [%User{name: "Joe", lastname: "Schmoe"}] = structs
    end

    test "with prefix" do
      structs =
        User
        |> Specimen.new()
        |> Specimen.Builder.create(Factory, 1, prefix: "public", repo: Repo)
        |> Context.get_structs()

      assert [%User{name: "Joe", lastname: "Schmoe"}] = structs
    end

    test "with states" do
      structs =
        User
        |> Specimen.new()
        |> Specimen.Builder.create(Factory, 1, repo: Repo, states: [:status])
        |> Context.get_structs()

      assert [%User{status: "active"}] = structs
    end

    test "with overrides" do
      structs =
        User
        |> Specimen.new()
        |> Specimen.Builder.create(Factory, 1, repo: Repo, overrides: [name: "John"])
        |> Context.get_structs()

      assert [%User{name: "John"}] = structs
    end
  end
end
