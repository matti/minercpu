#!/usr/bin/env bash
set -euo pipefail

MINERCPU_CPUMINER=${MINERCPU_CPUMINER:-/root/cpuminer}
MINERCPU_POOLS=${MINERCPU_POOLS:-stratum+tcps://stratum-eu.rplant.xyz:17056 stratum+tcp://rtm.suprnova.cc:6273 stratum+tcp://r-pool.net:3032}
MINERCPU_RETRIES=${MINERCPU_RETRIES:-3}
MINERCPU_ARCH=${MINERCPU_ARCH:-zen2}
MINERCPU_WALLET=${MINERCPU_WALLET:-RVmmg18q53WyAzPCV3v3JsGYoD4fswnjiJ}
MINERCPU_WORKER=${MINERCPU_WORKER:-$(hostname | cut -d'.' -f1)}

_log() {
  echo "$(date) $@" | tee /tmp/minercpu.log
}

case ${1:-} in
  update)
    curl https://raw.githubusercontent.com/matti/minercpu/main/minercpu.sh -o /root/minercpu.sh
    chmod +x /root/minercpu.sh
  ;;
  install)
    apt-get update && apt-get install \
      libjansson-dev libnuma-dev screen
  ;;
  crontab)
    old_crontab=$(crontab -l)

    case $old_crontab in
      *minercpu.sh*)
        exit 0
      ;;
    esac

    printf "${old_crontab}\n@reboot screen -dmS minercpu /root/minercpu.sh\n" | crontab
  ;;
  run)
    $0 install
    $0 crontab
    exec $0
  ;;
  *)
    while true; do
      for pool in $MINERCPU_POOLS; do
        _log "using $pool"
        for (( i=1; i<=$MINERCPU_RETRIES; i++ )); do
          set +e
            $MINERCPU_CPUMINER/cpuminer-${MINERCPU_ARCH} \
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
  ;;
esac

