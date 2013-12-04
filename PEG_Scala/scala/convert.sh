#!/usr/bin/env sh

name="A"
input_scala="../testcase/${name}.scala"
json_scala="${name}.json"
scala_sexp="${name}.scm"
output_scala="${name}_out.scala"
echo "input file is [${input_scala}]\n\n"

node ../parserTestwithFiles.js ${input_scala} > ${json_scala}
# cat ${json_scala}
echo "scala -> JSON : [${json_scala}] output.\n\n"

# racket ../json2sexp.rkt ${json_scala} > ${scala_sexp}
node ../doJson2Sx.js ${json_scala} > ${scala_sexp}
cat ${scala_sexp}
echo "JSON -> sexp : [${scala_sexp}] output.\n\n"

# node ../unparserTestwithFiles.js ${json_scala} > ${output_scala}
# cat ${output_scala}
# echo "JSON -> scala : [${output_scala}] output.\n\n"

echo "done."
