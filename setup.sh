#!/bin/bash
# setup.sh - Guides the user through the Terraform authorization process.

echo "====================================================================="
echo "           Welcome to the MySaaS Google Cloud Integration"
echo "====================================================================="
echo
echo "This script will grant the following READ-ONLY permissions to MySaaS:"
echo "  - BigQuery Data Viewer (roles/bigquery.dataViewer)"
echo "  - Storage Object Viewer (roles/storage.objectViewer)"
echo
echo "Initializing Terraform..."
terraform init -quiet
echo
echo "Terraform will now show you the exact changes to be made."
echo "---------------------------------------------------------------------"

terraform init

# The 'plan' command shows the user what will happen before they approve.
terraform plan

echo "---------------------------------------------------------------------"
read -p "Do you want to apply these changes? (y/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo "Applying changes... this may take a moment."
    # The 'apply' command executes the plan.
    terraform apply -auto-approve
    echo
    echo "✅ Success! Permissions have been granted."
    echo "You can now close this tab and return to the MySaaS application."
else
    echo "❌ Aborted. No changes were made."
fi