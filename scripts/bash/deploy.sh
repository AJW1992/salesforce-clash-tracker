echo "Deploying Metadata to Org"
sf project deploy start --json --source-dir clash-tracker --target-org TargetOrg > deployResults.json