#!/bin/sh

setup_git() {
  git config --global user.email "travis@travis-ci.org"
  git config --global user.name "Travis CI"
}

commit_website_files() {
  git checkout -b gh-pages
  git add ./_site/
  git commit --message "Travis build: $TRAVIS_BUILD_NUMBER"
}

upload_files() {
  "git remote add origin https://${GITHUB_TOKEN_LIT}@github.com/thelitblog/thelitblog.github.io.git > /dev/null 2>&1"
  git push --quiet --set-upstream origin gh-pages 
}

setup_git
commit_website_files
upload_files