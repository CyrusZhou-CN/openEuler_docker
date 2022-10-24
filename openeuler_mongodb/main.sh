#!/bin/bash

/opt/mongodb/bin/mongod -f /opt/mongodb/conf/mongodb.conf
echo -e "\033[32m ==> START SUCCESSFUL ... \033[0m"
mongod -v
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
service mysqld stop
echo "==> STOP SUCCESSFUL ..."