defmodule Specimen.Builder do
  @moduledoc """
  The module responsible for building Specimens given the specified constraints.
  This module is mainly used internaly by `Specimen.Maker` and `Specimen.Creator`.
  """

  @doc """
  Makes structs for a given `Specimen` as specified by the factory.

  ## Options

  - `:states` - A list of states to be applied to the item.
  - `:overrides` - A map or keyword list to override the struct's field.
  """
  def make(%Specimen{} = specimen, factory, count, opts \\ []) do
    after_making = fn %{struct: struct} = context ->
      %{context | struct: factory.after_making(struct, specimen.params)}
    end

    specimen
    |> build(factory, count, opts)
    |> Enum.map(&after_making.(&1))
  end

  @doc """
  Creates structs for a given `Specimen` as specified by the factory.

  ## Options
  Accepts the same options as `Specimen.Builder.make/4` in addition to:

  - `:repo` - The repo to use when inserting the item.
  - `:prefix` - The prefix to use when inserting the item.
  """
  def create(%Specimen{} = specimen, factory, count, opts \\ []) do
    {repo, opts} = Keyword.pop!(opts, :repo)
    {prefix, opts} = Keyword.pop(opts, :prefix)

    specimen
    |> make(factory, count, opts)
    |> Enum.map(fn context ->
      struct =
        context
        |> Specimen.Context.get_struct()
        |> repo.insert!(prefix: prefix, returning: true)
        |> factory.after_creating(specimen.params)

      %{context | struct: struct}
    end)
  end

  @doc """
  Creates structs for a given `Specimen` as specified by the factory.
  Differs from `create/4` in that the items are inserted in a single batch.
  This function relies on `Repo.insert_all/3` for performance reasons and allows a `:patch` option to be passed
  that will be used to patch the structs into insertable entries.

  ## Options
  Accepts the same options as `Specimen.Builder.create/4` in addition to:

  - `:patch` - It may be one of `{:drop, fields}` to drop the given fields or a function of single arity.
    If this option is not present, the default behavior is `{:drop, [:__meta__, :__struct__, :id]}`.
  """
  def create_all(%Specimen{} = specimen, factory, count, opts \\ []) do
    {repo, opts} = Keyword.pop!(opts, :repo)
    {patch, opts} = Keyword.pop(opts, :patch, {:drop, [:__meta__, :__struct__, :id]})
    {prefix, opts} = Keyword.pop(opts, :prefix)

    contexts = make(specimen, factory, count, opts)

    entries =
      contexts
      |> Specimen.Context.get_structs()
      |> Enum.map(fn struct ->
        case patch do
          {:drop, fields} ->
            Map.drop(struct, fields)

          fun when is_function(fun, 1) ->
            apply(patch, [struct])

          _ ->
            raise "Invalid arg passed to option :patch"
        end
      end)

    {_, entries} = repo.insert_all(specimen.module, entries, prefix: prefix, returning: true)

    structs = Enum.map(entries, &factory.after_creating(&1, specimen.params))

    Enum.zip_with(contexts, structs, &Map.put(&1, :struct, &2))
  end

  defp build(%Specimen{} = specimen, factory, count, opts) do
    {states, opts} = Keyword.pop(opts, :states, [])
    {overrides, _opts} = Keyword.pop(opts, :overrides, [])

    generator = fn -> generate(specimen, factory, states, overrides) end

    generator
    |> Stream.repeatedly()
    |> Enum.take(count)
  end

  defp generate(specimen, factory, states, overrides) do
    specimen
    |> factory.build()
    |> apply_states(factory, states)
    |> apply_overrides(overrides)
    |> Specimen.to_struct()
  end

  defp apply_states(%{params: params} = specimen, factory, states) do
    Enum.reduce(states, specimen, fn
      {state, attrs}, specimen ->
        Specimen.transform(specimen, &apply(factory, :state, [state, &1, params, attrs]), state)

      state, specimen ->
        Specimen.transform(specimen, &apply(factory, :state, [state, &1, params, nil]), state)
    end)
  end

  defp apply_overrides(specimen, overrides) do
    Enum.reduce(overrides, specimen, fn {field, value}, specimen ->
      Specimen.override(specimen, field, value)
    end)
  end
end
