#!/bin/bash

FILES=$(find . -type f -name "*.adoc")

for i in $FILES; do
  FILENAME=$(basename $i .adoc);
#  asciidoc -b docbook $i;
#  pandoc -f docbook -t markdown_strict "${i/adoc/xml}" -o "${i/adoc/md}";
  asciidoctor -b docbook -a leveloffset=+1 -o - $i | pandoc  --atx-headers  --wrap=preserve -t markdown_github --atx-headers -f docbook - >  "${i/adoc/md}"
  sed -i "1s/^/---\n/" "${i/adoc/md}"
  sed -i "1s/^/id: ${FILENAME}\n/" "${i/adoc/md}" 
  sed -i "1s/^/title: ${FILENAME}\n/" "${i/adoc/md}"
  sed -i "1s/^/---\n/" "${i/adoc/md}"
  sed -i "s/\.adoc//g" "${i/adoc/md}"
done
