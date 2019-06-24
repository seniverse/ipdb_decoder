defmodule IPDBDecoder.MixProject do
  use Mix.Project

  @version File.cwd!() |> Path.join("version") |> File.read!() |> String.trim()
  @url_github "https://github.com/seniverse/ipdb_decoder"

  def project do
    [
      app: :ipdb_decoder,
      version: @version,
      elixir: "~> 1.8",
      description: "IPIP.net GeoIP database (ext is .ipdb) Decoder",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      source_url: @url_github,
      homepage_url: "https://hex.pm/packages/ipdb_decoder",
      package: [
        licenses: ["Apache 2.0"],
        links: %{
          "GitHub" => @url_github,
          "Docs" => "https://hexdocs.pm/ipdb_decoder"
        },
        files: ~w(lib .formatter.exs mix.exs README* LICENSE* CHANGELOG* version Makefile)
      ],
      docs: [
        extras: ["README.md", "CHANGELOG.md"],
        main: "readme"
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:poison, "~> 3.1"},
      {:credo, ">= 1.0.0", only: [:dev, :test], runtime: false},
      {:pre_commit_hook, ">= 1.2.0", only: :dev, runtime: false},
      {:ex_doc, "~> 0.19", only: :dev, runtime: false},
      {:excoveralls, "~> 0.11", only: [:dev, :test], runtime: false}
    ]
  end
end
