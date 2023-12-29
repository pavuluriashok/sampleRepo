{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "s3AllowModify",
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:PutObject",
                "s3:DeleteObject"
            ],
            "Resource": [
                "arn:aws:s3:::ta-wpdata-*",
                "arn:aws:s3:::ta-wpdata-*/*"
            ]
        }
    ]
}