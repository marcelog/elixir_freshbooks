defmodule ElixirFreshbooks.Expense do
  @moduledoc """

  This handles the Invoices API.

  See: http://www.freshbooks.com/developers/docs/expenses

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
    client_id: nil,
    category_id: nil,
    amount: nil,
    vendor: nil,
    notes: nil,
    date: nil,
    project_id: nil,
    staff_id: nil

  @type t :: %ElixirFreshbooks.Expense{}

  @doc """
  Creates an expense.

  See: http://www.freshbooks.com/developers/docs/expenses#expense.create
  """
  @spec create(
    pos_integer, pos_integer, float, [String.t], String.t,
    pos_integer, pos_integer
  ) :: t | no_return
  def create(
    staff_id, category_id, amount, vendor, notes \\ [],
    date \\ :now, project_id \\ nil, client_id \\ nil
  ) do
    date = case date do
      :now ->
        {{year, month, date}, _} = :calendar.local_time
        date = if date < 10 do
          "0#{date}"
        else
          date
        end
        month = if month < 10 do
          "0#{month}"
        else
          month
        end
        "#{year}-#{month}-#{date}"
      _ -> date
    end
    expense = %ElixirFreshbooks.Expense{
      client_id: client_id,
      category_id: category_id,
      amount: amount,
      vendor: vendor,
      date: date,
      notes: notes,
      project_id: project_id,
      staff_id: staff_id
    }
    doc = Main.req "expense.create", [
      expense: to_xml(expense)
    ]
    id = xml_one_value_int doc, "//expense_id"
    %ElixirFreshbooks.Expense{expense | id: id}
  end

  defp to_xml(expense) do
    [
      client_id: expense.client_id,
      category_id: expense.category_id,
      amount: expense.amount,
      date: expense.date,
      vendor: expense.vendor,
      notes: Enum.join(expense.notes, "\n"),
      project_id: expense.project_id,
      staff_id: expense.staff_id
    ]
  end
end