#!/bin/bash

# Prompt the user to select the directory for subtree split
echo "Which branch would you like to merge:"
read selected_branch


git checkout master

# Prompt the user if they want to push the changes to the remote repository
echo "Do you want to merge the changes to from branch repository? (y/n) "
read merge_response

if [ "$merge_response" == "y" ] || [ "$merge_response" == "Y" ]; then
    # Merge changes from the specified branch into master
    git merge --allow-unrelated-histories -X theirs "$selected_branch"

    # Commit the changes
    git add "$selected_branch"/
    git commit -m "Merge "$selected_branch" into Master branch"

    # Prompt the user if they want to push the changes to the remote repository
    echo "Do you want to push the changes to the remote repository? (y/n)"
    read push_response

    if [ "$push_response" == "y" ]; then
        # Push changes to the remote repository
        git push origin master
    fi
fi

# Display a message indicating the process is complete
echo "Merge Complete"
