#!/usr/bin/env bash

echo '{"jsonrpc": "2.0", "method": "Input.ExecuteAction", "params": {"action": "pause"}, "id": 1}' | nc localhost 9090 -q 0 | jq
