defmodule Specimen.BuilderTest do
  use ExUnit.Case, async: true

  alias UserFixture, as: User
  alias UserFixtureFactory, as: Factory
  alias Specimen.Context

  doctest Specimen.Builder

  describe "builder" do
    test "make/4 returns the given amount of built structs" do
      structs =
        User
        |> Specimen.new()
        |> Specimen.Builder.make(Factory, 1)
        |> Context.get_structs()

      assert [%User{name: "Joe", lastname: "Schmoe"}] = structs
    end
  end
end
