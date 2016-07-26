defmodule ElixirFreshbooks.Mixfile do
  use Mix.Project

  def project do
    [
      app: :elixir_freshbooks,
      name: "elixir_freshbooks",
      source_url: "https://github.com/marcelog/elixir_freshbooks",
      version: "0.0.6",
      elixir: ">= 1.0.0",
      description: description,
      package: package,
      deps: deps,
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
      {:earmark, "~> 0.2.1", only: :dev},
      {:ex_doc, "~> 0.12.0", only: :dev},
      {:coverex, "~> 1.4.9", only: :test},
      {:exmerl, github: "pwoolcoc/exmerl", ref: "26ce73d6694d21208ffbaa1e87abd9c5407a0409"},
      {:xml_builder, "~> 0.0.8"},
      {:servito, github: "marcelog/servito", only: :test, tag: "v0.0.5"}
    ]
  end
end
