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
        elif self.operator == "+":
            return symTable[op1] + symTable[op2]
        elif self.operator == "-":
            return symTable[op1] - symTable[op2]
        elif self.operator == "*":
            return symTable[op1] * symTable[op2]
        elif self.operator == "/":
            return symTable[op1]/symTable[op2]
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


def main():
    statementList = [] 
    symTable = []

    filePath = sys.argv[1]
    file = open('./' + filePath)
    counter = 0 
    for line in file:
        counter += 1
        initSplit = line.split()
        if(initSplit[0] == "let" or initSplit[0] == "if" or initSplit[0] == "print" or initSplit[0] == "input"):
            stmt = Stmt(initSplit[0], initSplit[1:])
            statementList.append(stmt)
        if(":" in initSplit[0]):
            labelTuple = (initSplit[0].strip(":"), counter)
            symTable.append(labelTuple)
            stmt = Stmt(initSplit[1], initSplit[2:])
            statementList.append(stmt)
    file.close()

    for stmt in statementList:
        stmt.perform(symTable)
    
    print(symTable)


main()

# if tabs do not end up working later on 
# if initSplit[0][0] == "\t":
        #     initSplit = initSplit[0][0].strip("\t")