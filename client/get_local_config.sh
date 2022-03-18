#!/usr/bin/env bash

platform mount:download -A nextjs -m deploy --target . -y
rm platformsh.environment 
rm platformsh.installed
mv platformsh.env .env.local
