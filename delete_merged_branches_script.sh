#!/bin/bash

# Fetch the latest info from the remote
git fetch

# Change 'master' to whatever branch you want to check against (e.g., 'main')
BASE_BRANCH="main"

# List branches not merged into master
UNMERGED_BRANCHES=$(git branch -r --no-merged $BASE_BRANCH | grep -v "$BASE_BRANCH" | sed 's/origin\///' | tr -d ' ')

echo "Unmerged branches:"
echo "$UNMERGED_BRANCHES"

# Ask user for confirmation
read -p "Are you sure you want to delete these branches? (y/N) " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]
then
    for branch in $UNMERGED_BRANCHES
    do
        echo "Deleting branch $branch"
        git push origin --delete $branch
    done
else
    echo "No branches were deleted."
fi
