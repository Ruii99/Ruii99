#SUBSCRIBED https://raw.githubusercontent.com/xiamubaby/xiamucloud/refs/heads/main/Cloud.js
# 机场订阅，名称不能重复
proxy-providers:
  Airport_01:
    type: http
    interval: 1800
    health-check:
      enable: true
      url: https://www.gstatic.com/generate_204
      timeout: 5000
      interval: 300
    proxy: 🎯 全球直连
    url: https://5.restpluan.com/link/9bfF2y5BWavC9Sl9?clash=1

# 用于下载订阅时指定UA
global-ua: clash
# 全局配置
port: 7890
socks-port: 7891
redir-port: 7892
mixed-port: 7893
tproxy-port: 7894
ipv6: false
allow-lan: true
unified-delay: false
tcp-concurrent: true
geodata-mode: false
geodata-loader: standard
geo-auto-update: true
geo-update-interval: 3
geox-url:
  geoip: "https://testingcf.jsdelivr.net/gh/MetaCubeX/meta-rules-dat@release/geoip.dat"
  geosite: "https://testingcf.jsdelivr.net/gh/MetaCubeX/meta-rules-dat@release/geosite.dat"
  mmdb: "https://testingcf.jsdelivr.net/gh/MetaCubeX/meta-rules-dat@release/country.mmdb"
  asn: "https://github.com/xishang0128/geoip/releases/download/latest/GeoLite2-ASN.mmdb"
# 控制面板
external-controller: 0.0.0.0:9090
secret: ""
external-ui: ui
external-ui-url: "https://ghp.ci/https://github.com/MetaCubeX/metacubexd/archive/refs/heads/gh-pages.zip"
# 匹配进程 always/strict/off
find-process-mode: strict
global-client-fingerprint: chrome
keep-alive-idle: 600
keep-alive-interval: 30
# 策略组选择和fakeip缓存
profile:
  store-selected: true
  store-fake-ip: true
# 流量嗅探
sniffer:
  enable: true
  sniff:
    HTTP:
      ports: [80, 8080-8880]
      override-destination: true
    TLS:
      ports: [443, 8443]
    QUIC:
      ports: [443, 8443]
  force-domain:
    - +.v2ex.com
  skip-domain:
    - "Mijia Cloud"
    - "dlg.io.mi.com"
    - "+.push.apple.com"
    - "+.apple.com"
# 代理模式
tun:
  enable: true
  stack: system
  device: utun
  dns-hijack:
    - tcp://any:53
  gso: true
  gso-max-size: 65536
  auto-route: false
  auto-detect-interface: false
  auto-redirect: false
  strict-route: false
# DNS模块
dns:
  enable: true
  listen: 0.0.0.0:7874
  ipv6: false
  respect-rules: true
  # 模式切换 redir-host / fake-ip

  enhanced-mode: fake-ip
  fake-ip-range: 28.0.0.1/8
  # 模式切换 whitelist/blacklist 

  # 黑名单模式表示如果匹配成功则不返回 Fake-IP, 白名单模式时只有匹配成功才返回 Fake-IP
  fake-ip-filter-mode: blacklist
  fake-ip-filter:
    - +.lan
    - +.local
    - geosite:private
    - geosite:cn
  default-nameserver:
    - 223.5.5.5
    - 119.29.29.29
  proxy-server-nameserver:
    - 223.5.5.5
    - 119.29.29.29
  nameserver:
    - 223.5.5.5
    - 119.29.29.29

# 策略组

