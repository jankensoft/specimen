defmodule Specimen.BuilderTest do
  use ExUnit.Case, async: true

  alias UserFixture, as: User
  alias UserFixtureFactory, as: Factory

  doctest Specimen.Builder

  describe "builder" do
    test "make/4" do
      structs =
        User
        |> Specimen.new()
        |> Specimen.include(:name, "John")
        |> Specimen.Builder.make(Factory, 1)

      assert structs == nil
    end
  end
end
