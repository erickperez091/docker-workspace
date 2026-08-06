#!/bin/bash
echo "Creando bucket S3..."
awslocal s3api create-bucket --bucket documents
#awslocal s3 cp /tmp/Documents/Cuota_55.pdf s3://documents/

echo "Creando stream Kinesis..."
awslocal kinesis create-stream --stream-name user --shard-count 1
awslocal kinesis create-stream --stream-name test --shard-count 1


echo "Creando tabla DynamoDB para KCL..."
awslocal dynamodb create-table --table-name user-service --attribute-definitions AttributeName=leaseKey,AttributeType=S --key-schema AttributeName=leaseKey,KeyType=HASH --billing-mode PAY_PER_REQUEST


#echo "Seteando ambiente para Kubernetes"
#echo "Creando secrets"
#
#awslocal secretsmanager create-secret --name services/products/database --secret-string file:///opt/aws/secrets/secrets-database-product.json
#awslocal secretsmanager create-secret --name services/products/authentication --secret-string file:///opt/aws/secrets/secrets-jwt.json
#
#awslocal secretsmanager create-secret --name services/user-auth/database --secret-string file:///opt/aws/secrets/secrets-database-user-auth.json
#awslocal secretsmanager create-secret --name services/user-auth/authentication --secret-string file:///opt/aws/secrets/secrets-jwt.json
#
#awslocal secretsmanager create-secret --name services/gateway/authentication --secret-string file:///opt/aws/secrets/secrets-jwt.json
#
#
#echo "Creando roles"
#
#awslocal iam create-role --role-name role-products-secret-reader --assume-role-policy-document file:///opt/aws/iam/trust-policy.json
#awslocal iam create-role --role-name role-user-auth-secret-reader --assume-role-policy-document file:///opt/aws/iam/trust-policy.json
#awslocal iam create-role --role-name role-gateway-secret-reader --assume-role-policy-document file:///opt/aws/iam/trust-policy.json
#awslocal iam create-role --role-name role-products-secret-denied --assume-role-policy-document file:///opt/aws/iam/trust-policy.json
#
#echo "Creando policies"
#
#awslocal iam create-policy --policy-name policy-products-secret-read --policy-document file:///opt/aws/iam/policy-products-secret-read.json
#awslocal iam create-policy --policy-name policy-user-auth-secret-read --policy-document file:///opt/aws/iam/policy-user-auth-secret-read.json
#awslocal iam create-policy --policy-name policy-gateway-secret-read --policy-document file:///opt/aws/iam/policy-gateway-secret-read.json
#
#
#echo "Atachando policies"
#
#awslocal iam attach-role-policy --role-name role-products-secret-reader --policy-arn arn:aws:iam::000000000000:policy/policy-products-secret-read
#awslocal iam attach-role-policy --role-name role-user-auth-secret-reader --policy-arn arn:aws:iam::000000000000:policy/policy-user-auth-secret-read
#awslocal iam attach-role-policy --role-name role-gateway-secret-reader --policy-arn arn:aws:iam::000000000000:policy/policy-gateway-secret-read