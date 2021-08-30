defmodule Specimen.Maker do
  @moduledoc false

  alias Specimen.Builder

  @doc """
  Makes one item as specified by the factory.

  ## Options
  Accepts the same options as `Specimen.Builder.make/3` in addition to:

  - `:context` - A map or keyword list to act as a shared context.
  """
  def make_one(module, factory, opts \\ []) do
    {context, opts} = Keyword.pop(opts, :context, [])

    module
    |> Specimen.new(context)
    |> Specimen.Builder.make(factory, 1, opts)
  end

  @doc """
  Makes many items as specified by the factory.

  ## Options
  Accepts the same options as `Specimen.Builder.make/3` in addition to:

  - `:context` - A map or keyword list to act as a shared context.
  """
  def make_many(module, factory, count, opts \\ []) do
    {context, _opts} = Keyword.pop(opts, :context, [])

    module
    |> Specimen.new(context)
    |> Specimen.Builder.make(factory, count, opts)
  end
end
