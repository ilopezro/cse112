import scala.collection.mutable.Map
import scala.io.Source
import util.control.Breaks._

abstract class Expr
case class Var(name: String) extends Expr
case class Str(name: String) extends Expr
case class Constant(num: Double) extends Expr
case class BinOp(operator: String, left: Expr, right: Expr) extends Expr

abstract class Stmt
case class Let(variable: String, expr: Expr) extends Stmt
case class If(expr: Expr, label: String) extends Stmt
case class Input(variable: String) extends Stmt
case class Print(exprList: List[Expr]) extends Stmt

object TLI {
    def eval(expr: Expr, symTab: Map[String, Double], lineNum: Double): Double = expr match {
        case BinOp("+",e1,e2) => eval(e1,symTab, lineNum) + eval(e2,symTab, lineNum) 
        case Var(expr) => println("expr"); return 1
        case Constant(expr) => println("num"); return 1
	    case _ => return -1 // should really throw an error
    }

    def parseExpr(line: Array[String], symTab: Map[String, Double], stmtList: Map[Double, Expr], counter: Double) = {
        breakable{
            if(line(0) == ""){
                println("empty line on line " + counter)
                break
            }else{
                println(line(0) + " " + counter)
            }
        }
        
    }

    def main(args: Array[String]) = {
        var symTable = Map[String, Double]()
        var statementList = Map[Double, Expr]()
        var lineCounter:Double = 0

        val bufferedSource = Source.fromFile("./in")
        for (line <- bufferedSource.getLines) {
            lineCounter += 1
            // parseExpr(line, symTable, statementList, lineCounter)
            var newLine:Array[String] = line.trim().split("\\s+")
            symTable += (newLine(0) -> lineCounter);
            parseExpr(newLine, symTable, statementList, lineCounter)
        }
        bufferedSource.close
        println(symTable)
    }
}