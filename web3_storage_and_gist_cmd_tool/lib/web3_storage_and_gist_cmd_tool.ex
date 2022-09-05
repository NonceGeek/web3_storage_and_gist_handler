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
        strict: [
          gist: :string, to: :string, genconf: :string, updategist: :boolean,
          folder: :string, des: :string, public: :boolean,
          help: :boolean,
          ],)
    Logger.info("opts: #{inspect(opts)}")
    Logger.info("argv: #{inspect(argv)}")
    handle_args(opts, argv)
  end


  # payload example that can be upload to gist:
  # %{
  #   description: "Example of a gist",
  #   files: %{"README.md": %{content: "Hello World"}},
  #   public: true
  # }
  def handle_args([folder: folder_path, des: description, public: if_public], []) do
    try do
      payload = do_handle_args(folder_path, description, if_public)
      {:ok, %{"id" => gist_id, "owner" => %{"login" => username}}} = GistHandler.create_gist(payload)
      url = GistHandler.build_url(username, gist_id)
      IO.puts "uploaded files to gist: #{url}"
    rescue
      error ->
        IO.puts "meet error: #{inspect(error)}"
    end

  end

  def handle_args([gist: gist_id, folder: folder_path, des: description, public: if_public], []) do
    try do
      payload = do_handle_args(folder_path, description, if_public)
      {:ok, %{"id" => gist_id, "owner" => %{"login" => username}}} = GistHandler.update_gist(gist_id, payload)
    url = GistHandler.build_url(username, gist_id)
      IO.puts "updated files in gist: #{url}"
    rescue
      error ->
        IO.puts "meet error: #{inspect(error)}"
    end
  end

  def handle_args([gist: gist_id, to: "ipfs" = to, updategist: true], []) do
    try do

    %{owner: %{login: username}} = payload = GistHandler.get_gist(gist_id)

      {:ok,
      %{
        "Hash" => hash
    }} =
      gist_to_ipfs(payload)

    io_puts_upload_info(to, hash)
    {:ok, _payload} =
      update_gist(to, gist_id, hash)

    IO.puts "gist #{gist_id} is updated! view on #{GistHandler.build_url(username, gist_id)}"
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

  def handle_args([help: true], []) do
    "send gist to IPFS:\n./web3_storage_and_gist_cmd_tool --gist [gist_id] --to ipfs --updategist\n"
    |> Kernel.<>("send gist to ARWEAVE: \n./web3_storage_and_gist_cmd_tool --gist [gist_id] --to ar --updategist\n")
    |> Kernel.<>("------\n")
    |> Kernel.<>("file to gist:\n ./web3_storage_and_gist_cmd_tool --folder [path] --des [description] --public\n")
    |> Kernel.<>("file to gist:\n ./web3_storage_and_gist_cmd_tool --gist [gist_id] --folder [path] --des [description] --public\n")
    |> Kernel.<>("------\n")
    |> Kernel.<>("generate config:\n ./web3_storage_and_gist_cmd_tool --genconf \"ipfs_read_node pfs_write_node ipfs_project_id ipfs_api_key_secret github_token\"")
    |> IO.puts()
  end

  def do_handle_args(folder_path, description, if_public) do
    {:ok, files_names} = File.ls(folder_path)
    # generate files
    files =
      handle_files(files_names, folder_path)
    # generate_payload
    %{
      description: description,
      files: files,
      public: if_public
    }
  end

  def handle_files(files_names, folder_path) do
    files_names
    |> Enum.reject(fn file_name ->
      String.at(file_name, 0) == "."
    end) # reject the file begin with .
    |> Enum.reduce(%{}, fn file_name, acc ->
      Map.put(acc, String.to_atom(file_name), %{content: fetch_file(file_name, folder_path)})
    end)
  end

  def fetch_file(file_name, folder_path) do
    File.read!("#{folder_path}/#{file_name}")
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

  def gist_to_ipfs(payload) do
    payload
    |> Poison.encode!()
    |> IpfsHandler.put_data()
  end


end
