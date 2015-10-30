defmodule ElixirFreshbooks.Helper.XML do
  defmacro __using__(_opts) do
    quote do
      import ElixirFreshbooks.Helper.XML
      require Record
      require Logger
      Record.defrecord(
        :xmlText,
        Record.extract(:xmlText, from_lib: "xmerl/include/xmerl.hrl")
      )
      Record.defrecord(
        :xmlElement,
        Record.extract(:xmlElement, from_lib: "xmerl/include/xmerl.hrl")
      )
      Record.defrecord(
        :xmlAttribute,
        Record.extract(:xmlAttribute, from_lib: "xmerl/include/xmerl.hrl")
      )
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
      Exmerl.XPath.find unquote(doc), unquote(xpath)
    end
  end

  defmacro xml_value(doc, element) do
    quote [location: :keep] do
      elements = xml_find unquote(doc), "#{unquote(element)}/text()"
      for e <- elements, do: to_string xmlText(e, :value)
    end
  end

  defmacro xml_one_value_int(doc, element) do
    quote [location: :keep] do
      case xml_one_value(unquote(doc), unquote(element)) do
        nil -> nil
        code ->
          {code, ""} = Integer.parse code
          code
      end
    end
  end

  defmacro xml_one_value(doc, element) do
    quote [location: :keep] do
      case xml_find unquote(doc), "#{unquote(element)}/text()" do
        [] -> nil
        [e] -> to_string xmlText(e, :value)
      end
    end
  end
end