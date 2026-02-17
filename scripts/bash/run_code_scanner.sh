echo "Install SFDX Scanner"
echo -e 'y/n' | sf plugins install @salesforce/sfdx-scanner

echo "Performing Static Code Analysis"
# explicitly set the prefix path portion; recursive top-down directory scanning can easily exhaust memory in the VM or container
sf scanner run --category Security --engine pmd --outfile staticCodeAnalysis.json --target "/home/circleci/project/clash-tracker/main/default/classes/**"

# TODO: migrate to sf code-analyzer run (currently in beta)
# sf code-analyzer run --output-file codeScannerAnalysis.json --severity-threshold 3 --workspace "/home/circleci/project/clash-tracker/main/default/**"