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
            return symTable[op1]
        elif self.operator == "const":
            return symTable[op1]
        elif self.operator == "=":
            currTuple = list(filter(lambda x:self.op1 in x, symTable)) 
            checkForVar2 = list(filter(lambda x:self.op2 in x, symTable)) 
            if(len(currTuple) == 0):
                try:
                    int(self.op2)
                    tupleToAdd = (self.op1, self.op2)
                    symTable.append(tupleToAdd)
                except:
                    try:
                        numToAdd = checkForVar2[0][1]
                        tupleToAdd = (self.op1, float(numToAdd))
                        symTable.append(tupleToAdd)
                    except:
                        sys.exit("Invalid Variable")
            else:
                try:
                    int(self.op2)
                    indexOfTuple = symTable.index(currTuple[0])
                    newTuple = (self.op1, self.op2)
                    symTable[indexOfTuple] = newTuple
                except:
                    try:
                        numToAdd = checkForVar2[0][1]
                        indexOfTuple = symTable.index(currTuple[0])
                        newTuple = (self.op1, numToAdd)
                        symTable[indexOfTuple] = newTuple
                    except:
                        sys.exit("Invalid Variable")
        elif self.operator == "+":
            currTuple = list(filter(lambda x:self.op1 in x, symTable)) 
            if(len(currTuple) == 0):
                sys.exit("Invalid variable")
            
            checkForVar2 = list(filter(lambda x:self.op2 in x, symTable)) 

            if len(checkForVar2) == 0:
                try:
                    int(self.op2)
                    numToAdd = currTuple[0][1]
                    result = float(self.op2) + float(numToAdd)
                    return result
                except:
                    sys.exit("Invalid variable")
            if len(checkForVar2) == 1:
                try:
                    int(self.op2)
                    numToAdd = currTuple[0][1]
                    result = float(self.op2) + float(numToAdd)
                    return result
                except:
                    numToAdd = currTuple[0][1]
                    num2 = checkForVar2[0][1]
                    result = float(num2) + float(numToAdd)
                    return result
        elif self.operator == "-":
            currTuple = list(filter(lambda x:self.op1 in x, symTable)) 
            indexOfTuple = symTable.index(currTuple[0])
            numToAdd = currTuple[0][1]
            result = float(numToAdd) - float(self.op1)
            return result
        elif self.operator == "*":
            Output = list(filter(lambda x:self.op1 in x, symTable)) 
            # indexOfOutput = symTable.index(Output[0])
            # numToMult = Output[0][1]
            # newTuple = (self.op1, float(self.op2) * float(numToMult))
            # symTable[indexOfOutput] = newTuple
        elif self.operator == "/":
            Output = list(filter(lambda x:self.op1 in x, symTable)) 
            # indexOfOutput = symTable.index(Output[0])
            # numToDivide = Output[0][1]
            # newTuple = (self.op1, float(self.op2)/float(numToDivide))
            # symTable[indexOfOutput] = newTuple
        elif self.operator == "<":
            return symTable[op1] < symTable[op2]
        elif self.operator == ">":
            return symTable[op1] > symTable[op2]
        elif self.operator == "<=":
            return symTable[op1] <= symTable[op2]
        elif self.operator == ">=":
            return symTable[op1] >= symTable[op2]
        elif self.operator == "==":
            return symTable[op1] == symTable[op2]
        elif self.operator == "!=":
            return symTable[op1] != symTable[op2]
        else:
            return "Undefined varible"

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
    def perform(self, symTable):
        print("Doing: " + str(self))
        # if self.keyword == "let" :
        # elif self.keyword == "print":
        # elif self.keyword == "if":
        if self.keyword == "input":
            userInput = int(input())
            valueToAdd = (self.exprs, userInput)
            symTable.append(valueToAdd)
        elif self.keyword == "print":
            stringToPrint = ""
            for item in self.exprs:
                stringToPrint += item.strip("\"") + " "
            print(stringToPrint)
        elif self.keyword == "let":
            if len(self.exprs) > 5:
                print("invalid expression")
            elif len(self.exprs) > 3:
                expressionToEval = Expr(self.exprs[2], self.exprs[3], self.exprs[4])
                result = expressionToEval.eval(symTable)
                del self.exprs[2:5]
                self.exprs.append(result)
                self.perform(symTable)
            else:
                expressionToEval = Expr(self.exprs[0], self.exprs[1], self.exprs[2])
                expressionToEval.eval(symTable)
               
  

def parseExpr(line, statementList, symTable, counter):
    if(line[0] == "let" or line[0] == "if" or line[0] == "print" or line[0] == "input"):
        stmt = Stmt(line[0], line[1:])
        statementList.append(stmt)
    if(":" in line[0]):
        labelTuple = (line[0].strip(":"), counter)
        symTable.append(labelTuple)
        stmt = Stmt(line[1], line[2:])
        statementList.append(stmt)

def main():
    statementList = [] 
    symTable = []

    filePath = sys.argv[1]
    file = open('./' + filePath)
    counter = 0 
    for line in file:
        counter += 1
        initSplit = line.split()
        parseExpr(initSplit, statementList, symTable, counter)
        
    file.close()

    for stmt in statementList:
        stmt.perform(symTable)
    print (symTable)

main()

# if tabs do not end up working later on 
# if initSplit[0][0] == "\t":
        #     initSplit = initSplit[0][0].strip("\t")