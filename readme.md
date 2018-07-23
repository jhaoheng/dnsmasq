# How to use
- build image : `docker build -t orbweb/dnsmasq .`
- run container : 
    - `docker run -it --rm --cap-add=NET_ADMIN -v $(pwd)/dnsmasq-conf:/home/dnsmasq -v $(pwd)/etc/resolv.conf:/etc/resolv.conf orbweb/dnsmasq /bin/bash`
- 執行 dnsmasq : `dnsmasq --hostsdir=/home/dnsmasq/hosts --conf-dir=/home/dnsmasq/confs`

# 設定參數
1. conf 預設的 dns 為 `etcd.discovery`(可變更), 請至 `dnsmasq-conf` 中查詢
	- 設定規則請查詢 
2. 注意其他服務的 container，不一定需要在同一個 docker network 下，但在同一個網路下，會比較容易管理
3. dns-container 必須更新 `/etc/resolv.conf` 設定, 以確保服務的查詢

# 如何動態更新 dns config
1. 更新 dnsmasq-conf 中的設定 (confs/hosts)
    - 新增 hosts : `{container_ip} {name}.etcd.discovery`
        - {container_ip} : 注意是在同一個 docker 中的 ip
    - 新增 confs
        - server : `srv-host=_etcd-server._tcp.etcd.discovery,{name}.etcd.discovery,2380,0,100`
        - client : `srv-host=_etcd-client._tcp.etcd.discovery,{name}.etcd.discovery,2379,0,100`
2. 取得 pid : `ps aux | grep -v grep | grep dnsmasq | awk '{print $2}'`
3. 刪除 `kill -9 {pid}`
4. 執行 dnsmasq 指令
5. 驗證
    - `dig +noall +answer SRV _etcd-server._tcp.etcd.discovery`
    - `dig +noall +answer {name}.etcd.discovery`