#!/bin/bash
set -eo pipefail
if [[ ${DEBUG:=0} == "1" ]]; then
    set -x
fi

setup() {
    echo "KUJIRAD_HOME: ${KUJIRAD_HOME:=/kujira}"
    echo "KUJIRAD_ARGS: ${KUJIRAD_ARGS:=--home $KUJIRAD_HOME}"
    echo "---"
    echo "CONFIGURE: ${CONFIGURE:=0}"
    echo "MONIKER: ${MONIKER:=mint-$RANDOM}"
    echo "CHAIN_ID: ${CHAIN_ID:=kaiyo-1}"
    echo "GENESIS_URL: ${GENESIS_URL:=https://github.com/Team-Kujira/networks/raw/master/mainnet/kaiyo-1.json}"
    echo "GENESIS_SHA256SUM: ${GENESIS_SHA256SUM:=9981e51c7e0ee1445c953eb7d27aef89e688c4d6db7a31459b0837b2dd3ceca5}"
    echo "SEEDS: ${SEEDS:=ade4d8bc8cbe014af6ebdf3cb7b1e9ad36f412c0@seeds.polkachu.com:11856,20e1000e88125698264454a884812746c2eb4807@seeds.lavenderfive.com:11856,824fa337b806bd48ce9505d74ba3e5adea80da93@seeds.goldenratiostaking.net:1628}"
    echo "PEERS: ${PEERS:=}"
    echo "MIN_GAS_PRICES: ${MIN_GAS_PRICES:=0.00119ukuji,0.00150factory/kujira1qk00h5atutpsv900x202pxx42npjr9thg58dnqpa72f2p7m2luase444a7/uusk,0.00150ibc/295548A78785A1007F232DE286149A6FF512F180AF5657780FC89C009E2C348F,0.000125ibc/27394FB092D2ECCD56123C74F36E4C1F926001CEADA9CA97EA622B25F41E5EB2,0.00126ibc/47BD209179859CDE4A2806763D7189B6E6FE13A17880FE2B42DE1E6C1E329E23,0.00652ibc/3607EB5B5E64DD1C0E12E07F077FF470D5BC4706AFCBC98FE1BA960E5AE4CE07,617283951ibc/F3AA7EF362EC5E791FE78A0F4CCC69FEE1F9A7485EB1A8CAB3F6601C00522F10,0.000288ibc/EFF323CC632EC4F747C61BCE238A758EFDB7699C3226565F7C20DA06509D59A5,0.000125ibc/DA59C009A0B3B95E0549E6BF7B075C8239285989FF457A8EDDBB56F10B2A6986,0.00137ibc/A358D7F19237777AF6D8AD0E0F53268F8B18AE8A53ED318095C14D6D7F3B2DB5,0.0488ibc/4F393C3FCA4190C0A6756CE7F6D897D5D1BE57D6CCB80D0BC87393566A7B6602,78492936ibc/004EBF085BBED1029326D56BE8A2E67C08CECE670A94AC1947DF413EF5130EB2,964351ibc/1B38805B1C75352B28169284F96DF56BDEBD9E8FAC005BDCC8CF0378C82AA8E7}"
    echo "PRUNING: ${PRUNING:=custom}"
    echo "PRUNING_KEEP_RECENT: ${PRUNING_KEEP_RECENT:=10000}"
    echo "PRUNING_KEEP_EVERY: ${PRUNING_KEEP_EVERY:=100}"
    echo "PRUNING_INTERVAL: ${PRUNING_INTERVAL:=1033}"
    echo "HALT_HEIGHT: ${HALT_HEIGHT:=0}"
    echo "API_ENABLE: ${API_ENABLE:=true}"
    echo "API_ADDRESS: ${API_ADDRESS:=tcp://0.0.0.0:1317}"
    echo "API_CORS: ${API_CORS:=true}"
    echo "GRPC_ENABLE: ${GRPC_ENABLE:=true}"
    echo "GRPC_ADDRESS: ${GRPC_ADDRESS:=0.0.0.0:9090}"
    echo "GRPC_WEB_ENABLE: ${GRPC_WEB_ENABLE:=false}"
    echo "GRPC_WEB_ADDRESS: ${GRPC_WEB_ADDRESS:=0.0.0.0:9091}"
    echo "GRPC_WEB_CORS: ${GRPC_WEB_CORS:=true}"
    echo "SNAPSHOT_INTERVAL: ${SNAPSHOT_INTERVAL:=1000}"
    echo "SNAPSHOT_KEEP_RECENT: ${SNAPSHOT_KEEP_RECENT:=5}"
    echo "WASM_QUERY_GAS_LIMIT: ${WASM_QUERY_GAS_LIMIT:=30000000}"
    echo "PRIV_VALIDATOR_LADDR: ${PRIV_VALIDATOR_LADDR:=}"
    echo "RPC_LADDR: ${RPC_LADDR:=tcp://0.0.0.0:26657}"
    echo "RPC_CORS: ${RPC_CORS:=*}"
    echo "P2P_LADDR: ${P2P_LADDR:=tcp://0.0.0.0:26656}"
    echo "P2P_EXTERNAL_ADDRESS: ${P2P_EXTERNAL_ADDRESS:=}"
    echo "P2P_INBOUND_PEERS: ${P2P_INBOUND_PEERS:=50}"
    echo "P2P_OUTBOUND_PEERS: ${P2P_OUTBOUND_PEERS:=50}"
    echo "P2P_UNCONDITIONAL_PEERS: ${P2P_UNCONDITIONAL_PEERS:=}"
    echo "P2P_PRIVATE_PEERS: ${P2P_PRIVATE_PEERS:=}"
    echo "TX_INDEX: ${TX_INDEX:=kv}"
    echo "TX_INDEX_PSQL_URL: ${TX_INDEX_PSQL_URL:=}"
    echo "---"
    echo "STATESYNC: ${STATESYNC:=0}"
    echo "STATESYNC_RPC: ${STATESYNC_RPC:=https://rpc-kujira.mintthemoon.xyz:443}"
    echo "STATESYNC_HALT: ${STATESYNC_HALT:=0}"
    echo "STATESYNC_UNSAFE_RESET: ${STATESYNC_UNSAFE_RESET:=0}"
    echo "---"
    echo "SNAPSHOT: ${SNAPSHOT:=0}"
    echo "SNAPSHOT_AUTO: ${SNAPSHOT_AUTO:=0}"
    echo "SNAPSHOT_URL: ${SNAPSHOT_URL:=}"
    echo "SNAPSHOT_DISCOVER_URL: ${SNAPSHOT_DISCOVER_URL:=0}"
    echo "SNAPSHOT_SOURCE_URLS: ${SNAPSHOT_SOURCE_URLS:=https://polkachu.com/tendermint_snapshots/kujira,https://backups.synergynodes.com/snapshot_kujira.php}"
    echo "SNAPSHOT_TYPE: ${SNAPSHOT_TYPE:=tar.lz4}"
    echo "SNAPSHOT_UNSAFE_RESET: ${SNAPSHOT_UNSAFE_RESET:=0}"
    echo "---"
    if [[ "$DEBUG" == "1" ]]; then
        KUJIRAD_ARGS="$KUJIRAD_ARGS --log_level debug"
    fi
}

