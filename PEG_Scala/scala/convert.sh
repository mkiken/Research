#!/usr/bin/env sh

name="A"
inputScala="../testcase/${name}.scala"
jsonScala="${name}.json"
scala_sexp="${name}.scm"
outputScala="${name}_out.scala"
echo "input file is [${inputScala}]\n\n"

node ../parserTestwithFiles.js ${inputScala} > ${jsonScala}
# cat ${jsonScala}
echo "scala -> JSON : [${jsonScala}] output.\n\n"

# racket ../json2sexp.rkt ${jsonScala} > ${scala_sexp}
node ../doJson2Sx.js ${jsonScala} > ${scala_sexp}
cat ${scala_sexp}
echo "JSON -> sexp : [${scala_sexp}] output.\n\n"

# node ../unparserTestwithFiles.js ${jsonScala} > ${outputScala}
# cat ${outputScala}
# echo "JSON -> scala : [${outputScala}] output.\n\n"

echo "done."
