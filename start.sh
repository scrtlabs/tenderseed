#!/usr/bin/env sh

if [ ! -z "$TENDERSEED_NODE_KEY" ]
then
  echo $TENDERSEED_NODE_KEY > /data/.tenderseed/config/node_key.json
fi

tenderseed start