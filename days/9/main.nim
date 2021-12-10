import zero_functional
import std/[sugar,sequtils,strutils,strformat,algorithm,math]
import streams
var testinput = """2199943210
3987894921
9856789892
8767896789
9899965678"""
proc parseInput(input:Stream):seq[seq[int]] =
    input.lines --> map(it --> map(parseInt($it)))

let test = testinput.newStringStream.parseInput
let inp = "input".newFileStream.parseInput

for l in test:
    echo l
proc `[]`[T](s:seq[seq[T]],x,y:int):T = s[y][x]
proc `[]=`[T](s:var seq[seq[T]],x,y:int,val:T) = s[y][x] = val

proc comparisons(s:seq[seq[int]]):seq[seq[bool]] =
    let width = (if s.len == 0: 0 else: s[0].len)
    result = newSeqWith(s.len, newSeqWith(width,true) )
    for y,row in s:
        for x,height in row:
            for (dx,dy) in [(-1,0),(1,0),(0,1),(0,-1)]:
                if (x+dx in 0..<row.len) and (y+dy in 0..<s.len):
                    result[x,y] = result[x,y] and height < s[x+dx,y+dy]
for c in comparisons(test):
    echo (c --> map(if it: "*" else: "o")).join("")
#[
var testHeightmap = testinput.linescollect:
    for line in testinput:
        line.map(parseInt)
proc lowPoints(heightmap: seq[seq[int]])
]#
proc riskLevel(s:seq[seq[int]],x,y:int):int= s[x,y] + 1
iterator triplets[T,R](s:(seq[T],seq[R])):auto =
    var idx = 0
    while idx < s[0].len and idx < s[1].len:
        yield (idx,s[0][idx],s[1][idx])
        inc idx

let output = collect(for x,row in zip(inp,inp.comparisons):
    collect(for y,height,isLowest in row.triplets:
        if isLowest:
            height + 1
        else:
            0
    ).sum).sum
echo output
