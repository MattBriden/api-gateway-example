#!/bin/bash

set -e

SRC_DIR=$(cd ../../src && pwd)

rm -rf "$SRC_DIR"/api/target/
rm -rf "$SRC_DIR"/authorizer/target/

mkdir "$SRC_DIR"/api/target/
mkdir "$SRC_DIR"/authorizer/target/

zip "$SRC_DIR"/api/target/api.zip "$SRC_DIR"/api/python/api.py
zip "$SRC_DIR"/authorizer/target/authorizer.zip "$SRC_DIR"/authorizer/python/authorizer.py

aws s3 cp "$SRC_DIR"/api/target/api.zip s3://briden-lambda-bucket/v1/api.zip
aws s3 cp "$SRC_DIR"/authorizer/target/authorizer.zip s3://briden-lambda-bucket/v1/authorizer.zip