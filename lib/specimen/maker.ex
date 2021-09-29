defmodule Specimen.Maker do
  @moduledoc false

  @type opts :: Specimen.Builder.make_opts() | Specimen.params()

  @doc """
  Makes one item as specified by the factory.

  ## Options
  Accepts the same options as `Specimen.Builder.make/3` in addition to:

  - `:params` - A map or keyword list to act as a shared params.
  """
  def make_one(module, factory, opts \\ []) do
    {params, opts} = Keyword.pop(opts, :params, [])

    module
    |> Specimen.new(params)
    |> Specimen.Builder.make(factory, 1, opts)
    |> List.first()
  end

  @doc """
  Makes many items as specified by the factory.

  ## Options
  Accepts the same options as `Specimen.Builder.make/3` in addition to:

  - `:params` - A map or keyword list to act as a shared params.
  """
  def make_many(module, factory, count, opts \\ []) do
    {params, _opts} = Keyword.pop(opts, :params, [])

    module
    |> Specimen.new(params)
    |> Specimen.Builder.make(factory, count, opts)
  end
end
