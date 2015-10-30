defmodule ElixirFreshbooks.Client do
  @moduledoc """

  This handles the Clients API.

  See: http://www.freshbooks.com/developers/docs/clients

  Copyright 2015 Marcelo Gornstein <marcelog@gmail.com>

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at
      http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
  """
  use ElixirFreshbooks.Helper.XML
  alias ElixirFreshbooks, as: Main
  defstruct \
    id: nil,
    first_name: nil,
    last_name: nil,
    organization: nil,
    email: nil

  @type t :: %ElixirFreshbooks.Client{}

  @doc """
  Creates a client.

  See: http://www.freshbooks.com/developers/docs/clients#client.create
  """
  @spec create(String.t, String.t, String.t, String.t) :: t | no_return
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