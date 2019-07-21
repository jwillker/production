#!/usr/bin/env bash

sbt assembly
docker-compose build
