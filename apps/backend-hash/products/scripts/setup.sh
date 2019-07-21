#!/usr/bin/env bash

sh ./scripts/copy_discounts_api.sh
yarn install
docker-compose build
