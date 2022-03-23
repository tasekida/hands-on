---
title: hands on
type: docs
---

# このhands onについて
  
  
このhands onは私のノート、言い方を変えると備忘録です。
  
忘れた時に見るのでhands on形式にしたいと思っています。

## hugo-book
  
このサイトは静的サイトジェネレーター[hugo](https://gohugo.io/)を使っています。
  
テーマは[hugo-book](https://themes.gohugo.io/themes/hugo-book/)を使っています。

## install
  
WSL2のUbuntu20.04を使用
  
```tpl
apt -y install hugo
hugo new site hands-on
cd hands-on
git init
git submodule add https://github.com/alex-shpak/hugo-book themes/hugo-book
echo theme = \"hugo-book\" >> config.toml
cp -R themes/hugo-book/exampleSite/content .
hugo server --minify --theme hugo-book
```
