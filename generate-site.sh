#!/bin/sh

# Convert files from markdown to html.
# Output will be in the generated-html directory.

mkdir generated-html
rm -rf generated-html/*

for i in markdown/*.md; do
  pandoc -f markdown -t html $i > html-from-markdown/$(basename $i .md).html
done

for i in images stylesheet-images; do
  cp -r markdown/$i generated-html
done
