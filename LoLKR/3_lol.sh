#!/bin/sh

#  3_lol.sh
#  LoLKR
#
#  Created by Jason Koo on 4/9/15.
#  Copyright (c) 2015 Jaesung Koo. All rights reserved.
#
#  $> ./3_lol.sh "/Applications/League of Legends.app" 8010

# arguments
if [ "$#" -ne 2 ]; then
    echo "Illegal number of parameters"
    exit 3
fi

if [ ! -d "$1" ]; then
    echo "롤 설치 경로를 확인해 주세요."
    exit 3
fi

BASE_DIR="$1/Contents/LoL/RADS"

# add korea server on menu
echo "na,            na,            en_US,                                                                                                                                                          A
br,            br,            pt_BR,                                                                                                                                                          A
tr,            tr,            tr_TR,                                                                                                                                                          A
euw,           euw,           en_GB|de_DE|es_ES|fr_FR|it_IT,                                                                                                                                  A
eune,          eune,          en_GB|cs_CZ|el_GR|hu_HU|pl_PL|ro_RO,                                                                                                                            A
ru,            ru,            ru_RU,                                                                                                                                                          A
la1,           la1,           es_MX,                                                                                                                                                          A
la2,           la2,           es_MX,                                                                                                                                                          A
oc1,           oc1,           en_AU,                                                                                                                                                          A
jp,            jp,            ja_JP,                                                                                                                                                          A
kr,            kr,            ko_KR|en_US,                                                                                                                                                    A
" > $BASE_DIR/projects/lol_patcher/managedfiles/0.0.0.45/regions.txt

echo "na,            NA,            lol_air_client_config_na,                                   NA1,                                                        prod.na1.lol.riotgames.com,                                 status.leagueoflegends.com
br,            BR,            lol_air_client_config_br,                                   BR1,                                                        prod.br.lol.riotgames.com,                                  status.leagueoflegends.com
tr,            TR,            lol_air_client_config_tr,                                   TR1,                                                        prod.tr.lol.riotgames.com,                                  status.leagueoflegends.com
euw,           EUW,           lol_air_client_config_euw,                                  EUW1,                                                       prod.euw1.lol.riotgames.com,                                status.leagueoflegends.com
eune,          EUNE,          lol_air_client_config_eune,                                 EUN1,                                                       prod.eun1.lol.riotgames.com,                                status.leagueoflegends.com
ru,            RU,            lol_air_client_config_ru,                                   RU,                                                         prod.ru.lol.riotgames.com,                                  status.leagueoflegends.com
la1,           LA1,           lol_air_client_config_la1,                                  LA1,                                                        prod.la1.lol.riotgames.com,                                 status.leagueoflegends.com
la2,           LA2,           lol_air_client_config_la2,                                  LA2,                                                        prod.la2.lol.riotgames.com,                                 status.leagueoflegends.com
oc1,           OC1,           lol_air_client_config_oc1,                                  OC1,                                                        prod.oc1.lol.riotgames.com,                                 status.leagueoflegends.com
jp,            JP,            lol_air_client_config_jp,                                   jp1,                                                        prod.jp1.lol.riotgames.com,                                 status.leagueoflegends.com
kr,            KR,            lol_air_client_config_kr,                                   KR,                                                         prod.kr.lol.riotgames.com,                                  status.leagueoflegends.com
" > $BASE_DIR/projects/lol_patcher/managedfiles/0.0.0.45/shards.txt

echo "English, en_US
Português, pt_BR
Türkçe, tr_TR
English, en_GB
Deutsch, de_DE
Español, es_ES
Français, fr_FR
Italiano, it_IT
Čeština, cs_CZ
Ελληνικά, el_GR
Magyar, hu_HU
Polski, pl_PL
Română, ro_RO
Русский, ru_RU
Español, es_MX
English, en_AU
日本語, ja_JP
Korean, ko_KR" > $BASE_DIR/projects/lol_patcher/managedfiles/0.0.0.45/languages.txt

# change update server address
echo "DownloadPath = /releases/Maclive
DownloadURL = 127.0.0.1:$2
Region = KR" > "$BASE_DIR/system/system.cfg"

