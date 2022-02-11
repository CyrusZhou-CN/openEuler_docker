#!/bin/bash
if [ -n "$BIND" ]; then
        sed -i "s/bind 127.0.0.1.*/bind $BIND/g" /usr/local/redis/bin/redis.conf
fi
sed -i 's/daemonize no/daemonize yes/g' /usr/local/redis/bin/redis.conf

/usr/local/redis/bin/redis-server /usr/local/redis/bin/redis.conf
redis-server -v
echo -e "\033[32m ==> START SUCCESSFUL ... \033[0m"
waitterm() {
        local PID
        # any process to block
        tail -f /dev/null &
        PID="$!"
        # setup trap, could do nothing, or just kill the blocker
        trap "kill -TERM ${PID}" TERM INT
        # wait for signal, ignore wait exit code
        wait "${PID}" || true
        # clear trap
        trap - TERM INT
        # wait blocker, ignore blocker exit code
        wait "${PID}" 2>/dev/null || true
}
waitterm

echo "==> STOP"
pkill redis-server
echo "==> STOP SUCCESSFUL ..."