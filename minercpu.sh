#!/usr/bin/env bash
set -euo pipefail

MINERCPU_CPUMINER=${MINERCPU_CPUMINER:-/root/cpuminer}
MINERCPU_POOLS=${MINERCPU_POOLS:-stratum+tcp://rtm.suprnova.cc:6273 stratum+tcps://stratum-eu.rplant.xyz:17056 stratum+tcp://r-pool.net:3032}
MINERCPU_RETRIES=${MINERCPU_RETRIES:-3}
MINERCPU_ARCH=${MINERCPU_ARCH:-zen2}
MINERCPU_WALLET=${MINERCPU_WALLET:-RVmmg18q53WyAzPCV3v3JsGYoD4fswnjiJ}
MINERCPU_WORKER=${MINERCPU_WORKER:-$(hostname | cut -d'.' -f1)}
MINERCPU_THREADS=${MINERCPU_THREADS:-$(nproc)}
MINERCPU_PRECMD=${MINERCPU_PRECMD:-:}

_term() {
  exit 0
}
trap _term TERM INT

_log() {
  echo "$(date) $@" | tee /tmp/minercpu.log
}

cmd=${1:-}

case "${cmd}" in
  update)
    curl https://raw.githubusercontent.com/matti/minercpu/main/minercpu.sh -o /root/minercpu.sh
    chmod +x /root/minercpu.sh
  ;;
  install)
    for package in libjansson-dev libnuma-dev screen; do
      dpkg -l $package || apt update && apt install -y $package
    done
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
  cpu)
    cat /proc/cpuinfo | grep "model name" | uniq | cut -d: -f2 | xargs
  ;;
  run|daemon)
    $0 install
    $0 crontab
    [ ! -f /root/tune_config ] && $0 tune > /root/tune_config
    case "${cmd}" in
      run)
        exec screen -mS minercpu /root/minercpu.sh
      ;;
      daemon)
        screen -dmS minercpu /root/minercpu.sh
      ;;
    esac
  ;;
  tune)
    case $($0 cpu) in
      "AMD Ryzen Threadripper 3960X 24-Core Processor")
        echo """0 0 2 2 0 0
0 0 1 1 2 0
0 2 2 2 0 0
2 0 2 2 0 0
0 0 0 2 2 0
0 2 0 2 0 0
2 0 0 2 0 0
0 2 0 2 1 0
2 0 0 2 1 0
2 2 0 2 0 0
0 0 2 0 2 0
0 2 2 0 0 0
1 0 2 0 0 0
0 2 2 0 1 0
2 0 2 0 1 0
2 2 2 0 0 0
0 2 0 0 2 0
2 0 0 0 2 0
2 2 0 0 0 0
1 2 0 0 1 0"""
      ;;
      "AMD Ryzen 9 5950X 16-Core Processor")
        echo """0 0 2 2 0 0
0 0 2 2 1 0
0 2 2 2 0 0
1 0 2 2 0 0
0 0 0 2 1 0
0 2 0 2 0 0
1 0 0 2 0 0
0 2 0 2 1 0
1 0 0 2 1 0
1 2 0 2 0 0
0 0 2 0 1 0
0 2 2 0 0 0
1 0 2 0 0 0
0 2 2 0 1 0
1 0 2 0 1 0
1 2 2 0 0 0
0 2 0 0 1 0
1 0 0 0 1 0
1 2 0 0 0 0
1 2 0 0 1 0"""
      ;;
      "AMD Ryzen 5 3600 6-Core Processor")
        echo """0 0 2 2 0 0
0 0 2 2 1 0
0 2 2 2 0 0
2 0 2 2 0 0
0 0 0 2 2 0
0 2 0 2 0 0
2 0 0 2 0 0
0 2 0 2 1 0
2 0 0 2 1 0
2 2 0 2 0 0
0 0 2 0 2 0
0 2 2 0 0 0
1 0 2 0 0 0
0 2 2 0 1 0
1 0 2 0 1 0
2 2 2 0 0 0
0 2 0 0 2 0
1 0 0 0 2 0
2 2 0 0 0 0
2 2 0 0 1 0"""
    esac
  ;;
  *)
    $MINERCPU_PRECMD

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
              --timeout=60 \
              --threads=$MINERCPU_THREADS \
              --tune-full
          set -e

          _log "pool failed ($i / $MINERCPU_RETRIES) $pool"
          sleep 5
        done
      done
    done
  ;;
esac

