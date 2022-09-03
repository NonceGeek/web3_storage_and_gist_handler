defmodule Web3StorageAndGistCmdTool.IpfsHandler do
  @moduledoc """
    get/set data with IPFS
  """
  alias Web3StorageAndGistCmdTool.Ipfs
  def get_data(ipfs_cid) do
    conn = Ipfs.Connection.conn(:read)
    {:ok, payload} =
      Ipfs.API.get(conn, ipfs_cid)
    try do
      result =
        payload
        |> Poison.decode!()
        |> ExStructTranslator.to_atom_struct()
      {:ok, result}
    rescue
      error ->
        {:error, inspect(error)}
    end
  end

  def put_data(data) do
    conn = Ipfs.Connection.conn(:write)
    Ipfs.API.add(conn, data)
  end
end