proxy-groups:

  - {name: ♻️ 手动切换, type: select, proxies: [🇭🇰 HK香港, 🇼🇸 TW台湾, 🇸🇬 SG新加坡, 🇯🇵 JP日本, 🇰🇷 KR韩国, 🇺🇸 US美国], include-all: null}

  - {name: 🎯 全球直连, type: select, proxies: [DIRECT], include-all: null}

  - {name: 🔎 Google, type: select, proxies: [ 🇺🇸 US美国], include-all: null}

  - {name: 📲 Telegram, type: select, proxies: [🇭🇰 HK香港, 🇸🇬 SG新加坡, 🇯🇵 JP日本,], include-all: null}

  - {name: 🐟 漏网之鱼, type: select, proxies: [♻️ 手动切换], include-all: null}

  - filter: 港|🇭🇰|HK|(?i)Hong
    name: 🇭🇰 HK香港
    type: select
    include-all: true
    icon: https://fastly.jsdelivr.net/gh/Koolson/Qure/IconSet/Color/Hong_Kong.png
  - filter: 台|🇹🇼|湾|TW|(?i)Taiwan
    include-all: true
    name: 🇼🇸 TW台湾
    type: select
    icon: https://fastly.jsdelivr.net/gh/Koolson/Qure@master/IconSet/Color/Taiwan.png
  - include-all: true
    name: 🇸🇬 SG新加坡
    type: select
    filter: 新加坡|坡|狮城|🇸🇬|SG|(?i)Singapore
    icon: https://fastly.jsdelivr.net/gh/Koolson/Qure@master/IconSet/Color/Singapore.png
  - include-all: true
    name: 🇯🇵 JP日本
    type: select
    filter: 日|🇯🇵|东京|JP|(?i)Japan
    icon: https://fastly.jsdelivr.net/gh/Koolson/Qure@master/IconSet/Color/Japan.png
  - name: 🇰🇷 KR韩国
    type: select
    icon: https://fastly.jsdelivr.net/gh/Koolson/Qure@master/IconSet/Color/Korea.png
    filter: 韩|🇰🇷|首尔|KR|(?i)Korea
    include-all: true
  - include-all: true
    name: 🇺🇸 US美国
    type: select
    filter: 美国|🇺🇲|US|(?i)States|America
    icon: https://fastly.jsdelivr.net/gh/Koolson/Qure@master/IconSet/Color/United_States.png


rules:
  - RULE-SET,lan_class,🎯 全球直连
  - RULE-SET,direct_class,🎯 全球直连
  - RULE-SET,custom_direct_class,🎯 全球直连
  - RULE-SET,googlecn_class,🎯 全球直连
  - RULE-SET,privatetracker_class,🎯 全球直连
  - RULE-SET,telegram_class,📲 Telegram
  - RULE-SET,google_class,🔎 Google
  - RULE-SET,chinadomain_class,🎯 全球直连
  - RULE-SET,chinacompanyip_class,🎯 全球直连
  - RULE-SET,chinaip_class,🎯 全球直连
  - RULE-SET,download_class,🎯 全球直连
  - GEOSITE,category-public-tracker,🎯 全球直连
  - GEOIP,lan,🎯 全球直连,no-resolve
  - GEOIP,cn,🎯 全球直连,no-resolve
  - MATCH,🐟 漏网之鱼


rule-anchor:
  class: &class {type: http, interval: 86400, behavior: classical, format: text}
rule-providers:
  lan_class: {!!merge <<: *class, url: "https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rule/Clash/Lan/Lan.list"}

  direct_class: {!!merge <<: *class, url: "https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rule/Clash/Direct/Direct.list"}

  custom_direct_class: {!!merge <<: *class, url: "https://raw.githubusercontent.com/Aethersailor/Custom_OpenClash_Rules/main/rule/Custom_Direct.list"}

  googlecn_class: {!!merge <<: *class, url: "https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/GoogleCN.list"}

  privatetracker_class: {!!merge <<: *class, url: "https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rule/Clash/PrivateTracker/PrivateTracker.list"}

  telegram_class: {!!merge <<: *class, url: "https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rule/Clash/Telegram/Telegram.list"}

  google_class: {!!merge <<: *class, url: "https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rule/Clash/Google/Google.list"}

  chinadomain_class: {!!merge <<: *class, url: "https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/ChinaDomain.list"}

  chinacompanyip_class: {!!merge <<: *class, url: "https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/ChinaCompanyIp.list"}

  chinaip_class: {!!merge <<: *class, url: "https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/ChinaIp.list"}

  download_class: {!!merge <<: *class, url: "https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rule/Clash/Download/Download.list"}

