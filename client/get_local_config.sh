#!/usr/bin/env bash

platform mount:download -A nextjs -e pr-1 -m deploy --target . -y
rm platformsh.environment 
rm platformsh.installed
rm settings.json
mv platformsh.env .env.local
