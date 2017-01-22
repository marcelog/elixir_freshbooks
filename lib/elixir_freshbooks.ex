defmodule ElixirFreshbooks do
  @moduledoc """

  An elixir client for the FreshBooks API.

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
  alias ElixirFreshbooks.Helper.Http, as: Http
  alias ElixirFreshbooks.Error.Connection, as: RequestError
  alias ElixirFreshbooks.Error.Connection, as: ConnectionError
  alias ElixirFreshbooks.Error.Operation, as: OperationError
  require Logger

  @spec req(String.t, Keyword.t) :: Record | no_return
  def req(requestType, parameters) do
    body = [{:request, %{method: requestType}, parameters}]
    case Http.req token(), :post, uri(), body do
      {:ok, 200, _headers, body} ->
        {doc, _} = Exmerl.from_string body
        [response] = xml_find doc, "//response"
        status = xml_attribute response, "status"
        if status !== "ok" do
          code = xml_value doc, "//code"
          error = xml_value doc, "//error"
          raise OperationError, message: {Enum.zip(code, error), doc}
        end
        doc
      {:ok, status, headers, body} ->
        raise RequestError, message: {status, headers, body}
      error ->
        raise ConnectionError, message: error
    end
  end

  defp token() do
    config :token
  end

  defp uri() do
    if Mix.env === :test do
      config :test_server_uri
    else
      config :uri
    end
  end

  defp config(key) do
    Application.get_env :elixir_freshbooks, key
  end
end
