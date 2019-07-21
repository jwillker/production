#!/usr/bin/env bash

cd ./products && sh ./scripts/copy_discounts_api.sh && cd ..
docker-compose build
docker-compose up