#!/usr/bin/env sh

# 发生错误时终止
set -e

# 构建
hexo clean
hexo generate

# 进入构建文件夹
cd public

git init
git add -A
git commit -m 'deploy'

# 如果你要部署在 https://<USERNAME>.github.io/<REPO>
git push -f git@github.com:lidengkedev/books.git master:gh-pages

cd -