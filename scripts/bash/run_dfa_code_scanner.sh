echo "Install SFDX Scanner"
echo -e 'y/n' | sf plugins install @salesforce/sfdx-scanner

echo "Running Salesforce Graph Engine Scanner (DFA)"
# only target specific classes/methods for dfa scans, very memory intensive
sf scanner run dfa --format json --outfile dfaCodeScannerAnalysis.json --target "/home/circleci/project/clash-tracker/main/default/classes/SPECIFIC_CLASS_OR_METHOD" --projectdir "/home/circleci/project/clash-tracker/main/default/**"