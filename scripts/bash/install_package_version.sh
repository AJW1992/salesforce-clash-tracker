echo "Installing Package Version"

# --package should be obtained from project-json.file or package version creation results from current pipeline
# --installation-key should be maintained in an environment variable or removed if the version has no installation key
echo "Package Version Report"
echo y | sf package install --installation-key $installationKey --json --package $packageAliasOrSubscriberPackageVersionId --target-org TargetOrg --wait 30 > packageInstallationResults.json

# if installation times out the installation request can be retrieved and used in a subsequent call to obtain the results of the installation
# sf package install report --json --request-id $packageInstallationId --target-org TargetOrg