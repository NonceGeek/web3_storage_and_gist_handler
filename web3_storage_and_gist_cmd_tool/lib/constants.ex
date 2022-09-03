defmodule Constants do

  # Constants about IPFS
  def get_constant(:ipfs_read_node), do: System.get_env("IPFS_DEDIGATED_GATEWAY")
  def get_constant(:ipfs_write_node), do: System.get_env("IPFS_API_ENDPOINT")
  def get_constant(:ipfs_project_id), do: System.get_env("IPFS_PROJECT_ID")
  def get_constant(:ipfs_api_key_secret), do: System.get_env("IPFS_API_KEY_SECRET")

  # setting in:\n
  # > https://github.com/settings/tokens
  def get_constant(:github_token), do: System.get_env("GITHUB_TOKEN")

end
