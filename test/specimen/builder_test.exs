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
        |> Specimen.Context.get_struct()

      assert [%User{name: "Joe", lastname: "Schmoe"}] = structs
    end

    test "by passing the :states option" do
      structs =
        User
        |> Specimen.new()
        |> Specimen.Builder.make(Factory, 1, states: [:status])
        |> Specimen.Context.get_struct()

      assert [%User{status: "active"}] = structs
    end

    test "by passing the :overrides option" do
      structs =
        User
        |> Specimen.new()
        |> Specimen.Builder.make(Factory, 1, overrides: [name: "John"])
        |> Specimen.Context.get_struct()

      assert [%User{name: "John"}] = structs
    end

    test "by passing attrs to the :states option" do
      structs =
        User
        |> Specimen.new()
        |> Specimen.Builder.make(Factory, 1, states: [status: %{status: "banished"}])
        |> Specimen.Context.get_struct()

      assert [%User{status: "banished"}] = structs
    end
  end

  describe "create/4 returns the given amount of built structs" do
    test "by passing the only :repo option" do
      structs =
        User
        |> Specimen.new()
        |> Specimen.Builder.create(Factory, 1, repo: Repo)
        |> Specimen.Context.get_struct()

      assert [%User{name: "Joe", lastname: "Schmoe"}] = structs
    end

    test "by passing the :prefix option" do
      structs =
        User
        |> Specimen.new()
        |> Specimen.Builder.create(Factory, 1, prefix: "public", repo: Repo)
        |> Specimen.Context.get_struct()

      assert [%User{name: "Joe", lastname: "Schmoe"}] = structs
    end

    test "by passing the :states option" do
      structs =
        User
        |> Specimen.new()
        |> Specimen.Builder.create(Factory, 1, repo: Repo, states: [:status])
        |> Specimen.Context.get_struct()

      assert [%User{status: "active"}] = structs
    end

    test "by passing the :overrides option" do
      structs =
        User
        |> Specimen.new()
        |> Specimen.Builder.create(Factory, 1, repo: Repo, overrides: [name: "John"])
        |> Specimen.Context.get_struct()

      assert [%User{name: "John"}] = structs
    end
  end

  test "make/4 calls after_making callback" do
    structs =
      User
      |> Specimen.new()
      |> Specimen.Builder.make(Factory, 1)
      |> Specimen.Context.get_struct()

    assert [%User{age: age}] = structs
    assert age != nil
  end

  test "create/4 calls after_creating callback" do
    structs =
      User
      |> Specimen.new()
      |> Specimen.Builder.create(Factory, 1, repo: Repo)
      |> Specimen.Context.get_struct()

    assert [%User{name: name, lastname: lastname, email: email, age: age}] = structs
    assert email == String.downcase("#{name}.#{lastname}@mail.com")
    assert age != nil
  end

  test "create/4 actually persists the built struct" do
    %{id: id} =
      User
      |> Specimen.new()
      |> Specimen.Builder.create(Factory, 1, repo: Repo)
      |> Specimen.Context.get_struct()
      |> List.first()

    assert %User{id: ^id, name: "Joe", lastname: "Schmoe"} = Repo.get!(User, id)
  end

  describe "create_all/4 returns the specified amount of structs persisted" do
    test "by passing required options" do
      opts = [repo: Repo]

      %{id: id} =
        User
        |> Specimen.new()
        |> Specimen.Builder.create_all(Factory, 1, opts)
        |> Specimen.Context.get_struct()
        |> List.first()

      assert %User{id: ^id, name: "Joe", lastname: "Schmoe"} = Repo.get!(User, id)
    end

    test "by passing {:drop, fields} to the :patch option" do
      opts = [repo: Repo, patch: {:drop, [:__meta__, :__struct__, :id]}]

      %{id: id} =
        User
        |> Specimen.new()
        |> Specimen.Builder.create_all(Factory, 1, opts)
        |> Specimen.Context.get_struct()
        |> List.first()

      assert %User{id: ^id, name: "Joe", lastname: "Schmoe"} = Repo.get!(User, id)
    end

    test "by passing a function to the :patch option" do
      opts = [repo: Repo, patch: &Map.drop(&1, [:__meta__, :__struct__, :id])]

      %{id: id} =
        User
        |> Specimen.new()
        |> Specimen.Builder.create_all(Factory, 1, opts)
        |> Specimen.Context.get_struct()
        |> List.first()

      assert %User{id: ^id, name: "Joe", lastname: "Schmoe"} = Repo.get!(User, id)
    end

    test "by passing an invalid arg to the :patch option" do
      opts = [repo: Repo, patch: nil]

      assert_raise RuntimeError, "Invalid arg passed to option :patch", fn ->
        User
        |> Specimen.new()
        |> Specimen.Builder.create_all(Factory, 1, opts)
      end
    end
  end
end
