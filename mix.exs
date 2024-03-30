defmodule StaticSite.MixProject do
  use Mix.Project

  def project do
    [
      app: :static_site,
      version: "0.1.0",
      elixir: "~> 1.16",
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {StaticSite.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:nimble_publisher, "~> 1.1.0"},
      {:phoenix_live_view, "~> 0.20.9"},
      {:esbuild, "0.8.1"},
      {:tailwind, "0.2.2"},
      {:yaml_elixir, "2.9.0"},
      {:plug_cowboy, "2.7.0"},
      {:file_system, "1.0.0"}
    ]
  end

  defp aliases() do
    [
      "site.build": ["build", "tailwind default --minify", "esbuild default --minify"]
    ]
  end
end
