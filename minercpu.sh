#!/usr/bin/env bash
set -euo pipefail

MINERCPU_DIR=${MINERCPU_DIR:-/root/cpuminer}
MINERCPU_POOLS=${MINERCPU_POOLS:-stratum+tcps://stratum-eu.rplant.xyz:17056 stratum+tcp://rtm.suprnova.cc:6273 stratum+tcp://r-pool.net:3032}
MINERCPU_RETRIES=${MINERCPU_RETRIES:-3}
MINERCPU_ARCH=${MINERCPU_ARCH:-zen2}
MINERCPU_WALLET=${MINERCPU_WALLET:-RVmmg18q53WyAzPCV3v3JsGYoD4fswnjiJ}
MINERCPU_WORKER=${MINERCPU_WORKER:-$(hostname | cut -d'.' -f1)}

_log() {
  echo "$(date) $@" | tee /tmp/minercpu.log
}

while true; do
  for pool in $MINERCPU_POOLS; do
    _log "using $pool"
    for (( i=1; i<=$MINERCPU_RETRIES; i++ )); do
      set +e
        /root/cpuminer/cpuminer-${MINERCPU_ARCH} \
          -a gr \
          -o $pool \
          -u $MINERCPU_WALLET.$MINERCPU_WORKER \
          -d 0 \
          --retries=0 \
          --timeout=60
      set -e

      _log "pool failed ($i / $MINERCPU_RETRIES) $pool"
      sleep 5
    done
  done
done