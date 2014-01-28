#!/usr/bin/env sh

if [ $# -lt 1 ];
then
	echo "find no argument!";
	exit;
fi

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

echo "${midTree} making..."
# echo "node ${SCALAX_HOME}/experiment/makeMidtree.js ${inputScala} > ${midTree}"
node ${SCALAX_HOME}/experiment/makeMidtree.js ${inputScala} > ${midTree}
ret=$?
if test ${ret} -ne 0
then
	exit
fi
# echo "scala -> midtree : [${midTree}] output.\n\n"

echo "${macroParser} making..."
# echo "node ${SCALAX_HOME}/experiment/makeMacroParser.js ${midTree} > ${macroParser}"
node ${SCALAX_HOME}/experiment/makeMacroParser.js ${midTree} > ${macroParser}
ret=$?
if test ${ret} -ne 0
then
	exit
fi
# echo "midtree -> pegjs : [${macroParser}] output.\n\n"

echo "${syncedParser} making..."
cat "${SCALAX_HOME}/experiment/scala-parser.pegjs" > ${syncedParser}
cat ${macroParser} >> ${syncedParser}
# echo "pegjs -> pegjs : [${syncedParser}] output.\n\n"

echo "${Tree} making..."
# echo "node ${SCALAX_HOME}/experiment/makeTree.js ${inputScala} ${syncedParser} > ${Tree}"
node ${SCALAX_HOME}/experiment/makeTree.js ${inputScala} ${syncedParser} > ${Tree}
ret=$?
if test ${ret} -ne 0
then
	exit
fi
# echo "midtree, pegjs -> tree : [${Tree}] output.\n\n"

echo "${scala_sexp} making..."
# echo "node ${SCALAX_HOME}/experiment/doJson2Sx.js ${Tree} > ${scala_sexp}"
node ${SCALAX_HOME}/experiment/doJson2Sx.js ${Tree} > ${scala_sexp}
ret=$?
if test ${ret} -ne 0
then
	exit
fi
# echo "tree -> sform(scm) : [${scala_sexp}] output.\n\n"

echo "${expanded_sexp} making..."
ypsilon ${SCALAX_HOME}/experiment/expand.scm ${scala_sexp} ${expanded_sexp}
# echo "ypsilon ${SCALAX_HOME}/experiment/expand.scm ${scala_sexp} ${expanded_sexp}"
ret=$?
if test ${ret} -ne 0
then
	exit
fi
# echo "sform(scm) -> expanded_sform(scm) : [${expanded_sexp}] output.\n\n"

echo "${expanded_scala} making..."
node ${SCALAX_HOME}/experiment/doSx2Scala.js ${expanded_sexp} > ${expanded_scala}
# echo "node ${SCALAX_HOME}/experiment/doSx2Scala.js ${expanded_sexp} > ${expanded_scala}"
ret=$?
if test ${ret} -ne 0
then
	exit
fi
# echo "expanded_sform(scm) -> expanded_scala : [${expanded_scala}] output.\n\n"

echo "done."

