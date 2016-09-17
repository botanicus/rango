#!/bin/sh

ab -kc 100 -t 20 http://127.0.0.1:4001/ > results.txt
ab -kc 100 -t 20 http://127.0.0.1:4002/ >> results.txt
ab -kc 100 -t 20 http://127.0.0.1:4003/ >> results.txt
ab -kc 100 -t 20 http://127.0.0.1:4004/ >> results.txt
# ab -kc 100 -t 20 http://127.0.0.1:4005/ >> results.txt
