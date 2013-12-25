#!/usr/bin/env sh

# if true;
if [ $# -lt 1 ];
then
	echo "find no argument!";
	exit;
fi

# name="let_test"
# name=$1
# inputScala="${name}.scala"
inputScala=$1
name=${inputScala%.*}
jsonScala="${name}.json"
midTree="${name}/1_midtree.json"
Tree="${name}/4_tree.json"
scala_sexp="${name}/5_sform.scm"
expanded_sexp="${name}/6_expanded.scm"
expanded_scala="${name}/7_expanded.scala"
outputScala="${name}_out.scala"
macroParser="${name}/2_macroParser.pegjs"
syncedParser="${name}/3_syncedMacroParser.pegjs"
echo "input file is [${inputScala}]\n\n"

echo "working directory is ${name}."
mkdir ${name}

#ひとまずこれでmidtreeをつくる
echo "${midTree} making..."
echo "node ../compileAndTest.js ${inputScala} > ${midTree}"
node ../compileAndTest.js ${inputScala} > ${midTree}
ret=$?

if test ${ret} -ne 0
then
	exit
fi
echo "scala -> midtree : [${midTree}] output.\n\n"

echo "${macroParser} making..."
echo "node ../makeMacroParser.js ${midTree} > ${macroParser}"
node ../makeMacroParser.js ${midTree} > ${macroParser}
ret=$?

if test ${ret} -ne 0
then
	exit
fi
echo "midtree -> pegjs : [${macroParser}] output.\n\n"

echo "${syncedParser} making..."
cat "../ex-scala.pegjs" > ${syncedParser}
cat ${macroParser} >> ${syncedParser}
echo "pegjs -> pegjs : [${syncedParser}] output.\n\n"

echo "${Tree} making..."
echo "node ../syncAndParse.js ${inputScala} ${syncedParser} > ${Tree}"
node ../syncAndParse.js ${inputScala} ${syncedParser} > ${Tree}
ret=$?
if test ${ret} -ne 0
then
	exit
fi
echo "midtree, pegjs -> tree : [${Tree}] output.\n\n"

echo "${scala_sexp} making..."
echo "node ../doJson2Sx.js ${Tree} > ${scala_sexp}"
node ../doJson2Sx.js ${Tree} > ${scala_sexp}
ret=$?
if test ${ret} -ne 0
then
	exit
fi
echo "tree -> sform(scm) : [${scala_sexp}] output.\n\n"

echo "${expanded_sexp} making..."
# echo "ypsilon ../expand.scm ${scala_sexp} > ${expanded_sexp}"
echo "ypsilon ../expand.scm ${scala_sexp} ${expanded_sexp}"
ypsilon ../expand.scm ${scala_sexp} ${expanded_sexp}
ret=$?
if test ${ret} -ne 0
then
	exit
fi
echo "sform(scm) -> expanded_sform(scm) : [${expanded_sexp}] output.\n\n"

echo "${expanded_scala} making..."
# ypsilon expand.scm ${scala_sexp} > ${expanded_sexp}
echo "node ../doSx2Scala.js ${expanded_sexp} > ${expanded_scala}"
node ../doSx2Scala.js ${expanded_sexp} > ${expanded_scala}
ret=$?
if test ${ret} -ne 0
then
	exit
fi
echo "expanded_sform(scm) -> expanded_scala : [${expanded_scala}] output.\n\n"

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
