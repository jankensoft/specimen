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

  def get_state(%Context{states: states}, key) do
    states
    |> get_context()
    |> Map.get(key)
  end

  def get_states(contexts, key) when is_list(contexts) do
    Enum.map(contexts, &get_state(&1, key))
  end

  def get_state(%Context{states: states}, key1, key2) do
    states
    |> get_state(key1)
    |> Map.get(key2)
  end

  def get_states(contexts, key1, key2) when is_list(contexts) do
    Enum.map(contexts, &get_state(&1, key1, key2))
  end
end