# change login server address
if [ ! -d "$BASE_DIR/projects/lol_air_client_config_oc1/releases" ]; then
    echo "북미 서버를 먼저 선택하고 업데이트가 완료되어야 합니다."
    exit 3
elif [ ! -d "$BASE_DIR/projects/league_client_en_us/releases" ]; then
    echo "북미 서버를 먼저 선택하고 업데이트가 완료되어야 합니다."
    exit 3
fi

if [ ! -d "$BASE_DIR/projects/lol_air_client_config_kr" ]; then
    cp -r "$BASE_DIR/projects/lol_air_client_config_oc1" "$BASE_DIR/projects/lol_air_client_config_kr"
fi

find "$BASE_DIR/projects/lol_air_client_config_kr" -name "lol.properties" | while read filename; do echo "host=prod.kr.lol.riotgames.com,prod.kr.lol.riotgames.com
xmpp_server_url=chat.kr.lol.riotgames.com
lq_uri=https://lq.kr.lol.riotgames.com
rssStatusURLs=null
regionTag=kr
lobbyLandingURL=http://frontpage.kr.leagueoflegends.com/ko_KR/client/landing
featuredGamesURL=http://spectator.kr.lol.riotgames.com:80/observer-mode/rest/featured
storyPageURL=http://www.leagueoflegends.co.kr/launcher/journal.php
ladderURL=http://www.leagueoflegends.co.kr
platformId=KR
ekg_uri=https://ekg.riotgames.com
loadModuleChampionDetail=true
useOldChatRenderers=true
riotDataServiceDataSendProbability=1.0" > "$filename"; done

echo "airConfigProject = lol_air_client_config_kr" > "$BASE_DIR/system/launcher.cfg"
echo "locale = ko_KR" > "$BASE_DIR/system/locale.cfg"

LATEST=`find projects/league_client/releases -depth 1 | sort -gr | head -n1`

patch $LATEST/deploy/system.yaml << EOF
--- system.yaml	2000-01-01 00:00:00.000000000 +0900
+++ system.yaml	2000-01-01 00:00:00.000000000 +0900
@@ -84,7 +84,7 @@
     - copy_to_solution: false
       headers: []
       history: keep
-      hostname: l3cdn.riotgames.com
+      hostname: 127.0.0.1:$2
       id: league_client_sln
       locale: en_US
       region: NA
@@ -94,7 +94,7 @@
     - copy_to_solution: true
       headers: []
       history: none
-      hostname: l3cdn.riotgames.com
+      hostname: 127.0.0.1:$2
       id: lol_game_client_sln
       locale: en_US
       region: NA
@@ -476,6 +477,39 @@
       store:
         store_url: https://store.tr.lol.riotgames.com
     web_region: tr
+  KR:
+    available_locales:
+    - ko_KR
+    default_locale: ko_KR
+    rso_platform_id: KR
+    servers:
+      chat:
+        allow_self_signed_cert: false
+        chat_host: chat.kr.lol.riotgames.com
+        chat_port: 5223
+      entitlements:
+        entitlements_url: https://entitlements.auth.riotgames.com/api/token/v1
+      lcds:
+        lcds_host: prod.kr.lol.riotgames.com
+        lcds_port: 2099
+        login_queue_url: https://lq.kr.lol.riotgames.com/login-queue/rest/queues/lol
+        use_tls: true
+      license_agreement_urls:
+        eula: http://www.leagueoflegends.co.kr/?m=rules&cid=3
+        terms_of_use: http://www.leagueoflegends.co.kr/?m=rules&cid=1
+      payments:
+        payments_host: https://plstore.kr.lol.riotgames.com
+      prelogin_config:
+        prelogin_config_url: https://prod.config.patcher.riotgames.com
+      rms:
+        rms_heartbeat_interval_seconds: 60
+        rms_url: wss://riot.edge.rms.si.riotgames.com:443
+      service_status:
+        api_url: https://status.leagueoflegends.com/shards/kr/synopsis
+        human_readable_status_url: https://status.leagueoflegends.com/#kr
+      store:
+        store_url: https://store.kr.lol.riotgames.com
+    web_region: kr
 rso:
   kount:
     collector: prod02.kaxsdc.com
EOF

echo "지역을 KR로 변경해주세요."
