defmodule Specimen.MixProject do
  use Mix.Project

  def project do
    [
      app: :specimen,
      version: "0.5.0",
      elixir: "~> 1.12",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :crypto]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
      {:uuid, "~> 1.1"},
      {:ecto, "~> 3.6", only: :test},
      {:ecto_sql, ">= 3.0.0", only: :test},
      {:postgrex, ">= 0.0.0", only: :test}
    ]
  end
end
