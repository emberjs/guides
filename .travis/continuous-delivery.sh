#!/bin/bash
REPO="https://github.com/emberjs/guides.emberjs.com.git"
ROOT=$HOME/build/emberjs/guides
BUILT_FILES=$ROOT/build
DEPLOY=$ROOT/deploy
WEBSITE_FILES=$DEPLOY/guides.emberjs.com

# setup a temp folder to run things out of
mkdir $DEPLOY
cd $DEPLOY

echo "Installing Firebase tools for deploys"
npm install firebase-tools@^2.1 -g

git clone $REPO

# get latest version so we can copy our files to the right snapshot dir
cd guides.emberjs.com/snapshots
a=(*/)
tmp=${a[@]: -1} # has a trailing slash we remove below
latestVersion=${tmp%/}

LATEST_VERSION=$WEBSITE_FILES/snapshots/$latestVersion

cd $DEPLOY

rm -rf $LATEST_VERSION
cp -r $BUILT_FILES $LATEST_VERSION

cd $WEBSITE_FILES

# clean up versions in our built files
node tasks/update-versions.js

# do the deploy
firebase deploy -f ember-guides-staging