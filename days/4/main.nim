## bingo
## input is 
## numbers (comma separated)
## set of boards:
## 5lines x 5 space separated
import std/[sequtils,sugar,enumerate,parseutils,setutils]
from std/strutils import split
import zero_functional
type
    BingoGrid = array[25,range[0..99]]
    BingoSets = object
        grid: BingoGrid
        sets: array[10,set[range[0..99]]]
template items(b:BingoSets):set[range[0..99]] = b.sets.items
template `[]=`(b:BingoSets,i:range[0..9],val:set[range[0..99]]) = b.sets[i]=val

proc `[]`(b:BingoGrid,x,y:int):int = b[y*5+x]
proc `[]=`(b:var BingoGrid; x,y:int; val:int) = b[y*5+x] = val
proc `[]=`(b:var BingoGrid; y:int; vals:array[5,int]) =
    for x,v in vals:
        b[y*5+x] = v

iterator row(b:BingoGrid,y:range[0..4]): range[0..99] = 
    for x in 0..4:
        yield b[x,y]
iterator col(b:BingoGrid,x:range[0..4]): range[0..99] =
    for y in 0..4:
        yield b[x,y]
proc row(b:var BingoGrid,y:range[0..4]): var array[5,range[0..99]] = cast[var array[5,range[0..99]]](b[y*5].addr)

proc parseLine(line:string,res: var array[5,range[0..99]]) =
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

proc toBingoSets(b:BingoGrid):BingoSets =
    result.grid = b
    for y in 0..4:
        result[y]=(b.row(y).toSet)
    for x in 5..9:
        result[x]=(b.col(x-5).toSet)

    

#[proc game(input:(seq[int],seq[BingoGrid])):auto =
    for bingoball in input[0]:
        #naive first
        for grid in input[1]:
            for i in 0..24:
                if grid[i]==bingoball:
                    grid[i] = -grid[i] # 'mark' with a minus sign
]#
proc winsWith(grid:BingoSets,balls:set[range[0..99]]):bool =
    for s in grid:
        if s <= balls:
            return true
    return false               

proc game(input:(seq[int],seq[BingoSets])):auto =
    var balls:set[range[0..99]]
    for bingoball in input[0]:
        balls.incl bingoball
        var winners:seq[BingoSets] = @[]
        for grid in input[1]:
            if grid.winsWith balls:
                winners.add grid
        if winners.len > 0:
            return (balls,bingoball,winners)

proc q1(filename:string):int =
    let (bingoballs,grids) = filename.parseInput
    let sets = grids.map(toBingoSets)
    let (balls,lastball,winners) = game((bingoballs,sets))
    assert len(winners) == 1
    var winner = winners[0]
    #sum of all unmarked numbers. we didn't need the grid but hey
    for x in winner.sets.foldl(a+b) - balls:
        result += x
    result *= lastball

echo q1("test")
echo q1("input")
##is it true that there will always be a unique winner?

#surely this is super slow
#another way is
## for grid in input[1]
##   #go through bingoballs till we get a winner or run out of balls.
##   #worst case the first M-1 use up the whole deck, last one wins early
##   #= M*N
##
##   hey, no, we should be using sets for a start
## there's 100 grids and 100 numbers.
## is_a_winner(grid,numbers):  
##   row or col in grid that's a subset of numbers
## in other words for subset in bingogrid, subset <= numbers
## how do we say <= for two sets? for s in subset s in numbers. rubbish.
## aha! isn't it that 010010 <= 110010 because 010010 and 110010 == 010010
##                    010010 &  001101 
## < is in the stdlib, but we dont want strict subset.
## <= is also in stdlib 'A & ~B == 0'
                 