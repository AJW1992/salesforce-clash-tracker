echo "Deploying Metadata to Org and Running Tests"
sf project deploy start --json --source-dir clash-tracker --target-org TargetOrg > deployResults.json

echo "Testing Code in Org"
sf apex run test --json --code-coverage --test-level RunLocalTests --output-dir test-results --result-format tap --wait 30 --target-org TargetOrg > testRunResults.json