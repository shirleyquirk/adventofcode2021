import std/[sequtils,strutils,algorithm,math,sugar]

type LanternFish = array[9,int]
    
proc parseInput(filename:string):LanternFish = 
    for gestationTime in filename.open.readLine.split(',').map(parseInt):
        inc result[gestationTime]

proc afterNdays(fish:var LanternFish,n:int) =
    for _ in 1..n:
        fish.rotateLeft(1)
        fish[6] += fish[8]

let input = "input".parseInput

echo input.dup(afterNdays(80)).sum

echo input.dup(afterNdays(256)).sum