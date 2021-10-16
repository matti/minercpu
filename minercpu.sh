#!/usr/bin/env bash
set -euo pipefail

cmd=${1:-}
handled=yes
case "${cmd}" in
  update)
    curl https://raw.githubusercontent.com/matti/minercpu/main/minercpu.sh -o /root/minercpu.new
    chmod +x /root/minercpu.new
    diff /root/minercpu.sh /root/minercpu.new
  ;;
  crontab)
    if crontab -l; then
      old_crontab=$(crontab -l)
    else
      old_crontab=""
    fi

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
  tune|arch)
    cpu=$($0 cpu)
    case "$cpu" in
      "Intel(R) Core(TM) i5-10400F CPU @ 2.90GHz")
        case $cmd in
          arch)
            echo "avx2"
          ;;
          tune)
            echo """0 0 0 0 0 0
0 0 2 1 0 0
0 2 2 1 0 0
2 0 2 1 0 0
0 0 0 0 0 0
0 0 0 0 0 0
0 0 0 0 0 0
0 2 0 1 0 0
2 0 0 1 0 0
2 2 0 1 0 0
0 0 0 0 0 0
0 0 0 0 0 0
1 0 0 0 0 0
0 2 2 0 0 0
2 0 2 0 0 0
2 2 2 0 0 0
0 0 0 0 0 0
0 0 0 0 0 0
0 0 0 0 0 0
2 2 0 0 0 0"""
          ;;
        esac
      ;;
      "AMD Ryzen 9 3900 12-Core Processor")
        case $cmd in
          arch)
            echo "zen2"
          ;;
          tune)
            echo """0 0 2 2 0 0
0 0 2 2 1 0
0 2 2 2 0 0
1 0 2 2 0 0
0 0 0 2 2 0
0 2 0 2 0 0
2 0 0 2 0 0
0 2 0 2 1 0
2 0 0 2 1 0
1 2 0 2 0 0
0 0 2 0 2 0
0 2 2 0 0 0
1 0 2 0 0 0
0 2 2 0 1 0
1 0 2 0 1 0
1 2 2 0 0 0
0 1 0 0 2 0
2 0 0 0 2 0
2 2 0 0 0 0
1 2 0 0 1 0"""
          ;;
        esac
      ;;
      "AMD Ryzen 5 4600G with Radeon Graphics")
        case $cmd in
          arch)
            echo "zen2"
          ;;
          tune)
            echo """0 0 0 0 0 0
0 0 0 0 0 0
0 1 1 1 0 0
1 0 0 1 0 0
0 0 0 0 0 0
0 0 0 0 0 0
1 0 0 0 0 0
0 0 0 0 0 0
0 0 0 0 0 0
1 0 0 1 0 0
0 0 0 0 0 0
0 0 0 0 0 0
0 0 0 0 0 0
0 1 0 0 0 0
0 0 0 0 0 0
1 1 2 0 0 0
0 1 0 0 0 0
0 0 0 0 0 0
0 0 0 0 0 0
0 0 0 0 0 0"""
          ;;
        esac
      ;;
      "AMD Ryzen Threadripper 3960X 24-Core Processor")
        case $cmd in
          arch)
            echo "zen2"
          ;;
          tune)
        echo """0 0 2 0 0 1 0 1
0 0 2 0 0 1 0 2
0 0 2 1 2 0 0 0
0 0 2 1 2 0 0 0
0 2 2 2 0 0 1 0
0 2 2 2 0 0 1 0
2 0 2 2 0 0 1 0
2 0 2 2 0 0 1 0
0 0 0 2 2 0 0 0
0 0 0 2 2 0 0 0
0 2 0 2 0 0 1 0
0 2 0 2 0 0 1 0
0 0 0 0 0 1 0 0
2 0 0 2 0 0 1 0
0 2 0 1 2 0 0 0
0 1 0 1 2 0 0 0
2 0 0 1 2 0 0 1
1 0 0 1 2 0 0 0
2 2 0 2 0 0 1 0
2 2 0 2 0 0 0 0
0 0 2 0 2 0 0 0
0 0 2 0 2 0 0 0
0 2 2 0 0 0 1 0
0 2 2 0 0 0 1 0
2 0 2 0 0 0 1 0
2 0 2 0 0 0 1 0
0 0 2 0 2 0 0 0
0 2 1 0 2 0 0 0
0 0 2 0 2 0 0 0
0 0 2 0 2 0 0 0
2 2 2 0 0 0 1 0
2 2 2 0 0 0 1 0
0 2 0 0 2 0 0 0
0 2 0 0 2 0 0 0
2 0 0 0 2 0 0 0
2 0 0 0 2 0 0 0
2 2 0 0 0 0 1 0
2 2 0 0 0 0 1 0
0 0 0 0 2 0 0 0
0 0 0 0 2 0 0 0"""
          ;;
        esac
      ;;
      "AMD Ryzen 9 5950X 16-Core Processor")
        case $cmd in
          arch)
            echo "zen3"
          ;;
          tune)
        echo """0 0 2 2 0 0 1 0
0 0 2 2 0 0 1 0
0 0 2 2 1 0 1 0
0 0 2 2 1 0 1 0
0 2 2 2 0 0 1 0
0 2 2 2 0 0 1 0
1 0 2 2 0 0 1 0
1 0 2 2 0 0 1 0
0 0 0 2 1 0 0 0
0 0 0 2 1 0 1 0
0 2 0 2 0 0 1 0
0 2 0 2 0 0 1 0
2 0 0 2 0 0 0 0
1 0 0 2 0 0 1 0
0 2 0 2 1 0 1 1
0 2 0 2 1 0 1 1
1 0 0 2 1 0 1 0
1 0 0 2 1 0 1 0
1 2 0 2 0 0 1 0
1 2 0 2 0 0 0 0
0 0 2 0 1 0 1 0
0 0 2 0 1 0 1 0
0 1 2 0 0 0 1 0
0 2 2 0 0 0 1 0
2 0 2 0 0 0 1 0
1 0 2 0 0 0 1 0
0 2 2 0 1 0 1 0
0 2 2 0 1 0 1 0
1 0 2 0 1 0 0 0
1 0 2 0 1 0 1 0
1 2 2 0 0 0 1 0
1 2 2 0 0 0 1 0
0 2 0 0 1 0 0 0
0 2 0 0 1 0 1 0
1 0 0 0 1 0 0 0
1 0 0 0 1 0 0 0
1 2 0 0 0 0 1 0
1 2 0 0 0 0 0 0
1 2 0 0 1 0 1 0
1 2 0 0 1 0 1 0"""
          ;;
        esac
      ;;
      "AMD Ryzen 5 3600 6-Core Processor")
        case $cmd in
          arch)
            echo "zen2"
          ;;
          tune)
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
          ;;
        esac
      ;;
      *)
        case $cmd in
          arch)
            case $cpu in
              *AMD*)
                echo "zen2"
              ;;
              *Intel*)
                echo "avx2"
              ;;
              *)
                echo "unknown"
              ;;
            esac
          ;;
          tune)
            echo ""
          ;;
        esac
      ;;
    esac
  ;;
  *)
    handled=no
  ;;
