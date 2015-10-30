defmodule ElixirFreshbooksTest do
  @moduledoc """
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
  use ExUnit.Case, async: true
  use Servito
  use ElixirFreshbooks.Test.Util
  use ElixirFreshbooks.Helper.XML
  require Logger

  setup do
    :ok
  end

  test "can raise connection error on network issues" do
    assert_raise(
      ElixirFreshbooks.Error.Connection,
      fn ->
        ElixirFreshbooks.Client.create("first", "last", "org", "user@host.com")
      end
    )
  end

  test "can raise request error on server issues" do
    name = start_server fn(_bindings, _headers, _body, req, state) ->
      ret 404, [], "blah"
    end
    assert_raise(
      ElixirFreshbooks.Error.Connection,
      fn ->
        ElixirFreshbooks.Client.create("first", "last", "org", "user@host.com")
      end
    )
    stop_server name
  end

  test "can raise operation error on bad request" do
    name = start_server fn(_bindings, _headers, _body, req, state) ->
      serve_file "bad_auth"
    end
    assert_raise(
      ElixirFreshbooks.Error.Operation,
      fn ->
        ElixirFreshbooks.Client.create("first", "last", "org", "user@host.com")
      end
    )
    stop_server name
  end

  test "can create client" do
    request_assert "client.create", "client.create",
      fn() ->
        ElixirFreshbooks.Client.create "first", "last", "org", "user@host.com"
      end,
      fn(body, msgs) ->
        assert_fields body, msgs, [
          {"first_name", "first"},
          {"last_name", "last"},
          {"organization", "org"},
          {"email", "user@host.com"}
        ]
      end,
      fn(result) ->
        assert %ElixirFreshbooks.Client{
          id: 4422,
          first_name: "first",
          last_name: "last",
          organization: "org",
          email: "user@host.com"
        } === result
      end
  end


  defp request_assert(
    file, request_type, request_fun, server_asserts_fun, client_asserts_fun
  ) do
    me = self
    server_name = start_server fn(_bindings, _headers, body, req, state) ->
      msgs = []
      #msgs = case validate body do
      #  {:error, error} -> ["invalid schema: #{inspect error}"|msgs]
      #  :ok -> msgs
      #end
      msgs = case xml_find(body, "//request") do
        [r] -> case xml_attribute r, "method" do
          ^request_type -> msgs
          _ -> ["wrong request method"|msgs]
        end
        _ -> ["wrong request section"|msgs]
      end
      msgs = server_asserts_fun.(body, msgs)
      send me, msgs
      serve_file file
    end
    result = request_fun.()
    stop_server server_name
    receive do
      [] -> client_asserts_fun.(result)
      x -> flunk "Something went wrong with the request: #{inspect x}"
    end
  end
end