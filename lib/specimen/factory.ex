defmodule Specimen.Factory do
  @moduledoc """
  Defines a factory for creating structs of the specified module.

  ## Options

  - `:module` - The module to create structs of.
  - `:repo` - The repository to store the structs in.
  - `:prefix` - The database prefix to use when inserting structs.

  > These options can also be overriden by passing them as arguments to the functions that support it.

  ## Examples

  ```
  defmodule UserFactory do
    use Specimen.Factory,
      module: User,
      repo: Repo,
      prefix: "prefix"
  end
  ```

  """

  @callback make_one(opts :: list(Specimen.Maker.opts())) :: Specimen.Context.t()

  @callback make_many(count :: integer(), opts :: list(Specimen.Maker.opts())) ::
              list(Specimen.Context.t())

  @callback create_one(opts :: list(Specimen.Creator.opts())) :: Specimen.Context.t()

  @callback create_many(count :: integer(), opts :: list(Specimen.Creator.opts())) ::
              list(Specimen.Context.t())

  @callback create_all(count :: integer(), opts :: list(Specimen.Creator.all_opts())) ::
              list(Specimen.Context.t())

  @callback build(Specimen.t()) :: Specimen.t()

  @callback state(atom(), struct(), params :: Specimen.params(), attrs :: term()) ::
              struct() | {struct(), Specimen.params()}

  @callback after_making(struct(), params :: Specimen.params()) :: struct()

  @callback after_creating(struct(), params :: Specimen.params()) :: struct()

  defmacro __using__(opts) when is_list(opts) do
    quote bind_quoted: [opts: opts] do
      @behaviour Specimen.Factory

      # unless opts[:module] do
      #   raise "Missing `:module` option"
      # end

      {module, opts} = Keyword.pop!(opts, :module)
      {repo, opts} = Keyword.pop(opts, :repo)
      {prefix, _opts} = Keyword.pop(opts, :prefix)

      @factory __MODULE__
      @factory_module module
      @factory_repo repo
      @factory_prefix prefix

      def __info__,
        do: [
          factory: @factory,
          factory_module: @factory_module,
          factory_repo: @factory_repo,
          factory_prefix: @factory_prefix
        ]

      def make_one(opts \\ []) do
        Specimen.Maker.make_one(@factory_module, @factory, opts)
      end

      def make_many(count, opts \\ []) do
        Specimen.Maker.make_many(@factory_module, @factory, count, opts)
      end

      def create_one(opts \\ []) do
        opts = Keyword.merge([repo: @factory_repo, prefix: @factory_prefix], opts)
        Specimen.Creator.create_one(@factory_module, @factory, opts)
      end

      def create_many(count, opts \\ []) do
        opts = Keyword.merge([repo: @factory_repo, prefix: @factory_prefix], opts)
        Specimen.Creator.create_many(@factory_module, @factory, count, opts)
      end

      def create_all(count, opts \\ []) do
        opts = Keyword.merge([repo: @factory_repo, prefix: @factory_prefix], opts)
        Specimen.Creator.create_all(@factory_module, @factory, count, opts)
      end

      def build(%Specimen{module: module, params: params}) when module != unquote(module) do
        raise "This factory can't be used to build #{inspect(module)}"
      end

      def build(specimen), do: specimen

      def state(_state, struct, _params, _attrs), do: struct

      def after_making(struct, _params), do: struct

      def after_creating(struct, _params), do: struct

      defoverridable build: 1, state: 4, after_making: 2, after_creating: 2
    end
  end
end
