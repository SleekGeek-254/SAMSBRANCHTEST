#!/bin/bash

# Prompt the user to select the directory for subtree split
echo "Select the directory for subtree split:"
read selected_directory

# Create a new branch using git subtree split
git subtree split -P "$selected_directory" -b "$selected_directory"

# Check if the branch was created successfully
if [ $? -eq 0 ]; then
    # Move to the new branch
    git checkout "$selected_directory"

    # Check if the branch already exists
    if git show-branch "$selected_directory" &> /dev/null; then
        echo "Branch '$selected_directory' already exists. Exiting."
        exit 1
    fi

    # Create the subdirectory "$selected_directory" and move contents into it
    mkdir "${selected_directory}"
    shopt -s extglob
    mv !(reorganize_after_split.sh) "${selected_directory}"/ 2> /dev/null

    # Remove everything in the root directory except the specified subdirectory
    shopt -s extglob
    rm -r !("${selected_directory}")

    # Commit the changes
    git add "${selected_directory}"/
    git commit -m "Organize structure with '${selected_directory}' subdirectory"

    # Prompt the user if they want to push the changes to the remote repository
    echo "Do you want to push the changes to the remote repository? (y/n)"
    read push_response

    if [ "$push_response" == "y" ]; then
        # Push changes to the remote repository
        git push origin "${selected_directory}"
    fi

    # Display a message indicating the process is complete
    echo "Reorganization after subtree split is complete."
else
    echo "Subtree split failed. Exiting."
fi
