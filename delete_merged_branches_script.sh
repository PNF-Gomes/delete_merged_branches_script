#!/bin/bash

# Fetch the latest info from the remote
git fetch origin

# Change 'master' to whatever branch you want to check against (e.g., 'main')
BASE_BRANCH="master"

# List remote branches
REMOTE_BRANCHES=$(git branch -r | grep -v "$BASE_BRANCH" | sed 's/origin\///' | tr -d ' ')

# Check each branch if it has been merged/rebased/squashed
TO_DELETE=""
for branch in $REMOTE_BRANCHES; do
    # Check if the tip of the branch is in the main branch's history
    if git merge-base --is-ancestor origin/$branch $BASE_BRANCH; then
        TO_DELETE="$TO_DELETE $branch"
    fi
done

echo "Merged, rebased, or squashed branches:"
echo "$TO_DELETE"

# Ask user for confirmation
read -p "Are you sure you want to delete these branches? (y/N) " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]
then
    for branch in $TO_DELETE
    do
        echo "Deleting branch $branch"
        git push origin --delete $branch
    done
else
    echo "No branches were deleted."
fi

