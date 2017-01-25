defmodule Spyanator.Mixfile do
  use Mix.Project
  @description """
    A Spy library for Elixir.
  """
  def project do
    [app: :spyanator,
     version: "0.0.3",
     elixir: "~> 1.3",
     name: "Spyanator",
     description: @description,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     test_coverage: [tool: ExCoveralls],
     preferred_cli_env: [coveralls: :test],
     package: package(),
     deps: deps()]
  end

  defp package do
    [
      maintainers: ["Adam Beck"],
      licenses: ["MIT"],
      links: %{"Github" => "https://github.com/Gwash3189/spyanator"}
    ]
  end

  def application do
    [applications: []]
  end

  defp deps do
    [{:excoveralls, "~> 0.5", only: :test},
     {:mix_test_watch, "~> 0.2", only: :dev},
     {:ex_doc, "~> 0.14", only: :dev}]
  end
end
