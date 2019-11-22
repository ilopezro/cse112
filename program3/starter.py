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
    def eval(self, symTable):
        if self.operator == "var":
            return symTable[self.op1]
        else:
            return 0

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
        print ("Doing: " + str(self))
        if self.keyword == "input":
            try:
                userInput = float(input())
            except:
                sys.exit("Illegal or missing input")
            valueToAdd = {self.exprs[0]: float(userInput)}
            symTable.update(valueToAdd)
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
                            result = expressionToEval.eval(symTable)
                            stringToPrint += str(result) + " "
                        except:
                            sys.exit("Invalid call for variable at line " + str(lineNum))
            print(stringToPrint)
            

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

    # lineNum = 0 
    # for item in statementList:
    for key in statementList:
        statementList[key].perform(symTable, key)
    
main()