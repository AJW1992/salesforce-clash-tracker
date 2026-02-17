echo "Logging into Salesforce Dev Hub Org"
mkdir keys
echo $CLASH_TRACKER_DEVOPS_PK | base64 -di > keys/server.key

sf org login jwt --alias DevHubOrg --client-id $CLASH_TRACKER_DEVOPS_CLIENT_ID --json --jwt-key-file keys/server.key --set-default-dev-hub --username $CLASH_TRACKER_DEVHUB_USERNAME > loginDevHubResults.json