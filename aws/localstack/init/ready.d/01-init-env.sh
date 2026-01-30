#!/bin/bash
echo "Creando bucket S3..."
awslocal s3api create-bucket --bucket documents
#awslocal s3 cp /tmp/Documents/Cuota_55.pdf s3://documents/

echo "Creando stream Kinesis..."
awslocal kinesis create-stream --stream-name user --shard-count 1
awslocal kinesis create-stream --stream-name test --shard-count 1


echo "Creando tabla DynamoDB para KCL..."
awslocal dynamodb create-table --table-name user-service --attribute-definitions AttributeName=leaseKey,AttributeType=S --key-schema AttributeName=leaseKey,KeyType=HASH --billing-mode PAY_PER_REQUEST