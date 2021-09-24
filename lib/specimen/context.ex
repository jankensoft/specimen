defmodule Specimen.Context do
  alias __MODULE__

  defstruct [:struct, :states]

  def merge_states(%Context{states: states}) do
    Enum.reduce(states, %{}, fn {_, attrs}, acc -> Map.merge(acc, attrs) end)
  end

  def merge_states(contexts) when is_list(contexts) do
    Enum.map(contexts, &merge_states/1)
  end

  def get_struct(%Context{struct: struct}), do: struct

  def get_struct(contexts) when is_list(contexts) do
    Enum.map(contexts, &get_struct/1)
  end

  def get_attrs(%Context{states: states}, state), do: Map.get(states, state)

  def get_attrs(contexts, state) when is_list(contexts) do
    Enum.map(contexts, &get_attrs(&1, state))
  end

  def get_attrs(%Context{} = context, state, key) do
    context
    |> get_attrs(state)
    |> Map.get(key)
  end

  def get_attrs(contexts, state, key) when is_list(contexts) do
    Enum.map(contexts, &get_attrs(&1, state, key))
  end
end
