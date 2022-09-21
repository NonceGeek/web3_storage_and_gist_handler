# web3_storage_and_gist_handler
Github Data => Gist data &lt;=> Web3 Storages(IPFS/Arweave)

An Example of Code that saved on IPFS:

> CID: QmU3x6fvxHwLKjwwrewiMGi8ua4p1nVqXjk5JdJ71JiKAA

## 0x01) Using Guide

0x01) Gen Conf

```bash
 ./web3_storage_and_gist_cmd_tool --genconf "ipfs_read_node pfs_write_node ipfs_project_id ipfs_api_key_secret github_token"
```

0x02) Gist => IPFS

```bash
./web3_storage_and_gist_cmd_tool --gist [gist_id] --to ipfs --updategist
send gist to ARWEAVE:
./web3_storage_and_gist_cmd_tool --gist [gist_id] --to ar --updategist
```

0x03) Files => Gist

```bash
./web3_storage_and_gist_cmd_tool --folder [path] --des [description] --public
./web3_storage_and_gist_cmd_tool --gist [gist_id] --folder [path] --des [description] --public
```

## 0x02) Articles abount Gist using in Web3

* [dApp 使用存储指南之 Gist](https://mp.weixin.qq.com/s/wGkPsU-T0CHPcTbKiGDzLw)
