# Specimen

🏭 A reasonable factory implementation structure for elixir applications.  

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `specimen` to your list of dependencies in `mix.exs` or pulling the dependencies directly from Github:

```elixir
def deps do
  [
    {:specimen, github: "jankensoft/specimen"}
  ]
end
```

## Basic Usage

```elixir
defmodule UserFactory do
  use Specimen.Factory, module: User

  def build(specimen) do
    specimen
    |> Specimen.include(:name, "John")
    |> Specimen.include(:age, 42)
  end

  def state(:lastname, %User{} = user) do
    Map.put(user, :lastname, "Doe")
  end
end
```

**Making and inserting just one user**

```elixir
UserFactory.make_one()
#=> %Specimen.Context{struct: %User{}}

UserFactory.create_one()
#=> %Specimen.Context{struct: %User{}}
```

**Making and inserting a specific amount of users**

```elixir
UserFactory.make_many(10)
#=> [%Specimen.Context{struct: %User{}}, ...]

UserFactory.create_many(10)
#=> [%Specimen.Context{struct: %User{}}, ...]
```

**Making and inserting a user with lastname**

```elixir
UserFactory.make_one([:lastname])
#=> %Specimen.Context{struct: %User{}}

UserFactory.create_one([:lastname])
#=> %Specimen.Context{struct: %User{}}
```

**Retrieving data from the building context**

```elixir
Specimen.Context.get_struct(UserFactory.create_one()) 
#=> %User{}

Specimen.Context.get_struct(UserFactory.create_many(10)) 
#=> [%User{}, ...]
```

**Calling factories from struct modules**

```elixir
defmodule User do
  use Specimen.HasFactory, UserFactory
  defstruct [:name, :surname, :age]
end
```

```elixir
User.Factory.make_one()
User.Factory.make_many(10)
```

## TODO List

- [ ] Add support for more Ecto types (UUID, embeds, etc...)
- [ ] Allow configuration of Repo globally through application settings
- [ ] Allow extension of custom types through external implementations (specific domains)
- [ ] See if we can enforce that a non-empty factory only builds items for the specified module
- [ ] Take in consideration excluded and included fields before using `Specimen.fill/1`
- [ ] Allow the configuration of default states to call per factory
- [ ] Add support to sequences (sequencing values)
- [ ] Add `before_create` callback to allow factories to pre-configure how to patch entries beforehand
- [ ] Add `before_make` callback to allow factories to pre-configure how to patch items beforehand