#!/bin/bash
REPO="https://github.com/emberjs/guides.emberjs.com.git"
ROOT=$HOME/build/emberjs/guides
BUILT_FILES=$ROOT/build
DEPLOY=$ROOT/deploy
WEBSITE_FILES=$DEPLOY/guides.emberjs.com

# setup a temp folder to run things out of
mkdir $DEPLOY
cd $DEPLOY

echo "Installing Netlify tools"
npm install netlify-cli -g

git clone $REPO

# get latest version so we can copy our files to the right snapshot dir
cd guides.emberjs.com
latestVersion=`node tasks/get-latest-version.js`
LATEST_VERSION=$WEBSITE_FILES/snapshots/$latestVersion

echo "Will deploy $latestVersion"

cd $DEPLOY

rm -rf $LATEST_VERSION
cp -r $BUILT_FILES $LATEST_VERSION

cd $WEBSITE_FILES

# clean up versions in our built files
node tasks/update-versions.js

cd snapshots

# Need to get permissions / tokens sorted out
# might need to use -t <token-here> for this

currentDir=`pwd`
echo "Deploying from $currentDir"

netlify deploy -s ca5334ce-40e8-4c25-a26a-0d1e36e609c2 -p . -t $NETLIFY_ACCESS_TOKEN
