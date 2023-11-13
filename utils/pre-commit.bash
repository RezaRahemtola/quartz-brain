IFS=$'\n'

for file in $(git grep -l --cached -G '^publish: false$') ; do
    git rm --cached $file
done
