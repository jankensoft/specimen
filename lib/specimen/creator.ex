defmodule Specimen.Creator do
  @moduledoc false

  @doc """
  Creates one item as specified by the factory.

  ## Options
  Accepts the same options as `Specimen.Builder.create/3` in addition to:

  - `:context` - A map or keyword list to act as a shared context.
  """
  def create_one(module, factory, opts \\ []) do
    {params, opts} = Keyword.pop(opts, :params, [])

    module
    |> Specimen.new(params)
    |> Specimen.Builder.create(factory, 1, opts)
    |> List.first()
  end

  @doc """
  Creates many items as specified by the factory.

  ## Options
  Accepts the same options as `Specimen.Builder.create/3` in addition to:

  - `:params` - A map or keyword list to act as a shared params.
  """
  def create_many(module, factory, count, opts \\ []) do
    {params, opts} = Keyword.pop(opts, :params, [])

    module
    |> Specimen.new(params)
    |> Specimen.Builder.create(factory, count, opts)
  end

  @doc """
  Creates many items as specified by the factory.
  Check `Specimen.Builder.create_all/4` for more information.

  ## Options
  Accepts the same options as `create_many/4` in addition to:

  - `:params` - A map or keyword list to act as a shared params.
  """
  def create_all(module, factory, count, opts \\ []) do
    {params, opts} = Keyword.pop(opts, :params, [])

    module
    |> Specimen.new(params)
    |> Specimen.Builder.create_all(factory, count, opts)
  end
end
