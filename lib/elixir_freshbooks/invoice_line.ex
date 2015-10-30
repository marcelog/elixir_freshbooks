defmodule ElixirFreshbooks.InvoiceLine do
  @moduledoc """

  An Invoice Line.

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
  defstruct \
    name: nil,
    description: nil,
    unit_cost: nil,
    quantity: nil,
    type: nil

  @type t :: %ElixirFreshbooks.InvoiceLine{}

  @doc """
  Creates a line structure.
  """
  @spec new(String.t, String.t, Float.t, Integer.t, String.t) :: t
  def new(name, description, unit_cost, quantity, type \\ "item") do
    %ElixirFreshbooks.InvoiceLine{
      name: name,
      description: description,
      unit_cost: unit_cost,
      quantity: quantity,
      type: type
    }
  end

  @doc """
  Returns an XML structure for the given invoice line.
  """
  @spec to_xml(t) :: Keyword.t
  def to_xml(line) do
    [
      name: line.name,
      description: line.description,
      unit_cost: line.unit_cost,
      quantity: line.quantity,
      type: line.type
    ]
  end
end