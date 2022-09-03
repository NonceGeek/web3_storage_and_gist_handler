defmodule Web3StorageAndGistCmdTool.MixProject do
  use Mix.Project

  def project do
    [
      app: :web3_storage_and_gist_cmd_tool,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      escript: escript(),
      deps: deps(),

    ]
  end

  def escript do
    [main_module: Web3StorageAndGistCmdTool.CLI]
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
      {:httpoison, "~> 1.5"},
      {:ex_struct_translator, "~> 0.1.1"},
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
