defmodule Web3StorageAndGistCmdTool.CLI do
  @moduledoc """
  Documentation for `Web3StorageAndGistCmdTool`.
  """
  require Logger
  def main(args) do
    # Logger.info("args: #{inspect(args)}")
    {opts, argv, _} =
      OptionParser.parse(args,
        strict: [gist: :string, to: :string, genconf: :string],)
    Logger.info("opts: #{inspect(opts)}")
    Logger.info("argv: #{inspect(argv)}")
    handle_args(opts, argv)
  end

  def handle_args([gist: gist_id, to: "ipfs"], []) do
    IO.puts "upload to ipfs"
  end
  def handle_args([gist: gist_id, to: "ar"], []) do
    IO.puts "upload to arweave(//TODO)"
  end

  def handle_args([genconf: raw_conf], []) do
    [ipfs_read_node, ipfs_write_node, ipfs_project_id, ipfs_api_key_secret, github_token] = String.split(raw_conf, " ")
    IO.puts "
      copy the `cmds` into your bash or env file(such as `direnv`):
      export IPFS_DEDIGATED_GATEWAY=#{ipfs_read_node}
      export IPFS_API_ENDPOINT=#{ipfs_write_node}
      export IPFS_PROJECT_ID=#{ipfs_project_id}
      export IPFS_API_KEY_SECRET=#{ipfs_api_key_secret}
      export GITHUB_TOKEN=#{github_token}
    "
  end

  def handle_args([], ["help"]) do
    "send gist to IPFS:\n./web3_storage_and_gist_cmd_tool --gist [gist_id] --to ipfs\n"
    |> Kernel.<>("send gist to ARWEAVE: \n./web3_storage_and_gist_cmd_tool --gist [gist_id] --to ar\n")
    |> Kernel.<>("generate config:\n ./web3_storage_and_gist_cmd_tool --genconf []")
    |> IO.puts()
  end


end
