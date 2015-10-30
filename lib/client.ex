defmodule ElixirFreshbooks.Client do
  use ElixirFreshbooks.Helper.XML
  alias ElixirFreshbooks, as: Main
  defstruct \
    id: nil,
    first_name: nil,
    last_name: nil,
    organization: nil,
    email: nil

  @type t :: %ElixirFreshbooks.Client{}

  def create(first_name, last_name, organization, email) do
    client = %ElixirFreshbooks.Client{
      first_name: first_name,
      last_name: last_name,
      organization: organization,
      email: email
    }
    doc = Main.req "client.create", [
      client: to_xml(client)
    ]
    id = xml_one_value_int doc, "//client_id"
    %ElixirFreshbooks.Client{client | id: id}
  end

  defp to_xml(client) do
    [
      first_name: client.first_name,
      last_name: client.last_name,
      organization: client.organization,
      email: client.email
    ]
  end
end