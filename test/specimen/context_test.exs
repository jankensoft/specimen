defmodule Specimen.ContextTest do
  use ExUnit.Case, async: true

  doctest Specimen.Context

  test "merge_states/1 returns all states as a unique map" do
    states = %{foo: %{bubbles: 1}, bar: %{bubbles: 2}}
    context = %Specimen.Context{states: states}
    attrs = Specimen.Context.merge_states(context)

    assert Map.has_key?(attrs, :bubbles)
  end

  test "merge_states/1 returns a list of states as unique maps" do
    contexts = [
      %Specimen.Context{states: %{foo: %{bubbles: 1}}},
      %Specimen.Context{states: %{bar: %{bubbles: 2}}}
    ]

    attrs = Specimen.Context.merge_states(contexts)

    assert Enum.all?(attrs, &Map.has_key?(&1, :bubbles))
  end

  test "get_struct/1 returns the context struct" do
    context = %Specimen.Context{struct: %{}}
    assert Specimen.Context.get_struct(context) == %{}
  end

  test "get_struct/1 returns the context structs" do
    contexts = [
      %Specimen.Context{struct: %{}},
      %Specimen.Context{struct: %{}}
    ]

    assert [%{}, %{}] = Specimen.Context.get_struct(contexts)
  end

  test "get_attrs/2 returns attrs for the given state key" do
    states = %{foo: %{bubbles: 1}}
    context = %Specimen.Context{states: states}
    attrs = Specimen.Context.get_attrs(context, :foo)

    assert Map.has_key?(attrs, :bubbles)
  end

  test "get_attrs/2 returns all attrs for the given state key" do
    contexts = [
      %Specimen.Context{states: %{foo: %{bubbles: 1}}},
      %Specimen.Context{states: %{foo: %{bubbles: 2}}}
    ]

    assert [%{bubbles: 1}, %{bubbles: 2}] = Specimen.Context.get_attrs(contexts, :foo)
  end

  test "get_attrs/3 returns attrs values for the given state key" do
    states = %{foo: %{bubbles: 1}}
    context = %Specimen.Context{states: states}

    assert 1 = Specimen.Context.get_attrs(context, :foo, :bubbles)
  end

  test "get_attrs/3 returns all attrs values for the given state key" do
    contexts = [
      %Specimen.Context{states: %{foo: %{bubbles: 1}}},
      %Specimen.Context{states: %{foo: %{bubbles: 2}}}
    ]

    assert [1, 2] = Specimen.Context.get_attrs(contexts, :foo, :bubbles)
  end
end
