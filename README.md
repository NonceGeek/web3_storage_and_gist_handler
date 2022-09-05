# web3_storage_and_gist_handler
Gist data &lt;=> Web3 Storages(IPFS/Arweave)

## Using Guide

0x01) Gen Conf

```bash
 ./web3_storage_and_gist_cmd_tool --genconf "ipfs_read_node pfs_write_node ipfs_project_id ipfs_api_key_secret github_token"
```

0x02) Gist <=> IPFS

```bash
./web3_storage_and_gist_cmd_tool --gist [gist_id] --to ipfs --updategist
send gist to ARWEAVE:
./web3_storage_and_gist_cmd_tool --gist [gist_id] --to ar --updategist
```

0x03) File <=> Gist

```bash
./web3_storage_and_gist_cmd_tool --folder [path] --des [description] --public
./web3_storage_and_gist_cmd_tool --gist [gist_id] --folder [path] --des [description] --public
```
