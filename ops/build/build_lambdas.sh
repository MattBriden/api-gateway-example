#!/bin/bash

set -e

SRC_DIR=$(cd ../../src && pwd)

rm -rf "$SRC_DIR"/api/target/
rm -rf "$SRC_DIR"/authorizer/target/

API_DIR="$SRC_DIR"/api/
AUTH_DIR="$SRC_DIR"/authorizer/

cd "$API_DIR"
mkdir target
zip target/api.zip python/api.py

cd "$AUTH_DIR"
mkdir target
zip target/authorizer.zip python/authorizer.py

cd "$SRC_DIR"

aws s3 cp "$SRC_DIR"/api/target/api.zip s3://briden-lambda-bucket/v1/api.zip
aws s3 cp "$SRC_DIR"/authorizer/target/authorizer.zip s3://briden-lambda-bucket/v1/authorizer.zip