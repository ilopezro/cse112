import scala.collection.mutable.Map
import scala.io.Source
import util.control.Breaks._
import scala.io.StdIn.readInt

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
	    case _ => System.exit(0); return -1 // should really throw an error
    }

    def perform(stmt: Stmt, symTab: Map[String, Double], lineNum: Double): Double = stmt match {
        case Input(in) => {
            var userInput:Int = 0; 
            try{
                userInput = readInt()
            }catch{
                case x : NumberFormatException => {
                    println("Illegal or missing input.")
                    System.exit(0)
                }
            }
            var newInput = userInput.asInstanceOf[Double];
            symTab += (in -> newInput)
            return lineNum;
        }
        case _ => println("idk some error message here"); return -1; 
    }

    def parseExpr(line: Array[String], symTab: Map[String, Double], stmtList: Map[Double, Stmt], counter: Double) = {
        breakable{
            if(line(0) == ""){
                break
            }else if(line(0) == "let"){
                // stmtList += (counter -> Let(line(1)))
            }else if(line(0) == "if"){

            }else if(line(0) == "print"){
                var newLine = line.drop(1)
                var toStr: String = newLine.mkString(" ")

                var newArray: Array[String] = toStr.split(" , ");
                var exprList = List[Expr](); 
                for(i <- newArray){
                    //checks to see if the string is a digit
                    if(i.forall(_.isDigit)){
                        var const = Constant(i.asInstanceOf[Double])
                        exprList += const; 
                    }
                }

                stmtList += (counter -> Print(exprList))
            }else if(line(0) == "input"){
                stmtList += (counter -> Input(line(1)));
            }else if(line(0) contains ":"){
                symTab += (line(0).replaceAll(":", "") -> counter)
            }else{
                println(s"Syntax error on line $counter.")
                System.exit(0)
            }
        }
    }

    def main(args: Array[String]) = {
        var symTable = Map[String, Double]()
        var statementList = Map[Double, Stmt]()
        var lineCounter:Double = 0
        var inputPath:String = ""; 
        
        try{
            inputPath = args(0)
        }catch{
            case x: ArrayIndexOutOfBoundsException => {
                println("Usage: TLI <inputFilePath>")
                System.exit(0)
            }
        }

        val bufferedSource = Source.fromFile(s"./$inputPath")

        for (line <- bufferedSource.getLines) {
            lineCounter += 1
            // parseExpr(line, symTable, statementList, lineCounter)
            var newLine:Array[String] = line.trim().split("\\s+")
            parseExpr(newLine, symTable, statementList, lineCounter)
        }

        var stmtListKeySet = statementList.keySet; 
        var i = 0; 
        
        statementList get 8 match {
            case Some(Input(i)) => perform(Input(i), symTable, 8);
            case _ => println("still debugging")
        }
        // println(stmt)


        //how to get input!! and cast it to a double
        // var age:Int = 0; 
        // try{
        //     age = readInt()
        // }catch{
        //     case x : NumberFormatException => {
        //         println("Illegal or missing input.")
        //         System.exit(0)
        //     }
        // }
        // var ageDub = age.asInstanceOf[Double];

        //how to check if varible is instance of something
        // var v = Var("Hello");
        // println(v.isInstanceOf[Var]);

        bufferedSource.close
        println(symTable)
        println(statementList)
    }
}