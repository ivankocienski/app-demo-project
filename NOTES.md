# Notes

## Merging project repos

This project started as two separate repos.

Importing happened following [this guide.](https://stackoverflow.com/questions/1683531/how-to-import-existing-git-repository-into-another)

Steps taken were
```bash
mkdir app-demo-project
cd app-demo-project
git init
# <readme>

# back end
git remote add other-backend /home/ivan/dev/go/src/api-demo/
git fetch other-backend
git checkout -b other-backend-branch other-backend/main
mkdir back-end
mv * back-end/
git add .
git commit -m "back-end imported"
git checkout main
git merge other-backend-branch --allow-unrelated-histories

# front end
git remote add other-frontend /home/ivan/dev/elm/api-demo-frontend/
git fetch other-frontend
git checkout -b other-frontend-branch other-frontend/main
mkdir front-end
mv * front-end/
git add .
git commit -m "back-end imported"
git checkout main
git merge other-frontend-branch --allow-unrelated-histories


# clean up
git remote rm other-backend
git branch -d other-backend-branch

git remote rm other-frontend
git branch -d other-frontend-branch

```

