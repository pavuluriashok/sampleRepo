{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "KMSKeypermission",
            "Effect": "Allow",
            "Action": [
                "kms:Encrypt",
                "kms:Decrypt",
                "kms:ReEncrypt*",
                "kms:GenerateDataKey*",
                "kms:DescribeKey"
            ],
            "Resource": [
                "arn:aws:kms:us-east-1::*"
            ]
        }
    ]
}