#!/bin/bash
# setup.sh - Guides the user through the Terraform authorization process,
# now with interactive project selection.

echo "====================================================================="
echo "           Welcome to the MySaaS Google Cloud Integration"
echo "====================================================================="
echo

# --- NEW: Interactive Project Selection Logic ---

# First, try to get the configured default project.
PROJECT_ID=$(gcloud config get-value project 2>/dev/null)

# If no default project is set, begin the interactive selection.
if [[ -z "$PROJECT_ID" ]]; then
    echo "No default project is set. Fetching available projects..."
    
    # Get a list of project IDs into a bash array.
    PROJECT_LIST=($(gcloud projects list --format="value(projectId)" --sort-by=projectId))

    # Check if the user has any projects at all.
    if [ ${#PROJECT_LIST[@]} -eq 0 ]; then
        echo "❌ ERROR: Your Google Account does not have access to any Google Cloud projects."
        echo "Please create or get access to a project, then restart this process."
        exit 1
    fi

    echo "Please choose the project you wish to use with MySaaS:"
    
    # Use a 'select' loop to present the menu to the user.
    # PS3 is the prompt that the user will see.
    PS3="Enter the number of your choice: "
    select choice in "${PROJECT_LIST[@]}" "Quit"; do
        case "$choice" in
            "Quit")
                echo "❌ Aborted by user."
                exit 0
                ;;
            *)
                # If the choice is not empty, it's a valid project.
                if [[ -n "$choice" ]]; then
                    PROJECT_ID=$choice
                    break # Exit the select loop.
                else
                    echo "Invalid selection. Please enter a number from the list."
                fi
                ;;
        esac
    done
fi
# --- END NEW SECTION ---


echo
echo "✅ Using project: $PROJECT_ID"
echo
echo "This script will grant the following READ-ONLY permissions to project '$PROJECT_ID':"
echo "  - BigQuery Data Viewer (roles/bigquery.dataViewer)"
echo "  - Storage Object Viewer (roles/storage.objectViewer)"
echo
echo "Initializing Terraform..."
terraform init -quiet > /dev/null
echo
echo "Terraform will now show you the exact changes to be made."
echo "---------------------------------------------------------------------"

terraform plan -var="project_id=$PROJECT_ID"

echo "---------------------------------------------------------------------"
read -p "Do you want to apply these changes? (y/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo "Applying changes... this may take a moment."
    terraform apply -auto-approve -var="project_id=$PROJECT_ID"
    echo
    echo "✅ Success! Permissions have been granted to project '$PROJECT_ID'."
    echo "You can now close this tab and return to the MySaaS application."
else
    echo "❌ Aborted. No changes were made."
fi