#!/bin/bash
echo "Creando bucket S3..."
awslocal s3api create-bucket --bucket documents
#awslocal s3 cp /tmp/Documents/Cuota_55.pdf s3://documents/