esac
[ "$handled" = "yes" ] && exit 0

if [ -f "/root/minercpu.env" ]; then
  eval $(cat /root/minercpu.env)
fi


MINERCPU_CPUMINER=${MINERCPU_CPUMINER:-/root/cpuminer}
MINERCPU_POOLS=${MINERCPU_POOLS:-stratum+tcps://eu.flockpool.com:5555}
MINERCPU_RETRIES=${MINERCPU_RETRIES:-3}
MINERCPU_ARCH=${MINERCPU_ARCH:-$(/root/minercpu.sh arch)}
MINERCPU_WALLET=${MINERCPU_WALLET:-RQP3wfYx9ob6xyhs2TQ6T3FngH9xjF7XzA}
MINERCPU_WORKER=${MINERCPU_WORKER:-$(hostname | cut -d'.' -f1)}
MINERCPU_THREADS=${MINERCPU_THREADS:-$(nproc)}
MINERCPU_PRECMD=${MINERCPU_PRECMD:-:}
MINERCPU_REBOOT=${MINERCPU_REBOOT:-no}

echo """
export MINERCPU_CPUMINER='${MINERCPU_CPUMINER}'
export MINERCPU_POOLS='${MINERCPU_POOLS}'
export MINERCPU_RETRIES='${MINERCPU_RETRIES}'
export MINERCPU_ARCH='${MINERCPU_ARCH}'
export MINERCPU_WALLET='${MINERCPU_WALLET}'
export MINERCPU_WORKER='${MINERCPU_WORKER}'
export MINERCPU_THREADS='${MINERCPU_THREADS}'
export MINERCPU_PRECMD='${MINERCPU_PRECMD}'
""" > /root/minercpu.env

_term() {
  exit 0
}
trap _term TERM INT

_log() {
  echo "$(date) $@" | tee -a /root/minercpu.log
}

case "${cmd}" in
  version)
    echo "0.1.0"
  ;;
  uninstall)
    set +e
      screen_id=$(screen -ls | grep .minercpu | cut -f 2 | cut -d. -f1)
      if [ "$screen_id" != "" ]; then
        screen -XS "$screen_id" quit
      fi

      rm -rf "${MINERCPU_CPUMINER}"
      rm -rf /root/minercpu.env
      rm -rf /root/minercpu.log
      rm -rf /root/minercpu.sh
      rm -rf /root/tune_config
      crontab -l | grep -v "minercpu" | crontab
    set -e
  ;;
  reinstall)
    rm -rf "${MINERCPU_CPUMINER}"
    exec $0 install
  ;;
  install)
    export PAGER=""

    for package in libjansson-dev libnuma-dev screen; do
      dpkg -l $package || apt update && apt install -y $package
    done

    if [ ! -e "${MINERCPU_CPUMINER}" ]; then
      curl -L --fail -o /tmp/cpuminer.tar.gz https://github.com/WyvernTKC/cpuminer-gr-avx2/releases/download/1.2.2/cpuminer-gr-1.2.2-x86_64_linux.tar.gz
      tar -xvof /tmp/cpuminer.tar.gz
      mv cpuminer-gr-1.2.2-x86_64_linux "${MINERCPU_CPUMINER}"
    fi
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
  *)
    $MINERCPU_PRECMD

    (
      while true; do
        set +e
          summary_output=$(echo "summary" | nc localhost 4048 | tr -d '\0')
        set -e
        if [ "$summary_output" != "" ]; then
          hashes=$(echo $summary_output | cut -d';' -f7 | cut -d'=' -f2)
          temp=$(echo $summary_output | cut -d';' -f14 | cut -d'=' -f2)
          freq=$(echo $summary_output | cut -d';' -f16 | cut -d'=' -f2)
          echo "-- minercpu -- hashes: ${hashes} temp: ${temp}c freq: $freq"
        fi

        sleep 10
      done
    ) &

    while true; do
      for pool in $MINERCPU_POOLS; do
        _log "using $pool"
        for (( i=1; i<=$MINERCPU_RETRIES; i++ )); do
          set +e
            $MINERCPU_CPUMINER/binaries/cpuminer-${MINERCPU_ARCH} \
              -a gr \
              -o $pool \
              -u $MINERCPU_WALLET.$MINERCPU_WORKER \
              -d 0 \
              --retries=0 \
              --timeout=60 \
              --threads=$MINERCPU_THREADS \
              --tune-full \
              --api-bind=127.0.0.1:4048
          set -e

          _log "pool failed ($i / $MINERCPU_RETRIES) $pool"
          sleep 5
        done
      done

      if [ "$MINERCPU_REBOOT" = "yes" ]; then
        curl --max-time 3 --silent -o /dev/null --fail -L 1.1.1.1 || /sbin/reboot
      fi
    done
  ;;
esac