defmodule ElixirFreshbooks.Payment do
  @moduledoc """

  This handles the Payment API.

  See: http://www.freshbooks.com/developers/docs/payments

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
    invoice_id: nil,
    client_id: nil,
    amount: nil,
    type: nil,
    notes: nil

  @type t :: %ElixirFreshbooks.Payment{}

  @doc """
  Creates a payment.

  See: http://www.freshbooks.com/developers/docs/payments#payment.create
  """
  @spec create(pos_integer, float, String.t, [String.t]) :: t | no_return
  def create(invoice_id, amount, type, notes) do
    payment = %ElixirFreshbooks.Payment{
      invoice_id: invoice_id,
      type: type,
      notes: notes,
      amount: amount
    }
    doc = Main.req "payment.create", [
      payment: to_xml(payment)
    ]
    id = xml_one_value_int doc, "//payment_id"
    %ElixirFreshbooks.Payment{payment | id: id}
  end

  defp to_xml(payment) do
    [
      invoice_id: payment.invoice_id,
      type: payment.type,
      notes: Enum.join(payment.notes, "\n"),
      amount: payment.amount
    ]
  end
end