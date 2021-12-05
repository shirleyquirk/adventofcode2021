## bingo
## input is 
## numbers (comma separated)
## set of boards:
## 5lines x 5 space separated
import std/[sequtils,sugar,enumerate,parseutils]
from std/strutils import split
import zero_functional
type
    BingoGrid = array[25,int]
proc `[]`(b:BingoGrid,x,y:int):int = b[y*5+x]
proc `[]=`(b:var BingoGrid; x,y:int; val:int) = b[y*5+x] = val
proc `[]=`(b:var BingoGrid; y:int; vals:array[5,int]) =
    for x,v in vals:
        b[y*5+x] = v
proc row(b:var BingoGrid,y:range[0..4]): var array[5,int] = cast[var array[5,int]](b[y*5].addr)

proc parseLine(line:string,res: var array[5,int]) =
    var idx=line.skipWhile({' '})
    for v in res.mitems:
        idx += line.parseInt(v,idx)
        idx += line.skipWhile({' '},idx)

proc parseInput(filename:string): (seq[int],seq[BingoGrid]) =
    ##input numbers
    var f = open(filename,fmRead)
    defer: f.close
    result[0] = f.readLine.split(',').map(strutils.parseInt)
    var y = 0
    var tmp:BingoGrid
    for line in f.lines:
        if line == "":
            continue
        parseLine(line,tmp.row(y))
        inc y
        if y == 5:
            y = 0
            result[1].add tmp



