defmodule Specimen.Context do
  alias __MODULE__

  defstruct [:struct, :states]

  def get_context(%Context{states: states}) do
    Enum.reduce(states, %{}, &Map.merge/2)
  end

  def get_contexts(contexts) when is_list(contexts) do
    Enum.map(contexts, &get_context/1)
  end

  def get_struct(%Context{struct: struct}) do
    struct
  end

  def get_structs(contexts) when is_list(contexts) do
    Enum.map(contexts, &get_struct/1)
  end

  def get_attr(%Context{states: states}, key) do
    states
    |> Map.get(key)
  end

  def get_attrs(contexts, key) when is_list(contexts) do
    Enum.map(contexts, &get_attr(&1, key))
  end

  def get_attr(context, key1, key2) do
    context
    |> get_attr(key1)
    |> Map.get(key2)
  end

  def get_attrs(contexts, key1, key2) when is_list(contexts) do
    Enum.map(contexts, &get_attr(&1, key1, key2))
  end
end
