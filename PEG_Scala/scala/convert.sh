#!/usr/bin/env sh

# name="A"
name="let_test"
inputScala="${name}.scala"
jsonScala="${name}.json"
midTree="${name}.midtree"
Tree="${name}.tree"
scala_sexp="${name}.scm"
outputScala="${name}_out.scala"
macroParser="${name}_macroParser.pegjs"
echo "input file is [${inputScala}]\n\n"

#ひとまずこれでmidtreeをつくる
node ../compileAndTest.js ${inputScala} > ${midTree}
echo "scala -> midtree : [${midTree}] output.\n\n"

node ../makeMacroParser.js ${midTree} > ${macroParser}
echo "midtree -> pegjs : [${macroParser}] output.\n\n"

node ../syncAndParse.js ${inputScala} "../ex-scala.pegjs" ${macroParser} > ${Tree}
echo "midtree, pegjs -> tree : [${Tree}] output.\n\n"


# node ../parserTestwithFiles.js ${inputScala} > ${jsonScala}
# cat ${jsonScala}
# echo "scala -> JSON : [${jsonScala}] output.\n\n"

# racket ../json2sexp.rkt ${jsonScala} > ${scala_sexp}
# node ../doJson2Sx.js ${jsonScala} > ${scala_sexp}
# cat ${scala_sexp}
# echo "JSON -> sexp : [${scala_sexp}] output.\n\n"

# node ../unparserTestwithFiles.js ${jsonScala} > ${outputScala}
# cat ${outputScala}
# echo "JSON -> scala : [${outputScala}] output.\n\n"

echo "done."
