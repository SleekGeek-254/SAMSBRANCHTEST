#!/bin/bash

# Prompt the user to select the directory for subtree split
echo "Select the directory for subtree split:"
read selected_directory

# Create a new branch using git subtree split
git subtree split -P "$selected_directory" -b "$selected_directory"

# Move to the new branch
git checkout "$selected_directory"

# Create the subdirectory "$selected_directory" and move contents into it
mkdir "$selected_directory"
shopt -s extglob
mv !(reorganize_after_split.sh) "$selected_directory"/ 2> /dev/null
rm reorganize_after_split.sh

# Commit the changes
git add "$selected_directory"/
git commit -m "Organize structure with '$selected_directory' subdirectory"


# Prompt the user if they want to push the changes to the remote repository
echo "Do you want to push the changes to the remote repository? (y/n)"
read push_response

if [ "$push_response" == "y" ]; then
    # Push changes to the remote repository
    git push origin "$selected_directory"
fi

# Display a message indicating the process is complete
echo "Reorganization after subtree split is complete."ete."
