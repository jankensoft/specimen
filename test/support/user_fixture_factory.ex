defmodule UserFixtureFactory do
  use Specimen.Factory, module: UserFixture

  def build(specimen, context) do
    specimen
    |> Specimen.include(:id)
    |> Specimen.include(:name, context[:name] || "Joe")
    |> Specimen.include(:lastname, "Schmoe")
    |> Specimen.exclude(:password)
  end

  def state(:status, %UserFixture{} = user, context) do
    %{user | status: context[:status] || "active"}
  end

  def after_making(%UserFixture{} = user, context) do
    %{user | age: context[:age] || System.unique_integer([:positive, :monotonic])}
  end

  def after_creating(%UserFixture{name: name, lastname: lastname} = user, context) do
    %{user | email: context[:email] || String.downcase("#{name}.#{lastname}@mail.com")}
  end
end
