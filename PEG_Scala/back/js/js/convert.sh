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

name="let"
input_js="./${name}.js"
expanded_json=${name}.json
sx_js="${name}.scm"
js_sexp="${name}.scm"
output_js="${name}_out.js"
echo "input file is [${input_js}]\n\n"

node ../../doJson2Sx.js ${expanded_json} > ${sx_js}
cat ${sx_js}
echo "JSON -> sx : [${sx_js}] output.\n\n"

# racket ../json2sexp.rkt ${sx_js} > ${js_sexp}
# echo "sx -> sexp[macro-expand] : [${js_sexp}] output.\n\n"

# node ../../sx2js.js ${sx_js} > ${output_js}
# cat ${output_js}
# echo "sexp[macro-expand] -> JS : [${output_js}] output.\n\n"

echo "done."
