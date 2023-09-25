#!/bin/bash

# Fetch the latest info from the remote
git fetch

# Change 'master' to whatever branch you want to check against (e.g., 'main')
BASE_BRANCH="main"

# List branches that have been merged into master or whose tip is in master (indicating a potential rebase)
MERGED_OR_REBASED_BRANCHES=$(git branch -r --merged $BASE_BRANCH | grep -v "$BASE_BRANCH" | sed 's/origin\///' | tr -d ' ')

echo "Merged or potentially rebased branches:"
echo "$MERGED_OR_REBASED_BRANCHES"

# Ask user for confirmation
read -p "Are you sure you want to delete these branches? (y/N) " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]
then
    for branch in $MERGED_OR_REBASED_BRANCHES
    do
        echo "Deleting branch $branch"
        git push origin --delete $branch
    done
else
    echo "No branches were deleted."
fi

