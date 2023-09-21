#!/bin/bash
<<INFO
PROJECT: 智能补丁使用和管理
Author: wangguangge 00804212
Date: 2023-09-14
EC_S:
INFO

ip2=$1

function test_14() {
        local threshold=14
        if [ $threshold -le $progress ]; then
                return
        fi

        if [ `rpm -q mysql-server | grep mysql-server- | wc -L` -gt 0 ]; then
                progress=$threshold
        fi
}

function test_28() {
        local threshold=28
        if [ $threshold -le $progress ]; then
                return
        fi

        if [ `rpm -q redis | grep redis- | wc -L` -gt 0 ]; then
                progress=$threshold
        fi
}

function test_42() {
        local threshold=42
        if [ $threshold -le $progress ]; then
                return
        fi

        if [ `rpm -q aops-zeus | grep aops-zeus- | wc -L` -gt 0 ]; then
                progress=$threshold
        fi
}

function test_56() {
        local threshold=56
        if [ $threshold -le $progress ]; then
                return
        fi

        if [ `rpm -q aops-hermes | grep aops-hermes- | wc -L` -gt 0 ]; then
                progress=$threshold
        fi
}

function test_70() {
        local threshold=70
        if [ $threshold -le $progress ]; then
                return
        fi

        if [ `rpm -q elasticsearch | grep elasticsearch- | wc -L` -gt 0 ]; then
                progress=$threshold
        fi
}

function test_84() {
        local threshold=84
        if [ $threshold -le $progress ]; then
                return
        fi

        if [ `rpm -q aops-apollo | grep aops-apollo- | wc -L` -gt 0 ]; then
                progress=$threshold
        fi
}

function test_100() {
        local threshold=100
        if [ $threshold -le $progress ]; then
                return
        fi

        progress=$threshold

}

function start_test() {
        while true; do
                progress=0
                test_14
                test_28
                test_42
                test_56
                test_70
                test_84
                test_100
                if [ $progress -gt $result ]; then
                        result=$progress
                        curl http://21.21.0.211:8888/api/sandbox/progress/update/$result
                fi
                sleep 5s
        done
}

result=0
start_test
