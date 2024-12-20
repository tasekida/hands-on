---
title: hands on
type: docs
date: 2022-05-18T00:00:00+09:00
---

# このページについて  
このページは私のノート、言い方を変えると備忘録です。  
忘れた時に見るつもりなので、hands on形式にします。
## hugo-book  
このページは静的サイトジェネレーター[hugo](https://gohugo.io/)を使っています。  
テーマは[hugo-book](https://themes.gohugo.io/themes/hugo-book/)を使っています。  
## install  
WSL2のUbuntu20.04を使用  
```tpl
brew install hugo
hugo new site hands-on
cd hands-on
git init
git submodule add https://github.com/alex-shpak/hugo-book themes/hugo-book
echo theme = \"hugo-book\" >> config.toml
echo .settings >> .gitignore
echo .hugo_build.lock >> .gitignore
echo .gitmodules >> .gitignore
echo public/ >> .gitignore
echo themes/ >> .gitignore
hugo server --minify --theme hugo-book
hugo
git add .
git commit -m "first commit"
git push -u origin main
```
