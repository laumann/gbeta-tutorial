#!/bin/sh
# Creates TAGS files for this current (pwd) gbeta project folder

echo "Creating TAGS file"
cd src
rgx='/\(\|.*[^a-zA-Z_0-9]\)\([a-zA-Z_][a-zA-Z_0-9][a-zA-Z_0-9]+\):/\2/'
files=$(find . -name \*.bet -type f | grep -ve /Base/)
etags -l none --regex=$rgx $files 2>/dev/null
cd ..

