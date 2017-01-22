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
      files: ["lib", "priv", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Marcelo Gornstein"],
      licenses: ["Apache 2.0"],
      links: %{
        "GitHub" => "https://github.com/marcelog/elixir_freshbooks"
      }
    ]
  end

  defp deps do
    [
      {:ibrowse, github: "cmullaparthi/ibrowse", tag: "v4.3"},
      {:earmark, "~> 1.0.3", only: :dev},
      {:ex_doc, "~> 0.14.5", only: :dev},
      {:coverex, "~> 1.4.12", only: :test},
      {:exmerl, github: "portatext/exmerl", branch: "fixing_warnings_elixir_1_4_0"},
      {:xml_builder, "~> 0.0.9"},
      {:servito, github: "marcelog/servito", only: :test, tag: "v0.0.10"}
    ]
  end
end
