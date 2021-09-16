defmodule SpecimenTest do
  use ExUnit.Case, async: true

  doctest Specimen

  alias UserFixture, as: User
  alias Specimen.Context

  describe "specimen" do
    test "new/1 creates a clean Specimen" do
      specimen = Specimen.new(User)

      assert %Specimen{module: User, struct: %User{}} = specimen
      assert %Context{struct: %User{name: "John", lastname: "Doe"}} = Specimen.to_struct(specimen)
    end

    test "include/2 adds a field without value" do
      specimen =
        User
        |> Specimen.new()
        |> Specimen.include(:name)

      assert %Specimen{includes: [:name], funs: []} = specimen
      assert %Context{struct: %User{name: "John"}} = Specimen.to_struct(specimen)
    end

    test "include/3 adds a field with value" do
      specimen =
        User
        |> Specimen.new()
        |> Specimen.include(:name, "Joe")
        |> Specimen.include(:lastname, "Schmoe")

      assert %Specimen{includes: [:lastname, :name], funs: [_ | _]} = specimen
      assert %Context{struct: %User{name: "Joe", lastname: "Schmoe"}} = Specimen.to_struct(specimen)
    end

    test "vary/3 adds a field with a random value from a given list" do
      names = ~w"Joe Jerry James"

      specimen =
        User
        |> Specimen.new()
        |> Specimen.vary(:name, names)

      assert %Specimen{includes: [:name], funs: [_]} = specimen
      assert %Context{struct: %User{name: name}} = Specimen.to_struct(specimen)
      assert name in names
    end

    test "exclude/2 nilifies a field" do
      specimen =
        User
        |> Specimen.new()
        |> Specimen.exclude(:lastname)

      assert %Specimen{excludes: [:lastname], funs: []} = specimen
      assert %Context{struct: %User{name: "John", lastname: nil}} = Specimen.to_struct(specimen)
    end

    test "transform/3 changes a field" do
      specimen =
        User
        |> Specimen.new()
        |> Specimen.transform(&Map.put(&1, :name, "Joe"))

      assert %Specimen{includes: [], excludes: [], funs: [_ | _]} = specimen
      assert %Context{struct: %User{name: "Joe", lastname: "Doe"}} = Specimen.to_struct(specimen)
    end

    test "transform/3 changes a field with tag" do
      specimen =
        User
        |> Specimen.new()
        |> Specimen.transform(&Map.put(&1, :name, "Joe"), :name)

      assert %Specimen{includes: [], excludes: [], funs: [{:name, _}]} = specimen
      assert %Context{struct: %User{name: "Joe", lastname: "Doe"}} = Specimen.to_struct(specimen)
    end

    test "fill/1 adds random values to struct fields" do
      specimen =
        User
        |> Specimen.new()
        |> Specimen.fill()

      assert %Specimen{includes: [_ | _], excludes: [], funs: [_ | _]} = specimen
      assert %Context{struct: %User{}} = Specimen.to_struct(specimen)
    end

    test "override/2 adds a value to be overriden" do
      specimen =
        User
        |> Specimen.new()
        |> Specimen.override(:name, "Joe")
        |> Specimen.include(:name, "John")

      assert %Specimen{overrides: %{name: "Joe"}} = specimen
      assert %Context{struct: %User{name: "Joe"}} = Specimen.to_struct(specimen)
    end

  end
end
