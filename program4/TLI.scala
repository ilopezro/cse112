import scala.collection.mutable.Map
import scala.collection.mutable.ListBuffer
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
case class Print(exprList: ListBuffer[Expr]) extends Stmt

object TLI {
    def eval(expr: Expr, symTab: Map[String, Double], lineNum: Double): Double = expr match {
        case BinOp("+",e1,e2) => {
            return eval(e1,symTab, lineNum) + eval(e2,symTab, lineNum)
        }
        case BinOp("-",e1,e2) => {
            return eval(e1,symTab, lineNum) - eval(e2,symTab, lineNum)
        }
        case BinOp("/",e1,e2) => {
            return eval(e1,symTab, lineNum) / eval(e2,symTab, lineNum)
        } 
        case BinOp("*",e1,e2) => {
            return eval(e1,symTab, lineNum) * eval(e2,symTab, lineNum)
        }
        case Var(expr) => {
            var someVal = symTab get expr match {
                case None =>{
                    println(symTab)
                    println(s"Undefined variable $expr at line $lineNum.")
                    System.exit(0); 
                    return 0; 
                }
                case Some(x: Double) => {
                    return x; 
                }
            }
            return someVal; 
        }
        case Constant(expr) => {
            return expr; 
        }
	    case _ => println(s"something went wrong in eval line $lineNum"); System.exit(0); return -1 // should really throw an error
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
        case Print(list) => {
            var string: String = ""; 
            for(x <- list){
                x match {
                    case Str(str) => {
                        string += str.replaceAll("\"", "")
                    }
                    case Constant(const) =>{
                        string += s"$const"
                    }
                    case Var(v) => {
                        var value = eval(x, symTab, lineNum)
                        string += s"$value"
                    }
                    case _ =>{
                        println("some type of error")
                    }
                }
                string+= " "
            }
            println(string)
            return lineNum;
        }
        case Let(str, expr) =>{
            expr match {
                case Constant(x) => {
                    var dubConst = x.asInstanceOf[Double]
                    symTab += (str -> dubConst)
                }
                case Var(x) => {
                    var value = eval(expr, symTab, lineNum)
                    symTab += (str -> value)
                }
                case BinOp(operator, ex1, ex2)=> {
                    var value = eval(expr, symTab, lineNum);
                    symTab += (str -> value)
                }
            }
            return lineNum; 
        }
        case If(expr, label) => {
            println("hello from if")
            return lineNum;
        }
        case _ => println("idk some error message here"); return -1; 
    }

    def parseExpr(line: Array[String], symTab: Map[String, Double], stmtList: Map[Double, Stmt], counter: Double) = {
        breakable{
            if(line(0) == ""){
                break
            }else if(line(0) == "let"){
                //Let(var, expr)
                var varToInsert = line(1); 
                var restOfExpr = line.drop(2); 
                if(restOfExpr.length == 2){
                    if(restOfExpr(1).forall(_.isDigit)){
                        var const = Constant(restOfExpr(1).toDouble)
                        stmtList += (counter -> Let(varToInsert, const))
                    }else{
                        var variable = Var(restOfExpr(1));
                        stmtList += (counter -> Let(varToInsert, variable))
                    }
                }else if(restOfExpr.length == 4){
                    var leftConst = Constant(0); 
                    var leftVar = Var("");
                    var rightConst = Constant(0);
                    var rightVar = Var("")
                    var isLeftVar = false; 
                    var isRigthVar = false; 
                    if(restOfExpr(1).forall(_.isDigit)){
                        leftConst = Constant(restOfExpr(1).toDouble)
                    }else{
                        leftVar = Var(restOfExpr(1))
                        isLeftVar = true; 
                    }
                    if(restOfExpr(3).forall(_.isDigit)){
                        rightConst = Constant(restOfExpr(3).toDouble)
                    }else{
                        rightVar = Var(restOfExpr(3))
                        isRigthVar = true; 
                    }

                    if(isLeftVar && isRigthVar){
                        var binaryOp = BinOp(restOfExpr(2), leftVar, rightVar)
                        stmtList += (counter -> Let(varToInsert, binaryOp))
                    }else if(isLeftVar){
                        var binaryOp = BinOp(restOfExpr(2), leftVar, rightConst)
                        stmtList += (counter -> Let(varToInsert, binaryOp))
                    }else if(isRigthVar){
                        var binaryOp = BinOp(restOfExpr(2), leftConst, rightVar)
                        stmtList += (counter -> Let(varToInsert, binaryOp))
                    }else{
                        var binaryOp = BinOp(restOfExpr(2), leftConst, rightConst)
                        stmtList += (counter -> Let(varToInsert, binaryOp))
                    }
                }else{
                    println(s"Syntax error on line $counter.")
                    System.exit(0)
                }
            }else if(line(0) == "if"){

            }else if(line(0) == "print"){
                var newLine = line.drop(1)
                var toStr: String = newLine.mkString(" ")

                var newArray: Array[String] = toStr.split(" , ");
                var exprList = ListBuffer[Expr]();
                for(i <- newArray){
                    //checks to see if the string is a digit
                    if(i.forall(_.isDigit)){
                        var newDub = i.toDouble
                        var const = Constant(newDub)
                        exprList += const;  
                    }else if(i.contains("\"")){
                        exprList += Str(i)
                    }else{
                        exprList += Var(i)
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

        for(i <- stmtListKeySet) { 
            Some(statementList(i)) match {
                case Some(Input(x)) => perform(Input(x), symTable, i);
                case Some(Print(list)) => perform(Print(list), symTable, i);
                case Some(Let(str, expr)) => perform(Let(str, expr), symTable, i)
                case _ => println("still debugging")
            }
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
        // println(symTable)
        // println(statementList)
    }
}
