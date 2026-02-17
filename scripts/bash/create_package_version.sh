# writes the output of this command to a file that can be reviewed in the event of errors
# a package-scratch-def.json file specific to packaging should be substituted when packaging the solution
#   
# NOTES:
#   developer edition dev hub supports 500 unvalidated package version creations per dayand  6 validated package version creations per day
#   validated version creation is not suitable to the API limits of a developer edition dev hub (https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_devhub_package_version_create.htm)
#   --skip-validation should be replaced by --code-coverage
echo "Creating Package Version"
sf package version create --definition-file config/project-scratch-def.json --installation-key-bypass --json --package "Clash Tracker" --code-coverage --target-dev-hub DevHubOrg --wait 40 > packageVersionCreateResults.json

# if version creation times out the version creation request can be retrieved and used in a subsequent call to obtain the results of the package version creation
# sf package version create list --json --target-dev-hub DevHubOrg
# sf package version create report --json --package-create-request-id $PackageVersionCreateRequestId --target-dev-hub DevHubOrg > packageVersionCreateResults.json

# use retrieved SubscriberPackageVersionId
echo "Package Version Report"
subscriberPackageVersionId=$(jq -r .result.SubscriberPackageVersionId packageVersionCreateResults.json)
sf package version report --json --package $subscriberPackageVersionId --target-dev-hub DevHubOrg > packageVersionReport.json