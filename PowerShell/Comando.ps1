git branch -r | ForEach-Object {
    # Skip default branch, this script assumes
    # you already checked-out that branch when cloned the repo
    if (-not ($_ -match " -> ")) {
        $localBranch = ($_ -replace "^.*/", "")
        $remoteBranch = $_.Trim()
        #git branch --track "$localBranch" "$remoteBranch" --quiet
        git checkout "$localBranch" --quiet
    }
}
git fetch --all
git pull --all