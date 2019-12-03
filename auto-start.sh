#!/bin/bash

# start HDFS
start-dfs.sh
start-yarn.sh

# initialize commands from file
hive -i ./commands.sql

# run commands from file
hive -f ./commands.sql
