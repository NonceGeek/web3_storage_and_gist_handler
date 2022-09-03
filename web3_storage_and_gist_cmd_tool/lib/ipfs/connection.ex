defmodule Web3StorageAndGistCmdTool.Ipfs.Connection do
    @moduledoc """
    The IpfsConnection is used to create the struct that contains connection
    information of IPFS rest endpoint. By default it connects to `http://localhost:5001/api/v0`
    """
    alias Web3StorageAndGistCmdTool.Ipfs.Connection

    @type t :: %__MODULE__{
      host: String.t(),
      base: String.t(),
      port: pos_integer()
    }

    defstruct host: "", base: "api/v0", port: 5001

    def conn(:read) do
      %Connection{host: Constants.get_constant(:ipfs_read_node) }
    end

    def conn(:write) do
      %Connection{host: Constants.get_constant(:ipfs_write_node) }
    end

  end
