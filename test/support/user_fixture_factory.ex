defmodule UserFixtureFactory do
  use Specimen.Factory, module: UserFixture

  def build(specimen) do
    specimen
    |> Specimen.include(:id)
    |> Specimen.include(:name, "Joe")
    |> Specimen.include(:lastname, "Schmoe")
    |> Specimen.exclude(:password)
  end

  def state(:status, %UserFixture{} = user, params, attrs) do
    %{user | status: params[:status] || attrs[:status] || "active"}
  end

  def state(:id, %UserFixture{} = user, params, _attrs) do
    {%{user | id: params[:id]}, manual_sequence: true}
  end

  def state(:password, %UserFixture{} = user, _params, password) do
    user = %{user | password: Base.encode64(password)}
    {user, encoding: :base64}
  end

  def after_making(%UserFixture{} = user, params) do
    %{user | age: params[:age] || System.unique_integer([:positive, :monotonic])}
  end

  def after_creating(%UserFixture{name: name, lastname: lastname} = user, params) do
    %{user | email: params[:email] || String.downcase("#{name}.#{lastname}@mail.com")}
  end
end
