# monero-full-node ubuntu 20.04 LTS

Ubuntu 20.04 running monderod for p2pool setups based on instructions found here: <https://github.com/SChernykh/p2pool/releases>

## Usage

```bash
docker run -tid --restart=always -v xmrchain:/home/monero/.bitmonero -p 18080:18080 -p 18081:18081 -p 18083:18083 --name=monerod velvetvaldes/monero-daemon
```