download_genesis() {
    echo "downloading genesis"
    curl -kfsSL "$GENESIS_URL" -o "$KUJIRAD_HOME/config/genesis.json"
    if [[ $? != 0 ]]; then
        echo "failed to download genesis"
        exit 1
    fi
    genesis_sha256sum=$(sha256sum "$KUJIRAD_HOME/config/genesis.json" | awk '{print $1}')
    if [[ "$GENESIS_SHA256SUM" != "$genesis_sha256sum" ]]; then
        echo "genesis sha256sum mismatch"
        exit 1
    fi
    echo "$KUJIRAD_HOME/config/genesis.json updated from $GENESIS_URL"
}

configure() {
    if [[ "$CONFIGURE" != "1" ]]; then
        return
    fi
    echo "starting configure"
    if [[ ! -f "$KUJIRAD_HOME/config/config.toml" ]]; then
        echo "initializing config"
        kujirad --home "$KUJIRAD_HOME" init "$MONIKER"
    fi
    if [[ ! -f "$KUJIRAD_HOME/config/genesis.json" ]]; then
        echo "missing genesis"
        exit 1
    fi
    genesis_sha256sum=$(sha256sum "$KUJIRAD_HOME/config/genesis.json" | awk '{print $1}')
    if [[ "$GENESIS_SHA256SUM" != "$genesis_sha256sum" ]]; then
        download_genesis
    fi
    echo "configuring $KUJIRAD_HOME/config/config.toml"
    sed -i -E "s|^(priv_validator_laddr[[:space:]]+=[[:space:]]+).*$|\1\"$PRIV_VALIDATOR_LADDR\"| ; \
        /^\[rpc\]/,/^laddr[[:space:]]+=[[:space:]]+.*$/ s|^(laddr[[:space:]]+=[[:space:]]+).*$|\1\"$RPC_LADDR\"| ; \
        s|^(cors_allowed_origins[[:space:]]+=[[:space:]]+).*$|\1\[\"$RPC_CORS\"\]| ; \
        /^\[p2p\]/,/^laddr[[:space:]]+=[[:space:]]+.*$/ s|^(laddr[[:space:]]+=[[:space:]]+).*$|\1\"$P2P_LADDR\"| ; \
        s|^(external_address[[:space:]]+=[[:space:]]+).*$|\1\"$P2P_EXTERNAL_ADDRESS\"| ; \
        s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"$SEEDS\"| ; \
        s|^(persistent_peers[[:space:]]+=[[:space:]]+).*$|\1\"$PEERS\"| ; \
        s|^(unconditional_peer_ids[[:space:]]+=[[:space:]]+).*$|\1\"$P2P_UNCONDITIONAL_PEERS\"| ; \
        s|^(max_num_inbound_peers[[:space:]]+=[[:space:]]+).*$|\1$P2P_INBOUND_PEERS| ; \
        s|^(max_num_outbound_peers[[:space:]]+=[[:space:]]+).*$|\1$P2P_OUTBOUND_PEERS| ; \
        s|^(private_peer_ids[[:space:]]+=[[:space:]]+).*$|\1\"$P2P_PRIVATE_PEERS\"| ; \
        s|^(indexer[[:space:]]+=[[:space:]]+).*$|\1\"$TX_INDEX\"| ; \
        s|^(psql-conn[[:space:]]+=[[:space:]]+).*$|\1\"$TX_INDEX_PSQL_URL\"|" \
        "$KUJIRAD_HOME/config/config.toml"
    echo "configuring $KUJIRAD_HOME/config/app.toml"
    sed -i -E "s|^(minimum-gas-prices[[:space:]]+=[[:space:]]+).*$|\1\"$MIN_GAS_PRICES\"| ; \
        s|^(pruning[[:space:]]+=[[:space:]]+).*$|\1\"$PRUNING\"| ; \
        s|^(pruning-keep-recent[[:space:]]+=[[:space:]]+).*$|\1\"$PRUNING_KEEP_RECENT\"| ; \
        s|^(pruning-keep-every[[:space:]]+=[[:space:]]+).*$|\1\"$PRUNING_KEEP_EVERY\"| ; \
        s|^(pruning-interval[[:space:]]+=[[:space:]]+).*$|\1\"$PRUNING_INTERVAL\"| ; \
        s|^(halt-height[[:space:]]+=[[:space:]]+).*$|\1$HALT_HEIGHT| ; \
        /^\[api\]/,/^enable[[:space:]]+=[[:space:]]+.*$/ s|^(enable[[:space:]]+=[[:space:]]+).*$|\1$API_ENABLE| ; \
        /^\[api\]/,/^address[[:space:]]+=[[:space:]]+.*$/ s|^(address[[:space:]]+=[[:space:]]+).*$|\1\"$API_ADDRESS\"| ; \
        /^\[api\]/,/^enabled-unsafe-cors[[:space:]]+=[[:space:]]+.*$/ s|^(enabled-unsafe-cors[[:space:]]+=[[:space:]]+).*$|\1$API_CORS| ; \
        /^\[grpc\]/,/^enable[[:space:]]+=[[:space:]]+.*$/ s|^(enable[[:space:]]+=[[:space:]]+).*$|\1$GRPC_ENABLE| ; \
        /^\[grpc\]/,/^address[[:space:]]+=[[:space:]]+.*$/ s|^(address[[:space:]]+=[[:space:]]+).*$|\1\"$GRPC_ADDRESS\"| ; \
        /^\[grpc-web\]/,/^enable[[:space:]]+=[[:space:]]+.*$/ s|^(enable[[:space:]]+=[[:space:]]+).*$|\1$GRPC_WEB_ENABLE| ; \
        /^\[grpc-web\]/,/^address[[:space:]]+=[[:space:]]+.*$/ s|^(address[[:space:]]+=[[:space:]]+).*$|\1\"$GRPC_WEB_ADDRESS\"| ; \
        /^\[grpc-web\]/,/^enable-unsafe-cors[[:space:]]+=[[:space:]]+.*$/ s|^(enable-unsafe-cors[[:space:]]+=[[:space:]]+).*$|\1$GRPC_WEB_CORS| ; \
        s|^(snapshot-interval[[:space:]]+=[[:space:]]+).*$|\1$SNAPSHOT_INTERVAL| ; \
        s|^(snapshot-keep-recent[[:space:]]+=[[:space:]]+).*$|\1$SNAPSHOT_KEEP_RECENT| ; \
        s|^(query_gas_limit[[:space:]]+=[[:space:]]+).*$|\1$WASM_QUERY_GAS_LIMIT|" \
        "$KUJIRAD_HOME/config/app.toml"
}

