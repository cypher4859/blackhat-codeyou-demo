Can't actually push this up to AWS and run it because:
```json
{
    "ImportImageTasks": [
        {
            "Description": "HackMePlease Image",
            "ImportTaskId": "import-ami-03d662b815588205c",
            "SnapshotDetails": [
                {
                    "DiskImageSize": 4676563456.0,
                    "Format": "VMDK",
                    "Status": "completed",
                    "Url": "s3://blackhat-codeyou-demo-terraform-bucket/AMIs/vulnhub/Ubuntu_CTF.ova",
                    "UserBucket": {
                        "S3Bucket": "blackhat-codeyou-demo-terraform-bucket",
                        "S3Key": "AMIs/vulnhub/Ubuntu_CTF.ova"
                    }
                }
            ],
            "Status": "deleted",
            "StatusMessage": "ClientError: Unsupported kernel version 5.8.0-59-generic",
            "Tags": []
        }
    ]
}
```