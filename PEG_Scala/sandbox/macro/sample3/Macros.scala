import scala.language.experimental.macros
import scala.reflect.macros.Context
//import java.io.File


object Macros{
  // def file(param: String) = macro file_impl
  // def file_impl(c: Context)(param:c.Expr[String]): c.Expr[java.io.File] = {
  //   import c.universe._
  //   reify{new java.io.File(param.splice)}
  // }

  // def readFile(param: java.io.File) = macro readFile_impl
  // def readFile_impl(c: Context)(param:c.Expr[java.io.File]) = {
  //   import c.universe._
  //   reify{new java.io.BufferedReader( new java.io.FileReader(param.splice))}
  // }

  // def readFile(param: String) = macro readFileString_impl
  // def readFileString_impl(c: Context)(param:c.Expr[String]) = {
  //   import c.universe._
  //   reify{new java.io.BufferedReader( new java.io.FileReader(new java.io.File(param.splice)))}
  // }

  def printWriter(param: java.io.File) = macro printWriter_impl
  def printWriter_impl(c: Context)(param:c.Expr[java.io.File]) = {
    import c.universe._
    reify{new java.io.PrintWriter(new java.io.BufferedWriter( new java.io.FileWriter(param.splice)))}
  }

  // def printWriter(param: String) = macro printWriterString_impl
  // def printWriterString_impl(c: Context)(param:c.Expr[String]) = {
  //   import c.universe._
  //   reify{new java.io.PrintWriter(new java.io.BufferedWriter( new java.io.FileWriter(new java.io.File(param.splice))))}
  // }
}
