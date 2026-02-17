echo "Executing Post Deploy Operations in Org"

targetOrg=$1
# expose as secure environment variables for use in pipelines
clashDeveloperEmail=$2
clashDeveloperPwd=$3

echo "Beginning Anonymous Apex Processes"
echo "Assigning permission set..."
sf apex run --json --file scripts/apex/assignPermSet.apex --target-org $targetOrg > output/assignPermSet.json
echo "done"

echo "Initializing clash developer credential..."
echo "CredentialsService.createClashDeveloperCredential('$clashDeveloperEmail', '$clashDeveloperPwd');" > output/initClashDeveloperCredential.apex
sf apex run --json --file output/initClashDeveloperCredential.apex --target-org $targetOrg > output/initClashDeveloperCredential.json
echo "done"

echo "Initializing clash api credential"
sf apex run --json --file scripts/apex/initApiKeyCredential.apex --target-org $targetOrg > output/initApiKeyCredential.json
echo "done"
echo "Finished Anonymous Apex Processes"

echo "Importing Data"
sf data tree import --files --json data/Clan__c.json --target-org $targetOrg > output/clanImport.json
echo "Finished Post Deploy Operations in Org"