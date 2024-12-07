#! /bin/bash

time=$(date +%Y%m%d%H%M%S)
echo Running Node Test at $time

# 1. Download data from pwcd
# url="https://github.com/Kdwkakcs/pwcd/raw/refs/heads/main/all_node.db.gz" # https://raw.githubusercontent.com/Kdwkakcs/pwcd/refs/heads/main/all_node.db.gz
output="https://raw.githubusercontent.com/Kdwkakcs/pwcd/refs/heads/main/all_node.db.gz"

# 2. Run node test based on the downloaded data
savedb="test_node.db.gz"
./singtools node -d $output -s $savedb -c config.json -n 40000

# 3. Remove the downloaded data
rm ./GeoLite2-Country.mmdb ./cache.db diff_nodes.txt.gz
gzip diff_nodes.txt

# 4. commit the result to the remote repository
timeshour=$(date +%H)
datetime=$(date)
echo $timeshour
if [ $timeshour == "12" ]; then
    echo "Remove all commit history"
    git config --global user.email "action@github.com"
    git config --global user.name "GitHub Action"
    git add .
    # remove all commit history
    git checkout --orphan latest_branch
    git add -A
    git commit -m "Update at $datetime"
    git branch -D main
    git branch -m main
    git push -f origin main
else
    git config --global user.email "action@github.com"
    git config --global user.name "GitHub Action"
    git add .
    git commit -m "Update at $datetime"
    git push
fi
