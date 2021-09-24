defmodule Specimen.FactoryTest do
  use ExUnit.Case, async: true

  alias UserFixture, as: User
  alias UserFixtureFactory, as: Factory
#   alias Specimen.TestRepo, as: Repo

test "state/4 allows the return of a tuple {struct, attrs}" do
  context = Factory.make_one(states: [password: "1234"])
  assert Specimen.Context.get_attrs(context, :password, :encoding) == :base64
end

test "each state should have isolated attrs in Specimen.Context" do
  context = Factory.make_one(states: [:id, password: "1234"])
  assert Specimen.Context.get_attrs(context, :password, :encoding) == :base64
end

#   defmodule OtherModule, do: defstruct([:name])
#   defmodule EmptyFactory, do: use(Specimen.Factory, module: User)

#   test "build/2 on an empty factory raises when using a different module" do
#     specimen = Specimen.new(OtherModule)

#     message = "This factory can't be used to build Specimen.FactoryTest.OtherModule"

#     assert_raise RuntimeError, message, fn -> EmptyFactory.build(specimen) end
#   end

#   test "make_one/1 is exposed in the factory" do
#     assert {user, _context} = Factory.make_one(states: [:status])
#     assert %User{name: "Joe", lastname: "Schmoe", status: "active"} = user
#   end

#   test "make_many/2 is exposed in the factory" do
#     assert {[user], _context} = Factory.make_many(1, states: [:status])
#     assert %User{name: "Joe", lastname: "Schmoe", status: "active"} = user
#   end

#   test "create_one/1 is exposed in the factory" do
#     assert {user, _context} = Factory.create_one(repo: Repo, states: [:status])
#     assert %User{id: id} = user
#     assert %User{id: ^id, name: "Joe", lastname: "Schmoe", status: "active"} = Repo.get!(User, id)
#   end

#   test "create_many/2 is exposed in the factory" do
#     assert {[user], _context} = Factory.create_many(1, repo: Repo, states: [:status])
#     assert %User{id: id} = user
#     assert %User{id: ^id, name: "Joe", lastname: "Schmoe", status: "active"} = Repo.get!(User, id)
#   end

#   # test "create_all/2 is exposed in the factory" do
#   #   assert {[user], _context} =
#   #            Factory.create_all(1,
#   #              repo: Repo,
#   #              states: [:status],
#   #              patch: &Map.drop(&1, [:__meta__, :__struct__, :id])
#   #            )

#   #   assert %User{id: id} = user
#   #   assert %User{id: ^id, name: "Joe", lastname: "Schmoe", status: "active"} = Repo.get!(User, id)
#   # end

#   test "factory accepts repo configuration" do
#     defmodule UserFactoryWithRepoOption, do: use(Specimen.Factory, module: User, repo: Repo)

#     assert {user, _context} = UserFactoryWithRepoOption.create_one(states: [:status])
#     assert %User{id: id} = user
#     assert %User{id: ^id} = Repo.get!(User, id)

#     assert {[user], _context} = UserFactoryWithRepoOption.create_many(1, states: [:status])
#     assert %User{} = user
#     assert %User{id: ^id} = Repo.get!(User, id)
#   end

#   test "factory accepts prefix configuration" do
#     defmodule UserFactoryWithPrefixOption,
#       do: use(Specimen.Factory, module: User, repo: Repo, prefix: "foo")

#     assert_raise Postgrex.Error, ~r/ERROR 42P01 \(undefined_table\) relation "foo.users"/, fn ->
#       UserFactoryWithPrefixOption.create_one(states: [:status])
#     end

#     assert_raise Postgrex.Error, ~r/ERROR 42P01 \(undefined_table\) relation "foo.users"/, fn ->
#       UserFactoryWithPrefixOption.create_many(1, states: [:status])
#     end
#   end

#   test "function options have priority over factory options" do
#     defmodule UserFactoryWithOptions,
#       do: use(Specimen.Factory, module: User, repo: Repo, prefix: "foo")

#     assert_raise Postgrex.Error, ~r/ERROR 42P01 \(undefined_table\) relation "bar.users"/, fn ->
#       UserFactoryWithOptions.create_one(prefix: "bar", states: [:status])
#     end

#     assert_raise Postgrex.Error, ~r/ERROR 42P01 \(undefined_table\) relation "bar.users"/, fn ->
#       UserFactoryWithOptions.create_many(1, prefix: "bar", states: [:status])
#     end
#   end

#   test "context option is properly passed down to factory functions" do
#     context = [name: "Jane", status: "inactive", age: 42, email: "jane@mail.com"]

#     assert {user, _context} = Factory.make_one(context: context, states: [:status])
#     assert %User{name: "Jane", status: "inactive", age: 42} = user

#     assert {[user], _context} = Factory.make_many(1, context: context, states: [:status])
#     assert %User{name: "Jane", status: "inactive", age: 42} = user

#     assert {user, _context} = Factory.create_one(context: context, repo: Repo, states: [:status])
#     assert %User{email: "jane@mail.com"} = user

#     assert {[user], _context} =
#              Factory.create_many(1, context: context, repo: Repo, states: [:status])

#     assert %User{email: "jane@mail.com"} = user
#   end

#   test "factory exposes build context from specimen context" do
#     assert {user, %{manual_sequence: true}} = Factory.make_one(context: [id: 1], states: [:id])
#     assert %User{id: 1} = user

#     assert {[user], [%{manual_sequence: true}]} =
#              Factory.make_many(1, context: [id: 2], states: [:id])

#     assert %User{id: 2} = user
#   end

#   test "allows fields to be overriden dynamically" do
#     assert {user, _context} = Factory.make_one(states: [:status], overrides: [status: "active"])
#     assert %User{status: "active"} = user

#     assert {[user], _context} = Factory.make_many(1, states: [:status], overrides: [status: "active"])
#     assert %User{status: "active"} = user
#   end
end
