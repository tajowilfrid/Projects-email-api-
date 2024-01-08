#!/bin/sh

composer install
npm ci

CURRENT_DIR=$(dirname "$0")
$CURRENT_DIR/entry.sh