check_config() {
    if [[ ! -f "$KUJIRAD_HOME/config/config.toml" ]]; then
        echo "missing config"
        exit 1
    fi
    if [[ "$DEBUG" == "1" ]]; then
        cat "$KUJIRAD_HOME/config/config.toml"
        cat "$KUJIRAD_HOME/config/app.toml"
    fi
}

unsafe_reset_all() {
    kujirad --home "$KUJIRAD_HOME" tendermint unsafe-reset-all
    rm -rf "$KUJIRAD_HOME/wasm"
}

statesync() {
    if [[ "$STATESYNC" != "1" ]]; then
        return
    fi
    echo "starting statesync"
    if [[ -d "$KUJIRAD_HOME/data/application.db" ]]; then
        if [[ "$STATESYNC_UNSAFE_RESET" != "1" ]]; then
            echo "statesync enabled (STATESYNC=1) but data directory is not clear."
            echo "enable unsafe reset (STATESYNC_UNSAFE_RESET=1) to clear data directory and continue."
            exit 1
        fi
        unsafe_reset_all
    fi
    LATEST_HEIGHT=$(curl -s $STATESYNC_RPC/block | jq -r .result.block.header.height)
    TRUST_HEIGHT=$((LATEST_HEIGHT - 2000))
    TRUST_HASH=$(curl -s "$STATESYNC_RPC/block?height=$TRUST_HEIGHT" | jq -r .result.block_id.hash)
    echo "configuring statesync to height $TRUST_HEIGHT ($TRUST_HASH)"
    sed -i -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
        s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$STATESYNC_RPC,$STATESYNC_RPC\"| ; \
        s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$TRUST_HEIGHT| ; \
        s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" "$KUJIRAD_HOME/config/config.toml"
    if [[ "$STATESYNC_HALT" == "1" ]]; then
        echo "configuring statesync halt at $LATEST_HEIGHT"
        KUJIRAD_ARGS="$KUJIRAD_ARGS --halt-height=$LATEST_HEIGHT"
    fi
}

