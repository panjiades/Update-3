#!/bin/bash
ps -A | grep -v grep | grep "on" > /dev/null

if [ $? -eq 0 ]; then
bash ~/dialog
else
 bash on
fi