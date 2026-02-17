echo "Logging into Salesforce Build Org"
mkdir keys
echo $CLASH_TRACKER_DEVOPS_PK | base64 -di > keys/server.key

# NOTE: no build org established or corresponding environment variable for $CLASH_TRACKER_BUILD_USERNAME
sf org login jwt --alias TargetOrg --client-id $CLASH_TRACKER_DEVOPS_CLIENT_ID --json --jwt-key-file keys/server.key --username $CLASH_TRACKER_BUILD_USERNAME > loginBuildResults.json