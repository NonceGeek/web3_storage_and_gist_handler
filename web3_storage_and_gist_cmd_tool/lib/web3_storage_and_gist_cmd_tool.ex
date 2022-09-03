defmodule Web3StorageAndGistCmdTool.CLI do
  @moduledoc """
  Documentation for `Web3StorageAndGistCmdTool`.
  """
  alias Web3StorageAndGistCmdTool.GistHandler
  alias Web3StorageAndGistCmdTool.IpfsHandler
  require Logger

  def main(args) do
    # Logger.info("args: #{inspect(args)}")
    {opts, argv, _} =
      OptionParser.parse(args,
        strict: [gist: :string, to: :string, genconf: :string, updategist: :boolean],)
    Logger.info("opts: #{inspect(opts)}")
    Logger.info("argv: #{inspect(argv)}")
    handle_args(opts, argv)
  end

  def handle_args([gist: gist_id, to: "ipfs" = to, updategist: true], []) do
    try do
      {:ok,
      %{
        "Hash" => hash
    }} =
      gist_to_ipfs(gist_id)

    io_puts_upload_info(to, hash)
    {:ok, _payload} =
      update_gist(to, gist_id, hash)

    IO.puts "gist #{gist_id} has updated already."
    rescue
      error ->
        IO.puts "meet error: #{inspect(error)}"
    end
  end

  def handle_args([gist: gist_id, to: "ipfs" = to, updategist: false], []) do
    handle_args([gist: gist_id, to: "ipfs" = to], [])
  end

  def handle_args([gist: gist_id, to: "ipfs" = to], []) do
    {:ok,
      %{
        "Hash" => hash
    }} =
      gist_to_ipfs(gist_id)
    io_puts_upload_info(to, hash)
  end

  def handle_args([gist: _gist_id, to: "ar"], []) do
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
    "send gist to IPFS:\n./web3_storage_and_gist_cmd_tool --gist [gist_id] --to ipfs --updategist [true or false]\n"
    |> Kernel.<>("send gist to ARWEAVE: \n./web3_storage_and_gist_cmd_tool --gist [gist_id] --to ar --updategist [true or false]\n")
    |> Kernel.<>("generate config:\n ./web3_storage_and_gist_cmd_tool --genconf []")
    |> IO.puts()
  end

  def update_gist(to, gist_id, hash) do
    %{files: files} = payload = GistHandler.get_gist(gist_id)
    [file_name, value] = build_file(to, hash)
    files_new =
      files
      |> Map.put(file_name, value)
    payload_new =
      Map.put(payload, :files, files_new)
    GistHandler.update_gist(gist_id, payload_new)
  end

  def build_file("ipfs", hash) do
    [String.to_atom("IPFS_RECORD.json"), %{content: Poison.encode!(%{cid: hash})}]
  end

  @spec io_puts_upload_info(any, any) :: :ok
  def io_puts_upload_info(ar_of_ipfs, hash) do
    IO.puts "the Gist is upload to #{ar_of_ipfs} already!Hash is: #{hash}"
  end

  def gist_to_ipfs(gist_id) do
    gist_id
    |> GistHandler.get_gist()
    |> Poison.encode!()
    |> IpfsHandler.put_data()
  end


end
