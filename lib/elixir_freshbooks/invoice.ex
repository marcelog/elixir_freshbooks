defmodule ElixirFreshbooks.Invoice do
  @moduledoc """

  This handles the Invoices API.

  See: http://www.freshbooks.com/developers/docs/invoices

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
  alias ElixirFreshbooks.InvoiceLine, as: Line
  defstruct \
    id: nil,
    client_id: nil,
    status: nil,
    notes: nil,
    lines: []

  @type t :: %ElixirFreshbooks.Invoice{}

  @doc """
  Creates an invoice.

  See: http://www.freshbooks.com/developers/docs/invoices#invoice.create
  """
  @spec create(Integer.t, String.t, [String.t], [Line.t]) :: t | no_return
  def create(client_id, status, notes, lines) do
    invoice = %ElixirFreshbooks.Invoice{
      client_id: client_id,
      status: status,
      notes: notes,
      lines: lines
    }
    doc = Main.req "invoice.create", [
      invoice: to_xml(invoice)
    ]
    id = xml_one_value_int doc, "//invoice_id"
    %ElixirFreshbooks.Invoice{invoice | id: id}
  end

  defp to_xml(invoice) do
    [
      client_id: invoice.client_id,
      status: invoice.status,
      notes: Enum.join(invoice.notes, "\n"),
      lines: Enum.map(invoice.lines, fn(l) -> {:line, Line.to_xml(l)} end)
    ]
  end
end