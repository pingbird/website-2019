#!/usr/bin/env bash
set -e
RED=''
NC=''

rm -rf build
echo "${RED}executing pub build${NC}"
dart pub global run webdev build --release
cd build
echo "${RED}setting up nvm${NC}"
. ~/.nvm/nvm.sh
echo "${RED}invoking nvm${NC}"
nvm use stable
echo "${RED}setting up html minifier${NC}"
npm install html-minifier -g
echo "${RED}copying favicons${NC}"
cp ../ico/* ./
echo "${RED}inlining main.dart.js${NC}"
dart ../inlinemain.dart
echo "${RED}minifying${NC}"
html-minifier index.html --collapse-boolean-attributes --collapse-inline-tag-whitespace --collapse-whitespace --minify-css --minify-js --remove-attribute-quotes --remove-comments --remove-redundant-attributes --remove-script-type-attributes --remove-style-link-type-attributes --remove-tag-whitespace --sort-attributes --sort-class-name -o index.html
echo "${RED}uploading to server${NC}"
rm -r packages .build.manifest .packages build.zip
rsync -r * root@tst.sh:/var/www/html/