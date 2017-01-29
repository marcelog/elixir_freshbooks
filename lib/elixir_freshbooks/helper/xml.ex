defmodule ElixirFreshbooks.Helper.XML do

  @moduledoc """

  XML helper macros.

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
  defmacro __using__(_opts) do
    quote do
      import ElixirFreshbooks.Helper.XML
      import SweetXml
      require Record
      require Logger
    end
  end

  defmacro xml_attribute(doc, attribute) do
    quote [location: :keep] do
      attribute = String.to_atom(unquote(attribute))
      attrs = xml_attributes(unquote(doc))
      case Enum.filter(
        attrs, fn(a) -> xmlAttribute(a, :name) === attribute end
      ) do
        [] -> nil
        [a] -> to_string(xmlAttribute(a, :value))
      end
    end
  end

  defmacro xml_attributes(doc) do
    quote [location: :keep] do
      xmlElement(unquote(doc), :attributes)
    end
  end

  defmacro xml_find(doc, xpath) do
    quote [location: :keep] do
      SweetXml.xpath unquote(doc), unquote(xpath)
    end
  end

  defmacro xml_value(doc, element) do
    quote [location: :keep] do
      SweetXml.xpath unquote(doc), ~x"#{unquote(element)}/text()"ls
    end
  end

  defmacro xml_one_value_int(doc, element) do
    quote [location: :keep] do
      SweetXml.xpath unquote(doc), ~x"#{unquote(element)}/text()"i
    end
  end

  defmacro xml_one_value(doc, element) do
    quote [location: :keep] do
      SweetXml.xpath unquote(doc), ~x"#{unquote(element)}/text()"s
    end
  end
end