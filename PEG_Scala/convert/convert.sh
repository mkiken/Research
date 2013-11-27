#!/usr/bin/env sh

# EXJS environment varialbe should point to the path of the "ex-js" directory
# export EXJS=/Users/morikensuke/Desktop/macroTest/js-macro/ex-js
# export NODE_PATH=$NODE_PATH:/opt/local/lib/node_modules:$EXJS
# export YPSILON_LOADPATH=$YPSILON_LOADPATH:$EXJS

#echo "EXJS is"
#echo $EXJS


# if [ ! $# -eq 1 ]
# then
    # echo "Expected 1 argument, but got $# arguments"
    # exit 1
# fi

# input_js=$1

# dir=`dirname $input_js`
# converted_dir=$dir/converted
# base=`basename -s .js $input_js`
# treefile=$converted_dir/$base.tree
# sformfile=$converted_dir/$base-sform.scm
# expandedfile=$converted_dir/$base-expanded.*

# time $EXJS/make_exjs_tree.js $input_js &&
# time $EXJS/convert-json-simple.scm $treefile &&
# time $EXJS/expand-scm-simple.scm $sformfile &&
# chmod 644 $expandedfile

name="A"
input_scala="../testcase/${name}.scala"
json_scala="${name}.json"
scala_sexp="${name}.scm"
output_scala="${name}_out.scala"
echo "input file is [${input_scala}]\n\n"

node ../parserTestwithFiles.js ${input_scala} > ${json_scala}
# cat ${json_scala}
echo "scala -> JSON : [${json_scala}] output.\n\n"

racket ../json2sexp.rkt ${json_scala} > ${scala_sexp}
echo "JSON -> sexp : [${scala_sexp}] output.\n\n"

node ../unparserTestwithFiles.js ${json_scala} > ${output_scala}
cat ${output_scala}
echo "JSON -> scala : [${output_scala}] output.\n\n"

echo "done."
