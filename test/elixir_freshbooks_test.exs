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

  test "can update client" do
    request_assert "client.update", "client.update",
      fn() ->
        ElixirFreshbooks.Client.update %ElixirFreshbooks.Client{
          id: 4422,
          first_name: "first",
          last_name: "last",
          organization: "org",
          email: "user@host.com"
        }
      end,
      fn(body, msgs) ->
        assert_fields body, msgs, [
          {"first_name", "first"},
          {"last_name", "last"},
          {"organization", "org"},
          {"email", "user@host.com"}
        ]
      end,
      fn(result) -> assert :ok === result end
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

  test "can create client with user and pass" do
    request_assert "client.create", "client.create",
      fn() ->
        ElixirFreshbooks.Client.create(
          "first", "last", "org", "user@host.com", "user", "pass"
        )
      end,
      fn(body, msgs) ->
        assert_fields body, msgs, [
          {"first_name", "first"},
          {"last_name", "last"},
          {"organization", "org"},
          {"email", "user@host.com"},
          {"username", "user"},
          {"password", "pass"}
        ]
      end,
      fn(result) ->
        assert %ElixirFreshbooks.Client{
          id: 4422,
          first_name: "first",
          last_name: "last",
          organization: "org",
          email: "user@host.com",
          username: "user",
          password: "pass"
        } === result
      end
  end

  test "can create invoice" do
    request_assert "invoice.create", "invoice.create",
      fn() ->
        ElixirFreshbooks.Invoice.create(
          113, "sent", ["note1", "note2", "note3"],
          [ElixirFreshbooks.InvoiceLine.new("name", "desc", 1, 444)]
        )
      end,
      fn(body, msgs) ->
        assert_fields body, msgs, [
          {"client_id", "113"},
          {"status", "sent"},
          {"notes", "note1\nnote2\nnote3"}
        ]
      end,
      fn(result) ->
        assert %ElixirFreshbooks.Invoice{
          client_id: 113,
          id: 554,
          lines: [
            %ElixirFreshbooks.InvoiceLine{
              description: "desc",
              name: "name",
              quantity: 444,
              type: "item",
              unit_cost: 1
            }
          ],
          notes: ["note1", "note2", "note3"],
          status: "sent"
        } === result
      end
  end

  test "can create payment" do
    request_assert "payment.create", "payment.create",
      fn() ->
        ElixirFreshbooks.Payment.create(
          554, 150, "Credit Card", ["note1", "note2", "note3"]
        )
      end,
      fn(body, msgs) ->
        assert_fields body, msgs, [
          {"invoice_id", "554"},
          {"type", "Credit Card"},
          {"amount", "150"},
          {"notes", "note1\nnote2\nnote3"}
        ]
      end,
      fn(result) ->
        assert %ElixirFreshbooks.Payment{
          id: 889,
          invoice_id: 554,
          notes: ["note1", "note2", "note3"],
          type: "Credit Card",
          amount: 150
        } === result
      end
  end

  test "can create expense" do
    request_assert "expense.create", "expense.create",
      fn() ->
        ElixirFreshbooks.Expense.create(
          1, 1994955, 1.23, "test vendor", ["note 1", "note 2"], "2015-11-12"
        )
      end,
      fn(body, msgs) ->
        assert_fields body, msgs, [
          {"amount", "1.23"},
          {"vendor", "test vendor"},
          {"category_id", "1994955"},
          {"notes", "note 1\nnote 2"},
          {"date", "2015-11-12"},
          {"staff_id", "1"},
        ]
      end,
      fn(result) ->
        assert %ElixirFreshbooks.Expense{
          id: 320343,
          amount: 1.23,
          vendor: "test vendor",
          category_id: 1994955,
          notes: ["note 1", "note 2"],
          date: "2015-11-12",
          staff_id: 1
        } === result
      end
  end

  test "can create invoice with taxes" do
    request_assert "invoice.create", "invoice.create",
      fn() ->
        line = ElixirFreshbooks.InvoiceLine.new("name", "desc", 1, 444) |>
          ElixirFreshbooks.InvoiceLine.tax("1st tax", 1) |>
          ElixirFreshbooks.InvoiceLine.tax("2nd tax", 2)

        ElixirFreshbooks.Invoice.create(
          113, "sent", ["note1", "note2", "note3"], [line]
        )
      end,
      fn(body, msgs) ->
        assert_fields body, msgs, [
          {"client_id", "113"},
          {"status", "sent"},
          {"notes", "note1\nnote2\nnote3"},
          {"tax1_name", "1st tax"},
          {"tax1_percent", "1"},
          {"tax2_name", "2nd tax"},
          {"tax2_percent", "2"}
        ]
      end,
      fn(result) ->
        assert %ElixirFreshbooks.Invoice{
          client_id: 113,
          id: 554,
          lines: [
            %ElixirFreshbooks.InvoiceLine{
              description: "desc",
              name: "name",
              quantity: 444,
              type: "item",
              unit_cost: 1,
              taxes: [
                %{name: "2nd tax", percent: 2},
                %{name: "1st tax", percent: 1}
              ]
            }
          ],
          notes: ["note1", "note2", "note3"],
          status: "sent"
        } === result
      end
  end

  defp request_assert(
    file, request_type, request_fun, server_asserts_fun, client_asserts_fun
  ) do
    me = self()
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