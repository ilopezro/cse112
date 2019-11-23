#! /usr/bin/env python3
import fileinput
import sys

# used to store a parsed TL expressions which are
# constant numbers, constant strings, variable names, and binary expressions
class Expr :
    def __init__(self,op1,operator,op2=None):
        self.op1 = op1
        self.operator = operator
        self.op2 = op2

    def __str__(self):
        if self.op2 == None:
            return self.operator + " " + self.op1
        else:
            return self.op1 + " " + self.operator + " " +  self.op2

    # evaluate this expression given the environment of the symTable
    def eval(self, symTable, lineNum):
        if self.operator == "var":
            return symTable[self.op1]
        elif self.operator == "+":
            return self.op1 + self.op2
        elif self.operator == "-":
            return self.op1 - self.op2
        elif self.operator == "*":
            return self.op1 * self.op2
        elif self.operator == "/":
            return self.op1 / self.op2
        elif self.operator == "<":
            return self.op1 < self.op2
        elif self.operator == ">":
            return self.op1 > self.op2
        elif self.operator == "<=":
            return self.op1 <= self.op2
        elif self.operator == ">=":
            return self.op1 >= self.op2
        elif self.operator == "==":
            return self.op1 == self.op2
        elif self.operator == "!=":
            return self.op1 != self.op2
        else:
            sys.exit("Syntax error on line " + str(lineNum))
    
# used to store a parsed TL statement
class Stmt :
    def __init__(self,keyword,exprs):
        self.keyword = keyword
        self.exprs = exprs

    def __str__(self):
        others = ""
        for exp in self.exprs:
            others = others + " " + str(exp)
        return self.keyword + others

    # perform/execute this statement given the environment of the symTable
    def perform(self, symTable, lineNum):
        # print ("Doing: " + str(self))
        if self.keyword == "input":
            try:
                userInput = float(input())
            except:
                sys.exit("Illegal or missing input")
            valueToAdd = {self.exprs[0]: float(userInput)}
            symTable.update(valueToAdd)
            return lineNum
        elif self.keyword == "print":
            stringToPrint = ""
            quoteCounter = 0
            for item in self.exprs:
                if "\"" in item:
                    quoteCounter += 1
                    if(quoteCounter % 2 == 0):
                        stringToPrint += item.strip("\"") + " "
                        continue
                if quoteCounter % 2 != 0:
                    stringToPrint += item.strip("\"") + " "
                
                if quoteCounter % 2 == 0 and not("," in item):
                    try:
                        float(item)
                        stringToPrint += str(float(item)) + " "
                    except:
                        expressionToEval = Expr(item, "var")
                        try:
                            result = expressionToEval.eval(symTable, lineNum)
                            stringToPrint += str(result) + " "
                        except:
                            sys.exit("Invalid call for variable at line " + str(lineNum))
            print(stringToPrint)
            return lineNum
        elif self.keyword == "let":
            if len(self.exprs) > 5:
                sys.exit("Syntax error on line " + str(lineNum))
            elif len(self.exprs) > 3: # expression
                op1, operator, op2 = self.exprs[2], self.exprs[3], self.exprs[4]
                val1 = symTable.get(op1)
                val2 = symTable.get(op2)
                if(val1 is None):
                    try:
                        float(self.exprs[2])
                        val1 = float(self.exprs[2])
                    except:
                        sys.exit("Undefined variable " + self.exprs[2] + " at line " + str(lineNum))
                if(val2 is None):
                    try:
                        float(self.exprs[4])
                        val2 = float(self.exprs[4])
                    except:
                        sys.exit("Undefined variable " + self.exprs[4] + " at line " + str(lineNum))
                exprToEval = Expr(val1, operator, val2)
                result = exprToEval.eval(symTable, lineNum)
                del self.exprs[2:5]
                self.exprs.append(result)
                self.perform(symTable, lineNum)
            elif len(self.exprs) < 2:
                sys.exit("Syntax error on line " + str(lineNum))
            else: #assignment
                val = symTable.get(self.exprs[2])
                if(val is None):
                    val = float(self.exprs[2])
                toAdd = {self.exprs[0] : val}
                symTable.update(toAdd)
            return lineNum
            
def parseExpr(line, statementList, symTable, counter):
    if len(line) == 0:
        return
    if(line[0] == "let" or line[0] == "if" or line[0] == "print" or line[0] == "input"):
        stmt = {counter: Stmt(line[0], line[1:])}
        statementList.update(stmt)
    if(":" in line[0]):
        symTable.update({line[0].strip(":") : counter})
        stmt = {counter: Stmt(line[1], line[2:])}
        statementList.update(stmt)

def main():
    symTable = {}
    statementList = {}

    filePath = sys.argv[1]
    file = open('./' + filePath)
    counter = 0 
    for line in file:
        counter += 1
        initSplit = line.split()
        parseExpr(initSplit, statementList, symTable, counter)
    file.close()

    for key in statementList:
        toGo = statementList[key].perform(symTable, key)
    
main()