#!/bin/sh
# Credit: https://gist.github.com/willprice/e07efd73fb7f13f917ea

setup_git() {
  git config --global user.email "travis@travis-ci.org"
  git config --global user.name "Travis CI"
}

repo(){
git clone https://github.com/thelitblog/thelitblog.github.io.git && cd thelitblog.github.io && /bin/rm -rf * && cp -r ../_site/ . && ls
}


commit(){
  dateAndMonth=`date "+%b %Y"`
  cd thelitblog.github.io && git checkout inverse && ls && git add -f . && git commit -m "Travis update: $dateAndMonth (Build $TRAVIS_BUILD_NUMBER)" -m "[skip ci]"
  # Create a new commit with a custom build message
  # with "[skip ci]" to avoid a build loop
  # and Travis build number for reference
}

upload_files() {
  # Remove existing "origin"
  cd thelitblog.github.io && git remote rm origin && git remote add origin https://dopewind:${GITHUB_TOKEN}@github.com/thelitblog/ > /dev/null 2>&1 && git push origin inverse --quiet --force
  # Add new "origin" with access token in the git URL for authentication
}


setup_git
repo
commit

# Attempt to commit to git only if "git commit" succeeded
if [ $? -eq 0 ]; then
  echo "Uploading to GitHub"
  upload_files
else
  echo "Nothing to do"
fi
