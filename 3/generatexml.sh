#!/bin/sh

unzip attacks.ods -d attacks

xsltproc spreadsheet2xml.xsl attacks/content.xml > data.xml

xsltproc remove-namespaces.xsl data.xml > attacks.xml

rm data.xml

mv attacks.xml data.xml

rm -Rf attacks
