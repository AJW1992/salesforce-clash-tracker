# using scratch orgs is not suited to developer edition orgs due to API limits
#   LIMITS
#   3 active scratch orgs
#   6 daily scratch org creations
#
# scratch org alias should be variable based on some unique criteria (i.e. branch name, name of developer, etc.)
# how to manage the lifecycle of scratch orgs will depend on org editions and specific project needs
#
# this implementation makes efficient use of the limits within developer edition orgs but is not designed to scale up for usage by larger development teams
echo "Requesting Scratch Org from Dev Hub"
sf data query --file scripts/soql/activescratchorg.soql --json --target-org DevHubOrg > activeScratchOrgQueryResults.json

activeScratchOrgCount=$(jq -r .result.totalSize activeScratchOrgQueryResults.json)

if [ "$activeScratchOrgCount" -eq 0 ]
then
    echo "No Active Scratch Org Found"
    echo "Creating New Scratch Org..."
    sf org create scratch --alias TargetOrg --definition-file config/custom-scratch-def.json --json --no-namespace --target-dev-hub DevHubOrg --wait 30 > scratchOrgCreateResults.json
else
    username=$(jq -r .result.records[0].SignupUsername activeScratchOrgQueryResults.json)
    echo "Logging into Scratch Org"
    sf org login jwt --alias TargetOrg --client-id $CLASH_TRACKER_DEVOPS_CLIENT_ID --json --jwt-key-file keys/server.key --username $username > loginScratchResults.json
fi