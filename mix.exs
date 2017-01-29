defmodule ElixirFreshbooks.Mixfile do
  use Mix.Project

  def project do
    [
      app: :elixir_freshbooks,
      name: "elixir_freshbooks",
      source_url: "https://github.com/marcelog/elixir_freshbooks",
      version: "0.0.10",
      elixir: ">= 1.0.0",
      description: description(),
      package: package(),
      deps: deps(),
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod
    ]
  end

  def application do
    [
      applications: [
        :logger,
        :ibrowse
      ]
    ]
  end

  defp description do
    """
Elixir client for FreshBooks.

    """
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Marcelo Gornstein"],
      licenses: ["Apache 2.0"],
      links: %{
        "GitHub" => "https://github.com/marcelog/elixir_freshbooks"
      }
    ]
  end

  defp deps do
    [
      {:ibrowse, "~> 4.4.0"},
      {:earmark, "~> 1.0.3", only: :dev},
      {:ex_doc, "~> 0.14.5", only: :dev},
      {:coverex, "~> 1.4.12", only: :test},
      {:sweet_xml, "~> 0.6.4"},
      {:xml_builder, "~> 0.0.9"},
      {:servito, "~> 0.0.10", only: :test}
    ]
  end
end
