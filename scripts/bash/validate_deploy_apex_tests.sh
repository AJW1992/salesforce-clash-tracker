# --dry-run deployment can be swapped for sf project deploy validate to obtain a quick-deploy id for future deployment
echo "Validating Deployment of Metadata to Org and Running Tests"
sf project deploy start --dry-run --json --source-dir clash-tracker --target-org TargetOrg --test-level RunLocalTests --wait 40 > validateDeployResults.json