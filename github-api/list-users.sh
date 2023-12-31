#!/bin/bash

####################################
# Author: Goutham Bitra
# Date: 21-10-2023
# About: This script lists the users with read access to a GitHub repository.
# Input: You need to export your GitHub username and token.
#        Example: export username="GouthamBitra", export token="ghp_*****"
#        You should pass two arguments while executing the script, e.g.: ./list-users.sh "REPO_OWNER" "REPO_NAME"
#
######################################

# GitHub API URL
API_URL="https://api.github.com"

# GitHub username and personal access token
USERNAME="$username"
TOKEN="$token"

# User and Repository information
REPO_OWNER="$1"
REPO_NAME="$2"

# Function to make a GET request to the GitHub API
github_api_get() {
  local endpoint="$1"
  local url="${API_URL}/${endpoint}"

  # Send a GET request to GitHub API with authentication
  curl -s -u "${USERNAME}:${TOKEN}" "${url}"
}

# Function to list users with read access to the repository
list_users_with_read_access() {
  local endpoint="repos/${REPO_OWNER}/${REPO_NAME}/collaborators"

  # Fetch the list of collaborators on the repository
  collaborators="$(github_api_get "$endpoint" | jq -r '.[] | select(.permissions.pull == true) | .login')"

  # Display the list of collaborators with read access
  if [[ -z "$collaborators" ]]; then
    echo "No users with read access found for ${REPO_OWNER}/${REPO_NAME}."
  else
    echo "Users with read access to ${REPO_OWNER}/${REPO_NAME}:"
    echo "$collaborators"
  fi
}

# Function to provide usage instructions
helper() {
  expected_cmd_args=2
  if [ $# -ne $expected_cmd_args ]; then
    echo "Usage: ./list-users.sh <REPO_OWNER> <REPO_NAME>"
    exit 1
  fi
}

# Check the number of command-line arguments
helper "$@"

# Main script
echo "Listing users with read access to ${REPO_OWNER}/${REPO_NAME}..."
list_users_with_read_access
