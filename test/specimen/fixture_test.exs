defmodule Specimen.FixtureTest do
  use ExUnit.Case, async: true

  doctest Specimen.Fixture

  alias Specimen.Fixture

  describe "elixir types" do
    test ":integer returns random integer fixture" do
      fixture = Fixture.make(:integer)
      assert is_integer(fixture)
    end

    test ":string returns a random string fixture" do
      fixture = Fixture.make(:string)
      assert is_binary(fixture)
      assert String.valid?(fixture)
    end

    test ":binary returns a random binary fixture" do
      fixture = Fixture.make(:binary)
      assert is_binary(fixture)
      assert byte_size(fixture) == 10
      refute String.valid?(fixture)
    end

    test ":float returns a random float fixture" do
      fixture = Fixture.make(:float)
      assert is_float(fixture)
    end

    test ":boolean returns a random boolean fixture" do
      fixture = Fixture.make(:boolean)
      assert is_boolean(fixture)
    end

    test ":date_time returns a random date_time fixture" do
      fixture = Fixture.make(:date_time)
      assert %DateTime{} = fixture
    end

    test ":time returns a random time fixture" do
      fixture = Fixture.make(:time)
      assert %Time{} = fixture
    end

    test ":naive_date_time returns a random naive_date_time fixture" do
      fixture = Fixture.make(:naive_date_time)
      assert %NaiveDateTime{} = fixture
    end

    test "unsupported fixture type throws an exception" do
      assert_raise RuntimeError, "Unsupported type foo", fn ->
        Fixture.make(:foo)
      end
    end
  end
end
