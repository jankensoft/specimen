defmodule Specimen.FactoryTest do
  use ExUnit.Case, async: true

  doctest Specimen.Factory

  alias UserFixture, as: User
  alias UserFixtureFactory, as: Factory
  alias Specimen.TestRepo, as: Repo

  test "state/4 allows the return of a tuple {struct, attrs}" do
    context = Factory.make_one(states: [password: "1234"])
    assert Specimen.Context.get_attrs(context, :password, :encoding) == :base64
  end

  test "each state should have isolated attrs in Specimen.Context" do
    context = Factory.make_one(states: [:id, password: "1234"])
    assert Specimen.Context.get_attrs(context, :password, :encoding) == :base64
  end

  test "make_one/1 is exposed in the factory" do
    context = Factory.make_one(states: [:status])

    assert %User{name: "Joe", lastname: "Schmoe", status: "active"} =
             Specimen.Context.get_struct(context)
  end

  test "make_many/2 is exposed in the factory" do
    contexts = Factory.make_many(1, states: [:status])

    assert [%User{name: "Joe", lastname: "Schmoe", status: "active"}] =
             Specimen.Context.get_struct(contexts)
  end

  test "create_one/1 is exposed in the factory" do
    context = Factory.create_one(repo: Repo, states: [:status])
    %User{id: id} = Specimen.Context.get_struct(context)
    assert %User{id: ^id, name: "Joe", lastname: "Schmoe", status: "active"} = Repo.get!(User, id)
  end

  test "create_many/2 is exposed in the factory" do
    contexts = Factory.create_many(1, repo: Repo, states: [:status])
    [%User{id: id}] = Specimen.Context.get_struct(contexts)
    assert %User{id: ^id, name: "Joe", lastname: "Schmoe", status: "active"} = Repo.get!(User, id)
  end

  test "create_all/2 is exposed in the factory" do
    contexts = Factory.create_all(1, repo: Repo, states: [:status])
    [%User{id: id}] = Specimen.Context.get_struct(contexts)
    assert %User{id: ^id, name: "Joe", lastname: "Schmoe", status: "active"} = Repo.get!(User, id)
  end

  test "factory accepts repo configuration" do
    defmodule UserFactoryWithRepoOption, do: use(Specimen.Factory, module: User, repo: Repo)

    context = UserFactoryWithRepoOption.create_one()
    %User{id: id} = Specimen.Context.get_struct(context)
    assert %User{id: ^id} = Repo.get!(User, id)

    contexts = UserFactoryWithRepoOption.create_many(1)
    [%User{id: id}] = Specimen.Context.get_struct(contexts)
    assert %User{id: ^id} = Repo.get!(User, id)
  end

  test "factory accepts prefix configuration" do
    defmodule UserFactoryWithPrefixOption,
      do: use(Specimen.Factory, module: User, repo: Repo, prefix: "foo")

    assert_raise Postgrex.Error, ~r/ERROR 42P01 \(undefined_table\) relation "foo.users"/, fn ->
      UserFactoryWithPrefixOption.create_one()
    end

    assert_raise Postgrex.Error, ~r/ERROR 42P01 \(undefined_table\) relation "foo.users"/, fn ->
      UserFactoryWithPrefixOption.create_many(1)
    end
  end

  test "function options have priority over factory options" do
    defmodule UserFactoryWithOptions,
      do: use(Specimen.Factory, module: User, repo: Repo, prefix: "foo")

    assert_raise Postgrex.Error, ~r/ERROR 42P01 \(undefined_table\) relation "bar.users"/, fn ->
      UserFactoryWithOptions.create_one(prefix: "bar")
    end

    assert_raise Postgrex.Error, ~r/ERROR 42P01 \(undefined_table\) relation "bar.users"/, fn ->
      UserFactoryWithOptions.create_many(1, prefix: "bar")
    end
  end

  test "params option is properly passed down to factory functions" do
    params = [status: "inactive", age: 42, email: "test@mail.com"]

    context = Factory.make_one(params: params, states: [:status])
    assert %User{status: "inactive", age: 42} = Specimen.Context.get_struct(context)

    contexts = Factory.make_many(1, params: params, states: [:status])
    assert [%User{status: "inactive", age: 42}] = Specimen.Context.get_struct(contexts)

    context = Factory.create_one(repo: Repo, params: params, states: [:status])

    assert %User{status: "inactive", age: 42, email: "test@mail.com"} =
             Specimen.Context.get_struct(context)

    contexts = Factory.create_many(1, repo: Repo, params: params, states: [:status])

    assert [%User{status: "inactive", age: 42, email: "test@mail.com"}] =
             Specimen.Context.get_struct(contexts)
  end

  test "factory exposes build attrs from specimen params" do
    context = Factory.make_one(params: [id: 1], states: [:id])
    assert Specimen.Context.get_attrs(context, :id, :manual_sequence) == true

    contexts = Factory.make_many(1, params: [id: 2], states: [:id])
    assert Specimen.Context.get_attrs(contexts, :id, :manual_sequence) == [true]
  end

  test "allows fields to be overriden dynamically" do
    context = Factory.make_one(states: [:status], overrides: [status: "inactive"])
    assert %User{status: "inactive"} = Specimen.Context.get_struct(context)

    contexts = Factory.make_many(1, states: [:status], overrides: [status: "inactive"])
    assert [%User{status: "inactive"}] = Specimen.Context.get_struct(contexts)
  end

  test "build/2 on an empty factory raises when using a different module" do
    defmodule OtherModule, do: defstruct([:name])
    defmodule EmptyFactory, do: use(Specimen.Factory, module: User)

    specimen = Specimen.new(OtherModule)

    message = "This factory can't be used to build Specimen.FactoryTest.OtherModule"

    assert_raise RuntimeError, message, fn -> EmptyFactory.build(specimen) end
  end
end
