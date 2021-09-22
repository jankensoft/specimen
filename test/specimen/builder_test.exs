defmodule Specimen.BuilderTest do
  use ExUnit.Case, async: true

  alias UserFixture, as: User
  alias UserFixtureFactory, as: Factory
  alias Specimen.TestRepo, as: Repo

  doctest Specimen.Builder

  describe "make/4 returns the given amount of built structs" do
    test "by passing no options" do
      structs =
        User
        |> Specimen.new()
        |> Specimen.Builder.make(Factory, 1)
        |> Specimen.Context.get_structs()

      assert [%User{name: "Joe", lastname: "Schmoe"}] = structs
    end

    test "by passing the :states option" do
      structs =
        User
        |> Specimen.new()
        |> Specimen.Builder.make(Factory, 1, states: [:status])
        |> Specimen.Context.get_structs()

      assert [%User{status: "active"}] = structs
    end

    test "by passing the :overrides option" do
      structs =
        User
        |> Specimen.new()
        |> Specimen.Builder.make(Factory, 1, overrides: [name: "John"])
        |> Specimen.Context.get_structs()

      assert [%User{name: "John"}] = structs
    end
  end

  describe "create/4 returns the given amount of built structs" do
    test "by passing the only :repo option" do
      structs =
        User
        |> Specimen.new()
        |> Specimen.Builder.create(Factory, 1, repo: Repo)
        |> Specimen.Context.get_structs()

      assert [%User{name: "Joe", lastname: "Schmoe"}] = structs
    end

    test "by passing the :prefix option" do
      structs =
        User
        |> Specimen.new()
        |> Specimen.Builder.create(Factory, 1, prefix: "public", repo: Repo)
        |> Specimen.Context.get_structs()

      assert [%User{name: "Joe", lastname: "Schmoe"}] = structs
    end

    test "by passing the :states option" do
      structs =
        User
        |> Specimen.new()
        |> Specimen.Builder.create(Factory, 1, repo: Repo, states: [:status])
        |> Specimen.Context.get_structs()

      assert [%User{status: "active"}] = structs
    end

    test "by passing the :overrides option" do
      structs =
        User
        |> Specimen.new()
        |> Specimen.Builder.create(Factory, 1, repo: Repo, overrides: [name: "John"])
        |> Specimen.Context.get_structs()

      assert [%User{name: "John"}] = structs
    end
  end

  test "make/4 calls after_making callback" do
    structs =
      User
      |> Specimen.new()
      |> Specimen.Builder.make(Factory, 1)
      |> Specimen.Context.get_structs()

    assert [%User{age: age}] = structs
    assert age != nil
  end

  test "create/4 calls after_creating callback" do
    structs =
      User
      |> Specimen.new()
      |> Specimen.Builder.create(Factory, 1, repo: Repo)
      |> Specimen.Context.get_structs()

    assert [%User{name: name, lastname: lastname, email: email, age: age}] = structs
    assert email == String.downcase("#{name}.#{lastname}@mail.com")
    assert age != nil
  end

  test "create/4 actually persists the built struct" do
    %{id: id} =
      User
      |> Specimen.new()
      |> Specimen.Builder.create(Factory, 1, repo: Repo)
      |> Specimen.Context.get_structs()
      |> List.first()

    assert %User{id: ^id, name: "Joe", lastname: "Schmoe"} = Repo.get!(User, id)
  end
end