get_snapshot_url() {
    snapshot_source_url_list=(${SNAPSHOT_SOURCE_URLS//,/ })
    for snapshot_source_url in "${snapshot_source_url_list[@]}"; do
        snapshot_urls=($(curl -fsSL "$snapshot_source_url" | grep -Eo "https://[^[:space:]]+.tar.lz4" | uniq))
        if [ ${#snapshot_urls[@]} -gt 0 ]; then
            echo "${snapshot_urls[0]}"
            return 0
        fi
    done
    echo "failed to discover snapshot url"
    return 1
}

snapshot() {
    if [[ "$SNAPSHOT" != "1" ]]; then
        return
    fi
    if [[ -d "$KUJIRAD_HOME/data/application.db" ]]; then
        if [[ "$SNAPSHOT_AUTO" == "1" ]]; then
            echo "snapshot auto enabled (SNAPSHOT_AUTO=1) and data directory is present, skipping restore."
            return
        fi
        if [[ "$SNAPSHOT_UNSAFE_RESET" != "1" ]]; then
            echo "snapshot enabled (SNAPSHOT=1) but data directory is not clear."
            echo "enable unsafe reset (SNAPSHOT_UNSAFE_RESET=1) to clear data directory and continue."
            exit 1
        fi
        unsafe_reset_all
    fi
    if [[ "$SNAPSHOT_AUTO" == "1" ]]; then
        SNAPSHOT_DISCOVER_URL="1"
    fi
    snapshot_path="/tmp/snapshot.$(openssl rand -hex 8)"
    if [[ -z "$SNAPSHOT_URL" ]] && [[ "$SNAPSHOT_DISCOVER_URL" == "1" ]]; then
        echo "discovering current snapshot url"
        SNAPSHOT_URL=$(get_snapshot_url)
    fi
    echo "downloading snapshot from $SNAPSHOT_URL"
    curl -fSL "$SNAPSHOT_URL" -o "$snapshot_path"
    echo "unpacking $SNAPSHOT_TYPE snapshot"
    if [[ "$SNAPSHOT_TYPE" == "tar.lz4" ]]; then
        which lz4 &> /dev/null || sudo apt install -y lz4
        mkdir -p "$snapshot_path.unpacked"
        lz4 -cd "$snapshot_path"  | tar -xC "$snapshot_path.unpacked"
    else
        echo "unsupported snapshot type: $SNAPSHOT_TYPE"
        exit 1
    fi
    if [[ -d "$snapshot_path.unpacked/data" ]]; then
        snapshot_unpacked_path="$snapshot_path.unpacked"
    else
        snapshot_contents=$(ls "$snapshot_path.unpacked")
        if [[ $(echo "$snapshot_contents" | wc -l) -eq 1 ]]; then
            snapshot_unpacked_path="$snapshot_path.unpacked/$snapshot_contents"
        else
            echo "unable to detect snapshot base directory"
            ls -l "$snapshot_path.unpacked"
            exit 1
        fi
    fi
    if [[ ! -d "$snapshot_unpacked_path/wasm" ]]; then
        echo "snapshot missing wasm directory"
        ls -l "$snapshot_unpacked_path"
        exit 1
    fi
    echo "applying snapshot to $KUJIRAD_HOME"
    cp -r "$snapshot_unpacked_path/data" "$KUJIRAD_HOME/"
    cp -r "$snapshot_unpacked_path/wasm" "$KUJIRAD_HOME/"
    rm -rf "$snapshot_path" "$snapshot_path.unpacked"
}

start() {
    echo "===================="
    echo "mintthemoon/kujirad"
    setup
    configure
    check_config
    statesync
    snapshot
    echo "===================="
    if [[ $# -gt 0 ]]; then
        exec kujirad $KUJIRAD_ARGS $@
    else
        exec kujirad $KUJIRAD_ARGS start
    fi
}

start $@
