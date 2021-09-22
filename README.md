# Specimen

A better (sane) default factory implementation  

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `specimen` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:specimen, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/specimen](https://hexdocs.pm/specimen).

## Basic Usage

Define a factory file with configuration and optional states:

```elixir
defmodule UserFactory do
  use Specimen.Factory, module: User

  def build(specimen) do
    Specimen.include(specimen, :name, "John")
  end

  def state(:surname, %User{} = user) do
    Map.put(user, :surname, "Doe")
  end

  def after_making(%User{} = user) do
    Map.put(user, :age, 42)
  end  
end
```

And then:

```elixir
# Make just one user
{%User{}, _context} = UserFactory.make_one()

# Make the specified amount of users
{users, _contexts} = UserFactory.make_many(10)

# Make users by including specific states
{%User{surname: "Doe"}, _context} = UserFactory.make_one([:surname])
```

Call it directly from your struct/ schema modules:

```elixir
defmodule User do
  use Specimen.HasFactory, UserFactory
  defstruct [:name, :surname, :age]
end
```

```elixir
{user, _} = User.Factory.make_one()
{users, _} = User.Factory.make_many(10)
```

## TODO List

- [x] Expose `create_one` and `create_many` implementations on factories
- [ ] Add support for more Ecto types (UUID, embeds, etc...)
- [ ] Allow configuration of Repo globally through application settings
- [x] Allow configuration of Repo for each factory individually
- [ ] Allow extension of custom types through external implementations (specific domains)
- [ ] See if we can enforce that a non-empty factory only builds items for the specified module
- [ ] Take in consideration excluded and included fields before using `Specimen.fill/1`
- [ ] Allow the configuration of default states to call per factory
- [x] Allow passing attributes / context through function calls (use-case: override default factory definitions)
- [x] Return creation context along with created items (use-case: access values created by inner factory definitions)
- [ ] Add support to sequences (sequencing values)
- [x] Add support to vary from a given list of values (use-case: generate distinct values from a given list, eg: user roles)
- [x] Rename `create_many` to `create_all` for performance usages and make `create_many` rely on `create_one` the same way `make_many` relies on `make_one`
  - [x] Allow user to pass a function to patch structs into entries so `create_all` can use `Repo.insert_all` properly (right now we just remove some fields and hope everything works, but each user might have a different need).
- [ ] Check if grouping individual contexts by state can facilitate the return (eg: [state_context_1: %{}, state_context_2: %{}]).
This would allow us to use multiple contexts that return similar states (keys) without mixing/ merging the result into a single map.
- [ ] Add `before_create` callback to allow factories to pre-configure how to patch entries beforehand
- [ ] Add `before_make` callback to allow factories to pre-configure how to patch items beforehand
- [x] Add `:override` option that allows the user to replace fields dynamically without having to hardcode optional code inside `after_making` and `after_creating`
- [x] Merge `Specimen.Creator` and `Specimen.Maker` functions into `Specimen.Build` and consider the presence of a `:repo` option as a request to insert the entries (this should only impact Specimen's inner API, the public factory API will remain the same). This will be necessary because of the amount of duplicated tests for similar cases we are developing into.
